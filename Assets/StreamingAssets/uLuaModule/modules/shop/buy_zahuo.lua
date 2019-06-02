local buy_zahuo = {}
local lastTimes=0
local priceList = {}
function buy_zahuo:update(tempdata)
    self.delegate = tempdata.delegate
    self.item = tempdata.item
    self.prize = tempdata.prize
    self.shoptype=tempdata.shoptype
    self.shop_item=tempdata.item.shop_item
    local shop_item = tempdata.item.shop_item
    local maxCount = tempdata.maxCount
    self.shop_item = shop_item
    if self.item.isRes ~= nil and self.item.isRes then
        self.txt_name.text = self.item.name
    else
        self.txt_name.text = self.item:getDisplayColorName()
    end
    if self.item:getType()== "char" then 
        local count = 0
        local chars = Player.Chars:getLuaTable()
        for k, v in pairs(chars) do
            if v.dictid == self.item.dictid then 
                count=count+1
            end 
        end
        self.txt_desc.text = TextMap.GetValue("Text_1_1068") .. count
    elseif self.item:getType()== "treasure" then 
        local count = 0
        local treasures = Player.Treasure:getLuaTable()
        for k,v in pairs(treasures) do
            if v.id==self.item.id  then
                count=count+1
            end
        end
        self.txt_desc.text = TextMap.GetValue("Text_1_1068") .. count
    elseif self.item:getType()== "item" and self.item.Table.aotu_use==1 and self.item.Table.drop.Count==1 and Tool.typeId(self.item.Table.drop[0].type) then 
        local count = Player.Resource[self.item.Table.drop[0].type]
        self.txt_desc.text = TextMap.GetValue("Text_1_1068") .. toolFun.moneyNumberShowOne(math.floor(tonumber(count)))
    elseif self.item.count~=nil then 
        self.txt_desc.text = TextMap.GetValue("Text_1_1068") .. self.item.count 
    else 
        self.txt_desc.text=""
    end 
    local binding = ClientTool.loadAndGetLuaBindingFromPool("Prefabs/publicPrefabs/itemAll", self.img_kuangzi.gameObject)
    binding:CallUpdate({ "char", self.item, self.img_kuangzi.width, self.img_kuangzi.height,nil,nil,nil,nil,false })
    self.numberSelect:maxNumValue(maxCount)
    self.numberSelect.selectNum = 1
    self.number.gameObject:SetActive(false)  
    local count = 1
    if shop_item.count > 1 then
        count = shop_item.count
    end
    if self.item.__count ~= nil then count = self.item.__count end
    if self.shoptype==0 then
        self.number.gameObject:SetActive(true)
        self.number.text = count  
        self.xiaogouNum.text=""
    else
        self.number.gameObject:SetActive(false)
        lastTimes = shop_item.count - shop_item.buy_num
        if (lastTimes) <= 0 then
            self.xiaogouNum.text = TextMap.GetValue("Text_1_1069")
        else
            self.xiaogouNum.text =string.gsub(TextMap.GetValue("LocalKey_783"),"{0}",lastTimes)
        end
    end
    self.numberSelect:setCallFun(buy_zahuo.setMoneyChange, self)
    priceList={}
    if shop_item.price~=nil then 
        if shop_item.price[0].sell_type~="" then 
            table.insert( priceList, shop_item.price[0])
        end 
        if shop_item.price[1].sell_type~="" then 
            table.insert( priceList, shop_item.price[1])
        end
        if #priceList==1 then 
            self.money1.gameObject:SetActive(true)
            self.moneySprite1.gameObject:SetActive(true)
            self.money2.gameObject:SetActive(false)
            self.moneySprite2.gameObject:SetActive(false)
        elseif #priceList==2 then 
            self.money1.gameObject:SetActive(true)
            self.moneySprite1.gameObject:SetActive(true)
            self.money2.gameObject:SetActive(true)
            self.moneySprite2.gameObject:SetActive(true)
            self.txt_huodeyinbi.transform.localPosition = Vector3(-50, -100, 0) 
        end
        self.prize={}
        for i=1,#priceList do 
            local price = priceList[i].sell_price
            local true_price = priceList[i].sell_num
            --出售上限
            if priceList[i].inc_limit ~= nil and true_price > priceList[i].inc_limit then 
                true_price = priceList[i].inc_limit 
            end
            local iconName=""
            if priceList[i].sell_type == "item" then 
                local itemcell=uItem:new(priceList[i].sell_arg)
                iconName = itemcell.Table.iconid
                if itemcell.count < true_price then
                    self["money" .. i].text = true_price
                else
                    self["money" .. i].text = true_price
                end
            else 
                iconName = Tool.getResIcon(priceList[i].sell_type)
                if (Tool.getCountByType(priceList[i].sell_type) < true_price) then
                    self["money" .. i].text = true_price
                else
                    if priceList[i].sell_type=="gold" then 
                        self["money" .. i].text = true_price 
                    else
                        self["money" .. i].text = true_price
                    end 
                end
            end
            self:setIcon("moneySprite" .. i, iconName, true)
            table.insert(self.prize, true_price)
        end
    else 
        self.money2.gameObject:SetActive(false)
        local true_price= shop_item.sell_price
        if shop_item.sell_discount~=nil then 
            true_price = math.floor(true_price * shop_item.sell_discount / 100 + 0.5)
        end 
        self["money1"].text = true_price
        local iconName = Tool.getResIcon(shop_item.sell_type)
        self:setIcon("moneySprite1", iconName, true)
        table.insert(priceList, shop_item)
    end 
