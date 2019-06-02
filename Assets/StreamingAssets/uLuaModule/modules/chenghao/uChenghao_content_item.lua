local m = {}

function m:update(tables)
	self.tab = tables.tab
	self.delegate = tables.delegate
	self.index = tables.index
	self.i = tables.i
	if self.tab == nil then
		return
	end
	local myindex = (self.index - 1) * 5 + self.i
	if self.tab.tab["icon"] ~= nil then
		self.open.spriteName = self.tab.tab["icon"]
		self.unpen.spriteName = self.tab.tab["icon"]
	end
	local  curren = Player.Info.ninjialvl + 1
	if myindex> curren  then
		self.unpen.gameObject:SetActive(true)
		self.open.gameObject:SetActive(false)
	elseif myindex == curren  then
		self.open.gameObject:SetActive(true)
		self.select:SetActive(true)
	else
		self.select.gameObject:SetActive(false)
		self.open.gameObject:SetActive(true)
	end
	local mystarlvup = TableReader:TableRowByID("playerstarlvup", myindex)
	if mystarlvup ~= nil then
		self.txt_desc.text = mystarlvup.desc
	end

end

function m:onClick(go, name)
	self.desc:SetActive(true)
	if self.i < 5 then
		self.binding:CallAfterTime(2, function()
			self.desc:SetActive(false)
		end)
	end
end

return m
