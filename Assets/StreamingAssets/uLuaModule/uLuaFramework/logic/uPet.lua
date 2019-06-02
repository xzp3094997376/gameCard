--角色类

local Pet = {}

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

function Pet:GetAttr(attr, propertys, isId, pre, n)
    n =  0
    pre = pre or ""
    local row = nil
    if isId == "id" then
        row = TableReader:TableRowByID("magics", attr)
    else
        row = TableReader:TableRowByUnique("magics", "name", attr)
    end
	
    if row == nil then return "" end
    local desc = ""
    if propertys.Count == nil then
        local arg1 = propertys[row.id] + n
        if pre and math.floor(arg1 / row.denominator) == 0 then return "" end
	
        desc = string.gsub("[ffff96]" .. row.format .. "[-]", "{0}", "[ffffff]" .. pre .. math.floor(arg1 / row.denominator) .. "[-]")
    else
        if propertys.Count > row.id then
            local arg1 = propertys[row.id] + n
            if pre and math.floor(arg1 / row.denominator) == 0 then return "" end
		
            desc = string.gsub("[ffff96]" .. row.format .. "[-]", "{0}", "[ffffff]" .. pre .. math.floor(arg1 / row.denominator) .. "[-]")
        end
    end
    return desc or ""
end

function Pet:GetAttrNewByP(id, propertys, p)
	local row = TableReader:TableRowByID("magics", id)
    local desc = ""
	local arg1 = 0
    if propertys.Count == nil then
        arg1 = propertys[id]
		arg1 = arg1 / row.denominator / 1000 * p
		arg1 = math.floor(arg1)
        desc = string.gsub("[ffff96]" .. row.format .. "[-]", "{0}", "[ffffff]" .. arg1 .. "[-]")
    else
        if propertys.Count > id then
            arg1 = propertys[id] / 1000 * p
			arg1 = math.floor(arg1)
            desc = string.gsub("[ffff96]" .. row.format .. "[-]", "{0}", "[ffffff]" .. arg1 .. "[-]")
        end
    end
    return arg1, desc or ""
end

function Pet:GetAttrNew(attr, propertys,isGreen)
    local row = TableReader:TableRowByUnique("magics", "name", attr)
    if row == nil then return "" end
    local desc = ""
	local arg1 = 0
    if propertys.Count == nil then
        arg1 = propertys[row.id]
		arg1 = arg1 / row.denominator
		arg1 = math.floor(arg1)
        if isGreen~=nil and isGreen==true then 
            desc = string.gsub("[ffff96]" .. row.format .. "[-]", "{0}", "[24FC24]" .. arg1 .. "[-]")
        else 
            desc = string.gsub("[ffff96]" .. row.format .. "[-]", "{0}", "[ffffff]" .. arg1 .. "[-]")
        end 
    else
        if propertys.Count > row.id then
            arg1 = propertys[row.id]
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

function Pet:GetPetExp(lv, star_level)
    if (lv == nil) then return nil end
    local item = TableReader:TableRowByUnique("petExp", "lv", lv)
    if (item ~= nil) then
        --if tonumber(star_level) < 3 then star_level = 3 end
        return item["exp_d_" .. star_level]
    end
    return nil
end

function Pet:GetPetTotalExp(lv, star_level)
    if (lv == nil) then return nil end
    local item = TableReader:TableRowByUnique("petExp", "lv", lv)
    if (item ~= nil) then
        return item["exp_" .. star_level]
    end
    return nil
end


--类型
function Pet:getType()
    return "pet"
end


function Pet:GetAttrByPet(attr)
    local row = TableReader:TableRowByUnique("magics", "name", attr)
    local arg1 = self.info.propertys[row.id]
	if arg1 == nil then 
		print("宠物属性表里没有: " .. attr .. " id = " .. row.id)
	end 
	arg1 = arg1 / row.denominator
	arg1 = math.floor(arg1)
	local desc = string.gsub("[ffff96]".. row.format .. "[-]", "{0}", "[ffffff]" .. arg1 .. "[-]")
    return arg1, desc
