local goldBuySoulORBp = {}
local baseData = {}
local indexData = {}
local currentSelect
local infobinding
local currendID
local havenum
local vo
local priceList = {}
function goldBuySoulORBp:update(type)
    if type[1] =="superLink" then 
        self._type=type[2]
        buyType=self._type
        self._callBack = LuaMain:refreshTopMenu()
        self.onChange = LuaMain:refreshTopMenu()
        currendID = goldBuySoulORBp:getItemId(buyType)
        goldBuySoulORBp:refreash()
    else 
        self._type = type[1]
        self._titleTxt = type[2]
        self._callBack = type[3]
        self.onChange = type[4]
        if type[5] ~= nil then
            self._useHandler = type[5]
        end
        self:setdata()
    end
end

--商店数据
function goldBuySoulORBp:getShopData()
    baseData = {}
    indexData = {}
    local shop_list = Player.Shop[7] --杂货是7
    local count = shop_list.count
    for i = 0, count - 1 do
        local cell = shop_list[i]
        if cell.type == "item" then
            baseData[cell.id] = cell
            indexData[cell.id] = i
        end
        cell = nil
    end
    shop_list = nil
end

function goldBuySoulORBp:getItemId(buyType)
    local row = TableReader:TableRowByID("shopConvert", buyType)
    if row ~=nil then
        row = json.decode(row:toString())
    end
    if row ~=nil then
        self.Label_des.text =row.desc
        return row.item_id
    else
        return nil
    end
end

function goldBuySoulORBp:setdata()
    --只有bp有两种情况
    local buyType = self._type
    if self._type == "soul" then
        currendID = 31 --灵子糖果5000
        self.buyType.text = TextMap.GetValue("Text355")
    elseif self._type == "bp" then
        currendID = 5 
        local item22Count = Tool.getCountByType("item", 5)
		print("bp = " .. item22Count)
        local buy21Count = 0
        local buy22Count = 0
        if item22Count == 0 then
            local item21Count = Tool.getCountByType("item", 5)
            if item21Count == 0 then
                local shop_list = Player.Shop[7] --杂货是7
                local count = shop_list.count
                for i = 0, count - 1 do
                    local cell = shop_list[i]
                    if cell.type == "item" then
                        local id = tonumber(cell.id)
                        local lastTimes = cell.count - cell.buy_num
                        if id == 5 then
                            buy22Count = lastTimes
                        end
                        if id == 5 and lastTimes > 0 then
                            buy21Count = lastTimes
                        end
                    end
                    cell = nil
                end

                if buy22Count == 0 and buy21Count > 0 then
                    currendID = 5
                    buyType = "bp2"
                end
            else
                currendID = 5
                buyType = "bp2"
            end
        end
        self.buyType.text = TextMap.GetValue("Text356")
        self .Label_des.text =TextMap.GetValue("Text_1_2")
    elseif self._type == "tzq" then
        currendID = 76 --挑战令
        self.buyType.text = TextMap.GetValue("Text357")
    elseif self._type == "djq" then
        currendID = 83 --对决券
        self.buyType.text = TextMap.GetValue("Text357")
    elseif self._type == "lwl" then
        currendID = 84 --灵王令
        self.buyType.text = TextMap.GetValue("Text357")
    elseif self._type == "xsl" or self._type == "xs1" or self._type == "xs2"
            or self._type == "xs3" or self._type == "xs4" or self._type == "xs6" then
        --currendID = 43 --悬赏令
        self.buyType.text = TextMap.GetValue("Text357")
    elseif self._type == "slq" then
        currendID = 44 --试炼券
        self.buyType.text = TextMap.GetValue("Text357")
    elseif self._type == "tfl" or self._type == "daxu_point"then
        currendID = 65--96
        self.buyType.text = TextMap.GetValue("Text357")
        self.Label_des.text =TextMap.GetValue("Text_1_3")
    elseif self._type == "leagueCopyQ" then
        currendID = 1000 --公会副本券
        self.buyType.text = TextMap.GetValue("Text357")
    elseif self._type == "kftzq" then --跨服挑战券
        currendID = 1002
        self.buyType.text = TextMap.GetValue("Text357")
    elseif self._type == "xmzp" then -- 小免战牌
        currendID = 66
        self.Label_des.text = TextMap.GetValue("Text1646")
        self.Label_des.text =TextMap.GetValue("Text_1_4")
    elseif self._type == "dmzp" then --大免战牌
        currendID = 67
        self.buyType.text = TextMap.GetValue("Text1646")
        self.Label_des.text =TextMap.GetValue("Text_1_4")
	elseif self._type == "vp" then -- 精力
		currendID = 6
		buyType = "vp2"
        self.buyType.text = TextMap.GetValue("Text1646")
        self.Label_des.text =TextMap.GetValue("Text_1_5")
    end
    --if self._type ~= "xmzp" and self._type ~= "dmzp" then 
    --    currendID = goldBuySoulORBp:getItemId(buyType)
    --end
    goldBuySoulORBp:refreash()
    --self.Sprite.gameObject:SetActive(false)
    --vo = itemvo:new("item", 1, currendID, 1, "1")
