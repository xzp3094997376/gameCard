local m = {} 

function m:update(data,index,delegate)
	self.data = data 
	self.delegate=delegate
	if self.data.chapter_type == "exchange" then 
		m:UpdateExchangeContent()
	else 
		m:UpdateTaskContent()
	end 
end

function m:UpdateExchangeContent()
	self.limitedChange:SetActive(true)
	self.taskType:SetActive(false)
	self.Text_Title.text = self.data.itemName
	if self.data.discount==nil or self.data.discount=="" or tonumber(self.data.discount)==10 then 
		self.Sprite_dis:SetActive(false)
	else 
		self.Sprite_dis:SetActive(true)
		self.Text_dis.text=string.gsub(TextMap.GetValue("LocalKey_789"),"{0}",self.data.discount)
	end 
	if self.data.act_packageArr ~=nil then 
		local _item = {}
		_item=RewardMrg.getDropItem(self.data.act_packageArr[1])
		self.dropItem=_item
		if self._itemAll == nil then
	        self._itemAll = ClientTool.loadAndGetLuaBindingFromPool("Prefabs/publicPrefabs/itemAll", self.Target_Sprite.gameObject)
	    end
	    self._itemAll:CallUpdate({"char", _item, self.Target_Sprite.width, self.Target_Sprite.height, true, nil}) 	        
	end
	local winCount=self.data.status.winCount or 0 
	local times = self.data.win_times-winCount
	if times<0 then 
		times=0
	end 
	self.Cost_num.text=string.gsub(TextMap.GetValue("LocalKey_780"),"{0}",times)
	self.canbuyNum=tonumber(times)
	if self.data.specialArr ~= nil then 
		local list = {}
		for i,v in ipairs(self.data.specialArr) do
			if v.consume_type ~=nil and v.consume_arg~=nil then
				local cell = {}
				cell.type=v.consume_type
				cell.arg=v.consume_arg
				cell.arg2=v.consume_arg2 
    			if v.consume_type == "char" then
                    local vo = Char:new(v.consume_arg)
                    vo.item=cell
                    vo.rwCount = v.consume_arg2
                    vo.__tp = "char"
                    table.insert(list, vo)
                else
                    local vo = itemvo:new(v.consume_type, v.consume_arg2, v.consume_arg)
                    local max = Tool.getCountByType(v.consume_type, v.consume_arg)
                    local num = v.consume_arg
                    if Tool.typeId(v.consume_type)==false then num = v.consume_arg2 end
                    if max < tonumber(num) then
                        vo.__numColor = "[ff0000]"
                    else
                        vo.__numColor = nil
                    end
                    vo.item=cell
                    vo.__tp = "vo"
                    table.insert(list, vo)
                end
    		end 
		end
		self.Grid:refresh("Prefabs/moduleFabs/activityModule/itemActivity", list,self)
		self.consumeList=list
	end 
	local selectIndex=self.data.delegate.selectIndex
	local _list = self.data.delegate.list[self.data.delegate.selectIndex]
	local data_delegate = self.data.delegate.data.data["" .. _list.id]
	local y = os.date('%Y', tonumber(Player.Info.create)/1000)
    local m = os.date('%m', tonumber(Player.Info.create)/1000)
    local d = os.date('%d', tonumber(Player.Info.create)/1000)
    local time = os.time({day=d, month=m, year=y, hour=0, minute=0, second=0}) *1000 
    local stage_startTime= data_delegate.stage_startTime
    local stage_endTime= data_delegate.stage_endTime
	if tonumber(data_delegate.stage_startTime) <1000 then 
        stage_startTime=time +tonumber(data_delegate.stage_startTime)*24*60*60*1000
    end
    if tonumber(data_delegate.stage_endTime) <1000 then 
        stage_endTime=time +tonumber(data_delegate.stage_endTime)*24*60*60*1000
    end
	if data_delegate.stage_startTime~=nil and tonumber(stage_startTime) / 1000 > os.time() then 
		self.btn_Get.gameObject:SetActive(false)
		self.Sprite_Guoqi_ex:SetActive(false)
	elseif data_delegate.stage_endTime~=nil and tonumber(stage_endTime) / 1000 < os.time() then 
		self.btn_Get.gameObject:SetActive(false)
		self.Sprite_Guoqi_ex:SetActive(true)
	else 
		self.btn_Get.gameObject:SetActive(true)
		self.Sprite_Guoqi_ex:SetActive(false)
	end 
end

