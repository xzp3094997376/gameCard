--
-- Created by IntelliJ IDEA.
-- User: xiyou
-- Date: 2015/3/22
-- Time: 17:50
-- To change this template use File | Settings | File Templates.
--
--鬼道
local M = {}
local ghost_max_lv = nil
local powerUpAttr = {}
local ghost_powerup_maxlv = nil
local ghost_powerUp_consume = nil
function M:getType()
    return self.Table.type
end

function M:getHead()
    if (self._head) then return self._head end
    local img = self.Table.iconid
    if (img == "" or img == nil) then img = "default" end
    self._head = UrlManager.GetImagesPath("equipImage/" .. img .. ".png")
    return self._head
end

function M:getMaxPower()
    if ghost_powerup_maxlv == nil then
        ghost_powerup_maxlv = TableReader:TableRowByID("ghostArgs", "ghost_powerup_maxlv").arg
        ghost_powerup_maxlv = tonumber(ghost_powerup_maxlv)
    end
    return ghost_powerup_maxlv
end

--当前的最大精炼等级
function M:getCurMaxPower()
    local row = {}
    TableReader:ForEachTable("ghostPowerUp",
        function(k, item)
            if item ~= nil and item.name == self.name then 
                table.insert(row, item)
            end
            return false
        end)
    if row[row.Count].level<=self.lv then 
        return row[row.Count].power
    elseif row[1].level>self.lv then 
        return 0
    else 
        for i=1, row.Count-1 do
            if row[i].level<=self.lv and row[i+1].level>self.lv then 
                return row[i].power
            end 
        end
    end
    return 0
end

function M:isMaxPower()
    return self.power >= self.getMaxPower()
end

--经验消耗
function M:getPowerUpConsume()
    if ghost_powerUp_consume == nil then
        ghost_powerUp_consume = TableReader:TableRowByID("ghostArgs", "ghost_powerUp_consume").arg2
        ghost_powerUp_consume = tonumber(ghost_powerUp_consume)
    end
    return ghost_powerUp_consume
end

--最大强化等级
function M:getMaxLv()
    if ghost_max_lv == nil then
        ghost_max_lv = TableReader:TableRowByID("ghostArgs", "ghost_max_lv").arg
    end
    return ghost_max_lv
end

--判断是否强化到顶级
function M:isMaxLv()
    return self.lv >= self:getMaxLv()
end

function M:getCurMaxLv()
    if maxLvUp_arg == nil then
        local ghost_levelUp = TableReader:TableRowByID("ghostArgs", "ghost_levelUp")
        maxLvUp_arg = ghost_levelUp.arg
        maxLvUp_arg2 = ghost_levelUp.arg2
    end

    return Player.Info.level * maxLvUp_arg - maxLvUp_arg2
end

local maxLvUp_arg = nil
local maxLvUp_arg2 = nil

function M:curMaxLv()
    if maxLvUp_arg == nil then
        local ghost_levelUp = TableReader:TableRowByID("ghostArgs", "ghost_levelUp")
        maxLvUp_arg = ghost_levelUp.arg
        maxLvUp_arg2 = ghost_levelUp.arg2
    end

    return self.lv < Player.Info.level * maxLvUp_arg - maxLvUp_arg2
end

function M:getHeadSpriteName()
    local img = self.Table.iconid
    if (img == "" or img == nil) then img = "default" end
    return img
end

--颜色
--return { icon = "",color = "" }
function M:getColor()
    local color = Tool.getItemColor(self.Table.color)
    return color
end

function M:getItemColorName(color, names)
    local _names = names
	if color == 1 then
        _names = "[ffffff]" .. names .. "[-]"
    elseif color == 2 then
        _names = "[00ff00]" .. names .. "[-]"
    elseif color == 3 then
        _names = "[00b4ff]" .. names .. "[-]"
    elseif color == 4 then
        _names = "[ff00ff]" .. names .. "[-]"
    elseif color == 5 then
        _names = "[ff9600]" .. names .. "[-]"
    elseif color == 6 then
        _names = "[ff0000]" .. names .. "[-]"
	elseif color == 7 then
        _names = "[ff0000]" .. names .. "[-]"
    end
    return _names
end

--ui中显示的名字，带进阶等级
function M:getDisplayName()
    local name = self.name
    if self.power > 0 then name = name .. " [00ff00]+" .. self.power .."[-]" end
    return M:getItemColorName(self.star, name)
end

--ui中显示角色名字，带颜色
function M:getDisplayColorName()
    local name = self.name
    if self.power > 0 then name = name .. " [00ff00]+" .. self.power .."[-]" end
    return M:getItemColorName(self.star, name)
