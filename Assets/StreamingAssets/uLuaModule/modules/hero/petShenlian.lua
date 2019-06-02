
-- 神炼
local m = {}


--神炼
function m:onShenLian(itemId, num, exp, level)
	if self.isMax == true then 
		--MessageMrg.show(TextMap.GetValue("Text_1_866"))
		return 
	end 
	local items = { {id = itemId, count = num} }
	local str = json.encode(items)
	local that = self
    Api:shenlianUp(that.pet.id, str, level, function(result)
		--that.refresh = true
		m:playEffect()
        that.pet:updateInfo()
        local list = {}
		local time = 0
		for i = 1, num do 
			local desc = "[00ff00]+"..exp.."[-]"
			--table.insert(list, desc)
			that.binding:CallAfterTime(time, function()
				OperateAlert.getInstance:showMsgToGameObject(desc, self.txtExp.gameObject)
			end)
			time = time + 0.1
		end 
		m:onUpdate()
		
    end, function(ret)

        return false
    end)
    --end)
end

function m:setImage()
    self.img_hero:LoadByModelId(self.pet.modelid, "idle", function() end, false, 100, 1)
end

--添加碎片
function m:onAddPiece(go)
    DialogMrg.showPieceDrop(self.pet)
end

function m:onClick(go, name)
    if name == "btn_starUp" then
        m:onOneKeyLvUp(go)
    elseif name == "btn_addPiece" then
        self:onAddPiece(go)
	elseif name == "btn_property" then 
		local maxShenlian = Tool.GetPetArgs("shenlian_max_lv")
		UIMrg:pushWindow("Prefabs/moduleFabs/pet/pet_shenlian_dialog", {pet = self.pet, cur = self.pet.shenlian, next = maxShenlian})
    end
end

function m:itemDataInit(name, go)
	local itemImage = ""
	if name == "item1" then 
		itemImage = self.itemVo1.itemImage
		go.transform.localPosition = self.item1.transform.localPosition
		self.tempNum1 = self.tempNum1 - 1
		if self.tempNum1 < 0 then self.tempNum1 = 0 end
	elseif name == "item2" then
		itemImage = self.itemVo2.itemImage
		go.transform.localPosition = self.item2.transform.localPosition
		self.tempNum2 = self.tempNum2 - 1
		if self.tempNum2 < 0 then self.tempNum2 = 0 end
	elseif name == "item3" then 
		itemImage = self.itemVo3.itemImage
		go.transform.localPosition = self.item3.transform.localPosition
		self.tempNum3 = self.tempNum3 - 1
		if self.tempNum3 < 0 then self.tempNum3 = 0 end
	end
	return itemImage
end 

