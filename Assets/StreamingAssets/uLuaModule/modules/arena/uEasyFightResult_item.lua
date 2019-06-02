local m = {} 


function m:update(info)
	self.dropInfo = info.dropInfo
	self.times = info.times
	self.delegate = info.delegate
	self.isUse = info.isUse
	if self.isUse then
		self.isXH.gameObject:SetActive(true)
	else
		self.isXH.gameObject:SetActive(false)
	end


	self.itemList = {}

	for i = 1, 3 do
		self.itemList[i] = {}
		self.itemList[i].title = self["Label_Item_name"..i]
		self.itemList[i].ima = self["Sprite_Item"..i]
		self.itemList[i].value = self["Label_Value"..i]
		self.itemList[i].title.gameObject:SetActive(false)
	end

	if info.times > 0 then
		self.Label_times.text =string.gsub(TextMap.GetValue("LocalKey_777"),"{0}",self.times)
		self.Sprite_isWin.gameObject:SetActive(true)
		if info.isWin then
			self.Sprite_isWin.spriteName = "jingjichang_shengli"
		else 
			self.Sprite_isWin.spriteName = "jingjichang_shibai"
		end
	else
		self.Sprite_isWin.gameObject:SetActive(false)
		self.Label_times.text = TextMap.GetValue("Text_1_175")
		self.Sprite_backg.color = Color.yellow
		self.delegate:onFinishChl()
	end
	m:shwoItemInfo()
end

function m:shwoItemInfo()
	for i = 1, #self.dropInfo do
		if self.dropInfo[i] ~= nil then
			self.itemList[i].title.gameObject:SetActive(true)
			if self.dropInfo[i].name == TextMap.GetValue("Text_1_176") then
				self.itemList[i].title.text = TextMap.GetValue("Text_1_177")
			else
				self.itemList[i].title.text = TextMap.GetValue("Text_1_178")..self.dropInfo[i].name.."："
			end
			self.itemList[i].value.text = self.dropInfo[i].rwCount
			local iconName =self.dropInfo[i].Table.img
			if iconName==nil then 
				iconName =self.dropInfo[i].Table.iconid
			end 
			self.itemList[i].ima.Url = UrlManager.GetImagesPath("itemImage/" .. iconName .. ".png") 
		end
	end
end

return m