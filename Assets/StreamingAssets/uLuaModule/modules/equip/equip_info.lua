
local equip_info = {}

local ghostTypeToNumber = {
    po = 1,
    hui = 2,
    fu = 3,
    jie = 4
}


function equip_info:onTooltip(name)

end

function equip_info:update(data)
	-- type = 1, 去掉向左向右按钮
	-- type = 2, 布阵过来的
	self.type = data.type
	self.ghost = Ghost:new(data.ghost.id, data.ghost.key)
	self:onUpdate()
end

function equip_info:onEnter()
	self:onUpdate()
end 

function equip_info:onUpdate()
    equip_info:setHero(self.ghost)
	self:updateDes()
	self:updateProgress()
	self:updateSuit()

    if Player.Info.level < self.shengxingOpenLevel then
        self.btn_shengxing.isEnabled = false
        self.Label_sx_gray.gameObject:SetActive(true)
        self.Label_sx.gameObject:SetActive(false)
    else
        self.btn_shengxing.isEnabled = true
        self.Label_sx_gray.gameObject:SetActive(false)
        self.Label_sx.gameObject:SetActive(true)
    end
end 

function equip_info:updateSuit()
	self.txt_suit.text = self.ghost:getSuitName()
	local suitList = self.ghost:getEquipSuit()
	ClientTool.UpdateGrid("", self.content, suitList)
	
	self.txt_suit_des.text = self.ghost.suitDesc
	
	if self.type == 1 then 
		self.btn_left.gameObject:SetActive(false)
		self.btn_right.gameObject:SetActive(false)
		self.btn_replace.gameObject:SetActive(false)
		self.btn_xiexia.gameObject:SetActive(false)
	end 
end 

function equip_info:updateDes()
	    --属性与描述
	self.txtLv.text = TextMap.GetValue("Text_1_2913") .. self.ghost.lv
	self.txt_des.text = self.ghost.desc
	self.txt_attr_left.text = self.ghost:getQHAttr()
	local des = { fu = TextMap.GetValue("Text_1_2914"), hui = TextMap.GetValue("Text_1_2915"), jie = TextMap.GetValue("Text_1_2916"), po = TextMap.GetValue("Text_1_2917")}
	self.txt_type.text = des[self.ghost.kind]
	self.txt_jingli_lv.text = TextMap.GetValue("Text_1_2918") .. self.ghost.power
	self.txt_jinglian_des.text = self.ghost:getJLProperty()
end 

function equip_info:getAttrList(arg)
    local list = {}
    local len = arg.Count
    for i = 0, 3 do
        if i > len - 1 then
            list[i + 1] = 0
        else
            list[i + 1] = arg[i]
        end
    end
    return list
end

function equip_info:getMaxLevel(lv)
    if Tool.ghostXilianLevels then
        local item = Tool.ghostXilianLevels[self.ghost.kind .. "_" .. self.ghost.star]
        if item == nil then return 20 end
        local l = 20
        table.foreach(item, function(i, v)
            if lv <= v then l = v return l end
        end)
        return l
    end
    return 20
end

function equip_info:updateMainAttr()
    if Tool.ghostXilianLevels == nil then
        local list = {}
        local _list = {}
        TableReader:ForEachLuaTable("ghostXilianSettings", function(index, item)
            local kind, star, level, id = item.kind, item.star, item.level, item.id
            if list[kind .. "_" .. star] == nil then list[kind .. "_" .. star] = {} end
            table.insert(list[kind .. "_" .. star], level)
            local li = {}
            for o = 0, item.limit.Count - 1 do
                li[o + 1] = item.limit[o]
            end
            _list[kind .. "_" .. star .. "_" .. level] = li
            return false
        end)
        Tool.ghostXilianIds = _list
        Tool.ghostXilianLevels = list
    end
end

function equip_info:updateProgress()
	
	equip_info:updateMainAttr()
	
	local xilian = self:getAttrList(self.ghost.info.xilian)
    local xilian_tmp = self:getAttrList(self.ghost.info.xilian_tmp)
    local lv = self:getMaxLevel(self.ghost.lv)
    local row = Tool.ghostXilianIds[self.ghost.kind .. "_" .. self.ghost.star .. "_" .. lv]
	local bindings = {}
	bindings[1] = self.life_bar
	bindings[2] = self.atk_bar
	bindings[3] = self.ph_d_bar
	bindings[4] = self.magic_d_bar
    if row then
        for i = 1, 4 do
            local obj = {}
            obj.cur = xilian[i]
            obj.next = xilian_tmp[i]
            obj.max = row[i]
            --obj.name = string.gsub(desc[i].format, "{0}", "")
            bindings[i]:CallUpdateWithArgs(obj)
        end
    end
end 

