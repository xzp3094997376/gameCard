--
-- 鬼道
local m = {}
local tps = { TextMap.GetValue("Text106"), TextMap.GetValue("Text107"), TextMap.GetValue("Text108"), TextMap.GetValue("Text109") }
local types = { "po", "hui", "fu", "jie" }
local treasure_tps= {TextMap.GetValue("Text1655"),TextMap.GetValue("Text1656")}
local treasure_types = {"gong","fang"}

function m:update(lua)
    self.delegate = lua.delegate
    self.index = lua.index
	self.char = lua.char
    self.isPlayer = false
    if self.char.id == Player.Info.playercharid then
        self.isPlayer = true
    end
	m:updateChar(self.char)
    m:setPeiyangBtn()
end

function m:updateChar(char)
	self.char = char
	if self.char.id ==Player.Info.playercharid then 
        self.btnshizhuang.gameObject:SetActive(true)
    else 
        self.btnshizhuang.gameObject:SetActive(false)
    end 
    m:registerEvent()
    self:onUpdate(true)

    self.Label_huashen.gameObject:SetActive(false)
    if self.char.star >= 5 and 
	   self.char.lv >= 90 and 
	   self.char.star_level >= 8 and 
	   self.char.id ~= Player.Info.playercharid then
		self.Label_huashen.gameObject:SetActive(true)
        self.Label_huashen.text = self.char:getHuaShenLevel(self.char.id, self.char.dictid, self.char.quality)
    end
end

function m:onUpdate(ret)
    local char = self.char
	if char.id == Player.Info.playercharid then 
		self.btnChange.gameObject:SetActive(false)
	else 
		self.btnChange.gameObject:SetActive(true)
	end 
    if char.empty == true then
        self.binding:Hide("hero")
        self.binding:Show("empty")
        if self.delegate:isFull() then
            self.empty.text = TextMap.GetValue("Text1130")
        else
            self.empty.text = TextMap.GetValue("Text1137")
            --直接弹出选择角色面板
            -- local bind = UIMrg:pushWindow("Prefabs/moduleFabs/formationModule/formation/formation_select_char")
            -- bind:CallUpdate({ type = "single", module = "ghost", delegate = self.delegate })
        end
        self.txt_btn_name.text = TextMap.GetValue("Text1138")
        -- self.btn_check:SetActive(false)
        self.top:SetActive(false)
        -- self.hero_desc_bg:SetActive(false)
        m:updateGhost()
        --self.binding:Hide("dingwei")
        self.txt_name.text = ""
        return
    end
    -- self.btn_check:SetActive(false)
    self.top:SetActive(true)
    self.txt_btn_name.text = TextMap.GetValue("Text1139")
    self.binding:Hide("empty")
	self.img_type.spriteName = char:getDingWei()
	self.img_heti:SetActive(self.delegate:hasHeTi(Player.Team[0].chars, char))
    self.txt_name.text = Tool.getNameColor(char.star) .. char:getDisplayName() .. "[-]"
	self.currentHero:CallUpdate({char = char, delegate = self, isClick = true})
	--self.heromodel:LoadByModelId(char.modelid, "idle", function() end, false, -1, 1)
    --self.hero.Url = char:getImage()
    --self.hero:canDrag(true)
    --self.dingwei.spriteName = char:getDingWei()
    --self.binding:Show("dingwei")
    self.dw_text = char.Table.dingwei_desc
    m:updateTreasure()
    m:updateGhost()
	m:updatePet()
    m:updateYuling()
	
	if self.char.lv < 50 then 
		self.stars.gameObject:SetActive(false)
	else 
		self.stars.gameObject:SetActive(true)
		local star = math.floor ( self.char.stage / 10 )
		local starLists = {}
		local showStar = false
		for i = 1, 6 do
			showStar = false
			if i <= star then 
				showStar = true
			end
			starLists[i] = { isShow = showStar }
		end
		self.stars:refresh("", starLists, self)
	end
end

--定位描述显示
function m:onTooltip(name)
    --if name == "dingwei" then
    --    return self.dw_text
    --end
end

function m:onFilterPet(pet)
	if m:petIsOnTeam(pet.id) == true then return false end 
	return true
end 

function m:petIsOnTeam(petId)
	if Player.Team[0].pet ~= nil and Player.Team[0].pet == petId then  
		return true
	end 
	local ghostSlot = Player.ghostSlot
	for i = 0, 5 do 
		local slot = ghostSlot[i]
		local petid = slot.petid
		if petid ~= nil and petid ~= 0 then 
			local dict = Tool.getPetDictId(petid)
			local dictTarget = Tool.getPetDictId(petId)
			if dict == dictTarget then 
				return true
			end 
		end
	end 
	
	return false
end 

