local m = {} 
--右侧纵向item脚本

--btnstate 状态--1：未完成，2：已完成，未领取，:3：已领取


function m:update(data)--这里需要根据后台数据来显示不同的按钮，如果后台状态是可以领取的，就直接显示领取按钮
	self.data = data.info
	self.delegate = data.delegate
	self.actType = data.delegate.actType
	self.taksId = self.data.id
	local dropList = {}
	for index = 0, self.data.drop.Count do
		table.insert(dropList, self.data.drop[index])
	end
	self.Text_Title.text = self.data.target_desc
	self.Grid:refresh(self.Item, dropList)
    self.btn_Chongzhi.isEnabled = true
	if #dropList > 3 then
		self.Drag.gameObject:SetActive(true)
	else
		self.Drag.gameObject:SetActive(false)
	end
	self.Text_Requit.gameObject:SetActive(false)
	self.binding:CallAfterTime(0.1, function()
        self.ScrollView:ResetPosition()
    end)
	self.Text_Tip.gameObject:SetActive(false)
    self.btn_Get.gameObject:SetActive(false)
	self.btn_Chongzhi.gameObject:SetActive(false)
	self.Sprite_hasGet.gameObject:SetActive(false)
    self.Btn_Goto.gameObject:SetActive(false)
    if self.actType == "day7" then
    	if self.data.day_num <= Player.Day7s.day then
    		self.PlayactTypeList = Player.Day7s
			m:setButtonState(Player.Day7s)
		end
    	--print(self.data.target_desc.."状态："..Player.Day7s[self.data.id].state)
	else
		if self.data.day_num <= Player.DayNs[self.actType].day then
			self.PlayactTypeList = Player.DayNs[self.actType]
			m:setButtonState(Player.DayNs[self.actType])
		end
    	--print(self.data.target_desc.."状态："..Player.DayNs[self.actType][self.data.id].state)
    end
end

function m:setButtonState(PlayactTypeList)
	local cur 
    local target
    if self.actType == "day7" then
    	cur = PlayactTypeList[self.data.id].complete[self.data.id].progress
    	target = PlayactTypeList[self.data.id].complete[self.data.id].total
    else
    	cur = PlayactTypeList[self.data.id].complete.progress
    	target = PlayactTypeList[self.data.id].complete.total
    end
    if cur == 0 and target == 0 then
    	self.Text_Requit.gameObject:SetActive(false)
    else
    	self.Text_Requit.gameObject:SetActive(true)
    	if cur >= target then 
    		cur = target
    		self.Text_Requit.text = "[17F417]（"..cur.."/"..target.."）[-]"
    	else
    		self.Text_Requit.text = "（"..cur.."/"..target.."）"
    	end 
    end
	if PlayactTypeList[self.data.id] ~= nil and PlayactTypeList[self.data.id].state ~= nil then
    	self.btnState = PlayactTypeList[self.data.id].state
    	--print_t(self.data)
    	if self.btnState == 1 and self.data.type ~= "danchong" then
			--print("任务id："..self.data.id..", 任务名称:"..self.data.target_desc..", 状态：1是-->未完成")
    		if self.data.jump ~= nil and self.data.jump ~= "" then--跳转参数有值
		        self.Btn_Goto.gameObject:SetActive(true)
		    	local types = string.gsub(self.data.type, "_", "")
		        if types == "chapter" or types == "commonchapter" or types == "hardChapter" or types == "heroChapter" then
		        	self.data.type = types
		        end
		    end
		elseif self.btnState == 2 then
			--print("任务id："..self.data.id..", 任务名称: "..self.data.target_desc..", 状态：2是-->可领取")
			self.btn_Get.gameObject:SetActive(true)
		elseif self.btnState == 3 then
			--print("任务id："..self.data.id..", 任务名称: "..self.data.target_desc..", 状态：3是-->已领取")
			self.Sprite_hasGet.gameObject:SetActive(true)
		else
			--print("任务id："..self.data.id.."::->"..self.btnState)
			if self.data.type == "danchong" then
				self.btn_Chongzhi.gameObject:SetActive(true)
			end
    	end
	end

	--print("任务id："..self.data.id..", 任务名称: "..self.data.target_desc..":"..self.data.drwc..", state:->"..self.btnState)
	if self.data.drwc == 1 and self.Text_Tip ~= nil then
    	self.Text_Tip.transform.localPosition = Vector3(460, -91, 0)
		self.Text_Tip.gameObject:SetActive(true)
    	if self.data.day_num == self.PlayactTypeList.day then
    		self.Text_Tip.text = TextMap.GetValue("Text_1_90")
    		if self.btnState == 3 then
    			self.Text_Tip.text = ""
    		end
    	elseif self.data.day_num < self.PlayactTypeList.day then
    		if self.btnState == 2 then
				self.btn_Get.gameObject:SetActive(true)
    			self.Text_Tip.text = ""
    		elseif self.btnState == 3 then
				self.Sprite_hasGet.gameObject:SetActive(true)
    			self.Text_Tip.text = ""
    		else
    			self.Text_Tip.text = TextMap.GetValue("Text_1_91")
    			self.Text_Tip.transform.localPosition = Vector3(460, -51, 0)
    			self.btn_Get.gameObject:SetActive(false)
				self.btn_Chongzhi.gameObject:SetActive(false)
				self.Sprite_hasGet.gameObject:SetActive(false)
			    self.Btn_Goto.gameObject:SetActive(false)
				self.Text_Requit.gameObject:SetActive(false)
    		end
    	else
			self.Text_Tip.gameObject:SetActive(false)
    	end
    end
