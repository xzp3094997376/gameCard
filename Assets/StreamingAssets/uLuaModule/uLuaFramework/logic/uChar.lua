--角色类

local Char = {}

local attrNameColor = "[ffef3e]" --属性名颜色
local attrValueColor = "[00ff00]" --属性数值颜色
local attrFiexColor = "[4ad919]" --属性修正值颜色

----------------------------------------------- 角色属性字符---------------------------------------------------------------

local Attr =
{
    hp = "MaxHpV", --生命
    pAtk = "PhyAtkV", --物理攻击
    pDef = "PhyDefV", --物理防御
    mAtk = "MagAtkV", --法术攻击
    mDef = "MagDefV", --法术防御
    hp_factor = "MaxHpFactor",
    phy_atk_factor = "PhyAtkFactor", --物攻资质
    phy_def_factor = "PhyDefFactor", --物防资质
    mag_atk_factor = "MagAtkFactor", --法攻资质
    mag_def_factor = "MagDefFactor", --法防资质
    block = "BlockC", --格挡
    block_imm = "ImmBlockC", --破挡
    dodge = "DodgeC", --闪避
    hit = "HitC", --命中
    crit = "CritC", --暴击
    crit_imm = "ImmCritC" --抗暴
}

local AttrNewDescList = 
{
	"MaxHp", --生命
	"PhyAtk", --物理攻击
	"MagAtk", --法术攻击
	"PhyDef", --物理防御
	"MagDef"  --法术防御
}

local AttrDescList =
{
    "MaxHpV", --生命
    "MaxHpFactor", --生命资质
    "PhyAtkV", --物理攻击
    "PhyAtkFactor", --物攻资质
    "MagAtkV", --法术攻击
    "MagAtkFactor", --法攻资质
    "PhyDefV", --物理防御
    "PhyDefFactor", --物防资质
    "MagDefV", --法术防御
    "MagDefFactor", --法防资质
    "",
    "",
    "Anger", --初始怒气
    "MaxAnger", --怒气上限
    "AngerEachRound", --变身维持怒气
    "HitC", --命中
    "DodgeC", --闪避
    "BlockC", --格挡
    "ImmBlockC", --破挡
    "CritC", --暴击
    "ImmCritC", --抗暴
    "HealC", --治疗率
    "HealBonusC", --被治疗率
    "PhyDmgDecP", --物理免伤
    "MagDmgDecP", --灵术免伤
    "EndDmgIncP", --最终伤害
    "EndDmgDecP", --最终免伤
	"MaxHp", --生命
	"PhyAtk", --物理攻击
	"MagAtk", --法术攻击
	"PhyDef", --物理防御
	"MagDef"  --法术防御
}

local AttrDescWithP =
{
    MaxHpP = "MaxHpV",
    PhyAtkP = "PhyAtkV",
    PhyDefP = "PhyDefV",
    --MagAtkP = "MagAtkV",
    MagDefP = "MagDefV",
    -- MagDmgIncP = "",
    -- PhyDmgIncP = "",
    -- MagDmgDecP = "MagDefV",
    -- PhyDmgDecP = "PhyDefV",
    -- EndDmgIncP = "",
    -- EndDmgDecP = ""
}

local AttrPToV = {
    MaxHpV = "MaxHpP",
    PhyAtkV = "PhyAtkP",
    MagDefV = "MagDefP",
    MagAtkV = "MagAtkP",
    PhyDefV = "PhyDefP",
}

function GetAttr(attr, propertys, isId, pre, n)
    n =  0
    pre = pre or ""
    local row = nil
    if isId == "id" then
        row = TableReader:TableRowByID("magics", attr)
    else
        row = TableReader:TableRowByUnique("magics", "name", attr)
    end
	--local jiban = self:getSkillAttr()
	
    if row == nil then return "" end
    local desc = ""
    if propertys.Count == nil then
        local arg1 = propertys[row.id] + n
        if pre and math.floor(arg1 / row.denominator) == 0 then return "" end
		
		--if AttrPToV[attr] then
		--	local prow = TableReader:TableRowByUnique("magics", "name", AttrPToV[attr])
		--	arg1 = arg1 * (1+(propertys[prow.id] / 1000))
		--end
	
        desc = string.gsub("[ffff96]" .. row.format .. "[-]", "{0}", "[ffffff]" .. pre .. math.floor(arg1 / row.denominator) .. "[-]")
    else
        if propertys.Count > row.id then
            local arg1 = propertys[row.id] + n
            if pre and math.floor(arg1 / row.denominator) == 0 then return "" end
			
			--if AttrPToV[attr] then
			--	local prow = TableReader:TableRowByUnique("magics", "name", AttrPToV[attr])
			--	arg1 = arg1 * (1+(propertys[prow.id] / 1000))
			--end
		
            desc = string.gsub("[ffff96]" .. row.format .. "[-]", "{0}", "[ffffff]" .. pre .. math.floor(arg1 / row.denominator) .. "[-]")
        end
    end

    --    desc = desc .. "\n"
    return desc or ""
end


function GetAttrNew(attr, propertys, isGreen)
    local row = TableReader:TableRowByUnique("magics", "name", attr)
    if row == nil then return "" end
    local desc = ""
	local arg1 = 0
    if propertys.Count == nil then
        arg1 = propertys[row.id]
        --if pre and math.floor(arg1 / row.denominator) == 0 then return "" end
		arg1 = math.floor(arg1 / row.denominator)
		--arg1 = arg1 / row.denominator
		arg1 = math.floor(arg1)
        if isGreen ~= nil and isGreen == true then 
            desc = string.gsub("[ffff96]" .. row.format .. "[-]", "{0}", "[24FC24]" .. arg1 .. "[-]")
        else 
            desc = string.gsub("[ffff96]" .. row.format .. "[-]", "{0}", "[ffffff]" .. arg1 .. "[-]")
        end 
    else
        if propertys.Count > row.id then
            arg1 = propertys[row.id]
            --if pre and math.floor(arg1 / row.denominator) == 0 then return "" end
			arg1 = math.floor(arg1 / row.denominator)
			arg1 = math.floor(arg1)
            if isGreen~=nil and isGreen==true then 
                desc = string.gsub("[ffff96]" .. row.format .. "[-]", "{0}", "[24FC24]" .. arg1 .. "[-]")
            else 
                desc = string.gsub("[ffff96]" .. row.format .. "[-]", "{0}", "[ffffff]" .. arg1 .. "[-]")
            end 
        end
    end
    return arg1, desc or ""