end

--阵容界面显示属性
function Pet:getAttrSingleForGhost(attr, num)
    self:updateInfo() 
    local row = TableReader:TableRowByUnique("magics", "name", attr)
    local arg1 = self.info.propertys[row.id]
	arg1 = arg1 / row.denominator
	arg1 = math.floor(arg1)
	
	local newColor = "[9a4c1e]" ..row.format .. "[-]"
	arg1 = "[3b1c0a]" .. arg1 .. "[-]"
    local desc = string.gsub(newColor, "{0}", "[ffffff]" .. arg1 .. "[-]")
    return desc
end

function Pet:getAttrSingle(attr, isnum)
    if isnum then
        local row = TableReader:TableRowByUnique("magics", "name", attr)
        local arg1 = self.info.propertys[row.id]
		arg1 = arg1 / row.denominator
		arg1 = math.floor(arg1)
        return arg1, "[ffff96]".. row.format .. "[-]"
    else
        return self:GetAttrByPet(attr)
    end
end

function Pet:getAttrList(ids, propertys, pre)
    local list = {}

    table.foreach(ids, function(i, v)
        local desc = GetAttr(v, propertys, "id", pre)
        if desc ~= "" then
            table.insert(list, desc)
        end
    end)
    return list
end

function Pet:getAttrListNew(ids, propertys)
	local list = {}
    table.foreach(ids, function(i, v)
        local desc = self:GetAttrNew(v, propertys)
        if desc ~= "" then
            table.insert(list, desc)
        end
    end)
    return list
end 

--角色描述
function Pet:getDesc()
    return self.Table.desc
end

function Pet:getSkillAttr()
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

function Pet:getBlood()
    -------------------------------------------------------- 血脉---------------------------------------------------
    local bloodArg = {}
    local bloodline = Player.Pets[self.id].bloodline
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

function Pet:getTreasure()
    local pet_id = self.id
    local treasure = Player.Treasure
    local treasureSlot = Player.Pets[pet_id].treasure 
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


function Pet:CalculateTreasureProperty(magic,level)
    local num = magic.arg + magic.arg2 * level
    local data = {}
    data.name =  magic.name
    data.value = num / magic.denominator
	if data.name ~= nil then 
		table.insert(self.treasureArg, data)
    end
end

function Pet:CalculateTreasureProperty_JL(magic)
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

function Pet:CalculateImmortalityProperty(treasure)
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

function Pet:getAttrCultivateDesc()
    local info = self.info
    local propertys = info.propertys
    local desc = {}
    TableReader:ForEachLuaTable("petXilianRange", function(i, v)
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
function Pet:getAttrDesc()
	--print("升级： 英雄属性")
    local info = self.info
    local propertys = info.propertys
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
				local newColor = "[ffff96]" .. row.format .. "[-]"
                d = string.gsub(newColor, "{0}", "[ffffff]" .. arg1 .. "[-]")
            end
            if d ~= "" then
                table.insert(desc, d .. "\n")
            end
        end
    end)
    return desc
end


--升级所需要的经验
function Pet:exp()
    return GetPetExp(self.lv, self.star)
end

--角色图片
function Pet:getImage(ret)
    --    if (self._img) then return self._img end
    local key = "full_img_d"
    if ret == true then key = "full_img_t" end
    local img = self.modelTable[key]
    if (img == "" or img == nil) then img = "default" end
    self._img = UrlManager.GetImagesPath("cardImage/" .. img .. ".png")
    return self._img
end

--角色小头像
function Pet:getHead()
    if (self._head) then return self._head end
    local img = self.modelTable.head_img

    if (img == "" or img == nil) then img = "default" end

    self._head = UrlManager.GetImagesPath("headImage/" .. img .. ".png")
    return self._head
end

