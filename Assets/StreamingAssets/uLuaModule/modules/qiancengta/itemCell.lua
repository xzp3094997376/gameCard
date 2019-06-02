local newPackDropItem = {}

local binding
function newPackDropItem:update(v)
    self.img_kuangzi.gameObject:SetActive(false)
    if binding == nil then
        binding = ClientTool.loadAndGetLuaBindingFromPool("Prefabs/publicPrefabs/itemAll", self.newpackDropitem)
    end
    if v.type_item == "itemvo" then
        binding:CallUpdate({ "itemvo", v, self.img_kuangzi.width, self.img_kuangzi.height, true, nil, true })
    else
        binding:CallUpdate({ "char", v, self.img_kuangzi.width, self.img_kuangzi.height, true, nil, true })
    end
    self.Label.text = v.itemColorName
end


return newPackDropItem