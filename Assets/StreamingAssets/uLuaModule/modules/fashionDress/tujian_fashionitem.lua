local m = {} 

function m:update(lua)
	self.delegate=lua.char.delegate
	self.char=lua.char
	self.pic:LoadByModelId(self.char.modelTable.id, "idle", function() end, false, 0, 1,255,1)
	if Player.fashion[self.char.id] ~=nil and Player.fashion[self.char.id].powerlvl >=1 then 
		self.Texture.Url=UrlManager.GetImagesPath("sl_public/tujiankuang_2.png")
		self.bg.Url=UrlManager.GetImagesPath("sl_public/tujiankuang_1.png")
		self.Lock:SetActive(false)
	else 
		self.Texture.Url=UrlManager.GetImagesPath("sl_public/tujiankuangweijihuo_2.png")
		self.bg.Url=UrlManager.GetImagesPath("sl_public/tujiankuangweijihuo_1.png")
		self.Lock:SetActive(true)
	end 
	self.name.text=self.char:getDisplayColorName()
	local skillIndex=1
	if self.char.modelTable.normal_skill ~=nil then 
		self["skill" .. skillIndex].gameObject:SetActive(true)
		self["skill" .. skillIndex].spriteName="jineng_pu"
		skillIndex=skillIndex+1
	end
	if self.char.modelTable.skill ~=nil and self.char.modelTable.skill[0] ~=nil then 
		self["skill" .. skillIndex].gameObject:SetActive(true)
		self["skill" .. skillIndex].spriteName="jineng_ji"
		skillIndex=skillIndex+1
	end
	if self.char.modelTable.xp_skill ~=nil  and self.char.modelTable.xp_skill[0] ~=nil  then
		self["skill" .. skillIndex].gameObject:SetActive(true)
		self["skill" .. skillIndex].spriteName="jineng_he"
		skillIndex=skillIndex+1
	end
	for i=skillIndex,3 do 
		self["skill" .. i].gameObject:SetActive(false)
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

function m:onClick(go, name)
	if name=="btn_hero" then 
		local char = self.char
		char.ishas=false
		if char:getType() == "fashion" then 
			local infobin = Tool.push("fashioninfo", "Prefabs/moduleFabs/fashionDress/fashionDress_info")
			infobin:CallUpdate(char)
		end
	end 
end

return m