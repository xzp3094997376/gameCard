local m = {}

function m:update(lua)
	self.tp = lua.tp
	self.char = lua.char
	self.targetInfo = lua.targetInfo
	self:onUpdate()
	self:updateStatus()
end

function m:onUpdate()
	if self.char == nil then return end
	if self.__itemAll == nil then
        self.__itemAll = ClientTool.loadAndGetLuaBindingFromPool("Prefabs/publicPrefabs/itemAll", self.img_icon.gameObject)
    end
    self.__itemAll:CallUpdate({ "char", self.char, self.img_icon.width, self.img_icon.height, nil, nil, true })
	self.txt_name.text = self.char:getDisplayName()
end

function m:getMagics(list)
	local info = self.char.info.propertys 
	if self.targetInfo ~= nil then 
		info = self.targetInfo.propertys
	end 
	local str = ""
	for i = 1, #list do 
		local desc = GetAttr(list[i], info)
		str = str .. desc .. "\n"
	end 
	return str
end

function m:Start()
	
end

function m:OnDestroy()
	
end

function m:onHuaShen()
	local qlv = self.char.qlv
	local proIdList = {}
	local proTitleList = {}
	for i = 1, qlv do
		local preInfo = TableReader:TableRowByUniqueKey("qualitylevel", self.char.dictid, i)
		for j = 0, 3 do
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
	local str = ""
	for k, v in pairs(proIdList) do
		str = str .. proTitleList[k] .. v .. "\n"
	end
	local text = m:getHuaShenLevel(qlv, self.char.dictid, self.char.star)
	self.txt_lv.text = text
	self.txt_attr.text = str
end

function m:onJueXing()
	if self.char == nil then return end
    local equips = nil
	-- 觉醒
	if self.targetInfo ~= nil then 
		local list = {}
		local eqs = self.targetInfo.equip
		local jd = json.decode(tostring(eqs))
		for k,v in pairs(jd) do 
			local pos = tonumber(k)
			local id = v.i
			table.insert(list, {id = id, pos = pos})
		end
		equips = self.char:getEquipsByInfo(list)
	else
		equips = self.char:getEquips(true)
	end 

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
	local star = math.floor ( self.char.stage / 10 )
	local starLv = math.fmod(self.char.stage,10)
	if starLv < 0 then starLv = 0 end
	local msg = string.gsub(TextMap.GetValue("LocalKey_811"),"{0}",star)
	self.txtStar.text =string.gsub(msg,"{1}",starLv)
end 

function m:onJinHua()
	if self.char == nil then return end
	local strs = self:getMagics({"MaxHp", "PhyAtk", "PhyDef", "MagDef" })
	self.txt_attr.text = strs
	self.txt_lv.text = TextMap.GetValue("Text_1_795")..self.char.star_level
end

function m:onLv()
	if self.char == nil then return end
	local strs = self:getMagics({"MaxHp", "PhyAtk", "PhyDef", "MagDef" })
	self.txt_attr.text = strs
	self.txt_lv.text = TextMap.GetValue("Text_1_306")..self.char.lv
end 

function m:onXueMai()
	if self.char == nil then return end
	local attr = TableReader:TableRowByUniqueKey("bloodlineArg", self.char.bloodlv, self.char.star)
	local txt, list, nList1 = m:getMagicsByBlood(attr.magic)
	local str = list[2] .. list[3] .. list[1] .. list[4]

	self.txt_attr.text = str
	self.txt_lv.text = TextMap.GetValue("Text_1_796")..self.char.bloodlv
	
	local skill = nil
	local xpSkill = nil
	local skillUp = self:getSkillByType(attr.skillLvup, "skill")
	local xpSkillUp = self:getSkillByType(attr.skillLvup, "xp_skill")
	skill = self.char.modelTable._skill[skillUp.skill_slot-1]
	xpSkill = self.char.modelTable._xp_skill[skillUp.skill_slot-1]
	self.txt_skill_name.text = skill and ("[ffff96]" .. skill.show .. "：[-]" .. string.gsub(TextMap.GetValue("LocalKey_812"),"{0}",skillUp.skillLv)) or ""
	self.txt_xp_name.text = (xpSkill ~= nil) and ("[ffff96]" .. xpSkill.show .. "：[-]" .. string.gsub(TextMap.GetValue("LocalKey_812"),"{0}",xpSkillUp.skillLv)) or "" 
	self.skill_xp:SetActive(xpSkill ~= nil)