end

function m:onClick(go,name)
	if name == "btn_Get" then
		if self.taksId ~= nil then
			if self.delegate.actType == "day7" then
				Api:subDay7(self.taksId, function(result)
					m:setButtonState(self.PlayactTypeList)
					--packTool:showMsg(result, nil, 2)
					Events.Brocast("UpdateRedPoint")
					self.delegate:TypeChoiseCb()
					self.delegate:showMsg(result)
				end, function() end)
			else
				Api:subDay14(self.delegate.actType, self.taksId,nil, function(result)
					m:setButtonState(self.PlayactTypeList)
					--packTool:showMsg(result, nil, 2)
					Events.Brocast("UpdateRedPoint")
					self.delegate:TypeChoiseCb()
					self.delegate:showMsg(result)
				end, function() end)
			end

		end
	elseif name == "btn_Chongzhi" then
		m:OnChongzhi()
	elseif name == "Btn_Goto" then
        UIMrg:popWindow()--self.data.arg, 1, self.data.type--跳转到其他类型关卡就可以，但是调到普通关卡就不行，好像修改了普通关卡的跳转
		--Tool.replace("chapter", "Prefabs/moduleFabs/chapterModule/chapterModule_new", { 4, 1, "commonchapter"})
		uSuperLink.openModule(self.data.jump)
	end
end

function m:OnChongzhi()
    if self.data ~= nil then
    	self.chongzhi_item = TableReader:TableRowByID("shopPurchase", self.data.arg)
    end 
    if self.chongzhi_item~=nil then 
        if self.btn_Chongzhi~=nil then 
            self.btn_Chongzhi.isEnabled=false
        end 
        m:refreshDataWhenVip()
        -- local pay_lv = nil
        -- if self.delegate.data.event=="lvlup" then 
        --     pay_lv=self.status.id or 1
        -- end 
        local playerId = Player.playerId
        local rtype = self.chongzhi_item.rtype
        local serverId = PlayerPrefs.GetString("serverId") or NowSelectedServer
        local info = playerId .. "|" .. serverId .. "|" .. rtype .. "|" .. os.time()
		local money = self.chongzhi_item.cost *100
        local rate = TableReader:TableRowByID("charge_settings","charge_rate").value
        if (ClientTool.Platform == "android" or ClientTool.Platform == "ios") and isSdk== 1 then
            Api:getSevenDayPayUrl(GlobalVar.sdkPlatform, rtype, info, self.chongzhi_item.cost, self.actType, self.data.id ,function(res)
            local count = self.chongzhi_item.cost *tonumber(rate)
            local url = res.url
			--add by lihui UC6.1.0支付必须要的参数 2017-1-3 19:00
            local accountId = "0"
            if res.accountId ~= nil then
                accountId = res.accountId
            end
			local sign = res.sign

                if ClientTool.Platform == "ios" and GlobalVar.sdkPlatform == "gump" and accountId == 0 then
                        print("打开界面显示支付多方式："..ClientTool.Platform..":"..accountId)
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
                       	Events.Brocast("UpdateRedPoint")
                        self.delegate:TypeChoiseCb()
                        end)
                end
            end)
        else
            Api:innerSevendayPay(Player.playerId, self.chongzhi_item.cost, self.chongzhi_item.rtype,info, self.actType, self.data.id, function(result)
                if result ~= nil and result.ret == 0 then
                    OperateAlert.getInstance:showToGameObject({ TextMap.GetValue("Text1462") }, self.btn_Chongzhi.gameObject)
                else
                    if self.btn_Chongzhi~=nil then 
                        self.btn_Chongzhi.isEnabled=true
                    end 
                end
				Events.Brocast("UpdateRedPoint")
                self.delegate:TypeChoiseCb()
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

function m:refreshDataWhenVip( ... )
    Player.Resource:addListener("vipMenucurrency", "vip_exp", function(key, attr, newValue)
        self.delegate:TypeChoiseCb()
        Player:removeListener("vipMenucurrency")
    end)
end

function m:OnDestroy()
end

return m