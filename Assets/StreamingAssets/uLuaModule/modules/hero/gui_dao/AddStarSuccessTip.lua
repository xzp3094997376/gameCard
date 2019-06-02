local m = {} 

function m:update(data)
	self.data = data
	self.equipIcon.Url = self.data._equipIconUrl
	self.Label_Pre_type.text = self.data._preType
	self.Value_add_pre.text = self.data._prevalue
	self.Label_Next_type.text = self.data._nextType 
	self.Value_add_next.text = tonumber(self.data._nextValue) + tonumber(self.data._prevalue)
	self.Pre_name.text = self.data._equipName
	self.Next_name.text = self.data._equipName
	m:SetStarInfo()
	for i = 1, 5 do
		self["Start_pre_check_"..i].gameObject:SetActive(false)
		self["Start_next_check_"..i].gameObject:SetActive(false)
		self["Start_"..i].gameObject:SetActive(false)
		self["Start_Next_"..i].gameObject:SetActive(false)
	end

	for i = 1, tonumber(self.equipMaxStar) do
		self["Start_"..i].gameObject:SetActive(true)
		self["Start_Next_"..i].gameObject:SetActive(true)
	end

	if data._currentStar - 1 > 0 then
		for i = 1, data._currentStar - 1 do
			self["Start_pre_check_"..i].gameObject:SetActive(true)
			self["Start_next_check_"..i].gameObject:SetActive(true)
			self["Start_"..i].gameObject:SetActive(true)
			self["Start_Next_"..i].gameObject:SetActive(true)
			if i == data._currentStar - 1 then
				self["Start_next_check_"..i + 1].gameObject:SetActive(true)
				self["Start_Next_"..i + 1].gameObject:SetActive(true)
			end
		end
	elseif data._currentStar - 1 == 0 then
			self["Start_next_check_"..1].gameObject:SetActive(true)
			self["Start_Next_"..1].gameObject:SetActive(true)
	end
end

function  m:SetStarInfo()
	self.equipMaxStar = 0
	for i = 1, 5 do
		if TableReader:TableRowByUniqueKey("ghostaddstar", self.data.id, i) ~= nil then
			self["Start_"..i].gameObject:SetActive(true)
			self.equipMaxStar = i
		end
	end
end

function m:ShowInfo()
	if self.data then

	end
end

function m:onClick(go, name)
	if name == "closeBtnAll" then
        UIMrg:popWindow()
    end
end

return m