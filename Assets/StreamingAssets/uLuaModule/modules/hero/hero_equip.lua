-- 英雄觉醒
local powerUp = require("uLuaModule/modules/char/sub/uPowerUp.lua")

local m = {}

function m:update(lua)
	self.char = lua.char
    self.delegate = lua.delegate
    self:onUpdate(lua.char, true)
    local sell_type= "shenhun"
    self.ziyuanName.text =Tool.getResName(sell_type) .. ":"
    self.ziyuanNum.text =toolFun.moneyNumberShowOne(math.floor(tonumber(Tool.getCountByType(sell_type))))
    local iconName = Tool.getResIcon(sell_type)
    self.ziyuanIcon.Url=UrlManager.GetImagesPath("itemImage/" .. iconName .. ".png")
    self.isEquipNum = 0
    self.btn_OneKey_Equip.gameObject:SetActive(false)
end

function m:playEquipOnEffect(go, equip)
    if go == nil then return end
    ClientTool.AlignToObject(self.efEquipOn.gameObject, go, 3)
    self.efEquipOn:ResetToBeginning()
    local desc = equip:getDescList()
    if self.__power and self.char.power - self.__power > 0 then
        table.insert(desc, TextMap.GetValue("Text1055") .. self.char.power - self.__power)
    end
    m:showOperateAlert(desc)
    m:updateEquip()
end

function m:showOperateAlert(desc)
    self.binding:CallManyFrame(function()
        OperateAlert.getInstance:showToGameObject(desc, self.img_hero.gameObject)
    end)
end

function m:isCanEuqip(id)
    self.oneKeyId = id
    self.isEquipNum = self.isEquipNum + 1
    if self.isEquipNum >= 1 then
        self.btn_OneKey_Equip.gameObject:SetActive(true)
    else
        self.btn_OneKey_Equip.gameObject:SetActive(false)
    end
end

function m:updateEquip()
    self.__power = self.char.power
    local char = self.char
    local equips = char:getEquips(true)
    self.curEquipCount = 0
    local equipLists = {}
    for i = 1, #equips do
        local equip = equips[i]
        --已装备的装备数量
		equip:updateInfo()
        if (equip:getChar() ~= nil) then self.curEquipCount = self.curEquipCount + 1 end
        equipLists[i] = { equip = equips[i], char = char, pos = i - 1, delegate = self }
    end
    --self.equips:refresh("", equipLists, self)
	for i = 1, 4 do 
		if equipLists[i] ~= nil then 
			self["equip_button"..i].gameObject:SetActive(true)
			self["equip_button"..i]:CallUpdate(equipLists[i])
		else
			self["equip_button"..i].gameObject:SetActive(false)
		end 
	end 

    --判断是否突破到顶
    if not self.char:canPowerUp() then
        self.btn_powerUp.isEnabled = false
		self.Grid.gameObject:SetActive(false)
		self.txt_skill_name.text = TextMap.GetValue("Text_1_811")
    else
        self.btn_powerUp.isEnabled = true
        if self.curEquipCount == 6 then
            if self.tupoeffect == nil then
                self.tupoeffect = Tool.LoadButtonEffect(self.btn_powerUp.gameObject)
            end
            self.tupoeffect:SetActive(true)

        else
            if self.tupoeffect ~= nil then
                self.tupoeffect:SetActive(false)
            end
        end
    end
    self.delegate:updateHeroInfo(self.char)
    --self:updateDesc()
end

function m:updateDesc()
    local char = self.char
    --属性与描述
    local list = char:getAttrDesc()
    local descLeft = ""
    local descRight = ""
    table.foreachi(list, function(i, v)
        if i % 2 ~= 0 then
            descLeft = descLeft .. v
        else
            descRight = descRight .. v
        end
    end)
    --self.txt_attr_left.text = string.sub(descLeft, 1, -2)
    --self.txt_attr_right.text = string.sub(descRight, 1, -2)
    --self.txt_hero_desc.text = char:getDesc()
    --self.txt_ding_wei_desc.text = char.Table.dingwei_desc
end

function m:updateLevelInfo()
    local char = self.char
    local info = char:expInfo()

    self.txt_soul.text = char:exp()
end

