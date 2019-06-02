--
-- Created by IntelliJ IDEA.
-- User: xiyou
-- Date: 2015/3/14
-- Time: 18:17
-- To change this template use File | Settings | File Templates.
-- 月卡。

local page = {}
local goldItem = {}

function page:create()
    return self
end

function page:update(data, index)
    self.isExt = false
    self.delegate = data.delegate
    self._index = index
    goldItem={}
    local drop = {}
    for i,v in ipairs(data.drop) do
        local temp = v
        temp.index=i
        if v.type=="gold" then 
            goldItem=v
        end 
        table.insert(drop,temp)
    end
    table.sort( drop, function (a,b)
        return tonumber(a.index) < tonumber(b.index)
    end )
    self.data = data
    local package = data.package
    self.gid = package.id
    self.status = self.delegate.data.status[self.gid]
    self.row=data.dataItem
    self.dataIndex=self.row.dataIndex
    self.Title.text=TextMap.GetValue("Text_1_146") .. self.row.days .. TextMap.GetValue("Text_1_147")
    ClientTool.UpdateMyTable("Prefabs/moduleFabs/activityModule/itemActivity",self.Grid,drop)
    self:updateBtnState()


    if #drop>4 then
        self.drag:SetActive(true)
    else 
        self.drag:SetActive(false)
    end
end

function page:getfirst(id)
	local firstPay = 0
	local first = Player.FirstPay
	if first ==nil then return firstPay end 
	for i=0,first.Count-1 do
		if first[i]==id then 
			firstPay=1 
		end 
	end
	return firstPay
end

function page:OnDestroy()
    Player:removeListener("topMenucurrency2")
end

function page:updateBtnState()
    if self.status == 1 then
        self.delegate:countMutliPoint(true)
    end
    if self.status ~= nil then
        local num = 0
        if Player.Activity[self.delegate.data.id][self.gid] ~= nil and Player.Activity[self.delegate.data.id][self.gid] > 0 then
            num=Player.Activity[self.delegate.data.id][self.gid]
        end
        if num>0 then 
            self.desc.text = TextMap.GetValue("Text_1_148") .. num
        else 
			local tb = TableReader:TableRowByID("charge_settings","charge_rate")
            local rate = tb.value
			local add = 0
			local flag = page:getfirst(self.row.id)
			local list = {}
			if flag == 0 then 
				-- 首冲
				list = RewardMrg.getProbdropByTable(self.row.firstdrop)
			else 
				list = RewardMrg.getProbdropByTable(self.row.drop)
			end 
            local x = 1
			if list[1] ~= nil then 
				if list[1].id == "gold" then 
					add = list[1].rwCount
				end 
			end 
            if goldItem.type~=nil and goldItem.arg~=nil and tonumber(goldItem.arg)>0 then 
                self.desc.text=TextMap.GetValue("Text_1_151") .. (rate* self.row.cost + add) .. TextMap.GetValue("Text_1_152") .. goldItem.arg .. TextMap.GetValue("Text41")
            else 
                self.desc.text=TextMap.GetValue("Text_1_151") .. (rate* self.row.cost + add) .. TextMap.GetValue("Text_1_153")
            end
        end 
        if self.status == 1 then
            self.btGet.gameObject:SetActive(true)
            self.finish:SetActive(false)
            self.btn_name.text = TextMap.GetValue("Text376")
            self.btGet.isEnabled = true
        elseif self.status == 2 then
            self.btGet.gameObject:SetActive(false)
            self.finish:SetActive(true)
        elseif self.status == 3 then
            self.btGet.gameObject:SetActive(true)
            self.finish:SetActive(false)
            self.btGet.isEnabled = true
            self.btn_name.text = self.row.showname
        end
    else
        self.btGet.gameObject:SetActive(true)
        self.finish:SetActive(false)
        self.btGet.isEnabled = false
        self.btn_name.text = TextMap.GetValue("Text376")
    end
end

