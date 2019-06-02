local page = {}

function page:create()
    return self
end

function page:update(data)
    self.isExt = false
    if data~=nil then 
        self.data = data
    end 
    if self.Sprite_guoqi~=nil then 
        self.Sprite_guoqi:SetActive(false)
    end 
    self.chongzhi_item=nil
    self.delegate = self.data.delegate
    local drop = self.data.drop
    local package = self.data.package
    self.gid = package.id
    if self.data.type==nil or (self.data.type~="vipGift" and self.data.type~="vipFuli")then
        if self.delegate.data.extra_status then
            self.extra_status = self.delegate.data.extra_status[self.gid]
        end
        self.status = self.delegate.data.status[self.gid]
        if self.status == 1 or self.extra_status == 1 then
            self.delegate:countMutliPoint(true)
        end
    end 
    if self.data.type~=nil and self.data.type=="everyPay" then 
        self.type=self.data.type
        self.chongzhi_item=self.data.chongzhi_item
        local rate = TableReader:TableRowByID("charge_settings","Num_rate").value
        local rate1 = TableReader:TableRowByID("charge_settings","charge_rate").value
        if self.delegate.data._source_data.currency_type==nil or self.delegate.data._source_data.currency_type=="currency" then 
            self.Title.text =package.id/tonumber(rate) .. TextMap.GetValue("Text1461")        
        elseif self.delegate.data._source_data.currency_type=="gold" then 
            self.Title.text =(tonumber(rate1)*package.id)/tonumber(rate) .. TextMap.GetValue("LocalKey_654")
        elseif self.delegate.data._source_data.currency_type=="read_table" then
            self.Title.text =self.chongzhi_item["showname"]
        end 
        if self.delegate.data._source_data.times~= nil then 
            local times = self.delegate.data._source_data.times[self.gid] or 0
            if times>0 then 
                self.timeObj:SetActive(true)
            else
                self.time.text=string.gsub(TextMap.GetValue("LocalKey_691"),"{0}",times)
                self.timeObj:SetActive(false)
            end 
        else 
            self.timeObj:SetActive(false)
        end 
    elseif self.data.type~=nil and self.data.type=="vipGift" then 
        self.type=self.data.type
        self.Title.text = TextMap.GetValue("Text_1_125") .. package.id
        self.k=package.id 
        self.times = 0 
        if self.delegate.data.times~=nil and self.delegate.data.times[self.k] ~=nil then 
            self.times=self.delegate.data.times[self.k]
        end
        if tonumber(package.id)<=Player.Info.vip then 
            self.txt_change_count.text=string.gsub(TextMap.GetValue("LocalKey_692"),"{0}",self.times)
        else
            self.txt_change_count.text=TextMap.GetValue("Text_1_127")
        end
        if self.data.disc==10 then 
            self.disclabel.gameObject:SetActive(false)
        else 
            self.disclabel.gameObject:SetActive(true)
            self.disclabel.text=string.gsub(TextMap.GetValue("LocalKey_789"),"{0}",self.data.disc)
        end
        self.costNum.text=self.data.cost 
    elseif self.data.type~=nil and self.data.type=="vipFuli" then 
        self.Title.text = "VIP" .. package.id ..TextMap.GetValue("Text_1_128")
    elseif self.delegate.data.event=="loginGift" then  
        self.Title.text = package.name
        self.lv.text=""
        self.time.text=""
        self.tip_chongzhi.text=""
        self.cost:SetActive(false)
    else 
        self.Title.text = package.name
    end 
    
    self.btGet.gameObject:SetActive(true)
    self.finish:SetActive(false)
    if self.btRecharge~=nil then 
        self.btRecharge.gameObject:SetActive(false)
    end
    if self.data.type~=nil and self.data.type=="vipGift" then 
        self.type=self.data.type 
        if tonumber(package.id)<=Player.Info.vip and self.times==0 then 
            self.status=2
            self.finish:SetActive(true)
            self.btGet.gameObject:SetActive(false)
        elseif tonumber(package.id)<=Player.Info.vip and self.times>0 then 
            self.status=1
            self.finish:SetActive(false)
            self.btn_name.text = TextMap.GetValue("Text1464")
            self.btGet.gameObject:SetActive(true)
        elseif tonumber(package.id) > Player.Info.vip then 
            self.status=3
            self.btn_name.text = TextMap.GetValue("Text424")
            self.btGet.gameObject:SetActive(true)
            self.finish:SetActive(false)
        end
    elseif self.data.type~=nil and self.data.type=="vipFuli" then 
        self.type=self.data.type
        self.status=3
        if tonumber(package.id) == Player.Info.vip then 
            self.status=self.delegate.data.status
        end 
        if self.status==2 then 
            self.finish:SetActive(true)
            self.btGet.gameObject:SetActive(false)
        elseif self.status ==3 then 
            self.btn_name.text = TextMap.GetValue("Text424")
            self.btGet.gameObject:SetActive(true)
            self.finish:SetActive(false)
        else 
            self.btn_name.text = TextMap.GetValue("Text1672")
            self.btGet.gameObject:SetActive(true)
            self.finish:SetActive(false)
        end  
    elseif self.delegate.data.event=="lvlup" then 
        self.k=self.data.k
        self.status=self.delegate.data._source_data.status[self.k]
        self.time.text=""
        self.tip_chongzhi.text=""
        self.cost:SetActive(false)
        if self.status~=nil then 
            local lv = self.status.id or 1 
            self.btn_name.text=TextMap.GetValue("Text_1_22")
            if self.status.consume~=nil then 
                self.cost:SetActive(true)
                local iconName = Tool.getResIcon(self.status.consume[1].type)
                self.costIcon.Url=UrlManager.GetImagesPath("itemImage/" .. iconName .. ".png")
                self.costNum.text=self.status.consume[1].arg
            else 
                self.cost:SetActive(false)
            end 
            if self.status.pay~=nil then 
                self.chongzhi_item=nil 
                TableReader:ForEachLuaTable("shopPurchase", function(index, item)
                    if tonumber(item.id)==tonumber(self.status.pay) then
                        self.chongzhi_item=item
                    end 
                    return false
                end)
                if self.chongzhi_item~=nil then 
                    self.btn_name.text = TextMap.GetValue("Text424")
                    self.tip_chongzhi.text=string.gsub(TextMap.GetValue("LocalKey_799"),"{0}",self.chongzhi_item.cost)
                else 
                    self.tip_chongzhi.text=""
                end 
            else
                self.tip_chongzhi.text=""
            end
            if self.status.status~=nil and self.status.status.time~=nil then 
                if tonumber(self.status.status.time)/1000>os.time() then 
                    self.time.text=TextMap.GetValue("Text_1_131") .. Tool.FormatTime(self.status.status.time/ 1000 -os.time()) 
                    self:refreshCdtime(self.status.status.time)
                    self.Sprite_guoqi:SetActive(false)
                    self.btGet.gameObject:SetActive(true)
                else
                    self.time.text=""
                    self.Sprite_guoqi:SetActive(true)
                    self.btGet.gameObject:SetActive(false)
                end 
            else 
                self.time.text=""
            end 
            if self.status.status~=nil and self.status.status.status~=nil then 
                if self.status.status.status==1 then 
                    self.btn_name.text = TextMap.GetValue("Text376")
                    self.btGet.isEnabled = true
                    self.Sprite_guoqi:SetActive(false)
                elseif self.status.status.status==2 then 
                    self.finish:SetActive(true)
                    self.btGet.gameObject:SetActive(false)
                    self.Sprite_guoqi:SetActive(false)
                elseif self.status.status.status==3 then 
                    self.btn_name.text = TextMap.GetValue("Text424")
                    self.btGet.gameObject:SetActive(true)
                    self.btGet.isEnabled = true
                    self.finish:SetActive(false)
                    self.Sprite_guoqi:SetActive(false)
                else 
                    self.finish:SetActive(false)
                    self.Sprite_guoqi:SetActive(true)
                    self.btGet.gameObject:SetActive(false)
                end 
            else  
                self.btn_name.text = TextMap.GetValue("Text376")
                self.btGet.isEnabled = false
            end 
            if Player.Info.level<tonumber(lv) then 
                self.lv.text=TextMap.GetValue("Text_1_132") .. Player.Info.level
                if self.status.pay~=nil and (self.status.status==nil or self.status.status.status==nil or self.status.status.status==3) then
                    self.status.status=self.status.status or {}
                    self.status.status.status=3 
                    self.btn_name.text = TextMap.GetValue("Text424")
                    self.btGet.gameObject:SetActive(true)
                    self.btGet.isEnabled = false
                    self.finish:SetActive(false)
                end 
            else 
                self.lv.text=""
                if self.status.pay~=nil and (self.status.status==nil or self.status.status.status==nil or self.status.status.status==3) then
                    self.status.status=self.status.status or {}
                    self.status.status.status=3  
                    self.btn_name.text = TextMap.GetValue("Text424")
                    self.btGet.gameObject:SetActive(true)
                    self.btGet.isEnabled = true
                    self.finish:SetActive(false)
                end 
            end
			if self.data.time_status == 0 then 
                if self.status~=nil and self.status.status~=nil and self.status.status.status~=2 then 
                    self.finish:SetActive(false)
                    self.Sprite_guoqi:SetActive(true)
                    self.btGet.gameObject:SetActive(false)
                else 
                    self.finish:SetActive(true)
                    self.Sprite_guoqi:SetActive(false)
                    self.btGet.gameObject:SetActive(false)
                end 
            else 
                self.Sprite_guoqi:SetActive(false)
			end 
        end 
    elseif self.status ~= nil then
        if self.status == 2 then
            table.foreach(drop, function(i, v)
                v.has = true
            end)
        end
        if self.status == 1 or ((self.extra_status == 1 or self.extra_status == nil) and self.data.extra_drop and self.item_for_yueka) then
            self.btn_name.text = TextMap.GetValue("Text376")
            self.btGet.isEnabled = true
        elseif self.status == 2 then
            self.finish:SetActive(true)
            self.btGet.gameObject:SetActive(false)
        end
    else
        self.btGet.isEnabled = false
        self.btn_name.text = TextMap.GetValue("Text376")
        if self.data.event_type == "totalPay" or self.data.type == "everyPay" then
            self.btn_name.text = TextMap.GetValue("Text424")
            self.btGet.isEnabled = true
            self.btGet.gameObject:SetActive(true)
            self.finish:SetActive(false)
        end
    end
    self.drag:SetActive(true)
    if self.data.type~=nil and self.data.type=="everyPay" then 
        local _drop = {}
        local _extra_drop = {}
        for i=1,#drop do
			if drop[i].is_gold_base ~= nil then 	
				table.insert(_drop,drop[i])
			else 
				if self:typeId(drop[i].item.type) then 
					table.insert(_extra_drop,drop[i])
				else 
					table.insert(_drop,drop[i])
				end 
			end 
        end
        ClientTool.UpdateMyTable("Prefabs/moduleFabs/activityModule/itemActivity",self.Grid,{})
        ClientTool.UpdateMyTable("Prefabs/moduleFabs/activityModule/itemActivity",self.Grid,_drop,self.delegate)
        if #_drop>4 then
            self.drag:SetActive(true)
        else 
            self.drag:SetActive(false)
        end
        if #_extra_drop>0 then 
            self.ew:SetActive(true)
            ClientTool.UpdateMyTable("Prefabs/moduleFabs/activityModule/itemActivity",self.Table,{})
            ClientTool.UpdateMyTable("Prefabs/moduleFabs/activityModule/itemActivity",self.Table,_extra_drop,self.delegate)
        else 
            self.ew:SetActive(false)
        end 
    else 
        self.Grid:refresh("Prefabs/moduleFabs/activityModule/itemActivity",{},self.delegate)
        self.Grid:refresh("Prefabs/moduleFabs/activityModule/itemActivity", drop,self.delegate)
        if #drop>3 then
            self.drag:SetActive(true)
        else 
            self.drag:SetActive(false)
        end
    end 
    if self.data.extra_drop and self.item_for_yueka then
        self.binding:Show("item_for_yueka")
        if self.extra_status == 2 then self.data.extra_drop.has = true end
        self.item_for_yueka:CallUpdate(self.data.extra_drop)
    elseif self.item_for_yueka then
        self.binding:Hide("item_for_yueka")
    end
