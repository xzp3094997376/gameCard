local m = {} 

function m:update(item, index, myTable, delegate)
	self.item=item.char
	self.delegate=item.delegate
	self.name.text=self.item.show_name
	local renlingList = {}
	for i=0,self.item.consume.Count do
		if self.item.consume[i]~=nil then 
			local temp = RewardMrg.getDropItem({type=self.item.consume[i].consume_type,arg=self.item.consume[i].consume_arg,arg2=self.item.consume[i].consume_arg2})
			temp.delegate=self
			table.insert(renlingList,temp)
		end
	end 
	ClientTool.UpdateGrid("", self.Grid, renlingList)
	self.Grid.transform.localPosition = Vector3(-60*(#renlingList-1),15, 0)
	m:onUpdate()
end 

function m:onUpdate()
	local activeList = Player.renling
	local maxStar = TableReader:TableRowByID("renling_config",6).value2
	if activeList[self.item.group]==nil or activeList[self.item.group][self.item.id] == nil or tonumber(activeList[self.item.group][self.item.id].level) <1 then 
		self.stars.gameObject:SetActive(false)
		self.preview_btn.gameObject:SetActive(false)
		self.font.text=TextMap.GetValue("LocalKey_242") 
	else 
		self.stars.gameObject:SetActive(true)
		self.preview_btn.gameObject:SetActive(true)
		self.font.text=TextMap.GetValue("LocalKey_225")
		local starList = {}
		local starNum = activeList[self.item.group][self.item.id].level-1
		for i=1, starNum do
			local temp = {}
			temp.isShow=true
			table.insert(starList,temp)
		end
		for i=starNum+1, maxStar-1 do
			local temp = {}
			temp.isShow=false
			table.insert(starList,temp)
		end
		ClientTool.UpdateGrid("", self.stars, starList)
	end 
	local openLv = TableReader:TableRowByID("renling_config",5).value2
	self.button.gameObject:SetActive(true)
	if activeList[self.item.group]==nil or activeList[self.item.group][self.item.id] ==nil or tonumber(activeList[self.item.group][self.item.id].level) <1 then 
		if m:getCanActive(self.item.consume) then
			self.button.isEnabled=true
		else 
			self.button.isEnabled=false
		end
	elseif Player.Info.level>=tonumber(openLv) and tonumber(activeList[self.item.group][self.item.id].level)<tonumber(maxStar) then
		if m:getCanActive(self.item.consume) then
			self.button.isEnabled=true
		else 
			self.button.isEnabled=false
		end
	else
		self.button.gameObject:SetActive(false)
	end 
	local magicIndex = 1
	for i=0,self.item.magic.Count-1 do
		local row = self.item.magic[i]
		if row~=nil then 
			local tb =split(row._magic_effect.format, "{0}")
			local denominator=row._magic_effect.denominator or 1
			tb[2]=tb[2] or ""
			local star = 0
			local arg = row.magic_arg1
			if activeList[self.item.group]~=nil and activeList[self.item.group][self.item.id]~=nil and tonumber(activeList[self.item.group][self.item.id].level)>=1 then 
				star=tonumber(activeList[self.item.group][self.item.id].level)-1
				arg = row.magic_arg1+row.magic_arg2*star
			end 
			self["des" .. magicIndex].text="[ffff96]" .. tb[1] .. "[-][ffffff]" .. arg/denominator .. tb[2] .. "[-]"
			magicIndex=magicIndex+1
		end 
	end
	for i=magicIndex,4 do
		self["des" .. i].text=""
	end
end

function m:Start()
    Events.AddListener("update_gray", function()
        m:onUpdate()
        end)
end

function m:getScrollView()
	return self.delegate.view
end

function m:getCanActive(consume)
	local bag = Player.renlingBagIndex
	for i=0,consume.Count do
		if consume[i]~=nil then 
			if consume[i].consume_type == "renling" then
				local temp = bag[consume[i].consume_arg]
				if temp==nil then 
					return false
				else 
					if temp.count<tonumber(consume[i].consume_arg2) then 
						return false
					end 
				end  
			end 
		end
	end 
	return true
end

function m:onClick(go, name)
	if name == "preview_btn" then 
		UIMrg:pushWindow("Prefabs/moduleFabs/renlingModule/arrayChart_four",{self.item})
	elseif name=="button" then  
		local star=0
		if Player.renling[self.item.group]~=nil and Player.renling[self.item.group][self.item.id] ~=nil and tonumber(Player.renling[self.item.group][self.item.id].level) >=1 then 
			star=tonumber(Player.renling[self.item.group][self.item.id].level)
		end
		local msg = ""
		for i=0,self.item.magic.Count-1 do
			local row = self.item.magic[i]
			if row~=nil then 
				local tb =split(row._magic_effect.format, "{0}")
				local denominator=row._magic_effect.denominator or 1
				tb[2]=tb[2] or ""
				if star>=1 then 
					msg=msg .. "[ffff96]" .. tb[1] .. "[-][ffffff]" .. row.magic_arg2/denominator .. tb[2] .. "[-]"
				else 
					msg=msg .. "[ffff96]" .. tb[1] .. "[-][ffffff]" .. row.magic_arg1/denominator .. tb[2] .. "[-]"
				end 
				if i~=self.item.magic.Count-1 then
					msg=msg .. "\n" 
				end 
			end 
		end
		Api:tujianLevelUp(self.item.id,function (result)
			MessageMrg.showMove(msg)
			Events.Brocast('update_gray')
			packTool:showMsg(result, nil, 0)
		end)
	end 
end 

function m:create(binding)
    self.binding = binding
    return self
end

return m