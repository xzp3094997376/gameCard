
--宝物
local M = {}
local treasure_max_lv = nil
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
    TableReader:ForEachTable("treasurePowerUp",
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

function M:isMaxPower()
    return self.power >= self.getMaxPower()
end

function M:redPointQianHua()
	local ret = Tool.isUsedTreasure(self.key)
	if ret == nil or ret == false then return false end 
	
	local unUse = Tool.getUnUseTreasure()
    local canCost = {}
    for k,v in pairs(unUse) do
        if v.value.power <= 0 and v.key ~= "" then
			local tb = TableReader:TableRowByID("treasure", v.value.id);
			if tb.can_lvup_yjtj_auto == 1 or tb.can_lvup_yjtj == 1 then 
				return true
			end 
        end
    end
    return false
end 

function M:redPointJingLian()
	local ret = Tool.isUsedTreasure(self.key)
	if ret == nil or ret == false then return false end 
	
	local ret = false
	-------------------------------------- 进阶材料------------------------------------------------------------------------
    local row = TableReader:TableRowByUniqueKey("ghostPowerUp", self.id, self.power + 1) 
    if row == nil then return end
    
    if  self.lv < row.level then
		return false
    end

    local consume = RewardMrg.getConsumeTable(row.consume)
    local list = {}
    table.foreach(consume, function(i, v)
        local t = v:getType()
        local num = v.rwCount
        local max = Tool.getCountByType(v:getType(), v.id)
        if num > max then
            ret = false
			return ret
        end
    end)
	return true
end 

--最大强化等级
function M:getMaxLv()
    if treasure_max_lv == nil then
        treasure_max_lv = TableReader:TableRowByID("treasureArgs", "treasure_max_lv").arg
    end
    return treasure_max_lv
end

--判断是否强化到顶级
function M:isMaxLv()
    return self.lv >= self:getMaxLv()
end

--当前的最大强化等级
local maxLvUp_arg = nil
local maxLvUp_arg2 = nil
function M:getCurMaxLv()
    if maxLvUp_arg == nil then
        local ghost_levelUp = TableReader:TableRowByID("treasureArgs", "treasure_levelup_present")
        maxLvUp_arg = ghost_levelUp.arg
        maxLvUp_arg2 = ghost_levelUp.arg2
    end

    return Player.Info.level * maxLvUp_arg - maxLvUp_arg2
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

--ui中显示的名字，带进阶等级
function M:getDisplayName()
    local name = self.name
    if self.power > 0 then 
        return Tool.getNameColor(self.Table.star) .. name .. "[-][24FC24] +" .. self.power .. "[-]"
    else 
        return Tool.getNameColor(self.Table.star) .. name .. "[-]"
    end
    
end

--ui中显示角色名字，带颜色
function M:getDisplayColorName()
    local name = self.name
    if self.power > 0 then 
        return Tool.getNameColor(self.Table.star) .. name .. "[-][24FC24] +" .. self.power .. "[-]"
    else 
        return Tool.getNameColor(self.Table.star) .. name .. "[-]"
    end
end

function M:getWearCharName()
    local charName = ""
    
end

function M:updateInfo()
    if self.key ~= nil then
        local info = Player.Treasure[self.key]
        self.info = info
        self.lv = info.level   --强化的等级
        if self.lv <= 0 then self.lv = 1 end
        self.exp = info.exp
        self.power = tonumber(info.power or 0)  --精炼等级
        self.onPosition = info.onPosition
    end
end


--外框
function M:getFrame()
    local star = self.star
    return Tool.getFrame(star)
end

function M:getFrameNormal()
    local star = self.star
    return Tool.getFrame(star)
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



function M:getMagic()
    if self.magic then return self.magic end
    local list = {}
    local magic = self.Table.magic
    for i = 0, magic.Count - 1 do
        local m = magic[i]
        local row = m._magic_effect
        local obj = {
            format = row.format,
            denominator = row.denominator,
            arg = m.magic_arg1 ,
            arg2 = m.magic_arg2 ,
            name = row.name
        }
        table.insert(list, obj)
    end
    self.magic = list
    return self.magic
end

function M:getMaxJinglianLv()
    local jlv = 0
    TableReader:ForEachLuaTable("treasurePowerUp",function(k,v) 
        if v.name == self.id then
            jlv = jlv + 1
        end
        return false
    end)
    return jlv
end

function M:getMagic_JL(_power)
    local list = {}
    local magic
    local allPower =  self.power + _power
    if allPower >= 0 then
        if allPower > self:getMaxJinglianLv() then
            allPower = self:getMaxJinglianLv()
        end 
		local tb = TableReader:TableRowByUniqueKey("treasurePowerUp", self.id, allPower)
		if tb ~= nil then 
			magic = tb.magic
		end 
        if magic == nil then return end
        for i = 0, 1 do  --magic.Count - 1
            local m = magic[i]
            local row = m._magic_effect
            local obj = {
                format = row.format,
                denominator = row.denominator,
                arg = m.magic_arg1 / row.denominator,
                name = row.name
            }
            table.insert(list, obj)
        end
    else
        table.insert(list, self:getMagic()[3])
        table.insert(list, self:getMagic()[4])
    end
    return list
end

function M:GetImmortalitySkill()
    local des = ""
    local list = {}
    if self.star == 6 then
        TableReader:ForEachLuaTable("treasurePowerUp",function(k,v) 
            if v.name == self.id then
                if v.extra_num~=nil and v.extra_num > 0 then
                    local magic = v.magic
                    if magic ~= nil then
                        for i=2,magic.Count - 1 do
                            local m = magic[i]
                            local row = m._magic_effect
                            local obj = {
                                format = "[ffff96]"..row.format.."[-]",
                                denominator = row.denominator,
                                arg = m.magic_arg1 / row.denominator,
                                name = row.name,
                                des = v.skill_desc,
                                active = self.power >= v.power
                            }
                            table.insert(list, obj)
                        end
                    end
                end
            end
            return false
        end)
        if #list > 0 then
            for k,v in pairs(list) do
                local num = v.arg
                --local col = "[8f8f8f]"
                --if v.active then col = "[ffffff]" end
                if k == 1 then
                    des = string.gsub(v.format, "{0}", "[ffffff]" .. num / v.denominator .. "[-]").." "..v.des
                else
                    des = des.."\n"..string.gsub(v.format, "{0}", "[ffffff]" .. num / v.denominator .. "[-]").." "..v.des
                end
            end
        end
    end
    return des
end


function M:GetFurtureBaseProperty(levels)
    local list = {}
	print("levels = " .. levels)
    local base_p = ""
    local magic = self:getMagic()[1]
    local num = (magic.arg + magic.arg2 * (self.lv - 1))/magic.denominator
    local num_new = (magic.arg2 * levels) /magic.denominator
    local tb =split(magic.format, "{0}")
    if tb[2] ~=nil then
        num_new = num_new .. tb[2]
    end
    base_p =string.gsub("[ffff96]" .. magic.format.."[-]", "{0}", "[-][ffffff]" .. num)
    table.insert(list, {base=base_p,add=num_new})
    
    local magic2 = self:getMagic()[2]
    local num2 = (magic2.arg + magic2.arg2 * (self.lv - 1))/magic2.denominator
    local num2_new = (magic2.arg2 * levels)/magic2.denominator
    local tb =split(magic2.format, "{0}")
    if tb[2] ~=nil then
        print(string.sub(magic2.format, -4,-4))
        num2_new = num2_new .. tb[2]
    end

    base_p =string.gsub("[ffff96]" .. magic2.format .. "[-]", "{0}", "[-][ffffff]" .. num2)
    table.insert(list, {base=base_p,add=num2_new})
    return list
end


function M:GetTreasureBaseProperty(newxP)
    local base_p = ""
    local magic = self:getMagic()[1]
    local magic2 = self:getMagic()[2]
	if magic ~= nil then 
		local num = magic.arg + magic.arg2 * ((self.lv - 1) + newxP)
		base_p =  string.gsub("[ffff96]"..magic.format.."[-]", "{0}", "[ffffff]" .. (num / magic.denominator))
    end
	if magic2 ~= nil then 
		--local magic2 = self:getMagic()[2]
		local num2 = magic2.arg + magic2.arg2 * ((self.lv - 1) + newxP)
		base_p = base_p.."\n"..string.gsub("[ffff96]"..magic2.format.."[-]", "{0}", "[ffffff]" .. (num2 / magic2.denominator))
	end 
	return base_p
end

function M:GetTreasureJLProperty(newxP,isGreen)
    local jl_p = ""
	local tb = self:getMagic_JL(newxP)
	if tb == nil then return "" end 
	local magic = tb[1]
	if magic == nil then return "" end 
    local num = magic.arg/magic.denominator
    if isGreen~=nil and isGreen==true then 
        jl_p =  string.gsub("[ffff96]"..magic.format.."[-]", "{0}", "[24FC24]" .. num) --/ magic.denominator)
    else 
        jl_p =  string.gsub("[ffff96]"..magic.format.."[-]", "{0}", "[ffffff]" .. num) --/ magic.denominator)
    end 
    
    local magic2 = self:getMagic_JL(newxP)[2]
    local num2 = magic2.arg/magic2.denominator
    if isGreen~=nil and isGreen==true then 
        jl_p = jl_p.."\n"..string.gsub("[ffff96]"..magic2.format.."[-]", "{0}", "[24FC24]" .. num2) --/ magic2.denominator)
    else 
        jl_p = jl_p.."\n"..string.gsub("[ffff96]"..magic2.format.."[-]", "{0}", "[ffffff]" .. num2) --/ magic2.denominator)
    end 
    return jl_p
