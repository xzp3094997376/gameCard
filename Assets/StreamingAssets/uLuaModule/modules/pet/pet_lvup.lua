
-- 英雄升级
local m = {}

function m:update(lua)
    self.delegate = lua.delegate
    self:onUpdate(lua.pet, true)
end

function m:showOperateAlert(desc)
    self.binding:CallManyFrame(function()
        OperateAlert.getInstance:showToGameObject(desc, self.bottom)
    end)
end

function m:updateDesc()
    local pet = self.pet
    --属性与描述
    --local list = pet:getAttrDesc()
	local atr2_n, atr_s = self.pet:GetAttrNew("PhyAtk", pet.info.propertys)
	local pd2_n, pd_s = self.pet:GetAttrNew("PhyDef", pet.info.propertys)
	local life2_n, life_s = self.pet:GetAttrNew("MaxHp", pet.info.propertys)
	local md2_n, md_s =self.pet:GetAttrNew("MagDef", pet.info.propertys)
	
	self.txt_attr_left.text = atr_s  .. "\n" .. pd_s--string.gsub(list[3], "\n", "")
	--self.txt_attr_left2.text = md_s --string.gsub(list[7], "\n", "")
	self.txt_attr_right.text = life_s .. "\n" .. md_s --string.gsub(list[9], "\n", "")
	--self.txt_attr_right2.text = pd_s --string.gsub(list[1], "\n", "")

		
	self.txt_name.text = pet:getDisplayName()
	self.txtLv.text = TextMap.GetValue("Text_1_772") .. (pet.lv)
	--self.txt_cur_lv.text = TextMap.GetValue("Text_1_772") .. (pet.lv)
	--self.txt_next_lv.text = TextMap.GetValue("Text_1_772") .. (pet.lv + 1)
	--self.txt_cur_lv.text = TextMap.GetValue("Text_1_772") .. (pet.lv)
 
	local exp1 = self.pet:GetPetExp(pet.lv, pet.star)
	local curExp = m:getCurrentExp(self.pet.info.exp)
	self.txtExp.text =  curExp .. "/" .. exp1
    self.exp.value = curExp / exp1
	self.txt_power.text = pet.power

    self:updateExp()
	

	--local chars = Player.Chars:getLuaTable()
	--print_t(chars)
end

function m:updateAddDesc(propertys)
	
	self.right:SetActive(true)
	
	local atr_n = self.pet:GetAttrNew("PhyAtk", propertys,true)
	local pd_n = self.pet:GetAttrNew("PhyDef", propertys,true)
	local life_n = self.pet:GetAttrNew("MaxHp", propertys,true)
	local md_n = self.pet:GetAttrNew("MagDef", propertys,true)
	
	local atr_n2 = self.pet:GetAttrNew("PhyAtk", self.pet.info.propertys)
	local pd_n2 = self.pet:GetAttrNew("PhyDef", self.pet.info.propertys)
	local life_n2 = self.pet:GetAttrNew("MaxHp", self.pet.info.propertys)
	local md_n2 = self.pet:GetAttrNew("MagDef", self.pet.info.propertys)
	
	self.txt_life.text = "[00ff00]"..(life_n - life_n2).."[-]"
	self.txt_atk.text = "[00ff00]"..(atr_n - atr_n2).."[-]"
	self.txt_pd.text = "[00ff00]"..(pd_n - pd_n2).."[-]"
	self.txt_md.text = "[00ff00]"..(md_n - md_n2).."[-]"
end

