local m = {}


function m:update(lua)
    local char = lua.char
    local delegate = lua.delegate
    self.delegate = delegate
    self.char = char

    self.lb_lingya.text = char.power
    self.lb_name.text = char.name

    self.char_head.enabled = false
    if self.__itemAll == nil then
        self.__itemAll = ClientTool.loadAndGetLuaBindingFromPool("Prefabs/publicPrefabs/itemAll", self.char_head.gameObject)
    end
    self.__itemAll:CallUpdate({ "char", char, self.char_head.width, self.char_head.height })
    --    self.char_head:CallUpdate(char)
end

function m:onClick(go, name)
    self.delegate:selectedChar(self.char)
end

function m:create()
    return self
end

return m