local M = {}

function M:update(data, index, table)
    --data为Char:new(item.arg)或者itemvo:new(item.type, item.arg2, item.arg)
    local name = data.name or data.itemName or ""
    self.labName.text = Tool.getNameColor(data.star) .. name .. "[-]"

    self.item_frame.enabled = false
    if self.__itemAll == nil then
        self.__itemAll = ClientTool.loadAndGetLuaBindingFromPool("Prefabs/publicPrefabs/itemAll", self.item_frame.gameObject)
    end

    if data.getType and data.getType() == "char" then
        self.__itemAll:CallUpdate({ "char", data, self.item_frame.width, self.item_frame.height })
    else
        self.__itemAll:CallUpdate({ "itemvo", data, self.item_frame.width, self.item_frame.height })
    end
end

function M:play(cb)
    self.binding:PlayTween("ani", 0.3, function()
        if cb then cb() end
    end)
end



return M