end

------------------------------------------------------------------------------------------------------------------------

--通过等级快速读取角色升级所需经验
--@prame lv角色等级
--@return 经验值
--[[
function GetCharExp(lv)
    if (lv == nil) then return 1 end
    local item = TableReader:TableRowByUnique("charExp", "lv", lv)
    if (item ~= nil) then return item.exp_d[1] end
    return 1
end]]
function GetCharExp(lv, star_level)
    if (lv == nil) then return nil end
    local item = TableReader:TableRowByUnique("charExp", "lv", lv)
    if (item ~= nil) then
        --if tonumber(star_level) < 3 then star_level = 3 end
        return item["exp_d_" .. star_level]
    end
    return nil
end

function GetCharTotalExp(lv, star_level)
    if (lv == nil) then return nil end
    local item = TableReader:TableRowByUnique("charExp", "lv", lv)
    if (item ~= nil) then
        --if tonumber(star_level) < 3 then star_level = 3 end
        return item["exp_" .. star_level]
    end
    return nil
end


--类型
function Char:getType()
    return "char"
end


function Char:GetAttrByChar(attr)
    local row = TableReader:TableRowByUnique("magics", "name", attr)
    local arg1 = self.info.propertys[row.id]
	if arg1 == nil then 
		print("卡片属性里没有：" .. attr .. "  id: " .. row.id)
	end 
	arg1 = arg1 / row.denominator
	arg1 = math.floor(arg1)
	local desc = string.gsub("[ffff96]".. row.format .. "[-]", "{0}", "[ffffff]" .. arg1 .. "[-]")
    return arg1, desc
end

--阵容界面显示属性
function Char:getAttrSingleForGhost(attr, num)
    self:updateInfo() 
    local row = TableReader:TableRowByUnique("magics", "name", attr)
    local arg1 = self.info.propertys[row.id]
	arg1 = arg1 / row.denominator
	arg1 = math.floor(arg1)
	--arg1 = arg1 + self:getTypeProForHuaShen(row.cnName, self.id, self.dictid)
    -- if num > 0 then
    --     arg1 = arg1 + num
    -- end
	local newColor = "[9a4c1e]" ..row.format .. "[-]"
	arg1 = "[3b1c0a]" .. arg1 .. "[-]"
    local desc = string.gsub(newColor, "{0}", "[ffffff]" .. arg1 .. "[-]")
    return desc
end

function Char:getFactor(attr)
	local factor = 0
	if attr == "MaxHpV" then 
		factor = self.hp_factor
	elseif attr == "PhyAtkV" then 
		factor = self.phy_atk_factor
	elseif attr == "PhyDefV" then 
		factor = self.phy_def_factor
	elseif attr == "MagDefV" then 
		factor = self.mag_def_factor
	end 
	return factor
end 

function Char:getDiffLvUp(attr, lv)
	local add = lv * self:getFactor(attr)
	if AttrPToV[attr] then
		local prow = TableReader:TableRowByUnique("magics", "name", AttrPToV[attr])
		add = add * (1+(self.info.propertys[prow.id] / 1000))
	end
	return math.floor(add)
end

function Char:getDiffAttr(attrp, vDiff, zzDiff)
    local row = TableReader:TableRowByUnique("magics", "name", attrp)
	print("attrp = " .. attrp)
    local arg1 = self.info.propertys[row.id]
	print("value = " .. arg1)
	local add =( vDiff + zzDiff * self.lv )*(1+(arg1 / 1000))
	add = math.floor(add)
	return add
end 

function Char:getAttrSingle(attr, isnum)
    if isnum then
        local row = TableReader:TableRowByUnique("magics", "name", attr)
        local arg1 = self.info.propertys[row.id]
		arg1 = arg1 / row.denominator
        --if AttrPToV[attr] then
		--	local prow = TableReader:TableRowByUnique("magics", "name", AttrPToV[attr])
		--	arg1 = arg1 * (1+(self.info.propertys[prow.id] / 1000))
		--	
        --    local bloodArg = self:getBlood()
        --    local xiLian = self:getXiLianDesc()
        --    local jiban = self:getSkillAttr()
        --    local n = 0
		--	--print("blood")
		--	--print_t(bloodArg)
		--	--print("xilian")
		--	--print_t(xiLian)
		--	--print("jiban")
		--	--print_t(jiban)
        --    --if xiLian[attr] then
        --    --    n = xiLian[attr]
		--	--	print("______xilian: " .. xiLian[attr])
        --    --end
        --    if jiban[attr] then
        --        n = n + jiban[attr]
        --    end
        --    --if bloodArg[attr] then
        --    --    n = n + bloodArg[attr]
        --    --end
        --    arg1 = arg1 / row.denominator
        --    arg1 = arg1 * (1000 + n) / 1000
        --    arg1 = math.floor(arg1)
        --end
		arg1 = math.floor(arg1)
        return arg1, "[ffff96]".. row.format .. "[-]"
    else
        return self:GetAttrByChar(attr)
    end
end

function Char:getAttrList(ids, propertys, pre)
    local list = {}

    table.foreach(ids, function(i, v)
        local desc = GetAttr(v, propertys, "id", pre)
        if desc ~= "" then
            table.insert(list, desc)
        end
    end)
    return list
end

function Char:getAttrListNew(ids, propertys)
	local list = {}
    table.foreach(ids, function(i, v)
        local desc = GetAttrNew(v, propertys)
        if desc ~= "" then
            table.insert(list, desc)
        end
    end)
    return list
end 

--角色描述
function Char:getDesc()
    return self.Table.desc
end

--洗练属性
function Char:getXiLianDesc()
    --    if self.lv < 10 then return {} end
    local list = {}
    local luaAttach = self:getAttach()
    TableReader:ForEachLuaTable("charXilianRange", 
	function(k, v)
		if v ~= nil then
			local _type = v._magic_effect.name
			if _type ~= nil and _type ~= "" then
				if luaAttach[k] ~= nil then 
					table.insert(list, luaAttach[k])
				end
			end
		end
		return false
	end)
    return list
end

