local m = {} 

function m:Start()
	Tool.loadTopTitle(self.gameObject, TextMap.GetValue("Text_1_2968"))
	local iconName = TableReader:TableRowByUnique("resourceDefine", "name","lingyu").img
	self.pic_res1.Url=UrlManager.GetImagesPath("itemImage/"..iconName..".png")
	-- iconName = TableReader:TableRowByUnique("resourceDefine", "name","renlingzhi").img
	-- self.pic_res2.Url=UrlManager.GetImagesPath("itemImage/"..iconName..".png")
	-- iconName = TableReader:TableRowByUnique("resourceDefine", "name","duihuan").img
	-- self.pic_res3.Url=UrlManager.GetImagesPath("itemImage/"..iconName..".png")
	local name = TableReader:TableRowByUnique("resourceDefine", "name","lingyu").cnName
	self.name1.text=name .. "："
	-- name = TableReader:TableRowByUnique("resourceDefine", "name","renlingzhi").cnName
	-- self.name2.text=name .. "："
	-- name = TableReader:TableRowByUnique("resourceDefine", "name","duihuan").cnName
	-- self.name3.text=name .. "："
	m:onUpdate()
end

function m:onUpdate()
	LuaMain:ShowTopMenu(6,nil,{[1]={ type="lingyu"},[2]={ type="money"},[3]={ type="gold"}})
	local resNum = Tool.getCountByType("lingyu")
	self.num1.text=toolFun.moneyNumberShowOne(math.floor(tonumber(resNum)))
	-- resNum = Tool.getCountByType("renlingzhi")
	-- self.num2.text=toolFun.moneyNumberShowOne(math.floor(tonumber(resNum)))
	-- resNum = Tool.getCountByType("duihuan")
	--self.num3.text=toolFun.moneyNumberShowOne(math.floor(tonumber(resNum)))
	local chartNum_active =m:getChartNum()
	self.chartnum.text=TextMap.GetValue("Text_1_2967") .. chartNum_active
	self.chapterList = {}
	TableReader:ForEachLuaTable("renling_tujian", function(index, item) --shopPurchase
		table.insert(self.chapterList,item)
		return false
		end)
	table.sort(self.chapterList,function(a,b)
		return tonumber(a.group)< tonumber(b.group)
	end )
	self.scrollView:refresh(self.chapterList, self, false,0)
	self.binding:CallAfterTime(0.1,function()
        if #self.chapterList<=4 then 
			self.Content.transform.localPosition = Vector3(20,0, 0)
		else 
			self.Content.transform.localPosition = Vector3(0,0, 0)
		end 
    end)
    m:updateAttribute()
end 

function m:getChartNum()
	local num =0 
	TableReader:ForEachLuaTable("renling_tujian", function(index, _item)
		if Player.renling[_item.group]~=nil and Player.renling[_item.group].totolcnt~=nil then 
			num=num+tonumber(Player.renling[_item.group].totolcnt)
		end 
		return false
		end)
	return num
end

function m:updateAttribute()
	local propertys = Player.renling.propertys
	local magicList = {}
	TableReader:ForEachLuaTable("magics", function(index, item)
		if propertys[item.id]~=nil and propertys[item.id]>0 then 
			local tb =split(item.format, "{0}")
			local magicItem = {}
			magicItem.tb1=tb[1]
			magicItem.tb2=tb[2] or ""
			magicItem.denominator=item.denominator
			magicItem.arg=tonumber(propertys[item.id])
			table.insert(magicList,magicItem)
		end 
		return false
		end)
	for i=1,#magicList do
		if self["baselabel".. i]==nil then
			local go = NGUITools.AddChild(self.des.gameObject, self["baselabel".. ((i-1)%4+1)].gameObject)
			go.transform.localPosition = Vector3(self["baselabel".. ((i-1)%4+1)].transform.localPosition.x, -43.5-30*(math.floor((i-1)/4)), 0)
			self["baselabel".. i]=go:GetComponent(UILabel)
		end
		self["baselabel".. i].text="[F0E77B]" .. magicList[i].tb1 .. "[FFFFFF] " .. magicList[i].arg/tonumber(magicList[i].denominator or 1) .. magicList[i].tb2 .. "[-]"
	end
	for i=#magicList+1,4 do
		self["baselabel".. i].text=""
	end
	if #magicList>8 then 
		self.bg.hight=282+30*(math.ceil(#magicList/4)-2)
		self.hight=15*(math.ceil(#magicList/4)-2)+84
		self.more_btn.gameObject:SetActive(true)
	else
		self.more_btn.gameObject:SetActive(false)
	end 
end

function m:getChartNum()
	LuaMain:ShowTopMenu(6,nil,{[1]={ type="lingyu"},[2]={ type="money"},[3]={ type="gold"}})
	local num =0 
	TableReader:ForEachLuaTable("renling_tujian", function(index, _item)
		if Player.renling[_item.group]~=nil and Player.renling[_item.group].totolcnt~=nil then 
			num=num+tonumber(Player.renling[_item.group].totolcnt)
		end 
		return false
		end)
	return num
end

function m:onClick(go, name)
	if name == "achieve_btn" then
		UIMrg:pushWindow("Prefabs/moduleFabs/renlingModule/arrayChart_two")
	elseif name == "knapsack_btn" then 
		Tool.push("renling", "Prefabs/moduleFabs/renlingModule/newpack_renling")
	elseif name=="more_btn" then 
		if self.up==nil or self.up==false then 
			self.up=true
			self.bg.transform.localPosition=Vector3(0,self.hight,0)
		else 
			self.up=false
			self.bg.transform.localPosition=Vector3(0,84,0)
		end 
	end 
end 

function m:onEnter()
	m:onUpdate()
    LuaMain:ShowTopMenu(6,nil,{[1]={ type="lingyu"},[2]={ type="money"},[3]={ type="gold"}})
end

return m