end

function M:updateInfo()
    if self.key ~= nil then
        local info = Player.Ghost[self.key]
        self.info = info
        self.lv = info.level
        if self.lv <= 0 then self.lv = 1 end
        self.exp = info.exp
        self.power = tonumber(info.power or 0)
        self.levelUpComsume = info.levelUpComsume
        self.xilian = info.xilian
        self.xilian_tmp = info.xilian_tmp
        self.xilian_times = info.xilian_times
        self.addStar = info.star
    end
end

--外框
function M:getFrame()
    local star = self.star
    return Tool.getFrame(star)
end

function M:redPointQianHua()
	local ret = Tool.isUsedGhost(self.key)
	if ret == nil or ret == false then return false end 
	
	if self.lv < Player.Info.level * 2 then 
		local ghostLevelUpCost = TableReader:TableRowByUnique("ghostLevelUpCost", "level", self.lv + 1)
		local money = ghostLevelUpCost[self.kind .. self.star]
		if Player.Resource.money > money then 
			return true 
		else 
			return false
		end 
	else 
		return false 
	end 
end 

--精炼红点
function M:redPointJingLian()
    local linkData = Tool.readSuperLinkById(239)
    local limitLv = linkData.unlock[0].arg
    if Player.Info.level<limitLv then return false end 
	local ret = Tool.isUsedGhost(self.key)
	if ret == nil or ret == false then return false end 
    local row= TableReader:TableRowByID("ghostArgs", "ghost_powerup_maxlv")
    if self.power>=tonumber(row.arg) then 
        return false 
    end 
	-------------------------------------- 进阶材料------------------------------------------------------------------------
    local row = TableReader:TableRowByUniqueKey("ghostPowerUp", self.id, self.power + 1) 
    if row == nil then return end
    
    if  self.lv < row.level then
		return false
    end
    
    local consume = RewardMrg.getConsumeTable(row.consume)
    for i=1,#consume do
        local num = consume[i].rwCount
        local max = Tool.getCountByType(consume[i]:getType(), consume[i].id)
        if num > max then
			return false
       end
    end
	return true
end 

function M:getFrameNormal()
    local star = self.star
    return Tool.getFrame(star)
end

--获得强化列表
function M:getPowerUpList()
    local power = powerUpAttr[self.id]
    if power then

        return power
    end
    local list = {}
    for i = 1, self:getMaxPower() do
        row = TableReader:TableRowByUniqueKey("ghostPowerUp", self.id, i)
        if row and row.magic.Count > 0 then
            local magics = row.magic
            local len = magics.Count
            for j = 0, len - 1 do
                local magic = magics[j]
                if row["show_magic" .. (j + 1)] == 1 then
                    local _row = magic._magic_effect
                    local obj = {
                        name = string.gsub(_row.format, "{0}", magic.magic_arg1 / _row.denominator),
                        power = row.power,
                        arg = magic.magic_arg1
                    }
                    table.insert(list, obj)
                end
            end
        end
    end
    powerUpAttr[self.id] = list
    return list
end

--外框
function M:getFrameBig()
    local star = self.star
    local icon = "ji_xian1"
    if star == 2 then
        icon = "ji_xian1"
    elseif star == 3 then
        icon = "ji_xian2"
    elseif star == 4 then
        icon = "ji_xian3"
    elseif star == 5 then
        icon = "ji_xian4"
    elseif star == 6 then
        icon = "ji_xian5"
    end
    return icon
end

function M:getFrameBG()
    local star = self.star
    return Tool.getBg(star)
end

--获得描述
function M:getDesc(list)
    local li = {}
    local magic = self:getMagic()
    for i = 1, #magic do
        local v = magic[i]
        local num = v.arg + list[i]
        if num > 0 then
            num = v.arg + self.lv * v.arg2
            num = num + list[i]
            num = num / v.denominator
            local str = string.gsub(v.format, "{0}", num)
            table.insert(li, str)
        end
    end
    --    table.insert(li,1,self:getMainAttr())
    li[1] = self:getMainAttr()
    li[2] = "\n"..self:getProperty()
    return li
end

function M:getProperty()
    local desc = ""
    local row = TableReader:TableRowByUniqueKey("ghostPowerUp", self.id, self.power)
    if row == nil then return "" end 
    if row.magic == nil then return "" end 

    for i = 1, row.magic.Count - 1 do 
        local magic = row.magic[i]
        local format = "[ffff96]" .. magic._magic_effect.format 
        local temp = string.gsub(format, "{0}", "[-]"..magic.magic_arg1 / magic._magic_effect.denominator)
        desc = desc .. temp .. "\n"
    end 
    return desc