--检查该羁绊是否已经激活
function m:checkFetter(fetterId, list)
    if fetterId == nil or list == nil then
        print("fetterId or list is nil ")
        return nil
    end

    for i = 1, #list do
        if list[i] == fetterId then
            return true
        end
    end
    return false
end

function m:updateInfos()
    local char = self.char
    if char == nil or char.empty then return end

    local list = self.delegate:getFetter(char.id) -- 获取该角色已经激活的羁绊列表
    self.cout = 0
    table.foreach(list, function(i, v)
        local line = TableReader:TableRowByID("relationship", v)
        if line == nil then
            line = TableReader:TableRowByUnique("relationship", v)
        end

        local fetterName = line.show_name
        if i <= 6 then
            self.cout = i
            self["txt_fetter" .. i].text = "[ff0000]" .. fetterName .. "[-]"
        end
    end)

    if self.cout < 6 then --当前激活的羁绊数不足六个
    -- local listall = {}
    local line = TableReader:TableRowByID("avter", char.dictid)
    if line ~= nil then
        if line.relationship == nil then
            print("line.relationship is nil ")
        end

        for i = 0, 7 do
            if line.relationship[i] ~= nil and line.relationship[i].."" ~= "" then
                if self.cout < 6 then
                    if m:checkFetter(line.relationship[i], list) == false then
                        local tb = TableReader:TableRowByID("relationship", line.relationship[i])
                        local fetterName = tb.show_name
						--if self.cout + 1 == 1 or self.cout + 1 == 3 or self.cout + 1 == 5 then 
							self["txt_fetter" .. self.cout + 1].text = "[9a4c1e]" .. fetterName .. "[-]"
						--else 
						--	self["txt_fetter" .. self.cout + 1].text = "[ff0000]" .. fetterName .. "[-]"
						--end 
                        self.cout = self.cout + 1
                    end
                end
            end
        end

        if self.cout < 6 then
            for i = self.cout + 1, 6 do
                self["txt_fetter" .. i].text = ""
            end
        end
    end
    end

    local attr1 =string.gsub(TextMap.GetValue("LocalKey_748"),"{0}",char.lv) -- 等级
    local attr2 = char:getAttrSingleForGhost("MaxHp") -- 最大生命--MaxHp
    local attr3 = char:getAttrSingleForGhost("PhyAtk") -- 物理攻击--PhyAtk
    local attr4 = char:getAttrSingleForGhost("PhyDef") -- 物理防御--PhyDef
    --local attr5 = char:getAttrSingleForGhost("MagAtk", self.tre_MAP4 or 0) -- 灵术攻击
    local attr6 = char:getAttrSingleForGhost("MagDef") -- 灵术防御--MagDef


    self.txt_attr1.text = attr1
    self.txt_attr2.text = attr2
    self.txt_attr3.text = attr3
    self.txt_attr4.text = attr4
    --self.txt_attr5.text = attr5
    self.txt_attr6.text = attr6
end

function m:updateGhost()
    local index = self.index
    local ghostSlot = Player.ghostSlot
    -- local ghostSlot = self:getGuiDaoList()
    local ghost = Player.Ghost
    local slot = ghostSlot[index]
    local postion = slot.postion
    local list = {}
    local len = postion.Count
    local equipPos = {}
    self.ghostArg = {}
    self.gostAttrName = {}
    for i = 1, 4 do
        if i > len then
            list[i] = { empty = true, name = tps[i], kind = types[i], charIndex = self.index, equipIndex = i - 1, char = self.char }
            equipPos[i] = false
            self.ghostArg[i] = 0
        else
            local key = postion[i - 1]
            if key ~= "" and key ~= nil and key ~= 0 and key ~= "0" then
                local g = ghost[key].id
                if g == 0 then
                    equipPos[i] = false
                    self.ghostArg[i] = 0
                    list[i] = { empty = true, delegate = self, name = tps[i], kind = types[i], charIndex = self.index, equipIndex = i - 1, char = self.char }
                else
                    local gh = Ghost:new(g, key)
                    gh.hasWear = 1
                    gh.equipIndex = i - 1
                    gh.charIndex = index
                    gh.char = self.char
					gh.delegate = self
                    list[i] = gh
                    equipPos[i] = true
                    self.ghostArg[i] = gh:getMainArg()
                    self.gostAttrName[i] = gh:getMainAttrName()
                end

            else
                equipPos[i] = false
                list[i] = { empty = true, delegate = self, name = tps[i], kind = types[i], charIndex = self.index, equipIndex = i - 1, char = self.char }
                self.ghostArg[i] = 0
            end
        end
    end
    self.equipPos = equipPos
    --    self.itemList = ClientTool.UpdateGrid("", self.equips, list, self)
    for i = 1, #list do
        self["cell" .. (i - 1)]:CallUpdate(list[i])
    end
    m:updateInfos()
end

