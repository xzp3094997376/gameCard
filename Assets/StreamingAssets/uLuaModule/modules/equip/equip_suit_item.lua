local m = {}

function m:update(data)
	self.ghost = data
	if self._Item == nil then
        self._Item = ClientTool.loadAndGetLuaBindingFromPool("Prefabs/publicPrefabs/itemAll", self.item.gameObject)
    end
    self._Item:CallUpdate({ "char", self.ghost, self.item.width, self.item.height })
	self.txt_name.text = self.ghost:getDisplayColorName()
	self.eff:SetActive(self.ghost.hasWear ~= nil)
end

return m

