local m = {}
local initedSkill = false
local initedHeji = false
local initedJiBan = false

function m:destory()
   
end

-- type 
-- 1 碎片
-- 2 忍者
-- 3 合击
-- 4 羁绊
function m:update(lua)
	self.char = lua.obj
	--  碎片
	self.suipian:CallUpdateWithArgs(lua)
	-- 模型
	if self.char:getType() == "char" then 
		self.char = Char:new(nil, self.char.dictid)
	elseif self.char:getType() == "charPiece" then 
		self.char = Char:new(nil, self.char.id)
		--self.hero:LoadByModelId(self.char.Table.model_id, "idle", function() end, false, 0, 1)
	end 
	self.hero:LoadByModelId(self.char.Table.model_id, "idle", function() end, false, 0, 1)
	self.txt_lv_name.text = self.char.itemColorName
	self.img_type.spriteName = self.char:getDingWei()
end

function m:onClick(go, name)
	if name == "btn_suipian_gray" then 
		self.type = 1
		m:updateBtnStatus()
	elseif name == "btn_char_gray" then 
		self.type = 2
		m:updateBtnStatus()
	elseif name == "btn_heji_gray" then 
		self.type = 3
		m:updateBtnStatus()
	elseif name == "btn_jiban_gray" then 
		self.type = 4
		m:updateBtnStatus()
	elseif name == "btn_close" then 
		UIMrg:popWindow()
	end
end

function m:updateBtnStatus()
	if self.btnlist == nil then return end 
	for i = 1, #self.btnlist do 
		local item = self.btnlist[i]
		if i == self.type then 
			item.selected:SetActive(true)
			item.normal.gameObject:SetActive(false)
			item.con:SetActive(true)
		else 
			item.selected:SetActive(false)
			item.normal.gameObject:SetActive(true)
			item.con:SetActive(false)
		end 
	end 
	if self.type == 1 then 
		self.con_model:SetActive(false)
	else	 
		self.con_model:SetActive(true)
	end
	if self.type == 2 then 
		if initedSkill == false then 
			-- 更新忍者
			m:updateChar()
		end 
	elseif self.type == 3 then 
		if initedHeji == false then 
			-- 更新合击
			local skills = self.char:getNewXpSkill()
			if #skills == 0 then 
				MessageMrg.show(TextMap.GetValue("Text_1_848"))
				self.type = self.lastType
				m:updateBtnStatus()
				return 
			end
			m:updateHeJi()
		end 
	elseif self.type == 4 then
		-- 更新羁绊
		if initedJiBan == false then 
			m:updateJiBan()
		end 
	end
	self.lastType = self.type
end 

function m:getHeroByFetter(char, drop)
	local heros = {}
	if self.charList == nil then 
		self.charList = {}
		TableReader:ForEachLuaTable("char", function(k, v)
			table.insert(self.charList, v)
		end)
	end
	for i = 0, drop.Count - 1 do
		--print("drop[i] = " .. drop[i].condition_value)
		if char.Table.relationid ~= drop[i].condition_value then 
			for j = 1, #self.charList do 
				if self.charList[j].relationid == drop[i].condition_value then 
					table.insert(heros, {char = self.charList[j], fetter = drop[i].condition_value})
				end 
			end
		end
	end
	local disList = {}
	local leixingChar = -1
	for i = 1, #heros do 
		if heros[i].char.leixing == char.Table.leixing then 
			leixingChar = heros[i].char.id
		end 
		table.insert(disList, {hero = heros[i], dis = math.abs(heros[i].char.star - char.star) })
	end
	if leixingChar == -1 then 
		table.sort(disList, function(a, b)
			return a.dis < b.dis
		end)
		leixingChar = disList[1].hero.char.id
	end
	return leixingChar
end 

function m:updateJiBan()
    self.cout = 0
	local allFetters = {}
	local line = TableReader:TableRowByID("avter", self.char.dictid)
    if line ~= nil then
        if line.relationship == nil or line.relationship.Count==0 then
            print("line.relationship is nil ")
            MessageMrg.show(TextMap.GetValue("Text_1_849"))
			self.type = self.lastType
			m:updateBtnStatus()
			return 
        end
        for i = 0, line.relationship.Count do
            if line.relationship[i] ~= nil and line.relationship[i].."" ~= "" then
				local tb = TableReader:TableRowByID("relationship", line.relationship[i])
				if tb ~= nil then
					if i < 4 then 
						local hero = m:getHeroByFetter(self.char, tb.drop)
						table.insert(allFetters, {did = hero, fetter = tb})
					end
				end 
                if self.cout < 6 then
                    if m:checkFetter(line.relationship[i], list) == false then
                        local fetterName = tb.show_name
							self["txt_fetter" .. self.cout + 1].text = "[9a4c1e]" .. fetterName .. "[-]"
                        self.cout = self.cout + 1
                    end
                end
            end
        end
	end
	ClientTool.UpdateGrid("", self.jiban_Grid, allFetters)
	initedJiBan = true