function m:CalculateTreasureProperty(magic,level)
    local num = magic.arg + magic.arg2 * level
    local data = {}
    data.name =  magic.name
    --print("....属性名字...."..magic.name)
    data.value = num / magic.denominator
    --print("....属性大小...."..num / magic.denominator)
    table.insert(self.treasureArg,data)
end

function m:CalculateTreasureProperty_JL(magic)
	if magic == nil then return end 
    local num = magic.arg
    local data = {}
    data.name =  magic.name
    --print("....属性名字...."..magic.name)
    data.value = num / magic.denominator
    --print("....属性大小...."..num / magic.denominator)
    table.insert(self.treasureArg,data)
end

function m:CalculateImmortalityProperty(treasure)
    --print("........Start........."..treasure.id)
    if treasure.star == 6 then
        TableReader:ForEachLuaTable("treasurePowerUp",function(k,v) 
            if v.name == treasure.id then
                if v.extra_num and v.extra_num > 0 and treasure.power >= v.power then
                    local magic = v.magic
                    if magic ~= nil then                        
                        for i=2,magic.Count - 1 do
                            --print("........one.........")
                            local m = magic[i]
                            local row = m._magic_effect
                            local obj = {
                                format = row.format,
                                denominator = row.denominator,
                                arg = m.magic_arg1,
                                name = row.name,
                                des = v.skill_desc
                            }
                            local data = {}
                            data.name =  row.name
                            data.value = m.magic_arg1 / row.denominator
                            table.insert(self.treasureArg,data)
                            --print(v.name.."????"..data.name)
                        end
                    end
                end
            end
            return false
        end)
    end
end

function m:onCallBack(char, tp)
    if tp == "pet" or tp == "pet_huyou" then 
		Api:petHuyou(char.id, self.index, function(result)
			m:onUpdate()
			if self.delegate then 
				self.delegate:onUpdate()
			end 
			end, function()
			return false
		end)
    elseif tp=="yuling" then 
        Api:yulingHuyou(char.id, self.index, function(result)
            m:onUpdate()
            if self.delegate then 
                self.delegate:onUpdate()
            end 
            end, function()
            return false
        end)
    end
end

function m:YulingXiexia()
    Api:yulingHuyouUnload(self.index, function(result)
        m:onUpdate()
        if self.delegate then 
            self.delegate:onUpdate()
        end 
        end, function()
        return false
    end)
end

function m:onFilter(pet)
	if m:checkHuyou(pet.id) then return false end 
	return true
end 


function m:checkHuyou(petId)
	local ghostSlot = Player.ghostSlot
	for i = 0, 5 do 
		local slot = ghostSlot[i]
		local petid = slot.petid
		if petId == petid then 
			return true
		end 
	end 
	return false
end 

function m:updatePet()
    local index = self.index
    local ghostSlot = Player.ghostSlot
    local slot = ghostSlot[index]
    local petid = slot.petid
	local len = 0
	if petid ~= nil and petid ~= "0" and petid ~= 0 then 
		len = 1
	else 
		len = 0
	end 
    local data = {}
    self.ghostArg = {}
    self.gostAttrName = {}
    if len == 0 then
        data = { empty = true, name = TextMap.GetValue("Text_1_918"), kind = "pet", charIndex = self.index, char = self.char, delegate = self }
    else
        if petid ~= "" and petid ~= nil and petid ~= 0 and petid ~= "0" then
            local pet = Pet:new(petid)
            pet.hasWear = 1
            pet.charIndex = index
            pet.char = self.char
			pet.kind = "pet"
			pet.delegate = self
            data = pet
        else
            data = { empty = true, name = TextMap.GetValue("Text_1_918"), kind = "pet", charIndex = self.index, char = self.char, delegate = self }
        end
    end
    self.pet_1:CallUpdate(data)
    m:updateInfos()
end 

function m:updateYuling()
    local index = self.index
    local ghostSlot = Player.ghostSlot
    local slot = ghostSlot[index]
    local yulingid = slot.yulingid
    local len = 0
    if yulingid ~= nil and yulingid ~= "0" and yulingid ~= 0 then 
        len = 1
    else 
        len = 0
    end 
    local data = {}
    self.ghostArg = {}
    self.gostAttrName = {}
    if len == 0 then
        data = { empty = true, name = TextMap.GetValue("Text_1_2993"), kind = "yuling", charIndex = self.index, char = self.char, delegate = self }
    else
        if yulingid ~= "" and yulingid ~= nil and yulingid ~= 0 and yulingid ~= "0" then
            local yuling = Yuling:new(yulingid)
            yuling.hasWear = 1
            yuling.charIndex = index
            yuling.char = self.char
            yuling.kind = "yuling"
            yuling.delegate = self
            data = yuling
        else
            data = { empty = true, name = TextMap.GetValue("Text_1_2993"), kind = "yuling", charIndex = self.index, char = self.char, delegate = self }
        end
    end
    self.cell8:CallUpdate(data)
