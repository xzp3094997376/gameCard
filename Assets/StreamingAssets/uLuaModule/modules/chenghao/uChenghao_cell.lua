local m = {}

function m:update(tables)
	if tables.onlySelIcon ~= nil and tables.onlySelIcon == true then
		self.open.gameObject:SetActive(false)
		self.unpen.gameObject:SetActive(false)
		local  curren = math.floor((Player.Info.ninjialvl) / 5) + 1 
		if self.tables.id > curren  then
			self.unpen.gameObject:SetActive(true)
		elseif self.tables.id <= curren  then
			self.open.gameObject:SetActive(true)
		end
		if	self.delegate:getCurrentIndex() == self.tables.id then
			self.select:SetActive(true)
		else
			self.select:SetActive(false)
		end
		return
	end
	self.tables = tables.tab
	self.delegate = tables.delegate
	if self.tables["name"] ~= nil then
		self.txt_name.text = self.tables["name"]
		self.txt_name_un.text = self.tables["name"]
	end

	if self.tables["icon"] ~= nil then
		self.open.spriteName = self.tables["icon"]
		self.unpen.spriteName = self.tables["icon"]
	end

	self.open.gameObject:SetActive(false)
	self.unpen.gameObject:SetActive(false)
	local  curren = math.floor((Player.Info.ninjialvl) / 5) + 1 
	if self.tables.id > curren  then
		self.unpen.gameObject:SetActive(true)
	elseif self.tables.id <= curren  then
		self.open.gameObject:SetActive(true)
	end

	if	self.delegate:getCurrentIndex() == self.tables.id then
		self.select:SetActive(true)
	else
		self.select:SetActive(false)
	end

end

function m:onClick(go, name)
	self.delegate:setCurrentIndex(self.tables.id)
end

return m