function m:onTooltip(name)
    if name == "dingwei" then
        return self.dw_text
    end
end

function m:find(name)
    local go = self.gameObject.transform:Find(name)
    if go then return go.gameObject end
    return nil
end

function m:resort(go)
    if go.gameObject.activeSelf then
        go.gameObject:SetActive(false)
        go.gameObject:SetActive(true)
    end
end

function m:updateTianfu()
	-- 天赋技能
	local that = self
	--local tb = nil 
	local nextStage = 0
	
	local tb = TableReader:TableRowByUniqueKey("powerUp_skill", "powerUp_skill", self.char.stage+1)
	--TableReader:ForEachLuaTable("unlock_skill", function(index, item)
    --    if item.skill_type == "powerUp_skill" and item.unlock_condition == "powerup" and item.unlock_arg > that.char.stage then 
	--		nextStage = item.unlock_arg
	--		tb = item
	--		return true
	--	end 
    --    return false
    --end)
	if tb ~= nil then 
		--local star = math.floor ( nextStage / 10 )
		--local starLv = math.fmod(nextStage,10)
	
		local skillId = self.char.modelTable.powerUp_skill[tb.skill_slot]
		if skillId == nil then print("天赋技能没有配置， 或者配置错误！") return end 
		local sk = TableReader:TableRowByID("skill", skillId)
		if sk ~= nil then 
			local name=string.gsub(TextMap.GetValue("LocalKey_827"),"{0}",self.char:getStageStarByNum(nextStage))
            self.txt_skill_name.text=string.gsub(name,"{1}",sk.name)
			self.txt_skill_des.text = sk.desc_eff
		end 
	else 
		self.skill:SetActive(false)
	end 
end 

function m:updateBloodState()
    local hero_info = m:find("Container/hero_info")
    Tool.SetActive(hero_info, self.showEquip)
    Tool.SetActive(self._blood_bg, not self.showEquip)
    --self.equips.gameObject:SetActive(self.showEquip)
end

function m:onUpdate(ret)
    local char = self.char
    self.dw_text = char.Table.dingwei_desc
    --self.dingwei.spriteName = char:getDingWei()
    if ret == nil then
        --        self.delegate:onUpdate(char)
        Events.Brocast('updateChar')
    end
    if self._blood then
        self._blood:CallTargetFunction("onUpdate", self.char)
    end

	local star = math.floor ( char.stage / 10 )
	local starLv = math.fmod(char.stage,10)
	if starLv < 0 then starLv = 0 end
    self.txtStar.text = string.gsub(TextMap.GetValue("LocalKey_810"),"{0}",star)
	self.txtStarLv.text = string.gsub(TextMap.GetValue("LocalKey_812"),"{0}",starLv)
	self.txt_name.text = self.char:getDisplayName()
	
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

    if char.star < 4 then
        m:setImage(false)
    else
        m:setImage(open)
    end
    self.binding:CallManyFrame(function()
        m:updateEquip()
    end)
	--self:updateTianfu()
    --self.txt_soulOneKey.text = 0
    --self.binding:CallManyFrame(function()
    --    m:updateLevelInfo()
    --end)
	
	 --材料
    local row = TableReader:TableRowByUniqueKey("powerUp", self.char.Table.powUpId, self.char.stage)
    if row then
		if self.skill.activeSelf == false then 
			self.skill:SetActive(true)
		end 
		self.txt_skill_name.text = row.desc1
		self.txt_skill_des.text = row.desc2
        local consume = RewardMrg.getConsumeTable(row.consume, self.char.dictid)
        local list = {}
        table.foreach(consume, function(i, v)
            local t = v:getType()
            if t == "money" then
                self.costMoney = toolFun.moneyNumber(math.floor(tonumber(v.rwCount)))
                local max = Tool.getCountByType("money")
                if v.rwCount > max then
                    self.txt_soul.text = "[ff2222]" .. self.costMoney .. "[-]"
                    ret = false
                else
                    self.txt_soul.text = self.costMoney
                end

            else
                local num = v.rwCount
                local max 
				if t == "char" then 
					max = Tool.getCountByType(v:getType(), v.dictid)
				else 
					max = Tool.getCountByType(v:getType(), v.id)
				end 
                if num > max then
                    num = "[ff2222]" .. max .. "[-][00ff00]/" .. num .. "[-]"
                    ret = false
                else
                    num = "[00ff00]" .. max .. "/" .. num .. "[-]"
                end
                v.rwCount = 1

                table.insert(list, {
                    item = v,
                    num = num
                })
            end
        end)
        ClientTool.UpdateGrid("", self.Grid, list)
	else 
		self.skill:SetActive(false)
    end
