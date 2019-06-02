
local m = {}

function m:update(data)
	local pet = data.pet
	self.delegate = data.delegate
    m:setHero(pet)
    self.pet =Yuling:new(pet.id)
    local lua = { nChar = self.pet, pet = pet }
    m:updatexihao()
    m:updatetujian()
	self:onUpdate()
	self.btn_tihuan.gameObject:SetActive(data.isShow or false) 
	self.btn_xiexia.gameObject:SetActive(data.isShow or false) 
end

function m:onEnter()
	self:onUpdate()
end 

function m:onUpdate()
	self.pet:updateInfo()
	self:updateDes()
	m:updatePiece()
	m:updatetianfu()
	
	self.open_lv = self:checkLockNoMsg(27)
	self.open_star = self:checkLockNoMsg(27)
	
	self:updateRedPoint()
	local star = self.pet.star_level
	local starLists = {}
	local showStar = false
    for i = 1, 5 do
		showStar = false
		if i <= star then 
			showStar = true
		end
        starLists[i] = { isShow = showStar }
    end
	self.stars:refresh("", starLists, self)
	self.stars_2:refresh("", starLists, self)
end 

function m:updatexihao()
	local xihaoid = self.pet.Table.xihaoid
	local xihaoList={}
	for i=0,xihaoid.Count-1 do
		local item = RewardMrg.getDropItem({type="item",arg=xihaoid[i]})
		item.delegate=self
		table.insert(xihaoList,item)
	end
	self.grid_xihao:refresh("",xihaoList,self)
end

function m:updatetujian()
	local suitid = self.pet.Table.suitid
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
    local tianfu_id = self.pet.Table.skilltype
	TableReader:ForEachTable("yulingSkill",
        function(index, item)
            if tonumber(item.type)==tonumber(tianfu_id) then 
            	local ft = ""
				local ftdesc = ""
				if  tonumber(item.unlock)<=self.pet.lv then 
					ft = "[ff0000]【" .. item.name .. "】[-]"
					ftdesc = "[ff0000]" .. item.desc  .. " [-]" 
				else 
					ft = "[ffc864]【" .. item.name .. "】[-]"
					ftdesc = "[ffc864]" .. item.desc  .. " [-]" 
				end 
            	table.insert(fetterList,{name = ft, desc = ftdesc})
            end 
            return false
        end)
	self.tianfu:CallUpdate({ type = "other", list = fetterList })
end


function m:updatePiece()
	local pet = self.pet
	local row = TableReader:TableRowByUniqueKey("yulingstarUp", pet.id, pet.star_level + 1)
    self.txt_progress.text = ""
	self.bar_star.value = 0
	self.baseData = nil
	if row then
        local consume = RewardMrg.getConsumeTable(row.consume, pet.id)
        local list = {}
		local progressMin = 0
		local progressMax = 0
        table.foreach(consume, function(i, v)
            local t = v:getType()
            if t == "yulingPiece" then
                progressMin = v.rwCount
				progressMax = Tool.getCountByType(v:getType(), v.id)
				self.baseData = v
            end
        end)
		self.txt_progress.text = progressMax .. "/" .. progressMin
		self.bar_star.value = progressMax / progressMin
    end
	-- local row2 = TableReader:TableRowByUniqueKey("yulingstarUp", pet.id, pet.star_level)
	-- if row2 then 
	-- 	self.txt_skill_damage.text = TextMap.GetValue("Text_1_874") .. (row2.skill_dmg / 10) .. "%"
	-- else 
	-- 	self.txt_skill_damage.text = TextMap.GetValue("Text_1_874") .. "0%"
	-- end
	self.txt_skill_damage.text=""
end 

function m:updateRedPoint()
	--更新红点提示
	local pet = self.pet
    self.redPoint_lv:SetActive(pet:redPointForStrong() and self.open_lv) --升级突破
    self.redPoint_jinhua:SetActive(pet:redPointForJinHua() and self.open_star) --升星
end 

