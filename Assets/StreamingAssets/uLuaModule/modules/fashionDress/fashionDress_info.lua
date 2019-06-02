local m = {}

function m:Start( ... )
	self.topMenu = LuaMain:ShowTopMenu(1, nil)
	Tool.loadTopTitle(self.gameObject, TextMap.GetValue("Text_1_336"))
end

function m:update(char)
	self.char = char
    self:setFashion()
	self:onUpdate()
	self:fashionList()
	if char.ishas~=nil and char.ishas==false then 
		self.btn_left.gameObject:SetActive(false)
		self.btn_right.gameObject:SetActive(false)
		self.btn_strong.gameObject:SetActive(false)
	else 
		if self.index > self.minIndex then 
			self.btn_left.gameObject:SetActive(true)
		else 
			self.btn_left.gameObject:SetActive(false)
		end 
		if self.index < self.maxIndex then 
			self.btn_right.gameObject:SetActive(true)
		else 
			self.btn_right.gameObject:SetActive(false)
		end 
	end 
end


function m:updateSkill()
	self.skill:CallUpdate({char = self.char,type="skill"})
end


function m:onEnter()
	self:onUpdate()
end 

function m:onUpdate()
	self.char:updateInfo()
	self:updateDes()
	self:updatetianfuSkill()
	self:updateMiaoshu()
	self:updateSkill()
	self:updateTujian()
end 

function m:updateDes()
	local char = self.char
	if Player.fashion[char.id] ~=nil and Player.fashion[char.id].powerlvl~=nil then 
		local addexpmagic=char.Table.magic
		for i=1,addexpmagic.Count do
			local text="[F0E77B]" .. addexpmagic[i-1]._magic_effect.format .. "[-]"
			self["attr_Label".. i].text=string.gsub(text,"{0}","[-] " .. addexpmagic[i-1].magic_arg1/tonumber(addexpmagic[i-1]._magic_effect.denominator or 1)) 
		end
		for i=addexpmagic.Count+1,3 do 
			self["attr_Label".. i].text =""
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
			self["qianghua_Label".. i].text=string.gsub(text,"{0}","[-] " .. _addexpmagic[i-1].magic_arg1) 
		end 
		for i=_addexpmagic.Count+1,4 do 
			self["qianghua_Label".. i].text =""
		end 
		self.lv.text=TextMap.GetValue("Text_1_337") .. lv 
	end 
end 

function m:updatetianfuSkill()
	-- 天赋技能
	local that = self
	local tianfuList = {}
	local powerUp_skill= self.char.modelTable.fashion_powerUp_skill
	local lv=Player.fashion[self.char.id].powerlvl
	if lv<1 then lv =1 end 
	if lv >300 then lv =300 end
	local row =TableReader:TableRowByUniqueKey("fashion_powerup", self.char.star-3, lv)
	if row==nil then return end 
	local lock_skill=row.unlockskill
	for i = 0, powerUp_skill.Count-1 do 
		local skill =TableReader:TableRowByID("skill", powerUp_skill[i])
		if skill ~=nil then 
			local unlock = lock_skill[i]	
			local tianfuName = skill.name
			local ft = ""
			local ftdesc = ""
			if  unlock ~="" and unlock==i then 
				ft = "[ff0000]【" .. tianfuName .. "】[-]"
				ftdesc = "[ff0000]" .. skill.desc   .. " [-]" 
			else 
				ft = "[ffc864]【" .. tianfuName .. "】[-]"
				ftdesc = "[ffc864]" .. skill.desc   .. " [-]" 
			end 
			table.insert(tianfuList, {name = ft, desc = ftdesc}) 
		end
	end 
	self.tianfu:CallUpdate({ type = "other", list = tianfuList })
end


