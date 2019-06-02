local m = {} 

--初始化
function m:create(binding)
    self.binding = binding
    self.gameObject = self.binding.gameObject
    return self
end

function m:update(lua)
	self.delegate=lua.delegate
	self.selectChar=lua.selectChar
	self.playerChar=Char:new(Player.Info.playercharid)
	if self.selectChar~=nil and self.selectChar~=0 and self.selectChar:getType()~="fashion" then 
		self.selectChar=nil 
	end 
	self.selectIndex=0
	self.fashionList={}
	self.fashionList=self:GetAllfashion()
	self.scrollview:refresh(self.fashionList, self, false, 0)
	if self.selectIndex>4 then
		self.binding:CallAfterTime(0.1, function()
			self.scrollview:goToIndex(self.selectIndex)
			end)
	end 
	self:updateChar()
	self:updateProperty()
	self:updateSkill()
end

function m:onClick(go, name)
    if name == "skill1"  then 
		self.des2.gameObject:SetActive(false)
		self.des3.gameObject:SetActive(false)
    	self.des1.gameObject:SetActive(true)
	elseif name == "skill2" then 
		self.des1.gameObject:SetActive(false)
		self.des3.gameObject:SetActive(false)
		self.des2.gameObject:SetActive(true)
	elseif name == "skill3" then 
		self.des1.gameObject:SetActive(false)
		self.des2.gameObject:SetActive(false)
		self.des3.gameObject:SetActive(true)
	elseif name == "btn_close" then 
		self.des1.gameObject:SetActive(false)
		self.des2.gameObject:SetActive(false)
		self.des3.gameObject:SetActive(false)
	elseif name == "btn_hero" then 
		if self.fashionList==nil then return end
		if self.fashionList[self.selectIndex+1] ==nil then return end
		local char = self.fashionList[self.selectIndex+1]
		if char:getType() == "fashion" then 
			local infobin = Tool.push("fashioninfo", "Prefabs/moduleFabs/fashionDress/fashionDress_info")
			infobin:CallUpdate(char)
		end
	elseif name == "btn_left" then 
		self.scroll:Scroll(-1)
    elseif name == "btn_right" then 
        self.scroll:Scroll(1)
	elseif name == "btn_zhuangbei" then 
		self.des1.gameObject:SetActive(false)
		self.des2.gameObject:SetActive(false)
		self.des3.gameObject:SetActive(false)
		local char = self.fashionList[self.selectIndex+1]
		if char==nil then return end
		if char:getType() == "fashion" then 
			Api:equipOnFashion(char.id,function (result)
				self.playerChar:FashionChangeSkill()
				Events.Brocast('change_fashion')
				self:updateChar()
				self:updateProperty()
			end)
		else
			Api:equipDownFashion(function (result)
				self.playerChar:FashionChangeSkill()
				Events.Brocast('change_fashion')
				self:updateChar()
			end)
		end 
    end
end

function m:updateItem(index)
	if self.fashionList==nil then return end
	if self.fashionList[index+1] ==nil then return end
	local char = self.fashionList[index+1]
	if char.isHas==true then 
		self.selectIndex = index
		self:updateChar()
		self:updateProperty()
		self:updateSkill()
		self.delegate:updateItem(char)
	else 
		local temp = {}
		temp.obj = char
		temp._type = "fashion"
		MessageMrg.showTips(temp)
	end 
end

function m:GetAllfashion()
	local list = {}
	local dictid = Tool.getDictId(Player.Info.playercharid)
	local char=Char:new(nil,dictid)
	char.isHas=true
	char.realIndex = 0
	char.delegate=self
	table.insert(list,char)
	local hasList = {}
	local notHasList = {}
	TableReader:ForEachTable("fashion",
        function(index, item)
            if item ~= nil then
            	local _item ={}
            	_item=Fashion:new(item.id)
            	if Player.fashion[item.id] ~=nil and Player.fashion[item.id].powerlvl >=1 then 
            		_item.isHas=true
            		if Player.fashion.curEquipID>0 and Player.fashion.curEquipID==item.id then 
            			_item.realIndex=1
            			if self.selectChar ==nil or self.selectChar:getType()~="fashion" then 
            				self.selectIndex=1
            			end 
            			table.insert(list,_item)
            		else 
            			table.insert(hasList,_item)
            		end 
            	else 
            		_item.isHas=false
            		table.insert(notHasList,_item)
            	end 
            end
            return false
        end)
	table.sort( hasList, function (a,b)
		if a.star~=b.star then return a.star > b.star end 
		if a.lv ~=b.lv then return a.lv >b.lv end 
		return a.id <b.id 
		end)
	table.sort( notHasList, function (a,b)
		if a.star~=b.star then return a.star > b.star end 
		return a.id <b.id 
		end)
	local realIndex = #list
	for k,v in pairs(hasList) do
		if self.selectChar ~=nil and self.selectChar:getType()== "fashion" and self.selectChar.id ==v.id then 
			self.selectIndex=realIndex
		end 
		v.delegate=self
		v.realIndex=realIndex
		table.insert(list,v)
		realIndex=realIndex+1
	end

	for k,v in pairs(notHasList) do
		v.delegate=self
		v.realIndex=realIndex
		table.insert(list,v)
		realIndex=realIndex+1
	end
	return list