end

local true_price = 0
function goldBuySoulORBp:refreash()
    havenum = Player.ItemBagIndex[currendID].count
    self.yongyouNum.text = "[ffff96]"..TextMap.GetValue("Text358").."[-]".. havenum
    goldBuySoulORBp:getShopData()
    currentSelect = baseData[currendID]
    self.selectNum.text = 1
    local item = uItem:new(currendID)
    self.itemName.text = item:getDisplayColorName()
    infobinding = ClientTool.loadAndGetLuaBindingFromPool("Prefabs/publicPrefabs/itemAll", self.rongqi.gameObject)
    infobinding:CallUpdate({ "char", item, self.rongqi.width, self.rongqi.height })
	print("_refresh_havenum = " .. havenum)
    if havenum > 0 then 
        self.buyType.text = TextMap.GetValue("Text_1_6")
        self.numberSelect.selectNum = 1
        self.txt_purchase.text =TextMap.GetValue("Text363")
        self.numberSelect:maxNumValue(havenum)
        self.txt_huodeyinbi:SetActive(false)
        self.itemTimes.gameObject:SetActive(false)
    else 
        if not currentSelect then 
            self:onClose()
            MessageMrg.show(TextMap.GetValue("Text_1_7"))
            return 
        end
        self.txt_purchase.text =TextMap.GetValue("Text1464")
        self.itemTimes.gameObject:SetActive(true)
        local lastTimes = currentSelect.count - currentSelect.buy_num
        local buy_num = currentSelect.buy_num
        if (lastTimes) <= 0 then
            self.itemTimes.text = TextMap.GetValue("Text359") --.. currentSelect.count
        else
            self.itemTimes.text = TextMap.GetValue("Text360") .. lastTimes --.. "[-]/" .. currentSelect.count
        end
        self.buyType.text = TextMap.GetValue("Text_1_8")
        self.txt_huodeyinbi:SetActive(true)
        priceList = {}
        if currentSelect.price[0].sell_type~="" then 
            table.insert( priceList, currentSelect.price[0])
        end 
        if currentSelect.price[1].sell_type~="" then 
            table.insert( priceList, currentSelect.price[1])
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
            self.txt_huodeyinbi.transform.localPosition = Vector3(-120, -73.6, 0) ---170, -210
        end
        self.prize={}
        self.canbuynum = lastTimes
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
                local buynum =0
                local totalNum =itemcell.count
                for j=1,self.canbuynum do
                    if totalNum>=true_price then 
                        buy_num=buy_num+1
                        local cur_price =true_price+math.floor((buy_num-1)/tonumber(priceList[i].step))*tonumber(priceList[i].inc)
                        --出售上限
                        if priceList[i].inc_limit ~= nil and cur_price > priceList[i].inc_limit then 
                            cur_price = priceList[i].inc_limit 
                        end
                        if totalNum>=cur_price then 
                            buynum=buynum+1
                            totalNum=totalNum-cur_price
                        end 
                    end 
                end
                self.canbuynum=math.min(self.canbuynum,buynum)
                if itemcell.count < true_price then
                    self["money" .. i].text = true_price
                else
                    self["money" .. i].text = true_price
                end
            else 
                iconName = Tool.getResIcon(priceList[i].sell_type)
                local buynum =0
                local totalNum =Tool.getCountByType(priceList[i].sell_type)
                for j=1,self.canbuynum do
                    if totalNum>=true_price then 
                        buy_num=buy_num+1
                        local cur_price =true_price+math.floor((buy_num-1)/tonumber(priceList[i].step))*tonumber(priceList[i].inc)
                        --出售上限
                        if priceList[i].inc_limit ~= nil and cur_price > priceList[i].inc_limit then 
                            cur_price = priceList[i].inc_limit 
                        end
                        if totalNum>=cur_price then 
                            buynum=buynum+1
                            totalNum=totalNum-cur_price
                        end 
                    end 
                end
                self.canbuynum=math.min(self.canbuynum,buynum)
                if (Tool.getCountByType(priceList[i].sell_type) < true_price) then
                    self["money" .. i].text = true_price--"[ff0000]" .. 
                else
                    if priceList[i].sell_type=="gold" then 
                        self["money" .. i].text = true_price--"[F0E77B]"
                    else
                        self["money" .. i].text = true_price--"[FFFFFF]" .. 
                    end 
                end
            end
            self:setIcon("moneySprite" .. i, iconName, true)
            table.insert(self.prize, true_price)
        end
        self.numberSelect:setCallFun(goldBuySoulORBp.setMoneyChange, self)
        self.numberSelect:maxNumValue(self.canbuynum)
        if lastTimes == 0 then
            if Player.Info.vip < 15 then
                self.itemPro.text = TextMap.GetValue("Text361")
                self.txt_purchase.text = TextMap.GetValue("Text68")
            else
                self.itemPro.text = TextMap.GetValue("Text362")
                self.useBtn.gameObject:SetActive(false)
                self.txt_purchase.text=TextMap.GetValue("Text1346")
            end
        end
    end
    if self.onChange ~= nil then
        self:onChange(self)
    end
