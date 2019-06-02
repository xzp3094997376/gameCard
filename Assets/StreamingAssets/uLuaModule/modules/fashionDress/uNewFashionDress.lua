local fashionDress = {} 

function fashionDress:Start( ... )
	self.topMenu = LuaMain:ShowTopMenu(1, nil)
	Tool.loadTopTitle(self.gameObject, TextMap.GetValue("Text_1_40"))
end

function fashionDress:update(lua)
	if lua~=nil then 
		self.tp=lua.tp
	end 
	if self.tp ==nil or self.tp==0 then 
		self.tp=1 
	end 
	self.selectChar=nil
	local hasFashion=false
	TableReader:ForEachTable("fashion",
        function(index, item)
            if item ~= nil then
            	if Player.fashion[item.id] ~=nil and Player.fashion[item.id].powerlvl >=1 then 
            		hasFashion=true 
            		return true
            	end 
            end
            return false
        end)
	if hasFashion==true then 
		self.btn_lvup_gray.gameObject:SetActive(false)
		self.btn_chongzhu_gray.gameObject:SetActive(false)
	else 
		self.btn_lvup_gray.gameObject:SetActive(true)
		self.btn_chongzhu_gray.gameObject:SetActive(true)
	end 
	self:updateBtn()
	self:updatePageContent()
end

function fashionDress:onClick(go, name)
    if name == "btn_dress_down"  then 
		self.tp=1
		self:updateBtn()
		self:updatePageContent()
	elseif name == "btn_lvUp_down" then 
		self.tp=2
		self:updateBtn()
		self:updatePageContent()
	elseif name == "btn_chongzhu_down" then 
		self.tp=3
		self:updateBtn()
		self:updatePageContent()
	elseif name == "btn_tujian_down" then 
		self.tp=4
		self:updateBtn()
		self:updatePageContent()
	elseif name == "btnBack" then 
		UIMrg:pop()
    end
end

function fashionDress:updateBtn()
	local list = {}
	list[1] = self.img_dressup
	list[2] = self.imglvUpUp
	list[3] = self.imgchongzhuUp
	list[4] = self.imgtujianUp
	for i = 1, 4 do 
		if i == self.tp then list[i]:SetActive(true)
		else list[i]:SetActive(false) end
	end 
end

function fashionDress:updateItem(char)
	self.selectChar=char
end

function fashionDress:updatePageContent()
	if self.tp==1 then 
		self.fashionDress_skill.gameObject:SetActive(true)
		self.fashionDress_qianghua.gameObject:SetActive(false)
		self.fashionDress_chongzhu.gameObject:SetActive(false)
		self.fashionDress_tujian.gameObject:SetActive(false)
		self.fashionDress_skill:CallUpdate({selectChar=self.selectChar,delegate=self})
		self:updateBtn()
	elseif self.tp==2 then 
		self.fashionDress_skill.gameObject:SetActive(false)
		self.fashionDress_qianghua.gameObject:SetActive(true)
		self.fashionDress_chongzhu.gameObject:SetActive(false)
		self.fashionDress_tujian.gameObject:SetActive(false)
		self.fashionDress_qianghua:CallUpdate({selectChar=self.selectChar,delegate=self})
		self:updateBtn()
	elseif self.tp==3 then 
		self.fashionDress_skill.gameObject:SetActive(false)
		self.fashionDress_qianghua.gameObject:SetActive(false)
		self.fashionDress_chongzhu.gameObject:SetActive(true)
		self.fashionDress_tujian.gameObject:SetActive(false)
		self.fashionDress_chongzhu:CallUpdate({selectChar=self.selectChar,delegate=self})
		self:updateBtn()
	elseif self.tp==4 then 
		self.fashionDress_skill.gameObject:SetActive(false)
		self.fashionDress_qianghua.gameObject:SetActive(false)
		self.fashionDress_chongzhu.gameObject:SetActive(false)
		self.fashionDress_tujian.gameObject:SetActive(true)
		self.fashionDress_tujian:CallUpdate({delegate=self})
		self:updateBtn()
	end 
end

return fashionDress