local m = {} 

function m:update(lua)
	self.delegate=lua.delegate
	self.selectChar=lua.selectChar
	if self.selectChar~=nil and self.selectChar:getType()~="fashion" then 
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
end

function m:updateItem(index)
	self.selectIndex = index
	if self.fashionList==nil then return end
	if self.fashionList[self.selectIndex+1] ==nil then return end
	local char = self.fashionList[self.selectIndex+1]
	if char.isHas==true then 
		self:updateChar()
		self:updateProperty()
		self.delegate:updateItem(char)
	end 
end

function m:GetAllfashion()
	local list = {}
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
            			_item.realIndex=0
            			if self.selectChar ==nil or self.selectChar:getType()~="fashion" then 
            				self.selectIndex=0
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

function m:onClick(go, name)
    if name == "btn_strong" then 
		local char = self.fashionList[self.selectIndex+1]
		if char:getType() == "fashion" then 
			local lv=Player.fashion[char.id].powerlvl
			if lv<1 then lv =1 end 
			if lv >300 then lv =300 end
			local row =TableReader:TableRowByUniqueKey("fashion_powerup", char.star-3, lv+1)
			if row.playerlvl<=Player.Info.level then 
				self.btn_strong.isEnabled=false
				Api:powerUpFashion(char.id,function (result)
					self.effect:SetActive(true)
					self.binding:CallAfterTime(1, function()
						self.btn_strong.isEnabled=true
						Events.Brocast('change_fashion')
						self:updateProperty()
						end)
					self.binding:CallAfterTime(0.7, function()
						self.effect:SetActive(false)
						end)
					end,function()
					self.btn_strong.isEnabled=true
					return false
					end)
			else 
				MessageMrg.show(string.gsub(TextMap.GetValue("LocalKey_809"),"{0}",row.playerlvl))
			end 
		end 
	elseif name == "btn_left" then 
		self.scroll:Scroll(-1)
    elseif name == "btn_right" then 
        self.scroll:Scroll(1)
    elseif name == "btn_hero" then 
		if self.fashionList==nil then return end
		if self.fashionList[self.selectIndex+1] ==nil then return end
		local char = self.fashionList[self.selectIndex+1]
		if char:getType() == "fashion" then 
			local infobin = Tool.push("fashioninfo", "Prefabs/moduleFabs/fashionDress/fashionDress_info")
			infobin:CallUpdate(char)
		end
	elseif name =="btn_Look" then 
		local char = self.fashionList[self.selectIndex+1]
		if char:getType() == "fashion" then 
			UIMrg:pushWindow("Prefabs/moduleFabs/fashionDress/fashionDress_tianfu",char)
		end 
    end
end

function m:updateChar()
	if self.fashionList==nil then return end
	if self.fashionList[self.selectIndex+1] ==nil then return end
	local char = self.fashionList[self.selectIndex+1]
	self.heroname.text=char:getDisplayColorName() 
	self.hero:LoadByModelId(char.modelTable.id, "idle", function() end, false, 0, 1)
end

function m:updateProperty()
	if self.fashionList==nil then return end
	if self.fashionList[self.selectIndex+1] ==nil then return end
	local char = self.fashionList[self.selectIndex+1]
	if Player.fashion[char.id] ~=nil and Player.fashion[char.id].powerlvl~=nil then 
		local lv=Player.fashion[char.id].powerlvl
		if lv<1 then lv =1 end 
		if lv >300 then lv =300 end
		local row =TableReader:TableRowByUniqueKey("fashion_powerup", char.star-3, lv)
		local row_next =TableReader:TableRowByUniqueKey("fashion_powerup", char.star-3, lv+1)
		if row_next==nil then row_next=row end 
		if row ==nil then return end
		local _addexpmagic=row.magic 
		local next_magic=row_next.magic
		local index = 1 
		for i=1 ,_addexpmagic.Count do
			self["name".. i]="[F0E77B]" .. _addexpmagic[i-1]._magic_effect.format .. "：[-]"
			self["num_cur".. i].text=_addexpmagic[i-1].magic_arg1/tonumber(_addexpmagic[i-1]._magic_effect.denominator or 1) 
			self["num_next".. i].text=next_magic[i-1].magic_arg1/tonumber(next_magic[i-1]._magic_effect.denominator or 1) 
		end 
		self["name0"]=TextMap.GetValue("Text_1_339")
		self["num_cur0"].text=lv
		self["num_next0"].text=lv+1
		if lv>=300 then 
			self["num_next0"].text=300
		end 
		self.btn_strong.isEnabled=true
		local consume = row_next.consume 
		for i=0,consume.Count-1 do
			if consume[i].consume_type=="item" then 
				local item = uItem:new(consume[i].consume_arg) 
				if self.__itemAll == nil then
					self.itempic.enabled = false
					self.__itemAll = ClientTool.loadAndGetLuaBindingFromPool("Prefabs/publicPrefabs/itemAll", self.itempic.gameObject)
					self.__itemAll:CallUpdate({ "char", item, self.itempic.width, self.itempic.height, true, nil, }) 
					self.itemname.text =item:getDisplayColorName()
				end
				if item.count >= consume[i].consume_arg2 then 
					self.itemnum.text= "[FFFFFF]" .. item.count .."/" .. consume[i].consume_arg2 .. "[-]"
				else 
					self.btn_strong.isEnabled=false
					self.itemnum.text= "[FF0000]" .. item.count .."/" .. consume[i].consume_arg2 .. "[-]"
				end 	
			else 
				local iconName = Tool.getResIcon(consume[i].consume_type)
				self.costicon.Url=UrlManager.GetImagesPath("itemImage/" .. iconName.. ".png")
				if (Tool.getCountByType(consume[i].consume_type) < consume[i].consume_arg) then
					self.btn_strong.isEnabled=false
					self.costLabel.text="[FF0000]" .. consume[i].consume_arg .. "[-]"
				else 
					self.costLabel.text="[FFFFFF]" .. consume[i].consume_arg .. "[-]"
				end
			end
		end
		local unlockskill = row.unlockskill
		local lockSkillId = -1
		for i=0,unlockskill.Count-1 do
			if unlockskill[i]~="" and unlockskill[i]>lockSkillId then
				lockSkillId=unlockskill[i]
			end 
		end 
		if lockSkillId>5 then 
			lockSkillId=5
		end 
		local cur_skillId=char.modelTable.fashion_powerUp_skill[lockSkillId+1]
		local cur_skill= TableReader:TableRowByID("skill", tonumber(cur_skillId))
		self.des.text="【" .. cur_skill.show .. "】：[-] " .. cur_skill.desc
	end 
end

return m