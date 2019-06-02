
local m = {}

function m:update(lua)
    local list = self:showEquipList()
	self:updateView(list, true)
end

--更新列表
function m:onUpdate()
    local list = {}
    if self.tab == 1 then
        list = self:showEquipList()
		self.img_hero:SetActive(true)
		self.img_pice_Up:SetActive(false)
		self.btn_sale.gameObject:SetActive(true)
    elseif self.tab == 2 then
        list = self:showPiceList()
		self.img_hero:SetActive(false)
		self.img_pice_Up:SetActive(true)
		self.btn_sale.gameObject:SetActive(false)
    end 
    self:updateView(list)
	self:updateRedPoint()
    self.redPoint:SetActive(Tool.checkRedPoint("guidao_qh",nil,true) or Tool.checkRedPoint("guidao_jl",nil,true) or false)
end

function m:updateLocal()
	if self.tab == 1 then 
		self.scrollView_equip:updateLocal()
	elseif self.tab == 2 then  
		self.scrollView_piece:updateLocal()
	end
end

function m:updateRedPoint()
    self.redPoint_for_pice:SetActive(Tool.checkRedPoint("guidao_hecheng") or false)
end

function m:updateView(list)
	if self.tab == 1 then 
		self.scrollView_equip.gameObject:SetActive(true)
		self.scrollView_equip:refresh(list, self, false, -1)
		self.scrollView_piece.gameObject:SetActive(false)
        if self.isScroll then
            self.binding:CallAfterTime(0.05, function()
                self.scrollView_equip:ResetPosition()
            end)
        end
	elseif self.tab == 2 then  
		self.scrollView_piece.gameObject:SetActive(true)
		self.scrollView_piece:refresh(list, self, false, -1)
		self.scrollView_equip.gameObject:SetActive(false)
        if self.isScroll then
            self.binding:CallAfterTime(0.05, function()
                self.scrollView_piece:ResetPosition()
            end)
        end
	end
end 

local function isUsed(list, key)
    return list[key .. ""] ~= nil
end

function m:onFilter(ghost)
	--if char.id == Player.Info.playercharid then 
	--	return false 
	--end 
	return true
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

--刷新英雄列表
function m:showEquipList()
    self.curNum = 0
    local ghostList = {}
    local ghost = Player.Ghost:getLuaTable() or {}
    local hasUse = m:getHasUseGhost() or {}
    local equipList = {  }
    local list = {  }
    table.foreach(ghost, function(i, v)
        self.curNum = self.curNum + 1
        local gh = Ghost:new(v.id, i)
        local tp = gh.kind
		gh.tab = 1
        if not isUsed(hasUse, i) then
            gh.hasWear = 0
			table.insert(list, gh)
        else
            gh.hasWear = 1
            gh.charid = hasUse[i .. ""]
			local char = Char:new(gh.charid)	
			if tostring(gh.charid) == tostring(Player.Info.playercharid) then 
				gh.charName = Char:getItemColorName(char.star, Player.Info.nickname)--TextMap.GetValue("Text_1_325")..
			else
				gh.charName = Char:getItemColorName(char.star, char.name)--TextMap.GetValue("Text_1_325")..
			end 
            
            table.insert(equipList, gh)
        end
    end)
    self.ShowNum.gameObject:SetActive(true)
    self.Label_Value_Bag.text = TextMap.GetValue("Text_1_326")..self.curNum.."/"..TableReader:TableRowByID("bagMax", "maxGhost")["vip"..Player.Info.vip]
    
	
	if #equipList > 1 then 
		table.sort(equipList, function(a, b)
			if a.charid ~= b.charid then return a.charid > b.charid end 
			if a.star ~= b.star then return a.star > b.star end
			if a.lv ~= b.lv then
				return a.lv > b.lv
			end
			return a.id < b.id
		end)
	end

	if #list > 1 then 
		table.sort(list, function(a, b)
			if a.star ~= b.star then return a.star < b.star end
			if a.lv ~= b.lv then
				return a.lv < b.lv
			end
			return a.id > b.id
		end)
	end 

    local len = #list
    if len > 0 then
        for i=1,#list do
            local v = list[i]
            table.insert(ghostList, 1, v)
        end
    end

    for i = 1, #equipList do
        local v = equipList[i]
        table.insert(ghostList, 1, v)
    end

	ghostList = self:getData(ghostList)
    list = nil
    enterList = nil
    return ghostList
end


