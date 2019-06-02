--
-- 选择英雄碎片 或 鬼道
local m = {}

local function isUsed(list, key)
    return list[key .. ""] == true
end

function m:update(lua)
    local star = lua.star
	self.callback = lua.callback
    local list = {}
    self._tp = lua.type
    if lua.type == "ghost" then
        local kind = lua.kind
        local has = lua.ghost or {}
        local key = has.key or ""
        local ghost = Player.Ghost:getLuaTable() or {}
		local hasUse = Tool.getHasUseGhost()

        table.foreach(ghost, function(i, v)
            local gh = Ghost:new(v.id, i)
            if gh.kind == kind then
                if not isUsed(hasUse, i) then
                    table.insert(list, gh)
                end
            end
        end)
        table.sort(list, function(a, b)
            if a.star ~= b.star then return a.star > b.star end
            if a.power ~= b.power then return a.power > b.power end
            if a.lv ~= b.lv then return a.lv > b.lv end
            return false
        end)
		
        if #list == 0 then
			UIMrg:popWindow()
			local ids = {po = 4, hui = 2, fu = 1, jie = 3}
			local item = itemvo:new("ghost", 0, ids[kind], 0, ids[kind].."")
			local temp = {}
            temp.obj = item
            UIMrg:pushWindow("Prefabs/moduleFabs/packModule/newpackInfo", temp)
        end
    elseif lua.type == "treasure" then
        self.charid=lua.charid
        self.pos=lua.pos
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
        if #list==0 then 
			UIMrg:popWindow()
            local ids = {fang = 1, gong = 3}
            local item = itemvo:new("treasure", 0, ids[lua.kind], 0, ids[lua.kind].."")
            local temp = {}
            temp.obj = item
            UIMrg:pushWindow("Prefabs/moduleFabs/packModule/newpackInfo", temp)
        end 
    else
        local pieces = Tool.getAllCharPiece() or {}
        local filter = lua.filter or function() return true end
        table.foreach(pieces, function(i, piece)
            piece:updateInfo()
            if piece.count > 0 then
                if filter(piece) then
                    if piece.star == star then
                        piece.rwCount = piece.count
                        table.insert(list, piece)
                    end
                end
            end
        end)
        if #list == 0 then
            --            UIMrg:popWindow()
            --            self.binding:Show("btn_go")
            --            self.binding:Show("txt_desc")
            --            self.txt_desc.text = TextMap.GetValue("Text112")
            --            self.btn_name.text = TextMap.GetValue("Text317")
            UIMrg:popWindow()
            DialogMrg.ShowDialog(TextMap.GetValue("Text112"), function()
                UIMrg:popWindow()
                uSuperLink.openModule(8)
            end, function() end, TextMap.GetValue("Text1136"), "openModule")
        end
    end
    local list = m:getData(list)
    self.scrollView:refresh(list, self, true)
    m:updateCount()
end

function m:updateCount()
    if self._tp == "ghost" or self._tp == "treasure" then return self.binding:Hide("char_num") end
    local index = 0
    table.foreach(selectCharPieceList, function(i, v)
        if v ~= nil then
            index = index + v.count
        end
    end)
    self.char_num.text = index .. "/" .. 5
end

function m:pushList(char)
    if selectCharPieceList[char.id] == nil then selectCharPieceList[char.id] = { char = char, count = 0 } end
    local count = selectCharPieceList[char.id].count
    selectCharPieceList[char.id].count = count + 1
    m:updateCount()
end

--function m:popList(id)
--    selectCharPieceList[id] = nil
--    m:updateCount()
--end

function m:getCount(id)
    local item = selectCharPieceList[id]
    if item == nil then return 0 end
    return item.count
end

function m:isFull(char)
    local index = 0
    local id = char.id
    table.foreach(selectCharPieceList, function(i, v)
        if v ~= nil then
            if v.char.id == id and v.char.count <= v.count then index = 5 return end
            index = v.count + index
        end
    end)
    return index >= 5
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
    if name == "btn_ok" then
        UIMrg:popWindow()
        -- Events.Brocast('updateCharPiece')
    elseif name == "btn_go" then
        if self._tp == "ghost" then
            UIMrg:popWindow()
            -- Tool.push("HunLian", "Prefabs/moduleFabs/guidao/hun_lian")
            uSuperLink.open("ghost", { 2 })
        else
            UIMrg:popWindow()
            uSuperLink.openModule(8)
        end
	elseif name == "btnBack" then 
		UIMrg:popWindow()
    end
end

return m