end
function goldBuySoulORBp:setIcon(old, name, ret)
    local assets = packTool:getIconByName(name)
    self[old]:setImage(name, assets)
    Tool.SetActive(self[old], ret)
end

function goldBuySoulORBp:setMoneyChange()
    local buy_num = currentSelect.buy_num
    local num = tonumber(self.selectNum.text)
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
end

function goldBuySoulORBp:typeId(_type)
    local typeAll = { "exp", "skill_point", "vip_exp", "money", "gold", "bp", "soul", "popularity", "credit", "honor", "hunyu", "donate", "vstime", "herotime", "league_times", "daxu_point", "dmzp", "xmzp"}
    for i, j in pairs(typeAll) do
        if _type == j then
            return true
        end
    end
    return false
end

function goldBuySoulORBp:showMoveDlg()
    if self._type == "lwl" then
        MessageMrg.showMove(TextMap.GetValue("Text364"))
    elseif self._type == "leagueCopyQ" then
        MessageMrg.showMove(TextMap.GetValue("Text364"))
    else
        MessageMrg.showMove(TextMap.GetValue("Text365"))
    end
end


function goldBuySoulORBp:onUsehandler()
    if havenum == nil or havenum <= 0 then
        MessageMrg.show(TextMap.GetValue("Text366"))
        return
    end

    if self._useHandler ~= nil then
        havenum = Player.ItemBagIndex[currendID].count
        self:_useHandler(self, havenum)
        goldBuySoulORBp:refreash()
        return
    end
    Api:useItem('item', currendID .. "", self.selectNum.text,
        function(result)
            local itemvalue
            local list = RewardMrg.getList(result)
            table.foreach(list,
                function(i, v)
                    itemvalue = v
                end)
            if itemvalue ~= nil then
                MessageMrg.showMove(TextMap.GetValue("Text367") .. itemvalue:getDisplayName() .. " [-]X " .. itemvalue.rwCount)
                if itemvalue:getDisplayName() == TextMap.GetValue("Text40") then --临时解决方案,以后记得更改
                MusicManager.playByID(25)
                end
                itemvalue = nil
            end
            --UIMrg:popWindow()
            self:onClose()
        end, currendID)
end

function goldBuySoulORBp:onBuyhandler()
    if Player.Resource.gold < true_price then
        DialogMrg.ShowDialog(TextMap.GetValue("Text368"), DialogMrg.chognzhi)
        return
    end
    if indexData[currendID] == nil then
        MessageMrg.show(TextMap.GetValue("Text369"))
        UIMrg:popWindow()
        return
    end
    Api:buyPartly(7, indexData[currendID], self.selectNum.text,
        function(result)
            local item =uItem:new(currendID)
            MessageMrg.showMove(TextMap.GetValue("Text370") .. item:getDisplayColorName() .. " X " .. self.selectNum.text)
            goldBuySoulORBp:refreash()
        end)
end

function goldBuySoulORBp:onClose()
    if self._callBack ~= nil then
        self:_callBack()
    end
    self._callBack = nil
    UIMrg:popWindow()
end

function goldBuySoulORBp:create()
    return
end

function goldBuySoulORBp:onClick(go, name)
    if name == "useBtn" then
        if self.txt_purchase.text == TextMap.GetValue("Text68") then
            self:onClose()
            DialogMrg.chognzhi()
        elseif self.txt_purchase.text == TextMap.GetValue("Text1346") then
            self:onClose()
        else
            if havenum~=nil and havenum>0 then 
                goldBuySoulORBp:onUsehandler()
            else 
                goldBuySoulORBp:onBuyhandler()
            end
        end
    elseif name == "closeBtnAll" then
        self:onClose()
    elseif name == "closeBtn" then
        self:onClose()
    elseif name == "cancle" then
        self:onClose()
    end
end

return goldBuySoulORBp