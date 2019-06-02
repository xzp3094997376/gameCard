--
-- Created by IntelliJ IDEA.
-- User: sunny  
-- Date: 2015/11/10
-- Time: 16:11
-- To change this template use File | Settings | File Templates.
-- 宝物列表
local m = {}

function m:update(lua)
    local list = self:showTreasureList()
    self.scrollView:refresh(list, self)
end

--更新列表
function m:onUpdate(flag)
    local list = self:showTreasureList()
    self.scrollView:refresh(list, self, false, -1)
    if self.isScroll ~= false then
        self.binding:CallAfterTime(0.1, function()
            self.scrollView:ResetPosition()
        end)
    end

    --self.redPoint_for_pice:SetActive(Tool.checkRedPoint("tujian")  or false)
end

function m:onClick(go, name)
	if name == "btnBack" then 
		UIMrg:pop()
	elseif name == "btn_sale" then 
		self:onSale()
	end 
end 

function m:getHasUseGhost()
    local ghostSlot = Player.ghostSlot
    local list = {}
    for i = 0, 5 do
        local slot = ghostSlot[i]
        local postion = slot.postion
        local len = postion.Count
        for j = 0, len - 1 do
            local pos = postion[j]
            if pos ~= nil and pos ~= "" and pos ~= 0 then
                list[pos .. ""] = slot.charid
            end
        end
    end
    return list
end

function m:getCanSale()
    local treasures = Player.Treasure:getLuaTable()
    for k,v in pairs(treasures) do
        local _treasure = Treasure:new(v.id, k)
        if self.sellType == nil then 
            self.sellType = _treasure.Table.sell_type
        end 
        if v.onPosition== false then
            return true
        end
    end
    return false
end

function m:onSale()
    if m:getCanSale() then 
        local bind = Tool.push("common_hero_select", "Prefabs/moduleFabs/hero/gui_common_select_hero", {delegate = self, type = 3})
    else 
        MessageMrg.show(TextMap.GetValue("Text_1_2811"))
    end 
end 

function m:onSaleCallBack(teamList, delegate)
	if teamList == nil then return end 
	local saleList = {}
	local index = 1 
	for k, v in pairs(teamList) do 
		saleList[index] = tonumber(v.key)
		index = index + 1
	end 
	if #saleList < 1 then return end 
	Api:sellEquip("treasure", saleList, function(ret)
		if ret.ret == 0 then 
			m:update()
			MessageMrg.show(TextMap.GetValue("Text_1_328"))
            packTool:showMsg(ret, nil, 0)
            delegate:onCallBack()
            
		end 
	end,function()
		return false 
	end)
end

function m:onEnter()
    self.isScroll = false
    m:onUpdate()
    LuaMain:ShowTopMenu()
end

--刷新宝物列表
function m:showTreasureList()
    self.curNum = 0
    local treasuresList = {} --未装备的所有宝物
    local treasures = Player.Treasure:getLuaTable()

    local list = {} --装备的宝物
    local explist = {} --经验宝物
    for k,v in pairs(treasures) do
        self.curNum = self.curNum + 1
       local _treasure = Treasure:new(v.id, k)
       if v.onPosition then
			local data = _treasure:GetCharIDandPos()
			if data.charid ~= nil then 
				_treasure.charid = data.charid
				table.insert(list, _treasure)
			else
				if _treasure.kind == "jing" then
					table.insert(explist, _treasure)
				else
					table.insert(treasuresList, _treasure)
				end
			end
        else
            if _treasure.kind == "jing" then
                table.insert(explist, _treasure)
            else
                table.insert(treasuresList, _treasure)
            end
        end
    end

    self.ShowNum.gameObject:SetActive(true)
    self.Label_Value_Bag.text = self.curNum.."/"..TableReader:TableRowByID("bagMax", "maxChar")["vip"..Player.Info.vip]

    -- 排列未装备的宝物
    table.sort(treasuresList, function(a, b)
        if a.star ~= b.star then return a.star > b.star end
        if a.power ~= b.power then return a.power > b.power end
        if a.lv ~= b.lv then return a.lv > b.lv end
        return a.id < b.id
    end)

    --排列装备的宝物
    table.sort(list, function(a, b)
		if a.charid ~= b.charid then return a.charid < b.charid end 
        if a.star ~= b.star then return a.star > b.star end
        if a.power ~= b.power then return a.power > b.power end
        if a.lv ~= b.lv then return a.lv > b.lv end
        return a.id < b.id
    end)

    --排列EXP宝物
    table.sort(explist, function(a, b)
        if a.star ~= b.star then return a.star > b.star end
        return a.id < b.id
    end)


    for i = 1, #treasuresList do
        local v = treasuresList[i]
        table.insert(list, v)
    end

    for i=1,#explist do
        local sz = explist[i]
        table.insert(list, sz)
    end

    treasuresList = self:getData(list)
    if #treasuresList == 0 then
        MessageMrg.show(TextMap.GetValue("Text_1_2812"))
        return {}
    end
    return treasuresList
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


function m:OnDestroy()
    Events.RemoveListener('selectedTreasure')
end

function m:Start()
    self.isScroll = true
    Tool.loadTopTitle(self.gameObject, TextMap.GetValue("Text_1_774"))
    Events.AddListener("selectedTreasure", funcs.handler(self, m.selectedTreasure))
    self.tab = 1 
    LuaMain:ShowTopMenu()
    --local teams = Player.Team[0].chars
    self:onUpdate()
end

function m:selectedTreasure(treasure)
    self.isScroll = true
    self:onUpdate()
end

return m