local TimerID = 0
local isUped = false
function m:onPress(go, name, ret)
	if ret == true and self[name .. "_onClick"]==true  then 
		isUped = false
		if self.pet.lv < self.lvLimit then 
			MessageMrg.show(TextMap.GetValue("Text_1_864")..self.lvLimit .. TextMap.GetValue("Text_1_865"))
			return 
		end 
		if self.isMax == true then 
			MessageMrg.show(TextMap.GetValue("Text_1_866"))
			return 
		end
	end 
	if self.pet.lv < self.lvLimit then 
		return 
	end 
	if self.isMax == true then 
		return 
	end
		
    if name == "item1" or name == "item2" or name == "item3" then
		local exp = 0 
		local itemId = 0
		local maxNum = 0
		if name == "item1" then
			self["item2_onClick"]=false
			self["item3_onClick"]=false 
			exp = self.it1.Table.exp
			itemId = self.it1.id
			maxNum = self.it1.count
		elseif name == "item2" then 
			self["item1_onClick"]=false
			self["item3_onClick"]=false 
			exp = self.it2.Table.exp
			itemId = self.it2.id
			maxNum = self.it2.count
		elseif name == "item3" then 
			self["item1_onClick"]=false
			self["item2_onClick"]=false 
			exp = self.it3.Table.exp
			itemId = self.it3.id
			maxNum = self.it3.count
		end
		if maxNum <= 0 then LuaTimer.Delete(TimerID) return end 
        if ret then
            LuaTimer.Delete(TimerID)
			self.expNum = 0
            TimerID = LuaTimer.Add(0, 50, function(id)
				self.expNum = self.expNum + 1
				if self.expNum > maxNum then self.expNum = maxNum end
				local go = self:getAnimGoByPool()
				if go ~= nil then
					go:SetActive(true)
					go.transform.localScale = Vector3(1, 1, 1)
					local cs = go:GetComponent(CustomSprite)
					local itemImage = m:itemDataInit(name, go)
					m:updateNum()
					local atlasName = packTool:getIconByName(itemImage)
					cs:setImage(itemImage, atlasName)
					self.binding:MoveToPos(go, 0.3, self.btn_starUp.transform.localPosition, function()
						self:recycleAnim()
					end)
					self.binding:ScaleToGameObject(go, 0.3, Vector3(0.3, 0.3, 1))
					
					if self.expNum >= 6 then
						print("添加经验")
						local isUp = m:isLevelUp(self.expNum * exp)
						local lv = 0
						if isUp == true then 
							lv = 1
						end 
						m:onShenLian(itemId, self.expNum, exp, lv)
						self.expNum = 0
					end
					
					local isUp = m:isLevelUp(self.expNum * exp)
					if isUp then 
						isUped = true
						LuaTimer.Delete(TimerID)
						m:onShenLian(itemId, self.expNum, exp, 1)
					end 
				end 
                return true
            end)
        else
        	self["item1_onClick"]=true
        	self["item2_onClick"]=true
        	self["item3_onClick"]=true
		    LuaTimer.Delete(TimerID)
			if isUped == false then 
				m:onShenLian(itemId, self.expNum, exp, 0)
			end 
			--local total = self.expNum * exp
			--print("停下来: " .. self.expNum)
			--print("exp = " .. exp)
			--print("itemId = " .. itemId)
        end
    end
end

function m:levelUpNeedExp(n)
	local total = self.pet.shenlianExp
	local lv = self.pet.shenlian
	local lvupExp = self.pet:getShenLianExp(self.pet.shenlian + n)
	local exp = lvupExp - total
	return exp
end 

function m:onOneKeyLvUp(go)
	if self.isMax == true then 
		MessageMrg.show(TextMap.GetValue("Text_1_866"))
		return 
	end 
	if self.pet.lv < self.lvLimit then 
		MessageMrg.show(TextMap.GetValue("Text_1_864")..self.lvLimit .. TextMap.GetValue("Text_1_865"))
		return 
	end 
	local needExp = self:levelUpNeedExp(1)
	local allExp = self:getAllExp()
	if allExp < needExp then 
		MessageMrg.show(TextMap.GetValue("Text_1_867"))	
	else 
		UIMrg:pushWindow("Prefabs/moduleFabs/pet/gui_shenlian_dialog", {delegate = self, item1 = self.itemVo1, item2 = self.itemVo2, item3 = self.itemVo3,  pet = self.pet} )
	end
end

function m:isLevelUp(exp)
	local cur = self:getCurrentExp(self.pet.shenlianExp)
	local lvupExp = m:getLevelUpExp()
	if cur + exp >= lvupExp then 
		return true 
	end 
	return false
end

