local m = {} 
local selectCostList = {}
function m:update(data)
	self.data = data
	local prolist = self.data:GetFurtureBaseProperty(0)
	local txt=""
    for i=1,#prolist do
    	if i==1 then 
    		txt=prolist[i].base
    	else 
    		txt=txt .. "\n" .. prolist[i].base
    	end 
		self["arrow" .. i]:SetActive(false)
	end 
	self.addLabel.text = ""
	self.txt_Property.text=txt
	self.txt_SLv.text = TextMap.GetValue("Text_1_772")..data.lv
	self.img_slider_shine:SetActive(false)
	self.txt_ULv.gameObject:SetActive(false)
	local lvConfig = TableReader:TableRowByUnique("treasureLevelUp","level",(data.lv))
	self.MaxLV = TableReader:TableRowByID("treasureArgs","treasure_max_lv").arg
	self.slider_di.gameObject:SetActive(lvConfig ~= nil)
	self.needexp = 0
	self.allexp = 0
	if lvConfig ~= nil then
		local num = lvConfig["t"..data.star]
		self.slidertxt.text = data.exp.."/".. num
		self.slider_di.value = data.exp/num
		self.lastExp = num - data.exp
		self.CurExpValue = self.slider_di.value
		self.needexp = num - data.exp
	end
	
	print("..........我的exp是........"..data.exp)
	local tempdata = {}
	tempdata.treasure = data
	--self.center_cell:CallUpdate(tempdata)
	self:ShowCenterCell(data)
	self:RestCostCell()

	self.txt_Cost.text = "0"
	local linkData = TableReader:TableRowByID("charArgs", "yjsj_baowu")
    if Player.Info.level>=tonumber(linkData.value) or Player.Info.vip>=tonumber(linkData.value2) then 
    	self.btn_oneKeyStrength.gameObject:SetActive(true)
    	self.btn_oneKeyStrength.transform.localPosition=Vector3(241.6,-267.2,0)
    	self.btn_strength.gameObject:SetActive(false)
    	self.btn_strength.transform.localPosition=Vector3(409.8,-267.2,0)
    	self.btn_oneclickadd.gameObject:SetActive(true)
    	self.btn_oneclickadd.transform.localPosition=Vector3(409.8,-267.2,0)
    	self.Cost.transform.localPosition=Vector3(85.5,-147.9,0)
    else 
    	self.btn_strength.gameObject:SetActive(false)
    	self.btn_strength.transform.localPosition=Vector3(325.7,-267.2,0)
    	self.btn_oneclickadd.gameObject:SetActive(true)
    	self.btn_oneclickadd.transform.localPosition=Vector3(325.7,-267.2,0)
    	self.btn_oneKeyStrength.gameObject:SetActive(false)
    	self.Cost.transform.localPosition=Vector3(1.4,-147.9,0)
    end 
    self:getAllOneKeyTreasure()
end

function m:getAllOneKeyTreasure()
	local unUse = Tool.getUnUseTreasure()
    local canCost = {}
    local canCost_allExp=0
    for k,v in pairs(unUse) do
        if v.value.power <= 0 and v.key~= self.data.key then
			local tr = Treasure:new(v.value.id, v.key)
			if tr.Table.can_lvup_yjtj_auto == 1 then 
				canCost_allExp=canCost_allExp+tr:getTreasureExp()
				table.insert(canCost,v)
			end 
        end
    end
	if #canCost == 0 then
		--MessageMrg.show(TextMap.GetValue("Text1756"))
		 self.oneKeyExp = 0
		return
	end
    self.onekeyTreasure=canCost
    self.oneKeyExp=canCost_allExp
end

function m:onClick(go, name)
	if name == "btn_strength" then 
		self:ClickStrength()
	elseif name == "btn_oneclickadd" then 
		if self.data.lv < self.MaxLV then 
			self:AutoChooseItem()
		else 
			MessageMrg.show(TextMap.GetValue("Text_1_2809"))
		end 
	elseif name == "btn_oneKeyStrength" then 
		if self.oneKeyExp ==nil then return end 
		local lvConfig = TableReader:TableRowByUnique("treasureLevelUp","level",(self.data.lv+1))
		if lvConfig ==nil then return end 
		local num = lvConfig["t"..self.data.star]
		if self.MaxLV<=self.data.lv then
			MessageMrg.show(TextMap.GetValue("Text_1_2809"))
		elseif self.oneKeyExp>=num-self.data.exp then 
			UIMrg:pushWindow("Prefabs/moduleFabs/TreasureModule/treasure_levelup_dialog", { pet = self.data, delegate = self } )
		else 
			MessageMrg.show(TextMap.GetValue("Text_1_860"))
		end 
	end 
end 

