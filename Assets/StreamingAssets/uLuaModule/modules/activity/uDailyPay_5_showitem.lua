local m = {} 
local Item
function m:update( data )
	if Item == nil then
		infobinding = ClientTool.loadAndGetLuaBindingFromPool("Prefabs/publicPrefabs/itemAll", self.showGrid.gameObject)
	end

	local _data = data
	local _type = data.type
	self.frame.gameObject:SetActive(false)
    local char = RewardMrg.getDropItem(_data)
    infobinding:CallUpdate({ "char", char, self.frame.width, self.frame.height, true, nil, true })
end



return m