local m = {} 

function m:update(item, index, myTable, delegate)
	self.item=item
	if self.__itemAll == nil then
		self.__itemAll = ClientTool.loadAndGetLuaBinding("Prefabs/publicPrefabs/itemAll", self.Sprite.gameObject)
	end
	self.__itemAll:CallUpdate({ "char", item, self.Sprite.width, self.Sprite.height, true, nil})
	self.Sprite.enabled = false
	self.__itemAll:CallTargetFunctionWithLuaTable("setDelegate", item.delegate)
end 

return m