local m = {}

function m:update(lua)
    self._callBack = lua.callback
	self.itemvo1 = lua.item1
	self.itemvo2 = lua.item2
	self.itemvo3 = lua.item3
	self.pet = lua.pet
	self.delegate = lua.delegate
	
	m:refreash()
end

function m:getVrCurrentExp_yuling(addExp)
	local total = self.pet.exp + addExp
	local lv = self.pet.lv
	local lvupExp = self.pet:getLevelUpExp(self.pet.lv)
	local level = 0
	local exp = total - lvupExp
	if self.pet.lv>= Player.Info.level then 
		return 0
	end
	while total >= lvupExp do 
		level = level + 1
		exp = total - lvupExp
		lvupExp = self.pet:getLevelUpExp(lv + level)
		if lv + level >= Player.Info.level then 
			if level <= 1 then level = 1 end 
			return (level - 1) 
		end 
		if lv + level >= self.max_lv  then 
			if level <= 1 then level = 1 end 
			return (level) 
		end 
	end
	if level <= 1 then level = 1 end 
	return (level - 1)
end 

function m:getVrCurrentExp(addExp)
	local total = self.pet.shenlianExp + addExp
	local lv = self.pet.shenlian
	local lvupExp, limitLv = self.pet:getShenLianExp(self.pet.shenlian)
	local level = 0
	local exp = total - lvupExp
	while total >= lvupExp do 
		level = level + 1
		exp = total - lvupExp
		lvupExp, limitLv = self.pet:getShenLianExp(lv + level, self.pet.star)
		if self.pet.lv < limitLv then 
			if level <= 1 then level = 1 end 
			return (level - 1) 
		end 
		if lv + level >= self.maxShenlian  then 
			if level <= 1 then level = 1 end 
			return (level) 
		end 
	end
	if level <= 1 then level = 1 end 
	return (level - 1)
end 

function m:levelUpNeedExp(n)
	if self.pet:getType()=="yuling" then 
		local total = self.pet.exp
		local lv = self.pet.lv
		local lvupExp = self.pet:getLevelUpExp(self.pet.lv + n)
		local exp = lvupExp - total
		return exp
	else 
		local total = self.pet.shenlianExp
		local lv = self.pet.shenlian
		local lvupExp = self.pet:getShenLianExp(self.pet.shenlian + n, self.pet.star)
		local exp = lvupExp - total
		return exp
	end 
end 

function m:getAllExp()
	local list ={}
	if self.pet:getType()== "yuling" then 
		list=getServerPackDataBySubType("item", "yulingItem", Player.ItemBag)
		local xihaoid = self.pet.Table.xihaoid
		local _list = {}
		for k,v in pairs(list) do
			for i=0,xihaoid.Count-1 do
				if tonumber(v.itemID) == tonumber(xihaoid[i]) then 
					table.insert(_list,v)
				end 
			end
		end
		list=_list
	else 
		list=getServerPackDataBySubType("item", "petShenlian", Player.ItemBag)
	end 
	local exp = 0
	
	for i = 1, #list do
        local item = list[i]
		exp = exp + item.itemTable.exp * item.itemCount	
    end 
	--print("allExp = " .. exp)
	return exp
end 

function m:setItemImage(sprite, image)
	local atlasName = packTool:getIconByName(image)
	sprite:setImage(image, atlasName)
end 

function m:updateNum()
	self.txt_num1.text = self.tempNum1 .. "/" .. self.tempMax1
	self.txt_num2.text = self.tempNum2 .. "/" .. self.tempMax2
	self.txt_num3.text = self.tempNum3 .. "/" .. self.tempMax3
end 