function m:updateExp()
	if self.meterials ~= nil then 
		local exp = 0
		table.foreach(self.meterials, function(i, v)
			if v ~= "0" and v ~= 0 then
				local pet = v
				exp = exp + v.exp
			end
		end)
		self.total = exp
		local lv = m:getLvup(exp)
		if lv > self.max_pet_lv then lv = self.max_pet_lv end
		self.slider_shine.gameObject:SetActive(true)
		if lv > 0 then 
			Api:getPetProperty(self.pet.id, lv , 0, 0, function(result)
				m:updateAddDesc(result.propertys)
			end)
			self.txtLvAdd.text = "+" .. lv
		else 
			self.right:SetActive(false)
			self.txtLvAdd.text = ""
			--self.slider_shine.gameObject:SetActive(false)
		end 
		if exp > 0 then 
			local vrExp = m:getCurrentExp(exp + self.pet.info.exp)
			local nExp = self.pet:GetPetExp(self.pet.lv + lv, self.pet.star)
			self.txtExp.text =  vrExp .. "/" .. nExp
			--self.exp.value = vrExp / nExp
			self.slider_shine.value = vrExp / nExp
		else 
			local exp1 = self.pet:GetPetExp(self.pet.lv, self.pet.star)
			local curExp = m:getCurrentExp(self.pet.info.exp)
			self.txtExp.text =  curExp .. "/" .. exp1
			self.exp.value = curExp / exp1
			self.slider_shine.gameObject:SetActive(false)
		end 
	else 
		self.txtLvAdd.text = ""
	end 
	
	m:updateLevelInfo()
end 

function m:getCurrentExp(totalExp)
	local total = totalExp --self.pet.info.exp
	local lv = self.pet.lv
	local lvupExp = self.pet:GetPetTotalExp(lv, self.pet.star)
	local level = 0
	local exp = total - self.pet:GetPetTotalExp(lv-1, self.pet.star)
	if lvupExp == nil then return exp end
	while total >= lvupExp and lvupExp ~= -1 do 
		--total = total - lvupExp
		level = level + 1
		exp = total - lvupExp
		if lv + level > Player.Info.level then 
			return exp
		end 
		lvupExp = self.pet:GetPetTotalExp(lv + level, self.pet.star)
	end 
	return exp
end

function m:getVrCurrentExp(addExp)
	local total = self.pet.info.exp + addExp
	local lv = self.pet.lv
	local lvupExp = GetPetTotalExp(lv - 1, self.pet.star)
	local level = 0
	local exp = total - lvupExp
	if lvupExp == nil then return exp end
	while total >= lvupExp do 
		--total = total - lvupExp
		level = level + 1
		exp = total - lvupExp
		if lv + level > Player.Info.level then 
			return exp
		end 
		lvupExp = GetPetTotalExp(lv + level, self.pet.star)
	end
	return exp
end 

function m:getLvup(addExp)
	local curExp = self.pet.info.exp
	local total = curExp  + addExp
	local lv = self.pet.lv
	if Player.Info.level <= self.pet.lv then 
		return 0
	end
	local lvupExp = self.pet:GetPetTotalExp(lv, self.pet.star)
	--self.slider_shine.value = total/lvupExp
	local level = 0
	if lvupExp == nil then return level end
	while(total >= lvupExp ) do 
		level = level + 1
		if lv + level > Player.Info.level then 
			return level
		end 
		lvupExp = self.pet:GetPetTotalExp(lv + level, self.pet.star)
	end 
	return level
end 

function m:updateLevelInfo()
    local pet = self.pet
	
	local tb = self.rate --TableReader:TableRowByID("petArgs", "petLevelUp_consumeRate")
	local sn = Tool.getResIcon(tb.value)
	self.money_icon:setImage(sn, "ItemImage")
	local cost = 0 
	if tb.value == "money" then 
		cost = self.total * tonumber(tb.value2) 
	elseif tb.value == "item" then 
		cost = self.total * tonumber(tb.other) 
	end 
	if cost > Player.Resource.money then 
		self.txt_cost_money.text = "[ff0000]" .. toolFun.moneyNumberShowOne(math.floor(tonumber(cost))) .. "[-]"
	else 
		self.txt_cost_money.text = toolFun.moneyNumberShowOne(math.floor(tonumber(cost)))
	end 
    
end