function Char:getSkillAttr()
    local fetterList = self:getFetter(self.id)
    if fetterList == nil then print("list is nil") return nil end
    local skillsAttrList = {}
    skillsAttrList["PhyAtkV"] = 0
    skillsAttrList["MagDefV"] = 0
    skillsAttrList["MagAtkV"] = 0
    skillsAttrList["PhyDefV"] = 0
    skillsAttrList["MaxHpV"] = 0
    for i = 1, #fetterList do
        if fetterList[i] ~= nil then
            local tb = TableReader:TableRowByID("relationship", fetterList[i])
            if tb.script_arg ~= nil then
                for j = 0, tb.script_arg.Count - 1, 3 do
                    local magic = tb.script_arg[j]
                    local arg = tb.script_arg[j + 1]
                    local arg2 = tb.script_arg[j + 2]
                    if magic ~= nil then
                        local row = TableReader:TableRowByUnique("magics", "cnName", magic)
                        if AttrDescWithP[row.name] then
                            skillsAttrList[AttrDescWithP[row.name]] = skillsAttrList[AttrDescWithP[row.name]] + arg
                        end
                    end
                end
            end
        end
    end
    return skillsAttrList
end

function Char:getBlood()
    -------------------------------------------------------- 血脉---------------------------------------------------
    local bloodArg = {}
    local bloodline = Player.Chars[self.id].bloodline
    if bloodline == nil then
        return bloodArg
    end
    local lv = bloodline.level
    local attr = TableReader:TableRowByUniqueKey("bloodlineArg", lv, self.star)
    local magics = attr.magic

    local it = nil

    for i = 0, magics.Count - 1 do
        it = magics[i]
        if AttrDescWithP[it._magic_effect.name] then
            bloodArg[AttrDescWithP[it._magic_effect.name]] = it.magic_arg1
        end
    end
    return bloodArg
    -----------------------------------------------------------------------------------------------------------------
end

function Char:getTreasure()
    local char_id = self.id
    local treasure = Player.Treasure
    local treasureSlot = Player.Chars[char_id].treasure 
    self.treasureArg = {}

    for i=1,2 do
        local key = treasureSlot[i-1]
        if key ~= "" and key ~= nil and key ~= 0 and key ~= "0" then
            if treasure[key] ~= nil then
                local ts = Treasure:new(treasure[key].id, key)
                for _s=1,2 do
					print("baowu...............")
                    self:CalculateTreasureProperty(ts:getMagic()[_s],ts.lv)
                    self:CalculateTreasureProperty_JL(ts:getMagic_JL(0)[_s])                   
                end
                self:CalculateImmortalityProperty(ts)
            end
        end      
    end

    self.treasureArg2 = {}
    local tre_MHP1 = 0
    local tre_PAP2 = 0
    local tre_PDP3 = 0
    local tre_MAP4 = 0
    local tre_MDP5 = 0
    for k,v in pairs(self.treasureArg) do
        if v.name == "MaxHpV" then
            tre_MHP1 = tre_MHP1 + v.value
        elseif v.name == "PhyAtkV" then
            tre_PAP2 = tre_PAP2 + v.value
        elseif v.name == "PhyDefV" then
            tre_PDP3 = tre_PDP3 + v.value
        elseif v.name == "MagAtkV" then
            tre_MAP4 = tre_MAP4 + v.value
        elseif v.name == "MagDefV" then
            tre_MDP5 = tre_MDP5 + v.value
        end
    end

    self.treasureArg2["MaxHpV"] = tre_MHP1
    self.treasureArg2["PhyAtkV"] = tre_PAP2
    self.treasureArg2["PhyDefV"] = tre_PDP3
    self.treasureArg2["MagAtkV"] = tre_MAP4
    self.treasureArg2["MagDefV"] = tre_MDP5
end


function Char:CalculateTreasureProperty(magic,level)
    local num = magic.arg + magic.arg2 * level
    local data = {}
    data.name =  magic.name
    --print("....属性名字...."..magic.name)
    data.value = num / magic.denominator
	if data.name ~= nil then 
		table.insert(self.treasureArg, data)
    end
end

function Char:CalculateTreasureProperty_JL(magic)
	if magic == nil then return end 
    local num = magic.arg
    local data = {}
    data.name =  magic.name
    --print("....属性名字...."..magic.name)
    data.value = num / magic.denominator
    --print("....属性大小...."..num / magic.denominator)
    local attr = AttrDescWithP[data.name]
    if attr ~= nil and attr ~= "" then
        data.name = attr
        table.insert(self.treasureArg,data)
    end
end

function Char:CalculateImmortalityProperty(treasure)
    --print("........Start........."..treasure.id)
    if treasure.star == 6 then
        TableReader:ForEachLuaTable("treasurePowerUp",function(k,v) 
            if v.name == treasure.id then
                if v.extra_num > 0 and treasure.power >= v.power then
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
                            local attr = AttrDescWithP[data.name]
                            if attr ~= nil and attr ~= "" then
                                data.name = attr
                                table.insert(self.treasureArg,data)
                            end
                            --print(v.name.."????"..data.name)
                        end
                    end
                end
            end
            return false
        end)
    end
end

function Char:getAttrCultivateDesc()
    local info = self.info
    local propertys = info.propertys
    local desc = {}
    TableReader:ForEachLuaTable("charXilianRange", function(i, v)
        local d = ""
        if v == "" then
            table.insert(desc, "\n")
        else
            local row = TableReader:TableRowByID("magics", v.id)
			
			if propertys.Count > row.id then
                local arg1 = propertys[row.id] / row.denominator
                arg1 = arg1 * (1000) / 1000
                local n = math.floor(arg1)
                if n > 0 then
                    d = row.format
                end
            end
			
            if d ~= "" then
                table.insert(desc, d .. "\n")
            end
        end
		return false
    end)
    return desc
end

--角色属性描述（升级进化界面，英雄属性界面）
function Char:getAttrDesc()
	--print("升级： 英雄属性")
    local info = self.info
    local propertys = info.propertys
    local tran = {}
    local desc = {}

    table.foreach(AttrNewDescList, function(i, v)
        local d = ""
        if v == "" then
            table.insert(desc, "\n")
        else
            local row = TableReader:TableRowByUnique("magics", "name", v)
			if propertys.Count > row.id then
				local rate = propertys[row.id] or 0
                local arg1 = rate / row.denominator
				arg1 = math.floor(arg1)
                --arg1 = arg1 + self:getTypeProForHuaShen(row.cnName, self.id, self.dictid)
                --arg1 = arg1 * (1000 + at_num + num) / 1000
                --local n = math.floor(arg1)
                --if n > 0 then
					local newColor = "[ffff96]" .. row.format .. "[-]"
                    d = string.gsub(newColor, "{0}", "[ffffff]" .. arg1 .. "[-]")
                --end
            end
            if d ~= "" then
                table.insert(desc, d .. "\n")
            end
        end
    end)
    return desc
