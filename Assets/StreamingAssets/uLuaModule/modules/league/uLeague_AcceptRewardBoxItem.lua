local m = {}

function m:update(v)
    self.img_kuangzi.gameObject:SetActive(false)
    local binding = ClientTool.loadAndGetLuaBindingFromPool("Prefabs/publicPrefabs/itemAll", self.newpackDropitem)
    binding:CallUpdate({ "char", v.data, self.img_kuangzi.width, self.img_kuangzi.height, true })
    self.Label.text = v.data:getDisplayName()
    v = nil
end

--初始化
function m:create(binding)
    self.binding = binding
    return self
end

return m