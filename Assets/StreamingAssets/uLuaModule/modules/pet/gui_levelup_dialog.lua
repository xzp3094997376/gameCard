local m = {}

function m:update(lua)
    self._callBack = lua.callback
	self.delegate = lua.delegate
	self.pet = lua.pet

	local tb ={}
	if self.pet:getType()=="pet" then 
		tb = TableReader:TableRowByID("petArgs", "petLevelUp_consumeRate")
		self.rate = 1
		if tb.value == "money" then 
			self.rate = tonumber(tb.value2) 
		end 
	elseif self.pet:getType()=="char" then 
		tb = TableReader:TableRowByID("charArgs", "charLevelUp_consumeRate")
		self.rate = 1
		if tb.value == "money" then 
			self.rate = tonumber(tb.value2) 
		end
	elseif self.pet:getType()=="treasure" then 
		tb = TableReader:TableRowByID("treasureArgs","treasure_levelUp_consume")
		self.rate = 1
		if tb.arg == "money" then 
			self.rate = tonumber(tb.arg2) 
		end
		self.Toggle1.value=false
		self.Toggle2.value=false
	end
	m:refreash()
end

function m:getVrCurrentExp(addExp)
	local total = self.pet.info.exp + addExp
	local lv = self.pet.lv
	local lvupExp = 0
	if self.pet:getType()=="pet" then 
		lvupExp = self.pet:GetPetTotalExp(lv, self.pet.star)
	elseif self.pet:getType()=="char" then 
		lvupExp = GetCharTotalExp(lv, self.pet.quality)
	end
	local level = 0
	local exp = total - lvupExp
	while total >= lvupExp and lvupExp ~= -1 do 
		level = level + 1
		exp = total - lvupExp
		if lv + level >= Player.Info.level then 
			return level
		end 
		if self.pet:getType()=="pet" then 
			lvupExp = self.pet:GetPetTotalExp(lv + level, self.pet.star)
		elseif self.pet:getType()=="char" then  
			lvupExp = GetCharTotalExp(lv + level, self.pet.quality)
		end
	end
	return level
end 

function m:levelUpNeedExp(n)
	local total = self.pet.info.exp
	local lv = self.pet.lv
	local lvupExp = 0
	if self.pet:getType()=="pet" then 
		lvupExp = self.pet:GetPetTotalExp(self.pet.lv + n - 1, self.pet.star)
	elseif self.pet:getType()=="char" then
		lvupExp = GetCharTotalExp(self.pet.lv + n - 1, self.pet.quality)
	elseif self.pet:getType()=="treasure" then
		lvupExp = self.pet:GetTotalExp(self.pet.lv + n - 1, self.pet.star)
	end
	local exp = lvupExp - total
	return exp
end 

function m:getAllExp()
	local list = getServerPackDataBySubType("item", "petItem", Player.ItemBag)
	local exp = 0
	
	for i = 1, #list do
        local item = list[i]
		for j = 1, item.itemCount do 
			local temp = exp + item.itemTable.exp
			-- 金币限制
			if temp * self.rate > Player.Resource.money then 
				return exp
			else 
				exp = temp
			end 
		end 
    end 
	return exp
end 

function m:refreash()
    self.yongyouNum.text = TextMap.GetValue("Text_1_945") .. self.pet.lv
    self.itemName.text = self.pet:getDisplayName()
	if self._data == nil then 
		self._data = ClientTool.loadAndGetLuaBindingFromPool("Prefabs/publicPrefabs/itemAll", self.rongqi.gameObject)
    end 
	self._data:CallUpdate({ "char", self.pet, self.rongqi.width, self.rongqi.height })
	if self.maxExp == nil then 
		if self.pet:getType()=="pet" then 
			self.maxExp = m:getAllExp()
		elseif self.pet:getType()=="char" then  
			self.maxExp = self.delegate.oneKeyExp
		elseif self.pet:getType()=="treasure" then  
			self:getAllOneKeyTreasure(0)
			self.maxExp = self.oneKeyExp
		end 
	end 
	if self.maxLv == nil then 
		if self.pet:getType()=="char" or self.pet:getType()=="pet" then  
			if Player.Info.level <= self.pet.lv then 
				self.maxLv = 0
			else 
				self.maxLv = m:getVrCurrentExp(self.maxExp)
				self.maxLv = math.min(self.maxLv,Player.Info.level-self.pet.lv)
			end 
		elseif self.pet:getType()=="treasure" then 
			self.MaxLV = TableReader:TableRowByID("treasureArgs","treasure_max_lv").arg 
			self.maxLv=self:Summour(self.maxExp+self.pet.exp,0).up_lv
		end 
		if self.maxLv == 0 then 
			self.num = 0
		end 
	end
	m:updateLvContent()
