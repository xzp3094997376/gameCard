local m = {}
local initedSkill = false
local initedHeji = false
local initedJiBan = false

function m:destory()
   
end

-- type 
-- 1 碎片
-- 2 宠物
function m:update(lua)
	self.pet = lua.obj
	--  碎片
	self.suipian:CallUpdateWithArgs(lua)
	-- 模型
	if self.pet:getType() == "pet" then 
		
	elseif self.pet:getType() == "petPiece" then 
		self.pet = Pet:new(nil, self.pet.id)
		--self.hero:LoadByModelId(self.char.Table.model_id, "idle", function() end, false, 0, 1)
	end 
	self.hero:LoadByModelId(self.pet.Table.model_id, "idle", function() end, false, 100, 1)
	self.txt_lv_name.text = self.pet.itemColorName
end

function m:onClick(go, name)
	if name == "btn_suipian_gray" then 
		self.type = 1
		m:updateBtnStatus()
	elseif name == "btn_pet_gray" then 
		self.type = 2
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
			-- 更新宠物
			m:updatePet()
		end 
	end
	self.lastType = self.type
end 

function m:updatePet()
	--local lua = { type = "skill", nChar = self.char, char = self.char }
	--self.skill:CallUpdate(lua)
	--local fetterList = self:getAllFetter()
	--self.fate:CallUpdate({ type = "other", list = fetterList })
	--initedSkill = true
	self.txt_attr_left.text = TextMap.GetValue("Text_1_882") .. self.pet.Table.hp_init
	self.txt_attr_left2.text = TextMap.GetValue("Text_1_883").. self.pet.Table.phy_atk_init
	self.txt_attr_right.text = TextMap.GetValue("Text_1_884")..self.pet.Table.phy_def_init
	self.txt_attr_right2.text = TextMap.GetValue("Text_1_885")..self.pet.Table.mag_def_init
	local tb = TableReader:TableRowByID("skill", tonumber(self.pet.modelTable.normal_skill))
	self.txt_name1.text = "[ffff96]【" ..tb.show.."】  [-]" .. tb.desc
	local sid = Player.Pets[self.pet.id].skill[0].skill_id
	local tb2 = TableReader:TableRowByID("skill", self.pet.modelTable.starup_skill[0])
	self.txt_name2.text = "[ffff96]【" ..tb2.show.."】  [-]" .. tb2.desc
	self.skill_bg.height = self.initSkillBg + self.txt_name2.height - 30
	local row = TableReader:TableRowByUniqueKey("petShenlian", self.pet.dictid, 30)
	self.pos_pet:CallUpdate(row)
	self.txt_hero_desc.text = self.pet.Table.desc
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
	self.initSkillBg = self.skill_bg.height
	self.btnlist = { 
		{normal = self.btn_suipian_gray, selected = self.btn_suipian, con = self.con_suipian},
		{normal = self.btn_pet_gray, selected = self.btn_pet, con = self.con_pet}
	}
	m:updateBtnStatus()
end

return m