function m:refreash()
	m:setItemImage(self.item1, self.itemvo1.Table.iconid)
	m:setItemImage(self.item2, self.itemvo2.Table.iconid)
	m:setItemImage(self.item3, self.itemvo3.Table.iconid)
	self.tempMax1 = self.itemvo1.rwCount
	self.tempMax2 = self.itemvo2.rwCount
	self.tempMax3 = self.itemvo3.rwCount
	
	self.tempNum1 = 0
	self.tempNum2 = 0
	self.tempNum3 = 0
	m:updateNum()
	if self.pet:getType() == "yuling" then
		self.yongyouNum.text = TextMap.GetValue("Text_1_945") .. self.pet.lv
	else 
		self.yongyouNum.text = TextMap.GetValue("Text_1_947") .. self.pet.shenlian
	end 
    self.itemName.text = self.pet:getDisplayName()
	if self._data == nil then 
		self._data = ClientTool.loadAndGetLuaBindingFromPool("Prefabs/publicPrefabs/itemAll", self.rongqi.gameObject)
    end 
	self._data:CallUpdate({ "char", self.pet, self.rongqi.width, self.rongqi.height })
	if self.maxExp == nil then 
		self.maxExp = m:getAllExp()
	end 
	if self.maxLv == nil then 
		if self.pet:getType()== "yuling" then 
			self.max_lv =TableReader:TableRowByID("yulingArgs","max_lv")
			self.max_lv=tonumber(self.max_lv.value)
			self.maxLv = m:getVrCurrentExp_yuling(self.maxExp)
			print("VR: " .. self.maxLv)
			if self.maxLv > self.max_lv then 
				self.maxLv = self.max_lv
			end
			local lvlimit = Player.Info.level
			if self.maxLv > lvlimit then 
				self.maxLv = lvlimit
			end
		else 
			self.maxLv = m:getVrCurrentExp(self.maxExp)
			print("VR: " .. self.maxLv)
			if self.maxLv > self.maxShenlian then 
				self.maxLv = self.maxShenlian
			end
			local lvlimit = m:getMaxShenlianByLv()
			if self.maxLv > lvlimit then 
				self.maxLv = lvlimit
			end
		end 
	end
	if self.maxLv < 1 then 
		self.num = 0
	end 
	m:updateLvContent()
end

function m:getMaxShenlianByLv()
	for i = self.pet.shenlian, self.maxShenlian do 
		local tb = TableReader:TableRowByUniqueKey("petShenlian", self.pet.dictid, i)
		if self.pet.lv < tb.limitLv then 
			return i - 1
		end 
	end 
	return self.maxShenlian
end

local canLvup = true
function m:onLvUp()
	if canLvup == false then return end 
	if self.num < 1 then return end 
	
	local str = json.encode(self.oneKeyData)
	if self.pet:getType()=="yuling" then 
		Api:yulingLevelUp(self.pet.id, str, self.num, function(ret)
			canLvup = true
			if ret.ret == 0 then 
				self.delegate:playEffect()
				UIMrg:popWindow()
			end 
		end)
	else  
		Api:shenlianUp(self.pet.id, str, self.num, function(ret)
			canLvup = true
			if ret.ret == 0 then 
				self.delegate:playEffect()
				UIMrg:popWindow()
			end 
		end)
	end 
end 

function m:onClick(go, name)
	if name == "useBtn" then 
		m:onLvUp()
	elseif name == "btn_add1" then 
		m:add1()
		m:updateLvContent()
	elseif name == "btn_sub1" then 
		m:sub1()
		m:updateLvContent()
	elseif name == "btn_addmax" then 
		m:add10()
		m:updateLvContent()
	elseif name == "btn_submax" then
		m:sub10()
		m:updateLvContent()
	elseif name == "closeBtn" then 
		m:onClose()
	elseif name == "canel" then
		m:onClose()
	end 
end