end

function m:Summour(all_exp,count)
	local value = {}
	local expConfig = nil
	if self.MaxLV >= self.pet.lv+count+1 then
		expConfig = TableReader:TableRowByUnique("treasureLevelUp","level",(self.pet.lv+count+1))["t"..self.pet.star]
	end
	 
	if expConfig == nil then
		value.up_lv = count
		value.last_exp = 0
	else
		if all_exp >= expConfig then
			value = self:Summour(all_exp - expConfig,count+1)
		else
			value.up_lv = count
			value.last_exp = all_exp	
		end
	end
	return value
end

function m:getAllOneKeyTreasure(_type)
	local treasures = Player.Treasure:getLuaTable()
	local canCost = {}
    local canCost_allExp=0
    for k,v in pairs(treasures) do
        if not v.onPosition  then
        	if v.power <= 0 and k~= self.pet.key then
        		local tr = Treasure:new(v.id, k)
        		if _type==0 then --自动选择
        			if tr.Table.can_lvup_yjtj_auto == 1 then 
        				canCost_allExp=canCost_allExp+tr:getTreasureExp()
        				table.insert(canCost,tr)
        			end 
        		elseif _type==1 then --可以选择紫色
        			if tr.Table.can_lvup_yjtj_auto == 1 or tr.star==4 then 
        				canCost_allExp=canCost_allExp+tr:getTreasureExp()
        				table.insert(canCost,tr)
        			end 
        		elseif _type==2 then --可以选择橙色
        			if tr.Table.can_lvup_yjtj_auto == 1 or tr.star==5 then 
        				canCost_allExp=canCost_allExp+tr:getTreasureExp()
        				table.insert(canCost,tr)
        			end 
        		elseif _type==3 then --可以选择紫色和橙色
        			if tr.Table.can_lvup_yjtj_auto == 1 or tr.star==4 or tr.star==5 then 
        				canCost_allExp=canCost_allExp+tr:getTreasureExp()
        				table.insert(canCost,tr)
        			end 
        		end 
        	end
        end
    end
	if #canCost == 0 then
		MessageMrg.show(TextMap.GetValue("Text1756"))
		return
	end
	table.sort(canCost, function(a, b)
		if a:getTreasureExp() ~=b:getTreasureExp() then return a:getTreasureExp()>b:getTreasureExp() end 
        return a.id < b.id
    end)
    self.onekeyTreasure=canCost
    self.oneKeyExp=canCost_allExp
end

function m:setMoneyChange()
    if Tool.getCountByType(currentSelect.sell_type) < self.selectNum.text * true_price then
        self.goldNum.text = "[ff0000]" .. self.selectNum.text * true_price
    else 
        self.goldNum.text = self.selectNum.text * true_price --强制类型转换
    end
end

local canLvup = true
function m:onLvUp()
	if canLvup == false then return end 
	if self.num < 1 then return end 
	local cost = self.totalExp * self.rate
	if Player.Resource.money < cost then 
		MessageMrg.showMove(TextMap.GetValue("Text_1_946"))
		return 
	end 
	local str = json.encode(self.oneKeyData)
	Api:petLevelUp(self.pet.id, str, self.totalExp, function(ret)
		canLvup = true
		if ret.ret == 0 then 
			self.delegate:playEffect()
			UIMrg:popWindow()
		end 
	end)
end 

function m:onCharLvUp()
	if canLvup == false then return end 
	local cost = self.totalExp * self.rate
	if Player.Resource.money < cost then 
		MessageMrg.showMove(TextMap.GetValue("Text_1_946"))
		return 
	end 
	self.delegate.meterials=self.oneKeyData
	self.delegate:updateMeterials()
	self.delegate:updateExp()
	self.delegate:onLvUp(self.delegate.btnOneKeyLvUp)
	UIMrg:popWindow()
end 

function m:onClick(go, name)
	if name == "useBtn" then 
		if self.pet:getType()=="pet" then 
			m:onLvUp()
		elseif self.pet:getType()=="char" then  
			self:onCharLvUp()
		elseif self.pet:getType()=="treasure" then  
			self.delegate:OnOneKeyStrength(self.oneKeyData,self.num)
			UIMrg:popWindow()
		end 	
	elseif name == "btn_add1" then 
		m:add1()
	elseif name == "btn_sub1" then 
		m:sub1()
	elseif name == "btn_addmax" then 
		m:add10()
	elseif name == "btn_submax" then
		m:sub10()
	elseif name == "closeBtn" then 
		m:onClose()
	elseif name == "canel" then
		m:onClose()
	elseif name == "btn_toggle1" then
		m:onClickToggle()
	elseif name == "btn_toggle2" then
		m:onClickToggle()
	end 
	m:updateLvContent()
