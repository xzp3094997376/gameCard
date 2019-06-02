local m = {} 

function m:update(item, index, myTable, delegate)
	if self.__itemAll == nil then
		self.__itemAll = ClientTool.loadAndGetLuaBinding("Prefabs/publicPrefabs/itemAll", self.pic.gameObject)
	end
	self.__itemAll:CallUpdate({ "char", item, self.pic.width, self.pic.height, true, nil})
	if item:getType()=="renling" then 
		if m:getCanNeed(item) then 
			self.tip_bg.gameObject:SetActive(true)
			self.tip_bg.spriteName="jiaobiao_1"
			self.name_tip.text=TextMap.GetValue("Text_1_2991")
		elseif m:getCanNeed_two(item) then 
			self.tip_bg.gameObject:SetActive(true)
			self.tip_bg.spriteName="jiaobiao_3"
			self.name_tip.text=TextMap.GetValue("Text_1_2992")
		else 
			self.tip_bg.gameObject:SetActive(false)
		end 
	end 
end 

-- 急需判断
function m:getCanNeed(item)
	local activeList = Player.renling
	local openLv = TableReader:TableRowByID("renling_config",5).value2
	local maxStar = TableReader:TableRowByID("renling_config",6).value2
	for i=0,item.Table.show.Count-1 do
		local id = item.Table.show[i]
		local row = TableReader:TableRowByID("renling_group",id)
		local group_item = TableReader:TableRowByUnique("renling_tujian","group",tonumber(row.group))
        if Tool.getRenLingLock(group_item) then 
			if activeList[row.group]~=nil or activeList[row.group][id] ==nil or tonumber(activeList[row.group][id].level)<1 then 
				local isShow = m:getCanNeedByRow(item,row)
				if isShow then 
					return true
				end 
			elseif Player.Info.level>=tonumber(openLv) and tonumber(player.renling[row.group][id].level)<tonumber(maxStar) then 
				local isShow = m:getCanNeedByRow(item,row)
				if isShow then 
					return true
				end
			end 
		end 
	end
	return false
end

-- 急需判断
function m:getCanNeedByRow(item,row)
	local bag = Player.renlingBagIndex
	for j=0,row.consume.Count do
		if row.consume[j]~=nil and row.consume[j].consume_type=="renling" then 
			local renlingId =row.consume[j].consume_arg
			if renlingId~=item.id then 
				if bag[renlingId]==nil or bag[renlingId].count<tonumber(row.consume[j].consume_arg2) then 
					return false
				end 
			else
				local num = 0
				if bag[renlingId]~=nil then 
					num=bag[renlingId].count
				end 
				if num +tonumber(item.rwCount[0]) <tonumber(row.consume[j].consume_arg2) then 
					return false
				elseif num >=tonumber(row.consume[j].consume_arg2) then 
					return false
				end 
			end 
		end
	end 
	return true
end

-- 需要判断
function m:getCanNeed_two(item)
	local activeList = Player.renling
	local openLv = TableReader:TableRowByID("renling_config",5).value2
	local maxStar = TableReader:TableRowByID("renling_config",6).value2
	for i=0,item.Table.show.Count-1 do
		local id = item.Table.show[i]
		local row = TableReader:TableRowByID("renling_group",id)
		local group_item = TableReader:TableRowByUnique("renling_tujian","group",tonumber(row.group))
        if Tool.getRenLingLock(group_item) then 
			if activeList[row.group]~=nil or activeList[row.group][id] ==nil or tonumber(activeList[row.group][id].level)<1 then 
				local isShow = m:getCanNeedByRow_two(item,row)
				if isShow then 
					return true
				end 
			elseif Player.Info.level>=tonumber(openLv) and tonumber(player.renling[row.group][id].level)<tonumber(maxStar) then 
				local isShow = m:getCanNeedByRow_two(item,row)
				if isShow then 
					return true
				end
			end 
		end 
	end
	return false
end

function m:getCanNeedByRow_two(item,row)
	local bag = Player.renlingBagIndex
	for j=0,row.consume.Count do
		if row.consume[j]~=nil and row.consume[j].consume_type=="renling" then 
			local renlingId =row.consume[j].consume_arg
			if renlingId==item.id then 
				local num = 0
				if bag[renlingId]~=nil then 
					num=bag[renlingId].count
				end 
				if num < tonumber(row.consume[j].consume_arg2) then 
					return true
				end 
			end 
		end
	end 
	return false
end

return m