end

function m:dropNumber(list, newList, power)
    local descIndex = {}
    local numList = {}
    for i = 0, list.Count - 1 do
        if list[i] ~= newList[i] then
            table.insert(descIndex, i)
            numList[i] = newList[i] - list[i]
        end
    end
    if power and power > 0 then
        table.insert(descIndex, TextMap.GetValue("Text_1_822") .. power)
    end
    local txtList = self.char:getAttrList(descIndex, numList, "+")
    m:showOperateAlert(txtList)
end

function m:updateTab()
    m:onUpdate(self.char)
end

--突破
function m:onPowerUp(go)
    if not self.char:canPowerUp() then
        MessageMrg.show(TextMap.TXT_TOP_POWER_UP)
        return
    end

    local that = self
    local list = self.char.info.propertys
    local data_before = {}
    data_before[1] = GetAttrNew("MaxHp", self.char.info.propertys) -- self.char:getAttrSingle("MaxHp", true)
    data_before[2] = GetAttrNew("PhyAtk", self.char.info.propertys) --self.char:getAttrSingle("PhyAtk", true)
    data_before[3] = GetAttrNew("PhyDef", self.char.info.propertys) --self.char:getAttrSingle("PhyDef", true)
    data_before[4] = GetAttrNew("MagDef", self.char.info.propertys) --self.char:getAttrSingle("MagDef", true)
	--if data_before then return end 
    local power = self.char.power
    Api:charColorUp(self.char.id, function(result)
        powerUp.Show(data_before, that.char, result, function()
            that.char:updateInfo()
            local newList = that.char.info.propertys
            m:dropNumber(list, newList, that.char.power - power)
            that:onUpdate(that.char, true)
            Events.Brocast('showEffect')
            self.delegate:updateHeroInfo(self.char)
            GuideMrg.Brocast("changeSkill", that.char)
        end)
    end)
end

function m:playEffect()
    self.effect:SetActive(false)
    self.effect:SetActive(true)
end

function m:onLvUp(go)
    local that = self
    local list = self.char.info.propertys
    local power = self.char.power
    go.isEnabled = false
    Api:charLevelUp(self.char.id, function(result)
        Events.Brocast('showEffect')
        that:playEffect()
        that.char:updateInfo()
        that:onUpdate(that.char)
        local newList = that.char.info.propertys
        MusicManager.playByID(28)
        m:dropNumber(list, newList, that.char.power - power)
        self.delegate:updateHeroInfo(self.char)
        local ret = GuideMrg.Brocast("charJinHua", that.char)
        if not ret then
            GuideMrg.Brocast("charXilian", that.char)
        end
        go.isEnabled = true
    end, function(ret)
        go.isEnabled = true
        return false
    end)
end

function m:onOneKeyLvUp(go)
    local that = self
    local list = self.char.info.propertys
    local power = self.char.power
    Api:oneStepcharLevelUp(self.char.id, function(result)
        Events.Brocast('showEffect')
        that:playEffect()
        that.char:updateInfo()
        m:onUpdate(that.char)
        local newList = that.char.info.propertys
        MusicManager.playByID(28)
        m:dropNumber(list, newList, that.char.power - power)
        self.delegate:updateHeroInfo(self.char)
        local ret = GuideMrg.Brocast("charJinHua", that.char)
        if not ret then
            GuideMrg.Brocast("charXilian", that.char)
        end
    end)
end