function m:onUpdate(pet, ret)
    self.pet = pet
	if self.pet == nil then return end 
	local list = Tool.getPetStarList(self.pet.star_level)
	self.stars:refresh("", list, self)
	self.slider_shine.gameObject:SetActive(false)
	local isOneKey = m:isOneKey()
    if pet.star < 4 then
        m:setImage(false)
    else
        m:setImage(open)
    end

    self.binding:CallManyFrame(function()
        m:updateDesc()
    end)
    --self.txt_soulOneKey.text = 0
    self.binding:CallManyFrame(function()
        m:updateLevelInfo()
    end)
    if self.max_pet_lv <= pet.lv then
        --self.btnOneKeyLvUp.isEnabled = false
        self.btn_levelUp.isEnabled = false
    else
        --self.btnOneKeyLvUp.isEnabled = true
        self.btn_levelUp.isEnabled = true
    end
    local isOneKeyJ = TableReader:TableRowByID("petArgs", "yjsj_limit")
    if isOneKeyJ ~= nil then
    	if Player.Info.level >= isOneKeyJ.value or Player.Info.vip >= isOneKeyJ.value2 then
    		if self.meterials and #self.meterials > 0 then 
				self.btn_one_key_lUp.gameObject:SetActive(false)
				self.btn_levelUp.gameObject:SetActive(true)
			else 
				--self.btn_one_key_lUp.gameObject:SetActive(isOneKey)
				self.btn_one_key_lUp.gameObject:SetActive(true)
				self.btn_levelUp.gameObject:SetActive(not isOneKey)
			end
    	else
			self.btn_one_key_lUp.gameObject:SetActive(false)
			self.btn_levelUp.gameObject:SetActive(true)
	    end
    end
	self:updateMeterials()
end

function m:isOneKey()
	local isOneKey = false
	if self.rate == nil then 
		self.rate = TableReader:TableRowByID("petArgs", "petLevelUp_consumeRate")
	end
	local tb = self.rate
	local need = m:levelUpExp()
	local list = getServerPackDataBySubType("item", "petItem", Player.ItemBag)
	local exp = 0
	local isOneKey = false
	local isCost = false
	
	for i = 1, #list do
        local item = list[i]
			for j = 1, item.itemCount do
			exp = exp + item.itemTable.exp
			if exp >= need then 
				isOneKey = true 
				break
			end 
		end
		if isOneKey == true then 
			break
		end 
    end 
	local cost = 0 
	-- 算cost的时候， 得用整个的口粮EXP
	if tb.value == "money" then 
		cost = exp * tonumber(tb.value2) 
		if Player.Resource.money >= cost then 
			isCost = true
		end 
	elseif tb.value == "item" then 
		cost = exp * tonumber(tb.other) 
	end 
	print("isCost = " .. tostring(isCost))
	return isCost and isOneKey
end 

function m:levelUpExp()
	local lvexp = self.pet:GetPetExp(self.pet.lv, self.pet.star)
	local cur = m:getCurrentExp(self.pet.info.exp)
	local exp = (lvexp - cur)
	if exp < 0 then exp = 0 end 
	return exp
end 

function m:dropNumber(list, newList, power)
    local descIndex = {}
    local numList = {}
    for i = 0, list.Count - 1 do
        if list[i] ~= newList[i] then
            table.insert(descIndex, i)
            numList[i] = newList[i] - list[i]
        end
    end
    if power and power > 0 then
        table.insert(descIndex, TextMap.GetValue("Text_1_822") .. power)
    end
    local txtList = self.pet:getAttrList(descIndex, numList, "+")
    m:showOperateAlert(txtList)
end

function m:updateTab()
    m:onUpdate(self.pet)
end

function m:playEffect()
    self.effect:SetActive(false)
    
	self.juese_zishenshengji:SetActive(false)
	self.juese_zishenshengji:SetActive(true)
	
    self.effect:SetActive(true)
end

-- 是否存在上阵列表中
function m:isExitTeam(id)
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

