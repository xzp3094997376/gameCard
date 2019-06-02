
local pet_info = {}

function pet_info:update(pet)
    pet_info:setHero(pet)
    self.pet = Pet:new(pet.id, pet.dictid)
    local lua = { nChar = self.pet, pet = pet }
	self:onUpdate()
end



function pet_info:SetTihuanAndXiexiaBtn(ret,lua)
    self.btn_tihuan.gameObject:SetActive(ret)
    self.btn_xiexia.gameObject:SetActive(ret)
    self.tihuanLua = lua
    self.delegate = lua.delegate
end

function pet_info:onEnter()
	self:onUpdate()
end 

function pet_info:onUpdate()
	self.pet:updateInfo()
	self:updateDes()
	pet_info:updatePiece()
	--self.btn_lvup.isEnabled = true
	--self.btn_evolution.isEnabled = true
	--self.btn_blood.isEnabled = true
	--self.btn_wake.isEnabled = true
	
	self.open_lv = self:checkLockNoMsg(151)
	self.open_star = self:checkLockNoMsg(152)
	self.open_shenlian = self:checkLockNoMsg(153)
	
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

function pet_info:updatePiece()
	local pet = self.pet
	local row = TableReader:TableRowByUniqueKey("petstarUp", pet.dictid, pet.star_level + 1)
    self.txt_progress.text = ""
	self.bar_star.value = 0
	self.baseData = nil
	if row then
        local consume = RewardMrg.getConsumeTable(row.consume, pet.dictid)
        local list = {}
		local progressMin = 0
		local progressMax = 0
        table.foreach(consume, function(i, v)
            local t = v:getType()
            if t == "petPiece" then
                progressMin = v.rwCount
				progressMax = Tool.getCountByType(v:getType(), v.id)
				self.baseData = v
            end
        end)
		self.txt_progress.text = progressMax .. "/" .. progressMin
		self.bar_star.value = progressMax / progressMin
    end
	local row2 = TableReader:TableRowByUniqueKey("petstarUp", pet.dictid, pet.star_level)
	if row2 then 
		self.txt_skill_damage.text = TextMap.GetValue("Text_1_874") .. (row2.skill_dmg / 10) .. "%"
	else 
		self.txt_skill_damage.text = TextMap.GetValue("Text_1_874") .. "0%"
	end
	
end 

function pet_info:updateRedPoint()
	--更新红点提示
	local pet = self.pet
    self.redPoint_lv:SetActive(pet:redPointForStrong() and self.open_lv) --升级突破
    self.redPoint_jinhua:SetActive(pet:redPointForJinHua() and self.open_star) --升星
    self.redPoint_shenlian:SetActive(pet:redPointForShenlian() and self.open_shenlian) --神炼
end 

function pet_info:updateDes()
	    --属性与描述
    local list = self.pet:getAttrDesc()
	self.txt_attr_left.text = list[2]
	self.txt_attr_left2.text = list[4]
	self.txt_attr_right.text = list[1]
	self.txt_attr_right2.text = list[5]

	self.txtLv.text = TextMap.GetValue("Text_1_876") .. self.pet.lv
	self.txt_hero_desc.text = self.pet.Table.desc
	
	self.notation.text = TextMap.GetValue("Text_1_877") .. (self.pet.Table.huyou / 10) .. TextMap.GetValue("Text_1_878")
	local tb = TableReader:TableRowByID("skill", tonumber(self.pet.modelTable.normal_skill))
	self.txt_name1.text = "[ffff96]【" ..tb.show.."】  [-]" .. tb.desc
	local sid = Player.Pets[self.pet.id].skill[0].skill_id
	local tb2 = TableReader:TableRowByID("skill", sid)
	self.txt_name2.text = "[ffff96]【" ..tb2.show.."】  [-]" .. tb2.desc
	self.skill_bg.height = self.initSkillBg + self.txt_name2.height - 30
	local row = TableReader:TableRowByUniqueKey("petShenlian", self.pet.dictid, self.pet.shenlian)
	self.pos_pet:CallUpdate(row)
	
	self.txt_shenlian.text = TextMap.GetValue("Text_1_879") .. self.pet.shenlian
	self.img_type.spriteName = "chongwu_" .. self.pet.star
	self.txt_pet_power.text = self.pet.power
end 

function pet_info:setHero(pet)
	self.hero:LoadByModelId(pet.modelid, "idle", function() end, false, 100, 1)
	self.txt_lv_name.text = pet:getDisplayName()
    local tp = pet:getType()
    local star = nil
    local piece = pet
end

function pet_info:Start()
	self.btnType = 1
	self.initSkillBg = self.skill_bg.height
	Tool.loadTopTitle(self.gameObject, TextMap.GetValue("Text_1_880"))
end


function pet_info:onClick(go, name)
	print("name = " .. name)
    if name == "btnBack" then
        UIMrg:pop()
    elseif name == "btn_change" then
        self:onClickChange()
	elseif name == "btn_lvup" then 
		--local isopen = self:checkLock(227)
		--if isopen then 
			UIMrg:push("pet_main", "Prefabs/moduleFabs/pet/pet_main", { pet = self.pet, tp = 1 })
		--end 
	elseif name == "btn_evolution" then 
		--local isopen = self:checkLock(228)
		--if isopen then 
			UIMrg:push("pet_main", "Prefabs/moduleFabs/pet/pet_main", { pet = self.pet, tp = 2 })
		--end
	elseif name == "btn_shenlian" then 
		--local isopen = self:checkLock(230)
		--if isopen then 
			UIMrg:push("pet_main", "Prefabs/moduleFabs/pet/pet_main", { pet = self.pet, tp = 3 })
		--end
	elseif name == "btn_left" then 
		self:onLeft()
	elseif name == "btn_right" then 
		self:onRight()
    elseif name =="btn_tihuan" then 
        UIMrg:pop()
        local bind = UIMrg:pushWindow("Prefabs/moduleFabs/formationModule/formation/formation_select_char")
        bind:CallUpdate(self.tihuanLua)
    elseif name =="btn_xiexia" then  
        if self.tihuanLua.type == "single" then
            if self.tihuanLua.module=="teamer" then 
                self.delegate:onCallBack(nil, self.tihuanLua.module)
                UIMrg:pop()
            end
        end
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

function pet_info:checkLockNoMsg(id)
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

function pet_info:checkLock(id)
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

function pet_info:onLeft()
	if self.allChars == nil then 
		self:findHeroList()
	end  
	
	self.index = self.index - 1
	if self.index < self.minIndex then self.index = self.minIndex end 
	self:updateHero()
end 

function pet_info:onRight()
	if self.allChars == nil then 
		self:findHeroList()
	end
	
	self.index = self.index + 1
	if self.index > self.maxIndex then self.index = self.maxIndex end 
	self:updateHero()
end 

function pet_info:updateHero()
	self:update(self.allChars[self.index])
end 

return pet_info
