local lasDropItem = {}

function lasDropItem:update(v)
    self.img_kuangzi.gameObject:SetActive(false)
    local binding = ClientTool.loadAndGetLuaBindingFromPool("Prefabs/publicPrefabs/itemAll", self.newpackDropitem)
    binding:CallUpdate({ "char", v, self.img_kuangzi.width, self.img_kuangzi.height })
    self.Label.text = v:getDisplayName()
end

--初始化
function lasDropItem:create(binding)
    self.binding = binding
    return self
end

return lasDropItem