--显示碎片列表
function m:showPiceList()
    self.ShowNum.gameObject:SetActive(false)
    local piecesList = {}
    local enoughList = {}
    local hasList = {}
    local pieces = Tool.getGhostPieceList() --获取碎片列表
	local pg = Player.GhostPieceBagIndex:getLuaTable()
    table.foreachi(pieces, function(index, piece)
        self.curNum = self.curNum + 1
        piece:updateInfo() --更新碎片信息
        if piece.count > 0 then
			--print("___piece.id = " .. piece.id)
            local char = GhostPiece:new(piece.id)
			--print("___star = " .. char.star .. "   name = " .. char.name )
            local name = char:getDisplayName()
            --local tb = TableReader:TableRowByUnique("avter", "name", name)
            --if self:checkPieceByEquip(tb.id) == false then --无该碎片所对应的角色
				--print_t(char)
				if char.count >= char.needCharNumber then --合成
					char.tab = 2
					table.insert(enoughList, char)
				else 
					char.tab = 3
					table.insert(piecesList, char)
				end
            --else --已经拥有该角色(去进化)
			--	char.tab = 4
			--	able.insert(hasList, char)
            --end
        end
    end)

    table.sort(enoughList, function(a, b)
        if a.star ~= b.star then return a.star < b.star end
    end)

    table.sort(piecesList, function(a, b)
        if a.star ~= b.star then return a.star > b.star end
        if a.count ~= b.count then
            return a.count > b.count
        end
        return a.id < b.id
    end)

    table.sort(hasList, function(a, b)
        if a.star ~= b.star then return a.star < b.star end
        if a.count ~= b.count then
            return a.count < b.count
        end
        return a.id > b.id
    end)

    table.foreachi(hasList, function(i, v)
        table.insert(piecesList, 1, v)
    end)

    table.foreachi(enoughList, function(i, v)
        table.insert(piecesList, 1, v)
    end)

    piecesList = self:getData(piecesList)
    if #piecesList == 0 then
        MessageMrg.show(TextMap.GetValue("Text1142"))
        return {}
    end
    return piecesList
end

--检测碎片所对应角色是否已经拥有
function m:checkPieceByEquip(key)
    if key == nil then return end
    local list = {}
    local charsList = Player.Ghost:getLuaTable()
    table.foreach(ghost, function(i, v)
        local char = Ghost:new(v.id, i)
        table.insert(list, char)
    end)
    for i = 1, #list do
        if list[i] ~= nil and list[i].key == key then
            return true
        end
    end
    return false
end

--检测该角色是否上阵
function m:check(charid)
    local teams = Player.Team[0].chars
    local list = {}
    for i = 0, 5 do
        if teams.Count > i then
            list[i + 1] = teams[i]
        else
            list[i + 1] = 0
        end
    end
    for i = 1, 6 do
        if charid == list[i] and charid ~= "0" and charid ~= 0 then
            return true
        end
    end
    return false
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

--获取当前的类型(1为英雄列表,2为碎片列表)
function m:getTab()
    return self.tab
end

--获取小伙伴队列
function m:checkFriend(charId)
    local teams = Player.Team[12].chars
    local list = {}
    for i = 0, 7 do
        if teams[i]~= nil and teams[i] == charId then
            return true
        end
    end
    return false
end

function m:onClick(go, name)
    if name == "btn_lvup_down" then --显示英雄列表
        self.isScroll = true
		if self.tab == 1 then return end
		self.tab = 1
		self:onUpdate()
	elseif name == "btn_pice_down" then --显示碎片列表
        self.isScroll = true
		if self.tab == 2 then return end
		self.tab = 2
		self:onUpdate()
	elseif name == "btnBack" then 
		UIMrg:pop()
	elseif name == "btn_sale" then 
		self:onSale()
    end
end

local function isUsed(list, key)
    return list[key .. ""] ~= nil
end

function m:getCanSaleEquip()
    local ghost = Player.Ghost:getLuaTable() or {}
    local hasUse = m:getHasUseGhost() or {}
    local canSale = false
    table.foreach(ghost, function(i, v)
        local gh = Ghost:new(v.id, i)
        if not isUsed(hasUse, i) then
            if self.onFilter then
                if self:onFilter(gh) then
                    canSale = true
                end
            else
                canSale = true
            end
        end
    end)
    return canSale
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

local function isUsed(list, key)
    return list[key .. ""] ~= nil
end

function m:onSale()
    if m:getCanSaleEquip() then 
        print("LLLLLLLLLL")
        local bind = Tool.push("common_hero_select", "Prefabs/moduleFabs/hero/gui_common_select_hero", {delegate = self, type = 2})
    else 
        MessageMrg.show(TextMap.GetValue("Text_1_327"))
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
	Api:sellEquip("ghost", saleList, function(ret)
		if ret.ret == 0 then 
			m:update()
			MessageMrg.show(TextMap.GetValue("Text_1_328"))
            packTool:showMsg(ret, nil, 0)
            delegate:onCallBack()
		end 
	end,function()
		return false 
	end )
end 

function m:onEnter()
    LuaMain:ShowTopMenu()
        self.isScroll = false
        self:onUpdate()
        -- if self.tab == 1 then
        --     self:onUpdate()
        -- elseif self.tab == 2 then
        --     local list = self:showPiceList()
        --     self.scrollView_piece:refresh(list, self, false, -1)
        -- end
    --self:onUpdate()
	--self:updateLocal()
end

function m:OnDestroy()
    -- Events.RemoveListener('updateHeroList')
end

function m:Start()
    self.isScroll = true
    Tool.loadTopTitle(self.gameObject, TextMap.GetValue("Text_1_329"))
    self.tab = 1 -- (1为显示英雄列表,2为显示碎片列表,默认是英雄列表)
    LuaMain:ShowTopMenu()
    local teams = Player.Team[0].chars
    self:onUpdate()
end

return m

