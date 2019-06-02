--
-- Created by IntelliJ IDEA.
-- User: xiyou
-- Date: 2014/10/14
-- Time: 14:13
-- To change this template use File | Settings | File Templates.
-- 公会商城道具

local league_item_cell = {}
local ITEM_HAS_NOT = TextMap.GetValue("Text1412")
local lastTimes = 0
function league_item_cell:update(item, index, myTable, delegate)
    self.shop_item = item.shop_item
    self.item = item
    self.delegate = delegate
    self._type = item.SHOP_TYPE
    self:onUpdate()
end

--商店不支持直接卖英雄，只能买碎片和道具
local itemBind
function league_item_cell:onUpdate()
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
    local price = shop_item.sell_price * shop_item.sell_discount / 100
    --下标，一次购买的数量
    if count > 1 then
        self.number.gameObject:SetActive(true)
        self.number.text = count
    else
        self.number.gameObject:SetActive(false)
    end

    if shop_item.sell_discount ~= 100 then
        self.old_img_icon:SetActive(true)
        self.img_discount:SetActive(true)
        self.img_discount:GetComponent("UISprite").spriteName = self:getDiscountPic(shop_item.sell_discount)
        self.txt_price.text = price + math.floor(shop_item.buy_num / (shop_item.step or 1)) * (shop_item.inc or 0)
    else
        self.old_img_icon:SetActive(false)
        self.img_discount:SetActive(false)
    end

    local iconName = Tool.getResIcon(shop_item.sell_type)
    league_item_cell:setIcon("img_huobi", iconName, true)

    --处理个人限购、公会限购、公会等级限制控制
    if GuildDatas:getMyGuildInfo().guildLevel >= shop_item.guild_level_limit then
        self.league_level_limit.gameObject:SetActive(false) --公会等级购买限制league_level_limit
        self.xiangou:SetActive(true)
        if self._type == 22 or self._type == 21 or self._type == 20 then --奖励商店

        if shop_item.posid ~= nil and shop_item.posid ~= -1 then -- 表示为奖励类的商品，在《公会奖励商店|guildPackage》表中配置，在道具和奖励商店显示
        self.league_limit_num.gameObject:SetActive(false)
        if Player.GuildPkg ~= nil and Player.GuildPkg[shop_item.posid] == 1 then
            shop_item.sell = true
            self.sell:SetActive(true)
            self.img_discount:SetActive(false)
            self.xiangouLabel.text = "0/1"
            BlackGo.setBlack(0.5, self.bg.transform)
        else
            shop_item.sell = false
            self.sell:SetActive(false)
            lastTimes = 1
            self.xiangouLabel.text = "1/1"
            BlackGo.setBlack(1, self.bg.transform)
        end
        else
            if shop_item.guild_limit_num <= 0 then --公会限购\限时商店\道具商店
            self.league_limit_num.gameObject:SetActive(false)
            else
                self.league_limit_num.gameObject:SetActive(true)
                local guildleftnum = shop_item.guild_limit_num - shop_item.guild_buy_num
                if guildleftnum > 0 then
                    self.old_img_icon:SetActive(false)
                    local tmp =string.gsub(TextMap.GetValue("LocalKey_696"),"{0}",guildleftnum)
                    self.league_limit_num.text = tmp
                elseif guildleftnum == 0 then
                    self.old_img_icon:SetActive(false)
                    local tmp =string.gsub(TextMap.GetValue("LocalKey_696"),"{0}",guildleftnum)
                    self.league_limit_num.text = tmp
                    self.sell:SetActive(true)
                    self.img_discount:SetActive(false)
                    BlackGo.setBlack(0.5, self.bg.transform)
                else
                    self.league_limit_num.gameObject:SetActive(false)
                end
            end

            if shop_item.per_limit_num <= 0 then
                self.xiangou:SetActive(false)
                self.sell:SetActive(false)
            else
                lastTimes = shop_item.per_limit_num - shop_item.buy_num
                self.xiangou:SetActive(true)
                if (lastTimes) <= 0 or shop_item.sell then
                    self.sell:SetActive(true)
                    self.img_discount:SetActive(false)
                    self.xiangouLabel.text = (0) .. "/" .. shop_item.per_limit_num
                    BlackGo.setBlack(0.5, self.bg.transform)
                else
                    self.sell:SetActive(false)
                    self.xiangouLabel.text = (shop_item.per_limit_num - shop_item.buy_num) .. "/" .. shop_item.per_limit_num
                    BlackGo.setBlack(1, self.bg.transform)
                end
            end
        end
        end
    else
        self.xiangou:SetActive(false)
        self.old_img_icon:SetActive(false)
        self.sell:SetActive(false)
        self.league_limit_num.gameObject:SetActive(false)
        self.league_level_limit.gameObject:SetActive(true)
        self.league_level_limit.text =string.gsub(TextMap.GetValue("LocalKey_756"),"{0}",shop_item.guild_level_limit)
        BlackGo.setBlack(0.5, self.bg.transform)
    end

    self.txt_name.text = item.name
    --local true_price = shop_item.sell_num

    self.txt_price_nomal.gameObject:SetActive(false)
    self.txt_price_un.gameObject:SetActive(false)

    if (Tool.getCountByType(shop_item.sell_type) < price) then
        self.txt_price_un.gameObject:SetActive(true)
        self.txt_price_un.text = price
    else
        self.txt_price_nomal.gameObject:SetActive(true)
        self.txt_price_nomal.text = price
    end
    if shop_item.sell_type == "gold" then --如果是钻石
    self.effect:SetActive(true)
    end
    self._prize = price
end

function league_item_cell:setIcon(old, name, ret)
    local assets = packTool:getIconByName(name)
    self[old]:setImage(name, assets)
    Tool.SetActive(self[old], ret)
end


function league_item_cell:getDiscountPic(discount)
    if discount == 100 then return "" end
    return "discount_" .. discount / 10
end

function league_item_cell:onBuy()
    if self._type == 20 or self._type == 21 or self._type == 22 then
        if GuildDatas:getMyGuildInfo().guildLevel < self.item.shop_item.guild_level_limit then
            MessageMrg.show(TextMap.GetValue("Text1416"))
            return
        elseif lastTimes <= 0 then
            MessageMrg.show(TextMap.GetValue("Text1417"))
            return
        elseif self.shop_item.sell then
            MessageMrg.show(ITEM_HAS_NOT)
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
end


function league_item_cell:Start()
    ClientTool.AddClick(self.binding, funcs.handler(self, self.onBuy))
end

return league_item_cell