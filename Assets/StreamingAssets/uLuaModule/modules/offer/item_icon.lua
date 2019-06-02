local m = {}

function m:update(item, index, myTable, delegate)
    --    self.img_frame.spriteName = item:getFrame()
    --    self.pic.Url = item:getHead()
    if self.__itemAll == nil then
        self.__itemAll = ClientTool.loadAndGetLuaBindingFromPool("Prefabs/publicPrefabs/itemAll", self.img_frame.gameObject)
        local that = self
       -- self.binding:CallAfterTime(0.2, function()
        --    ClientTool.AdjustDepth(that.__itemAll.gameObject, that.img_frame.depth)
       -- end)
    end
    self.__itemAll:CallUpdate({ "char", item, self.img_frame.width, self.img_frame.height, true })
end

function m:Start()
    self.binding:Hide("pic")
    self.img_frame.enabled = false
end

function m:create()
    return self
end

return m