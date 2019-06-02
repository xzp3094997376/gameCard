local m = {}

function m:update(v)
    --self.img_kuangzi.gameObject:SetActive(false)
    if self.itemBinding ~= nil then
        self.binding:DestroyObject(self.itemBinding.gameObject)
    end
    self.itemBinding = ClientTool.loadAndGetLuaBindingFromPool("Prefabs/publicPrefabs/itemAll", self.img_itm_k.gameObject)
    self.itemBinding:CallUpdate({ "char", v.data, self.img_itm_k.width, self.img_itm_k.height, true })
    self.txt_item.text = v.data:getDisplayName()
end

--初始化
function m:create(binding)
    self.binding = binding
    return self
end

return m