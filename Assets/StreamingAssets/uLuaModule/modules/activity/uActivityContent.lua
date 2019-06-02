local page = {}

local bindTable = {}

local myFont = nil

function page:create()
    return self
end

function page:updateContent(info)
    self.obj.gameObject:SetActive(true)
    local ret = info.ret
    if ret ~= nil then
        self.hasInit = ret
    end
    self:init(info, ret)
end

local InitLoadImage = false
function page:init(info, up)
    self.delegate = info.delegate
    self.data = info.data
    self.mutliPoint = 0 --计算多礼包中小红点 
    if not up then 
        self.yueka_id=0
    end

    self.binding:CallManyFrame(function()
        local event = self.data.event
        print(event)
        if event == "dailyGift" then self:dailyGift(up)
        elseif event == "rankPower" then self:rankPower(up)
        elseif event == "rankLvl" then self:rankLvl(up)
        elseif event == "rankPay" then self:rankPay(up)
        elseif event == "firstPayGift" then self:firstPayGift(up)
        elseif event == "serverGift" then self:serverGift(up)
        elseif event == "lvlup" then self:lvlup(up)
        elseif event == "totalPay" then self:totalPay(up, event)
        elseif event == "giftCode" then self:giftCode(up)
        elseif event == "findBug" then self:findBug(up)
        elseif event == "extraGold" then self:extraGold(up)
        elseif event == "shopSale" then self:shopSale(up)
        elseif event == "returnGold" then self:returnGold(up)
        elseif event == "notice" then self:notice(up)
        elseif event == "addQQ" then self:notice(up)
        elseif event == "doubleMoney" then self:doubleMoney(up)
        elseif event == "getBP" then self:getBP(up)
        elseif event == "monthCard" then self:monthCard(up)
        elseif event == "vipGift" then self:vipGift(up)
        elseif event == "dailyFirstPay" then self:dailyFirstPay(up)
        elseif event == "totalCost" then self:totalPay(up, event)
        elseif event == "everyPay" then self:everyPay(up)
        elseif event == "investPlan" then self:investPlan(up)
        elseif event == "loginGift" then self:loginGift(up)
        elseif event == "openGift" then self:openGift(up)
        elseif event == "limitChange" then self:limitChange(up)
        elseif event == "challengeWinReward" then self:challengeWinReward(up)
        elseif event == "login30" then self:dailySign(up)
        elseif event == "turnTable" then self:turnTable(up)
        elseif event == "cdkeyChange" then self:cdkeyChange(up)
        elseif event == "agencyGod" then self:agencyGod(up)
        elseif event == "rankJJC" then self:rankJJC()
        elseif event == "wishingWell" then self:wishingWell()
	    elseif event == "shareSDK" then self:shareSDK()
        elseif event == "rankActivity" then self:rankActivity()
        elseif event == "dailyPay" then self:dailyPay()
        elseif event == "fortune" then self:zhaocaimao()
        elseif event=="sendActBylevel" then 
            page:sendActBylevel()
        elseif event=="normalPay" then 
            page:normalPay(up)
        end
    end)
    if InitLoadImage then return end
    local keyMap = self._keyMap
    table.foreach(keyMap, function(k, v)
        if self[k] then
            if k == "title" and event == "rankJJC" then
            elseif k == "heroModel" then
                self.heroModel:LoadByCharId(tonumber(v), "idle", function(ctl) end, false, -1)
            else
                if k~="pb_3" then 
                    self[k].Url = UrlManager.GetImagesPath(v)
                end
            end
        end
    end)
    InitLoadImage = true
end

function page:normalPay(up)
    if up then 
        if self.selectItem_cur~=nil then 
            self.selectItem_cur:getCallBack()
        end 
        return 
    end
    self.purchaseData = {}
    local index = 0
    TableReader:ForEachLuaTable("shopPurchase", function(index, item)
        if item.recommend~=nil and item.recommend~="" and tonumber(item.recommend) >= 1 then
            item.delegate=self
            index=index+1
            item.index=index
            table.insert(self.purchaseData,item)
        end
    return false
    end)
    table.sort(self.purchaseData, function(a,b)
        return tonumber(a.recommend)<tonumber(b.recommend)
    end)
    self.table:refresh(self.purchaseData, self, false,0)
end

local time_send = 0

function page:sendActBylevel()
    LuaTimer.Delete(time_send)
    local level = Player.Activity[self.data.id].level
    local refreshTime = Player.Activity[self.data.id].refreshTime
    local intervalTime = self.data._source_data.intervalTime
    local time_num = intervalTime
    if self.data._source_data.time_num~=nil and self.data._source_data.time_num["" .. level]~=nil then 
        time_num = self.data._source_data.time_num["" .. level] 
    end 
    local total_num = self.data._source_data.consume_num["" .. level] 
    local progress = Player.Activity[self.data.id].total
    self.data.status=tonumber(Player.Activity[self.data.id].drop)
    if self.data._source_data.level_type =="chongzhi" then 
        self.cost:SetActive(false)
        self.desc.text="[F0E77B]" .. TextMap.GetValue("Text_1_2956") .. "[-]" ..total_num .. "[F0E77B]" .. TextMap.GetValue("Text_1_2957") .. "[-]（" .. progress .."/" .. total_num .." ）"
        self.lbTip.text=TextMap.GetValue("Text_1_22")
    elseif self.data._source_data.level_type =="gold" then  
        self.cost:SetActive(true)
        self.costNum.text=total_num
        self.needGoldNum=total_num
        self.desc.text=""
        self.lbTip.text=TextMap.GetValue("Text_1_8")
    elseif self.data._source_data.level_type =="danchong" then  
        self.cost:SetActive(false)
        self.chongzhi_item=nil 
        TableReader:ForEachLuaTable("shopPurchase", function(index, item)
            if tonumber(item.id)==tonumber(total_num) then
                self.chongzhi_item=item
            end 
            return false
        end)
        self.desc.text="[F0E77B]" .. TextMap.GetValue("LocalKey_73") .."[-]" ..self.chongzhi_item.cost .. "[F0E77B]" .. TextMap.GetValue("Text_1_2957") .."[-]"
        self.lbTip.text=TextMap.GetValue("Text_1_129")
    end 
    if Player.Activity[self.data.id].open==true or self.data.status==1 then 
        self.notOpen.gameObject:SetActive(false)
        self.btGet.gameObject:SetActive(true)
        if self.data.status==2 then 
            if self.data._source_data.level_type =="gold" then
                self.lbTip.text=TextMap.GetValue("Text1465")
            else 
                self.lbTip.text=TextMap.GetValue("Text397")
            end 
            self.btGet.isEnabled=false
        elseif self.data.status==1 then 
            if self.data._source_data.level_type =="gold" then
                self.lbTip.text=TextMap.GetValue("Text_1_8")
            else 
                self.lbTip.text=TextMap.GetValue("Text_1_22")
            end 
            self.btGet.isEnabled=true
        else 
            self.btGet.isEnabled=true
        end 
    else 
        self.wancheng:SetActive(false)
        self.btGet.gameObject:SetActive(false)
        self.notOpen.gameObject:SetActive(true)
    end 
    if Player.Activity[self.data.id].open==true then
        if tonumber(refreshTime) / 1000+time_num*60*60>os.time() then 
            local time =Tool.FormatTime(tonumber(refreshTime) / 1000+time_num*60*60 -os.time()) 
            if self.data._source_data.level_type =="gold" then
                self.time.text=TextMap.GetValue("Text_1_2959") .. "[24FC24]" .. time  .. "[-]" .. TextMap.GetValue("Text_1_2960") .. TextMap.GetValue("Text_1_8")
            elseif self.data._source_data.level_type =="chongzhi" then
                self.time.text=TextMap.GetValue("Text_1_2959") .. "[24FC24]" .. time  .. "[-]" .. TextMap.GetValue("Text_1_2960") .. TextMap.GetValue("Text_1_22")
            else  
                self.time.text=TextMap.GetValue("Text_1_2959") .. "[24FC24]" .. time  .. "[-]" .. TextMap.GetValue("Text_1_2960") .. TextMap.GetValue("Text_1_129")
            end
            time_send = LuaTimer.Add(0, 1000, function(id)
                if tonumber(refreshTime) / 1000+time_num*60*60 <=os.time() then 
                    LuaTimer.Delete(time_send)
                    page.delegate:refreshEveryPay()
                else 
                    local time  =Tool.FormatTime(tonumber(refreshTime) / 1000+time_num*60*60 -os.time())
                    if self.data._source_data.level_type =="gold" then
                        self.time.text=TextMap.GetValue("Text_1_2959") .. "[24FC24]" .. time  .. "[-]" .. TextMap.GetValue("Text_1_2960") .. TextMap.GetValue("Text_1_8")
                    elseif self.data._source_data.level_type =="chongzhi" then
                        self.time.text=TextMap.GetValue("Text_1_2959") .. "[24FC24]" .. time  .. "[-]" .. TextMap.GetValue("Text_1_2960") .. TextMap.GetValue("Text_1_22")
                    else  
                        self.time.text=TextMap.GetValue("Text_1_2959") .. "[24FC24]" .. time  .. "[-]" .. TextMap.GetValue("Text_1_2960") .. TextMap.GetValue("Text_1_129")
                    end
                end  
                end) 
        else 
            self.time.text=""
            if self.status~=1 then 
                self.btGet.gameObject:SetActive(false)
                self.notOpen.gameObject:SetActive(true)
            end 
        end 
    else
        if tonumber(refreshTime) / 1000+intervalTime*60*60 > os.time() then 
            local time  =Tool.FormatTime(tonumber(refreshTime) / 1000+intervalTime*60*60 -os.time())  
            self.time.text="[24FC24]" .. time  .. "[-]" .. TextMap.GetValue("Text397")
            time_send = LuaTimer.Add(0, 1000, function(id)
                if tonumber(refreshTime) / 1000+intervalTime*60*60 <=os.time() then 
                    LuaTimer.Delete(time_send)
                    page.delegate:refreshEveryPay()
                else 
                    local time  =Tool.FormatTime(tonumber(refreshTime) / 1000+intervalTime*60*60 -os.time())  
                    self.time.text=string.gsub(TextMap.GetValue("LocalKey_843"),"{0}","[24FC24]" .. time  .. "[-]")
                end  
                end) 
        else 
            self.time.text=""
            if self.status~=1 then 
                self.btGet.gameObject:SetActive(false)
                self.notOpen.gameObject:SetActive(true)
            end 
        end 
    end
    local droplist = {}
    local drop=self.data.drop[tonumber(level)] or {}
    table.foreach(drop, function(i, item)
        local _type = item.type
        if _type == "char" then
            local vo = Char:new(item.arg)
            vo.rwCount=item.arg2
            vo.__tp = "char"
            table.insert(droplist, vo)
        else
            local vo = itemvo:new(item.type, item.arg2, item.arg)
            vo.__tp = "vo"
            table.insert(droplist, vo)
        end
    end)
    ClientTool.UpdateMyTable("Prefabs/moduleFabs/activityModule/itemActivity", self.Grid,droplist,self)