end


--升级所需要的经验
function Char:exp()
    return GetCharExp(self.lv, self.quality)
end

--当前所拥有的灵子数
function Char:maxExp()
    return Player.Resource.soul
end

--经验信息
--@return { desc = "显示经验值xx/xx",value = "进度条的值(0~1)" }
function Char:expInfo()
    local exp = self:exp() or 1
    local max = self:maxExp()

    return
    {
        desc = exp,
        value = max / exp
    }
end

--角色图片
function Char:getImage(ret)
    --    if (self._img) then return self._img end
    local key = "full_img_d"
    if ret == true then key = "full_img_t" end
    local img = self.modelTable[key]
    if (img == "" or img == nil) then img = "default" end
    self._img = UrlManager.GetImagesPath("cardImage/" .. img .. ".png")
    return self._img
end

--角色小头像
function Char:getHead()
    if (self._head) then return self._head end
    local img = self.modelTable.head_img

    if (img == "" or img == nil) then img = "default" end

    self._head = UrlManager.GetImagesPath("headImage/" .. img .. ".png")
    return self._head
end

--获取头像贴图名字
function Char:getHeadSpriteName()
    local img = self.modelTable.head_img
    if (img == "" or img == nil) then img = "default" end
    return img
end

--获取角色的灵魂石对象
--@return CharPiece
function Char:getPiece()
    if (self.piece ~= nil) then return self.piece end
    self.piece = CharPiece:new(self.dictid)
    return self.piece
end

--获取角色的技能信息
function Char:getSkill()
    --角色技能等级
    local skills = self.info.skill:getLuaTable()
    self.skills = skills
    if self._skills == nil then
        self._skills = {}
        local sk_list = self.modelTable.skill
        local sk

        for i = 0, sk_list.Count - 1 do
            if i < 6 then
                if sk_list[i] ~= "" then
                    sk = Skill:new(sk_list[i], self, i)
                    --                self._skills[i + 1] = sk
                    table.insert(self._skills, sk)
                end
            end
        end
    else
        table.foreachi(self._skills, function(i, v)
            v:updateInfo(self)
        end)
    end

    return self._skills
end

--获取身上是否穿了装备
function Char:isHaveVest()
    local charEquips = self.info.equip or {} --身上的装备
    for i = 1, 6 do
        if (charEquips[i - 1].id ~= 0) then
            return true
        end
    end
    return false
end

--获得装备
function Char:getEquipsByInfo(list)
	--if self.equips ~= nil then  return self.equips end 
    local tb = TableReader:TableRowByUniqueKey("powerUp", self.Table.powUpId, self.stage)
    if tb == nil then
        print("数据错误,没有配突破表：" .. self.name .. " ->" .. self.dictid .. " stage->" .. self.stage)
        return {}
    end
    local equip_id = tb.equipid

    local len = equip_id.Count
    local equipsList = {}

    local charEquips = list or {} --身上的装备
    for i = 1, len do
        local id = equip_id[i - 1]
        local equip = Equip:new(id)
        equip:forChar(self)

		for j = 1, #list do 
			if (charEquips[j] ~= nil and id == charEquips[j].id) then
				equip:setChar(self, i - 1)
			end
		end
        equipsList[i] = equip
    end

    self.equips = equipsList
    return self.equips
end

--获得装备
function Char:getEquips(refresh)
    if not refresh then 
		if self.equips ~= nil then return self.equips end
	else 
		self:updateInfo()
	end 
    local tb = TableReader:TableRowByUniqueKey("powerUp", self.Table.powUpId, self.stage)
    if tb == nil then
        print("数据错误,没有配突破表：" .. self.name .. " ->" .. self.dictid .. " stage->" .. self.stage)
        return {}
    end
    local equip_id = tb.equipid

    local len = equip_id.Count
    local equipsList = {}

    local charEquips = self.info.equip or {} --身上的装备
    for i = 1, len do
        local id = equip_id[i - 1]
        local equip = Equip:new(id)
        equip:forChar(self)
        if (charEquips[i - 1].id ~= 0) then
            equip:setChar(self, i - 1)
        end

        equipsList[i] = equip
    end

    self.equips = equipsList
    return self.equips
end

function Char:redPointForJueXing()
    --角色等级过滤
    if self.lv < Player.Info.level - 20 then
        return false
    end
	--可突破
	local ret = false
	local equips = self:getEquips()
    local charEquips = self.info.equip or {} --身上的装备
    local count = 0
    for i = 1, #equips do
        if (charEquips[i - 1].id ~= 0) then
            count = count + 1
        end
    end
    if count == #equips and self:canPowerUp() and self:consumeJueXing() then
        ret = true
        return ret
    end
	return ret
end 

function Char:consumeJueXing()
	local isEnough = true
	local row = TableReader:TableRowByUniqueKey("powerUp", self.Table.powUpId, self.stage)
    if row then
        local consume = RewardMrg.getConsumeTable(row.consume, self.dictid)
        local list = {}
        table.foreach(consume, function(i, v)
            if v:getType() == "money" then
                local money = v.rwCount
                local max = Tool.getCountByType("money")
				if max < money then isEnough = false  return isEnough  end 
            else
                local num = v.rwCount
                local max 
				if v:getType() == "char" then 
					max = Tool.getCountByType(v:getType(), v.dictid)
				else 
					max = Tool.getCountByType(v:getType(), v.id)
				end 
				if max < num then isEnough = false  return isEnough  end 
            end
        end)
	else 
		isEnough = false 
    end
	return isEnough
end 

--可突破提示
function Char:checkRedPoint()
    local ret = false
    --角色等级过滤
    --if self.lv < Player.Info.level - 20 then
    --    return false 	
    --end
    --可升级
    ret = self:redPointForStrong()
    if ret == true then return ret end

    --可突破
    local charEquips = self.info.equip or {} --身上的装备
    local count = 0
    for i = 1, 6 do
        if (charEquips[i - 1].id ~= 0) then
            count = count + 1
        end
    end
    if count == 6 and self:canPowerUp() then
        ret = true
        return ret
    end

    --可装备
    ret = self:redPointForEquip()
    if ret == true then return ret end

    --技能点满且角色技能可升级
    --    ret = self:redPointForSkill()
    --    if ret == true then return ret end
    --灵络可点提醒
    --    ret = self:redPointForTransform()
    return ret
