local m = {} 

function m:Start()
	Tool.loadTopTitle(self.gameObject, TextMap.GetValue("Text_1_2965"))
	local iconName = TableReader:TableRowByUnique("resourceDefine", "name","lingyu").img
	self.pic_res1.Url=UrlManager.GetImagesPath("itemImage/"..iconName..".png")
	iconName = TableReader:TableRowByUnique("resourceDefine", "name","renlingzhi").img
	self.pic_res2.Url=UrlManager.GetImagesPath("itemImage/"..iconName..".png")
	iconName = TableReader:TableRowByUnique("resourceDefine", "name","duihuan").img
	self.pic_res3.Url=UrlManager.GetImagesPath("itemImage/"..iconName..".png")
	local name = TableReader:TableRowByUnique("resourceDefine", "name","lingyu").cnName
	self.name1.text=name .. "："
	name = TableReader:TableRowByUnique("resourceDefine", "name","renlingzhi").cnName
	self.name2.text=name .. "："
	name = TableReader:TableRowByUnique("resourceDefine", "name","duihuan").cnName
	self.name3.text=name .. "："
	m:onUpdate()
end

function m:onUpdate()
	LuaMain:ShowTopMenu(6,nil,{[1]={ type="lingyu"},[2]={ type="money"},[3]={ type="gold"}})
	local resNum = Tool.getCountByType("lingyu")
	self.num1.text=toolFun.moneyNumberShowOne(math.floor(tonumber(resNum)))
	resNum = Tool.getCountByType("renlingzhi")
	self.num2.text=toolFun.moneyNumberShowOne(math.floor(tonumber(resNum)))
	resNum = Tool.getCountByType("duihuan")
	self.num3.text=toolFun.moneyNumberShowOne(math.floor(tonumber(resNum)))
	local chartNum_active =m:getChartNum()
	self.chartnum.text=TextMap.GetValue("Text_1_2967") .. chartNum_active
	local battle_free = TableReader:TableRowByID("resetChapter_show",5)["vip" .. Player.Info.vip] -- 每日免费试炼次数
	local battlenun=Player.renling.fightCount or 0
	if tonumber(battle_free)>tonumber(battlenun) then 
		self.redPoint_battle:SetActive(true)
	else 
		self.redPoint_battle:SetActive(false)
	end 
	local freen_nun=Player.Times.renlingfreetime
	if freen_nun<=0 then 
		self.redPoint_summon:SetActive(false)
	else 
		self.redPoint_summon:SetActive(true)
	end
	self.redPoint_shop:SetActive(m:getNeedGoods())
	self.redPoint_chart:SetActive(m:getCanActiveChart()) 
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

function m:getNeedGoods()
	return false
end

function m:getCanActiveChart()
	return Tool.getAllRenlingChapterRed()
end

function m:onClick(go, name)
	print(name)
	if name == "battle_btn" then
		Tool.push("renling", "Prefabs/moduleFabs/renlingModule/arrayChart_battle")
	elseif name == "shop_btn" then 
		uSuperLink.openModule(19)
	elseif name == "summon_btn" then 
		Tool.push("renling", "Prefabs/moduleFabs/renlingModule/arrayChart_summon")
	elseif name == "chart_btn" then
		Tool.push("renling", "Prefabs/moduleFabs/renlingModule/arrayChart_one")
	end 
end 

function m:onEnter()
	m:onUpdate()
    LuaMain:ShowTopMenu(6,nil,{[1]={ type="lingyu"},[2]={ type="money"},[3]={ type="gold"}})
end

function m:create(binding)
    self.binding = binding
    return self
end

return m