--获取头像贴图名字
function Pet:getHeadSpriteName()
    local img = self.modelTable.head_img
    if (img == "" or img == nil) then img = "default" end
    return img
end

--获取角色的灵魂石对象
--@return PetPiece
function Pet:getPiece()
    if (self.piece ~= nil) then return self.piece end
    self.piece = PetPiece:new(self.dictid)
    return self.piece
end

--获取角色的技能信息
function Pet:getSkill()
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
function Pet:isHaveVest()
    local petEquips = self.info.equip or {} --身上的装备
    for i = 1, 6 do
        if (petEquips[i - 1].id ~= 0) then
            return true
        end
    end
    return false
end

--获得装备
function Pet:getEquips(refresh)
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

    local petEquips = self.info.equip or {} --身上的装备

    for i = 1, len do
        local id = equip_id[i - 1]
        local equip = Equip:new(id)
        equip:forPet(self)
        if (petEquips[i - 1].id ~= 0) then
            equip:setPet(self, i - 1)
        end

        equipsList[i] = equip
    end

    self.equips = equipsList
    return self.equips
end

--可突破提示
function Pet:checkRedPoint()
    local ret = false
    --角色等级过滤
    --可升级
    ret = self:redPointForStrong()
    if ret == true then return ret end

    --技能点满且角色技能可升级
    --    ret = self:redPointForSkill()
    --    if ret == true then return ret end
    --灵络可点提醒
    --    ret = self:redPointForTransform()
    return ret
end

--可进化提示
function Pet:redPointForJinHua()
    local ret = false
	if self:isExitTeam(self.id) == false then return false end 
	local row = TableReader:TableRowByUniqueKey("petstarUp", self.dictid, self.star_level + 1)
    if row == nil then return false end 
	local lv = row.limitLv
	if lv == nil then return false end 
    if self.lv < lv then return false end
    --材料
    if row then
        local consume = RewardMrg.getConsumeByTable(row.consume)
        local list = {}
        ret = true
        table.foreach(consume, function(i, v)
            local t = v.type
            local num = Tool.getCountByType(t, v.name)
            if v.count > num then ret = false return ret end
        end)
    end
    return ret
end

-- 是否在上阵或者护佑中
function Pet:isExitTeam(petId)
    local id = Player.Team[0].pet
    if id ~= nil and tonumber(id) ~= 0 and id == petId then
        return true
    end
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

--可升级
function Pet:redPointForStrong()
    local ret = false
    --可升级
    ret = Player.Info.level <= self.lv
	if ret == true then return false end 
	if self:isExitTeam(self.id) == false then return false end 
	local list = getServerPackDataBySubType("item", "petItem", Player.ItemBag)
	local exp = 0
	for i = 1, #list do 
		local item = list[i]
		if item.itemCount > 0 then return true end 
	end 
    return ret
end

function Pet:getShenLianExp(shenlian_lv)
	local row = TableReader:TableRowByUniqueKey("petShenlian", self.dictid, shenlian_lv)
	if row then 
		return row.exp, row.limitLv
	else 
		print("dictid = " .. self.dictid .. "  shenlian_lv = " .. shenlian_lv)
	end 
	
	return -1, -1
end

function Pet:redPointForShenlian()
    local ret = false
	if self:isExitTeam(self.id) == false then return false end 
	local max = Tool.GetPetArgs("shenlian_max_lv")
	if self.shenlian >= max then return false end 
	local tb = TableReader:TableRowByID("petArgs", "shenlian_item1")
	local count = Tool.getCountByType("item", tb.value2)
	if count and count > 0 then 
		return true
	end 
	tb = TableReader:TableRowByID("petArgs", "shenlian_item2")
	count = Tool.getCountByType("item", tb.value2)
	if count and count > 0 then 
		return true
	end 
	tb = TableReader:TableRowByID("petArgs", "shenlian_item3")
	count = Tool.getCountByType("item", tb.value2)
	if count and count > 0 then 
		return true
	end
	return false
end

