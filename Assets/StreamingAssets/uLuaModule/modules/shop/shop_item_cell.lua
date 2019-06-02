
-- 商城道具

local item_cell = {}
local ITEM_HAS_NOT = TextMap.GetValue("Text1410")
local lastTimes = 0
function item_cell:update(item, index, myTable, delegate)
    self.shop_item = item.shop_item
    self.item = item
    self.delegate = delegate
    self._type = item.SHOP_TYPE
    if self.item.name==nil then
        self.obj:SetActive(false)
    else
        self:onUpdate()
    end
end

--商店不支持直接卖英雄，只能买碎片和道具
local itemBind
function item_cell:onUpdate()
    self.effect:SetActive(false)
    local shop_item = self.shop_item
    local item = self.item
    self.dropTypeList = {}
    table.insert(self.dropTypeList, item:getType())
    if itemBind == nil then
        itemBind = ClientTool.loadAndGetLuaBindingFromPool("Prefabs/publicPrefabs/itemAll", self.pic.gameObject)
    end
    if item.desc ~=nil then 
        self.txt_des.text="[6E3109]" .. item.desc .. "[-]"
    end
    item:updateInfo()
    itemBind:CallUpdate({"char", item, self.pic.width, self.pic.height,true})
    local count = 1
    if shop_item.count > 1 then
        count = shop_item.count
    end
    if self.item.__count ~= nil then count = self.item.__count end
    item.rwCount = 1
    if self.shoptype==0 then
        self.number.gameObject:SetActive(true)
        self.number.text = count
        if item:getType()=="charPiece" or item:getType()=="ghostPiece" or item:getType()== "treasurePiece" then 
            self.xiangouLabel.text="[EB3308]" .. item.count .. "/" .. item.needCharNumber .. "[-]"
        else 
            self.xiangouLabel.text=""
        end
        if shop_item.sell then
            self.sell:SetActive(true)
            BlackGo.setBlack(0.5, self.bg.transform)
        else
            self.sell:SetActive(false)
            BlackGo.setBlack(1, self.bg.transform)
        end
    else
        self.number.gameObject:SetActive(false)
        lastTimes = shop_item.count - shop_item.buy_num
        self.xiangouLabel.gameObject:SetActive(true)
        if (lastTimes) <= 0 then
            self.sell:SetActive(true)
            BlackGo.setBlack(0.5, self.bg.transform)
            self.xiangouLabel.text = TextMap.GetValue("Text_1_1072")
        else
            self.sell:SetActive(false)
            BlackGo.setBlack(1, self.bg.transform)
            self.xiangouLabel.text =string.gsub(TextMap.GetValue("LocalKey_839"),"{0}",lastTimes)
        end
    end
    self.txt_name.text = item:getDisplayColorName()
    self._prize={}
    local priceList = {}
    if shop_item.price[0].sell_type~="" then 
        table.insert( priceList, shop_item.price[0])
    end 
    if shop_item.price[1].sell_type~="" then 
        table.insert( priceList, shop_item.price[1])
    end
    if priceList==nil then return end 
    self.canbuynum = lastTimes
    local buy_num = shop_item.buy_num
    --for i=1,#priceList do 
        self.effect:SetActive(false)
        local price = priceList[1].sell_price
        local true_price = priceList[1].sell_num
        --出售上限
        if priceList[1].inc_limit ~= nil and true_price > priceList[1].inc_limit then 
            true_price = priceList[1].inc_limit 
        end
        if priceList[1].sell_discount ~= 100 then
            self.img_discount:SetActive(true)
            self.txt_sale.text = self:getDiscountStr(priceList[1].sell_discount)
            local disPlayPrice = price + math.floor(shop_item.buy_num / (priceList[1].step or 1)) * (priceList[1].inc or 0)
            --出售上限
            if priceList[1].inc_limit ~= nil and disPlayPrice > priceList[1].inc_limit then 
                disPlayPrice = priceList[1].inc_limit 
            end
        else 
            self.img_discount:SetActive(false)
        end
        local iconName=""
        if priceList[1].sell_type == "item" then 
            local itemcell=uItem:new(priceList[1].sell_arg)
            iconName = itemcell.Table.iconid
            local buynum =0
            local totalNum = itemcell.count
            for j=1,self.canbuynum do
                if totalNum>=true_price then 
                    buy_num=buy_num+1
                    local cur_price =price+math.floor((buy_num-1)/tonumber(priceList[1].step))*tonumber(priceList[1].inc)
                    --出售上限
                    if priceList[1].inc_limit ~= nil and cur_price > priceList[1].inc_limit then 
                        cur_price = priceList[1].inc_limit 
                    end
                    if totalNum>=cur_price then 
                        buynum=buynum+1
                        totalNum=totalNum-cur_price
                    end 
                end 
            end
            self.canbuynum=math.min(self.canbuynum,buynum)
            if itemcell.count < true_price then
                self.txt_price_nomal.text ="[ff0000]" .. true_price .. "[-]"
            else
                self.txt_price_nomal.text ="[FFFFFF]" .. true_price .. "[-]"
            end
        else 
            iconName = Tool.getResIcon(priceList[1].sell_type)
            local buynum =0
            local totalNum =Tool.getCountByType(priceList[1].sell_type)
            for j=1,self.canbuynum do
                if totalNum>true_price then 
                    buy_num=buy_num+1
                    local cur_price =price+math.floor((buy_num-1)/tonumber(priceList[1].step))*tonumber(priceList[1].inc)
                    --出售上限
                    if priceList[1].inc_limit ~= nil and cur_price > priceList[1].inc_limit then 
                        cur_price = priceList[1].inc_limit 
                    end
                    if totalNum>=cur_price then 
                        buynum=buynum+1
                        totalNum=totalNum-cur_price
                    end 
                end 
            end
            self.canbuynum=math.min(self.canbuynum,buynum)
            if (Tool.getCountByType(priceList[1].sell_type) < true_price) then
                self.txt_price_nomal.text ="[ff0000]" .. true_price .. "[-]"
            else
                if priceList[1].sell_type=="gold" then 
                    self.txt_price_nomal.text ="[F0E77B]" .. true_price .. "[-]"
                else
                    self.txt_price_nomal.text ="[FFFFFF]" .. true_price .. "[-]"
                end 
            end
        end
        self["img_huobi"].Url =UrlManager.GetImagesPath("itemImage/" .. iconName .. ".png")
        if priceList[1].sell_type=="gold" then  --如果是钻石
            self["effect"]:SetActive(true)
        end
        self._prize[1]= true_price
    --end
    self._prize = true_price
