local m = {} 


function m:update()
	local guanshu = TextMap.GetValue("Text_1_952")
	local index = Player.PetChapter.currentChapter
	if index == 1 then guanshu = TextMap.GetValue("Text_1_952") end
	if index == 2 then guanshu = TextMap.GetValue("Text_1_953") end
	if index == 3 then guanshu = TextMap.GetValue("Text_1_954") end
	if index == 4 then guanshu = TextMap.GetValue("Text_1_955") end

	self.Label_name.text =string.gsub(TextMap.GetValue("LocalKey_778"),"{0}",guanshu)

	if Player.PetChapter[13].status == 1 then
		self.Area.gameObject:SetActive(true)
		self.Label_NotGet.gameObject:SetActive(false)
	else
		self.Area.gameObject:SetActive(false)
		self.Label_NotGet.gameObject:SetActive(true)
		self.Label_NotGet.text = TextMap.GetValue("Text_1_957")
	end

	local petPrize = TableReader:TableRowByID("petPrize", index)
	local petChapterArgs = TableReader:TableRowByID("petChapterArgs", 4)
	if Player.PetChapter.prizeTimes > 0 and Player.PetChapter.prizeTimes < 6 then
		local pettreasureCost = TableReader:TableRowByID("pettreasureCost", Player.PetChapter.prizeTimes)
		local iconName = Tool.getResIcon(pettreasureCost.return_consume[0].consume_type)
		self.Sprite_CostIcon.Url = UrlManager.GetImagesPath("itemImage/" .. iconName .. ".png")
		if pettreasureCost ~= nil then
			self.Label_CostValue.text = pettreasureCost.return_consume[0].consume_arg
			self.Label_kaiqi.text = TextMap.GetValue("Text_1_958")..6 - Player.PetChapter.prizeTimes ..TextMap.GetValue("Text_1_959")
		else
			self.Label_CostValue.text = 0
			self.Label_kaiqi.text = TextMap.GetValue("Text_1_960")
		end
	elseif Player.PetChapter.prizeTimes == 0 then
		self.Label_CostValue.text = TextMap.GetValue("Text_1_95")
		self.Label_kaiqi.text = TextMap.GetValue("Text_1_961")
	else
		self.Area.gameObject:SetActive(false)
		self.Label_NotGet.gameObject:SetActive(true)
		self.Label_NotGet.text = TextMap.GetValue("Text_1_962")
	end
	if self.listObj == nil then
		m:setDropItem()
	end
end

function m:setDropItem()
	self.listObj = {}

	local petPrize = TableReader:TableRowByID("petPrize", Player.PetChapter.currentChapter)

	self.curChapter = Player.PetChapter.currentChapter

	for i = 0, petPrize.probdrop.Count - 1 do
		self.listObj[i] = petPrize.probdrop[i]
	end

	self.ScrollView:refresh(self.listObj, self, true, 0)
end

function m:onClick(go, name)
	if name == "Btn_close" then
    	UIMrg:popWindow()
    elseif name == "open_Button" then
    	Api:getPrize(function(result)
        	packTool:showMsg(result, nil,2)
        	m:update()
    		Events.Brocast("RefreshPetGQInfo")
    	end)
	end
end

return m