function m:onLvUp(go)
    local that = self
    local list = self.pet.info.propertys
	if self.meterials == nil or #self.meterials < 1 then 
		MessageMrg.show(TextMap.GetValue("Text_1_963"))
		return 
	end 
    go.isEnabled = false
	local str = json.encode(self.oneKeyData)
    Api:petLevelUp(self.pet.id, str, self.total, function(result)
        Events.Brocast('showEffect')
        that:playEffect()
		that.binding:CallAfterTime(1.7, function()
			self.right:SetActive(false)
			that.pet:updateInfo()
			m:resetLvup()
			that:onUpdate(that.pet)
			self.delegate:updateRedPoint()
			local newList = that.pet.info.propertys
			MusicManager.playByID(28)
			--m:dropNumber(list, newList, that.pet.power - power)
			--that.delegate:updateHeroInfo(that.pet)
			--that.delegate:updateColor()
			go.isEnabled = true
			self.juese_zishenshengji:SetActive(false)
		end) 
		--self.isAdd = false
    end, function(ret)
        go.isEnabled = true
        return false
    end)
end

function m:onOneKeyLvUp(go)
	if self:isOneKey() == false then 
		MessageMrg.show(TextMap.GetValue("Text_1_964"))
		return 	
	end 
	if self.pet.lv >= Player.Info.level then
		MessageMrg.show(TextMap.GetValue("Text_1_965"))
		return 
	end 
    UIMrg:pushWindow("Prefabs/moduleFabs/pet/gui_levelup_dialog", { pet = self.pet, delegate = self } )
end

function m:setImage(ret)
	self.img_hero:LoadByModelId(self.pet.modelid, "idle", function() end, false, 100, 1)
end

function m:onClick(go, name)
    if name == "btn_one_key_lUp" then
        m:onOneKeyLvUp(go)
    elseif name == "btn_levelUp" then
        m:onLvUp(go)
	elseif name == "btnAdd" then 
		m:onAutoAdd()
	end 
	m:onClick_add(go, name)
	m:onClick_close(go, name)
end

function m:onAutoAdd()
	if self.meterials ~= nil and #self.meterials >= self.max_slot then return end 
	local items = {}
	local list = getServerPackDataBySubType("item", "petItem", Player.ItemBag)
	table.sort(list, function(a, b)
		return a.itemTrueColor > b.itemTrueColor
	end)
	--print_t(list)
	for i = 1, #list do
        local item = list[i]
		for j = 1, item.itemCount do 
			if #items >= 10 then break end
			table.insert(items, { itemid = item.itemID, exp = item.itemTable.exp })
		end
    end

    if #items == 0 then
		MessageMrg.show(TextMap.GetValue("Text_1_966"))
		return 
	else 
		self.oneKeyData = {}
		if self.meterials == nil then 
			self.meterials = {}
		end
		for i = 1, self.max_slot do
			if items[i] ~= nil then 
				if self.meterials[i] == nil and items[i] ~= nil then 
					self.meterials[i] = items[i]
					m:insertData(items[i].itemid)
				end
			end 
		end 
	end
	self:updateMeterials()
	self:updateExp()
end

function m:onFilterAutoAdd(pet)
	if pet.id == self.pet.id then return false end
	if pet.id == Player.Info.playercharid then return false end 
	-- 紫色以上不添加
	--if pet.star > 4 then return false end
	-- 觉醒过的
	if pet.stage > 0 then return false end 
	-- 进阶过的
	if pet.star_level > 0 then return false end 
	-- 上阵的不能添加
	if m:isExitTeam(pet.id) then return false end 
	-- 小伙伴
	if m:checkFriend(pet.id) then return false end 
	
	return true
end 

--获取小伙伴队列
function m:checkFriend(charId)
    local teams = Player.Team[12].chars
    local list = {}
    for i = 0, 7 do
        if tonumber(teams[i]) == charId then
            return true
        end
    end
    return false
end

function m:onFilter(pet)
	--条件1
	if pet.id == Player.Info.playercharid then return false end 
	if pet.id == self.pet.id then return false end
	--if pet.star > 5 then return false end
	-- 觉醒过的
	if pet.stage > 0 then return false end 
	-- 进阶过的
	if pet.star_level > 0 then return false end 
	-- 上阵的不能添加
	if m:isExitTeam(pet.id) then return false end 
		-- 小伙伴
	if m:checkFriend(pet.id) then return false end 
	
	return true
