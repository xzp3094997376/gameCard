local m = {}
--合成碎片
function m:update(item, index, _table, delegate)
    --    self.item_frame.spriteName = item:getFrame()
    --    self.item_icon.Url = item:getHead()
    self.item_frame.enabled = false
    self.delegate = delegate
    if self.__itemAll == nil then
        self.__itemAll = ClientTool.loadAndGetLuaBindingFromPool("Prefabs/publicPrefabs/itemAll", self.item_frame.gameObject)
        --self.binding:CallAfterTime(0.2, function()
       --     ClientTool.AdjustDepth(self.__itemAll.gameObject, self.item_frame.depth)
        --end)
    end
    self.__itemAll:CallUpdate({ "char", item, self.item_frame.width, self.item_frame.height })
    --    测试
    --TODO
    --        if item.count == 0 then
    --            Api:getItem(item:getType(), item.id, item._costCount + 1, function()
    --                item.count = item._costCount + 1
    --                self.txt_cost.text = item:getCostDesc()
    --            end)
    --        end
    self.txt_cost.text = item:getCostDesc()
    self.item = item
end

function m:onClick(go, name)
    self.delegate:setEquipTitle(self.item, self.delegate.next_index)
end

function m:create()
    return self
end

return m