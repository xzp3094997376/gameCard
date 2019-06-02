local m = {} 

function m:update(item, index, myTable, delegate)
	self.item=item
	if self.__itemAll == nil then
		self.__itemAll = ClientTool.loadAndGetLuaBinding("Prefabs/publicPrefabs/itemAll", self.pic.gameObject)
	end
	local bag = Player.renlingBagIndex
	if bag[item.id]==nil or bag[item.id].count<tonumber(item.rwCount) then 
		self.__itemAll:CallUpdate({ "char", item, self.pic.width, self.pic.height, true, nil,isGray=true})
	else 
		self.__itemAll:CallUpdate({ "char", item, self.pic.width, self.pic.height, true, nil,isGray=false})
	end 
	self.pic.enabled = false
	self.name.text=item:getDisplayColorName()
	self.__itemAll:CallTargetFunctionWithLuaTable("setDelegate", item.delegate)
end 

function m:Start()
    Events.AddListener("update_gray", function()
        local bag = Player.renlingBagIndex
		if bag[self.item.id]==nil or bag[self.item.id].count<tonumber(self.item.rwCount) then 
			self.__itemAll:CallTargetFunction("isShowGray",true)
		else 
			self.__itemAll:CallTargetFunction("isShowGray",false)
		end 
        end)
end

function m:OnDestroy()
    Events.RemoveListener('update_gray')
end

return m