function m:updateDes()
	    --属性与描述
    local list =self.pet:getAttrDesc()
	self.txt_attr_left.text = list[1]
	self.txt_attr_left2.text = list[3]
	self.txt_attr_right.text = list[2]
	self.txt_attr_right2.text = list[4]
	local iconName = TableReader:TableRowByUnique("resourceDefine", "name","haogandu").img
	self.img.Url=UrlManager.GetImagesPath("itemImage/"..iconName..".png")
	self.lv_num.text =self.pet.lv
	self.txt_hero_desc.text = self.pet.Table.desc
	
	--技能
	-- local tb = TableReader:TableRowByID("skill", tonumber(self.pet.modelTable.normal_skill))
	-- self.txt_name1.text = "[ffff96]【" ..tb.show.."】  [-]" .. tb.desc
	-- local sid = Player.yuling[self.pet.id].skill[0].skill_id
	-- local tb2 = TableReader:TableRowByID("skill", sid)
	-- self.txt_name2.text = "[ffff96]【" ..tb2.show.."】  [-]" .. tb2.desc
	-- self.skill_bg.height = self.initSkillBg + self.txt_name2.height - 30

	self.img_type.spriteName = "chongwu_" .. self.pet.star
	self.txt_pet_power.text = self.pet.power
end 

function m:setHero(pet)
	self.hero:LoadByModelId(pet.modelid, "idle", function() end, false, 100, 1)
	self.txt_lv_name.text = pet:getDisplayName()
end

function m:Start()
	self.btnType = 1
	self.initSkillBg = self.skill_bg.height
	Tool.loadTopTitle(self.gameObject, TextMap.GetValue("Text_1_3001"))
end


function m:onClick(go, name)
	print("name = " .. name)
    if name == "btnBack" then
        UIMrg:pop()
    elseif name == "btn_change" then
        self:onClickChange()
	elseif name == "btn_lvup" then 
		UIMrg:push("yuling", "Prefabs/moduleFabs/yuling/yuling_cultivate", { pet = self.pet, tp = 1 })
	elseif name == "btn_evolution" then 
		UIMrg:push("yuling", "Prefabs/moduleFabs/yuling/yuling_cultivate", { pet = self.pet, tp = 2 })
	elseif name == "btn_left" then 
		self:onLeft()
	elseif name == "btn_right" then 
		self:onRight()
    elseif name =="btn_tihuan" then 
        UIMrg:pop()
        local bind = UIMrg:pushWindow("Prefabs/moduleFabs/formationModule/formation/formation_select_char")
        bind:CallUpdate({ type = "yuling", delegate = self.delegate, index = 1 })
    elseif name =="btn_xiexia" then  
       UIMrg:pop()
       self.delegate:YulingXiexia()
	elseif name == "btn_add" then 
		if self.baseData ~= nil then 
			local temp = {}
			temp.obj = self.baseData
			temp._type = "petPiece"
			temp.type = 1
			MessageMrg.showTips(temp)
		end
	elseif name == "btn_property" then 
		local maxShenlian = Tool.GetPetArgs("shenlian_max_lv")
		UIMrg:pushWindow("Prefabs/moduleFabs/pet/pet_shenlian_dialog", {pet = self.pet, cur = self.pet.shenlian, next = maxShenlian})
	elseif name == "btn_skill" then 
		UIMrg:pushWindow("Prefabs/moduleFabs/pet/pet_skill_des", {pet = self.pet})
	end
end

function m:checkLockNoMsg(id)
	local linkData = Tool.readSuperLinkById( id)
    local unlockType = linkData.unlock[0].type --解锁条件
    if unlockType ~= nil then
        local level = linkData.unlock[0].arg
        if Player.Info.level < level or Player.Info.vip < linkData.vipLevel then
           return false
        end
	end
	return true
end

function m:checkLock(id)
	local linkData = Tool.readSuperLinkById( id)
    local unlockType = linkData.unlock[0].type --解锁条件
    if unlockType ~= nil then
        local level = linkData.unlock[0].arg
        if Player.Info.level < level or Player.Info.vip < linkData.vipLevel then
            MessageMrg.show(string.gsub(TextMap.GetValue("Text_1_881"), "{0}", level))
            return false
        end
	end
	return true
end

function m:onLeft()
	if self.allChars == nil then 
		self:findHeroList()
	end  
	
	self.index = self.index - 1
	if self.index < self.minIndex then self.index = self.minIndex end 
	self:updateHero()
end 

function m:onRight()
	if self.allChars == nil then 
		self:findHeroList()
	end
	
	self.index = self.index + 1
	if self.index > self.maxIndex then self.index = self.maxIndex end 
	self:updateHero()
end 

function m:updateHero()
	self:update(self.allChars[self.index])
end 

return m
