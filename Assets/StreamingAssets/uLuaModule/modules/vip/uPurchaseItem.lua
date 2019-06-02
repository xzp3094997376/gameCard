local page = {}

function page:Start()
    --ClientTool.load("Effect/Prefab/ui_jingtairenwu_wp_02", self.spIcon.gameObject)
end

function page:create()
    return self
end

function page:update(data, index, grid, delegate)
    self.delegate = data.delegate
    self.lbGift.text = data.showname
    self.index = index + 1
    self.data=data
    self.grid=grid
    self.dataType = data.rtype
    self.money = data.cost
    self.rtype = data.rtype
    page:getCallBack()
end

function page:getCallBack()
    self.button.isEnabled=true
    local firstPay = self:getfirst(self.data.id)
    local drop = {}
    if self.data.firstdrop.Count >0 then 
        if firstPay==0 and self.data.firstdrop[0]~=nil then 
            drop=self.data.firstdrop
        elseif firstPay==1 and self.data.drop[0]~=nil then 
            drop=self.data.drop
        end 
    end 
    self.group1.gameObject:SetActive(false)
    self.group2.gameObject:SetActive(false)
    if drop~=nil  then
        local droplist = RewardMrg.getProbdropByTable(drop)
        local dropgroup = self:getData(droplist)
        if #dropgroup==1 then 
            self.group1.gameObject:SetActive(true)
            self.group1:CallUpdate(dropgroup[1])
            self.group1.transform.localPosition=Vector3(0,5,0)
            self.group2.gameObject:SetActive(false)
        elseif #dropgroup==2 then 
            self.group2.gameObject:SetActive(true)
            self.group1:CallUpdate(dropgroup[1])
            self.group1.transform.localPosition=Vector3(0,85,0)
            self.group2:CallUpdate(dropgroup[2])
            self.group2.transform.localPosition=Vector3(0,-20,0)
        else 
            print("充值送礼掉落物品个数大于4，此类型未支持")
        end
    end
    if firstPay == 0 then 
        self.lbSend.text = TextMap.GetValue("Text_1_2855") 
    else 
        self.lbSend.text = TextMap.GetValue("Text_1_2856") 
    end
    self.lb_price.text = self.data.cost .. TextMap.GetValue("Text_1_2853")
    self.lb_price:MakePixelPerfect()
    if firstPay == 0 then
        self.img_jiaoBiao:SetActive(true)
    else
        self.img_jiaoBiao:SetActive(false)
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

function page:getData(data)
    local list = {}
    local row = 2
    for i = 1, table.getn(data), row do
        local li = {}
        local len = 0
        for j = 0, row - 1 do
            if data[i + j] then
                local d = data[i + j]
                d.realIndex = i + j
                li[j + 1] = d
                len = len + 1
                d.mType = self.mType
            end
        end
        if len > 0 then
            table.insert(list, li)
        end
    end

    return list
end


function page:onClick(go, name)
	print("name = " .. name)
    self.delegate.selectItem_cur=self
    if tonumber(self.data.recommend) < 1 then
        return
    end
    if self.button~=nil then 
        self.button.isEnabled=false
    end 
    self.delegate:refreshDataWhenVip()
    local pay_lv = nil
    if self.delegate.data.event=="normalPay" then 
        pay_lv=self.data.index or 1
    end 
    local playerId = Player.playerId
    local rtype = self.data.rtype
    local serverId = PlayerPrefs.GetString("serverId") or NowSelectedServer
    local info = playerId .. "|" .. serverId .. "|" .. rtype .. "|" .. os.time()
    local rate = TableReader:TableRowByID("charge_settings","charge_rate").value
    local money = self.data.cost * 100
    if (ClientTool.Platform == "android" or ClientTool.Platform == "ios") and isSdk== 1 then
        Api:getPayUrl(GlobalVar.sdkPlatform, rtype,info,self.data.cost,self.delegate.data.id,pay_lv,function(res)
        local count = self.data.cost *tonumber(rate)
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
        --    print("serali andpay2="..tostring(res.ios))
        --    if res.ios ~= nil then                      
        --        accountId = res.ios                         
        --    else
        --        accountId = "1"
        --    end 
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
                table.insert(payInfo, money)
                table.insert(payInfo, self.index)
                table.insert(payInfo, unit)
                table.insert(payInfo, count)
                table.insert(payInfo, info)
                table.insert(payInfo, url)
                table.insert(payInfo, accountId)
                table.insert(payInfo, sign)
                UIMrg:pushWindow("Prefabs/moduleFabs/publicModule/ChoisePayType",{
                                    info = payInfo, delegate = self})
            else
                mysdk:pay(money, self.data.id,self.data.name, count, info, url, accountId, sign, "1", function(result)
                    OperateAlert.getInstance:showToGameObject({ TextMap.GetValue("Text1462") }, self.button.gameObject)
                    end, function()
                    if self.button~=nil then 
                        self.button.isEnabled=true
                    end 
                    end)
            end
        end)
    else
        Api:innerPay(Player.playerId, self.data.cost, self.data.rtype,info,self.delegate.data.id,pay_lv, function(result)
            if result ~= nil and result.ret == 0 then
                OperateAlert.getInstance:showToGameObject({ TextMap.GetValue("Text1462") }, self.button.gameObject)
            else
                if self.button~=nil then 
                    self.button.isEnabled=true
                end 
            end
            end)
    end
end

function page:returnPay()
    if self.button~=nil then 
        self.button.isEnabled=true 
    end 
end

function page:OnDestroy()
    Player:removeListener("vipMenucurrency")
end

return page