function m:updateLvContent()
	if self.maxLv < 1 then 
		self.num = 0
		self.selectNum.text = self.num
		return 
	end 
	if self.pet:getType()=="yuling" then 
		if self.pet.lv + self.num > self.max_lv then 
			MessageMrg.show(TextMap.GetValue("Text_1_3018"))
			self.num = self.max_lv - self.pet.level
		end 
	else 
		if self.pet.shenlian + self.num > self.maxShenlian then 
			MessageMrg.show(TextMap.GetValue("Text_1_866"))
			self.num = self.maxShenlian - self.pet.shenlian
		end 
	end 
	self.selectNum.text = self.num
	local exp = m:levelUpNeedExp(self.num)
	--print("升级所需： " .. exp)
	-- 转化经验为口粮
	self.totalExp = m:translateExp(exp)
	--self.eNum.text = self.totalExp
	--self.gNum.text = self.totalExp * self.rate
	if self.oneKeyData == nil then return end 
	self.tempNum1 = 0
	self.tempNum2 = 0
	self.tempNum3 = 0
	for i = 1, #self.oneKeyData do 
		local item = self.oneKeyData[i] 
		if item.id == self.itemvo1.itemID then 
			self.tempNum1 = item.count
		elseif item.id == self.itemvo2.itemID then 
			self.tempNum2 = item.count
		elseif item.id == self.itemvo3.itemID then 
			self.tempNum3 = item.count
		end
	end 
	self:updateNum()
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

function m:translateExp(exp)
	if exp > self.maxExp then return exp end 
	local tempExp = 0
	local ret = 0
	self.oneKeyData = {}
	local list ={}
	if self.pet:getType()=="yuling" then 
		list=getServerPackDataBySubType("item", "yulingItem", Player.ItemBag)
		local xihaoid = self.pet.Table.xihaoid
		local _list = {}
		for k,v in pairs(list) do
			for i=0,xihaoid.Count-1 do
				if tonumber(v.itemID) == tonumber(xihaoid[i]) then 
					table.insert(_list,v)
				end 
			end
		end
		list=_list
	else 
		list=getServerPackDataBySubType("item", "petShenlian", Player.ItemBag)
	end 
	list = self:getData(list)
	table.sort(list, function(a, b)
		return a.itemTable.exp < b.itemTable.exp
	end)

	local bret = 0
	for i = 1, #list do
		local item = list[i]
		for j = 1, item.itemCount do 
			if bret < exp then 
				if item.tempCount > 0 then 
					m:insertData(item.itemID)
					bret = item.itemTable.exp + bret
					item.tempCount = item.tempCount - 1
				end 
			else 
				return bret
			end
		end
	end
		
	return bret
end 

function m:getData(list)
	for i = 1, #list do
		local item = list[i]
		item.tempCount = item.itemCount
	end 
	return list
end 

function m:sub10()
	self.num = self.num - 10
	if self.num < 1 then self.num = 0 end 
end 

function m:sub1()
	self.num = self.num - 1
	if self.num < 1 then self.num = 0 end  
end 

function m:add1()
	self.num = self.num + 1
	if self.num > self.maxLv then self.num = self.maxLv end 
end 

function m:add10()
	self.num = self.num + 10
	if self.num > self.maxLv then self.num = self.maxLv end 
end 

function m:showMoveDlg()
    if self._type == "lwl" then
        MessageMrg.showMove(TextMap.GetValue("Text364"))
    elseif self._type == "leagueCopyQ" then
        MessageMrg.showMove(TextMap.GetValue("Text364"))
    else
        MessageMrg.showMove(TextMap.GetValue("Text365"))
    end
end

function m:onClose()
    if self._callBack ~= nil then
        self:_callBack()
    end
    self._callBack = nil
    UIMrg:popWindow()
end

function m:create()
    return
end

function m:Start()
	self.num = 1
	local tb = TableReader:TableRowByID("petArgs", "petLevelUp_consumeRate")
	self.maxShenlian = Tool.GetPetArgs("shenlian_max_lv")
	self.rate = 1
	if tb.value == "money" then 
		self.rate = tonumber(tb.value2) 
	--elseif tb.value == "item" then 
	--	self.rate = tonumber(tb.other) 
	end 
end 

return m