local m = {}
local __font = nil
local isRunning = false

function m:update(lua)
	-- 外部刷新， 停止
	isRunning = false 
    self.delegate = lua.delegate
    self.char = lua.char
    m:onUpdate()
end

function m:getMagics(magics, isRight)
    local txt = ""
    local len = magics.Count - 1
	local list = {}
	local nList = {}
    for i = 0, len do
        local row = magics[i]
        local magic_effect = row._magic_effect
        local magic_arg1 = row.magic_arg1
        -- local magic_arg2 = row.magic_arg2
        local desc = ""
		local arg1 = magic_arg1 / magic_effect.denominator
		if isRight ~= nil then 
			desc = string.gsub("[ffff96]" .. magic_effect.format.."[-]", "{0}", "[00ff00]"..arg1)
		else 
			desc = string.gsub("[ffff96]" .. magic_effect.format.."[-]", "{0}", "[ffffff]"..arg1)
		end 
        if i < len then desc = desc .. "\n" end
        -- if math.floor(magic_arg1 / magic_effect.denominator) == 0 then desc =  "" end
        txt = txt .. desc
		list[i+1] = desc
		nList[i+1] = arg1
    end
    return  txt, list, nList
end

function m:onUpdate()
    self.node:SetActive(true)
    self.dw_text = self.char.Table.dingwei_desc
	self.img_hero:LoadByModelId(self.char.modelid, "idle", function() end, false, 0, 1)
    self:updateDesc()

    if self.char == nil then
        return
    end

    self.costItem:updateInfo()
    local charId = self.char.id
    local bloodline = Player.Chars[charId].bloodline
    local lv = bloodline.level
    local value = bloodline.value
    local char = self.char
	self.selected:SetActive(self.isAuto)
	self.txtName.text = self.char:getDisplayName()
	--self.txt_start_lv.text = "[ffff96]" .. self.char.star_level .."[-]"
    self.txt_left_lv.text =string.gsub(TextMap.GetValue("LocalKey_659"),"{0}",lv)
    local attr = TableReader:TableRowByUniqueKey("bloodlineArg", lv, char.star)
	local txt, list, nList1 = m:getMagics(attr.magic)
	--self.txt_left_attr.text = list[1] .. list[2]
	self.txt_attr_left.text = list[2] .. list[3]
	self.txt_attr_right.text = list[1] .. list[4]
    if not m:isMax(lv + 1) then
        local row = TableReader:TableRowByID("bloodlineLvup", lv + 1)
        if row.char_lv_limit > char.lv then
            self.btnUp.isEnabled = false
            --self.txt_need.text = TextMap.GetValue("Text_1_889") .. row.char_lv_limit
        else
            self.btnUp.isEnabled = true
            --self.txt_need.text = ""
        end
        local exp = row["star_" .. char.star .. "_bexp"]
        local num = self.costItem.count or 0
        self.txt_blood.text = TextMap.GetValue("Text_1_886") .. value .. "/" .. exp
        if num < row.bexp_lvup then 
            num = Tool.red .. num .. "[-]" 
        else
            num = toolFun.moneyNumberShowOne(math.floor(tonumber(num)))
        end
        self.txt_cost_num.text = num .. "/" .. row.bexp_lvup

        self.txt_right_lv.text =string.gsub(TextMap.GetValue("LocalKey_659"),"{0}",lv + 1)
        attr = TableReader:TableRowByUniqueKey("bloodlineArg", lv + 1, char.star)
		local txt, list, nList2 = m:getMagics(attr.magic, true)
		--self.txt_left_attr.text = list[1] .. list[2]
		self.txt_attr_left2.text = list[2] .. list[3]
		self.txt_attr_right2.text = list[1] .. list[4]
		self.txt_atk_add.text = (nList2[2] - nList1[2]).."%"
		self.txt_life_add.text = (nList2[3] - nList1[3]).."%"
		self.txt_dp_add.text = (nList2[1] - nList1[1]).."%"
		self.txt_md_add.text = (nList2[4] - nList1[4]).."%"
		self.bar_progress.value = value / exp
        m:setValue(value / exp)
		
		local skill = nil
		local hasXp = false
		local xpSkill = nil
		local skillUp = self:getSkillByType(attr.skillLvup, "skill")
		local xpSkillUp = self:getSkillByType(attr.skillLvup, "xp_skill")
		
		if self.char.id == Player.Info.playercharid then 
			if Player.fashion.curEquipID > 0 then 
				for i = 1, #self.char._allSkills do 
					local item = self.char._allSkills[i]
					if item.customType == 2 then 
						skill = item
					elseif item.customType == 3 then 
						if self.char.fashionlv >= 160 then 
							xpSkill = item
							hasXp = true
						end 
					end 
				end
			else
				skill = self.char.modelTable._skill[skillUp.skill_slot-1]
				xpSkill = self.char.modelTable._xp_skill[skillUp.skill_slot-1]
				hasXp = true
			end
		else
			skill = self.char.modelTable._skill[skillUp.skill_slot-1]
			xpSkill = self.char.modelTable._xp_skill[skillUp.skill_slot-1]
			hasXp = true
		end 
		
		self.txt_skill_next.text = skill and ("[ffff96]" .. skill.show .. "：[-]" ..string.gsub(TextMap.GetValue("LocalKey_830"),"{0}", skillUp.skillLv)) or ""
		self.txt_xp_skill_next.text = (hasXp == true and xpSkill ~= nil) and ("[ffff96]" .. xpSkill.name .. "：[-]" ..string.gsub(TextMap.GetValue("LocalKey_830"),"{0}",xpSkillUp.skillLv)) or ""
    else
        --最大等级
        self.txt_right_lv.text = TextMap.GetValue("Text1102")
		self.txt_attr_left2.text = self.txt_attr_left.text
		self.txt_attr_right2.text = self.txt_attr_right.text
        self.txt_cost_num.text = "0"

        local row = TableReader:TableRowByID("bloodlineLvup", self.max_lv)
        local exp = row["star_" .. char.star .. "_bexp"]
        self.txt_blood.text = TextMap.GetValue("Text_1_886") .. exp .. "/" .. exp
        m:setValue(1)
		self.bar_progress.value = 1
        self.btnUp.isEnabled = false
        --self.eff:SetActive(false)
    end
    self.delegate:updateHeroInfo(self.char)
