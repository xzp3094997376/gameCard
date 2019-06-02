local m = {} 

function m:update(lua)
	self.delegate=lua.char.delegate
	self.char=lua.char
	print(lua.can_show)
	local ishave = m:checkActive(self.char.id) 
	if ishave then 
		self.Texture.Url=UrlManager.GetImagesPath("sl_public/tujiankuang_2.png")
		self.bg.Url=UrlManager.GetImagesPath("sl_public/tujiankuang_1.png")
		self.Lock:SetActive(false)
		self.have:SetActive(true)
		local iconName = TableReader:TableRowByUnique("resourceDefine", "name","haogandu").img
		self.img.Url=UrlManager.GetImagesPath("itemImage/"..iconName..".png")
		local lv =0
		self.lv.text=string.gsub(TextMap.GetValue("LocalKey_812"),"{0}",lv)
		local star = 0
		local maxStar = TableReader:TableRowByID("yulingArgs","max_yuling_starup").value
		local starList = {}
		for i=1, star do
			local temp = {}
			temp.isShow=true
			table.insert(starList,temp)
		end
		for i=star+1, tonumber(maxStar) do
			local temp = {}
			temp.isShow=false
			table.insert(starList,temp)
		end
		ClientTool.UpdateGrid("", self.stars, starList)
	else 
		self.Texture.Url=UrlManager.GetImagesPath("sl_public/tujiankuangweijihuo_2.png")
		self.bg.Url=UrlManager.GetImagesPath("sl_public/tujiankuangweijihuo_1.png")
		self.Lock:SetActive(true)
		self.have:SetActive(false)
	end 
	self.name.text=self.char:getDisplayColorName()
	if lua.can_show==0 then 
		self.unOpen:SetActive(true)
		self.pic.gameObject:SetActive(false)
	else 
		self.unOpen:SetActive(false)
		self.pic.gameObject:SetActive(true)
		self.pic:LoadByModelId(self.char.modelTable.id, "idle", function() end, false, 100, 1,255,1)
	end 
end

function m:checkActive(id)
	for i = 0, Player.yuling.yulingTujian.Count - 1 do 
		if id == Player.yuling.yulingTujian[i] then 
			return true
		end 
	end 
	return false
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

function m:onClick(go, name)
	if name=="btn_hero" then 
		local char = self.char
		if char:getType() == "yuling" then 
			local temp = {}
		    temp.obj = char
		    temp._type = "yuling"
			temp.type = 1 
			UIMrg:pushWindow("Prefabs/moduleFabs/yuling/yuling_info_dialog", temp)
		end
	end 
end

return m