function m:updateTujian()
	local zuheId = tonumber(self.char.Table.suitid)
	local zuhe=TableReader:TableRowByID("fashion_suit",zuheId)
	if zuhe.fashions[0]>0 then 
		local item1=Fashion:new(zuhe.fashions[0])
		self.pic1.enabled = false
		if self._itemAll1 == nil then
			self._itemAll1 = ClientTool.loadAndGetLuaBindingFromPool("Prefabs/publicPrefabs/itemAll", self.pic1.gameObject)
		end
		self._itemAll1:CallUpdate({ "char", item1, self.pic1.width, self.pic1.height, true, nil, })
		self.fashionName1.text = item1:getDisplayColorName()
		self.zuheName.text=Tool.getNameColor(item1.star) .. zuhe.name  .. "[-]"
	end
	if zuhe.fashions[1]>0 then 
		local item2=Fashion:new(zuhe.fashions[1])
		self.pic2.enabled = false
		if self._itemAll2 == nil then
			self._itemAll2 = ClientTool.loadAndGetLuaBindingFromPool("Prefabs/publicPrefabs/itemAll", self.pic2.gameObject)
		end
		self._itemAll2:CallUpdate({ "char", item2, self.pic2.width, self.pic2.height, true, nil, })
		self.fashionName2.text = item2:getDisplayColorName()
	end
	local addexpmagic = zuhe.magic
	for i=1,addexpmagic.Count do
		print(i)
		local text="[F0E77B]" .. addexpmagic[i-1]._magic_effect.format .. "[-]"
		text=string.gsub(text,"{0}","：[-] " .. addexpmagic[i-1].magic_arg1/tonumber(addexpmagic[i-1]._magic_effect.denominator or 1) ) 
		self["tujian_Label".. i].text=text
	end
	for i=addexpmagic.Count+1,4 do
		self["tujian_Label".. i].text=""
	end
	if addexpmagic.Count<=2 then 
		self.img_bg1.height=225
	else 
		self.img_bg1.height=267
	end
end


function m:updateMiaoshu()
	self.txt_hero_desc.text=self.char.desc
	self.img_bg.height = self.txt_hero_desc.height+20
end 



function m:setFashion(char)
	self.hero:LoadByModelId(self.char.modelTable.id, "idle", function() end, false, 0, 1)
	self.txt_lv_name.text = self.char:getDisplayName()
	self.type.text=self.char:getItemQuality()
end


--刷新英雄列表
function m:fashionList()
   	local list = {}
	TableReader:ForEachTable("fashion",
        function(index, item)
            if item ~= nil then
            	local _item ={}
            	_item=Fashion:new(item.id)
            	if Player.fashion[item.id] ~=nil and Player.fashion[item.id].powerlvl >=1 then 
            		table.insert(list,_item)
            	end 
            end
            return false
        end)
	table.sort( list, function (a,b)
		if a.star~=b.star then return a.star > b.star end 
		if a.lv~=b.lv then return a.lv > b.lv end 
		return a.id <b.id 
		end)
	for i,v in ipairs(list) do
		if v.id ==self.char.id then 
			self.index=i
        end 
	end
	
	self.minIndex = 1
	self.maxIndex = #list
    self.allChars = list
end

function m:onClick(go, name)
	print (name)
    if name == "btnBack" then
        UIMrg:pop()
	elseif name == "btn_strong" then 
		UIMrg:pop()
		UIMrg:pop()
		Tool.push("fashion", "Prefabs/moduleFabs/fashionDress/newFashionDress",{tp=2})
	elseif name == "btn_left" then 
		self:onLeft()
	elseif name == "btn_right" then 
		self:onRight()
	end
end



function m:onLeft()
	if self.allChars == nil then 
		self:fashionList()
	end 
	print (self.index) 
	
	self.index = self.index - 1
	if self.index < self.minIndex then self.index = self.minIndex end 
	self:updateHero()
end 

function m:onRight()
	if self.allChars == nil then 
		self:fashionList()
	end
	self.index = self.index + 1
	if self.index > self.maxIndex then self.index = self.maxIndex end 
	self:updateHero()
end 

function m:updateHero()
	self:update(self.allChars[self.index])
end 

return m