--更新角色信息
function Pet:updateInfo()
    local pets = Player.Pets
    local info = pets[self.id]
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
	self.shenlian = info.shenlian
	self.shenlianExp = info.shenlianExp or 0
    self.equips = nil

	if self.id == Player.Info.playerpetid then 
		self.name = Player.Info.nickname
	else 
		self.name = self.Table.show_name
	end 
    self.itemColorName = Pet:getItemColorName(self.star, self.name)
end

--ui中显示角色名字，带进阶等级
function Pet:getDisplayColorName()
    local name = self.name
    local strStage = ""
    -- if self.star_level ~= nil and self.star_level > 0 then
    --     strStage = " [00ff00]+" .. (self.star_level).."[-]"
    -- end
    name = Pet:getItemColorName(self.star, name)
    return  name .. strStage
end

--ui中显示角色名字，带进阶等级
function Pet:getDisplayName()
	local name = ""
	if self.id == Player.Info.playerpetid then 
		name = Player.Info.nickname
	else 
		name = self.name 
	end 
    local strStage = ""
    -- if self.star_level ~= nil and self.star_level > 0 then
    --     strStage = " [00ff00]+" .. (self.star_level).."[-]"
    -- end
	name = Pet:getItemColorName(self.star, name .. strStage)
    return name 
end

--进阶颜色与外框
function Pet:getColor()
    local color = Tool.getPetColor(self.star)
    return color
end

--外框
function Pet:getFrame()
    local star = self.star
	return Tool.getFrame(star)
end

--头像背景
function Pet:getFrameBG()
    local star = self.star
	return Tool.getBg(star)
end

--升星消耗
function Pet:startUpNeed()
    -- if self.star == 13 then return nil end
    if self.star_level == Tool.GetPetArgs("max_power_Leader") then return nil end
    local num = Tool.GetPetArgs("star_" .. (self.star_level + 1) .. "_need_money")
    return num
end

function Pet:getAllSkill()
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
    else
        table.foreachi(self._allSkills, function(i, v)
            v:updateInfo(self)
        end)
    end

    return self._allSkills
end 

--xp技能
function Pet:getXpSkill()
    if self.xp_attack then 
        self.xp_attack:updateInfo(self)
        return self.xp_attack 
    end
    local xp_attack = self.modelTable.xp_skill
    self.xp_attack = Skill:new(xp_attack, self, 9)
    self.xp_attack.tp = "change"
    return self.xp_attack
end

--在队伍中
function Pet:getTeamIndex(...)
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

function Pet:getItemColorName(color, names)
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
    end
    return _names
end

--初始化
function Pet:init(id, did)
    local dictid = nil 
	if id ~= nil then 
		dictid = Tool.getPetDictId(id) or did
	else 
		dictid = did
	end 
	if dictid == nil or tonumber(dictid) == nil then 
		print("没有找到宠物ID: " .. tostring(dictid))
	end 
    self.Table = TableReader:TableRowByID("pet", dictid)
    if self.Table == nil then
        self.Table = TableReader:TableRowByUnique("pet", "name", dictid)
    end
    if self.Table == nil then
        print("readTable err pet , 读表请使用新的ID: dictid " .. tostring(dictid))
        return
    end
	
	-- 此quality改成了读表的star, 服务器中quality为卡片颜色。
	-- 避免改动4、5百处判断条件
    self.quality = self.Table.star
    self.star_level = 0
    self.typeIndex = 6
    self.modelTable = TableReader:TableRowByID("petavter", self.Table.model_id)  
    self.id = tonumber(id or -1)
	self.dictid = self.Table.id
	self.modelid = self.Table.model_id
    self.sex = self.Table.sex
    self:updateInfo()
    self.teamIndex = self:getTeamIndex()
end

--初始化一张卡片
function Pet:new(id, dictid)
    local o = {}
    setmetatable(o, self)
    self.__index = self
    o:init(id, dictid)
    return o
end

return Pet