end

function m:onClick_close(go, name)
	if self.meterials == nil then return end 
	for i = 1, #self.meterials do 
		if name == "btn_close_" .. i then 
			-- 选择英雄
			table.remove(self.meterials,i) 
			self:updateMeterials()
			self:updateExp()
			break
		end
	end 
end 

function m:onClick_add(go, name)
	for i = 1, self.max_slot do 
		if name == "item" .. i then 
			-- 选择英雄
			local bind = UIMrg:pushWindow("Prefabs/moduleFabs/hero/gui_select_hero")
			bind:CallUpdate({ type = "pet", module = "daili", delegate = self, pet = self.pet, selectList = self.meterials, max = self.max_slot })
			self.clickIndex = i
			break
		end
	end 
end

function m:resetLvup()
	self.meterials = nil 
	self.total = 0
	self:updateMeterials()
	self:updateExp()
end 

function m:updateMeterials()
	if self.meterials ~= nil and #self.meterials > 0 then 
		self.btn_levelUp.gameObject:SetActive(true)
		self.btnAdd.gameObject:SetActive(false)
	else 
		self.btn_levelUp.gameObject:SetActive(false)
		self.btnAdd.gameObject:SetActive(true)
	end 
	for i = 1, self.max_slot do
		if self.meterials ~= nil and self.meterials[i] ~= nil then 
			local data = self.meterials[i]
			local item = itemvo:new("item", 1, data.itemid, 1)
			if self["item_img_"..i] == nil then
				self["item_img_"..i] = ClientTool.loadAndGetLuaBindingFromPool("Prefabs/publicPrefabs/itemAll", self["item"..i].gameObject)
			end
			self["item_img_"..i].gameObject:SetActive(true)
			self["item_img_"..i]:CallUpdate({ "itemvo", item, 110, 110, true })
		else 
			if self["item_img_"..i] ~= nil then
				self["item_img_"..i].gameObject:SetActive(false)
			end
		end 
	end
end 

function m:onCallBackSelect(items, tp)
	print("call back selectCostList")
	self.meterials = {}
	self.oneKeyData = {}
	local index = 0
	for i, v in pairs(items) do
		index = index + 1
		if index > self.max_slot then return end 
		if self.meterials[index] == nil and v ~= nil then 
			self.meterials[index] = v
			m:insertData(v.itemid)
		end 
	end 
	self:updateMeterials()
	self:updateExp()
end 

function m:onCallBack(chars, tp)
	if chars == nil then 
		print("回调出错: " .. tostring(tp))
		return
	end 
	local that = self
	--for i, v in pairs(chars) do
	--	if v.star >= 4 then 
	--		DialogMrg.ShowDialog("你确定要适用紫卡及以上进行升级吗?", function()
	--			that:onCallBackSelect(chars)
	--			UIMrg:popWindow()
	--			return
	--		end)
	--	end 
	--end
	m:onCallBackSelect(chars, tp)
end

function m:insertData(itemId)
	if self.oneKeyData ~= nil then 
		local isInsert = false
		for i = 1, #self.oneKeyData do 
			local item = self.oneKeyData[i]
			if item.id == itemId then 
				item.count = item.count + 1
				isInsert = true
				break
			end 
		end 
		if isInsert == false then 
			table.insert(self.oneKeyData, {id = itemId, count = 1})
		end 
	end 
end 

function m:onSelectLvOk()

end 

function m:onSelectLvCannel()

end 

function m:hideEffect()
end

function m:OnEnable()
    self:onUpdate(self.pet)
end

function m:Start()
	self.max_slot = 5
	--self.isAdd = false
	self.v_lv = 0
	local char = Char:new(Player.Info.playercharid)
	self.max_pet_lv = char.lv
	
	self.total = 0
    self.showEquip = true
	self.right:SetActive(false)
end

function m:onClose()
    UIMrg:pop()
end

return m