function m:UpdateTaskContent()                 
	self.limitedChange:SetActive(false)
	self.taskType:SetActive(true)   
	local totalItem = 0                                                               
	self.Text_Title_task.text = self.data.itemName
	if self.data.selectPackageArr ~= nil and self.data.selectIcon ~= nil then
		self.ids=0
        self.RandomItem:SetActive(true)
		--local bg_icon = "itemImage" .. self.data.selectIcon .. ".png"
		local bg_icon = "itemImage/item_cheng.png"
    	self.icoTex.Url = UrlManager.GetImagesPath(bg_icon)  
    	self.grid_task.transform.localPosition = Vector3(118,0,0)
    	totalItem=totalItem+1
    else
    	self.RandomItem:SetActive(false)
        self.grid_task.transform.localPosition = Vector3(10,0,0)
	end
	if self.data.act_packageArr ~= nil then 
		local list = {}
		for i,v in ipairs(self.data.act_packageArr) do
			if v.type ~=nil and v.arg~=nil then 
				totalItem=totalItem+1
    			local item = RewardMrg.getDropItem(v)
    			table.insert(list, v)
    		end 
		end
		self.grid_task:refresh("Prefabs/moduleFabs/activityModule/itemActivity", list,self) 
	end 
	if totalItem>3 then 
		self.Drag_task:SetActive(true)
	else 
		self.Drag_task:SetActive(false)
	end 
	local winCount=self.data.status.winCount or 0 
	if tonumber(winCount)>tonumber(self.data.win_times) then 
		winCount=self.data.win_times
	end 
	self.Text_Requit.text="（" .. winCount .. "/" .. self.data.win_times .."）"
	local btn_list = {}
	table.insert(btn_list,self.btn_Get_task.gameObject)
	table.insert(btn_list,self.btn_Chongzhi.gameObject)
	table.insert(btn_list,self.Sprite_Goto.gameObject)
	table.insert(btn_list,self.Sprite_hasGet.gameObject)
	table.insert(btn_list,self.Sprite_Guoqi.gameObject)
	local tap = 0
	local status = self.data.status.drop or 0 
	local selectIndex=self.data.delegate.selectIndex
	local _list = self.data.delegate.list[self.data.delegate.selectIndex]
	local data_delegate = self.data.delegate.data.data["" .. _list.id]
	local y = os.date('%Y', tonumber(Player.Info.create)/1000)
    local m = os.date('%m', tonumber(Player.Info.create)/1000)
    local d = os.date('%d', tonumber(Player.Info.create)/1000)
    local time = os.time({day=d, month=m, year=y, hour=0, minute=0, second=0}) *1000 
    local stage_startTime= data_delegate.stage_startTime
    local stage_endTime= data_delegate.stage_endTime
	if tonumber(data_delegate.stage_startTime) <1000 then 
        stage_startTime=time +tonumber(data_delegate.stage_startTime)*24*60*60*1000
    end
    if tonumber(data_delegate.stage_endTime) <1000 then 
        stage_endTime=time +tonumber(data_delegate.stage_endTime)*24*60*60*1000
    end 
	if status == 1 then 
		tap=1
	elseif data_delegate.stage_startTime~=nil and tonumber(stage_startTime) / 1000 > os.time() then 
		tap =0
	elseif data_delegate.stage_endTime~=nil and tonumber(stage_endTime) / 1000 < os.time() then
		tap=5
	elseif self.data.chapter_type=="danchong" and status==0 then 
		tap=2
	elseif status==2 then 
		tap=4
	elseif status==3 then 
		tap=2
	else 
		local link_id=self.data.status.link_id
		if link_id~=nil then 
			tap=3
		else 
			tap=0
		end 
	end
	for i,v in ipairs(btn_list) do
	  	if i== tap then 
	  		v:SetActive(true)
	  	else 
	  		v:SetActive(false)
	  	end 
	end  
end

function m:ReViewReward()
	local temp = {}
    temp.title = TextMap.GetValue("Text_1_23")
    temp.onOk = function()
        UIMrg:popWindow()
    end
    temp.type = "showInfo"
    temp.tip = TextMap.GetValue("Text_1_24")
    temp.state =  true
    local drop =  self.data.selectPackageArr
    drop.number = nil
    temp.drop = drop
    temp.bt_name = TextMap.GetValue("Text_1_25")

    UIMrg:pushWindow("Prefabs/moduleFabs/chapterModule/chapterbox", temp)
end

function m:onClick(go,name)
	print(name)
	if name == "btn_icon" then
		m:ReViewReward()
	elseif name =="btn_Chongzhi" then
		m:OnChongzhi()
	elseif name =="btn_Get_task" then
		if self.data.selectPackageArr ~= nil and self.data.selectIcon ~= nil then
			m:ShowCanChooseItemsPage()
		else 
			m:onClickGet()
		end 
	elseif name =="btn_Get" then 
		if self.data.selectPackageArr ~= nil and self.data.selectIcon ~= nil then
			m:ShowCanChooseItemsPage()
		else 
			m:OnClickExchange()
		end 
	elseif name =="Sprite_Goto" then 
		local link_id=self.data.status.link_id or 0 
		UIMrg:pop()
		uSuperLink.openModule(link_id)
	end
