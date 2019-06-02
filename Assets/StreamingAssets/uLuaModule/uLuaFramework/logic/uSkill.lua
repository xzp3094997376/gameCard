local Skill = {}
local TXT_POWER_UP_UNLOCK_SKILL = TextMap.GetValue("Text_1_2908")
--[[
function Tool.GetCharArgs(key)
    return TableReader:TableRowByID("charArgs", key).value
end
]]
--进阶等级对应颜色
local StateToUnLockColor = {}



--通过技能等级快速读取技能升级所需金币
--@prame lv技能等级
--@pos 第几个技能
--@return 经验值
local function GetSkillUpCost(lv, pos, star_level)
    if (lv == nil) then return 0 end

    local item = TableReader:TableRowByUnique("skillExp", "lv", lv)
    if (item ~= nil and pos < 6) then
        if tonumber(star_level) < 3 then star_level = 3 end
        return item["star_" .. star_level][pos].skill_money
    end
    return 0
end

--更新技能信息
function Skill:updateInfo(char)
    self.char = char
    local sk = self:getSkillValue()
    if sk == nil then
        --技能没解锁
        self.lv = 1
        self.lock = true
	else 
	    self.lv = sk.level
        --return
    end

    --技能是否解锁
    --[[self.lock = false
    if self.index < 4 then
        local limit = TableReader:TableRowByID("charArgs", "limit_"..(self.index+1).."_skill_level").value
        local cost = GetSkillUpCost(self.lv, self.index, char.star)
        self.cost = cost

        --技能升到满级
        local val = Tool.GetCharArgs("skill_" .. (self.index + 1) .. "_level_top")
        self.isMaxLevel = (self.lv >= limit) or (char.lv - self.lv < val)
        self.nextNeed = self.lv + val
    end

    if self.index == 9 then
        local limit = TableReader:TableRowByID("charArgs", "limit_5_skill_level").value
        local cost = GetSkillUpCost(self.lv, 4, char.star)
        self.cost = cost

        --技能升到满级
        local charArg = TableReader:TableRowByID("charArgs", "skill_5_level_top")
        self.isMaxLevel = (self.lv >= limit) or (self.lv > (char.lv - charArg.value) / charArg.value2)
        self.nextNeed = self.lv * charArg.value2 + charArg.value
    end

    if self.index == 8 then
        local limit = TableReader:TableRowByID("charArgs", "limit_8_skill_level").value
        local cost = GetSkillUpCost(self.lv, 5, char.star)
        self.cost = cost

        --技能升到满级
        local charArg = TableReader:TableRowByID("charArgs", "skill_8_level_top")
        self.isMaxLevel = (self.lv >= limit) or (self.lv > (char.lv - charArg.value) / charArg.value2)
        self.nextNeed = self.lv * charArg.value2 + charArg.value
    end ]]--
	--print("________++++++++++++++")
    local des = self.Table.desc_eff or ""
	if sk ~= nil then 
		--print("________++++++++++++++2")
		local vals = sk.value
		--print("获取到数值: " .. tostring(vals))
		local num = 1
		for i = 0, vals.Count - 1 do
			if type(vals[i]) == "number" then
				num = self.Table["desc_" .. i]
				num = tonumber(num)
				if num == 0 or num == nil then num = 1 end
				if num ~= 10 then
					num = math.floor(vals[i] / num)
				else
					num = vals[i] / num
				end
				des = string.gsub(des, "{" .. i .. "}", num)
			end
		end
		if vals.Count ~= 0 then
			self.__desc = des
		else
			self.__desc = ""
		end
		self.desc = des
	else 
		self.desc = self.Table.desc
	end
end

function Skill:getDesc()
    if self.__desc ~= "" and self.__desc ~= nil then
        return self.__desc
    end
    return self.Table.desc
end

--技能属性点
function Skill:getValue()
    local skills = self.char.info.skill:getLuaTable()
    table.foreach(skills, function(i, v)
		local skill = self.char.info.skill[i]
		if skill ~= nil and skill.skill_id == self.id then 
			return skill.value
		end 
    end)
end

function Skill:getSkillValue()
    local skills = self.char.info.skill:getLuaTable()
	--print("查找： " .. self.name .. "  id : " .. self.id)
	local ret = nil
    table.foreach(skills, function(i, v)
		local skill = self.char.info.skill[i]
		--print("解锁: " .. skill.skill_id)
		if skill ~= nil and skill.skill_id == tostring(self.id) then 
			--print("获取到技能：" .. self.name)
			ret = skill
		end 
    end)
	return ret 
end 

--技能升级属性增长
function Skill:getDescList(oldValue)
    local list = {}
    local vals = self:getValue()
    if vals == nil or oldValue == nil then
        return list
    end
    for i = 0, vals.Count - 1 do
        if vals[i] ~= nil and oldValue[i] ~= nil then
            local num = vals[i] - oldValue[i]
            local _num = self.Table["desc_" .. i]
            if _num == nil or _num == "" or _num == 0 then
                _num = 1
            end
            _num = math.floor(tonumber(_num))
            --        if _num == 0 or _num == nil then _num = 1 end
            if _num ~= 10 then
                num = math.floor(num / _num)
            else
                num = num / _num
                if num ~= 0 then
                    num = string.format("%0.2f", num)
                end
            end
            if num ~= 0 then
                table.insert(list, string.gsub(self.Table["desc_attr" .. i], "{" .. i .. "}", num) or "")
            end
        end
    end
    return list
end

--解锁提示
function Skill:unlockDesc()

    if StateToUnLockColor[self.index + 1] == nil then
        for i = 1, 3 do
            local stage = Tool.GetCharArgs("unlock_skill_" .. i .. "_level")
            --            local color = Tool.GetCharArgs("powerup_" .. state .. "_color")
            --            StateToUnLockColor[i] = string.gsub(TXT_POWER_UP_UNLOCK_SKILL, "{0}", color)
            StateToUnLockColor[i] = "xibie_" .. (stage + 1)
        end
        StateToUnLockColor[9] = Tool.GetCharArgs("unlock_skill_8_level")
    end

    return StateToUnLockColor[self.index + 1]
end

--初始化
function Skill:init(id, char, index)
    self.lv = 1
    self.index = index
    self.Table = TableReader:TableRowByID("skill", id)
    if self.Table == nil then
        self.Table = TableReader:TableRowByUnique("skill", "name", id)
        --   print("技能表为空：" .. id)
        return
    end
    self.char = char
    self.id = self.Table.id

    --self.desc = self.Table.desc
    self.name = self.Table.show
    if char then
        self:updateInfo(char)
    end
end

--技能图标
function Skill:getIcon()
    if (self._icon) then return self._icon end
    --    local img = self.Table.head_img
    local img = self.Table.icon
    if (img == "" or img == nil) then img = "default" end

    self._icon = UrlManager.GetImagesPath("skill/" .. img .. ".png")
    return self._icon
end

--初始化技能
--技能id,角色Char,技能位置index(0~3)
function Skill:new(id, char, index)
    local o = {}
    setmetatable(o, self)
    self.__index = self
    o:init(id, char, index)
    return o
end

return Skill