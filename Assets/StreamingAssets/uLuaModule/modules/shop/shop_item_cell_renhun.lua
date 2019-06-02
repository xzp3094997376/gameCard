--
-- Created by IntelliJ IDEA.
-- User: xiyou
-- Date: 2014/10/14
-- Time: 14:13
-- To change this template use File | Settings | File Templates.
-- 商城道具

local item_cell = {}
local ITEM_HAS_NOT = TextMap.GetValue("Text1412")
local lastTimes = 0
function item_cell:update(item, index, myTable, delegate)
    self.shop_item = item.shop_item
    self.item = item
    self.delegate = delegate
    self._type = item.SHOP_TYPE
    self:onUpdate()
end

--商店不支持直接卖英雄，只能买碎片和道具
local itemBind
function item_cell:onUpdate()
    self.effect:SetActive(false)
    local shop_item = self.shop_item
    local item = self.item
    if itemBind == nil then
        itemBind = ClientTool.loadAndGetLuaBindingFromPool("Prefabs/publicPrefabs/itemAll", self.pic.gameObject)
    end
    itemBind:CallUpdate({ "char", item, self.pic.width, self.pic.height })
    local count = 1
    if shop_item.count > 1 then
        count = shop_item.count
    end
    if self.item.__count ~= nil then count = self.item.__count end
    item.rwCount = 1
    if self._type ~= 7 then
        self.number.gameObject:SetActive(true)
        self.number.text = count
        self.xiangou:SetActive(false)
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
        self.xiangou:SetActive(true)
        if (lastTimes) <= 0 then
            self.sell:SetActive(true)
            self.xiangouLabel.text = (0) .. "/" .. shop_item.count
            BlackGo.setBlack(0.5, self.bg.transform)
        else
            self.sell:SetActive(false)
            self.xiangouLabel.text = (shop_item.count - shop_item.buy_num) .. "/" .. shop_item.count
            BlackGo.setBlack(1, self.bg.transform)
        end
    end
   
    self.txt_name.text =  item.itemColorName 
    local price = shop_item.sell_price
    local true_price = shop_item.sell_num
    --出售上限
    -- if true_price > shop_item.inc_limit then true_price = shop_item.inc_limit end
    if shop_item.sell_discount ~= 100 then
        -- true_price = price * shop_item.sell_discount / 100
        self.old_img_icon:SetActive(true)
        self.img_discount:SetActive(true)
        self.img_discount:GetComponent("UISprite").spriteName = self:getDiscountPic(shop_item.sell_discount)
        local disPlayPrice = price + math.floor(shop_item.buy_num / (shop_item.step or 1)) * (shop_item.inc or 0)

        --出售上限
        -- if disPlayPrice > shop_item.inc_limit then disPlayPrice = shop_item.inc_limit end
        self.txt_price.text = disPlayPrice
    else
        -- true_price = price
        self.old_img_icon:SetActive(false)
        self.img_discount:SetActive(false)
    end
    -- self.true_price.text = true_price
    self.txt_price_nomal.gameObject:SetActive(false)
    self.txt_price_un.gameObject:SetActive(false)

    if (Tool.getCountByType(shop_item.sell_type) < true_price) then
        self.txt_price_un.gameObject:SetActive(true)
        self.txt_price_un.text = true_price
    else
        self.txt_price_nomal.gameObject:SetActive(true)
        self.txt_price_nomal.text = true_price
    end
    -- self.img_icon.spriteName = Tool.getResIcon(shop_item.sell_type)
    local iconName = Tool.getResIcon(shop_item.sell_type)

    item_cell:setIcon("img_huobi", iconName, true)
    item_cell:setIcon("img_icon", iconName, false)

    if iconName == "resource_zuanshi" then --如果是钻石
    self.effect:SetActive(true)
    end
    -- self.img_huobi.spriteName = iconName
    self._prize = true_price
end

function item_cell:setIcon(old, name, ret)
    local assets = packTool:getIconByName(name)
    self[old]:setImage(name, assets)
    Tool.SetActive(self[old], ret)
end

function item_cell:getDiscountPic(discount)
    if discount == 100 then return "" end
    return "discount_" .. discount / 10
end

function item_cell:onBuy()
    if self._type == 7 then
        if lastTimes <= 0 then
            MessageMrg.show(TextMap.GetValue("Text1411"))
            return
        end
        UIMrg:pushWindow("Prefabs/moduleFabs/puYuanStoreModule/shop_zahuoBuy", {
            prize = self._prize,
            maxCount = lastTimes,
            item = self.item,
            delegate = self.delegate
        })
        return
    end
    if self.shop_item.sell then
        MessageMrg.show(ITEM_HAS_NOT)
        return
    end
    -- UIMrg:pushWindow("Prefabs/moduleFabs/puYuanStoreModule/puYuanStore_buyTips", {
    --     delegate = self.delegate,
    --     item = self.item
    -- })
    local that = self
    Api:buyShop(self.item.SHOP_TYPE, self.item.shop_pos, function(result)
        -- that.delegate:checkUpdate()
        local tp = 0
        if that.item:getType() == "char" then tp = 1 end
        packTool:showMsg(result, nil, tp)
        item_cell:onUpdate()
        if that.delegate.updateRes then
            that.delegate:updateRes()
        end
    end)
end


function item_cell:Start()
    --ClientTool.AddClick(self.binding, funcs.handler(self, self.onBuy))
    ClientTool.AddClick(self.new_img_icon, funcs.handler(self, self.onBuy))
end

return item_cell