function m:onUpdate()
	local pet = self.pet
	local nextLv = self.pet.shenlian+1

	if self.pet.shenlian >= self.maxShenlian then 
		self.isMax = true
		nextLv = self.pet.shenlian
	end 
    self.txt_name.text = self.pet:getItemColorName(self.pet.star, self.pet.name)
	self.txt_shenlian.text = TextMap.GetValue("Text_1_868")..self.pet.shenlian..TextMap.GetValue("Text_1_869")
	
	self.txt_next_shenlian.text = TextMap.GetValue("Text_1_868")..(nextLv)..TextMap.GetValue("Text_1_869")
	self.txtLv.text = string.gsub(TextMap.GetValue("LocalKey_828"),"{0}",nextLv)
	
	local list = Tool.getPetStarList(self.pet.star_level)
	self.stars:refresh("", list, self)
 
	local row = TableReader:TableRowByUniqueKey("petShenlian", pet.dictid, pet.shenlian)
	row.isGreen=false
	self.left_pos:CallUpdate(row)
	
	local row2 = TableReader:TableRowByUniqueKey("petShenlian", pet.dictid, nextLv)
	row2.isGreen=true
	self.right_pos:CallUpdate(row2)
	self.lvLimit = row2.limitLv
	if self.lvLimit > self.pet.lv then 
		self.txt_need_lv.text = TextMap.GetValue("Text_1_872")..self.lvLimit
	else 
		self.txt_need_lv.text = ""
	end 
	
	if row then
		m:setImage()
	end
	
	if self.__item1 == nil then 
		local tb = TableReader:TableRowByID("petArgs", "shenlian_item1")
		self.it1 = uItem:new(tb.value2)
		self.itemVo1 = self.it1
		self.itemVo1.rwCount=self.it1.count
		self.__item1 = ClientTool.loadAndGetLuaBindingFromPool("Prefabs/publicPrefabs/itemAll", self.item1.gameObject)
	end
	if self.__item2 == nil then 
		local tb = TableReader:TableRowByID("petArgs", "shenlian_item2")
		self.it2 = uItem:new(tb.value2)
		self.itemVo2 = self.it2
		self.itemVo2.rwCount=self.it2.count
		self.__item2 = ClientTool.loadAndGetLuaBindingFromPool("Prefabs/publicPrefabs/itemAll", self.item2.gameObject)
	end
	if self.__item3 == nil then 
		local tb = TableReader:TableRowByID("petArgs", "shenlian_item3")
		self.it3 = uItem:new(tb.value2)
		self.itemVo3 = self.it3
		self.itemVo3.rwCount=self.it3.count
		self.__item3 = ClientTool.loadAndGetLuaBindingFromPool("Prefabs/publicPrefabs/itemAll", self.item3.gameObject)
	end
	self["item1_onClick"]=true
	self["item2_onClick"]=true
	self["item3_onClick"]=true
	self.it1:updateInfo()
	self.it2:updateInfo()
	self.it3:updateInfo()
	self.itemVo1.count = self.it1.count
	self.itemVo2.count = self.it2.count
	self.itemVo3.count = self.it3.count
    self.__item1:CallUpdate({ "char", self.itemVo1, 110, 110, true, nil, true, false })
    self.__item2:CallUpdate({ "char", self.itemVo2, 110, 110, true, nil, true, false })
    self.__item3:CallUpdate({ "char", self.itemVo3, 110, 110, true, nil, true, false })
	self.__item1:CallManyFrame(function()
		self.__item1.target.shuliang.gameObject:SetActive(false)
	end, 2)
	self.__item2:CallManyFrame(function()
		self.__item2.target.shuliang.gameObject:SetActive(false)
	end, 2)
	self.__item3:CallManyFrame(function()
		self.__item3.target.shuliang.gameObject:SetActive(false)
	end, 2)
	self.tempNum1 = self.it1.count
	self.tempNum2 = self.it2.count
	self.tempNum3 = self.it3.count
	m:updateNum()
	self.txt_exp1.text = TextMap.GetValue("Text_1_873") .. self.it1.Table.exp
	self.txt_exp2.text = TextMap.GetValue("Text_1_873") .. self.it2.Table.exp
	self.txt_exp3.text = TextMap.GetValue("Text_1_873") .. self.it3.Table.exp
	
	local curExp = m:getCurrentExp(self.pet.shenlianExp)
	local exp1 = m:getLevelUpExp()
	self.txtExp.text =  TextMap.GetValue("Text_1_857").. curExp .. "/" .. exp1
	if self.isMax == true then 
		self.txtExp.text =  TextMap.GetValue("Text_1_811")
	end 
    self.exp.value = curExp / exp1
		