end

function m:SelectMeCb(ids)
	self.ids=ids
	if self.data.chapter_type=="exchange" then 
		m:OnClickExchange()
	else 
		m:onClickGet()
	end 
end

function m:ShowCanChooseItemsPage()
	UIMrg:pushWindow("Prefabs/moduleFabs/activityModule/act_choose_reward", {data=self.data.selectPackageArr,delegate=self})
end

function m:OnClickExchange()
	local winCount=self.data.status.winCount or 0 
	local times = self.data.win_times-winCount
	if times<0 then 
		times=0
	end
	if self.data.specialArr ~= nil then 
		local list = {}
		for i,v in ipairs(self.data.specialArr) do
			if v.consume_type ~=nil and v.consume_arg~=nil then
				local cell = {}
				cell.type=v.consume_type
				cell.arg=v.consume_arg
				cell.arg2=v.consume_arg2 
				m:getCanbuyNum(cell)
    		end 
		end
	end 
	if self.canbuyNum > 1 then
		local gid = self.data.delegate.selectIndex .. "_" .. self.delegate.data.index .. "_" .. self.data.index
		if self.data.selectPackageArr ~= nil and self.data.selectIcon ~= nil then
			gid= gid .. "_" .. self.ids
		else 
			gid= gid .. "_ "
		end 
		self.data.delegate:exchange_two({self.data.act_packageArr[1], self.canbuyNum, self.consumeList,gid})
	elseif self.canbuyNum == 1 then
		local gid = self.data.delegate.selectIndex .. "_" .. self.delegate.data.index .. "_" .. self.data.index
		if self.data.selectPackageArr ~= nil and self.data.selectIcon ~= nil then
			gid= gid .. "_" .. self.ids
		else 
			gid= gid .. "_ "
		end 
		gid= gid .. "_1"
		Api:getActGift(self.data.delegate.data.id, gid, function(result)
	        if result.drop ~= nil then
	            packTool:showMsg(result, nil, 1)
	        end
	        self.data.delegate:refreshActivityData()
	        end)
	elseif times== 0 then
		MessageMrg.show(TextMap.GetValue("Text_1_94"))
	elseif self.canbuyNum == 0 then
		MessageMrg.show(TextMap.GetValue("Text_1_93"))
	end
end

function m:OnChongzhi()
    if self.data ~= nil then
    	self.chongzhi_item = TableReader:TableRowByID("shopPurchase", tonumber(self.data.special))
    end 
    if self.chongzhi_item~=nil then 
        if self.btn_Chongzhi~=nil then 
            self.btn_Chongzhi.isEnabled=false
        end 
        self.data.delegate:refreshDataWhenVip()
        local playerId = Player.playerId
        local rtype = self.chongzhi_item.rtype
        local serverId = PlayerPrefs.GetString("serverId") or NowSelectedServer
        local info = playerId .. "|" .. serverId .. "|" .. rtype .. "|" .. os.time()
        local rate = TableReader:TableRowByID("charge_settings","charge_rate").value
		local money = self.chongzhi_item.cost *100
		local gid = self.data.delegate.selectIndex .. "_" .. self.delegate.data.index .. "_" .. self.data.index
        if (ClientTool.Platform == "android" or ClientTool.Platform == "ios") and isSdk== 1 then
            Api:getPayUrl(GlobalVar.sdkPlatform, rtype, info, self.chongzhi_item.cost, self.data.delegate.data.id, gid ,function(res)
            local count = self.chongzhi_item.cost *tonumber(rate)
			--add by lihui UC6.1.0支付必须要的参数 2017-1-3 19:00
			local accountId = "0"
            local url = ""
			local sign =""
			print("serali OnChongzhi="..tostring(ClientTool.Platform)..",sdkPlatform="..GlobalVar.sdkPlatform)
			if ClientTool.Platform == "ios" then
				print("serali iospay2="..tostring(res.ios))
				if res.ios ~= nil then						
					accountId = res.ios							
				else
					accountId = "1"
				end
			--elseif ClientTool.Platform == "android" and GlobalVar.sdkPlatform == "gump" then
			--	print("serali andpay2="..tostring(res.ios))
			--	if res.ios ~= nil then						
			--		accountId = res.ios							
			--	else
			--		accountId = "1"
			--	end	
			else
				if res.accountId ~= nil then
                    accountId = res.accountId
                end
			end	
			print("serali iospay4="..tostring(accountId))
			if res.url ~= nil then
				url = res.url
			end
			if res.sign ~= nil then
				sign = res.sign
			end
				if ClientTool.Platform == "ios" and GlobalVar.sdkPlatform == "gump" and accountId == 0 then
					local payInfo = {}
	                table.insert(payInfo, money)
	                table.insert(payInfo, self.chongzhi_item.id)
	                table.insert(payInfo, self.chongzhi_item.name)
	                table.insert(payInfo, count)
	                table.insert(payInfo, info)
	                table.insert(payInfo, url)
	                table.insert(payInfo, accountId)
	                table.insert(payInfo, sign)
	                UIMrg:pushWindow("Prefabs/moduleFabs/publicModule/ChoisePayType",{
	                                    info = payInfo, delegate = self})

	            else
		            mysdk:pay(money, self.chongzhi_item.id,self.chongzhi_item.name, count, info, url, accountId, sign, "1", function(result)
		                OperateAlert.getInstance:showToGameObject({ TextMap.GetValue("Text1462") }, self.btn_Chongzhi.gameObject)
		                end, function()
		                if self.btn_Chongzhi~=nil then 
		                    self.btn_Chongzhi.isEnabled=true
		                end 
		                end)
		        end
            end)
        else
            Api:innerPay(Player.playerId, self.chongzhi_item.cost, self.chongzhi_item.rtype,info, self.data.delegate.data.id, gid, function(result)
                if result ~= nil and result.ret == 0 then
                    OperateAlert.getInstance:showToGameObject({ TextMap.GetValue("Text1462") }, self.btn_Chongzhi.gameObject)
                else
                    if self.btn_Chongzhi~=nil then 
                        self.btn_Chongzhi.isEnabled=true
                    end 
                end
                end)
        end
    else
        DialogMrg.chognzhi()
    end 
