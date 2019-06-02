local m = {}

function m:update(data)
    self.name.text = data:getDisplayColorName()
        
    --self.num.text=data.rwCount
    --self.frame.gameObject:SetActive(false)
    if self.__itemAll == nil then
        self.__itemAll = ClientTool.loadAndGetLuaBindingFromPool("Prefabs/publicPrefabs/itemAll", self.Pic.gameObject)
        local that = self
        -- self.binding:CallAfterTime(0.2, function()
        --     ClientTool.AdjustDepth(that.__itemAll.gameObject, that.Pic.depth)
        -- end)
    end
    local type = ""
    if data:getType() == "item" then
        self.item = itemvo:new(data:getType(), data.rwCount, data.id)
        type = "itemvo"
    elseif data:getType() == "char" or data:getType() == "charPiece" then 
        self.item = data
        type = "char"
    elseif self:typeId(data:getType()) then
        self.item = itemvo:new(data:getType(), 1, data.rwCount)
        type = "itemvo"
    else
        self.item = itemvo:new(data:getType(), 1, data.id)
        type = "itemvo"
    end
    self.__itemAll:CallUpdate({type, self.item, self.Pic.width, self.Pic.height, true, nil, true })
end

function m:typeId(_type)
    -- local ret = false
    -- TableReader:ForEachLuaTable("resourceDefine", function(k, v)
    --     if _type == v.name then
    --         ret = true
    --         return false
    --     end
    -- end)
    return Tool.typeId(_type) 
end

function m:create()
    return self
end

return m