end
	
function m:onPeiYang()
	local desc = {TextMap.GetValue("Text_1_797"), TextMap.GetValue("Text_1_798"), TextMap.GetValue("Text_1_799"), TextMap.GetValue("Text_1_800")}
	local str = ""
	local xlInfo = self.char.info.xilian 
	if self.targetInfo ~= nil then 
		xlInfo = self.char.source.xilian
	end 
	local xilian = m:getAttrList(xlInfo)
	local lv = m:getMaxLevel(self.char.lv)
	if Tool.charXilianIds == nil then 
		local _list = {}
		TableReader:ForEachLuaTable("charXilianSettings", function(index, item)
			local kind, star, level, id = item.kind, item.star, item.level, item.id
			local li = {}
			for o = 0, item.limit.Count - 1 do
				li[o + 1] = item.limit[o]
			end
			_list[kind .. "_" .. star .. "_" .. level] = li
			return false
		end)
		Tool.charXilianIds = _list
	end 
	local row = Tool.charXilianIds["char_" .. self.char.star .. "_" .. lv]
	for i = 1, 4 do
		str = str .. "[ffff96]"..desc[i].."[-]" .. xilian[i].."/"..row[i].."\n"
	end
	self.txt_attr.text = str
end

function m:getMaxLevel(lv)
    if Tool.charXilianLevels then
        local item = Tool.charXilianLevels["char_" .. self.char.star]
        if item == nil then return 20 end
        local l = 20
        table.foreach(item, function(i, v)
            if lv <= v then l = v return l end
        end)
        return l
    end
    return 20
end

function m:getAttrList(arg)
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

function m:updateStatus()
	if self.tp == 1 then 
		-- 内容
		self.txt_lv.gameObject:SetActive(true)
		self.txt_attr.gameObject:SetActive(true)
		
		self.juexing:SetActive(false)
		self.skill_normal.gameObject:SetActive(false)
		self.skill_xp.gameObject:SetActive(false)
		m:onLv()
	elseif self.tp == 2 then 
		-- 内容
		self.txt_lv.gameObject:SetActive(true)
		self.txt_attr.gameObject:SetActive(true)
		
		self.juexing:SetActive(false)
		self.skill_normal.gameObject:SetActive(false)
		self.skill_xp.gameObject:SetActive(false)
		m:onJinHua()
	elseif self.tp == 3 then 	
		-- 内容
		self.txt_lv.gameObject:SetActive(false)
		self.txt_attr.gameObject:SetActive(true)
		
		self.juexing:SetActive(false)
		self.skill_normal.gameObject:SetActive(false)
		self.skill_xp.gameObject:SetActive(false)
		m:onPeiYang()
	elseif self.tp == 4 then 
		-- 内容
		self.txt_lv.gameObject:SetActive(true)
		self.txt_attr.gameObject:SetActive(true)
		
		self.juexing:SetActive(false)
		self.skill_normal.gameObject:SetActive(true)
		self.skill_xp.gameObject:SetActive(true)
		m:onXueMai()
	elseif self.tp == 5 then 
		-- 内容
		self.txt_lv.gameObject:SetActive(false)
		self.txt_attr.gameObject:SetActive(false)
		
		self.juexing:SetActive(true)
		self.skill_normal.gameObject:SetActive(false)
		self.skill_xp.gameObject:SetActive(false)
		m:onJueXing()
	elseif self.tp == 6 then 
		-- 内容
		self.txt_lv.gameObject:SetActive(true)
		self.txt_attr.gameObject:SetActive(true)
		
		self.juexing:SetActive(false)
		self.skill_normal.gameObject:SetActive(false)
		self.skill_xp.gameObject:SetActive(false)
		m:onHuaShen()
	end 
end 

function m:getMagicsByBlood(magics, isRight)
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

function m:getHuaShenLevel(qlv, dictid, quality)
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
                text = TextMap.GetValue("Text_1_801") ..huaSInfo.desc
            elseif quality == 6 then
                text = TextMap.GetValue("Text_1_802") ..huaSInfo.desc
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

function m:getSkillByType(arr, type)
	for i = 0, arr.Count - 1 do 
		if arr[i].skill_type == type then 
			return arr[i]
		end 
	end 
	return nil 
end 

return m