end

local timerId = 0

function page:refreshCdtime()
    if self.status~=nil and self.status.status~=nil and self.status.status.time~=nil then 
        LuaTimer.Delete(timerId)
        timerId = LuaTimer.Add(0,1000, function(id)
            if self.status~=nil and self.status.status~=nil and self.status.status.time~=nil and self.status.status.time / 1000>os.time() then 
                self.time.text=TextMap.GetValue("Text_1_131") .. Tool.FormatTime(self.status.status.time/ 1000 -os.time()) 
            elseif self.status==nil or self.status.status==nil or self.status.status.time==nil  then 
                self.time.text=""
            else  
                self.time.text=TextMap.GetValue("Text_1_91")
            end 
        end)
    end 
end

function page:OnDestroy()
    LuaTimer.Delete(timerId)
    self.chongzhi_item=nil
end

function page:OnDisable()
    LuaTimer.Delete(timerId)
    self.chongzhi_item=nil
end

function page:onBtGet()
    if self.delegate.data.event == "lvlup" then
        self.isExt = ((self.extra_status == 1 or self.extra_status == nil) and self.data.extra_drop and self.item_for_yueka)
        if self.status == 2 and self.isExt and Player.Card["yueka"] <= 0 then
            MessageMrg.show(TextMap.GetValue("Text448"))
            return
        end
        if self.status == 1 or self.isExt then
            self.delegate.delegate:getMutliPackage(self, self.delegate.data.id, self.gid)
            self.status = 2
            self.finish:SetActive(true)
            self.btGet.gameObject:SetActive(false) 
        end
    elseif self.type~=nil and self.type=="vipGift" then 
        if tonumber(self.gid)<=Player.Info.vip and self.data.times>0 then 
            DialogMrg.ShowDialog(string.gsub(TextMap.GetValue("LocalKey_800"),"{0}",self.data.cost), function()
                self.delegate:buyVipGift(self, self.delegate.data.id, self.gid,1,function ()
                    self:update()
                end)
                end)
        elseif tonumber(self.data.package.id) > Player.Info.vip then 
            self:OnChongzhi()
        end
    elseif self.type~=nil and self.type=="vipFuli" then
        if self.status==1 then 
            self.delegate:getDropPackage(self, self.delegate.data.id, self.gid)
            self.status = 2
            self.finish:SetActive(true)
            self.btGet.gameObject:SetActive(false)
        elseif self.status==3 then 
            self:OnChongzhi()
        end 
    else
        if self.status == 1 then
            self.delegate.delegate:getMutliPackage(self, self.delegate.data.id, self.gid)
            self.status = 2
            self.finish:SetActive(true)
            self.btGet.gameObject:SetActive(false) 
            if self.delegate.data.event == "everyPay" then
                self.delegate.find=self.data.index or 0
                self.delegate.delegate:refreshEveryPay()
            end
        end
    end
