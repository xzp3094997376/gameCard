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
	self.ghost = lua.obj
	--  碎片
	self.suipian:CallUpdateWithArgs(lua)
	-- 模型
	if self.ghost:getType() == "ghost" then 
		
	elseif self.ghost:getType() == "ghostPiece" then 
		local id = TableReader:TableRowByUnique("ghost", "name", self.ghost.Table.name).id
		self.ghost = Ghost:new(id)
		--self.hero:LoadByModelId(self.char.Table.model_id, "idle", function() end, false, 0, 1)
	end 
	--self.hero:LoadByModelId(self.ghost.Table.model_id, "idle", function() end, false, 100, 1)
	self.txt_lv_name.text = self.ghost.itemColorName
end

function m:onClick(go, name)
	if name == "btn_suipian_gray" then 
		self.type = 1
		m:updateBtnStatus()
	elseif name == "btn_equip_gray" then 
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
			m:updateEquip()
		end 
	end
	self.lastType = self.type
end 

function m:updateEquip()
	self.equip.Url = self.ghost:getHead()
	self.txt_lv_name.text = self.ghost:getDisplayColorName()
	local magic = self.ghost:getMagic()[1]
	self.txt_attr_left.text = string.gsub(magic.format, "{0}", "[ffffff]" .. magic.arg)
	self.txt_qianhua.text = string.gsub(magic.format, "{0}", "[ffffff]" .. magic.arg2)
	self.txt_desc.text = self.ghost.desc
	self.txt_suit.text = self.ghost:getSuitName()
	local suitList = self.ghost:getEquipSuit()
	ClientTool.UpdateGrid("", self.content, suitList)
	
	self.txt_suit_des.text = self.ghost.suitDesc
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
	self.btnlist = { 
		{normal = self.btn_suipian_gray, selected = self.btn_suipian, con = self.con_suipian},
		{normal = self.btn_equip_gray, selected = self.btn_equip, con = self.con_equip}
	}
	m:updateBtnStatus()
end

return m