function m:ShowCenterCell(tempdata)
    local name = tempdata:getHeadSpriteName()
    local atlasName = packTool:getIconByName(name)
    self.img_frame:setImage(name, atlasName)
	
	--if self.__itemShow == nil then
    --    self.__itemShow = ClientTool.loadAndGetLuaBindingFromPool("Prefabs/publicPrefabs/itemAll", self.img_frame_1.gameObject)
    --end
    --self.__itemShow:CallUpdate({ "treasure", tempdata, self.img_frame_1.width, self.img_frame_1.height, true, nil, })
    --self.__itemShow:CallTargetFunction("setTipsBtn",  false )
    --self.__itemShow.gameObject.transform:GetComponentInChildren('BoxCollider').enabled = false
    --self.__itemShow.gameObject.transform:FindChild("pic"):GetComponent("BoxCollider").enabled = false
    self.txt_name_1.text = tempdata:getDisplayColorName()
end


function m:RestCostCell()
	local costdata = {}
	costdata.treasure = nil
	costdata.delegate = self
	for i=1,5 do
		self["costcell_"..i]:CallUpdate(costdata)
	end
	selectCostList = {}
end

function m:OnOneKeyStrength(_list ,_lv)
	self.uplevels = _lv
	selectCostList = _list
	self.treasureCostList = selectCostList
	for i=1,5 do
		local tempCost = {}
		tempCost.treasure = selectCostList[i]
		tempCost.index = i
		tempCost.delegate = self
		self["costcell_"..i]:CallUpdate(tempCost)
	end
	for i=1,5 do
		self["effect_0"..i]:SetActive(false)
	end
	self:UpdateExpSlider(selectCostList)
	if self.data ~= nil then
		if #selectCostList>0 then
			if  Player.Resource.money >= (self.costmoney or 0) then
				local trekey = tonumber(self.data.key)
				local keyArr = {}
				for k,v in pairs(selectCostList) do
					local v_t = tonumber(v.key)
					table.insert(keyArr,v_t)
				end

				if self.data.lv < self.MaxLV then
					Api:oneKeyLevelUp(trekey,keyArr,_lv,function()
						self:ShowEffect()
						self.Effect:SetActive(false)
						self.Effect:SetActive(true)
						
						self:RestCostCell()
						self:ShowAddPropertyTips()
						self:RefreshView()
					end,function()
						print(TextMap.GetValue("Text1758"))
					end)
				else
					MessageMrg.show(TextMap.GetValue("Text1753"))
				end
			else
				MessageMrg.show(TextMap.GetValue("Text1754"))
			end
		else
			MessageMrg.show(TextMap.GetValue("Text1755"))
		end
	end
end

function m:ClickStrength()
	if self.data ~= nil then
		if #selectCostList>0 then
			if  Player.Resource.money >= (self.costmoney or 0) then
				local trekey = tonumber(self.data.key)
				local keyArr = {}
				for k,v in pairs(selectCostList) do
					local v_t = tonumber(v.key)
					table.insert(keyArr,v_t)
				end

				if self.data.lv < self.MaxLV then
					Api:treasureLevelUp(trekey,keyArr,function()
						self:ShowEffect()
						self.Effect:SetActive(false)
						self.Effect:SetActive(true)
						
						self:RestCostCell()
						self:ShowAddPropertyTips()
						self:RefreshView()
					end,function()
						print(TextMap.GetValue("Text1758"))
					end)
				else
					MessageMrg.show(TextMap.GetValue("Text1753"))
				end
			else
				MessageMrg.show(TextMap.GetValue("Text1754"))
			end
		else
			MessageMrg.show(TextMap.GetValue("Text1755"))
		end
	end
end

function m:SomeShowInFurture(all_exp)
	print("all_exp = " .. all_exp)
	local value = self:Summour(all_exp+self.data.exp,0)
	self.uplevels = value.up_lv
	local curMaxExp = TableReader:TableRowByUnique("treasureLevelUp","level",(self.data.lv+value.up_lv))["t"..self.data.star]
	
	self.slidertxt.text = value.last_exp.."/"..curMaxExp
	--self.slider_di.value = value.last_exp/curMaxExp
	self.txt_ULv.gameObject:SetActive(value.up_lv>0)
	self.txt_ULv.text = "+"..value.up_lv
	
	self.img_slider_shine:SetActive(true)

	if value.up_lv > 0 then
		self.slider_shine.value = 1
	else
		self.slider_shine.value = value.last_exp/curMaxExp
	end
	local prolist = self.data:GetFurtureBaseProperty(value.up_lv)
	if value.up_lv >0 then
		local txt=""
		local add=""
		for i=1,#prolist do
			if i==1 then 
	    		txt=prolist[i].base
	    		add=prolist[i].add
	    	else 
	    		txt=txt .. "\n" .. prolist[i].base
	    		add=add .. "\n" .. prolist[i].add
	    	end 
			self["arrow" .. i]:SetActive(true)
		end
		self.txt_Property.text = txt
		self.addLabel.text = add
	else
		local txt=""
	    for i=1,#prolist do
	    	if i==1 then 
	    		txt=prolist[i].base
	    	else 
	    		txt=txt .. "\n" .. prolist[i].base
	    	end 
			self["arrow" .. i]:SetActive(false)
		end 
		self.addLabel.text = ""
		self.txt_Property.text=txt
	end 	