end

function m:updateChar()
	if self.fashionList==nil then return end
	if self.fashionList[self.selectIndex+1] ==nil then return end
	local char = self.fashionList[self.selectIndex+1]
	local model=0
	if self.selectIndex == 0 then 
		self.heroname.gameObject:SetActive(false)
	else 
		self.heroname.gameObject:SetActive(true)
		self.heroname.text=char:getDisplayColorName()
	end 
	self.btn_zhuangbei.gameObject:SetActive(false)
	if char.isHas==true  then 
		if Player.fashion.curEquipID>0 then
			if Player.fashion.curEquipID~=char.id then 
				self.btn_zhuangbei.gameObject:SetActive(true)
			end 
		else 
			if self.selectIndex>0 then 
				self.btn_zhuangbei.gameObject:SetActive(true)
			end 
		end
	end 
	self.hero:LoadByModelId(char.modelTable.id, "idle", function() end, false, 0, 1)
end

function m:updateSkill()
	if self.fashionList==nil then return end
	if self.fashionList[self.selectIndex+1] ==nil then return end
	local char = self.fashionList[self.selectIndex+1]
	local skillIndex=1
	self.skillList ={}
	if char.modelTable.normal_skill ~=nil then 
		local normal_skill=TableReader:TableRowByID("skill", tonumber(char.modelTable.normal_skill))
		if normal_skill ~=nil then 
			table.insert(self.skillList,normal_skill)
			self["skill" .. skillIndex].gameObject:SetActive(true)
			self["icon" .. skillIndex].Url=UrlManager.GetImagesPath("skillImage/" .. normal_skill.icon .. ".png")
			self["type" .. skillIndex].spriteName="jineng_pu"
			skillIndex=skillIndex+1
			self.des1.text=self.skillList[1].desc
		end
	end
	if char.modelTable.skill ~=nil and char.modelTable.skill[0] ~=nil then 
		local skill=TableReader:TableRowByID("skill", tonumber(char.modelTable.skill[0]))
		if skill ~=nil then 
			table.insert(self.skillList,skill)
			self["skill" .. skillIndex].gameObject:SetActive(true)
			self["icon" .. skillIndex].Url=UrlManager.GetImagesPath("skillImage/" .. skill.icon .. ".png")
			self["type" .. skillIndex].spriteName="jineng_ji"
			skillIndex=skillIndex+1
			self.des2.text=self.skillList[2].desc
		end
	end
	if char.modelTable.xp_skill ~=nil  and char.modelTable.xp_skill[0] ~=nil  then
		local xp_skill=TableReader:TableRowByID("skill",tonumber(char.modelTable.xp_skill[0]))
		if xp_skill ~=nil then 
			table.insert(self.skillList,xp_skill)
			self["skill" .. skillIndex].gameObject:SetActive(true)
			self["icon" .. skillIndex].Url=UrlManager.GetImagesPath("skillImage/" .. xp_skill.icon .. ".png")
			self["type" .. skillIndex].spriteName="jineng_he"
			skillIndex=skillIndex+1
			self.des3.gameObject:SetActive(false)
			self.des3.text=self.skillList[3].desc
		end
	end
	for i=skillIndex,3 do 
		self["skill" .. i].gameObject:SetActive(false)
	end 
end 

function m:updateProperty()
	if self.fashionList==nil then return end
	if self.fashionList[self.selectIndex+1] ==nil then return end
	local char = self.fashionList[self.selectIndex+1]
	self.PropertySprite:SetActive(false)
	if self.selectIndex == 0 then  return  end 
	if Player.fashion[char.id] ~=nil and Player.fashion[char.id].powerlvl~=nil then 
		self.PropertySprite:SetActive(true)
		local addexpmagic=char.Table.magic
		for i=1,addexpmagic.Count do
			local text="[F0E77B]" .. addexpmagic[i-1]._magic_effect.format .. "[-]"
			self["baselabel".. i].text=string.gsub(text,"{0}","[-] " .. addexpmagic[i-1].magic_arg1/tonumber(addexpmagic[i-1]._magic_effect.denominator or 1) ) 
		end
		for i=addexpmagic.Count+1,3 do 
			self["baselabel".. i].text =""
		end 
		if addexpmagic.Count<=2 then 
			self.base.transform.localPosition = Vector3(-170, 40, 0)
			self.qianghua.transform.localPosition = Vector3(-170, 0, 0)
		else 
			self.base.transform.localPosition = Vector3(-170, 59, 0)
			self.qianghua.transform.localPosition = Vector3(-170, -20, 0)
		end 
		local lv=Player.fashion[char.id].powerlvl
		if lv<1 then lv =1 end 
		if lv >300 then lv =300 end
		local row =TableReader:TableRowByUniqueKey("fashion_powerup", char.star-3, lv)
		if row ==nil then return end
		local _addexpmagic=row.magic 
		local index = 1 
		for i=1 ,_addexpmagic.Count do
			local text="[F0E77B]" .. _addexpmagic[i-1]._magic_effect.format .. "[-]"
			self["qianghuaLabel".. i].text=string.gsub(text,"{0}","[-] " .. _addexpmagic[i-1].magic_arg1/tonumber(_addexpmagic[i-1]._magic_effect.denominator or 1) ) 
		end 
	end 
end

return m