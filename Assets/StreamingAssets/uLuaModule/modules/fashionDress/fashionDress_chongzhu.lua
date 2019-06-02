local m = {} 

function m:update(lua)
	self.delegate=lua.delegate
	self.selectChar=lua.selectChar
	self.effect:SetActive(false)
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
			if Player.fashion[char.id] ~=nil and Player.fashion[char.id].powerlvl~=nil then 
				local lv=Player.fashion[char.id].powerlvl
				if lv<1 then lv =1 end 
				if lv >300 then lv =300 end
				if Player.fashion.curEquipID>0 and Player.fashion.curEquipID==char.id then 
					MessageMrg.show(TextMap.GetValue("Text_1_330"))
				elseif lv<=1 then 
					MessageMrg.show(TextMap.GetValue("Text_1_331"))
				else  
					Api:reviewRebuildFashion(char.id,function (result)
						if result.drop ~=nil then 
							self.rewardList=self:getDrop(result.drop)
							self:reviewRebuildFashionPage()
						end 
						end)
				end
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
    end
end

function m:getDrop(info)
    local _list = {}
    if info.Count == 1 then
        local m = {}
        m.type = info[0].type
        m.arg = info[0].arg
        m.arg2 = info[0].arg2
        table.insert(_list, m)
        m = nil
    else
        for i = 0, info.Count - 1 do
            local m = {}
            m.type = info[i].type
            m.arg = info[i].arg
            m.arg2 = info[i].arg2
            table.insert(_list, m)
            m = nil
        end
    end
    return _list
end

function m:reviewRebuildFashionPage()
	if self.fashionList==nil then return end
	if self.fashionList[self.selectIndex+1] ==nil then return end
	local char = self.fashionList[self.selectIndex+1]
	local name=char:getDisplayColorName() 
	UIMrg:pushWindow("Prefabs/moduleFabs/recycleModule/gui_rewards_show", {
					title = TextMap.GetValue("Text_1_332"),
                    content = TextMap.GetValue("Text_1_333") .. name .. TextMap.GetValue("Text_1_334"),
                    content1="",
					delegate = self,
					consume=self.costLabel.text,
					callback = self.rebuildFashion,
					rewardList = self.rewardList
					})
	this = self
end

function m:rebuildFashion()
	if self.fashionList==nil then return end
	if self.fashionList[self.selectIndex+1] ==nil then return end
	local char = self.fashionList[self.selectIndex+1]
	self.btn_strong.isEnabled=false
	Api:rebuildFashion(char.id, function(result)
		MusicManager.playByID(42)
		self.effect:SetActive(true)
		self.binding:CallAfterTime(1, function()
			self.btn_strong.isEnabled=true
			self:updateProperty()
			self:showMsg(self.rewardList)
			Events.Brocast('change_fashion')  
			end)
		self.binding:CallAfterTime(1.7, function()
			self.effect:SetActive(false)
			end)
    end, function(...)
        self.btn_strong.isEnabled=true
        return false
    end)
end

function m:showMsg(drop)
    if drop == nil then return end
    local name = ""
    local goodsname = ""
    local num = 0
    local ms = {}
    local _type = 0
    for i, v in pairs(drop) do
        local item = RewardMrg.getDropItem(v)
        name = item.Table.iconid or item.Table.img
        num = item.rwCount or 0
        goodsname = Tool.getNameColor(item.star or item.color or 1) .. item.name .. "[-]"
        local g = {}
        g.type = _type
        g.icon = name
        g.text = num
        g.goodsname = goodsname
		g.goodsType = v.type
        table.insert(ms, g)
        g = nil
    end
	OperateAlert.getInstance:showGetGoods(ms, self.hero.gameObject)
end

function m:updateChar()
	if self.fashionList==nil then return end
	if self.fashionList[self.selectIndex+1] ==nil then return end
	local char = self.fashionList[self.selectIndex+1]
	self.heroname.text=char:getDisplayColorName() 
	self.hero:LoadByModelId(char.modelTable.id, "idle", function() end, false, 0, 1)
end

function m:updateProperty()
	self.effect1:SetActive(false)
	if self.fashionList==nil then return end
	if self.fashionList[self.selectIndex+1] ==nil then return end
	local char = self.fashionList[self.selectIndex+1]
	if Player.fashion[char.id] ~=nil and Player.fashion[char.id].powerlvl~=nil then 
		local lv=Player.fashion[char.id].powerlvl
		if lv<1 then lv =1 end 
		if lv >300 then lv =300 end
		self.lv.text=TextMap.GetValue("Text_1_335") .. lv
		local row =TableReader:TableRowByUniqueKey("fashion_powerup", char.star-3, lv)
		if row==nil then return end 
		local return_consume=row.return_consume
		local iconName = Tool.getResIcon(return_consume[0].consume_type)
		self.costicon.Url=UrlManager.GetImagesPath("itemImage/" .. iconName.. ".png")
		if (Tool.getCountByType(return_consume[0].consume_type) < return_consume[0].consume_arg) then
			self.btn_strong.isEnabled=false
			self.costLabel.text="[FF0000]" .. return_consume[0].consume_arg .. "[-]"
		else 
			self.costLabel.text="[FFFFFF]" .. return_consume[0].consume_arg .. "[-]"
		end
		if return_consume[0].consume_type=="gold" then 
			self.effect1:SetActive(true)
		end 
	end 
end

return m