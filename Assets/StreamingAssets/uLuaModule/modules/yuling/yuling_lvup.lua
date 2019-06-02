
-- 升级
local m = {}


--升级
function m:onlevelUp(itemId, num, exp, level)
	if self.isMax == true then 
		--MessageMrg.show(TextMap.GetValue("Text_1_866"))
		return 
	end 
	local items = { {id = itemId, count = num} }
	local str = json.encode(items)
	local that = self
    Api:yulingLevelUp(that.pet.id, str, level, function(result)
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
		self.delegate:updateRedPoint()
		m:onUpdate()
		
    end, function(ret)

        return false
    end)
    --end)
end


--添加碎片
function m:onAddPiece(go)
    DialogMrg.showPieceDrop(self.pet)
end

function m:onClick(go, name)
    if name == "btn_starUp" then
        m:onOneKeyLvUp(go)
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
	if ret == true and self[name .. "_onClick"]==true then 
		isUped = false
		if self.pet.lv >= Player.Info.level then 
			MessageMrg.show(TextMap.GetValue("Text_1_864")..(Player.Info.level+1) .. TextMap.GetValue("Text_1_865"))
			return 
		end 
		if self.isMax == true then 
			MessageMrg.show(TextMap.GetValue("Text_1_866"))
			return 
		end
	end 
	if self.pet.lv >= Player.Info.level then 
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
					self.binding:MoveToPos(go, 0.3, self.img_hero.transform.localPosition, function()
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
						m:onlevelUp(itemId, self.expNum, exp, lv)
						self.expNum = 0
					end
					
					local isUp = m:isLevelUp(self.expNum * exp)
					if isUp then 
						isUped = true
						LuaTimer.Delete(TimerID)
						m:onlevelUp(itemId, self.expNum, exp, 1)
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
				m:onlevelUp(itemId, self.expNum, exp, 0)
			end 
        end
    end
end

function m:levelUpNeedExp(n)
	local total = self.pet.exp
	local lv = self.pet.lv
	local lvupExp = self.pet:getLevelUpExp(self.pet.lv + n)
	local exp = lvupExp - total
	return exp
end 

function m:onOneKeyLvUp(go)
	if self.isMax == true then 
		MessageMrg.show(TextMap.GetValue("Text_1_3018"))
		return 
	end 
	if self.pet.lv >= Player.Info.level then 
		MessageMrg.show(TextMap.GetValue("Text_1_864")..(self.pet.lv+1) .. TextMap.GetValue("Text_1_865"))
		return 
	end 
	local needExp = self:levelUpNeedExp(1)
	local allExp = self:getAllExp()
	if allExp < needExp then 
		MessageMrg.show(TextMap.GetValue("Text_1_3021"))	
	else 
		UIMrg:pushWindow("Prefabs/moduleFabs/pet/gui_shenlian_dialog", {delegate = self, item1 = self.itemVo1, item2 = self.itemVo2, item3 = self.itemVo3,  pet = self.pet} )
	end
end

function m:isLevelUp(exp)
	local cur = self:getCurrentExp(self.pet.exp)
	local lvupExp = m:getLevelUpExp()
	if cur + exp >= lvupExp then 
		return true 
	end 
	return false
end

function m:onUpdate()
	local pet = self.pet
	local nextLv = self.pet.lv+1

	if self.pet.lv >= self.maxLv then 
		self.isMax = true
		nextLv = self.pet.lv
	end 
	local iconName = TableReader:TableRowByUnique("resourceDefine", "name","haogandu").img
	self.img.Url=UrlManager.GetImagesPath("itemImage/"..iconName..".png")
	self.lv.text =self.pet.lv
	if Player.Info.level <= self.pet.lv then 
		self.txt_need_lv.text = TextMap.GetValue("Text_1_872")..Player.Info.level
	else 
		self.txt_need_lv.text = ""
	end 
	local xihaoid = self.pet.Table.xihaoid
	for i=0,xihaoid.Count-1 do
		self["item".. (i+1) .."_onClick"]=true
     
		self["it" .. (i+1)] = RewardMrg.getDropItem({type="item",arg=xihaoid[i]})
		self["itemVo" .. (i+1)] = RewardMrg.getDropItem({type="item", arg2=self["it" .. (i+1)].count, arg=self["it" .. (i+1)].id})
		self["__item" .. (i+1)] = ClientTool.loadAndGetLuaBindingFromPool("Prefabs/publicPrefabs/itemAll", self["item" .. (i+1)].gameObject)
		self["it" .. (i+1)]:updateInfo()
		self["itemVo" .. (i+1)].count = self["it" .. (i+1)].count
		self["__item" .. (i+1)]:CallUpdate({ "char", self["itemVo" .. (i+1)], 110, 110, true, nil, true, false,false})
		self["__item" .. (i+1)]:CallManyFrame(function()
			self["__item" .. (i+1)].target.shuliang.gameObject:SetActive(false)
		end, 2)
		self["tempNum" .. (i+1)] = self["it" .. (i+1)].count
		self["txt_exp" .. (i+1)].text = TextMap.GetValue("Text_1_873") .. self["it" .. (i+1)].Table.exp
	end
	m:updateNum()
	m:updateDesc()
	local curExp = m:getCurrentExp(self.pet.exp)
	local exp1 = m:getLevelUpExp()
	self.txtExp.text =  TextMap.GetValue("Text_1_857").. curExp .. "/" .. exp1
	if self.isMax == true then 
		self.txtExp.text =  TextMap.GetValue("Text_1_811")
	end 
    self.exp.value = curExp / exp1
		
end

function m:updateDesc()
    local list =self.pet:getAttrDesc(false)
    for i=1,4 do
    	self["txt_attr"..i].text=list[i]
    end
    self.cur_lv.text=TextMap.GetValue("Text_1_165")  .. self.pet.lv
    self.next_lv.text=TextMap.GetValue("Text_1_165") .. (self.pet.lv+1)
    Api:getyulingProperty(self.pet.id, 1 , 0, function(result)
		local pro = {}
		pro[2] = self.pet:GetAttrNew("PhyAtk", result.propertys,true)
		pro[3] = self.pet:GetAttrNew("PhyDef", result.propertys,true)
		pro[1] = self.pet:GetAttrNew("MaxHp", result.propertys,true)
		pro[4] = self.pet:GetAttrNew("MagDef", result.propertys,true)
		for i=1,4 do
	    	self["next_attr"..i].text=pro[i]
	    end	
	end)
	-- local list =self.pet:getAttrDesc(true)
 --    for i=1,4 do
 --    	self["next_attr"..i].text=list[i]
 --    end	
end

function m:updateNum()
	self.txt_num1.text = self.tempNum1
	self.txt_num2.text = self.tempNum2
	self.txt_num3.text = self.tempNum3
end

function m:getLvupExp(lv,star)
	local row =  TableReader:TableRowByUnique("yulingExp","lv",lv)
	if row then 
		return row["exp_" .. star]
	end 
	return -1
end

function m:getLevelUpExp()
	local nextLv = self.pet.lv + 1
	if self.isMax then 
		nextLv = self.pet.lv
	end 
	local exp1 = m:getLvupExp(nextLv,self.pet.star)
	local exp2 = nil 
	if self.pet.lv > 0 then 
		exp2 = m:getLvupExp(self.pet.lv,self.pet.star)
	end
	return exp1 - (exp2 or 0)
end 

function m:getCurrentExp(totalExp)
	if totalExp <= 0 then return 0 end 
	local total = totalExp 
	local lv = self.pet.lv
	local lvupExp = m:getLvupExp(lv,self.pet.star)
	local level = 0
	local exp = total - m:getLvupExp(lv,self.pet.star)
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
	local list = getServerPackDataBySubType("item", "yulingItem", Player.ItemBag)
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
	self.maxLv =TableReader:TableRowByID("yulingArgs","max_lv")
	self.maxLv=tonumber(self.maxLv.value)
	local row = TableReader:TableRowByID("yulingArgs","yjsj_limit")
	if Player.Info.level>=tonumber(row.value) or Player.Info.vip>=tonumber(row.value2) then 
		self.btn_starUp.gameObject:SetActive(true)
	else 
		self.btn_starUp.gameObject:SetActive(false)
	end 
end

return m