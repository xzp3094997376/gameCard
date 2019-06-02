local m = {}


function m:update(info)
	self.data = info
	local char = RewardMrg.getDropItem({type=self.data.type,arg2=1,arg=self.data.arg})
	if self.inst_item == nil then
		self.inst_item = ClientTool.loadAndGetLuaBinding("Prefabs/publicPrefabs/itemAll", self.pic.gameObject)
	end
	self.inst_item:CallUpdate({ "char", char, self.pic.width, self.pic.height, true, nil, true })

	if self.data.arg2.Count > 1 then
        self.num.text = self.data.arg2[0] .. "~" ..  self.data.arg2[1]
    elseif self.data.arg2.Count == 1 then
        self.num.text= self.data.arg2[0]
    end

end

return m