end

function m:updateTreasure()
    local char_id = self.char.id
    local treasure = Player.Treasure
    local treasureSlot = Player.Chars[char_id].treasure --self.char.treasure
    local list = {}
    local treasure_equipPos = {}
    self.treasureArg = {}


    for i=1,2 do
        if i > treasureSlot.Count then
            list[i] = { empty = true, name = treasure_tps[i], kind = treasure_types[i], charIndex = self.index, equipIndex = i - 1, char = self.char ,subtype = "treasure"}
            treasure_equipPos[i] = false
            --self.treasureArg[i] = {name = "",value = 0}
        else
            local key = treasureSlot[i-1]
            if key ~= "" and key ~= nil and key ~= 0 and key ~= "0" then
                if treasure[key] ~= nil then
                    local ts = Treasure:new(treasure[key].id, key)
                    ts.hasWear = 1
                    ts.equipIndex = i - 1
                    ts.charIndex = index
                    ts.char = self.char
                    ts.subtype = "treasure"
                    list[i] = ts
                    treasure_equipPos[i] = true
                    for _s=1,2 do
                    self:CalculateTreasureProperty(ts:getMagic()[_s],ts.lv)
                    self:CalculateTreasureProperty_JL(ts:getMagic_JL(0)[_s])                   
                    end
                    self:CalculateImmortalityProperty(ts)
                end
            else
                treasure_equipPos[i] = false
                list[i] = { empty = true, name = treasure_tps[i], kind = treasure_types[i], charIndex = self.index, equipIndex = i - 1, char = self.char ,subtype = "treasure"}
                --self.treasureArg[i] = {name = "",value = 0}
            end
        end
    end

    self.treasure_equipPos = treasure_equipPos
    for i = 1, #list do
        self["treasure_" .. (i - 1)]:CallUpdate(list[i])
    end
end


function m:getBestGhostByType(pos, list)
    if #list == 0 then return "" end
    table.sort(list, function(a, b)
        if a.star ~= b.star then return a.star > b.star end
        if a.power ~= b.power then return a.power > b.power end
        if a.lv ~= b.lv then return a.lv > b.lv end
        return false
    end)
    if list[1] then return pos .. ":" .. list[1].key end
    return ""
end

--一键装备
function m:onWear(go)
    local index = 0
    for i = 1, #self.equipPos do
        if self.equipPos[i] == true then index = index + 1 end
    end
    if index == #self.equipPos then
        return
    end
    local list = Tool.getUnUseGhost()
    local po = {}
    local hui = {}
    local fu = {}
    local jie = {}
    table.foreach(list, function(i, v)
        if v.kind == "po" then table.insert(po, v) end
        if v.kind == "hui" then table.insert(hui, v) end
        if v.kind == "fu" then table.insert(fu, v) end
        if v.kind == "jie" then table.insert(jie, v) end
    end)

    local str = ""
    local tb = {}
    if self.equipPos[1] == false then
        local s = m:getBestGhostByType(0, po)
        table.insert(tb, s)
    end

    if self.equipPos[2] == false then
        local s = m:getBestGhostByType(1, hui)
        table.insert(tb, s)
    end

    if self.equipPos[3] == false then
        local s = m:getBestGhostByType(2, fu)
        table.insert(tb, s)
    end

    if self.equipPos[4] == false then
        local s = m:getBestGhostByType(3, jie)
        table.insert(tb, s)
    end
    local len = #tb
    for i = 1, len do
        if tb[i] ~= "" then
            str = str .. tb[i]
            if i ~= len then
                str = str .. "|"
            end
        end
    end
    if str == "" then
        MessageMrg.show(TextMap.GetValue("Text1140"))
        return
    end
    Api:gd_equipOn_ones(self.index, str, function(result)
        MusicManager.playByID(50)
        m:updateGhost()
        Tool.resetUnUseGhost()
        Events.Brocast('updateChar')
    end)
end

-- --培养英雄
-- function m:onHero(go)
--     uSuperLink.open("hero", { 1, self.char }, 0, 2)
-- end
--点击强化大师按钮
function m:clickMaster()
    local isAllequip = self.equipPos[1] == true and self.equipPos[2] == true and self.equipPos[3] == true and self.equipPos[4] == true
    local isAlltreasure = self.treasure_equipPos[1] ==true and self.treasure_equipPos[2] ==true
    if isAllequip or isAlltreasure then 
        UIMrg:pushWindow("Prefabs/moduleFabs/formationModule/formation/enhanced_master", {delegate=self,char=self.char,index =self .index,isAllequip=isAllequip,isAlltreasure=isAlltreasure})
    else 
        MessageMrg.show(TextMap.GetValue("Text_1_1052"))
    end 
end