function page:onClick(go, name)
    if name == "btGet" then
        if self.status == 1 then
                self.delegate.delegate:getMutliPackage(self.delegate, self.delegate.data.id, self.gid,
                    function (result)
                        if result.times~=nil and result.times>0 then
                            self.status = 1
                        else 
                            self.status = 2
                        end 
                        self:updateBtnState()
                        self.delegate.delegate:refreshEveryPay()
                    end)
        elseif self.status == 3 then
            if self.btGet~=nil then 
                self.btGet.isEnabled=false
            end 
            if self.btRecharge~=nil then 
                self.btRecharge.isEnabled=false
            end 
            self.delegate:refreshDataWhenVip()
            local playerId = Player.playerId
            local rtype = self.row.rtype
            local serverId = PlayerPrefs.GetString("serverId") or NowSelectedServer
            local info = playerId .. "|" .. serverId .. "|" .. rtype .. "|" .. os.time()
			local rate = TableReader:TableRowByID("charge_settings","charge_rate").value
            local money = self.row.cost *100
                if (ClientTool.Platform == "android" or ClientTool.Platform == "ios") and isSdk== 1 then
                    Api:getPayUrl(GlobalVar.sdkPlatform, rtype,info, self.row.cost, self.delegate.data.id, nil , function(res)
                    
                    local count = self.row.cost *tonumber(rate)
					--add by lihui UC6.1.0支付必须要的参数 2017-1-3 19:00
					local accountId = "0"
                    local url = ""
                    local sign =""
					print("serali onClick="..tostring(ClientTool.Platform)..",sdkPlatform="..GlobalVar.sdkPlatform)
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
			         print("serali iospay1="..tostring(accountId))
					
					if res.url ~= nil then
                        url = res.url
                    end
                    if res.sign ~= nil then
                        sign = res.sign
                    end
    					 if ClientTool.Platform == "ios" and GlobalVar.sdkPlatform == "gump" and accountId == 0 then
                            print("打开界面显示支付多方式："..ClientTool.Platform..":"..accountId)
                            local payInfo = {}
                            table.insert(payInfo, money)
                            table.insert(payInfo, self.row.id)
                            table.insert(payInfo, self.row.name)
                            table.insert(payInfo, count)
                            table.insert(payInfo, info)
                            table.insert(payInfo, url)
                            table.insert(payInfo, accountId)
                            table.insert(payInfo, sign)
                            UIMrg:pushWindow("Prefabs/moduleFabs/publicModule/ChoisePayType",{
                                                info = payInfo, delegate = self})                       
                        else
                            mysdk:pay(money, self.row.id,self.row.name, count, info, url, accountId, sign, "1", function(result)
                                self:onPurchase(true, 0)
                                end, function()
                                if self.btGet~=nil then 
                                    self.btGet.isEnabled=true
                                end 
                                if self.btRecharge~=nil then 
                                    self.btRecharge.isEnabled=true
                                end 
                                end)
                        end
                    end)
                else
                    Api:innerPay(Player.playerId, self.row.cost, self.row.rtype,info,self.delegate.data.id, function(result)
                        if result ~= nil and result.ret == 0 then
                            self:onPurchase(true, 0)
                        else
                            if self.btGet~=nil then 
                                self.btGet.isEnabled=true
                            end 
                            if self.btRecharge~=nil then 
                                self.btRecharge.isEnabled=true
                            end 
                            self:onPurchase(false, 0)
                        end
                        end)
                end
            end
    elseif name == "btn_left" then
        self.slider.value = 0
    elseif name == "btn_right" then
        self.slider.value = 1
    end
end

function page:returnPay()
    if self.btGet~=nil then 
        self.btGet.isEnabled=true
    end 
    if self.btRecharge~=nil then 
        self.btRecharge.isEnabled=true 
    end 
end

function page:onPurchase(succeed, money)
    if succeed then
        self.delegate.data.status[self.gid]=1
        self.status=1
        OperateAlert.getInstance:showToGameObject({ TextMap.GetValue("Text1462") }, self.btGet.gameObject)
    else
        MessageMrg.show(TextMap.GetValue("Text1463"))
    end
end

function page:getCallBack()
    self.delegate:countMutliPoint(false)
    if self.delegate.mutliPoint < 1 then
        self.delegate.delegate:hideEffect()
    end
    self.delegate:getCallBack()
end

function page:onPress(go,name,bPress)		
		if (self.delegate == nil or self.delegate.getScrollView == nil) then
		return
	end
  local sv = self.delegate:getScrollView()
	if sv ~= nil then
		sv:Press(bPress);
	end
end

function page:OnDrag(go,name,detal)
		if (self.delegate == nil or self.delegate.getScrollView == nil) then
		return
	end
	local sv = self.delegate:getScrollView()
	
	if sv ~= nil then
		sv:Drag();
	end
end


return page