function equip_info:setHero(ghost)
	self.equip.Url = ghost:getHead()
	self.txt_lv_name.text = ghost:getDisplayColorName()
	local tp = ghost:getType()
    local star = nil
    local piece = ghost
    equip_info:getGodSkillInfo()
    if tp == "ghost" then
        star = ghost.star_level
        equip_info:showStar(ghost)
    else
        local info = piece:pieceInfo(star)
        self.slider.value = info.value
    end
end

function equip_info:getGodSkillInfo()
    local godskillList = {}
    local godSkillMenu = Tool:getGodSkillListInfo()
    if godSkillMenu ~= nil then
        for i = 1, #godSkillMenu do
            local item = godSkillMenu[i]
            if item ~= nil and item.name == self.ghost.name then
                for j = 0, item._skillid.Count do
                    if item._skillid[j] ~= nil then
                        local skillId = item._skillid[j].id
                        local name = "[ffc864]【"..item._skillid[j].name.."】 [-]"--Text1812
                        local desc = "[ffc864]"..item._skillid[j].desc.."[-][64ff64]（"..string.gsub(TextMap.GetValue("Text1812"), "{0}", item.unlock[j]).."）[-]"
                        if self.ghost.info.skill ~= nil then
                            for i = 0, self.ghost.info.skill.Count - 1 do
                                if self.ghost.info.skill[i] == skillId then
                                   name = string.gsub(name,"ffc864","FF0000")
                                   desc = "[ff0000]"..item._skillid[j].desc.."（"..string.gsub(TextMap.GetValue("Text1812"), "{0}", item.unlock[j]).."）[-]" 
                                   break
                                end
                            end
                        end
                        table.insert(godskillList, {skillId = skillId, name = name, desc = desc}) 
                    end
                end
                break
            end
        end
    end
    if #godskillList > 0 then
        self.Godskill.gameObject:SetActive(true)
        self.Godskill:CallUpdate({list = godskillList, targetInfo = self.itemData})
    else
        self.Godskill.gameObject:SetActive(false)
        self.taozhuang:SetAnchor(self.Sprite_shengxing.gameObject, 
            0, -289, 0, -125)
    end
    --print_t(godskillList)
end

function equip_info:showStar(ghost)
    local desc = ghost:getSXPropetry()
    if desc ~= nil then
        self.List_start.gameObject:SetActive(true)
        self.btn_shengxing.isEnabled = true
        if desc.starNum == 5 then
            self.btn_shengxing.gameObject:SetActive(false)
        else
            self.btn_shengxing.gameObject:SetActive(true)
        end
        if desc.starNum ~= nil and desc.starNum > 0 then
            self.txt_shengxing_lv.text = TextMap.GetValue("Text_1_2919")
            self.txt_shengxing_des.text = "[ffff96]"..desc.type.."[-]"..desc.value
        elseif desc.starNum == 0 then
            self.txt_shengxing_lv.text = TextMap.GetValue("Text_1_2919")
            self.txt_shengxing_des.text = "[ffff96]"..desc.type.."[-]"..desc.value
        end
        equip_info:setStar(desc.starNum)
    else
        self.btn_shengxing.isEnabled = false
        self.List_start.gameObject:SetActive(false)
        self.txt_shengxing_lv.text = TextMap.GetValue("Text_1_2920")
        self.txt_shengxing_des.text = TextMap.GetValue("Text_1_2920")

        self.shengxing.gameObject:SetActive(false)
        self.taozhuang:SetAnchor(self.jinlian.gameObject, 
            self.shengxing.leftAnchor.absolute, -69, self.shengxing.rightAnchor.absolute, -180)
        self.taozhuang.leftAnchor.relative = 0
        self.taozhuang.bottomAnchor.relative = 0
        self.taozhuang.rightAnchor.relative = 1
        self.taozhuang.topAnchor.relative = 0
    end
end

function equip_info:setStar(count)
    local list = {}
    local rlist = {}
    for i = 1, 5 do
        if TableReader:TableRowByUniqueKey("ghostaddstar", self.ghost.id, i) ~= nil then
            self["Start_"..i].gameObject:SetActive(true)
        else
            self["Start_"..i].gameObject:SetActive(false)
        end
    end
    for i = 1, 5 do
        list[i] = self["RStart_"..i]
        list[i].gameObject:SetActive(false)
    end

    if count > 0 and #list > 0 then
        for i = 1, count do
            self["Start_"..i].gameObject:SetActive(true)
            list[i].gameObject:SetActive(true)
        end
    end
    self.List_start_grid.enabled = true
end

local function isUsed(list, key)
    return list[key .. ""] ~= nil
end

function equip_info:Start()
	self.btnType = 1
    row = Tool.readSuperLinkById( 242)
	Tool.loadTopTitle(self.gameObject, TextMap.GetValue("Text_1_2921"))
    local unlock = row.unlock[0]
    if unlock == nil then return end
    self.shengxingOpenLevel = unlock.arg