end

function M:GetCharIDandPos()
    local data = {}
    local alltreasure = Player.Treasure
    local allchars = Player.Chars:getLuaTable()
    for k,v in pairs(allchars) do
        if v.treasure ~= nil then
            for i=0,v.treasure.Count do
                if v.treasure[i] == tonumber(self.key) then
                    data.pos = i
                    data.charid = k                 
                    return data
                end
            end
        end
    end
    return data
end

function M:getLevelAllExp()
    local allexp = self.exp
    if self.lv > 1 then
        for i=1,self.lv-1 do
            local lvConfig = TableReader:TableRowByUnique("treasureLevelUp","level",i)["t"..self.star]
            if lvConfig ~= nil then
                allexp = allexp + lvConfig
            end
        end 
    end
    return allexp
end

function M:GetTotalExp(lv, star_level)
    if (lv == nil) then return 0 end
    local allexp = 0
    for i=self.lv,lv do
        local lvConfig = TableReader:TableRowByUnique("treasureLevelUp","level",i)["t"..self.star]
        if lvConfig ~= nil then
            allexp = allexp + lvConfig
        end
    end 
    return allexp
end

function M:getTreasureKindName()
    if self.kind == "gong" then
        return TextMap.GetValue("Text1749")
    elseif self.kind == "fang" then
        return TextMap.GetValue("Text1750")
    elseif self.kind == "jing" then
        return TextMap.GetValue("Text1759")
    end
    return ""
end

function M:getTreasureExp()
    local expConfig = TableReader:TableRowByID("treasureConversion", self.id)
    local all_exp = self:getLevelAllExp()
    if expConfig ~= nil then
        all_exp = all_exp+expConfig.conversion_exp
    end
    return all_exp
end

function M:init(id, key)
    self.Table = TableReader:TableRowByID("treasure", id);
    if self.Table == nil then
        self.Table = TableReader:TableRowByUnique("treasure", "name", id)
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