end

function item_cell:getDiscountStr(discount)
    if discount == 100 then return "" end
    return string.gsub(TextMap.GetValue("LocalKey_789"),"{0}",discount / 10)
end

function item_cell:onClick(go, name)
	if name == "new_img_icon" then
        if Tool:judgeBagCount(self.dropTypeList) == false then return end
		self:onBuy()
	end 
end 

function item_cell:onBuy()
    if self._type == 7 or self._type == 9 or self._type == 15 then
        if lastTimes <= 0 then
            MessageMrg.show(TextMap.GetValue("Text1411"))
            return
        end
        local canbuynum=self.canbuynum
        if canbuynum <=0 then 
            MessageMrg.show(TextMap.GetValue("Text_1_1075"))
            return
        end
        print (canbuynum)
        UIMrg:pushWindow("Prefabs/moduleFabs/puYuanStoreModule/shop_zahuoBuy", {
            shoptype=self.shoptype,
            prize = self._prize,
            maxCount =math.min(lastTimes,canbuynum),
            item = self.item,
            delegate = self
        })
        return
    end
    if self.shop_item.sell then
        MessageMrg.show(ITEM_HAS_NOT)
        return
    end
    UIMrg:pushWindow("Prefabs/moduleFabs/puYuanStoreModule/puYuanStore_buyTips", {
        delegate = self.delegate,
        item = self.item
    })
end


function item_cell:Start()
    --ClientTool.AddClick(self.binding, funcs.handler(self, self.onBuy))
end

return item_cell