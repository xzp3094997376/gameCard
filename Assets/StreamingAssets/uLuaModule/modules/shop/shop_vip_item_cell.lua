--
-- Created by IntelliJ IDEA.
-- User: xiyou
-- Date: 2014/10/14
-- Time: 14:13
-- To change this template use File | Settings | File Templates.
-- 商城道具

local item_cell = {}
local ITEM_HAS_NOT = TextMap.GetValue("Text1410")
local lastTimes = 0
function item_cell:update(item, index, myTable, delegate)
    self.shop_item = item.shop_item
    self.item = item
    self.delegate = delegate
    self._type = item.SHOP_TYPE
    self:onUpdate()
end

local itemBind
function item_cell:onUpdate()
    self.effect:SetActive(false)
    local shop_item = self.shop_item
    local item = self.item
    if itemBind == nil then
        itemBind = ClientTool.loadAndGetLuaBindingFromPool("Prefabs/publicPrefabs/itemAll", self.pic.gameObject)
    end
    itemBind:CallUpdate({ "char", item, self.pic.width, self.pic.height })
    itemBind:CallTargetFunctionWithLuaTable("HideNum")
    local count = 1
    if shop_item.count > 1 then
        count = shop_item.count
    end
    if self.item.__count ~= nil then count = self.item.__count end
    item.rwCount = 1

    self.number.gameObject:SetActive(false)
    if count > 1 then
        self.number.gameObject:SetActive(true)
        self.number.text = tostring(count)
    end

    lastTimes = shop_item.max_num - shop_item.buy_num
    if (lastTimes) <= 0 then
        self.xiangouLabel.text = TextMap.GetValue("Text_1_1072")
    else
        self.xiangouLabel.text = string.gsub(TextMap.GetValue("LocalKey_839"),"{0}",lastTimes)
    end
    if shop_item.item_limit_type=="vip" then 
        self.txt_des.text=string.gsub(TextMap.GetValue("LocalKey_797"),"{0}",shop_item.item_limit_args)
    elseif shop_item.item_limit_type=="lv" then 
        self.txt_des.text=string.gsub(TextMap.GetValue("LocalKey_798"),"{0}",shop_item.item_limit_args)
    end 

    self.txt_name.text = item.name
    local price = shop_item.sell_price
    local true_price = shop_item.sell_price

    local iconName = Tool.getResIcon(shop_item.sell_type)
    item_cell:setIcon("img_huobi", iconName, true)
    item_cell:setIcon("img_huobi1", iconName, true)
    self.img_discount:SetActive(false)
    if shop_item.sell_discount ~= 100 then
        self.img_discount.gameObject:SetActive(true)
        local zhe = math.floor(shop_item.sell_discount/10)
        self.txt_sale.text =string.gsub(TextMap.GetValue("LocalKey_789"),"{0}",zhe)
    end
    if shop_item.sell_discount~=nil then 
        true_price = math.floor(true_price * shop_item.sell_discount / 100 + 0.5)
    end 
    self.txt_price_cur.text = true_price
    self.txt_price_nomal.text = price
    if shop_item.sell_type == "gold" then --如果是钻石
        self.effect:SetActive(true)
        self.effect1:SetActive(true)
    end
    if shop_item.item_limit_type == "vip" and Player.Info.vip < shop_item.item_limit_args then
        self.btn_name.text=TextMap.GetValue("Text68")
        self.xiangouLabel.text=TextMap.GetValue("Text_1_127")
    elseif shop_item.item_limit_type == "lv" and Player.Info.level < shop_item.item_limit_args then
        self.btn_name.text=TextMap.GetValue("Text1464")
        self.xiangouLabel.text=TextMap.GetValue("Text499")
    else
        self.btn_name.text=TextMap.GetValue("Text1464")
    end
end

function item_cell:setIcon(old, name, ret)
    self[old].Url =UrlManager.GetImagesPath("itemImage/" .. name .. ".png")
end


function item_cell:getVIPLVPic(viplv)
    if viplv > 15 then
        viplv = 15
    end
    return "SD-vip" .. viplv
end

function item_cell:onClick(go, btName)
    if lastTimes <= 0 then
        MessageMrg.show(TextMap.GetValue("Text1411"))
        return
    end
    local shop_item = self.shop_item
    if shop_item.item_limit_type == "vip" then
        if Player.Info.vip < shop_item.item_limit_args then
            DialogMrg.ShowDialog(TextMap.GetValue("Text_1_1087") , function()
                DialogMrg.chognzhi()
                end)
            return
        end
    elseif shop_item.item_limit_type == "lv" then
        if Player.Info.level < shop_item.item_limit_args then
            MessageMrg.show(string.gsub(TextMap.GetValue("LocalKey_751"),"{0}",shop_item.item_limit_args)
            return
        end
    end
    local true_price = shop_item.sell_price
    if shop_item.sell_discount~=nil then 
        true_price = math.floor(true_price * shop_item.sell_discount / 100 + 0.5)
    end
    local canBuyNum =math.floor(Tool.getCountByType(shop_item.sell_type)/tonumber(true_price))
    canBuyNum=math.min(canBuyNum,lastTimes)
    if canBuyNum>0 then 
        UIMrg:pushWindow("Prefabs/moduleFabs/puYuanStoreModule/shop_zahuoBuy", {
            prize = self._prize,
            maxCount = lastTimes,
            item = self.item,
            delegate = self.delegate
        })
    else 
        if lastTimes <= 0 then
            MessageMrg.show(TextMap.GetValue("Text1411"))
            return
        end
        if canBuyNum <=0 then 
            MessageMrg.show(TextMap.GetValue("Text_1_1075"))
            return
        end
    end 
end


function item_cell:Start()
    
end

return item_cell