local libao_contain_cell = {} 

function libao_contain_cell:update(item, index, myTable, delegate)
    self.item_item = item.item_item
    self.item_type =item.item_type
    self.item_num = item.item_num
    self.item = item
    self.index=index
    self.myTable=myTable
    self.delegate = delegate
    self:onUpdate()
end
function libao_contain_cell:onUpdate()
    local binding 
    if self.iconbinding ==nil then 
        self.iconbinding=ClientTool.loadAndGetLuaBindingFromPool("Prefabs/publicPrefabs/itemAll", self.pic.gameObject)
    end 
    
    self.iconbinding:CallTargetFunctionWithLuaTable("setDelegate", self.delegate)
    --if self.item_type == "item" then
    --	binding:CallUpdate({ "itemvo", self.item, self.pic.width, self.pic.height ,true})
    --else
    --print_t(self.item.item_item.type)
    local type = ""
    local name = ""
    if self.item:getType() == "item" then
        self.item = itemvo:new(self.item:getType(), self.item.item_num, self.item.id)
        type = "itemvo"
        name = self.item.itemName
    elseif self.item:getType() == "char" or self.item:getType() == "charPiece" then 
        type = "char"
        name = self.item.name
    elseif libao_contain_cell:resTypeId(self.item:getType()) then
        self.item = itemvo:new(self.item:getType(), 1, self.item.rwCount)
        type = "itemvo"
        name = self.item.itemName
    else
        self.item = itemvo:new(self.item:getType(), 1, self.item.id)
        type = "itemvo"
        name = self.item.itemName
    end
    self.iconbinding:CallUpdate({ type, self.item, self.pic.width, self.pic.height,true})
    --end 
    --print_t(self.item)
    self.name.text = self.item.itemColorName--self.item:getDisplayColorName()
    self.num.gameObject:SetActive(false)
	-- if self.item_num == nil then
	-- 	self.num.text = ""
	-- else
	-- 	self.num.text="X" .. self.item_num
	-- end

end


function libao_contain_cell:resTypeId(_type)
    -- local ret = false
    -- TableReader:ForEachLuaTable("resourceDefine", function(k, v)
    --     if _type == v.name then
    --         ret = true
    --         return false
    --     end
    -- end)
    return Tool.typeId(_type) 
end


return libao_contain_cell