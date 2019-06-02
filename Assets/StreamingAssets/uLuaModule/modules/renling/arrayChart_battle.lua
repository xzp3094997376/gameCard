local m = {} 

function m:Start()
	Tool.loadTopTitle(self.gameObject, TextMap.GetValue("Text_1_2980"))
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

	m:update()
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

function m:update()
	local resNum = Tool.getCountByType("lingyu")
	self.num1.text=toolFun.moneyNumberShowOne(math.floor(tonumber(resNum)))
	resNum = Tool.getCountByType("renlingzhi")
	self.num2.text=toolFun.moneyNumberShowOne(math.floor(tonumber(resNum)))
	resNum = Tool.getCountByType("duihuan")
	self.num3.text=toolFun.moneyNumberShowOne(math.floor(tonumber(resNum)))
	local chartNum_active =m:getChartNum()
	self.chartnum.text=TextMap.GetValue("Text_1_2967") .. chartNum_active
	local refresh_free = TableReader:TableRowByID("renling_config",3).value
	local refreshNum = Player.renling.refCount or 0
	if refreshNum<tonumber(refresh_free) then 
		self.cost.gameObject:SetActive(false)
		self.refreshNum.text=TextMap.GetValue("Text_1_2990") .. (tonumber(refresh_free)-refreshNum)
	else 
		self.cost.gameObject:SetActive(true)
		self.refreshNum.text=""
		local row = TableReader:TableRowByUniqueKey("resetChapter",1+refreshNum-tonumber(refresh_free),"renlingChapter")
		for i=0,row.consume.Count-1 do
			if row.consume[i]~=nil then 
				if row.consume[i].consume_type=="level" and row.consume[i].consume_arg>Player.Info.level then 
					self.cost.gameObject:SetActive(false)
				elseif row.consume[i].consume_type=="vip" and row.consume[i].consume_arg>Player.Info.vip then 
					self.cost.gameObject:SetActive(false)
				elseif Tool.typeId(row.consume[i].consume_type)==true then 
					local iconName = TableReader:TableRowByUnique("resourceDefine", "name",row.consume[i].consume_type).img
					self.cost.Url=UrlManager.GetImagesPath("itemImage/"..iconName..".png")
					self.costNum.text=row.consume[i].consume_arg
					self.refresh={}
					self.refresh.name=TableReader:TableRowByUnique("resourceDefine", "name",row.consume[i].consume_type).cnName
					self.refresh.type=row.consume[i].consume_type
					self.refresh.arg=row.consume[i].consume_arg
				end 
			end 
		end
	end
	local battle_free = TableReader:TableRowByID("resetChapter_show",5)["vip" .. Player.Info.vip] -- 每日免费试炼次数
	local battlenun=Player.renling.fightCount or 0
	self.battleNum.text=string.gsub(TextMap.GetValue("LocalKey_695"),"{0}",battle_free-battlenun)
	local chapterid = Player.renling.chapterId
	local chapterRow = TableReader:TableRowByID("renlingChapter",chapterid)
	if chapterRow == nil then return end 
	self.hero:LoadByModelId(chapterRow.model, "idle", function() end, false, 0, 1, 255, 1)
	self.txt_boss_name.text=Tool.getNameColor(chapterRow.star) .. chapterRow.show_name .. "[-]"
	local rewardList = RewardMrg.getProbdropByTable(chapterRow.probdrop)
	self.scrollview:refresh(rewardList, self, false,0)
end

function m:onClickRefresh()
	local refresh_free = TableReader:TableRowByID("renling_config",3).value
	local refreshNum = Player.renling.refCount or 0
	if refreshNum<tonumber(refresh_free) then 
		Api:refChapter(function ()
			m:update()
		end)
	else
		if tonumber(self.refresh.arg)<= Tool.getCountByType(self.refresh.type) then 
			Api:refChapter(function ()
				m:update()
			end)
		else 
			MessageMrg.show(TextMap.GetValue("Text_1_100"))
		end 
	end 
end

function m:onClick(go, name)
    if name == "battle_btn" then
    	local battle_free = TableReader:TableRowByID("resetChapter_show",5)["vip" .. Player.Info.vip] -- 每日免费试炼次数
    	local battlenun=Player.renling.fightCount or 0
    	if tonumber(battle_free)>battlenun then 
	    	Api:fightRenlingChapter(function (result)
	    		self:update()
	            local fightData = {}
	            fightData["battle"] = result
	            fightData["drop"] = result.drop
	            fightData["mdouleName"] = "renlingChapter"
	            UIMrg:pushObject(GameObject())
	            UluaModuleFuncs.Instance.uOtherFuns:callBackFight(fightData)
			end)
	    else 
	    	MessageMrg.show(TextMap.GetValue("Text_1_2988"))
	    end 
    elseif name == "refresh_btn" then
    	self:onClickRefresh()
    elseif name == "btn_shop" then
        uSuperLink.openModule(19)
    elseif name == "btn_pack" then
        Tool.push("renling", "Prefabs/moduleFabs/renlingModule/newpack_renling")
    elseif name == "Sprite_click" then
    	
    end 
end

function m:onEnter()
    LuaMain:ShowTopMenu(6,nil,{[1]={ type="lingyu"},[2]={ type="money"},[3]={ type="gold"}})
end

return m