end

function page:typeId(_type)
    -- local ret = false
    -- TableReader:ForEachLuaTable("resourceDefine", function(k, v)
    --     if _type == v.name then
    --         ret = true
    --         return false
    --     end
    -- end)
    return Tool.typeId(_type)  
end

function page:onClick(go, name)
    if name == "btGet" then
        self.delegate.selectItem_cur=self
        if self.delegate.data.event=="lvlup" then 
            self.isExt = ((self.extra_status == 1 or self.extra_status == nil) and self.data.extra_drop and self.item_for_yueka)
            if self.status == 2 and self.isExt and Player.Card["yueka"] <= 0 then
                MessageMrg.show(TextMap.GetValue("Text448"))
                return
            end
            if self.status.status~=nil and self.status.status.status~=nil and self.status.status.status == 1 or self.isExt then
                self.delegate.delegate:getMutliPackage(self, self.delegate.data.id, self.gid)
                self.status.status.status = 2
                self.finish:SetActive(true)
                self.btGet.gameObject:SetActive(false)
                self.delegate.delegate:refreshEveryPay()
            elseif self.status.status~=nil and self.status.status.status~=nil and self.status.status.status == 3 then 
                self:OnChongzhi()
            end
        elseif self.status ~= nil then
            self:onBtGet()
        else 
            self:OnChongzhi()
        end
    elseif name == "btn_left" then
        self.slider.value = 0
    elseif name == "btn_right" then
        self.slider.value = 1
    elseif name == "btRecharge" then
        self:OnChongzhi()
    end