end

--招财猫活动
function page:zhaocaimao()
    local act_id=self.data.id
    local data=self.data
    local freeTimes=Player.Activity[act_id].freeTimes or 0
    local costTimes =Player.Activity[act_id].costTimes or 0
    local cdTime=Player.Activity[act_id].cdTime or 0
    local history = Player.Activity[act_id].h 
    local totalnum_cur=freeTimes+costTimes
    local totalgetNum = 0
    if history~=nil then 
        for i=0,history.Count-1 do
            totalgetNum=totalgetNum+history[i].d
        end
    end 
    if self.data.desc ~=nil and self.data.desc~="" then 
        self.btn_notice.gameObject:SetActive(true)
    else 
        self.btn_notice.gameObject:SetActive(false)
    end 
    local total = 0
    self.gift={}
    for i=1,4 do 
        local gift = TableReader:TableRowByID("fortune","gift_" .. i)
        table.insert( self.gift, gift )
        self["boxnum"..i].text=gift.arg1 .. TextMap.GetValue("Text_1_15")
        if totalnum_cur>=tonumber(gift.arg1) then 
            self["effect"..i]:SetActive(true)
            if data.status~=nil and data.status['' .. gift.arg1]==nil then 
                self.data.status['' .. gift.arg1]=1 
            end 
        else 
            self["effect"..i]:SetActive(false)
        end 
        if data.status~=nil and data.status['' .. gift.arg1]~=nil then 
            if data.status['' .. gift.arg1]==2 then 
                self["box_open" .. i].gameObject:SetActive(true)
                self["box_close" .. i].gameObject:SetActive(false)
                self["effect"..i]:SetActive(false)
            else 
                self["box_open" .. i].gameObject:SetActive(false)
                self["box_close" .. i].gameObject:SetActive(true)
            end 
        else 
            self["box_open" .. i].gameObject:SetActive(false)
            self["box_close" .. i].gameObject:SetActive(true)
        end 
        if i==4 then 
            total=gift.arg1
        end 
    end
    local row = TableReader:TableRowByID("fortune","freetime")
    self.slider_di.value=totalnum_cur/total
    self.isFree=false
    if cdTime/1000<=os.time() and freeTimes<row.arg1 then 
        self.isFree=true
        self.btn_label.text=TextMap.GetValue("Text_1_95")
        self.des1.text=""
    else 
        if freeTimes<=row.arg1 then 
            page:refreshCdtime(cdTime)
            local time  =Tool.FormatTime(cdTime / 1000 -os.time()) 
            self.des1.text=string.gsub(TextMap.GetValue("LocalKey_794"),"{0}",time)
        else 
            self.des1.text=""
        end 
        self.btn_label.text=TextMap.GetValue("Text_1_97")
    end 
    local row1 = TableReader:TableRowByID("fortune","viplimit_" .. Player.Info.vip)
    self.ziyuanNum3.text="（" .. costTimes .. "/" .. row1.arg2 .. "）"
    self.canBuy=false 
    if tonumber(costTimes)<tonumber(row1.arg2) then 
        self.canBuy=true 
    end 
    if self.isFree or self.canBuy then 
        self.btGet.isEnabled=true
    else 
        self.btGet.isEnabled=false
    end 
    self.ziyuanNum1.text=totalgetNum
    row = TableReader:TableRowByID("fortune","arg1")
    self.des.text=TextMap.GetValue("Text_1_98") .. (row.arg1+Player.Info.level*math.floor(Player.Info.level/row.arg2))*row.arg3 .. TextMap.GetValue("Text_1_99")
    row = TableReader:TableRowByID("fortune","cost")
    self.costGold=row.arg1+math.floor(costTimes/row.arg2)*row.arg3
    self.ziyuanNum2.text=self.costGold
end

function page:ReViewReward(id)
    local gift = TableReader:TableRowByID("fortune","gift_" .. id)
    local temp = {}
    temp.type = "showReward"
    temp.obj = self:getDropTable(self.gift[id].drop)
    temp.onOk = function()
        UIMrg:popWindow()
        self.delegate:getMutliPackage(self, self.data.id,'' .. gift.arg1,function ()
            self.data.status['' .. gift.arg1]=2
            self["box_open" .. id].gameObject:SetActive(true)
            self["box_close" .. id].gameObject:SetActive(false)
            self["effect"..id]:SetActive(false)
        end)
    end
    temp.index = id
    temp.state = self.data.status['' .. gift.arg1]
    temp.currentChapterType = ""
    temp.delegate = self
    temp._go = self.binding.gameObject

    UIMrg:pushWindow("Prefabs/moduleFabs/chapterModule/chapterbox", temp)
end

function page:getDropTable(list)
    local _list={}
    for i=0,list.Count do
        table.insert(_list, list[i])
    end
    return _list
end

function page:onClick(go, name)
    print(name)
    local event = self.data.event
    if name == "btGet" then
        if event == "fortune" then 
            if self.isFree==true or (Player.Resource.gold>=self.costGold and self.canBuy) then 
                self.delegate:fortune(self,self.data.id,function ()
                    self:zhaocaimao()
                    self.delegate:refreshEveryPay()
                end) 
            else 
                if (Player.Resource.gold<self.costGold and self.canBuy ) then 
                    MessageMrg.show(TextMap.GetValue("Text_1_100"))
                elseif self.canBuy==false then 
                    MessageMrg.show(TextMap.GetValue("Text_1_101"))
                end 
            end 
        elseif event =="firstPayGift" or event =="dailyGift" or event =="dailyFirstPay" or event =="openGift" then
            self.delegate:getDropPackage(self, self.data.id, "")
        elseif event=="sendActBylevel" then 
            if self.data.status==1 then 
                self.delegate:getDropPackage(self, self.data.id, "")
            elseif self.data.status~=2 and self.data._source_data.level_type=="danchong" then 
                page:OnChongzhi()
            elseif self.data._source_data.level_type=="gold" then 
                if Player.Resource.gold>=tonumber(self.needGoldNum) then 
                    self.delegate:getDropPackage(self, self.data.id, "")
                else 
                    DialogMrg.ShowDialog(TextMap.GetValue("Text368") , function()
                        DialogMrg.chognzhi()
                        end)
                    return
                end 
            elseif self.data._source_data.level_type=="chongzhi" then 
                DialogMrg.ShowDialog("您的充值额度不够，是否前往充值？" , function()
                    DialogMrg.chognzhi()
                    end)
                return
            else 

            end 
        end   
    elseif name == "box_close1" then
        if event == "fortune" then 
            self:ReViewReward(1)
        end
    elseif name == "btnQQAdd" then
        --mysdk:joinQQGroup(self.data.add_qq)
        local row = TableReader:TableRowByID("errCode", "114");
        if row ~= nil then
            local desc = row.desc
            local type = row.type
            if desc == "" or desc == nil then return end
            MessageMrg.show(desc)
        end
    elseif name=="btn_url" then 
            Application.OpenURL(self.url_path)
    elseif name == "box_close2" then
        if event == "fortune" then 
            self:ReViewReward(2)
        end
    elseif name == "box_close3" then
        if event == "fortune" then
            self:ReViewReward(3) 
        end
    elseif name == "box_close4" then
        if event == "fortune" then 
            self:ReViewReward(4)
        end
    elseif name == "btn_notice" then
        if event == "fortune" then 
            UIMrg:pushWindow("Prefabs/moduleFabs/qiancengta/qiancengta_rule", {nil,title = TextMap.GetValue("Text_1_102"),rule=self.data.desc})
        end
    elseif name == "btn_more" then
        if event == "fortune" then 
            local history = Player.Activity[self.data.id].h 
            if history~=nil then 
                local descList = {}
                local desc1 = ""
                if history.Count<=40 then 
                    for i=0,history.Count-1 do
                        local row=TableReader:TableRowByID("fortune",history[i].b)
                        if i<history.Count-1 then 
                            local msg = string.gsub(TextMap.GetValue("LocalKey_795"),"{0}",row.arg3)
                            msg=string.gsub(msg,"{1}",history[i].c)
                            msg=string.gsub(msg,"{1}",history[i].d)
                            desc1= desc1 .. msg
                        else 
                            local msg = string.gsub(TextMap.GetValue("LocalKey_796"),"{0}",row.arg3)
                            msg=string.gsub(msg,"{1}",history[i].c)
                            msg=string.gsub(msg,"{1}",history[i].d)
                            desc1= desc1 .. msg
                        end 
                    end
                else 
                    for i=history.Count-40,history.Count-1 do
                        local row=TableReader:TableRowByID("fortune",history[i].b)
                        if i<history.Count-1 then 
                            desc1= desc1 .. "[ff0000]【" .. row.arg3 .. TextMap.GetValue("Text_1_103") .. history[i].c .. TextMap.GetValue("Text_1_104") .. history[i].d .. TextMap.GetValue("Text_1_105")
                        else 
                            desc1= desc1 .. "[ff0000]【" .. row.arg3 .. TextMap.GetValue("Text_1_103") .. history[i].c .. TextMap.GetValue("Text_1_104") .. history[i].d .. TextMap.GetValue("Text_1_106")
                        end 
                    end
                end 
                UIMrg:pushWindow("Prefabs/moduleFabs/qiancengta/qiancengta_rule", {nil,title = TextMap.GetValue("Text_1_107"),rule=desc1})
            else 
                MessageMrg.show(TextMap.GetValue("Text_1_108"))
            end
        end 
    elseif name =="btn1" then 
        self:onClickYuekaBtn(1)
    elseif name =="btn2" then 
        self:onClickYuekaBtn(2)
    elseif name =="btn3" then 
        self:onClickYuekaBtn(3)
    elseif name =="btn4" then 
        self:onClickYuekaBtn(4)
    elseif name =="btn5" then 
        self:onClickYuekaBtn(5)
    end 
end