end

function m:updateNum()
	self.txt_num1.text = self.tempNum1
	self.txt_num2.text = self.tempNum2
	self.txt_num3.text = self.tempNum3
end

function m:getShenLianExp(petDictid, shenlian_lv)
	local row = TableReader:TableRowByUniqueKey("petShenlian", petDictid, shenlian_lv)
	if row then 
		return row.exp, row.limitLv
	else 
		print("dictid = " .. petDictid .. "  shenlian_lv = " .. shenlian_lv)
	end 
	
	return -1, -1
end

function m:getLevelUpExp()
	local nextLv = self.pet.shenlian + 1
	if self.isMax then 
		nextLv = self.pet.shenlian
	end 
	local exp1 = m:getShenLianExp(self.pet.dictid, nextLv)
	local exp2 = nil 
	if self.pet.shenlian > 0 then 
		exp2 = m:getShenLianExp(self.pet.dictid, self.pet.shenlian)
	end
	return exp1 - (exp2 or 0)
end 

function m:getCurrentExp(totalExp)
	if totalExp <= 0 then return 0 end 
	local total = totalExp --self.pet.info.exp
	local lv = self.pet.shenlian
	local lvupExp = 0 --m:getShenLianExp(self.pet.dictid, lv)
	local level = -1
	local exp, lvLimit = total - m:getShenLianExp(self.pet.dictid, lv-1)
	while total >= lvupExp and lvupExp ~= -1 do 
		level = level + 1
		exp = total - lvupExp
		lvupExp, lvLimit = m:getShenLianExp(self.pet.dictid, lv+level)
		if lvupExp == -1 then 
			break
		end 
		if self.pet.lv < lvLimit then 
			return exp
		end 
		if lv + level >= self.maxShenlian  then 
			if level <= 1 then level = 1 end 
			return (level) 
		end 
	end 
	return exp
end


function m:hideEffect()
end

function m:OnEnable()
    self:onUpdate()
end

function m:update(lua)
    self.delegate = lua.delegate
    self.pet = lua.pet
	self.refresh = true
    self:onUpdate()
end

function m:recycleAnim()
	if #self.unMakeList > 0 then 
		local go = table.remove(self.unMakeList, 1)
		go:SetActive(false)
		table.insert(self.moveList, go)
		return go
	end 
	return nil
end

function m:getAllExp()
	local list = getServerPackDataBySubType("item", "petShenlian", Player.ItemBag)
	local exp = 0
	
	for i = 1, #list do
        local item = list[i]
		exp = exp + item.itemTable.exp * item.itemCount	
    end 
	
	return exp
end 

function m:getAnimGoByPool()
	if #self.moveList > 0 then 
		local go = table.remove(self.moveList, 1)
		table.insert(self.unMakeList, go)
		return go
	end 
	return nil
end 

function m:OnDestroy()
	LuaTimer.Delete(TimerID)
	self.moveList = nil 
end

function m:playEffect()
    self.effect:SetActive(false)
    
	self.juese_zishenshengji:SetActive(false)
	self.juese_zishenshengji:SetActive(true)
	--self.binding:CallAfterTime(1, function()
	--	self.juese_zishenshengji:SetActive(false)
	--end)
    self.effect:SetActive(true)
end

function m:Start()
	self.moveList = {}
	self.unMakeList = {}
	for i = 1, 5 do 
		local go = ClientTool.AddChild(self.move.gameObject, self.move_p)
		table.insert(self.moveList, go)
	end
	self.maxShenlian = Tool.GetPetArgs("shenlian_max_lv")
	self.maxLv = self.maxShenlian
	print("max: " .. self.maxShenlian)
end

return m