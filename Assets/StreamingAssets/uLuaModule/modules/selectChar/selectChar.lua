local m = {}

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

function m:update(data)
    self.callBack = data.callBack
    local chars = Player.Chars:getLuaTable()
    self.charsList = {}
    local hasChar = {}
    local index = 1
    for k, v in pairs(chars) do
        local char = Char:new(k, v)
        if char:isHaveVest() then
            self.charsList[index] = char
            hasChar[char.id] = true
            index = index + 1
        end
    end
    Tool.sortChar(self.charsList)
    local list = self:getData(self.charsList)
    --    self.myTable:refresh("Prefabs/moduleFabs/selectChar/charHead", self.charsList, self)
    self.charView:refresh(list, self, true)
    list = nil
end

--选择角色，关闭列表
function m:selectedChar(char)
    self:onClose()
    if self.callBack then self.callBack(char) end
end

function m:onClose()
    --    SendBatching.DestroyGameOject(self.binding.gameObject)
    --    UIMrg:pop()
    self.binding.gameObject:SetActive(false)
end

function m:Start()
    --    LuaMain:ShowTopMenu(1)
end

function m:show(type, callBack)
    --    local binding = ClientTool.loadAndGetLuaBinding("Prefabs/moduleFabs/selectChar/select_list", GlobalVar.Center)
    --    binding:CallUpdate({
    --        type = type,
    --        callBack = callBack
    --    })
    Tool.push("select_list", "Prefabs/moduleFabs/selectChar/select_list", {
        type = type,
        callBack = callBack
    })
end

function m:onClick(go, name)
    self:onClose()
end

function m:create()
    return self
end

return m