function m:onClick(go, name)
    if name == "btn_wear" then
        m:onWear(go)
	elseif name == "btnDetail" then 
		m:clickDetailBtn()
    elseif name == "btnQianghuaDashi" then 
        m:clickMaster()
    elseif name=="btnshizhuang" then
        local linkData = Tool.readSuperLinkById(119)
        local limitLv = linkData.unlock[0].arg
        if Player.Info.level >= limitLv then 
            uSuperLink.openModule(119)
        else
            MessageMrg.show(TextMap.getText("TXT_XS_UNLOCK_DESC", {limitLv}))
            return
        end 
    elseif name == "btnChange" then
        --下一阵位解锁
        if self.char.empty == true and self.delegate:isFull() then
            local max_slot = self.delegate.max_slot + 1
            if max_slot > 6 then return end
            local lv = TableReader:TableRowByID("playerArgs", "slot" .. max_slot).value
            MessageMrg.show(string.gsub(TextMap.GetValue("Text111"),"{0}",lv))
            return
        end
        local bind = UIMrg:pushWindow("Prefabs/moduleFabs/formationModule/formation/formation_select_char")
        local index = self.delegate:findFormationIndex(self.char)
        bind:CallUpdate({ type = "single", module = "ghost", delegate = self.delegate, index = index })
	elseif name == "bg" then 
		if self.char:getType() == "char" then 
			UIMrg:pushWindow("Prefabs/moduleFabs/formationModule/formation/hero_property", { char = self.char, delegate = self.delegate})
		end 
	elseif name == "bg_r" then 
		if self.char == nil then return end 
		Tool.push("heroInfo", "Prefabs/moduleFabs/hero/hero_info", self.char)
    elseif name == "btnpeiyang" then
        m:gotoPeiYang()
    end
end

function m:setPeiyangBtn()
    local char = self.char
    self.btnpeiyang.gameObject:SetActive(false)
    if (char:redPointForStrong() and m:checkLock(227, true)) and self.isPlayer == false or 
       (char:redPointForJinHua() and m:checkLock(228, false)) or
       (char:redPointForCultivate() and m:checkLock(230, false)) or 
       (char:redPointForXueMai() and m:checkLock(72, false)) or
       (char:redPointForEquip() and m:checkLock(229, false)) or 
       (char:redPointForHuaShen(char) and m:checkLock(75, false)) and self.isPlayer == false then
        self.btnpeiyang.gameObject:SetActive(true)
    end
end

function m:gotoPeiYang()
    local char = self.char
    local redPointList = {}
    if char:redPointForStrong() and m:checkLock(227, true) and self.isPlayer == false then
        UIMrg:push("new_hero", "Prefabs/moduleFabs/hero/newHero", { char = self.char, tp = 1 })--升级

    elseif char:redPointForJinHua() and m:checkLock(228, false) then
        UIMrg:push("new_hero", "Prefabs/moduleFabs/hero/newHero", { char = self.char, tp = 3 })--进化

    elseif char:redPointForCultivate() and m:checkLock(230, false) then
        UIMrg:push("new_hero", "Prefabs/moduleFabs/hero/newHero", { char = self.char, tp = 5 })--培养

    elseif char:redPointForXueMai() and m:checkLock(72, false) then
        UIMrg:push("new_hero", "Prefabs/moduleFabs/hero/newHero", { char = self.char, tp = 4 })--血脉

    elseif char:redPointForEquip() and m:checkLock(229, false) then
        UIMrg:push("new_hero", "Prefabs/moduleFabs/hero/newHero", { char = self.char, tp = 2 })--觉醒

    elseif char:redPointForHuaShen(char) and m:checkLock(75, false) and self.isPlayer == false  then
        UIMrg:push("new_hero", "Prefabs/moduleFabs/hero/newHero", { char = self.char, tp = 6 })--化神
    end
end

function m:checkLock(id, isCharLevel)
    local linkData = Tool.readSuperLinkById(id)
    local unlockType = linkData.unlock[0].type --解锁条件
    local jinhuaLV = 0
    local linkData2 = TableReader:TableRowByID("charArgs", "min_qualitylevel")
    if linkData2 ~= nil then
        jinhuaLV = linkData2.value2
    end
    if unlockType ~= nil then
        local level = linkData.unlock[0].arg
        if isCharLevel then 
            if id == 75 then
                if self.char.lv < level or self.char.star_level < jinhuaLV then
                    return false
                end
            else
                if self.char.lv < level or Player.Info.vip < linkData.vipLevel then
                return false
                end
            end
        else
            if Player.Info.level < level or Player.Info.vip < linkData.vipLevel then
                return false
            end
        end
    end
    return true
end

function m:showEquipOnEffect(go)
    if go == nil then return end
    ClientTool.AlignToObject(self.UI_guodaojiemian_whitelight, go.gameObject, 3)
    self.UI_guodaojiemian_whitelight:SetActive(false)
    self.UI_guodaojiemian_whitelight:SetActive(true)
    self.binding:CallAfterTime(1, function()
        self.UI_guodaojiemian_whitelight:SetActive(false)
    end)
