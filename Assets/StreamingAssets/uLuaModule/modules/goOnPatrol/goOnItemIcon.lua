--抽卡物品头像显示
local M = {}

function M:update(data, index, table)
    if data.itemColorName ~= nil then
        self.labName.text = data.itemColorName
    elseif data.color ~= nil then
        self.labName.text = Char:getItemColorName(data.color, data.name)
    else
        self.labName.text = data.name
    end

    self.item_frame.enabled = false
    if self.__itemAll == nil then
        self.__itemAll = ClientTool.loadAndGetLuaBindingFromPool("Prefabs/publicPrefabs/itemAll", self.item_frame.gameObject)
    end
    self.__itemAll:CallUpdate({ "char", data, self.item_frame.width, self.item_frame.height })
    --    ClientTool.resetTransform(self.__itemAll.transform)
    if data.star and data.star > 5 and self.Panel then
        self.Panel:SetActive(true)
    else
        if self.Panel then
            self.Panel:SetActive(false)
        end
    end
end

function M:Start(...)
    -- if myFont then
    --     self.labName.bitmapFont = myFont
    -- end
end

function M:play(cb)
    self.binding:PlayTween("ani", 0.3, function()
        if cb then cb() end
    end)
end



return M