end

function m:updateHeJi()
	local skills = self.char:getNewXpSkill()
	if #skills > 0 then
		local skill = skills[1]
		self.skill_txt_name.text = "[ffff96]【" .. skill.Table.show .. "】：[-]" .. skill.Table.desc
		self.skill_img_icon.spriteName = m:getIcon(skill.customType)
	end
	initedHeji = true
	TableReader:ForEachLuaTable("skilltie", function(k, v)
		if v.heroid == self.char.dictid then 
			m:updateHeJiHeros(v)
			return 
		else 
			for i = 0, v.ties.Count - 1 do 
				if self.char.dictid == v.ties[i] then 
					m:updateHeJiHeros(v)
					return
				end 
			end 
		end 
	end)
end

function m:updateChar()
	self.txt_attr_left.text = TextMap.GetValue("Text_1_882") .. self.char.Table.hp_init
	self.txt_attr_left2.text = TextMap.GetValue("Text_1_883").. self.char.Table.phy_atk_init
	self.txt_attr_right.text = TextMap.GetValue("Text_1_884")..self.char.Table.phy_def_init
	self.txt_attr_right2.text = TextMap.GetValue("Text_1_885")..self.char.Table.mag_def_init
	local lua = { type = "skill", nChar = self.char, char = self.char }
	self.skill:CallUpdate(lua)
	local fetterList = self:getAllFetter()
	self.fate:CallUpdate({ type = "other", list = fetterList })
	initedSkill = true
end 

function m:updateHeJiHeros(skillTieItem)
	local list = {}
	table.insert(list, {dictid = skillTieItem.heroid, showadd = true})
	for i = 0, skillTieItem.ties.Count - 1 do 
		if i == skillTieItem.ties.Count - 1 then 
			table.insert(list, {dictid = skillTieItem.ties[i], showadd = false})		
		else
			table.insert(list, {dictid = skillTieItem.ties[i], showadd = true})	
		end 
	end
	ClientTool.UpdateGrid("", self.heji_Grid, list)
end 

function m:getIcon(type)
	local str = ""
	if type == 1 then 	-- 普通攻击
		str = "jineng_pu"
	elseif type == 2 then -- 普通技能
		str = "jineng_ji"
	elseif type == 3 or type == 4 then -- 合体技	
		str = "jineng_he"
	end 
	return str
end 

function m:Start()
	self.type = 1
	self.lastType = 1
	self.btnlist = { 
		{normal = self.btn_suipian_gray, selected = self.btn_suipian, con = self.con_suipian},
		{normal = self.btn_char_gray, selected = self.btn_char, con = self.con_char},
		{normal = self.btn_heji_gray, selected = self.btn_heji, con = self.con_heji},
		{normal = self.btn_jiban_gray, selected = self.btn_jiban, con = self.con_jiban}
	}
	m:updateBtnStatus()
end

--获取所有的羁绊
function m:getAllFetter()
	local fetterList = {}
    local line = self.char.modelTable
    if line ~= nil then
        if line.relationship == nil then
            print("line.relationship is nil ")
        end
		local that = self 
        for i = 0, line.relationship.Count - 1 do
            if line.relationship[i] ~= nil and line.relationship[i].."" ~= "" then
                local tb = TableReader:TableRowByID("relationship", line.relationship[i])
                local fetterName = tb.show_name
				local ft = ""
				local ftdesc = ""
				local ret = that:checkFetter(tb.id)
				if  ret == true then 
					ft = "[ff0000]【" .. fetterName .. "】[-]"
					ftdesc = "[ff0000]" .. tb.desc_eff  .. " [-]" 
				else 
					ft = "[ffc864]【" .. fetterName .. "】[-]"
					ftdesc = "[ffc864]" .. tb.desc_eff  .. " [-]" 
				end 
				table.insert(fetterList, {name = ft, desc = ftdesc})
            end
        end
	end
	return fetterList
end

function m:checkFetter(id)
    local list = self:getFetter(self.char.id) -- 获取该角色已经激活的羁绊列表
	local ret = false
    for i = 1, #list do
		local item = list[i]
        local line = TableReader:TableRowByID("relationship", item)
        if line == nil then
            line = TableReader:TableRowByUnique("relationship", item)
        end
		if line.id == id then return true end 
    end
	return false
end 

--获取某个角色已激活的羁绊id列表
function m:getFetter(id)
    if id == nil then return end
    local fetters = Player.Chars[id].tie:getLuaTable()
    local tb = {}
    table.foreach(fetters, function(i, v)
        if v ~= nil then
            table.insert(tb, v)
        end
    end)
    return tb
end

return m