local ItemCell = {}


function ItemCell:updateItem()
    self.char_kuang.gameObject:SetActive(false)
    local infobinding = ClientTool.loadAndGetLuaBindingFromPool("Prefabs/publicPrefabs/itemAll", self.char)
    infobinding:CallUpdate({ "itemvo", self.itemVO, self.char_kuang.width, self.char_kuang.height, true })
    if self.itemVO.isShowName ~= nil and self.itemVO.isShowName == false then
        return
    else
        self.Label.text = self.itemVO.itemColorName
    end
end

function ItemCell:update(table)
    self.itemVO = table
    ItemCell:updateItem()
end

--初始化
function ItemCell:create(binding)
    self.binding = binding

    return self
end

return ItemCell