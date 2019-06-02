local m = {} 

function m:update(lua_data)
	self.index = lua_data.index
	local treasure = lua_data.treasure
	self.delegate = lua_data.delegate
	self.frame:SetActive(treasure ~= nil)
	self.addEquip.gameObject:SetActive(treasure == nil)
	self.btn_close.gameObject:SetActive(treasure ~= nil)
	if self.labState ~= nil then
		self.labState.gameObject:SetActive(treasure == nil)
	end
	if treasure ~= nil then
		m:setIcon(treasure, self.icon)
		self.txt_name.text = treasure:getDisplayColorName()
		--self.frame.spriteName = treasure:getFrameNormal()
	else
		self.txt_name.text = ""
	end

end

function m:onClick(go,name)
	if name == "btn_center" then

	elseif name == "btn_cost" then
		self:ChooseItem()
	elseif name == "btn_close" then 
		self.delegate:removeTreasure(self.index)
	end
end

function m:ChooseItem()
   	self.delegate:WSelectExpCallBack()
end

function m:setIcon(item, icon)
    local name = item:getHeadSpriteName()
    local atlasName = packTool:getIconByName(name)
    icon:setImage(name, atlasName)
end

return m