function page:OnChongzhi()
    if self.chongzhi_item~=nil then 
        if self.btGet~=nil then 
            self.btGet.isEnabled=false
        end  
        self:refreshDataWhenVip()
        local pay_lv = nil
        if self.data.event=="sendActBylevel" then 
            pay_lv=Player.Activity[self.data.id].level
        end 
        local playerId = Player.playerId
        local rtype = self.chongzhi_item.rtype
        local serverId = PlayerPrefs.GetString("serverId") or NowSelectedServer
        local info = playerId .. "|" .. serverId .. "|" .. rtype .. "|" .. os.time()
        local rate = TableReader:TableRowByID("charge_settings","charge_rate").value
        local money = self.chongzhi_item.cost *100
        if (ClientTool.Platform == "android" or ClientTool.Platform == "ios") and isSdk== 1 then
            Api:getPayUrl(GlobalVar.sdkPlatform, rtype,info,self.chongzhi_item.cost,self.data.id,pay_lv,function(res)
            local count = self.chongzhi_item.cost *tonumber(rate)
            local url = res.url
            local sign =""
            --add by lihui UC6.1.0支付必须要的参数 2017-1-3 19:00
            local accountId = "0"
            if ClientTool.Platform == "ios" or (ClientTool.Platform == "android" and GlobalVar.sdkPlatform == "gump") then
                print("serali iospay2="..tostring(res.ios))
                if res.ios ~= nil then                      
                    accountId = res.ios                         
                else
                    accountId = "1"
                end         
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
                    local payInfo = {}
                    table.insert(payInfo, amount)
                    table.insert(payInfo, id)
                    table.insert(payInfo, unit)
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
                        end)
                end
            end)
        else
            Api:innerPay(Player.playerId, self.chongzhi_item.cost, self.chongzhi_item.rtype,info,self.data.id,pay_lv, function(result)
                if result ~= nil and result.ret == 0 then
                    OperateAlert.getInstance:showToGameObject({ TextMap.GetValue("Text1462") }, self.btGet.gameObject)
                else
                    if self.btGet~=nil then 
                        self.btGet.isEnabled=true
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
end

function page:onClickYuekaBtn(id)
    if self.data.event =="monthCard" then 
        self.yueka_id=id
        if self.yuekaList~=nil and self.yuekaList[id] ~=nil then 
            for i=1,5 do
                if i==id then 
                    self.click_yueka_btn[i]:SetActive(true)
                    self.activityTable:CallUpdate(self.yuekaList[id])
                else 
                    self.click_yueka_btn[i]:SetActive(false)
                end 
            end
        end 
    end 
end

local timerId = 0
function page:refreshCdtime(_time)
    LuaTimer.Delete(timerId)
    timerId = LuaTimer.Add(0,1000, function(id)
        if _time / 1000>os.time() then 
            local time  =Tool.FormatTime(_time / 1000 -os.time()) 
            self.des1.text=string.gsub(TextMap.GetValue("LocalKey_794"),"{0}",time)
            self.btn_label.text=TextMap.GetValue("Text_1_97")
        else  
            self.des1.text=""
            self.isFree=true
            self.btn_label.text=TextMap.GetValue("Text_1_95")
            if self.isFree or self.canBuy then 
                self.btGet.isEnabled=true
            else 
                self.btGet.isEnabled=false
            end 
        end 
    end)
end


-- 分享活动
-- ALREADY_DRAW : 11, //已领取    
 -- CANNOT_SHARE : 12, //不可分享 未激活
    -- CAN_SHARE : 13,    //可分享
    -- CAN_DARW : 14,     //可领取
function page:shareSDK()
    local shareData = require("uLuaModule/modules/shareSDK/shareSDKData.lua")
    self:initShareSDK(shareData)

    -- self.Content.text = self.data.desc
    self.Content.text =  TextMap.GetValue("Text421")
    local list = {}
    local index = 1;

    table.sort(self.data.status,function (x,y)
        return x.value > y.value
    end)

    self:createShareDataForItme()
    for k, v in pairs(self.data.drop) do
        table.insert(list, { delegate = self, drop = v, package = self.data.package[k] ,status = self.data.status[k],shareData = shareData, gid = k})
    end
    table.sort(list,function ( x,y )
        local levelx = string.sub(x.gid,3,6)
        local levely = string.sub(y.gid,3,6)

        if tonumber(x.status) > 12 or tonumber(y.status) > 12 then
            return x.status > y.status
        end

        if (tonumber(x.status) > 10 and tonumber(x.status) < 13) and (tonumber(y.status) > 10 and tonumber(y.status) < 13) then
            return x.status > y.status
        end



        return levelx<levely
        
    end)

    -- print_r(list)
    ClientTool.UpdateGrid("", self.grid, list)

end

function page:createShareDataForItme()
    self.data.package = {}
    self.data.drop = {}
 
    TableReader:ForEachLuaTable("ShareTasks",function(k,v) 
        local packageData = {}
        packageData["id"] = v["id"]
        packageData["name"] = v["share_condition"]
        -- table.insert(self.data.package,packageData)
        self.data.package[v["id"]] = packageData
        self.data.drop[v["id"]] = v["drop"]
        -- table.insert(self.data.drop,dropData)
        return false
    end)
end

-- 初始化ShareSDK
function page:initShareSDK(shareData)
    -- 初始化平台
    ShareSDKManager.initShareSDK("GameManager")
    -- 初始化渠道    
    local platformInfo = shareData["platform"]
    local appJson = SettingConfig.getShareSDKConfig(GlobalVar.dataEyeChannelID,GlobalVar.gameName)

    table.foreach(appJson,function (i,v)
        local data = json.encode(v)
        ShareSDKManager.initShareSDKPlatform(v["name"],data)
    end)
end


function page:wishingWell()
    self.wishiItems:CallUpdate(self.data)
end


function page:agencyGod(up)
    --死神代理
    self.Content.text = self.data.desc

    ClientTool.AddClick(self.btn, function()
        uSuperLink.openModule(68)
    end)

    if myFont == nil then
        myFont = GameManager.GetFont()
        self.Content.bitmapFont = myFont
        self.btn.transform:GetChild(0).gameObject:GetComponent(UILabel).bitmapFont = myFont
    end
end

function page:countMutliPoint(add)
    if add then self.mutliPoint = self.mutliPoint + 1
    else self.mutliPoint = self.mutliPoint - 1
    end
    self.delegate:countRedPoint(add)
end

function page:hideRedPoint()
    self.delegate.rp[self.data.id] = false
end

function page:getCallBack()
    local event = self.data.event
    if event == "dailyGift" or event == "dailyFirstPay" or event == "firstPayGift" or event=="openGift" then
        self.lbTip.text = TextMap.GetValue("Text397")
        self.btGet.isEnabled=false
        self.data.status = 2
        self.delegate:countRedPoint(false)
    elseif event == "getBP" then
        self.btGet.transform:Find("Label"):GetComponent("UILabel").text = TextMap.GetValue("Text422")
        self.btGet.color = Color(0.5, 0.5, 0.5)
        self.data.status = 6
        self.sp_food:SetActive(false)
        self.delegate:countRedPoint(false)
    elseif event == "doubleMoney" then
        self.btGet.transform:Find("Label"):GetComponent("UILabel").text = TextMap.GetValue("Text423")
        self.btGet.color = Color(0.5, 0.5, 0.5)
        self.data.status = 0
        if self.effect then
            self.effect:SetActive(false)
            self.effect:SetActive(true)
        end
        self.delegate:countRedPoint(false)
    elseif event == "monthCard" then
        self.delegate:countRedPoint(false)
    elseif event == "sendActBylevel" then
        page:sendActBylevel()
    elseif event == "vipGift" then
    elseif event == "everyPay" then
        --self.delegate:refreshEveryPay()
    elseif event == "investPlan" then
        page:refreshDataWhenVip()
    elseif event == "loginGift" then
        self.delegate:refreshEveryPay()
    elseif event == "lvlup" then
        --self.delegate:refreshEveryPay()
    elseif event == "limitChange" then
        self.delegate:refreshEveryPay()
    elseif event == "challengeWinReward" then
        self.delegate:refreshEveryPay()
    elseif event == "turnTable" then
        self.delegate:refreshEveryPay()
    elseif event == "login30" then
        self.delegate:refreshEveryPay()
    elseif event == "totalPay" then
        self.delegate:refreshEveryPay()
    elseif event == "totalCost" then
        self.delegate:refreshEveryPay()
    elseif event == "shareSDK"  then
        self.delegate:refreshEveryPay()
    end
end

function page:OnDestroy()
    LuaTimer.Delete(time_send)
end

function page:refreshDataWhenVip( ... )
    Player.Resource:addListener("vipMenucurrency", "vip_exp", function(key, attr, newValue)
        print("refresh")
        self.delegate:refreshEveryPay()
        Player:removeListener("vipMenucurrency")
    end)
end

function page:OnDisable()
    Player:removeListener("vipMenucurrency")
end

-- 活动-封测每日送福利  // 每日首充礼包
function page:dailyGift(up)
    self:firstPayGift(up)
end


--// 每日首充礼包
function page:dailyFirstPay(up)
    self:firstPayGift(up)
end

local __rewardString = ""
local rank_index = { 0, 1, 2, 5, 20, 100 }

local maxRank = 0
function page:SetmaxRank()
    return maxRank
end


function page:getTextReward(reward, index)
    __rewardString = ""
    local list = {}
    if index == nil then index = 10000 end
    if reward then
        local function getItemName(name, count)
            return "[ffffff]" .. name .. "[-][ffd200] x" .. count .. " "
        end
        local isMeRank = false
        local rank = tonumber(index) or 9999
        local ii = 1
        for k, v in pairs(reward) do
            local rankId = self.data.package[k].id
            local numRank = tonumber(rankId)
            if numRank == nil then
                local tb = split(rankId, "-")
                local one = tonumber(tb[1]) or 0
                local two = tonumber(tb[2]) or 0
                if maxRank < two then maxRank = two end
                if (rank >= one and rank <= two) then
                    __rewardString = ""
                    isMeRank = true
                end
            else
                if maxRank < numRank then maxRank = numRank end
                if rank == numRank then
                    __rewardString = ""
                    isMeRank = true
                end
            end

            local li = {}
            table.foreach(v, function(i, item)
                local _type = item.type
                if _type == "char" then
                    local vo = Char:new(item.arg)
                    if vo.info.level > 0 then
                        vo = CharPiece:new(vo.id)
                        vo.rwCount = vo.needCharNumber
                    end
                    if isMeRank == true then
                        __rewardString = __rewardString .. getItemName(vo.name, vo.rwCount or 1)
                    end
                    vo.__tp = "char"
                    table.insert(li, vo)
                    vo = nil
                else
                    local vo = itemvo:new(item.type, item.arg2, item.arg)
                    if isMeRank == true then
                        print(vo.itemName)
                        __rewardString = __rewardString .. getItemName(vo.itemName, vo.itemShowCount or 1)
                    end
                    vo.__tp = "vo"
                    table.insert(li, vo)
                    vo = nil
                end
            end)
            isMeRank = false
            -- table.insert(list, { _rank = tonumber(k),li = li })
            table.insert(list, { rank = rankId, li = li })
        end
    end
    return list
end
--活动-排行榜活动汇总
function page:rankActivity()
    self.act_rank_obj:CallUpdate({delegate = self,data = self.data})
end

--活动-连续5日充值送豪礼
function page:dailyPay()
    self.act_dailypay_obj:CallUpdate({lua_data = self.data,delegate = self})
end


-- 活动-寻找最强战力
function page:rankPower(up)
    local btGet = self.btn_get:GetComponent("UIButton")
    local lbTip = btGet.transform:Find("txt_btn_name"):GetComponent("UILabel")
    if self.data.status == 1 then
        self.delegate:countRedPoint(true)
        lbTip.text = TextMap.GetValue("Text376")
        btGet.isEnabled = true
    elseif self.data.status == 2 then
        lbTip.text = TextMap.GetValue("Text397")
        btGet.isEnabled = false
    else
        lbTip.text = TextMap.GetValue("Text376")
        btGet.isEnabled = false
    end
    if up then return end
    self.Content.text = self.data.desc
    local rank = self.data.rank
    local list = {}
    local rankList = {}
    local index = 0
    if rank ~= nil then
        for k, v in pairs(rank) do
            if index < 3 then
                table.insert(list, { name = v.name, num = v.power, vip = v.vip })
            end
            table.insert(rankList, { name = v.name, num = v.power, vip = v.vip, rank = index + 1, _type = "power" })
            index = index + 1
        end
    end
    local source = self.data._source_data

    local me = source["self"] or {}

    for i = 1, 3 do
        self["rankItem" .. i]:CallUpdate(list[i])
    end
    local _list = page:getTextReward(self.data.drop, me.rank)

    if me.rank == nil then
        self.unrank:SetActive(true)
        self.binding:Hide("txt_rank")
        self.binding:Hide("txt_power")
        self.binding:Hide("txt_reward")
    else
        self.binding:Show("txt_reward")
        if __rewardString == "" or __rewardString == nil then
            __rewardString = TextMap.GetValue("Text425")
        end
        self.txt_reward.text = __rewardString

        self.unrank:SetActive(false)
        self.binding:Show("txt_rank")
        self.binding:Show("txt_power")
        self.txt_rank.text = me.rank or "0"
        self.txt_power.text = me.power or "0"
    end

    if index > 3 then --表示活动已经结束
    self.rankTXT.text = TextMap.GetValue("Text426")
    else
        self.rankTXT.text = TextMap.GetValue("Text321")
    end

    ClientTool.AddClick(self.btn_get, function()
        self.delegate:getDropPackage(self, self.data.id, "", function()
            lbTip.text = TextMap.GetValue("Text397")
            btGet.isEnabled = false
        end)
    end)
    ClientTool.AddClick(self.btn_rank, function()
        if index > 3 then
            if #rankList == 0 then return end
            UIMrg:pushWindow("Prefabs/moduleFabs/activityModule/act_rank_list", { list = rankList, me = { name = Player.Info.nickname, num = me.power or "0", vip = Player.Info.vip, rank = me.rank, _type = "power" } })
        else
            uSuperLink.openModule(122)
        end
    end)
    ClientTool.AddClick(self.btn_reward_info, function()
        UIMrg:pushWindow("Prefabs/moduleFabs/activityModule/act_rank_reward_info", _list)
    end)
end



-- 活动-战队等级大冲刺
function page:rankLvl(up)
    local btGet = self.btn_get:GetComponent("UIButton")
    local lbTip = btGet.transform:Find("txt_btn_name"):GetComponent("UILabel")
    --print("self.data.status"..self.data.status)
    if self.data.status == 1 then
        self.delegate:countRedPoint(true)
        lbTip.text = TextMap.GetValue("Text376")
        btGet.isEnabled = true
    elseif self.data.status == 2 then
        lbTip.text = TextMap.GetValue("Text397")
        btGet.isEnabled = false
    else
        lbTip.text = TextMap.GetValue("Text376")
        btGet.isEnabled = false
    end
    if up then return end
    self.Content.text = self.data.desc
    local rank = self.data.rank
    local list = {}
    local index = 0
    local rankList = {}
    if rank ~= nil then
        for k, v in pairs(rank) do
            if index < 3 then
                table.insert(list, { name = v.name, num = "Lv." .. v.level, vip = v.vip })
            end
            local m = {}
            m.name = v.name
            m.num = v.level
            m.vip = v.vip
            m.rank = index + 1
            m._type = "level"
            table.insert(rankList, m)
            m = nil
            --  table.insert(rankList, { name = v.name, num = "Lv." .. v.level, vip = v.vip, rank = v.rank, _type="level" })
            index = index + 1
        end
    end

    print("list count " .. table.getn(rankList))
    for i = 1, 3 do
        self["rankItem" .. i]:CallUpdate(list[i])
    end
    local source = self.data._source_data

    local me = source["self"] or {}
    local _list = page:getTextReward(self.data.drop, me.rank)
    --    Tool.SetActive(self.txt_reward,__rewardString ~= nil)
    --    self.txt_reward.text = __rewardString
    if me.rank == nil then
        --        self.unrank:SetActive(true)
        --        self.binding:Hide("txt_rank")
        --        self.binding:Hide("txt_power")
        self.binding:Hide("txt_reward")
        self.txt_rank.text = TextMap.GetValue("Text427")

        self.txt_power.text = "Lv." .. (Player.Info.level or "0")
    else
        self.binding:Show("txt_reward")
        if __rewardString == "" or __rewardString == nil then
            __rewardString = TextMap.GetValue("Text425")
        end
        self.txt_reward.text = __rewardString
        --        self.unrank:SetActive(false)
        self.binding:Show("txt_rank")
        self.binding:Show("txt_power")
        self.txt_rank.text = me.rank or "0"
        self.txt_power.text = "Lv." .. (me.level or "0")
    end

    ClientTool.AddClick(self.btn_get, function()
        self.delegate:getDropPackage(self, self.data.id, "", function()
            lbTip.text = TextMap.GetValue("Text397")
            btGet.isEnabled = false
        end)
    end)
    if index > 3 then --表示活动已经结束
    self.rankTXT.text = TextMap.GetValue("Text426")
    else
        self.rankTXT.text = TextMap.GetValue("Text321")
    end


    --当活动结束之后排行榜按钮变成获奖名单按钮
    ClientTool.AddClick(self.btn_rank, function()
        --活动结束
        if index > 3 then
            -- UIMrg:pushWindow("Prefabs/moduleFabs/activityModule/act_rank_list", rankList)
            if #rankList == 0 then return end
            UIMrg:pushWindow("Prefabs/moduleFabs/activityModule/act_rank_list", { list = rankList, me = { name = Player.Info.nickname, num = "Lv." .. Player.Info.level, vip = Player.Info.vip, rank = me.rank or "10000", _type = "level" } })

        else
            uSuperLink.openModule(121)
        end
    end)
    ClientTool.AddClick(self.btn_reward_info, function()
        UIMrg:pushWindow("Prefabs/moduleFabs/activityModule/act_rank_reward_info", _list)
    end)
end

function page:onUpdatePayRank(data)
    local rankList = {}
    local list = {}
    local rank = data.rank
    if rank ~= nil then
        local index = 0
        for i = 0, rank.Count - 1 do
            v = rank[i]
            if index < 3 then
                table.insert(list, { name = v.name, num = "Lv." .. v.level, vip = v.vip })
                -- self.rankList[i+1] = { name = v.name, num = "Lv." .. v.level, vip = v.vip }
                local m = {}
                m.name = v.name
                m.money = v.money
                m.num = v.level
                m.rank_multiple = source.rank_multiple
                m.vip = v.vip
                m.rank = index + 1
                m.max = maxRank
                m._type = "pay"
                self.rankList[i + 1] = m
            end
            index = index + 1
        end
    end
    for i = 1, 3 do
        self["rankItem" .. i]:CallUpdate(list[i])
    end
end

function page:onUpdateJJC(data)
    local rankList = {}
    local list = {}
    local rank = data.rank
    if rank ~= nil then
        local index = 0
        for i = 0, rank.Count - 1 do
            v = rank[i]
            if index < 3 then
                table.insert(list, { name = v.name, num = v.power, vip = v.vip })
                local m = {}
                m.name = v.name
                m.num = v.power
                m.vip = v.vip
                m.rank = index + 1
                m.max = maxRank
                m._type = "power"
                self.rankList[i + 1] = m
            end
            index = index + 1
        end
    end
    for i = 1, 3 do
        self["rankItem" .. i]:CallUpdate(list[i])
    end
end

local inited = false
function page:rankJJC(up)
    ActivityJJC = true
    Events.RemoveListener("onUpdateJJC")
    Events.AddListener("onUpdateJJC", funcs.handler(self, self.onUpdateJJC))
    if inited == false then
        inited = true
        self.title.Url = UrlManager.GetImagesPath("activity/HD-shiqiangsonghaoli.png")
    end
    local t = self.title:GetComponent(UITexture)
    t.width = 430
    t.height = 140
    self.Content.text = self.data.desc
    local rank = self.data.rank
    local list = {}
    local rankList = {}
    local index = 0
    local source = self.data._source_data

    local me = source["self"] or {}
    local _list = page:getTextReward(self.data.drop, me.rank)

    if rank ~= nil then

        for k, v in pairs(rank) do
            if index < 3 then
                table.insert(list, { name = v.name, num = v.power, vip = v.vip })
            end
            local m = {}
            m.name = v.name
            m.num = v.power
            m.rank_multiple = source.rank_multiple
            m.vip = v.vip
            m.rank = index + 1
            m.max = maxRank
            m._type = "power"
            table.insert(rankList, m)
            m = nil
            index = index + 1
        end
    end
    for i = 1, 3 do
        self["rankItem" .. i]:CallUpdate(list[i])
    end
    self.binding:Hide("txt_reward")
    self.binding:Hide("txt_rank")
    self.binding:Hide("txt_power")
    self.binding:Hide("unrank")

    local go = self.gameObject.transform:Find("panel/left/info/reward_info")
    Tool.SetActive(go, false)

    local btGet = self.btn_get:GetComponent("UIButton")
    local lbTip = btGet.transform:Find("txt_btn_name"):GetComponent("UILabel")
    if self.data.status == 1 then
        self.delegate:countRedPoint(true)
        lbTip.text = TextMap.GetValue("Text376")
    else
        lbTip.text = TextMap.GetValue("Text428")
    end
    local that = self
    ClientTool.AddClick(self.btn_get, function()
        if that.data.status == 1 then
            self.delegate:getDropPackage(self, self.data.id, "", function()
                that.data.status = 2
                lbTip.text = TextMap.GetValue("Text428")
            end)
            return
        end
        UIMrg:pushWindow("Prefabs/moduleFabs/activityModule/act_rank_reward_info", _list)
    end)
    if that.data.status ~= 0 then --表示活动已经结束
    self.rankTXT.text = TextMap.GetValue("Text426")
    else
        self.rankTXT.text = TextMap.GetValue("Text429")
    end
    self.rankList = rankList

    ClientTool.AddClick(self.btn_rank, function()
        UIMrg:pushWindow("Prefabs/moduleFabs/activityModule/act_rank_list_noLevel", {
            list = that.rankList,
            me = me,
            title = that.rankTXT.text,
            type = "power",
            rank_multiple = source.rank_multiple or 0
        })
    end)


    if _list[1] and _list[1].li then
        local items = _list[1].li
        for i = 1, #items do
            local char = items[i]
            if char.getType and (char:getType() == "char" or char:getType() == "charPiece") then
                if self._heroImge == nil then
                    local info = self.gameObject.transform:Find("panel/left/info")
                    self._heroImge = page:createTexture("img_hero", Vector3(150, -2, 0), info, 480, 320, 1)

                    local rank_info_bg = self.rank_info_bg.gameObject
                    self.btn_check = page:createTexture("btn_check", Vector3(140, 0, 0), self.rank_info_bg.transform, 74, 70, 34)
                    self.btn_check.Url = UrlManager.GetImagesPath("activity/ytddquj_01.png")
                    self.btn_check.gameObject:AddComponent(BoxCollider)
                    self.btn_check:GetComponent(UITexture):ResizeCollider()
                    ClientTool.AddClick(self.btn_check, function()
                        local item = char
                        if char:getType() == "char" then item = char:getPiece() end
                        Tool.push("heroInfo", "Prefabs/moduleFabs/hero/hero_info", item)
                    end)
                    local lab = self.txt_rank.transform:GetChild(0)
                    go = NGUITools.AddChild(rank_info_bg, lab.gameObject)
                    self._heroName = go:GetComponent(UILabel)
                    self._heroName.applyGradient = false
                end
                self._heroImge.Url = char:getImage()
                self._heroName.text = Tool.getNameColor(char.star) .. char:getDisplayName() .. "[-]"
            end
        end
    end
end

--活动-充值排行
function page:rankPay(up)
    local btGet = self.btn_get:GetComponent("UIButton")
    local lbTip = btGet.transform:Find("txt_btn_name"):GetComponent("UILabel")
    if self.data.status == 1 then
        self.delegate:countRedPoint(true)
        lbTip.text = TextMap.GetValue("Text376")
    else
        lbTip.text = TextMap.GetValue("Text428")
    end
    if up then return end
    ActivityPay = true
    Events.RemoveListener("onUpdatePayRank")
    Events.AddListener("onUpdatePayRank", funcs.handler(self, self.onUpdatePayRank))
    self.Content.text = self.data.desc
    local rank = self.data.rank
    local list = {}
    local index = 0
    local rankList = {}
    local source = self.data._source_data
    local me = source["self"] or {}
    local _list = page:getTextReward(self.data.drop, me.rank)
    if rank ~= nil then
        for k, v in pairs(rank) do
            if index < 3 then
                table.insert(list, { name = v.name, num = "Lv." .. v.level, vip = v.vip })
            end
            local m = {}
            m.name = v.name
            m.money = v.money
            m.num = v.level
            m.rank_multiple = source.rank_multiple
            m.vip = v.vip
            m.rank = index + 1
            m.max = maxRank
            m._type = "pay"
            table.insert(rankList, m)
            m = nil
            index = index + 1
        end
    end

    for i = 1, 3 do
        self["rankItem" .. i]:CallUpdate(list[i])
    end

    self.binding:Hide("txt_reward")
    self.binding:Hide("txt_rank")
    local go = self.gameObject.transform:Find("panel/left/info/reward_info")
    Tool.SetActive(go, false)

    
    local that = self
    ClientTool.AddClick(self.btn_get, function()
        if that.data.status == 1 then
            self.delegate:getDropPackage(self, self.data.id, "", function()
                lbTip.text = TextMap.GetValue("Text428")
                that.data.status = 2
                -- btGet.isEnabled = false
            end)
            return
        end
        UIMrg:pushWindow("Prefabs/moduleFabs/activityModule/act_rank_reward_info", _list)
    end)
    if that.data.status ~= 0 then --表示活动已经结束
    self.rankTXT.text = TextMap.GetValue("Text426")
    else
        self.rankTXT.text = TextMap.GetValue("Text429")
    end

    self.rankList = rankList
    local that = self
    --当活动结束之后排行榜按钮变成获奖名单按钮
    ClientTool.AddClick(self.btn_rank, function()
        UIMrg:pushWindow("Prefabs/moduleFabs/activityModule/act_rank_list_noLevel", { list = that.rankList, me = me, title = that.rankTXT.text, rank_multiple = source.rank_multiple })
    end)
    if _list[1] and _list[1].li then
        local items = _list[1].li
        for i = 1, #items do
            local char = items[i]
            if char.getType and (char:getType() == "char" or char:getType() == "charPiece") then
                if self._heroImge == nil then
                    local info = self.gameObject.transform:Find("panel/left/info")
                    self._heroImge = page:createTexture("img_hero", Vector3(150, -2, 0), info, 480, 320, 1)

                    local rank_info_bg = self.rank_info_bg.gameObject
                    self.btn_check = page:createTexture("btn_check", Vector3(140, 0, 0), self.rank_info_bg.transform, 74, 70, 34)
                    self.btn_check.Url = UrlManager.GetImagesPath("activity/ytddquj_01.png")
                    self.btn_check.gameObject:AddComponent(BoxCollider)
                    self.btn_check:GetComponent(UITexture):ResizeCollider()
                    ClientTool.AddClick(self.btn_check, function()
                        local item = char
                        if char:getType() == "char" then item = char:getPiece() end
                        Tool.push("heroInfo", "Prefabs/moduleFabs/hero/hero_info", item)
                    end)
                    local lab = self.txt_rank.transform:GetChild(0)
                    go = NGUITools.AddChild(rank_info_bg, lab.gameObject)
                    self._heroName = go:GetComponent(UILabel)
                    self._heroName.applyGradient = false
                end
                self._heroImge.Url = char:getImage()
                self._heroName.text = Tool.getNameColor(char.star) .. char:getDisplayName() .. "[-]"
            end
        end
    end
end

function page:createTexture(name, pos, parent, width, height, depth)
    local go = GameObject(name)
    go.transform.parent = parent
    go.transform.localPosition = pos
    go.transform.localScale = Vector3.one
    local tx = go:AddComponent(UITexture)
    tx.depth = depth
    tx.width = width
    tx.height = height
    local img = go:AddComponent(SimpleImage)
    return img
end

-- 活动-首充双倍超值大礼
function page:firstPayGift(up)
    if not up then 
        if self.data.event=="dailyFirstPay" then 
            self.title_xiao.text=TextMap.GetValue("Text_1_109")
        elseif self.data.event=="firstPayGift" then 
            self.title_xiao.text=TextMap.GetValue("Text_1_110") 
        elseif self.data.event=="dailyGift" then 
            self.title_xiao.text=TextMap.GetValue("Text_1_111") 
        elseif self.data.event=="openGift" then 
            self.title_xiao.text=TextMap.GetValue("Text_1_112") 
        end 
    end 
    if self.data.status == 1 then
        self.delegate:countRedPoint(true)
        self.lbTip.text = TextMap.GetValue("Text430")
        self.btGet.isEnabled=true
    elseif self.data.status == 2 then
        self.lbTip.text = TextMap.GetValue("Text397")
        self.btGet.isEnabled=false
    elseif self.data.status == 3 then
        self.lbTip.text = TextMap.GetValue("Text424")
        self.btGet.isEnabled=true
    end
    if not up then
        ClientTool.UpdateMyTable("Prefabs/moduleFabs/activityModule/itemActivity", self.Table, self.data.drop)
        if #self.data.drop > 5 then
            self.binding:CallManyFrame(function()
                self.scrollView:SetDragAmount(0, 0, false)
            end)
        end
    end
end

-- 活动-开服七日送豪礼   
function page:serverGift(up)
    if up then return end

    self.Content.text = self.data.desc
    local list = {}
    local first = true
    local index = 0
    local realIndex = 0
    local count = table.getn(self.data.drop) - 1
    for k, v in pairs(self.data.drop) do
        if first then
            local st = self.data.status[self.data.package[k].id]
            if st == 1 then
                self.delegate:countRedPoint(true)
                first = false
                realIndex = index
            end
        end
        index = index + 1

        table.insert(list, { delegate = self, drop = v, package = self.data.package[k] })
    end
    ClientTool.UpdateGrid("", self.grid, list)
    if first == false then
        self.binding:CallManyFrame(function()
            self.view:SetDragAmount(0, realIndex / count, false)
        end, 3)
    end
end


-- 活动-升级福利疯狂送
function page:lvlup(up)
    if up then 
        if self.selectItem_cur~=nil then 
            self.selectItem_cur:getCallBack()
        end 
        return 
    end
    local list = {}
    local past_list = {}
    local first = true
    local index = 0
    local count = table.getn(self.data.drop)
    local find = 0
    local extra_drop = self.data.extra_drop
    for k, v in pairs(self.data.drop) do
        local data = {}

        table.foreach(v, function(i, item)
            local _type = item.type
            if _type == "char" then
                local vo = Char:new(item.arg)
                if vo.info.level > 0 then
                    vo = CharPiece:new(vo.id)
                    vo.rwCount = vo.needCharNumber
                end
                vo.__tp = "char"
                table.insert(data, vo)
            else
                local vo = itemvo:new(item.type, item.arg2, item.arg)
                vo.__tp = "vo"
                table.insert(data, vo)
            end
        end)
        local extra_item = nil
        local item = extra_drop[k]
        if item then
            if item[1] then
                local _item = item[1]
                local _type = _item.type
                if _type == "char" then
                    local vo = Char:new(_item.arg)
                    if vo.info.level > 0 then
                        vo = CharPiece:new(vo.id)
                        vo.rwCount = vo.needCharNumber
                    end
                    vo.__tp = "char"
                    extra_item = vo
                else
                    local vo = itemvo:new(_item.type, _item.arg2, _item.arg)
                    vo.__tp = "vo"
                    extra_item = vo
                end
            end
        end
        local status = self.data._source_data.status[k] 
        local time_status = 1
        if status~=nil and status.status~=nil and status.status.time~=nil and status.status.time/1000<os.time() then 
            print (TextMap.GetValue("Text_1_91"))
            time_status = 0
            table.insert(past_list, { extra_drop = extra_item, delegate = self, drop = data, package = self.data.package[k],k=k, time_status = time_status })
        elseif status~=nil and status.status~=nil and status.status.status~=nil and status.status.status>3 then
            print (TextMap.GetValue("Text_1_91")) 
            time_status = 0
            table.insert(past_list, { extra_drop = extra_item, delegate = self, drop = data, package = self.data.package[k],k=k, time_status = time_status })
        elseif status~=nil and status.status~=nil and status.status.status~=nil and status.status.status==2 then
            table.insert(past_list, { extra_drop = extra_item, delegate = self, drop = data, package = self.data.package[k],k=k, time_status = time_status })
        else
            table.insert(list, { extra_drop = extra_item, delegate = self, drop = data, package = self.data.package[k],k=k, time_status = time_status })
        end
    end
    if #past_list > 0 then 
        for i = 1, #past_list do 
              table.insert(list, past_list[i])
        end 
    end
    for i,v in ipairs(list) do
        if first and v.time_status ~= 0 then
            local sst = 0
            local st = self.data._source_data.status[v.k].status or {}
            st=st.status
            if self.data.extra_status then
                sst = self.data.extra_status[v.k]
            end
            if self.data._source_data.status[v.k].pay~=nil and Player.Info.level>=tonumber(self.data._source_data.status[v.k].id) and (self.data._source_data.status[v.k].status==nil or self.data._source_data.status[v.k].status.status~=2) then
                first = false
                find = index
            elseif st == 1 or sst == 1 then
                first = false
                find = index
            end
            index = index + 1
        end
    end
    self.table:refresh(list, self, false, 0)
    self.binding:CallAfterTime(0.1,function()
        print("定位" .. find)
        self.table:goToIndex(find)
    end)
end

--活动-累计充值豪华礼包0    --活动-累计消耗送礼包
function page:totalPay(up, event) 
    if self.data.event=="totalCost" then 
        self.container.text=TextMap.GetValue("Text_1_113")
    else
        self.container.text=TextMap.GetValue("Text_1_114")
    end
    local list = {}
    local first = true
    local index = 0
    local realIndex = 0
    local nextKey = 0
    local nowCost = self.data.cost
    local curCost = Player.Activity[self.data.id].total
    local count = table.getn(self.data.drop) - 1
    local isFind = false
    for k, v in pairs(self.data.drop) do
        local st = self.data.status[self.data.package[k].id]
        if isFind ~= true then
            if k == 1 and nowCost < tonumber(self.data.package[k].id) then
                nextKey = self.data.package[k].id
                isFind = true
            elseif k == count + 1 and nowCost > tonumber(self.data.package[k].id) then
                nextKey = self.data.package[k].id
                isFind = true
            elseif k <= count and nowCost >= tonumber(self.data.package[k].id) and tonumber(self.data.package[k + 1].id) > nowCost then
                nextKey = self.data.package[k + 1].id
                isFind = true
            end
        end
        table.insert(list, { delegate = self, drop = v, event_type = event ,package = self.data.package[k] ,
            selectIcon = self.data.selectIcon[self.data.package[k].id],
            selectName = self.data.selectName[self.data.package[k].id],
            selectPackage = self.data.selectPackage[self.data.package[k].id]
            })
    end

    table.sort(list, function(a, b)
        if b ~= nil then
            a_status = a.delegate.data.status[a.package.id] or -1
            b_status = b.delegate.data.status[b.package.id] or -1
            if a_status ~= b_status then
                if a_status == 2 then  return false --待领取的状态最前面，再是进行中，最后是领取完成
                elseif b_status == 2 then return true
                else return a_status > b_status
                end
            elseif a.package.id ~= b.package.id then 
                return tonumber(a.package.id) < tonumber(b.package.id)
            end
        end
    end)
    for k,v in ipairs(list) do
        if first then
            local st = self.data.status[v.package.id]
            if st == 1 then
                first = false
                realIndex = index
            end
        end
        index = index + 1
    end

    local nextCost = tonumber(nextKey)
    nowCost = tonumber(nowCost)
    local num = 0
    if nextCost <= 0 then
        nextCost = nowCost
        num = 1
    else
        num = nowCost / nextCost
    end
    self.sliderVip.value = num
    self.labPieceCount.text = "[01ff13]" .. (nowCost) .. "[-]" .. "/" .. (nextCost)
    self.table:refresh(list, self,true, 0)
    self.binding:CallAfterTime(0.1,function()
        self.table:goToIndex(realIndex)
    end)
end

--活动-每日首冲大礼包
function page:everyPay(up)
    if up then 
        if self.selectItem_cur~= nil then 
            self.selectItem_cur:getCallBack()
        end 
        return 
    end 
    local list = {}
    local _list = {}
    local first = true
    local index = 0
    local find=0
    local count = table.getn(self.data.drop)
    local extra_drop = self.data.extra_drop
    local _sort = self.data._source_data.sort or {}
    local num_rate = TableReader:TableRowByID("charge_settings","Num_rate").value
    local charge_rate = TableReader:TableRowByID("charge_settings","charge_rate").value
    for k, v in pairs(self.data.drop) do
        local data = {}
		
        table.foreach(v, function(i, item)
            local _type = item.type
            if _type == "char" then
                local vo = Char:new(item.arg)
                if vo.info.level > 0 then
                    vo = CharPiece:new(vo.id)
                    vo.rwCount = vo.needCharNumber
                end
                vo.item=item
                vo.__tp = "char"
                table.insert(data, vo)
            else
                local vo = itemvo:new(item.type, item.arg2, item.arg)
                vo.__tp = "vo"
                vo.item=item
                table.insert(data, vo)
            end
        end)
        local extra_item = nil
        if extra_drop~=nil and table.getn(extra_drop)>0 then 
            local item = extra_drop[k]
            if item then
                if item[1] then
                    local _item = item[1]
                    local _type = _item.type
                    if _type == "char" then
                        local vo = Char:new(_item.arg)
                        if vo.info.level > 0 then
                            vo = CharPiece:new(vo.id)
                            vo.rwCount = vo.needCharNumber
                        end
                        vo.__tp = "char"
                        extra_item = vo
                    else
                        local vo = itemvo:new(_item.type, _item.arg2, _item.arg)
                        vo.__tp = "vo"
                        extra_item = vo
                    end
                end
            end
        end  
        local __id = self.data.package[k].id
        local st = self.data.status[__id]
        local sort = _sort[__id] or 0

        local price = self.data.package[k].id/tonumber(num_rate)
        local line = nil
        TableReader:ForEachLuaTable("shopPurchase", function(index, item)
            if tonumber(item.cost)==tonumber(price) and item.rtype~="invest" and string.sub(item.rtype,0,5)~="yueka" then
                line=item
            end
            return false
        end)
        if st == 2 then
            table.insert(_list, {type="everyPay", extra_drop = extra_item, delegate = self, drop = data, package = self.data.package[k],index=index,sort=tonumber(sort),chongzhi_item=line})
        else 
            table.insert(list, {type="everyPay", extra_drop = extra_item, delegate = self, drop = data, package = self.data.package[k],index=index,sort=tonumber(sort),chongzhi_item=line})
        end

		-- 加入基础钻石
        local firstPay = self:getfirst(line.id)
        price = tonumber(price) * charge_rate
        local drop = {}
        if line.firstdrop~=nil then 
            if firstPay==0 then 
                drop=line.firstdrop
            elseif firstPay==1 then 
                drop=line.drop
            end 
        end 
        for i=0,drop.Count-1 do
            if drop[i].type=="gold"then
                price=price+drop[i].arg
            end  
        end
		local item_base = {type = "gold", arg = price.."", arg2 = ""}
		local vo_base = itemvo:new("gold", "", price)
        vo_base.__tp = "vo"
		vo_base.is_gold_base = true
        vo_base.item=item_base
        table.insert(data, vo_base)		
    end
    table.sort(_list, function(a,b)
        return tonumber(a.sort)<tonumber(b.sort)
    end )
    table.sort(list, function(a,b)
        return tonumber(a.sort)<tonumber(b.sort)
    end )
    for i,v in ipairs(_list) do
        table.insert(list,v)
    end
    index=0
    if first then 
        for k, v in pairs(list) do
            if first then 
                local __id = v.package.id
                local sst = 0
                local st = self.data.status[__id]
                if self.data.extra_status then
                    sst = self.data.extra_status[__id]
                end
                if st == 1 or sst == 1 then
                    first = false
                    find = index
                end
            end 
            index = index + 1
        end 
    end 
    index=0
    if first then 
        for k, v in pairs(list) do
            if first then 
                local __id = v.package.id
                local sst = 0
                local st = self.data.status[__id]
                if self.data.extra_status then
                    sst = self.data.extra_status[__id]
                end
                if st ~= 2 and (sst ~= nil and sst ~= 2) then
                    first = false
                    find = index
                end
            end 
            index = index + 1
        end 
    end 
    print(find)
    self.table:refresh(list, self, true, 0)
    self.binding:CallAfterTime(0.1,function()
        self.table:goToIndex(find)
    end)
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

function page:refreshinvestPlan( ... )
    local getNum = 0
    local notGet=0
    for k, v in pairs(self.data.drop) do
        if self.data.status[self.data.package[k].id]==2 then 
            getNum=getNum+v[1].arg
        else 
            notGet=notGet+v[1].arg
        end
    end
    self.getLabel1.text=TextMap.GetValue("Text_1_115") .. getNum
    self.getLabel2.text=TextMap.GetValue("Text_1_116") .. notGet
end

--活动-成长基金
function page:investPlan(up)
    --获取级别可领取的列表
    local _list = {}
    local getNum = 0
    local notGet=0
    local first = true
    local find = 0
    local index = 0
    for k, v in pairs(self.data.drop) do
        if self.data.status[self.data.package[k].id]==2 then 
            getNum=getNum+v[1].arg
        else 
            notGet=notGet+v[1].arg
            if first then
                first = false
                find = index
            end
        end 
        index = index + 1
        local m = {}
        m.lv = self.data.package[k].id
        m.drop = v
        m.package = self.data.package[k]
        table.insert(_list, m)
        m = nil
    end
    self.getLabel1.text=TextMap.GetValue("Text_1_115") .. getNum
    self.getLabel2.text=TextMap.GetValue("Text_1_116") .. notGet
    self.scrollView:refresh(_list, self, false)
    self.binding:CallAfterTime(0.1,function()
        self.scrollView:goToIndex(find)
    end)
    local act = Player.Activity
    local btn = self.btGet.transform:GetComponent("UIButton")
    if act[self.data.id] then
        local plan = act[self.data.id]

        if plan and plan:ContainsKey("buy") and plan.buy == 1 then
            btn.isEnabled = false
        end
    end
    local obj = {}
    TableReader:ForEachLuaTable("shopPurchase", function(index, item)
        if item.rtype =="invest" then
            obj=item
        end
        return false
    end)
    self.cost.text=obj["showname"]
    local money = 100
    local id = obj["id"]
    local rtype = "invest" --类型
    local count = 0 --数量
    local unit = TextMap.GetValue("Text434")
    local playerId = Player.playerId
    local serverId = PlayerPrefs.GetString("serverId") or NowSelectedServer
    local info = playerId .. "|" .. serverId .. "|" .. rtype .. "|" .. os.time() --订单号
    if obj ~= nil then
        money = obj["cost"]
        rtype = obj["rtype"]
        -- count = obj["sendNum"]
        count = 1
        unit = obj["name"]
    end
    local rate = TableReader:TableRowByID("charge_settings","charge_rate").value
    --直接用金钱购买,读表获取基金的价格
    ClientTool.AddClick(self.btGet.transform, function()
        Api:checkInvest(self.data.id, function(result)
            if result.ret == 0 then
                btn.isEnabled=false
                page:getCallBack()
				local amount = money * 100
				if GlobalVar.sdkPlatform == "ly" then
					amount = money
				end
                if (ClientTool.Platform == "android" or ClientTool.Platform == "ios") and isSdk == 1 then
                    Api:getPayUrl(GlobalVar.sdkPlatform, rtype, info, money, self.data.id, nil, function(res)
                        
						--add by lihui UC6.1.0支付必须要的参数 2017-1-3 19:00
						local accountId = "0"
                        local url = ""
                        local sign =""
						print("serali investPlan="..tostring(ClientTool.Platform)..",sdkPlatform="..GlobalVar.sdkPlatform)
						if ClientTool.Platform == "ios"then
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
							accountId = res.accountId
						end	
						print("serali iospay1="..tostring(accountId))
						if res.url ~= nil then
                            url = res.url
                        end
                        if res.sign ~= nil then
                            sign = res.sign
                        end
						
						
                        mysdk:pay(amount, id, unit, count, info, url, accountId, sign,"1", function(result)
                            MessageMrg.show(TextMap.GetValue("Text435"))
                            btn.isEnabled = false
                        end, function()
                            btn.isEnabled = true
                            --MessageMrg.show(TextMap.GetValue("Text436"))
                        end)
                    end)
                else
                    Api:innerPay(playerId, money, rtype,info,self.data.id, function(result)
                        if result ~= nil and result.ret == 0 then
                            MessageMrg.show(TextMap.GetValue("Text435"))
                            btn.isEnabled = false
                        else
                            btn.isEnabled = true
                            MessageMrg.show(TextMap.GetValue("Text436"))
                        end
                    end)
                end
            end
        end, function(...)
            btn.isEnabled=true
            return false
        end)
    end)
end

function page:getData(data)
    local list = {}
    local row = 2
    for i = 1, table.getn(data), row do
        local li = {}
        local len = 0
        for j = 0, row - 1 do
            if data[i + j] then
                local d = data[i + j]
                li[j + 1] = d
                len = len + 1
            end
        end
        if len > 0 then
            table.insert(list, li)
        end
    end
    return list
end

--进入页面刷新
function page:onEnter(...)
    local that = self
end

-- 活动-回归感恩礼
function page:giftCode(up)
    if up then return end

    self.Content.text = self.data.desc
    self.lb_tip.text = TextMap.GetValue("Text437")
    if Player.Info.level > 9 and self.data.cdkey ~= "0" then
        self.lb_tip.text = TextMap.GetValue("Text438") .. self.data.cdkey
    end
    for k, v in pairs(self.data.drop) do
        local bind = ClientTool.loadAndGetLuaBinding("Prefabs/moduleFabs/activityModule/itemActivity", self.Table.gameObject)
        bind:CallUpdate(v)
    end
    self.Table:Reposition()
end

-- 活动-全民找bug
function page:findBug(up)
    if up then return end
    --self.Title.text = self.data.title
    self.Content.text = self.data.desc
end

-- 活动-充月卡赠钻石
function page:extraGold()
    self.Title.text = self.data.title
    self.Content.text = self.data.desc
end

--活动-商店打折
function page:shopSale(up)
    local hero_text = TextMap.GetValue("Text439")
    local package = self.data.package

    for i, v in ipairs(package) do
        hero_text = hero_text .. v.name
        if i ~= table.getn(package) then
            hero_text = hero_text .. "、"
        end
    end

    self.Title.text = self.data.title
    self.Content.text = self.data.desc .. "\n" .. hero_text
end

-- 活动-预付费，反钻石
function page:returnGold(up)
    if up then return end

    self.Title.text = self.data.title
    self.Content.text = self.data.desc
end

-- 活动-招财有礼
function page:doubleMoney(up)
    if up then return end

    self.Content.text = self.data.desc
    local btGet = self.btGet.transform:GetComponent("BoxCollider")
    local lbTip = btGet.transform:Find("Label"):GetComponent("UILabel")
    if self.data.status == 4 then
        self.delegate:countRedPoint(true)
        lbTip.text = TextMap.GetValue("Text440")
    else
        btGet.gameObject:GetComponent("UISprite").color = Color(0.5, 0.5, 0.5)
        lbTip.text = TextMap.GetValue("Text423")
    end
    ClientTool.AddClick(btGet.transform, function()
        if self.data.status == 4 then
            self.delegate:getDropPackage(self, self.data.id, "")
        else
            -- DialogMrg.buyMoney()
        end
    end)
end

-- 活动-豪华宴会
function page:getBP(up)
    local btGet = self.btGet
    local lbTip = btGet.transform:Find("Label"):GetComponent("UILabel")
    if self.data.status == 5 then
        self.sp_food:SetActive(true)
        self.delegate:countRedPoint(true)
        lbTip.text = TextMap.GetValue("Text422")
    elseif self.data.status == 6 then
        self.sp_food:SetActive(false)
        lbTip.text = TextMap.GetValue("Text422")
        self.btGet.color = Color(0.5, 0.5, 0.5)
    end
    if up then return end
    self.hero:LoadByModelId(87, "idle", function() end, false, 0, 1)
    ClientTool.AddClick(btGet.transform, function()
        if self.data.status == 5 then
            self.sp_food:SetActive(false)
            self.delegate:getDropPackage(self, self.data.id, "")
        end
    end)
    if self.data.status ~= 5 then
        if self.bpTimer == nil then
            local first = true
            LuaTimer.Add(0, 60000, function(id)
                self.bpTimer = id
                if self.data.status == 5 then 
                    self.sp_food:SetActive(true)
                    return false 
                end
                if first then
                    first = false
                    return
                end
                if self.gameObject.activeInHierarchy then
                    self.delegate:refreshEveryPay()
                end
                return true
            end)
        end
    elseif self.bpTimer then
        LuaTimer.Delete(self.bpTimer)
    end
end

function page:OnDestroy()
    Player:removeListener("vipMenucurrency")
    if self.bpTimer then
        LuaTimer.Delete(self.bpTimer)
    end
    if self.data.event == "fortune" then
        LuaTimer.Delete(timerId)
    end 
    if self.data.event == "rankPay" then
        ActivityPay = false
        Events.RemoveListener("onUpdatePayRank")
    end
    if self.data.event == "rankJJC" then
        ActivityJJC = false
        Events.RemoveListener("onUpdateJJC")
    end
    if self.data.event == "agencyGod" then
        myFont = nil
    end
end

-- 活动-月卡
function page:monthCard(up)
    if not up then 
        local txt = self.data.desc
        self.yuekaItem = {}
        TableReader:ForEachLuaTable("shopPurchase", function(index, item)
            if string.sub(item.rtype,0,5)=="yueka" then 
                item.dataIndex=index
                self.yuekaItem[item.rtype]=item
            end 
            return false
        end)
        local list = {}
        local first = true
        local index = 0
        local realIndex = 0
        local count = table.getn(self.data.drop) - 1
        for k, v in pairs(self.data.drop) do
            table.insert(list, { delegate = self, drop = v, package = self.data.package[k],dataItem=self.yuekaItem[self.data.package[k].id] })    
        end 
        if self.yueka_id ==0 then 
            for k,v in ipairs(list) do
                if first then
                    local st = self.data.status[v.package.id]
                    if st == 1 then
                        first = false
                        realIndex = index
                    end
                end
                index = index + 1
            end
            index = 0
            if first then 
                for k, v in pairs(list) do
                    if first then 
                        local st = self.data.status[v.package.id]
                        if st >2 then
                            first = false
                            realIndex = index
                        end
                    end 
                    index = index + 1
                end 
            end 
        else 
            realIndex=self.yueka_id-1
        end 
        self.click_yueka_btn={}
        for i=1,5 do
            table.insert(self.click_yueka_btn,self["click" .. i])
            if list[i]~=nil then 
                local name = list[i].dataItem.name
                self["name" .. i .. "1"].text=name
                self["name" .. i .. "2"].text=name
            else 
                self["btn" .. i].gameObject:SetActive(false)
                self.click_yueka_btn[i]:SetActive(false)
            end 
        end
        self.yueka_id=realIndex+1
        self.yuekaList=list
    end 
    for i=1,5 do
        if i==self.yueka_id then 
            self.click_yueka_btn[i]:SetActive(true)
            if self.yuekaList[i]~=nil then 
                self.activityTable:CallUpdate(self.yuekaList[i])
            end
        else 
            self.click_yueka_btn[i]:SetActive(false)
        end 
    end
end

-- 活动-vip礼包
function page:vipGift(up)
    self:setVipInfo(up)
end

function page:setVipInfo(up)
    if up then 
        if self.selectItem_cur~=nil then 
            self.selectItem_cur:getCallBack()
        end 
        return 
    end 
    self.vipLevel = {}
    TableReader:ForEachLuaTable("vipLevel", function(index, item) --shopPurchase
    self.vipLevel[index + 1] = item
    return false
    end)
    self.vip = Player.Info.vip
    self.exp = Player.Resource.vip_exp
    self.click_gift:SetActive(false)
    local list = {}
    local giftindex = 0
    local index = 0
    local _times = self.data._source_data.times
    local _disc = self.data._source_data.disc
    local _cost = self.data._source_data.cost
    local fuliIndex = 0
    local extra_item= {}
    for k, v in pairs(self.data.drop) do
        if tonumber(k) ==Player.Info.vip or tonumber(k) ==Player.Info.vip+1 then
            local data = {}
            table.foreach(v, function(i, item)
                local _type = item.type
                if _type == "char" then
                    local vo = Char:new(item.arg)
                    vo.__tp = "char"
                    table.insert(data, vo)
                else
                    local vo = itemvo:new(item.type, item.arg2, item.arg)
                    vo.__tp = "vo"
                    table.insert(data, vo)
                end
            end)
            local status= 3
            if tonumber(k) == Player.Info.vip then 
                status=self.data.status
            end 
            index=index+1
            local package = {}
            package.id=k 
            table.insert(extra_item, {type="vipFuli",status=status,delegate = self, drop = data, package =package })
        end 
    end
    table.sort(extra_item, function(a, b)
         if a.package.id ~= b.package.id then return tonumber(a.package.id) <tonumber(b.package.id) end 
    end)
    for i,v in ipairs(extra_item) do
        if fuliIndex==0 and v.package.id == self.vip then 
            fuliIndex=i 
        end 
    end
    self.fulitable.gameObject:SetActive(true)
    self.fulitable:refresh(extra_item, self, true, 0)
    self.binding:CallAfterTime(0.1,function()
        self.fulitable:goToIndex(fuliIndex)
    end)
    index=0
    for k, v in pairs(self.data._source_data.extra_drop) do
        local data = {}

        table.foreach(v, function(i, item)
            local _type = item.type
            if _type == "char" then
                local vo = Char:new(item.arg)
                vo.__tp = "char"
                table.insert(data, vo)
            else
                local vo = itemvo:new(item.type, item.arg2, item.arg)
                vo.__tp = "vo"
                table.insert(data, vo)
            end
        end)
        index=index+1
        local disc = 10
        if _disc~=nil and _disc[k] ~=nil then 
            disc=_disc[k]
        end 
        local times = 0 
        if _times~=nil and _times[k] ~=nil then 
            times=_times[k]
        end 
        local package = {}
        package.id=k
        table.insert(list, {type="vipGift",disc=disc,cost=_cost[k],times=times,delegate = self, drop = data, package = package })
    end
    table.sort(list, function(a, b)
        if a.package.id ~= b.package.id then return tonumber(a.package.id) <tonumber(b.package.id) end 
    end)
    for i,v in ipairs(list) do
        if giftindex==0 and v.package.id == self.vip then 
            giftindex=i 
        end 
    end
    self.gifttable:refresh(list, self, true, 0)
    self.binding:CallAfterTime(0.1,function()
        self.gifttable:goToIndex(giftindex)
        self.gifttable.gameObject:SetActive(false)
    end)   
    ClientTool.AddClick(self.btn_fuli, function()
        self.fulitable.gameObject:SetActive(true)
        self.gifttable.gameObject:SetActive(false)
        self.click_fuli:SetActive(true)
        self.click_gift:SetActive(false)
    end)
    ClientTool.AddClick(self.btn_gift, function()
        self.fulitable.gameObject:SetActive(false)
        self.gifttable.gameObject:SetActive(true)
        self.click_fuli:SetActive(false)
        self.click_gift:SetActive(true)
    end)
end

--边登7天
function page:loginGift(up)
    if up then
        if self.selectItem_cur~=nil then 
            self.selectItem_cur:getCallBack()
        end 
        return 
    end

    local list = {}
    local first = true 
    local index = 0
    local realIndex = 0
    local count = table.getn(self.data.drop) - 1
    for k, v in pairs(self.data.drop) do
        if first then
            local st = self.data.status[self.data.package[k].id]
            if st == 1 then
                first = false
                realIndex = index
            end
        end
        index = index + 1

        table.insert(list, { delegate = self, drop = v, package = self.data.package[k] })
    end
    if first==true then 
        for k, v in pairs(list) do
            if first then 
                local st = self.data.status[v.package.id]
                if st~=2 then 
                    first = false
                    realIndex = k-1
                end 
            end 
        end 
    end 
    self.table:refresh(list, self, false, 0)
    self.binding:CallAfterTime(0.1,function()
        self.table:goToIndex(realIndex)
    end) 
end

--开服大礼包
function page:openGift(up)
    self:firstPayGift(up)
end

function page:typeId(_type)
   local typeAll = { "equip", "equipPiece", "item", "char", "charPiece", "reel", "reelPiece" }
    for i, j in pairs(typeAll) do
        if _type == j then
            return true
        end
    end
    return false    
end

--限时兑换
function page:limitChange(up)
    if up then
        if self.selectItem_cur~=nil then 
            self.selectItem_cur:update()
        end 
        return 
    end
    local list = {}
    local first = true
    local index = 0
    local count = table.getn(self.data.drop)
    local find = 0
    local extra_drop = self.data.extra_drop
    local times = self.data._source_data.times
    local tps = self.data._source_data.type
    local discList = self.data._source_data.disc
    for k, v in pairs(self.data.drop) do
        local extra_item = {}
        table.foreach(v, function(i, item)
            local _type = item.type
            if _type == "char" then
                local vo = Char:new(item.arg)
                if vo.info.level > 0 then
                    vo = CharPiece:new(vo.id)
                    vo.rwCount = vo.needCharNumber
                end
                vo.__tp = "char"
                item.arg2=1
                vo.item=item
                table.insert(extra_item, vo)
            else
                local vo = itemvo:new(item.type, item.arg2, item.arg)
                local max = Tool.getCountByType(item.type, item.arg)
                local num = item.arg
                if page:typeId(item.type) then num = item.arg2 end
                --if max < tonumber(num) then
                --    vo.__numColor = "[ff0000]"
                --else
                    vo.__numColor = nil
                --end
                vo.item=item
                vo.__tp = "vo"
                table.insert(extra_item, vo)
            end
        end)
        local data = {}
        local _item =nil 
        _item=extra_drop[k]
        if _item~=nil then 
            table.foreach(_item, function(m,n)
                local _type1 = n.type
                if _type1 == "char" then
                    local vo = Char:new(n.arg)
                    if vo.info.level > 0 then
                        vo = CharPiece:new(vo.id)
                        vo.rwCount = vo.needCharNumber
                    end
                    n.arg2=1
                    vo.item=n
                    vo.__tp = "char"
                    table.insert(data, vo)
                else
                    local vo = itemvo:new(n.type, n.arg2, n.arg)
                    local max = Tool.getCountByType(n.type, n.arg)
                    local num = n.arg
                    if page:typeId(n.type) then num = n.arg2 end
                    if max < tonumber(num) then
                        vo.__numColor = "[ff0000]"
                    else
                        vo.__numColor = nil
                    end
                    vo.item=n
                    vo.__tp = "vo"
                    table.insert(data, vo)
                end
            end)
        end 
        local consume2_drop =nil
        if self.data._source_data.consume2~=nil then 
            consume2_drop=self.data._source_data.consume2["" .. k]
        end 
        local disc = 10
        if discList~=nil and discList[k .. ""]~=nil then
            disc=discList[k .. ""]
        end 
        table.insert(list, { tp = tps[k .. ""],disc=disc,k="" .. k, consume2=consume2_drop,extra_drop = extra_item, delegate = self, drop = data, package = self.data.package[k]})
    end
    print("长度" .. #list)
    self.table:refresh(list, self, false, 0)
    if self.gid_cur ~=nil then 
        local _index =0 
        local index=0
        for k, v in pairs(self.data.package) do
            if v.id==self.gid_cur then 
                _index=index
            end 
            index=index+1
        end
        self.binding:CallAfterTime(0.1,function()
            self.table:goToIndex(_index)
        end) 
    end 
end

--挑战获胜送豪礼
function page:challengeWinReward(up)
    if up then 
        if self.selectItem_cur~=nil then 
            self.selectItem_cur:update()
        end 
        return 
    end
    local list = {}
    local first = true
    local index = 0
    local realIndex = 0
    local count = table.getn(self.data.drop) - 1
    for k, v in pairs(self.data.drop) do
        if self.data.selectIcon ~=nil and self.data.selectIcon[self.data.package[k].id]~=nil then 
            table.insert(list, { delegate = self, drop = v, event_type = self.data.event ,package = self.data.package[k] ,
            selectIcon = self.data.selectIcon[self.data.package[k].id],
            selectName = self.data.selectName[self.data.package[k].id],
            selectPackage = self.data.selectPackage[self.data.package[k].id]
            })
        else 
            table.insert(list, { delegate = self, drop = v, package = self.data.package[k] })
        end
    end
    table.sort(list, function(a, b)
        if b ~= nil then
            a_status = a.delegate.data.status[a.package.id]
            b_status = b.delegate.data.status[b.package.id]
            if a_status ~= b_status and a_status~=nil and b_status~=nil  then
                if a_status == 2 then  return false --待领取的状态最前面，再是进行中，最后是领取完成
                elseif b_status == 2 then return true
                else return a_status > b_status
                end
            elseif a.package.id ~= b.package.id then 
                return tonumber(a.package.id) < tonumber(b.package.id)
            end
        end
    end)
    for k,v in ipairs(list) do
        if first then
            local st = self.data.status[v.package.id]
            if st == 1 then
                first = false
                realIndex = index
            end
        end
        index = index + 1
    end
    --ClientTool.UpdateGrid("", self.grid, list)
    self.table:refresh(list, self,false,0)
    self.binding:CallAfterTime(0.1,function()
        self.table:goToIndex(realIndex)
    end)
end

--幸运之轮
function page:turnTable(up)
    if up then return end
    self.Content:CallUpdate({ data = self.data, delegate = self })
end

--每日签到
function page:dailySign(up)
    --if up then return end
    self.Content:CallUpdate({ data = self.data._source_data, delegate = self.delegate })
end

--cdkey兑换
function page:cdkeyChange(up)
    if up then return end
    self.Content:CallUpdate({ data = self.data, delegate = self })
end

-- 活动公告
function page:notice()
    local tb=split(self.data.desc, "{")
    if tb[1]~=nil then self.Content.text=tb[1] end 
    local sp = {}
    if tb[2]~=nil then 
        sp=split(tb[2], "}")
        tb[2]=sp[1]
        tb[3]=sp[2]
        self.btn_url.gameObject:SetActive(true)
        self.url.text=tb[2] 
        self.url_path=tb[2] 
        local box = self.btn_url.gameObject:GetComponent(BoxCollider)
        box.size.y= self.url.height+10
    else 
        self.btn_url.gameObject:SetActive(false)
    end 
    if tb[3]~=nil then 
        self.content.text=tb[3] 
    else 
        self.content.text=""
    end 
end

function page:getScrollView()		
	return self.view;		
end

return page