end

local indexs = { po = 0, hui = 1, fu = 2, jie = 3 ,gong = 4, fang = 5}
--装备鬼道
function m:selectedGhost(ghost)
	print("ghost name : " .. ghost.name)
    --装备鬼道
    local data = ghost
    local index = indexs[data.kind]
    local delegate = self.delegate
    Api:gd_equipOn(data.key, self.index, index, function(result)
        MusicManager.playByID(50)
        Tool.resetUnUseGhost()
		--Events.Brocast('updateChar')
        data.hasWear = 1
        --Events.Brocast('updateLeft', data, true)
        m:updateGhost()
        UIMrg:popWindow()
        delegate:checkRedPoint()
        m:showEquipOnEffect(self.itemList[index + 1])
		--if ghost then return end 
    end, function(ret)
        return false
    end)
end

function m:selectedTreasure(treasure)
    local data = treasure
    local index = indexs[data.kind]
    local delegate = self.delegate
    MusicManager.playByID(50)
    Events.Brocast('updateChar')
    self:updateTreasure()
    self:updateInfos()
    print("...................回调结束..................")
    m:showEquipOnEffect(self.itemList[index + 1])
    self.delegate:onCallBack(self.char,"treasure")
end

function m:OnDestroy()
    Events.RemoveListener('selectedGhost')
    Events.RemoveListener('selectedTreasure')
end

function m:exit()
    self.UI_guodaojiemian_whitelight:SetActive(false)
end

function m:registerEvent()
    Events.RemoveListener('selectedGhost')
    Events.RemoveListener('selectedTreasure')
    Events.AddListener("selectedGhost", funcs.handler(self, m.selectedGhost))
    Events.AddListener("selectedTreasure", funcs.handler(self, m.selectedTreasure))
end


