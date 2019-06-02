local m = {} 

function m:update(lua)
	self.delegate=lua.delegate
	local id = lua.data
	self.pet = Pet:new(nil, id)
	self.txt_name.text = self.pet:getDisplayName()
	self.isOPen = lua.show
	if lua.show == 1 then 
		self.hero:LoadByModelId(self.pet.modelid, "idle", function() end, false, 100, 1)
		self.unOpen:SetActive(false)
	else 
		self.unOpen:SetActive(true)
	end
	local isOpen = m:checkActive(id)
	self.Lock:SetActive(not isOpen)
	if isOpen == true then
		self.img_bg.Url = UrlManager.GetImagesPath("sl_public/tujiankuang_2.png")
		self.kuang.Url = UrlManager.GetImagesPath("sl_public/tujiankuang_1.png")
	else
		self.img_bg.Url = UrlManager.GetImagesPath("sl_public/tujiankuangweijihuo_2.png")
		self.kuang.Url = UrlManager.GetImagesPath("sl_public/tujiankuangweijihuo_1.png")
	end 
end

function m:onClick(go, name)
	if name == "Detail_btn" then
		if self.isOPen == 1 then
			local info = {}
			info.obj = self.pet
			UIMrg:pushWindow("Prefabs/moduleFabs/hero/pet_info_dialog", info)
		end
	end
end

function m:onPress(go,name,bPress)
	if (self.delegate == nil or self.delegate.getScrollView == nil) then
		return
	end
    local sv = self.delegate:getScrollView()
	if sv ~= nil then
		sv:Press(bPress);
	end
end

function m:OnDrag(go,name,detal)
	if (self.delegate == nil or self.delegate.getScrollView == nil) then
		return
	end
	local sv = self.delegate:getScrollView()
	
	if sv ~= nil then
		sv:Drag();
	end
end

function m:checkActive(id)
	for i = 0, Player.Pets.petTujian.Count - 1 do 
		if id == Player.Pets.petTujian[i] then 
			return true
		end 
	end 
	return false
end

return m