local ImageCount = 0
function m:setImage(ret)
    if self.char.star < 4 then
        self.img_hero:LoadByModelId(self.char.modelid, "idle", function() end, false, -1, 1)
        self.binding:ChangeColor("img_hero", Color.white)
        --self.txt_desc_for_power:SetActive(false)
        return
    end
    local show = self._isShowChangeImage
    if ret == true then
        show = not show
    end
    local url = self.char:getImage(show)
    self.img_hero:LoadByModelId(self.char.modelid, "idle", function() end, false, -1, 1)
    if self._isShowChangeImage == true and ret == false then
        local a = 3 / 255
        self.binding:ChangeColor("img_hero", Color(a, a, a))
        --self.txt_desc_for_power:SetActive(true)
    else
        self.binding:ChangeColor("img_hero", Color.white)
        --self.txt_desc_for_power:SetActive(false)
    end
    ImageCount = ImageCount + 1
    if ImageCount >= 10 then
        ImageCount = 0
        ClientTool.release()
    end
end

function m:RotTo(go, btn, ret)
    btn.isEnabled = false
    local rotation = Quaternion.identity
    rotation.eulerAngles = Vector3(0, 80, 0)
    self.binding:RotTo(go, 0.2, rotation, function()
        m:setImage(ret)
        go.transform.rotation = Quaternion.Euler(Vector3(0, 90, 0))
        self.binding:CallManyFrame(function()
            self.binding:RotTo(go, 0.2, Quaternion.identity, function()
                btn.isEnabled = true
                go.transform.rotation = Quaternion.Euler(Vector3(0, 0, 0))
            end)
        end)
    end)
end

function m:goToJinHua(go)
    --跳到进化页面
    -- uSuperLink.open("powerUp", { 3, self.char }, 0, 2)
    self.delegate:switch(2)
end

function m:onClick(go, name)
    if name == "btn_powerUp" then
        self:onPowerUp(go)
    elseif name == "btnOneKeyLvUp" then
        m:onOneKeyLvUp(go)
    elseif name == "btn_changeNormal" then
        self._isShowChangeImage = not self._isShowChangeImage
        m:RotTo(self.img_hero.gameObject, go, true)
    elseif name == "btn_changeImage" then
        self._isShowChangeImage = not self._isShowChangeImage
        m:RotTo(self.img_hero.gameObject, go, false)
    elseif name == "btn_starUp" then
        m:goToJinHua(go)
    elseif name == "btnLvUp" then
        m:onLvUp(go)
    elseif name=="btn_shop" then 
        uSuperLink.openModule(14)
    elseif name=="btn_OneKey_Equip" then
        if self.isEquipNum >= 1 and self.oneKeyId ~= nil then
           Api:OneKeyWearEquip(self.oneKeyId, function()
                self.char:updateInfo()
                MusicManager.playByID(34)
                m:onUpdate(true)
                self.btn_OneKey_Equip.gameObject:SetActive(false)
            end)
        end
    end
end

function m:hideEffect()
end

function m:OnEnable()
    self:onUpdate(self.char)
end

function m:Start()

    self.showEquip = true
    -- self.binding:CallManyFrame(function()
    --     local go = self.gameObject.transform:Find("Container").gameObject
    --     self._blood = ClientTool.loadAndGetLuaBinding("Prefabs/activityModule/bloodModlue/hero_blood",go)
    --     self._blood:CallUpdate(self)
    --     self._blood.transform.localPosition = Vector3(-160,36,0)
    --     local sp = NGUITools.AddChild(go)
    --     local hero_info = m:find("Container/hero_info")
    --     hero_info = hero_info:GetComponent(UISprite)
    --     sp = sp:AddComponent(UISprite)
    --     sp.spriteName = hero_info.spriteName
    --     sp.atlas = hero_info.atlas
    --     sp.width = hero_info.width
    --     sp.height = hero_info.height
    --     sp.depth = hero_info.depth
    --     sp.transform.localPosition = hero_info.transform.localPosition
    --     self._blood_bg = sp.gameObject
    -- end,5)
    --self.oldParent = self.btn_changeImage.transform.parent
end

function m:onClose()
    -- if self.showEquip then 
    --     UIMrg:pop()
    -- else
    --     DialogMrg.ShowDialog(TextMap.getText("TXT_CLOSE_BLOOD").."\n\n"..TextMap.getText("TXT_CLOSE_BLOOD_TIP"),function()
    --     end,function()
    --         UIMrg:pop()
    --     end,nil,nil,"继续升级","先行离开")
    -- end
    UIMrg:pop()
end

return m