end 

--获得精炼属性
function M:getJLProperty()
	local desc = ""
	local row = TableReader:TableRowByUniqueKey("ghostPowerUp", self.id, self.power)
	if row == nil then return "" end 
	if row.magic == nil then return "" end 

	for i = 0, row.magic.Count - 1 do 
		local magic = row.magic[i]
		local format = "[ffff96]" .. magic._magic_effect.format 
		local temp = string.gsub(format, "{0}", "[-]"..magic.magic_arg1 / magic._magic_effect.denominator)
		desc = desc .. temp .. "\n"
	end 
	return desc
end 

--获得升星属性
function M:getSXPropetry()
   local equipInfo = Player.Ghost[self.key]
    local curExp = equipInfo.starExp
    local info = TableReader:TableRowByUniqueKey("ghostaddstar", self.id, 1)
    local desc = {}
    if info ~= nil then
        desc.type = "[ffff96]"..string.gsub(info.addstarmagic[0]._magic_effect.format, "{0}", "").."[-]"
        desc.value = 0
        desc.starNum = tonumber(equipInfo.star)
        if desc.starNum ~= nil and desc.starNum > 0 then 
            for i = 1, desc.starNum do
                local info = TableReader:TableRowByUniqueKey("ghostaddstar", self.id, i)
                desc.value = desc.value + (info.addexpmagic[0].magic_arg1 * info.exp) + info.addstarmagic[0].magic_arg1
            end
        end
        nextInfo = TableReader:TableRowByUniqueKey("ghostaddstar", self.id, desc.starNum + 1)
        if nextInfo ~= nil then
            desc.value =  desc.value + nextInfo.addexpmagic[0].magic_arg1 * math.floor(curExp)
        end
    else
        desc = nil
    end
    return desc
end

--获得主要信息，如果有洗练或者进阶的会算在一起
function M:getMainAttr(next)
    local magic = self:getMagic()[1]
    local num = magic.arg + magic.arg2 * (self.lv-1)
    if next then num = num + magic.arg2 end
    if self.xilian then--属于洗练的属性
        local len = self.xilian.Count
        if len > 0 then
            num = num + self.xilian[0]
        end
    end
    if self.power > 0 then--属于进阶属性的
        local row = TableReader:TableRowByUniqueKey("ghostPowerUp", self.id, self.power)
        num = num + row.magic[0].magic_arg1
        --num = row.show_clinet + num
    end

    local info = TableReader:TableRowByUniqueKey("ghostaddstar", self.id, 1)

    if info ~= nil then
        local sxp = self:getSXPropetry()
        num = num + sxp.value
        -- for i = 1, self.addStar do
        --     local info = TableReader:TableRowByUniqueKey("ghostaddstar", self.id, i)
        --     num = num + (info.addexpmagic[0].magic_arg1 * info.exp) + info.addstarmagic[0].magic_arg1
        -- end
    end

    return string.gsub(magic.format, "{0}","[ffffff]" .. num / magic.denominator .. "[-]")
end

--获得强化攻击力
function M:getQHAttr()
    local magic = self:getMagic()[1]
    local num = magic.arg + magic.arg2 * (Player.Ghost[self.key].level-1)
    return string.gsub(magic.format, "{0}","[ffffff]" .. num / magic.denominator .. "[-]")
end

function M:getPowerUpShowClient()
    local magic = self:getMagic()[1]
    local row = TableReader:TableRowByUniqueKey("ghostPowerUp", self.id, self.power)
    if row and row.magic then 
        if row.magic[0]["magic_arg1"] ~= nil then
            return string.gsub(magic.format, "{0}", row.magic[0]["magic_arg1"]) 
        end
    end
    return 0
end

function M:getShowClient(next)
    if self:isMaxPower() then return 0 end
    local row = TableReader:TableRowByUniqueKey("ghostPowerUp", self.id, self.power + (next == true and 1 or 0))
    if row then 
        return row.magic[0].magic_arg1--row.show_clinet 
    end
    return 0
end

function M:getMainArg()
    local magic = self:getMagic()[1]
    local num = magic.arg + magic.arg2 * self.lv
    if self.xilian then
        local len = self.xilian.Count
        if len > 0 then
            num = num + self.xilian[0]
        end
    end
    if self.power > 0 then
        local row = TableReader:TableRowByUniqueKey("ghostPowerUp", self.id, self.power)
        num = row.magic[0].magic_arg1
        --num = row.show_clinet + num
    end

    return num