end

function m:getSkillByType(arr, type)
	for i = 0, arr.Count - 1 do 
		if arr[i].skill_type == type then 
			return arr[i]
		end 
	end 
	return nil 
end 

function m:setValue(num)
    --self.effect.enabled = num ~= 0
   -- self.effect.transform.localPosition = Vector3(0, 130 * num - 130, 0)
end

function m:isMax(lv)
    return lv > self.max_lv
end

function m:resort(go)
    if go.gameObject.activeSelf then
        go.gameObject:SetActive(false)
        go.gameObject:SetActive(true)
    end
end


function m:bloodUp()
    -- self.delegate:playEffect()
    local luaTable = {}
    local data_attr = {}
    local data_before = {}
    local data_after = {}
    local char = self.char
    local charId = char.id
    local bloodline = Player.Chars[charId].bloodline
    local lv = bloodline.level

    local attr_befor = TableReader:TableRowByUniqueKey("bloodlineArg", lv - 1, char.star)
    local attr = TableReader:TableRowByUniqueKey("bloodlineArg", lv, char.star)

    local magics_befor = attr_befor.magic
    local magics = attr.magic
    local len = magics.Count - 1
    for i = 0, len do
        local row = magics[i]
        local magic_effect = row._magic_effect
        local magic_arg1 = row.magic_arg1

        local b_row = magics[i]
        local b_magic_arg1 = row.magic_arg1

        local name = string.gsub(magic_effect.format, "{0}%%", "")
        table.insert(data_attr, name)
        table.insert(data_before, magics_befor[i].magic_arg1 / magic_effect.denominator .. "%")
        table.insert(data_after, magic_arg1 / magic_effect.denominator .. "%")
    end
    local luaTable = {
        data_attr = data_attr,
        data_after = data_after,
        data_before = data_before,
		skill_before = self.txt_skill.text,
		skill_after = self.txt_skill_next.text,
        char = char,
        lv = lv,
        font = __font
    }
    -- UIMrg:clearWindow()
    UIMrg:pushWindow("Prefabs/activityModule/bloodModlue/bloodUp", luaTable)
end

function m:onBlood()
    local char = self.char
    -- local delegate = self.delegate
    local charId = char.id
    local bloodline = Player.Chars[charId].bloodline
    local lv = bloodline.level
    Api:BloodlineLvup(charId, function(result)
        char:updateInfo()
        if bloodline.level > lv then
            m:bloodUp()
        end
        -- delegate:onUpdate(char)
    end)
end

local TimerID = 0

function m:onClick(go, name)
    if name == "btnUp" then
		if isRunning == false or self.isAuto == false then 
			if Player.Info.level < self.unLockLv then
				MessageMrg.show(TextMap.GetValue("Text_1_889")  .. self.unLockLv)
				return
			end
			m:onBloodUp()
		end 
	elseif name == "btnOneKeyUp" then 
		self.isAuto = not self.isAuto
		isRunning = false
		LuaTimer.Delete(TimerID)
		self.selected:SetActive(self.isAuto)
    end
end

function m:onBloodUp()
	local char = self.char
    local charId = char.id
    local bloodline = Player.Chars[charId].bloodline
    local lv = bloodline.level
    local val = bloodline.value
	isRunning = true
    Api:BloodlineLvup(charId, function(result)
        char:updateInfo()
        --local list = { TextMap.GetValue("Text1103") .. (bloodline.value - val) }
		if result.ret == 0 then 
			if bloodline.level > lv then
				LuaTimer.Delete(TimerID)
				isRunning = false
				local str = TextMap.GetValue("Text1104") .. 1
				m:showOperateAlert(str)
				m:bloodUp()
			else 
				m:showOperateAlert(TextMap.GetValue("Text1103") .. (bloodline.value - val))
				if m.isAuto == true then 
					m.binding:CallAfterTime(0.15, function()
						m:onBloodUp()
					end)
				end 
			end
			--OperateAlert.getInstance:showToGameObjectQuick(TextMap.GetValue("Text1103") .. (bloodline.value - val))
			bloodline = Player.Chars[charId].bloodline
			m:onUpdate()
		else 
			LuaTimer.Delete(TimerID)
			isRunning = false
		end 
	end) 
