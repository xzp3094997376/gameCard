local m = {} 

function m:update(item)
	LuaMain:ShowTopMenu(6,nil,{[1]={ type="renlingzhi"},[2]={ type="money"},[3]={ type="gold"}})
	Tool.loadTopTitle(self.gameObject, TextMap.GetValue("Text_1_2968"))
	local name = string.gsub(TextMap.GetValue("LocalKey_666"),"{0}",item[1].group)
	self.name.text=string.gsub(name,"{1}",item[1].name)
	local activeList = {}
	local canActiveList = {}
	local upList = {}
	local canUpList = {}
	local bagStarList = {}
	local activeBug = Player.renling
	local openLv = TableReader:TableRowByID("renling_config",5).value2
	local maxStar = TableReader:TableRowByID("renling_config",6).value2
	TableReader:ForEachLuaTable("renling_group", function(index, _item) --shopPurchase
		if tonumber(_item.group)== tonumber(item[1].group) then
			_item.delegate=self 
			if activeBug[_item.group]~=nil and activeBug[_item.group][_item.id] ~=nil and tonumber(activeBug[_item.group][_item.id].level)>=1 then 
				local star = tonumber(activeBug[_item.group][_item.id].level)
				if Player.Info.level>=tonumber(openLv) and star<tonumber(maxStar) then 
					if m:getCanActive(_item.consume) then
						table.insert(canUpList,_item)
					else 
						table.insert(upList,_item)
					end  
				elseif Player.Info.level<tonumber(openLv) then 
					table.insert(upList,_item)
				elseif star==tonumber(maxStar) then 
					table.insert(bagStarList,_item)
				end 
			else
				if m:getCanActive(_item.consume) then
					table.insert(canActiveList,_item)
				else 
					table.insert(activeList,_item)
				end 
			end 
		end   
		return false
		end)
	table.sort(upList, function (a,b)
		return tonumber(a.id)<tonumber(b.id)
	end )
	table.sort(canUpList, function (a,b)
		return tonumber(a.id)<tonumber(b.id)
	end )
	table.sort(activeList, function (a,b)
		return tonumber(a.id)<tonumber(b.id)
	end )
	table.sort(canActiveList, function (a,b)
		return tonumber(a.id)<tonumber(b.id)
	end )
	table.sort(bagStarList, function (a,b)
		return tonumber(a.id)<tonumber(b.id)
	end )
	local renlingList = {}
	for i=1,#canActiveList do
		table.insert(renlingList,canActiveList[i])
	end
	for i=1,#canUpList do
		table.insert(renlingList,canUpList[i])
	end
	for i=1,#activeList do
		table.insert(renlingList,activeList[i])
	end
	for i=1,#upList do
		table.insert(renlingList,upList[i])
	end
	for i=1,#bagStarList do
		table.insert(renlingList,bagStarList[i])
	end
	--print_t(renlingList)
	renlingList=m:getData(renlingList)
	self.scrollView:refresh(renlingList, self, false,0)
end 

function m:getCanActive(consume)
	local bag = Player.renlingBagIndex
	for i=0,consume.Count do
		if consume[i]~=nil then 
			if consume[i].consume_type == "renling" then
				local temp = bag[consume[i].consume_arg]
				if temp==nil then 
					return false
				else 
					if temp.count<tonumber(consume[i].consume_arg2) then 
						return false
					end 
				end  
			end 
		end
	end 
	return true
end

function m:getData(data)
    local list = {}
    local row = 2
    for i = 1, table.getn(data), row do
        local li = {}
        local len = 0
        for j = 0, row - 1 do
            if data[i + j] then
                local d = data[i + j]
                li[j + 1] = d
                len = len + 1
            end
        end
        if len > 0 then
            table.insert(list, li)
        end
    end
    return list
end

function m:onClick(go, name)
	if name == "pack_btn" then 
		Tool.push("renling", "Prefabs/moduleFabs/renlingModule/newpack_renling")
	end 
end 

function m:getScrollView()
	return self.view
end

function m:onEnter()
    LuaMain:ShowTopMenu(6,nil,{[1]={ type="renlingzhi"},[2]={ type="money"},[3]={ type="gold"}})
end

return m