end

function page:OnChongzhi()
    if self.chongzhi_item ==nil then 
        local rate = TableReader:TableRowByID("charge_settings","Num_rate").value
        TableReader:ForEachLuaTable("shopPurchase", function(index, item)
            if self.data.type=="everyPay" and tonumber(item.cost)==tonumber(self.data.package.id/tonumber(rate)) and item.rtype~="invest" and string.sub(item.rtype,0,5)~="yueka" then
                self.chongzhi_item=item
            end 
            return false
        end)
    end 
    if self.chongzhi_item~=nil then 
        if self.btGet~=nil then 
            self.btGet.isEnabled=false
        end 
        if self.btRecharge~=nil then 
            self.btRecharge.isEnabled=false
        end 
        self.delegate:refreshDataWhenVip()
        local pay_lv = nil
        if self.delegate.data.event=="lvlup" then 
            pay_lv=self.status.id or 1
        end 
        local playerId = Player.playerId
        local rtype = self.chongzhi_item.rtype
        local serverId = PlayerPrefs.GetString("serverId") or NowSelectedServer
        local info = playerId .. "|" .. serverId .. "|" .. rtype .. "|" .. os.time()
        local rate = TableReader:TableRowByID("charge_settings","charge_rate").value
		local money = self.chongzhi_item.cost *100
        if (ClientTool.Platform == "android" or ClientTool.Platform == "ios") and isSdk== 1 then
            Api:getPayUrl(GlobalVar.sdkPlatform, rtype,info,self.chongzhi_item.cost,self.delegate.data.id,pay_lv,function(res)
            local count = self.chongzhi_item.cost*tonumber(rate)
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
			print("serali iospay1="..tostring(accountId))
            if res.url ~= nil then
                url = res.url
            end
			print("serali url="..tostring(url))
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
                        OperateAlert.getInstance:showToGameObject({ TextMap.GetValue("Text1462") }, self.btGet.gameObject)
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
            Api:innerPay(Player.playerId, self.chongzhi_item.cost, self.chongzhi_item.rtype,info,self.delegate.data.id,pay_lv, function(result)
                if result ~= nil and result.ret == 0 then
                    OperateAlert.getInstance:showToGameObject({ TextMap.GetValue("Text1462") }, self.btGet.gameObject)
                else
                    if self.btGet~=nil then 
                        self.btGet.isEnabled=true
                    end 
                    if self.btRecharge~=nil then 
                        self.btRecharge.isEnabled=true
                    end 
                end
                end)
        end
    else
        DialogMrg.chognzhi()
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

function page:getCallBack() 
    print("resourceDefine")
    self:update()
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

function page:getScrollView()
    return self.delegate:getScrollView()
end


return page