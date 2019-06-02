local uChapterBoxItem = {}

function uChapterBoxItem:update(v)
    self.img_kuangzi.gameObject:SetActive(false)
    local binding = ClientTool.loadAndGetLuaBindingFromPool("Prefabs/publicPrefabs/itemAll", self.newpackDropitem)
    binding:CallUpdate({ "char", v.data, self.img_kuangzi.width, self.img_kuangzi.height, true })
    self.Label.text = Tool.getNameColor(v.data.star or v.data.color or 1) .. v.data.name .. "[-]"
    v = nil
end

--初始化
function uChapterBoxItem:create(binding)
    self.binding = binding
    return self
end

return uChapterBoxItem