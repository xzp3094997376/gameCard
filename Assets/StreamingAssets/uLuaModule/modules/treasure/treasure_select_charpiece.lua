local m = {}
local treasureCostList = {}
function m:update(lua)
    treasureCostList = {}
    local list = {}
    self._tp = lua.type
    self._subtp = lua.subtype
    self.needexp = lua.needexp
    self.allexp = lua.allexp
    self.pos = lua.pos
    self.charid = lua.charid
    self.hasSelect = lua.hasSelect
    self.delegate = lua.delegate
	self.callback = lua.callback
    if lua.type == "treasure" then
        if lua.subtype == "treasure_equip" then
            self.title.text=TextMap.GetValue("Text_1_2813")
            self.btSure.transform.localPosition =Vector3(0,0,0)
            local kind = lua.kind
            local noUse = Tool.getUnUseTreasure()
            table.foreach(noUse, function(i, v)
                local gh = Treasure:new(v.value.id, v.key)
                if gh.kind == kind then
                	gh.charid = self.charid
                	gh.pos = self.pos
                    table.insert(list, gh)
                end
            end)
            table.sort(list, function(a, b)
                if a.power ~= b.power then return a.power > b.power end
                if a.star ~= b.star then return a.star > b.star end
                if a.lv ~= b.lv then return a.lv > b.lv end
                return a.id < b.id
            end)
        elseif lua.subtype == "treasure_cost" then
            self.title.text=TextMap.GetValue("Text_1_2814")
            self.btSure.transform.localPosition =Vector3(355,0,0)
            if lua.myTre ~= nil then
                list = Tool.getCanCostTreasure2(lua.myTre)
                if lua.hasSelect~=nil and #lua.hasSelect>0 then 
                    for k,v in pairs(lua.hasSelect) do
                        table.insert(treasureCostList,v)
                    end
                end 
                --self.txt_exp.text = TextMap.GetValue("Text1745")..self.allexp.."\n"..TextMap.GetValue("Text1746")..self.needexp
            end
        elseif lua.subtype == "treasure_reborn" then
            self.title.text=TextMap.GetValue("Text_1_1005")
            self.btSure.transform.localPosition =Vector3(0,0,0)
            local all_list = Tool.getUnUseTreasure()
            for k,v in pairs(all_list) do
                local gh = Treasure:new(v.value.id, v.key)
                if gh.lv>1 or gh.power>0 then 
                    print("LLLLLLLL")
                    table.insert(list, gh)
                end 
            end
            self:sort(list)
        end
    elseif lua.type == "smelt" then --宝物熔炼
        self.title.text=TextMap.GetValue("Text_1_2815")
        self.btSure.transform.localPosition =Vector3(0,0,0)
        local kind = lua.kind
        local noUse = Tool.getUnUseTreasure()
        table.foreach(noUse, function(i, v)
            local gh = Treasure:new(v.value.id, v.key)
            --print_t(gh)
            if gh.star == 5 and gh.lv == 1 and gh.power == 0 and gh.kind ~= "jing" then --未培养过的紫色宝物
                table.insert(list, gh)
            end
        end)
    end
	if #list == 0 then
		--self.binding:CallAfterTime(1, function()
			UIMrg:popWindow()
		--end)
		
        if lua.subtype == "treasure_reborn" then
            MessageMrg.show(TextMap.GetValue("Text_1_1011"))
        elseif lua.subtype == "treasure_equip" then
			-- MessageMrg.show("暂无可穿戴的宝物")
	  		-- 简单的提示一下流浪套装
			local ids = {fang = 1, gong = 3}
			local item = itemvo:new("treasure", 0, ids[lua.kind], 0, ids[lua.kind].."")
			local temp = {}
			temp.obj = item
			UIMrg:pushWindow("Prefabs/moduleFabs/packModule/newpackInfo", temp)
        else
			MessageMrg.show(TextMap.GetValue("Text1747"))
        end
      --UIMrg:popWindow()
    end
    --self.char_num.text = #list
    self.listCount = #list
    local list = m:getData(list)
    self.scrollView:refresh(list, self, true)
    --m:updateCount()
end

function m:sort(charsList)
    table.sort(charsList, function(aData, bData)
        if aData.star ~= bData.star then return aData.star > bData.star end
    end)
    return charsList
end

function m:getChar(char)
    self.delegate:selectedRebornTreasure(char)
    UIMrg:pop()
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
            end
        end
        if len > 0 then
            table.insert(list, li)
        end
    end

    return list
end

function m:onClick(go, name)
    if name == "btnBack" then
		UIMrg:popWindow()
	elseif name == "btSure" then
        UIMrg:popWindow()
        --if #treasureCostList > 0 then
            Events.Brocast('updateCostTreasureList',treasureCostList)
        --end
    end
end

function m:SelectCostCallBack(treasure_cost,item_self)
    if treasure_cost ~= nil then
        if item_self.isChooseValue() then
            self:RemoveSelectCost(treasure_cost)
            item_self:IsSelect()
        elseif #treasureCostList >= 5 then            
            MessageMrg.show(TextMap.GetValue("Text1748"))
        else
            item_self:IsSelect()
            table.insert(treasureCostList,treasure_cost)
        end
        --self.char_num.text = "[00ff00]"..#treasureCostList.."[-]/"..self.listCount
        --print(self.needexp)
        --self.txt_exp.text =TextMap.GetValue("Text1745")..self:AllExpValue().."\n"..TextMap.GetValue("Text1746")..self.needexp
    end
end

function m:AllExpValue()
    local exp = 0
    for k,v in pairs(treasureCostList) do
        exp = exp + v:getTreasureExp()
    end
    return exp
end

--熔炼
function m:OnSelect(treasure)
    if treasure == nil then return end
    if self.delegate ~= nil then
        self.delegate:setMaterial(treasure)
        UIMrg:popWindow()
    end
end

function m:RemoveSelectCost( item )
    for k,v in pairs(treasureCostList) do
        if item.key == v.key then
            table.remove(treasureCostList,k)
        end
    end
end

function m:GetKindName(kind)
    if kind == "gong" then
        return "[00ff00]"..TextMap.GetValue("Text1749").."[-]"
    elseif kind == "fang" then
        return "[00ff00]"..TextMap.GetValue("Text1750").."[-]"
    end
    return ""
end

return m