end


function buy_zahuo:setIcon(old, name, ret)
    local assets = packTool:getIconByName(name)
    self[old]:setImage(name, assets)
    Tool.SetActive(self[old], ret)
end

function buy_zahuo:setMoneyChange()
    local buy_num = self.shop_item.buy_num
    local num = tonumber(self.selectNum.text)
    if self.shop_item.price ~=nil then 
        for i=1,#priceList do 
            local price = priceList[i].sell_price
            local true_price = priceList[i].sell_num
            local total_price = 0
            local step = tonumber(priceList[i].step)
            local inc = priceList[i].inc
            for j=1,num do
                buy_num=buy_num+1
                local cur_price =price+math.floor((buy_num-1)/step)*inc
                --出售上限
                if priceList[i].inc_limit ~= nil and cur_price > priceList[i].inc_limit then 
                    cur_price = priceList[i].inc_limit 
                end
                total_price=total_price+cur_price
            end
            self["money" .. i].text = total_price
        end
    else 
        local true_price= self.shop_item.sell_price
        if self.shop_item.sell_discount~=nil then 
            true_price = math.floor(true_price * self.shop_item.sell_discount / 100 + 0.5)
        end 
        self["money1"].text = true_price*num
    end 
end

function buy_zahuo:useSellBack()
    UIMrg:popWindow()
end

function buy_zahuo:onClick(go, name)
    if name == "btn_quxiao" or name == "btnClose" then
        UIMrg:popWindow()
    end
    if name == "btn_queren" then
        if self.item.SHOP_TYPE == 20 or self.item.SHOP_TYPE == 21 or self.item.SHOP_TYPE == 22 then
            buy_zahuo:sendBuyLeagueShopItem()
        elseif self.item.SHOP_TYPE == 31 then
            buy_zahuo:sendBuyVIPShopItem()
        else
            buy_zahuo:senAPI()
        end
        self.btn_queren.isEnabled = false
    end
end

function buy_zahuo:sendBuyVIPShopItem()
    local delegate = self.delegate
    Api:buyVipShop(self.item.shop_item.itemid, tonumber(self.selectNum.text),
        function(result)
            print("buyVipShop")
            local itemvalue
            self.btn_queren.isEnabled = true
            local list = RewardMrg.getList(result)
            table.foreach(list,
                function(i, v)
                    itemvalue = v
                end)
            delegate.isRefrsh = true
            if itemvalue ~= nil then
                list = nil
                --紧跟着使用
                if itemvalue:getType() == "item" and itemvalue.Table.aotu_use == 1 then
                    Api:useItem("item", itemvalue.Table.id .. "", self.selectNum.text,
                        function(result)
                            buy_zahuo:showGetItems(result)
                        end, itemvalue.Table.id)
                else
                    buy_zahuo:showGetItems(result)
                end
            else
                itemvalue = nil
                Events.Brocast('shop_change')
                UIMrg:popWindow()
            end
        end, function()
            self.btn_queren.isEnabled = true
            return false
        end)
end

function buy_zahuo:typeId(_type)
    return Tool.typeId(_type)
end