end

--可进化提示
function Char:redPointForJinHua()
    --角色等级过滤
    if self.lv < Player.Info.level - 20 then
        return false
    end
	
    local ret = true
    local lv = Tool.GetCharArgs("star_" .. self.star_level + 1 .. "_need_level")
	if lv == nil then return false end 
    if self.lv < lv then return false end
	--材料
    local row = TableReader:TableRowByUniqueKey("consume_starUp", self.Table.starUpid, self.star_level + 1)
    if row then
        local consume = RewardMrg.getConsumeTable(row.consume, self.dictid)
        local list = {}
        table.foreach(consume, function(i, v)
            if v:getType() == "money" then
                local money = v.rwCount
                local max = Tool.getCountByType("money")
				if max < money then ret = false return ret end 
            else
                local num = v.rwCount
                local max 
				if v:getType() == "char" then 
					max = Tool.getCountByType(v:getType(), v.dictid)
				else 
					max = Tool.getCountByType(v:getType(), v.id)
				end 
				if max < num then ret = false return ret end 
            end
        end)
	end
    return ret
end

function Char:getYuling(id)
    local yulingId = 0
    local yilings =Player.yuling:getLuaTable()
    for k,v in pairs(yilings) do
        if v.huyou==id and v.quality>0 then 
            yulingId=k
        end 
    end
    return yulingId
end

-- 是否存在上阵列表中
function Char:isExitTeam(id)
    local teams = Player.Team[0].chars
    if teams == nil then
        return false
    end
    for i = 0, 5 do
        if teams.Count > i then
            if tonumber(teams[i]) == id then 
				return true
			end 
        end
    end
    return false
end

--获取小伙伴队列
function Char:checkFriend(charId)
    local teams = Player.Team[12].chars
    local list = {}
    for i = 0, 7 do
        if tonumber(teams[i]) == charId then
            return true
        end
    end
    return false
end

--可升级
function Char:redPointForStrong()
    local ret = false
	if self.id == Player.Info.playercharid then return ret end 
    --可升级
    ret = Player.Info.level <= self.lv
	if ret == true then return false end 
	local chars = Player.Chars:getLuaTable()
    for k, v in pairs(chars) do
        local char = Char:new(k, v)
		-- 可吞卡升级  和  可自动添加 的， 自动添加进来
		if char.Table.can_lvup_yjtj_auto == 1 or char.Table.can_lvup_yjtj == 1 then	
			local function onFilter(char)
				if char.id == self.id then return false end
				if char.id == Player.Info.playercharid then return false end 
				-- 觉醒过的
				if char.stage > 0 then return false end 
				-- 进阶过的
				if char.star_level > 0 then return false end 
				-- 上阵的不能添加
				if self:isExitTeam(char.id) then return false end 
				-- 小伙伴
				if self:checkFriend(char.id) then return false end 
				
				return true
			end 		
			if onFilter(char) then
				local tb = TableReader:TableRowByID("charArgs", "charLevelUp_consumeRate")
				local cost = 0 
				local exp = char.info.exp + char.Table.exp
				if tb.value == "money" then 
					cost = exp * tonumber(tb.value2) 
				elseif tb.value == "item" then 
					cost = exp * tonumber(tb.other) 
				end 
				ret = cost <= Player.Resource.money
				if ret == true then return ret end 
			end
		end
    end
    return ret
end

function Char:redPointForEquip()
    local ret = false
    local equips = self:getEquips()
    table.foreach(equips, function(o, v)
        v:updateInfo()
        local state = v:getState()
        if (state == ITEM_STATE.can or state == ITEM_STATE.en) then
            ret = true
            return ret
        end
    end)
    return ret
end

--灵络可点提醒
function Char:redPointForTransform()
	return false
end


