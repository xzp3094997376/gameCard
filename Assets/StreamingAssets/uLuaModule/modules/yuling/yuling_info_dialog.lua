local m = {}
local initedSkill = false
local initedHeji = false
local initedJiBan = false

function m:destory()
   
end

-- type 
-- 1 碎片
-- 2 御灵
function m:update(lua)
	self.yuling = lua.obj
	--  碎片
	self.suipian:CallUpdateWithArgs(lua)
	-- 模型
	if self.yuling:getType() == "yuling" then 
		
	elseif self.yuling:getType() == "yulingPiece" then 
		self.yuling = Yuling:new(self.yuling.id)
	end 
	self.hero:LoadByModelId(self.yuling.Table.model_id, "idle", function() end, false, 100, 1)
	self.txt_lv_name.text = self.yuling:getDisplayColorName()
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
			m:updateYuling()
		end 
	end
	self.lastType = self.type
end 

function m:updateYuling()
	self.txt_attr_left.text = TextMap.GetValue("Text_1_882") .. self.yuling.Table.hp_init
	self.txt_attr_left2.text = TextMap.GetValue("Text_1_883").. self.yuling.Table.phy_atk_init
	self.txt_attr_right.text = TextMap.GetValue("Text_1_884")..self.yuling.Table.phy_def_init
	self.txt_attr_right2.text = TextMap.GetValue("Text_1_885")..self.yuling.Table.mag_def_init
	--技能
	-- local tb = TableReader:TableRowByID("skill", tonumber(self.yuling.modelTable.normal_skill))
	-- self.txt_name1.text = "[ffff96]【" ..tb.show.."】  [-]" .. tb.desc
	-- local sid = Player.Pets[self.yuling.id].skill[0].skill_id
	-- local tb2 = TableReader:TableRowByID("skill", self.yuling.modelTable.starup_skill[0])
	-- self.txt_name2.text = "[ffff96]【" ..tb2.show.."】  [-]" .. tb2.desc
	-- self.skill_bg.height = self.initSkillBg + self.txt_name2.height - 30

	self.txt_hero_desc.text = self.yuling.Table.desc
	m:updatetianfu()
	m:updatexihao()
    m:updatetujian()
end 

function m:updatexihao()
	local xihaoid = self.yuling.Table.xihaoid
	local xihaoList={}
	for i=0,xihaoid.Count-1 do
		local item = RewardMrg.getDropItem({type="item",arg=xihaoid[i]})
		item.delegate=self
		table.insert(xihaoList,item)
	end
	self.grid_xihao:refresh("",xihaoList,self)
end

function m:updatetujian()
	local suitid = self.yuling.Table.suitid
	local line = TableReader:TableRowByID("yulingtujian", suitid)
	local yulingid = line.yulingid
	local yulingidList={}
	local star = 1
	for i=0,yulingid.Count-1 do
		local item = Yuling:new(yulingid[i])
		if item.star>star then 
			star=item.star
		end 
		item.delegate=self
		table.insert(yulingidList,item)
	end
	self.grid_tujian:refresh("",yulingidList,self)
	self.zuheName.text=Tool.getNameColor(star) .. line.name .. "[-]"
	local addexpmagic = line.addexpmagic
	local index = 1
	for i=1,addexpmagic.Count do
		if addexpmagic[i-1]._magic_effect ~=nil  then 
			local text="[F0E77B]" .. addexpmagic[i-1]._magic_effect.format .. "[-]"
			self["tujian_Label".. index].text=string.gsub(text,"{0}","[-] " .. addexpmagic[i-1].magic_arg1/tonumber(addexpmagic[i-1]._magic_effect.denominator or 1))  
			index=index+1
		end
	end
	for i=index,4 do
		self["tujian_Label".. i].text=""
	end
end

function m:updatetianfu()
	local fetterList = {}
	local tianfu_id = self.yuling.Table.skilltype
	TableReader:ForEachTable("yulingSkill",
        function(index, item)
            if tonumber(item.type) == tonumber(tianfu_id) then 
				local ft = "[ffc864]【" .. item.name .. "】[-]"
				local ftdesc = "[ffc864]" .. item.desc  .. " [-]" 
            	table.insert(fetterList,{name = ft, desc = ftdesc})
            end 
            return false
        end)
    self.tianfu:CallUpdate({ type = "other", list = fetterList })
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