function buy_zahuo:sendBuyLeagueShopItem()
    local delegate = self.delegate
    if self.shop_item.posid ~= nil and self.shop_item.posid ~= -1 then
        Api:buyPkgShop(self.shop_item.posid, self.selectNum.text,
            function(result)
                print("buyPkgShop")
                self.btn_queren.isEnabled = true
                self.shop_item.sell = true
                delegate.isRefrsh = true
                delegate:onRefresh()
                local itemvalue
                self.btn_queren.isEnabled = true
                local list = RewardMrg.getList(result)
                table.foreach(list,
                    function(i, v)
                        itemvalue = v
                    end)
                if itemvalue ~= nil and itemvalue:getType() == "item" and itemvalue.Table.aotu_use == 1 then
                    Api:useItem("item", itemvalue.Table.id .. "", self.selectNum.text,
                        function(result)
                            buy_zahuo:showGetItems(result)
                        end, itemvalue.Table.id)
                else
                    local name = ""
                    if self.item.isRes ~= nil and self.item.isRes then
                        name = self.item.name
                    else
                        name = self.item:getDisplayColorName()
                    end
                     local num = tonumber(self.selectNum.text)
                    if  self.item.shop_item.count ~= nil and self.item.shop_item.count > 1 then
                        num = num * self.item.shop_item.count
                    end
                    MessageMrg.showMove(TextMap.GetValue("Text370") .. name .. " [-]X " .. num)
                    Events.Brocast('shop_change')
                    UIMrg:popWindow()
                end
            end,
            function()
                self.btn_queren.isEnabled = true
                return false
            end)
    else
        Api:buyGuildShop(self.item.SHOP_TYPE, self.item.shop_item.type, self.item.shop_item.id, self.selectNum.text,
            function(result)
                print("buyGuildShop")
                self.btn_queren.isEnabled = true
                self.shop_item.buy_num = self.shop_item.buy_num + tonumber(self.selectNum.text)
                self.shop_item.guild_buy_num = self.shop_item.guild_buy_num + tonumber(self.selectNum.text)
                delegate.isRefrsh = true
                delegate:onRefresh()

                local itemvalue
                self.btn_queren.isEnabled = true
                local list = RewardMrg.getList(result)
                table.foreach(list,
                    function(i, v)
                        itemvalue = v
                    end)
                if itemvalue ~= nil and itemvalue:getType() == "item" and itemvalue.Table.aotu_use == 1 then
                    Api:useItem("item", itemvalue.Table.id .. "", self.selectNum.text,
                        function(result)
                            buy_zahuo:showGetItems(result)
                        end, itemvalue.Table.id)
                else
                    local name = ""
                    if self.item.isRes ~= nil and self.item.isRes then
                        name = self.item.name
                    else
                        name = self.item:getDisplayColorName()
                    end
                    local num = tonumber(self.selectNum.text)
                    if  self.item.shop_item.count ~= nil and self.item.shop_item.count > 1 then
                        num = num * self.item.shop_item.count
                    end
                    MessageMrg.showMove(TextMap.GetValue("Text370") .. name .. " [-]X " .. num)
                    Events.Brocast('shop_change')
                    UIMrg:popWindow()
                end
            end,
            function()
                self.btn_queren.isEnabled = true
                return false
            end)
    end
end

function buy_zahuo:senAPI()
    local delegate = self.delegate
    Api:buyPartly(self.item.SHOP_TYPE, self.item.shop_pos, self.selectNum.text,
        function(result)
            print ("buyPartly")
            local itemvalue
            self.btn_queren.isEnabled = true
            delegate:update(delegate.item)
            local list = RewardMrg.getList(result)
            table.foreach(list,
                function(i, v)
                    itemvalue = v
                end)
            if itemvalue ~= nil then
                list = nil
                --紧跟着使用
                if itemvalue:getType() == "item" and itemvalue.Table.aotu_use == 1 then
                    Api:useItem("item", itemvalue.Table.id .. "", self.selectNum.text,
                        function(result)
                            buy_zahuo:showGetItems(result)
                        end, itemvalue.Table.id)
                else
                    buy_zahuo:showGetItems(result)
                end
            else
                itemvalue = nil
                UIMrg:popWindow()
            end
        end, function()
            self.btn_queren.isEnabled = true
            return false
        end)
end

function buy_zahuo:showGetItems(result)
    packTool:showMsg(result, nil, 0)
    UIMrg:popWindow()
end

return buy_zahuo