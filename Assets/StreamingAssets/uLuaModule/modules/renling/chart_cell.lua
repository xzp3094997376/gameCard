local m = {} 

function m:update(item, index, myTable, delegate)
	self.item=item
	item.img="zhengtu_" .. item.group
	self.pic.Url=UrlManager.GetImagesPath("sl_renling/".. item.img ..".png")
	self.name.text=item.name
	self.chapterName.text= string.gsub(TextMap.GetValue("LocalKey_667"),"{0}",item.group)
	self.Lock = m:getLock()
	if self.Lock then 
		self.lock:SetActive(false)
		self.Slider.gameObject:SetActive(true)
		self.des.text=""
		local num = 0 -- 灵阵图第item.group章的已激活数目
		local totalNum=0 
		if Player.renling[item.group]~=nil and Player.renling[item.group].totolcnt~=nil then 
			num=num+tonumber(Player.renling[item.group].totolcnt)
		end
		TableReader:ForEachLuaTable("renling_group", function(index, _item) --shopPurchase
			if tonumber(_item.group)== tonumber(item.group) then 
				totalNum=totalNum+1 
			end   
			return false
			end)
		self.num.text=num .. "/" .. totalNum
		self.Slider.value =num/totalNum
	else 
		self.lock:SetActive(true)
		self.Slider.gameObject:SetActive(false)
		self.des.text=string.gsub(item.desc_lock, '\\n', '\n')
	end 
	self.red:SetActive(Tool.getOneRenlingChapterRed(item.group))
end 

function m:getLock()
	for i=0,self.item.unlock.Count-1 do
		local type = self.item.unlock[i].unlock_condition
		if type=="level" then 
			if Player.Info.level<tonumber(self.item.unlock[i].unlock_arg) then 
				return false 
			end 
		elseif string.sub(type,0,5) == "group" then  
			local chapterNum =tonumber(string.sub(type,6,-1))
			local num = m:getChartNumByGroup(chapterNum) -- 灵阵图第chapterNum章的已激活数目
			if num< tonumber(self.item.unlock[i].unlock_arg) then 
				return false
			end 
		end 
	end
	return true
end

function m:getChartNumByGroup(group)
	local num =0 
	if Player.renling[group]~=nil and Player.renling[group].totolcnt~=nil then 
		num=num+tonumber(Player.renling[group].totolcnt)
	end
	return num
end

function m:onClick(go, name)
	if name == "pic_btn" then
		if self.Lock then 
			Tool.push("renling", "Prefabs/moduleFabs/renlingModule/arrayChart_three",{self.item})
		end 
	end 
end 

return m