end

function m:returnPay()
	if self.btn_Chongzhi~=nil then 
	    self.btn_Chongzhi.isEnabled=true 
	end 
end

function m:onClickGet()
	local gid = self.data.delegate.selectIndex .. "_" .. self.delegate.data.index .. "_" .. self.data.index
	if self.data.selectPackageArr ~= nil and self.data.selectIcon ~= nil then
		gid= gid .. "_" .. self.ids
	end 
	Api:getActGift(self.data.delegate.data.id, gid, function(result)
        if result.drop ~= nil then
            packTool:showMsg(result, nil, 1)
        end
        self.data.delegate:refreshActivityData()
        end)
end

function m:getCanbuyNum(cell)
	local canbuyNum=0
    local _Count = 0
    local type = cell.type
    if type == "char" then
        local chars = Player.Chars:getLuaTable() --获取所有英雄
        --遍历所有角色
        for k, v in pairs(chars) do
            local char = Char:new(k, v)
            local blood = 0
            local bloodline = Player.Chars[char.id].bloodline
            if bloodline ~= nil then
                blood= bloodline.level
            end
            if char.info.exp==0 and blood==0 and char:getTeamIndex() == 7 and self:checkFriend(char) == false and self:onAgency(char)==false then --是初始状态并且未上阵
                if tonumber(char.dictid)==tonumber(cell.arg) then 
                    _Count=_Count+1
                end  
            end 
        end
    elseif type == "charPiece" then
        local item = CharPiece:new(cell.arg)
        _Count=item.count
    elseif type == "equip" then
        local item = Equip:new(cell.arg)
        _Count=item.count
    elseif type == "equipPiece" then
        local item = EquipPiece:new(cell.arg)
        _Count=item.count
    elseif type == "item" then
        local item = uItem:new(cell.arg)
        _Count=item.count
    elseif type == "ghost" then
        local ghost = Tool.getUnUseGhost()
        for k,v in pairs(treasures) do
            if tonumber(v.id)==tonumber(cell.arg) and v.level == 1 and v.power == 0 then
                _Count=_Count+1
            end
        end
    elseif type == "ghostPiece" then
        local item = GhostPiece:new(cell.arg)
        _Count=item.count
    elseif type == "treasure"then
        local treasures = Player.Treasure:getLuaTable()
        for k,v in pairs(treasures) do
            if tonumber(v.id)==tonumber(cell.arg) and v.level == 1 and v.power == 0 and not v.onPosition then
                _Count=_Count+1
            end
        end
    elseif type == "fashion" then
        local item = Fashion:new(cell.arg)
        _Count=item.count 
    elseif type == "pet" then
        local item = Pet:new(nil, cell.arg)
        _Count=item.count
    elseif type == "petPiece" then
        local item = PetPiece:new(cell.arg)
        _Count=item.count  
    elseif type == "treasurePiece"then
        local item = TreasurePiece:new(cell.arg)
        _Count=item.count
    elseif Tool.typeId(type) then 
    	_Count=Tool.getCountByType(type)
    end
    _Count=_Count or 0
    if cell.arg2=="" then cell.arg2=1 end 
    if Tool.typeId(type) then 
    	canbuyNum = math.floor(_Count/cell.arg)
    else 
    	canbuyNum = math.floor(_Count/cell.arg2)
    end 
    self.canbuyNum=math.min(self.canbuyNum,canbuyNum) 
end

return m