end

function M:getMainAttrName()
    if not self._mainAttrId then
        local magic = self:getMagic()[1]
        self._mainAttrId = magic.name
    end
    return self._mainAttrId
end

function M:getMagic()
    if self.magic then return self.magic end
    local list = {}
    local magic = self.Table.magic
    for i = 0, magic.Count - 1 do
        local m = magic[i]
        local row = m._magic_effect
        local obj = {
            format = "[ffff96]" .. row.format .. "[-]",
            denominator = row.denominator,
            arg = m.magic_arg1,
            arg2 = m.magic_arg2,
            name = row.name
        }
        table.insert(list, obj)
    end
    self.magic = list
    return self.magic
end

function M:getSuitName()
	if self.suitName == nil then 
		local suit = TableReader:TableRowByID("equipsuit", self.Table.suitid)
		self.suitName = M:getItemColorName(self.star, suit.show_name)
	end 
	return self.suitName
end 

function M:getEquipSuit()
    local slot = Tool.getGhostOwer(self.key)
	local _hasList = {}
	if slot ~= nil then 
		local _ghost = Player.Ghost
		local postion = slot.postion
		local len = postion.Count
		for j = 0, len - 1 do
			local key = postion[j]
			if key ~= nil and key ~= "" and key ~= 0 and key ~= "0" then
				local id = _ghost[key].id
				table.insert(_hasList, id)
			end
		end
	end
	if self.suitList == nil then 
		self.suitCount = 0
		self.suitList = {}
		local suit = TableReader:TableRowByID("equipsuit", self.Table.suitid)
		for i = 0, suit.equips.Count - 1 do 
			local ghost = Ghost:new(suit.equips[i])
			if ghost ~= nil then
				for j = 1, #_hasList do 
					if _hasList[j] == ghost.id then 
						ghost.hasWear = 1
						self.suitCount = self.suitCount + 1
					end 
				end 
				table.insert(self.suitList, ghost)
			end 
		end
		local desc = ""
		for i = 0, suit.items.Count - 1 do 
			local item = suit.items[i]
			local eMagic = TableReader:TableRowByID("equipsuit_magic", item.magic)
			local tempStr = ""
			for j = 0, eMagic.magic.Count-1 do 
				local magic = eMagic.magic[j]
				local format = magic._magic_effect.format
				local temp = "+" .. magic.magic_arg1 / magic._magic_effect.denominator
				local str = string.gsub(format, "{0}", temp)
				tempStr = tempStr .. str .. "     "
			end 
			if item.count <= self.suitCount then 
				desc = desc .. "[ff2a2a]" .. item.count .. TextMap.GetValue("Text_1_2901") .. tempStr .. "\n[-]"		
			else 
				desc = desc .. item.count .. TextMap.GetValue("Text_1_2901") .. tempStr .. "\n"		
			end 
		end
		self.suitDesc = desc
	end 
	return self.suitList
end 

function M:getSimpleDes()
    if self.magic then return self.magic end
    local list = {}
    local magic = self.Table.magic
    for i = 0, magic.Count - 1 do
        local m = magic[i]
        local row = m._magic_effect
        local obj = {
            format = row.format,
            denominator = row.denominator,
            arg = m.magic_arg1,
            arg2 = m.magic_arg2,
            name = row.name
        }
        table.insert(list, obj)
    end
    self.magic = list
    return self.magic
end

function M:isKeHeCheng()
    if self._costList == nil then
        local row = TableReader:TableRowByID("ghostPiece", self.id)
        if row == nil then return false end
        local consume = row.consume
        self._costList = RewardMrg.getConsumeTable(consume)
    end
    local r = true
    for i = 1, #self._costList do
        local it = self._costList[i]
        it:updateInfo()
        if it.count < it.rwCount then
            r = false
        end
    end
    return r
end

function M:init(id, key)
    self.Table = TableReader:TableRowByID("ghost", id);
    if self.Table == nil then
        self.Table = TableReader:TableRowByUnique("ghost", "name", id)
    end
    if self.Table == nil then
        print("表不存在。" .. id)
        return
    end
    self.star = self.Table.star
    self.name = self.Table.show_name
    self.id = self.Table.id
    self.desc = self.Table.desc
    --    self.color = self.Table.color
    self.kind = self.Table.kind
    self.power = 0
    self.lv = 1
    self.key = key
    self.color = self.Table._color.color
    self:updateInfo()
end

function M:new(id, key)
    local o = {}
    setmetatable(o, self)
    self.__index = self
    o:init(id, key)
    return o
end

return M