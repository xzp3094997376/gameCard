local m = {}
local infobinding
function m:update(v)
    self.frame.gameObject:SetActive(false)
    if infobinding == nil then
        infobinding = ClientTool.loadAndGetLuaBindingFromPool("Prefabs/publicPrefabs/itemAll", self.go)
    end
    if v.type == "char" or v.type == "charPiece" then
        infobinding:CallUpdate({ "char", v.data, self.frame.width, self.frame.height, true, nil, true })
        self.name.text = v.data:getDisplayName()
    else
        infobinding:CallUpdate({ "itemvo", v.data, self.frame.width, self.frame.height, true, nil, true })
        self.name.text = v.data.itemColorName
    end
end

return m