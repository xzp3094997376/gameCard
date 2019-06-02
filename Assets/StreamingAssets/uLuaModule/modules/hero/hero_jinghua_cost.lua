--
-- Created by IntelliJ IDEA.
-- User: xiyou
-- Date: 2015/3/4
-- Time: 11:47
-- To change this template use File | Settings | File Templates.
-- 进化材料

local m = {}

function m:update(lua)
    self.item = lua.item
    self.go.enabled = false
    if self.__itemAll == nil then
        self.__itemAll = ClientTool.loadAndGetLuaBindingFromPool("Prefabs/publicPrefabs/itemAll", self.go.gameObject)
    end
	local type = ""
	local name = ""
	-- if self.item:getType() == "item" then 
	-- 	self.item = itemvo:new(self.item:getType(), 1, self.item.id)
	-- 	type = "itemvo"
	-- 	name = self.item.itemName
	-- elseif self.item:getType() == "char" or self.item:getType() == "charPiece" then 
	-- 	type = "char"
	-- 	name = self.item.name
	-- else
	-- 	self.item = itemvo:new(self.item:getType(), 1, self.item.id)
	-- 	type = "itemvo"
	-- 	name = self.item.itemName
	-- end

	--
	if self.item:getType() == "item" then
        type = "itemvo"
        self.item = itemvo:new(self.item:getType(), self.item.item_num, self.item.id)
	 	name = self.item.itemName
    elseif self.item:getType() == "char" then 
        type = "char"
        name = self.item.name
    elseif self.item:getType() == "charPiece" then
        type = "charPiece"
        name = self.item.name
    elseif self.item:getType() == "pet" or self.item:getType() == "petPiece" then
        type = "pet"
        name = self.item.name
    elseif self.item:getType() == "petPiece" then
        type = "petPiece"
        name = self.item.name
    elseif self.item:getType() == "yulingPiece" then
        type = "petPiece"
        name = self.item.name
    elseif newItemContent:resTypeId(self.item:getType()) then
        type = "itemvo"
        self.item = itemvo:new(self.item:getType(), 1, self.item.rwCount)
	 	name = self.item.itemName
    else
        type = "itemvo"
        self.item = itemvo:new(self.item:getType(), 1, self.item.id)
	 	name = self.item.itemName
    end
	--
    self.__itemAll:CallUpdate({type, self.item, self.go.width, self.go.height, true})
    self.txt_num.text = lua.num
	self.txtName.text = Char:getItemColorName(self.item.star or 1, name) 
    --    self.vo = itemvo:new(self.item:getType(), 1, self.item.id)
end

function m:showDrop()
    --    UIMrg:pushWindow("Prefabs/moduleFabs/packModule/newpackInfo", {obj = self.vo})
    --    if self.item:getType() == "item" then return end
    DialogMrg.showPieceDrop(self.item)
end

function m:Start()
    -- ClientTool.AddClick(self.btn,function()
    --     m:showDrop()
    -- end)
end

return m