function m:clickDetailBtn()
    local index = self.index
    local ghostSlot = Player.ghostSlot
    local ghost = Player.Ghost
    local slot = ghostSlot[index]
    local postion = slot.postion
    local len = postion.Count
    local refineMaster=self.char.RefineMaster[0]
    if len ==0 then 
        MessageMrg.show(TextMap.GetValue("Text_1_1053"))
        return
    end
    local isRet=true
    local canUp=true
    for i = 1, len do
        local key = postion[i - 1]
        if key ~= "" and key ~= nil and key ~= 0 and key ~= "0" then
            local g = ghost[key].id
            if g ~= 0 then
                local gh = Ghost:new(g, key)
                local ghostLevelUpCost = TableReader:TableRowByUnique("ghostLevelUpCost", "level", gh.lv + 1)
                local ret=true 
                if ghostLevelUpCost ~=nil then 
                    local money = ghostLevelUpCost[gh.kind .. gh.star]
                    ret = money < Player.Resource.money
                end
                if ret ==false and isRet==true then
                    isRet=ret
                end 
                if ret == true then
                    ret = gh:curMaxLv()
                    if isRet==true and ret==false and canUp==true then 
                        canUp=ret
                    end 
                end
                if ret==true then 
                    print (TextMap.GetValue("Text_1_1054"))
                    isRet=true
                    canUp=true
                     Api:ghostOneKeyUp(index,function(result)
                        print (TextMap.GetValue("Text_1_1055"))
                        m:updateGhost()
                        if self.delegate then 
                            self.delegate:onUpdate()
                        end 
                        local data = result.returnData
                        local descList={}
                        for j=0,data.Count-1 do 
                            local key=postion[data[j].position]
                            local levelUpComsume=data[j].levelUpComsume
                            local upTimes=data[j].upTimes
                            local luckTimes=data[j].luckTimes
                            local upLevel = data[j].upLevel
                            local g = ghost[key].id
                            local gh = Ghost:new(g, key)
                            gh:updateInfo()
                            local magic = gh:getMagic()[1]
                            local num = magic.arg2
                            txt=string.gsub(TextMap.GetValue("LocalKey_817"),"{0}",levelUpComsume)
                            txt=string.gsub(txt,"{1}",gh:getDisplayColorName())
                            if upTimes>0 then 
                                txt=txt .. string.gsub(TextMap.GetValue("LocalKey_818"),"{0}",upTimes)
                            end   
                            if luckTimes>0 then 
                                txt=txt .. string.gsub(TextMap.GetValue("LocalKey_819"),"{0}",luckTimes)
                            end
                            if upLevel>0 then 
                                txt=txt .. string.gsub(TextMap.GetValue("LocalKey_820"),"{0}",upLevel)
                                txt=txt .. string.gsub(magic.format, "{0}","+" .. num * upLevel)
                            end
                        end 
                        local refineMaster_cur=result.RefineMaster
                        local upLevel_refineMaster=0
                        if refineMaster_cur~=nil and refineMaster~=nil and refineMaster<1 and refineMaster_cur>=1 then 
                            if refineMaster_cur>20 then refineMaster_cur=20 end 
                            upLevel_refineMaster=refineMaster_cur 
                            local curRow = TableReader:TableRowByID("master_ghost_lvUp",refineMaster_cur)
                            if curRow==nil then 
                                curRow=TableReader:TableRowByID("master_ghost_lvUp",20)
                            end 
                            local curMagic=curRow.magic
                            local des=string.gsub(TextMap.GetValue("LocalKey_821"),"{0}",refineMaster_cur)
                            if curMagic~=nil then 
                                for i=1 ,curMagic.Count do 
                                    if curMagic[i-1].magic_arg1~=0 and curMagic[i-1].magic_arg1~=nil then 
                                        local text = curMagic[i-1]._magic_effect.format
                                        if curMagic[i-1].magic_arg1>0 then 
                                            des=des .. "\n" .. string.gsub(text,"{0}","+" .. curMagic[i-1].magic_arg1)
                                        end
                                    end 
                                end
                            end 
                            table.insert(descList,des)
                        elseif refineMaster_cur~=nil and refineMaster~=nil and refineMaster>=1 and refineMaster_cur>refineMaster then  
                            if refineMaster_cur>20 then refineMaster_cur=20 end 
                            upLevel_refineMaster=refineMaster_cur-refineMaster
                            local curRow = TableReader:TableRowByID("master_ghost_lvUp",refineMaster_cur)
                            if curRow==nil then 
                                curRow=TableReader:TableRowByID("master_ghost_lvUp",20)
                            end 
                            local oldRow = TableReader:TableRowByID("master_ghost_lvUp",refineMaster)
                            local curMagic=curRow.magic
                            local oldMagic = oldRow.magic
                            local des=string.gsub(TextMap.GetValue("LocalKey_821"),"{0}",refineMaster_cur)
                            if curMagic~=nil and oldMagic~=nil then 
                                for i=1 ,curMagic.Count do 
                                    if curMagic[i-1].magic_arg1~=0 and curMagic[i-1].magic_arg1~=nil then 
                                        local text = curMagic[i-1]._magic_effect.format
                                        if oldMagic[i-1]==nil then 
                                            if curMagic[i-1].magic_arg1>0 then 
                                                des=des .. "\n" .. string.gsub(text,"{0}","+" .. curMagic[i-1].magic_arg1)
                                            end
                                        else 
                                            if curMagic[i-1].magic_arg1-oldMagic[i-1].magic_arg1>0 then 
                                                des=des .. "\n" .. string.gsub(text,"{0}","+" .. curMagic[i-1].magic_arg1-oldMagic[i-1].magic_arg1)
                                            end
                                        end 
                                    end 
                                end
                            end 
                        end
                        OperateAlert.getInstance:showToGameObject(descList, self.currentHero.gameObject)
                    end)
                    return 
                end
            end
        end
    end
    if canUp==false then 
        MessageMrg.show(TextMap.GetValue("Text_1_1064"))
    else
        if isRet==false then 
            MessageMrg.show(TextMap.GetValue("Text_1_1065"))
        end  
    end
end

function m:showInfo()
    if self.char == nil then return end
    Tool.push("heroInfo", "Prefabs/moduleFabs/hero/hero_info", self.char)
end

function m:Start()
    self.UI_guodaojiemian_whitelight:SetActive(false)
    self.itemList = {}
    for i = 0, 3 do
        table.insert(self.itemList, self["cell" .. i])
    end
    for i = 4,5 do
        table.insert(self.itemList,self["treasure_" .. i-4])
    end

    Events.AddListener("selectedGhost", funcs.handler(self, m.selectedGhost))
    --ClientTool.AddClick(self.hero_btn, funcs.handler(self, self.showInfo))
	
	--滑动
	self.dir = -1
	self.offsetX = 300
	self.isDrag = false
	self.currentHero = self.hero
	self.assistHero = self.hero2
	self.original = self.currentHero.gameObject.transform.localPosition
	self:resetHero()
end

-- 滑动系列函数
-- 重置位置
function m:resetHero()
	-- 排序
	self.currentHero.gameObject.transform.localPosition = self.original
	self.assistHero.gameObject.transform.localPosition = Vector3(
		self.currentHero.gameObject.transform.localPosition.x + self.offsetX,
		self.currentHero.gameObject.transform.localPosition.y, 0)
	-- TODO dxj 阵容的左右取值不一样， 先屏蔽
	self.currentHero.gameObject:GetComponent(BoxCollider).enabled = true
	self.assistHero.gameObject:GetComponent(BoxCollider).enabled = false
	self.dir = -1
	self.isDrag = false