end

function m:onClickToggle()
	if self.Toggle1.value==true then 
		if self.Toggle2==true then 
			self:getAllOneKeyTreasure(3)
		else 
			self:getAllOneKeyTreasure(1)
		end 
	else 
		if self.Toggle2==true then 
			self:getAllOneKeyTreasure(2)
		else 
			self:getAllOneKeyTreasure(0)
		end 
	end 
	self.maxExp = self.oneKeyExp
	self.maxLv=self:Summour(self.maxExp+self.pet.exp,0).up_lv
	if self.maxLv==0 then 
		self.num=0
	end 
end

function m:updateLvContent()
	self.selectNum.text = self.num
	local exp = m:levelUpNeedExp(self.num)
	if self.pet:getType()=="pet" then 
	    -- 转化经验为口粮
	    self.totalExp = m:translateExp(exp)
	elseif self.pet:getType()=="char" then  
		self.totalExp = m:translateCharExp(exp)
	elseif self.pet:getType()=="treasure" then  
		self.totalExp = m:translateTreasureExp(exp)
	end 
	self.eNum.text = self.totalExp
	self.gNum.text = self.totalExp * self.rate
	
	-- 修正升级次数
	--local lv = m:getVrCurrentExp(self.totalExp)
	--self.num = lv
	--self.selectNum.text = self.num
end

function m:translateTreasureExp(exp)
	if exp > self.maxExp then return exp end 
	local tempExp = 0
	self.oneKeyData = {}
	local list = self.onekeyTreasure
	local unUseList = {}
	for i = 1, #list do
		local item = list[i]
		if exp>=item:getTreasureExp() then 
			table.insert(self.oneKeyData, item)
			tempExp=tempExp+item:getTreasureExp()
			exp = exp-item:getTreasureExp()
		else 
			table.insert( unUseList, item)
		end
	end
	if exp >0 then 
		for i = #unUseList, 1, -1 do
			local _item = unUseList[i]
			if exp > 0 then 
				table.insert(self.oneKeyData, _item)
				tempExp=tempExp+_item:getTreasureExp()
				exp = exp-_item:getTreasureExp()
			end 
		end 
	end
	return tempExp
end 

function m:translateCharExp(exp)
	if exp > self.maxExp then return exp end 
	local tempExp = 0
	self.oneKeyData = {}
	local list = self.delegate.onekeyChar
	local unUseList = {}
	for i = 1, #list do
		local item = list[i]
		if exp>=item.Table.exp+item.info.exp then 
			table.insert(self.oneKeyData, item.id)
			tempExp=tempExp+item.Table.exp+item.info.exp
			exp = exp-item.Table.exp-item.info.exp
		else 
			table.insert( unUseList, item)
		end
	end
	if exp >0 then 
		for i = #unUseList, 1, -1 do
			local item = list[i]
			if exp > 0 then 
				table.insert(self.oneKeyData, item.id)
				tempExp=tempExp+item.Table.exp+item.info.exp
				exp = exp-item.Table.exp-item.info.exp
			else 
				i=1
			end 
		end 
	end
	return tempExp
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
	local list = getServerPackDataBySubType("item", "petItem", Player.ItemBag)
	list = self:getData(list)
	table.sort(list, function(a, b)
		return a.itemTable.exp < b.itemTable.exp
	end)
	local all = 0
	for i = 1, #list do 
		all = all + list[i].itemTable.exp * list[i].itemCount
	end 
	local function getBetterRet()
		local bret = 0
		for i = 1, #list do
			local item = list[i]
			if item.itemTable.exp >= exp and item.tempCount > 0 then 
				m:insertData(item.itemID)
				bret = item.itemTable.exp + bret
				item.tempCount = item.tempCount - 1
				return bret
			end
		end
		for i = #list, 1, -1 do
			local item = list[i]
			if item.tempCount > 0 then 
				m:insertData(item.itemID)
				bret = item.itemTable.exp + bret
				item.tempCount = item.tempCount - 1
				return bret
			end 
		end
		return -1
    end
	local better = 0
	while tempExp < exp do 
		better = getBetterRet()
		if better == -1 then break end 
		tempExp = tempExp + better
	end 
	ret = tempExp
	return ret
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
end 

return m