end

function m:Summour(all_exp,count)
	local value = {}
	local expConfig = nil
	if self.MaxLV >= self.data.lv+count then
		expConfig = TableReader:TableRowByUnique("treasureLevelUp","level",(self.data.lv+count))["t"..self.data.star]
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

function m:AutoChooseItem()
	local _list = Tool.getAutoCostTreasure(self.data)
	if #_list == 0 then
		MessageMrg.show(TextMap.GetValue("Text1756"))
		return
	end
	selectCostList = {} --重置已经选择的消耗材料
	local autoCostList = {}
	if #_list > 5 then
		for i=1,5 do 
			table.insert(autoCostList,_list[i])
		end
	else
		for k,v in pairs(_list) do
			table.insert(autoCostList,v)
		end
	end

	selectCostList = autoCostList
	self.treasureCostList = selectCostList
	table.foreach(autoCostList, function(i, v)
	 			local tempCost = {}
				tempCost.treasure = v
				tempCost.index = i
				tempCost.delegate = self
                self["costcell_"..i]:CallUpdate(tempCost)
            end)

	for i=1,5 do
		self["effect_0"..i]:SetActive(false)
	end

	self:UpdateExpSlider(autoCostList)
end

function m:Start()
	Events.AddListener("updateCostTreasureList", funcs.handler(self, m.updateCostTreasureList))
end

function m:OnDestroy()
	Events.RemoveListener('updateCostTreasureList')
end

function m:OnDisable( ... )
	self.Effect:SetActive(false)
end

function m:updateCostTreasureList(treasureCostList)
	if self.data.lv >= self.MaxLV then 
		MessageMrg.show(TextMap.GetValue("Text_1_2809"))
		return
	end 
	if treasureCostList~= nil then 
		self.treasureCostList = treasureCostList
	end 
	if #treasureCostList > 5 then return end
	selectCostList = treasureCostList

	for i=1,5 do
		local tempCost = {}
		tempCost.delegate = self
		if i<=#treasureCostList then 
			tempCost.treasure = treasureCostList[i]
			tempCost.index = i
		end
		self["costcell_"..i]:CallUpdate(tempCost)
		self["effect_0"..i]:SetActive(false)
	end

	self:UpdateExpSlider(treasureCostList)
end

function m:removeTreasure(index)
	if self.treasureCostList == nil then return end 
	if index < 1 or index > #self.treasureCostList then return end 
	table.remove(self.treasureCostList, index)
	
	self:updateCostTreasureList(self.treasureCostList)
end 

function m:UpdateExpSlider(costlist)
	if #costlist>0 then 
		self.btn_strength.gameObject:SetActive(true)
		self.btn_oneclickadd.gameObject:SetActive(false)
	else 
		self.btn_strength.gameObject:SetActive(false)
		self.btn_oneclickadd.gameObject:SetActive(true)
	end 
	local all_exp = 0
	for k,v in pairs(costlist) do
		all_exp = all_exp + v:getTreasureExp()
	end

	self:SomeShowInFurture(all_exp)
	self.allexp = all_exp
	local t_exp = TableReader:TableRowByID("treasureArgs","treasure_levelUp_consume")
	if t_exp ~= nil then
		self.txt_Cost.text = all_exp*t_exp.arg2
		self.costmoney = all_exp*t_exp.arg2
	end

end

function m:RefreshView()
	local info = Player.Treasure[self.data.key]
	local new_data = Treasure:new(self.data.id,self.data.key)
	self:update(new_data)
end

function m:ShowAddPropertyTips()
	local magic = self.data:getMagic()[1]
	local magic2 = self.data:getMagic()[2]
    local num = magic.arg2
    local num2 = magic2.arg2
    local e = self.uplevels
    local list = {}
    list[1] = TextMap.GetValue("Text_1_2810") .. e
    list[2] = string.gsub(magic.format, "{0}", (num * e / magic.denominator))
    list[3] = string.gsub(magic2.format, "{0}", (num2 * e / magic2.denominator))
    OperateAlert.getInstance:showToGameObject(list, self.eff.gameObject)
end

function m:ShowEffect()
	if #selectCostList > 0 then
		for i=1,#selectCostList do
			if i <= 5 then
				self["effect_0"..i]:SetActive(false)
				self["effect_0"..i]:SetActive(true)
			end
		end
	end
end

function m:WSelectExpCallBack()
	UIMrg:pushWindow("Prefabs/moduleFabs/TreasureModule/treasure_select_charpiece", 
   	{ kind = self.kind,
   	  type = "treasure" ,
      subtype = "treasure_cost",
      needexp = self.needexp,
      allexp = self.allexp,
      myTre = self.data,
      hasSelect = selectCostList
    })
end

return m