end 

function m:OnDestroy()
    --     Events.RemoveListener("reloadDelegate")
    __font = nil
end

--设置角色texture
local ImageCount = 0
function m:setImage(ret)
    if self.char.star < 4 then
        local url = self.char:getImage()
        --self.img_hero.Url = url
        --self.binding:ChangeColor("img_hero", Color.white)
        self.txt_desc_for_power:SetActive(false)
        return
    end
    local show = self._isShowChangeImage
    if ret == true then
        show = not show
    end
    --local url = self.char:getImage(show)
    --self.img_hero.Url = url
	self.img_hero:LoadByModelId(self.char.dictid, "idle", function() end, false, 0, 1)
    if self._isShowChangeImage == true and ret == false then
        local a = 3 / 255
        --self.binding:ChangeColor("img_hero", Color(a, a, a))
        -- self.txt_desc_for_power:SetActive(true)
    else
        --self.binding:ChangeColor("img_hero", Color.white)
        -- self.txt_desc_for_power:SetActive(false)
    end
    ImageCount = ImageCount + 1
    if ImageCount >= 10 then
        ImageCount = 0
        ClientTool.release()
    end
end

--更新角色信息
function m:updateDesc()
    local char = self.char
	local bloodline = Player.Chars[char.id].bloodline
    local lv = bloodline.level
	local attr = TableReader:TableRowByUniqueKey("bloodlineArg", lv, char.star)
	
	local skill = nil
	local xpSkill = nil
	local hasXp = false
	local skillUp = self:getSkillByType(attr.skillLvup, "skill")
	local xpSkillUp = self:getSkillByType(attr.skillLvup, "xp_skill")
	if self.char.id == Player.Info.playercharid then 
		if Player.fashion.curEquipID > 0 then 
			for i = 1, #self.char._allSkills do 
				local item = self.char._allSkills[i]
				if item.customType == 2 then 
					skill = item
				elseif item.customType == 3 then 
					if self.char.fashionlv >= 160 then
						hasXp = true
						xpSkill = item
					end 
				end 
			end
		else
			skill = self.char.modelTable._skill[skillUp.skill_slot-1]
			xpSkill = self.char.modelTable._xp_skill[skillUp.skill_slot-1]
			hasXp = true
		end
	else
		skill = self.char.modelTable._skill[skillUp.skill_slot-1]
		xpSkill = self.char.modelTable._xp_skill[skillUp.skill_slot-1]
		hasXp = true
	end 
	self.txt_skill.text = skill and ("[ffff96]" .. skill.show .. "：[-]" .. string.gsub(TextMap.GetValue("LocalKey_812"),"{0}",skillUp.skillLv)) or ""
	self.txt_xp_skill.text = (hasXp == true and xpSkill ~= nil) and ("[ffff96]" .. xpSkill.name .. "：[-]" .. string.gsub(TextMap.GetValue("LocalKey_812"),"{0}",xpSkillUp.skillLv)) or "" 
end

--飘字
function m:showOperateAlert(desc)
    self.binding:CallManyFrame(function()
        OperateAlert.getInstance:showToGameObjectQuick(desc, self.img_hero.gameObject)
    end)
end

function m:onTooltip(name)
    if name == "dingwei" then
        return self.dw_text
    end
end

function m:hideEffect()
end

function m:OnEnable()
    self:onUpdate()
end

function m:onClose()

    local bloodline = Player.Chars[self.char.id].bloodline
    local value = bloodline.value
    if value > 0 then
        DialogMrg.ShowDialog(TextMap.getText("TXT_CLOSE_BLOOD") .. "\n\n" .. TextMap.getText("TXT_CLOSE_BLOOD_TIP"), function()
        end, function()
            UIMrg:pop()
        end, nil, nil, TextMap.GetValue("Text1105"), TextMap.GetValue("Text1106"))
    else
        UIMrg:pop()
    end
end

function m:Start()
    self.node:SetActive(true)
    -- self.btnBloodOldParent = self.btnBlood.transform.parent
    -- self.btnPowerOldParent = self.btnPower.transform.parent
    self.max_lv = TableReader:TableRowByID("bloodlineSetting", 1).arg
    local costItem = TableReader:TableRowByID("bloodlineSetting", 3).arg
    self.unLockLv = TableReader:TableRowByID("bloodlineSetting", 4).arg
    local item = uItem:new(costItem)
    self.costItem = item
    local img = item:getHeadSpriteName()
    local assets = packTool:getIconByName(img)
	self.sp_icon:setImage(img, assets)
    --self.sp_icon_big:setImage(img, assets)
    self.txt_desc.text = TextMap.getText("TXT_BLOOD_DESC", {})
	self.isAuto = false
	
end

return m