function Char:redPointForCultivate()
    local base_consume = TableReader:TableRowByID("charArgs",  "char_xilian_normal_consume")
    local common_consume = TableReader:TableRowByID("charArgs",  "char_common_xilian_consume")
    local expert_consume = TableReader:TableRowByID("charArgs",  "char_expert_xilian_consume")
    local master_consume = TableReader:TableRowByID("charArgs",  "char_master_xilian_consume")
    local item=uItem:new(base_consume.value2)
    if item.count<base_consume.other then 
       return false
    else 
       if item.count<base_consume.other+common_consume.other and 
           Tool.getCountByType(expert_consume.value)<expert_consume.value2 
           and Tool.getCountByType(master_consume.value)<master_consume.value2 then 
           return false
       end
    end
    
	local xilian_tmp = self:getAttrList2(self.info.xilian_tmp)
    local xilian = self:getAttrList2(self.info.xilian)
	if Tool.charXilianLevels == nil then
       local list = {}
       local _list = {}
       TableReader:ForEachLuaTable("charXilianSettings", function(index, item)
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
       Tool.charXilianIds = _list
       Tool.charXilianLevels = list
    end
	local lv = self:getMaxLevel(self.lv)
    local row = Tool.charXilianIds["char_" .. self.star .. "_" .. lv]
    if row then
       for i = 1, 4 do
           local obj = {}
           obj.cur = xilian[i] or 0
           obj.max = row[i] or 0
			if obj.cur < obj.max then 
				return true 
			end 
       end
    end
	return false
end 

function Char:getMaxLevel(lv)
    if Tool.charXilianLevels then
        local item = Tool.charXilianLevels["char_" .. self.star]
        if item == nil then return 20 end
        local l = 20
        table.foreach(item, function(i, v)
            if lv <= v then l = v return l end
        end)
        return l
    end
    return 20
end

function Char:getAttrList2(arg)
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

--技能可升级提醒
function Char:redPointForSkill()
	return false
end

--获取人物当前化神阶段数
function Char:getHuaShenLevel(id, dictid, quality)
    local qlv = Player.Chars[id].qualitylvl
    local text = ""
    if qlv > 0 then
        local huaSInfo = TableReader:TableRowByUniqueKey("qualitylevel", dictid, qlv)
        if huaSInfo ~= nil and huaSInfo.level >= 5 then
            local lv = math.floor(huaSInfo.level / 5) * 5
            local ss = TableReader:TableRowByUniqueKey("qualitylevel", dictid, lv)
            if lv == qlv then
                text = huaSInfo.desc
            else
                text = ss.desc --..huaSInfo.desc
            end
        elseif qlv < 5 and qlv > 0 then
            if quality == 5 then
                text = TextMap.GetValue("Text_1_801") --..huaSInfo.desc
            elseif quality == 6 then
                text = TextMap.GetValue("Text_1_802") --..huaSInfo.desc
            end
        end
    elseif qlv == 0 then
        if quality == 5 then
            text = TextMap.GetValue("Text_1_801")
        elseif quality == 6 then
            text = TextMap.GetValue("Text_1_802")
        end
    end
    return text
end

function Char:getTypeProForHuaShen(typeId, charId, dictId)
    local qlv = Player.Chars[charId].qualitylvl
    local result = 0
    if qlv > 0 then
        for i = 1, qlv do
            local preInfo = TableReader:TableRowByUniqueKey("qualitylevel", dictId, i)
              for j = 0, 7 do
                if preInfo.magic[j] ~= nil then
                    local name = string.gsub(preInfo.magic[j]._magic_effect.cnName, "_V", "")
                    if typeId == preInfo.magic[j].magic_effect or typeId == name then
                        result = result + preInfo.magic[j].magic_arg1
                        break
                    end
                end
              end
        end
    end
    return result
end

--获得化身的加成属性列表
function Char:showHuaSProList(id, dictid)
    local qlv = Player.Chars[id].qualitylvl
    local list = {}
    local proIdList = {} 
    local proTitleList = {}
    local index = 0
    local text = ""
    if qlv > 0 then
        for i = 1, qlv do
            local preInfo = TableReader:TableRowByUniqueKey("qualitylevel", dictid, i)
            if preInfo ~= nil then
                for j = 0, 7 do
                    if preInfo.magic[j] ~= nil then
                        local id = preInfo.magic[j].magic_effect
                        local title = string.gsub(preInfo.magic[j]._magic_effect.format, "{0}", "")
                        if proIdList[id] ~= nil then
                            proIdList[id] = preInfo.magic[j].magic_arg1 + proIdList[id]
                        else
                            proIdList[id] = preInfo.magic[j].magic_arg1
                        end

                        if proTitleList[id] == nil then
                            proTitleList[id] = "[ffff96]"..title.."[-]"
                        end
                    end
                end
            end
        end

        for k, v in pairs(proIdList) do
            list[index] = proTitleList[k]..proIdList[k]
            index = index + 1
            if index == 4 then
                break
            end
        end
    end

    return list
end

--化神可升级提示
function Char:redPointForHuaShen(char)
    if char.id ~= Player.Info.playercharid then
        local qlv = Player.Chars[char.id].qualitylvl
        local targetlvInfo = TableReader:TableRowByUniqueKey("qualitylevel", char.dictid, qlv + 1)
        if targetlvInfo ~= nil then
            for i = 0, 2 do
                if targetlvInfo.consume[i] ~= nil then
                    local typeInfo = targetlvInfo.consume[i].consume_type
                    local name = targetlvInfo.consume[i]["$consume_arg"]

                    if typeInfo == "money" then
                        local needNum = tonumber(targetlvInfo.consume[i].consume_arg)
                        if Player.Resource.money < needNum then
                           return false
                        end
                    elseif typeInfo == "item" and name == TextMap.GetValue("Text_1_830") then
                        local needNum = tonumber(targetlvInfo.consume[i].consume_arg2)
                        local itemId = targetlvInfo.consume[i].consume_arg
                        local num =  Player.ItemBagIndex[itemId].count--Char:getServerPackData(typeInfo, itemId, Player.ItemBag)
                        if num < needNum then
                            return false
                        end
                    elseif typeInfo == "item" and name ~= TextMap.GetValue("Text_1_830") then
                        local needNum = tonumber(targetlvInfo.consume[i].consume_arg2)
                        local itemId = targetlvInfo.consume[i].consume_arg
                        local num =  Player.ItemBagIndex[itemId].count--Char:getServerPackData(typeInfo, itemId, Player.ItemBag)
                        if num < needNum then
                            return false
                        end
                    elseif typeInfo == "hunyu" then
                        local needNum = tonumber(targetlvInfo.consume[i].consume_arg)
                        local shenHunNm = tonumber(Player.Resource.hunyu)
                        if shenHunNm < needNum then
                            return false
                        end
                    elseif typeInfo == "charPiece" then
                        local needNum = tonumber(targetlvInfo.consume[i].consume_arg2)
                        local itemId = targetlvInfo.consume[i].consume_arg
                        local piece  = Char:getServerPackData(typeInfo, itemId, Player.ItemBag)
                        if piece < needNum then
                            return false
                        end
                    end
                end
            end
        else
            return false
        end
    end
    return true
end

--判断背包的对应道具数量
function Char:getServerPackData(type, itemId, Bag)
   local bag = Bag:getLuaTable()
    if not bag then error("bag have nothing") end
    local num = 0
    for k, v in pairs(bag) do
        local vo = {}
        vo = itemvo:new(type, v.count, v.id, v.time, k)

        if type == "charPiece" then
            local piece = Player.CharPieceBagIndex[itemId]
            if piece ~= nil then
                num = piece.count
                break
            end
        end
        if vo.itemType == type and vo.itemID == itemId  then
            num = vo.itemCount
            break
        end
    end
    return num
end

--血脉可升级提示
function Char:redPointForXueMai()
    local linkData = TableReader:TableRowByID("bloodlineSetting", 4)
    if linkData.arg ~= nil then
        if Player.Info.level < linkData.arg then
            return false
        end
    end

    --判断血脉是否到达等级限制
    local lv = Player.Chars[self.id].bloodline.level --当前血脉等级
    local max_lv = TableReader:TableRowByID("bloodlineSetting", 1).arg
    if lv + 1 > max_lv then --到达顶级
        return false
    else                                  --未到达顶级
        local row = TableReader:TableRowByID("bloodlineLvup", lv + 1)
        if row.char_lv_limit > self.lv then --达到当前等级限制
            return false
        end
    end

    local costItem = TableReader:TableRowByID("bloodlineSetting", 3).arg
    local item = uItem:new(costItem)
    self.costItem = item
    local num = self.costItem.count
    local value = Player.Chars[self.id].bloodline.value --当前血脉值
    local row = TableReader:TableRowByID("bloodlineLvup", lv + 1)
	if row == nil then return false end 
    local exp = row["star_" .. self.star .. "_bexp"]
    if exp == nil or num < (exp - value) or lv + 1 > max_lv then
        return false
    else
        return true
    end
end

function Char:initInfo(info)
	self.info = info
	-- 此star改成了服务器中quality    为卡片颜色。
	-- 避免改动4、5百处判断条件
	self.star = info.quality
	if self.star < 1 then 
		self.star = self.quality
	end 
    self.lv = info.level --等级
	if self.lv <= 0 then self.lv = 1 end
    self.star_level = info.star --星级
    self.power = math.ceil(info.power) --战力
    self.stage = info.stage --阶
    --if self.stage == 0 then
    --    self.stage = 1
    --end
    if info.RefineMaster ~=nil then
        self.RefineMaster=info.RefineMaster
    end
    self.equips = nil
	if self.id == Player.Info.playercharid then 
		self.name = Player.Info.nickname
        if Player.fashion.curEquipID>0 then 
            self:FashionChangeSkill()
        end 
	else 
		self.name = self.Table.show_name
	end 
    self.itemColorName = Char:getItemColorName(self.star, self.name)
end

--更新角色信息
function Char:updateInfo()
    local chars = Player.Chars
    local info = chars[self.id]
	
	self:initInfo(info)
end

--进阶等级
function Char:getStarFrame()
    return "xibiesmall_" .. (self.stage + 1)
end


function Char:getDingWei()
    local type = self.Table.party
    if type == 1 then
        return "zhenying_shan"
    elseif type == 2 then
        return "zhenying_e"
    elseif type == 3 then
        return "zhenying_ying"
	else
		return ""
    end
end

--进阶等级
function Char:getStarFrameBig()
    return "xibie_" .. (self.stage + 1)
end

function Char:getStageStar(isColor)
	local star = math.floor (self.stage / 10 )
	local starLv = math.fmod(self.stage,10)
	if isColor == nil then 
		str=string.gsub(TextMap.GetValue("LocalKey_822"),"{0}",star)
        str = string.gsub(str,"{1}",starLv)
	else 
        str=string.gsub(TextMap.GetValue("LocalKey_811"),"{0}",star)
		str = string.gsub(str,"{1}",starLv)
	end 
	return str
end 

function Char:getStageStarByNum(num, isColor)
	local star = math.floor (num / 10 )
	local starLv = math.fmod(num,10)
	local str = ""
	if isColor == nil then 
		str=string.gsub(TextMap.GetValue("LocalKey_822"),"{0}",star)
        str = string.gsub(str,"{1}",starLv)
	else 
        str = string.gsub(TextMap.GetValue("LocalKey_811"),"{0}",star)
        str =string.gsub(str,"{1}",starLv)
	end 
	return str
end 

--ui中显示角色名字，带进阶等级
function Char:getDisplayName()
	local name = ""
	if self.id == Player.Info.playercharid then 
		name = Player.Info.nickname
	else 
		name = self.name 
	end 
    local strStage = ""
    if self.star_level ~= nil and self.star_level > 0 then
        strStage = " [00ff00]+" .. (self.star_level) .. "[-]"
    end
	name = Char:getItemColorName(self.star, name)
    return name .. strStage
end

--ui中显示角色名字，带进阶等级
function Char:getDisplayColorName()
    local name = ""
    if self.id == Player.Info.playercharid then 
        name = Player.Info.nickname
    else 
        name = self.name 
    end 
    local strStage = ""
    if self.star_level ~= nil and self.star_level > 0 then
        strStage = " [00ff00]+" .. (self.star_level) .. "[-]"
    end
    name = Char:getItemColorName(self.star, name)
    return  name .. strStage
end

--进阶颜色与外框
function Char:getColor()
    local color = Tool.getCharColor(self.star)
    return color
end

--外框
function Char:getFrame()
    local star = self.star
	return Tool.getFrame(star)
end

--头像背景
function Char:getFrameBG()
    local star = self.star
	return Tool.getBg(star)
end

--大虚背景
function Char:getDaxuFrameBG(star)
	return Tool.getBg(star)
end

--大虚外框
function Char:getDaxuFrameKuang(star)
    return Tool.getFrame(star)
end

--过期
function Char:getLvFrame()
    return ""
end

--可突破
function Char:canPowerUp()
    return self.stage < Tool.GetCharArgs("max_powerup")
end

--升星消耗
function Char:startUpNeed()
    -- if self.star == 13 then return nil end
    if self.star_level == Tool.GetCharArgs("max_power_Leader") then return nil end
    local num = Tool.GetCharArgs("star_" .. (self.star_level + 1) .. "_need_money")
    return num
end

function Char:FashionChangeSkill()
    if self.id ~= Player.Info.playercharid then return end
    if Player.fashion.curEquipID<=0 then return end 
    local fashion = Fashion:new(Player.fashion.curEquipID) 
	self.fashionlv = fashion.lv
    --穿时装后改变主角的
    self.fashionTable=fashion.modelTable
    self.modelid=fashion.modelTable.id
    --穿时装后改变主角的技能
    self._allSkills = {}
    local skills = self.info.skill:getLuaTable()
    local sk_list = fashion.modelTable.skill
    local sk = nil 
    -- 普通攻击
    sk  = Skill:new(fashion.modelTable.normal_skill, self, 0)
    sk.customType = 1
    table.insert(self._allSkills, sk)
    table.foreach(skills, function(i, v)
        local skill = self.info.skill[i]
        if skill ~= nil and skill.skill_id~=nil then 
            local sk = Skill:new(v.skill_id, self)
            if sk.Table~=nil and sk.Table.type==2 then 
                -- 普通技能
                sk.customType = 2
                table.insert(self._allSkills, sk)
            elseif sk.Table~=nil and sk.Table.type==4 then 
                -- 合体技
                sk.customType = 3
                table.insert(self._allSkills, sk)
            end 
        end 
    end)
    table.sort( self._allSkills, function (a,b)
        if a.customType~=b.customType then return a.customType < b.customType end 
        return a.id <b.id 
    end)
end

function Char:getNewXpSkill()
	local list = {}
	-- 合体技
	local ht_list = self.modelTable.xp_skill
	for i = 0, ht_list.Count - 1 do
        --if i < 6 then
            if ht_list[i] ~= "" then
                sk = Skill:new(ht_list[i], self, #list + 1)
				sk.customType = 3
                table.insert(list, sk)
            end
        --end
    end
	-- 合体技配合技
	local xp_ties = self.modelTable.xp_ties
	for i = 0, xp_ties.Count - 1 do
		if xp_ties[i] ~= "" then
            sk = Skill:new(xp_ties[i], self, #list + 1)
			sk.customType = 4
            table.insert(list, sk)
        end
	end
	return list
end

function Char:getAllSkill()
	-- 普通技能
    local skills = self.info.skill:getLuaTable()
    local tb = {}
    if self._allSkills == nil then
        self._allSkills = {}
        local sk_list = self.modelTable.skill
        local sk = nil 
		-- 普通攻击
		sk  = Skill:new(self.modelTable.normal_skill, self, 0)
		sk.customType = 1
		table.insert(self._allSkills, sk)
		-- 普通技能
        for i = 0, sk_list.Count - 1 do
            --if i < 6 then
                if sk_list[i] ~= "" then
                    sk = Skill:new(sk_list[i], self, i)
                    --                self._skills[i + 1] = sk
					sk.customType = 2
                    table.insert(self._allSkills, sk)
                end
            --end
        end
		-- 合体技
		local ht_list = self.modelTable.xp_skill
		for i = 0, ht_list.Count - 1 do
            --if i < 6 then
                if ht_list[i] ~= "" then
                    sk = Skill:new(ht_list[i], self, #self._allSkills + 1)
					sk.customType = 3
                    table.insert(self._allSkills, sk)
                end
            --end
        end
		-- 合体技配合技
		local xp_ties = self.modelTable.xp_ties
		for i = 0, xp_ties.Count - 1 do
			if xp_ties[i] ~= "" then
                sk = Skill:new(xp_ties[i], self, #self._allSkills + 1)
				sk.customType = 4
                table.insert(self._allSkills, sk)
            end
		end
    else
        table.foreachi(self._allSkills, function(i, v)
            v:updateInfo(self)
        end)
    end

    return self._allSkills
end 

--xp技能
function Char:getXpSkill()
    if self.xp_attack then 
        self.xp_attack:updateInfo(self)
        return self.xp_attack 
    end
    local xp_attack = self.modelTable.xp_skill
    self.xp_attack = Skill:new(xp_attack, self, 9)
    self.xp_attack.tp = "change"
    return self.xp_attack
end

--光环技能
function Char:getXpAuraSkill()
    if self.xp_aura then 
        self.xp_aura:updateInfo(self)
        return self.xp_aura 
    end
    local xp_aura = self.modelTable.xp_aura
    self.xp_aura = Skill:new(xp_aura, self,8)
    self.xp_aura.tp = "change"
    return self.xp_aura
end

function Char:getTransform()
    return self.info.transform
end



--洗练属性
function Char:getAttach()
    return self.info.xilian
end

--洗练临时属性
function Char:getAttachTemp()
    return self.info.attachTemp
end

--在队伍中
function Char:getTeamIndex(...)
    local teams = Player.Team[0].chars
    local len = teams.Count
    for i = 1, 6 do
        if i - 1 < len then
            if teams[i - 1] .. "" == self.id .. "" then
                return i
            end
        else
            return 7
        end
    end
    return 7
end

function Char:getMaxLinLuoLv(lv)
    return Tool.GetCharArgs("lingluo_" .. lv .. "_lv")
end


function Char:getItemColorName(color, names)
    local _names = names
	_names = Tool.getItemColor(color).color .. names .. "[-]"
    return _names
end

function Char:getItemQuality()
    local _names = names
    if self.star == 1 then
        _names = TextMap.GetValue("Text_1_2882")
    elseif self.star == 2 then
        _names = TextMap.GetValue("Text_1_2883")
    elseif self.star == 3 then
        _names = TextMap.GetValue("Text_1_2884")
    elseif self.star == 4 then
        _names = TextMap.GetValue("Text_1_2885")
    elseif self.star == 5 then
        _names = TextMap.GetValue("Text_1_2886")
    elseif self.star == 6 then
        _names = TextMap.GetValue("Text_1_2887")
    end
    return _names
end

--获取某个角色已激活的羁绊id列表
function Char:getFetter(id)
    if id == nil then return end
    local fetters = Player.Chars[id].tie:getLuaTable()
    local tb = {}
    table.foreach(fetters, function(i, v)
        if v ~= nil then
            table.insert(tb, v)
        end
    end)
    --local fetter = {}
    --table.foreach(tb, function(i, v)
    --    if v >= 100 then
    --        local skillid = Player.Chars[id].skill[v].skill_id
    --        if skillid ~= 0 or skillid ~= "0" then
    --            table.insert(fetter, skillid)
    --        end
    --    end
    --end)
    return tb
end

--初始化
function Char:init(id, dictid)
    local dictid = Tool.getDictId(id) or dictid
	if dictid == nil or tonumber(dictid) == nil then 
		print("没有找到新ID, 读表请使用新的ID: dictid " .. tostring(dictid))
	end 
    self.Table = TableReader:TableRowByID("char", dictid)
    if self.Table == nil then
        self.Table = TableReader:TableRowByUnique("char", "name", dictid)
    end
    if self.Table == nil then
        print("readTable err char , 读表请使用新的ID: dictid " .. dictid)
        return
    end
	
	-- 此quality改成了读表的star, 服务器中quality为卡片颜色。
	-- 避免改动4、5百处判断条件
    self.quality = self.Table.star
    self.star_level = 0
    self.typeIndex = 5
	--print("uchar: tableId = " .. self.Table.id)
    self.modelTable = TableReader:TableRowByID("avter", self.Table.id)  
    self.id = tonumber(id) or -1
	self.dictid = self.Table.id
    self.modelid=self.Table.model_id
    self.sex = self.Table.sex
    self.party = self.Table.party
    self.desc=self.Table.desc
    self:updateInfo()
    self.teamIndex = self:getTeamIndex()
end

--初始化一张卡片
function Char:new(id, dictid)
    local o = {}
    setmetatable(o, self)
    self.__index = self
    o:init(id, dictid)
    return o
end

return Char