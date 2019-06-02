local m = {} 

function m:Start()
	Tool.loadTopTitle(self.gameObject, TextMap.GetValue("Text_1_2971"))
	LuaMain:ShowTopMenu(6,nil,{[1]={ type="renlingzhi"},[2]={ type="money"},[3]={ type="gold"}})
	local bag =Player.renlingBag:getLuaTable()
    if not bag then error("bag have nothing") end
    local totelNum = 0
    local analogData = {}
    for k, v in pairs(bag) do
        local vo = RewardMrg.getDropItem({type="renling",arg=v.id,arg2=v.count})
        totelNum = totelNum + 1
        analogData[totelNum] = vo
        vo.delegate=self
        vo = nil
    end
    table.sort(analogData, function(a, b)
        if a.star ~= b.star then return a.star < b.star end
        return a.id > b.id
    end)
    analogData=m:getData(analogData)
    self.scrollView:refresh(analogData, self, false,0)
    if #analogData==0 then 
    	self.Label:SetActive(true)
        self.cansale=false
    else 
    	self.Label:SetActive(false)
        self.cansale=true
    end 
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
                d.realIndex = i + j
                li[j + 1] = d
                len = len + 1
                d.mType = self.mType
            end
        end
        if len > 0 then
            table.insert(list, li)
        end
    end
    return list
end

function m:onSaleCallBack(teamList, delegate)
    if teamList == nil then return end 
    local saleList =""
    local index = 1 
    local total = 0
    for k, v in pairs(teamList) do 
        total=total+1
    end 
    for k, v in pairs(teamList) do 
        if index==total then 
            saleList=saleList.. "\"" .. v.id .. "\"" .. ":" .. v.count 
        else 
            saleList=saleList.. "\"" .. v.id .. "\"" .. ":" .. v.count  .. ","
        end
        index=index+1 
    end 
    saleList="{" .. saleList .. "}"
    Api:decomposeRenling(saleList,function (result)
            packTool:showMsg(result, nil, 0)
            UIMrg:popWindow()
            delegate:onCallBack()
        end) 
end 

function m:onClick(go, name)
	if name == "fenjie_btn" then
		m:onSale()   
	end 
end

function m:getcansale()
    local bag =Player.renlingBag:getLuaTable()
    local openLv = TableReader:TableRowByID("renling_config",5).value2
    local maxStar = TableReader:TableRowByID("renling_config",6).value2
    local activeList = Player.renling
    for k, v in pairs(bag) do
        local vo = RewardMrg.getDropItem({type="renling",arg=v.id,arg2=v.count})
        local haveNum = 0
        for i=0,vo.Table.show.Count-1 do
            local id = vo.Table.show[i]
            local row = TableReader:TableRowByID("renling_group",id)
            if activeList[row.group]~=nil and activeList[row.group][id] ~=nil and tonumber(activeList[row.group][id].level)>=1 then 
                if Player.Info.level>=tonumber(openLv) and tonumber(Player.renling[row.group][id].level)<tonumber(maxStar) then 
                    haveNum=haveNum+1
                end 
            else 
                haveNum=haveNum+1
            end 
        end
        if haveNum ==0 then 
            return true 
        end 
    end
    return false
end

function m:onSale()
    if self.cansale then 
        local bind = Tool.push("common_hero_select", "Prefabs/moduleFabs/hero/gui_common_select_hero", {delegate = self, type = 4})
    else 
         MessageMrg.show(TextMap.GetValue("Text_1_2973"))
    end
end

function m:onEnter()
    m:Start()
end

return m