end

function equip_info:getHasUseGhost()
    local ghostSlot = Player.ghostSlot
    local list = {}
    for i = 0, 5 do
        local slot = ghostSlot[i]
        local postion = slot.postion
        local len = postion.Count
        for j = 0, len - 1 do
            local pos = postion[j]
            if pos ~= nil and pos ~= "" and pos ~= 0 then
                list[pos .. ""] = slot.charid
            end
        end
    end
    return list
end

function equip_info:findEquipList()
    local ghostList = {}
    local ghost = Player.Ghost:getLuaTable() or {}
    local hasUse = self:getHasUseGhost() or {}

    local equipList = {  }
    local list = {  }
    table.foreach(ghost, function(i, v)
        local gh = Ghost:new(v.id, i)
        local tp = gh.kind
        if isUsed(hasUse, i) then
            --gh.hasWear = 0
			--table.insert(list, gh)
        --else
            gh.hasWear = 1
            gh.charid = hasUse[i .. ""]
            gh.charName = TableReader:TableRowByID("char", gh.charid).name
            table.insert(equipList, gh)
        end
    end)
	
	
    table.sort(equipList, function(a, b)
        if a.star ~= b.star then return a.star > b.star end
        if a.lv ~= b.lv then
            return a.lv > b.lv
        end
        return a.id < b.id
    end)

    table.sort(list, function(a, b)
        if a.star ~= b.star then return a.star < b.star end
        if a.lv ~= b.lv then
            return a.lv < b.lv
        end
        return a.id > b.id
    end)

    local len = #list
    if len > 0 then
        for i=1,#list do
            local v = list[i]
            table.insert(ghostList, 1, v)
        end
    end

    for i = 1, #equipList do
        local v = equipList[i]
        table.insert(ghostList, 1, v)
    end
	
    for i = 1,#ghostList do
        local char = ghostList[i]
		if char.id == self.ghost.id then 
			self.index = i
		end 
    end
	
	self.minIndex = 1
	self.maxIndex = #ghostList
    self.allEquips = ghostList
end


function equip_info:onClick(go, name)
    if name == "btnBack" then
        UIMrg:pop()
	elseif name == "btn_lvup" then 
		--UIMrg:push("new_hero", "Prefabs/moduleFabs/hero/newHero", { char = self.char, tp = 1 })
		uSuperLink.open("ghost",  {1, self.ghost})
	elseif name == "btn_peiyang" then 
		uSuperLink.open("ghost",  {2, self.ghost})
    elseif name == "btn_shengxing" then 
        uSuperLink.open("ghost",  {4, self.ghost})
    elseif name == "btn_left" then 
		self:onLeft()
	elseif name == "btn_right" then 
		self:onRight()
	elseif name == "btn_replace" then 
		equip_info:onReplace()
	elseif name == "btn_xiexia" then 
		equip_info:onXieXia()
	end
end

function equip_info:onReplace()
    UIMrg:pushWindow("Prefabs/moduleFabs/guidao/guidao_select_charpiece", { kind = self.ghost.kind, ghost = ghost, type = "ghost", callback = self.replaceCallback})
end 

function equip_info:replaceCallback()
	UIMrg:pop()
end 

function equip_info:onXieXia()
    local data = self.ghost
    if data.hasWear == 0 then return end
	local equipKey, pos, ePos = data.key, equip_info:findGhostPos(data), equip_info:findEquipIndex(data)
	local that = self
    Api:gd_equipDown(equipKey, pos, ePos, function(result)
        Tool.resetUnUseGhost()
        data.hasWear = nil
        that.binding:Hide("btn_xiexia")
        that.binding:Show("btn_wear")
		UIMrg:pop()
        --Events.Brocast('updateChar', data)
    end)
end 

function equip_info:findGhostPos(ghost)
    local key = ghost.key
    local ghostSlot = Player.ghostSlot
    for i = 0, 5 do
        local slot = ghostSlot[i]
        local postion = slot.postion
        local len = postion.Count
        for j = 0, len - 1 do
            local pos = postion[j]
            if tonumber(pos) == tonumber(key) then
                return i
            end
        end
    end
end

function equip_info:findEquipIndex(ghost)
    local kind = ghost.kind
    return ghostTypeToNumber[kind] - 1
end

function equip_info:onLeft()
	if self.allEquips == nil then 
		self:findEquipList()
	end  
	
	self.index = self.index - 1
	if self.index < self.minIndex then self.index = self.minIndex end 
	self:updateHero()
end 

function equip_info:onRight()
	if self.allEquips == nil then 
		self:findEquipList()
	end
	
	self.index = self.index + 1
	if self.index > self.maxIndex then self.index = self.maxIndex end 
	self:updateHero()
end 

function equip_info:updateHero()
	self.ghost = self.allEquips[self.index]
	self:onUpdate()
end 

return equip_info