end

function m:updateAssistPos(dir)
	local offset = -self.offsetX
	if dir == 1 then 
		offset = self.offsetX 
	end 
	self.assistHero.gameObject.transform.localPosition = Vector3(
	self.currentHero.gameObject.transform.localPosition.x + offset,
	self.currentHero.gameObject.transform.localPosition.y, 0)
end

function m:updateAssistData(dir)
	local char = self:getTeamCharById(self.char.id, dir)
	if char ~= nil then 
		self.assistHero:CallUpdate({char = char, delegate = self, isClick = true})
		self.assistHero.gameObject:SetActive(true)
		self.canReplace = true
		self.assistChar = char
		local realIndex = self.index + 1
		if dir == 1 then 
			self.assistId = realIndex - 1
		else
			self.assistId = realIndex + 1
		end 
	else
		self.canReplace = false
		self.assistHero.gameObject:SetActive(false)
	end
end

function m:backOriginal()
	local tween = self.currentHero.gameObject:GetComponent(TweenPosition)
	if tween ~= nil then 
		tween.from = self.currentHero.gameObject.transform.localPosition
		tween.to = self.original
		tween.duration = 0.1
		tween.enabled = true
		tween:ResetToBeginning()
		self.binding:CallAfterTime(tween.duration, function()
			if self.isReplace == true then 
				if self.assistId ~= nil and self.assistChar ~= nil then 
					if self.assistId - 1 ~= self.index then 
						self.index = self.assistId - 1
						self.delegate:selectIcon(self.assistId)
					end
					--self.delegate:selectIcon(self.assistId)
				end 
			end 
			self:resetHero()
		end)
	end 

end

function m:getTeamCharById(id, dir)
    local teams = self.delegate.guidaoTeam --Player.Team[0].chars
	local count = 0
    for i = 1, #teams do
        if #teams >= i then
            if teams[i] ~= 0 and teams[i] ~= "0" and teams[i] == id then --可以添加一个从服务器端传过来的死亡状态，如果死亡则不上阵
				-- 找到，使用方向找到身边的
				local char = nil 
				if dir == 1 then 
					if (i - 1) > 0 and (i - 1) <= #teams and teams[(i-1)] ~= 0 and teams[(i-1)] ~= "0" then 
						char = Char:new(teams[(i-1)])
						return char, i-1
					end 
				elseif dir == 2 then 
					if (i + 1) > 0 and (i + 1) <= #teams and teams[(i+1)] ~= 0 and teams[(i+1)] ~= "0" then 
						char = Char:new(teams[(i+1)])
						return char, i+1
					end 
				end 
            end
        end
    end
	return nil
end

function m:showAssist(dir)
	-- 向右
	self:updateAssistPos(dir)
	self:updateAssistData(dir)
end

-- 手指松开隐藏
function m:onCallbackPress(ret)
	if ret == false then
		-- 切换当前卡片
		self:replaceCurrent()
		-- 缓动回到原位
		self:backOriginal()
		if self.assistHero ~= nil then 
			self.assistHero.gameObject:SetActive(false)
		end 
	else
	
	end 
end 

function m:replaceCurrent()
	if self.canReplace and self.canReplace == true then
		self.isReplace = false
		local now = self.currentHero.gameObject.transform.localPosition.x
		local last = self.original.x
		local dis = math.abs(now - last)
		if dis > self.offsetX / 2 then 
			if self.assistChar ~= nil then 
				local temp = self.currentHero
				self.currentHero = self.assistHero
				self.assistHero = temp
				self.isReplace = true
			end
		end 
	end
end

function m:onDragStart()
	if self.isDrag ~= true then 
		if self.dir ~= -1 then 
			self.isDrag = true
			self:showAssist(self.dir)
		end
	end 
end 

-- 获取方向
function m:onCallBackDir(dir)
	if self.isDrag == true then return end 
	if dir ~= -1 then 
		self.dir = dir
	end
end
-- 1 向左， 2向右

function m:herosMove(delta)
	if delta.x > 0.5 then
		if self.isDrag == false then 
			self:onDragStart()
			self:onCallBackDir(2)
		end
	elseif(delta.x < -0.5) then
		if self.isDrag == false then 
			self:onDragStart()
			self:onCallBackDir(1)
		end
	end
	local value = math.abs(delta.x)
	if value > 0.5 then 
		self:move(delta)
	end
end

function m:move(delta)
	-- 移动
	self.currentHero.gameObject.transform.localPosition = Vector3(
		self.currentHero.gameObject.transform.localPosition.x + delta.x,
		self.currentHero.gameObject.transform.localPosition.y,0)
	self.assistHero.gameObject.transform.localPosition = Vector3(
		self.assistHero.gameObject.transform.localPosition.x + delta.x,
		self.currentHero.gameObject.transform.localPosition.y,0)
end

return m

