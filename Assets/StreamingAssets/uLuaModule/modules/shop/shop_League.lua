--
-- Created by IntelliJ IDEA.
-- User: zhangqingbin
-- Date: 2015/7/20
-- Time: 11:46
-- To change this template use File | Settings | File Templates.
-- 公会商店
local m = {}
local isLoadShopData = false
local leagueShop = {}
local Countdown = {}
local SHOP_TYPE = 20 --商店类型
--商店数据
function m:getShopData()
    local list = {}
    local shop_list = leagueShop[SHOP_TYPE]
    local count = #shop_list
    print("ShopType " .. SHOP_TYPE)
    print("count " .. count)
    for i = 1, count do
        local cell = shop_list[i]
        local item
        local type = cell.type
        if type == "char" then
            item = Char:new(cell.id)
            --fix【浦沅商店】已拥有英雄等级会错误的显示在整卡上。
            if item.info.level > 0 then
                item = CharPiece:new(item.id)

                item.__count = item.needCharNumber
            end
            item.SHOP_TYPE = SHOP_TYPE
            item.shop_pos = i
            item.shop_item = cell
            table.insert(list, item)
        elseif type == "charPiece" then
            item = CharPiece:new(cell.id)
            item.SHOP_TYPE = SHOP_TYPE
            item.shop_pos = i
            item.shop_item = cell
            table.insert(list, item)
        elseif type == "equip" then
            item = Equip:new(cell.id)
            item.SHOP_TYPE = SHOP_TYPE
            item.shop_pos = i
            item.shop_item = cell
            table.insert(list, item)
        elseif type == "equipPiece" then
            item = EquipPiece:new(cell.id)
            item.SHOP_TYPE = SHOP_TYPE
            item.shop_pos = i
            item.shop_item = cell
            table.insert(list, item)
        elseif type == "ghostPiece" then
            item = GhostPiece:new(cell.id)
            item.SHOP_TYPE = SHOP_TYPE
            item.shop_pos = i
            item.shop_item = cell
            table.insert(list, item)
        elseif type == "ghost" then
            item = Ghost:new(cell.id)
            item.SHOP_TYPE = SHOP_TYPE
            item.shop_pos = i
            item.shop_item = cell
            table.insert(list, item)
        elseif type == "reel" then
            item = Reel:new(cell.id)
            item.SHOP_TYPE = SHOP_TYPE
            item.shop_pos = i
            item.shop_item = cell
            table.insert(list, item)
        elseif type == "reelPiece" then
            item = ReelPiece:new(cell.id)
            item.SHOP_TYPE = SHOP_TYPE
            item.shop_pos = i
            item.shop_item = cell
            table.insert(list, item)
        elseif type == "item" then
            item = uItem:new(cell.id)
            item.SHOP_TYPE = SHOP_TYPE
            item.shop_pos = i
            item.shop_item = cell
            table.insert(list, item)
        end
    end
    return list
end

function m:OnDestroy()
end

function m:updateRes()
    -- body
end

function m:onEnter()
end

function m:onExit()
end

function m:onUpdate()
    if self.isRefrsh == true then
        self.isRefrsh = false
        print("m:onUpdate")
        self:onRefresh()
    end
end


function m:setIcon(old, name, ret)
    local assets = packTool:getIconByName(name)
    self[old]:setImage(name, assets)
    Tool.SetActive(self[old], ret)
end

--更新道具列表
function m:updateItem(view)
    --更新货币显示
    local iconName = Tool.getResIcon("donate")
    m:setIcon("img_coin", iconName, true)
    self.txt_count.text = Player.Resource.donate

    local list = self:getShopData()
    ClientTool.UpdateGrid("Prefabs/moduleFabs/puYuanStoreModule/shop_League_item_cell", view, list, self)
end

function m:showMsg(result)
    packTool:showMsg(result, nil, 1)
end

--点击金币
function m:onItem(go)
    self.img_refreshDi:SetActive(false)
    self.btn_item.isEnabled = false
    self.btn_gift.isEnabled = true
    self.btn_zahuo.isEnabled = true

    SHOP_TYPE = 20
    self:getShopDataFormServer(20)
    self.txt_refresh_time.text = ""
    self.info:SetActive(true)
    self.img_refreshDi:SetActive(true)
    self:updateItem(self.item_view)
end

--点击杂货
function m:onZahuo(go)
    self.__curTab = 2

    self.info:SetActive(true)
    self.btn_item.isEnabled = true
    self.btn_gift.isEnabled = true
    self.btn_zahuo.isEnabled = false
    self.zahuo:SetActive(true)
    self.txt_refresh_time.text = ""
    SHOP_TYPE = 21
    self:getShopDataFormServer(21)
    self.img_refreshDi:SetActive(true)
    self:updateItem(self.zahuo_view)
end

--点击礼包
function m:onGift(go)
    self.__curTab = 3
    self.info:SetActive(false)
    self.btn_item.isEnabled = true
    self.btn_gift.isEnabled = false
    self.btn_zahuo.isEnabled = true
    self.item:SetActive(false)
    self.zahuo:SetActive(false)

    SHOP_TYPE = 22
    self.img_refreshDi:SetActive(false)
    self:updateItem(self.gift_view)
end

function m:onRefresh(go)
    print("m:onRefresh(go)")
    if SHOP_TYPE == 20 then
        self:updateItem(self.item_view)
    elseif SHOP_TYPE == 21 then
        self:updateItem(self.zahuo_view)
    elseif SHOP_TYPE == 22 then
        self:updateItem(self.gift_view)
    end
end

function m:onClick(go, name)
    if name == "btn_gift" then
        self:onGift(go)
    elseif name == "btn_item" then
        self:onItem(go)
    elseif name == "btn_zahuo" then
        self:onZahuo(go)
    end
end

function m:readLeagueShopData()
    if isLoadShopData then
        return
    end
    isLoadShopData = true
    leagueShop[20] = {}
    leagueShop[21] = {}
    leagueShop[22] = {}
    print("readLeagueShopData")
    TableReader:ForEachLuaTable("guildshop_refresh", function(index, item)
        print("guildshop_refresh")
        print("guildshop_refresh item.shop " .. item.shop)
        if item.shop == 20 or item.shop == 22 then
            local listshop = leagueShop[item.shop]
            local start = 0
            local len = 0
            if type(item.drop) == "table" then
                start = 1
                len = #item.drop
            else
                len = item.drop.Count - 1
            end
            for i = start, len do
                local itemdata = nil
                for j = 1, #listshop do
                    if listshop[j].type == item.drop[i].type and listshop[j].id == item.drop[i].arg then
                        itemdata = listshop[j]
                        break
                    end
                end
                if itemdata == nil then
                    itemdata = { buy_record = 0, type = "", id = 0, count = 1, per_limit_num = 1, guild_level_limit = 1, guild_limit_num = 0, guild_buy_num = 0, buy_num = 0, sell = false, sell_type = "gold", sell_num = 0, sell_discount = 100, sell_price = 8888, step = 1, inc = 0 }
                    itemdata.type = item.drop[i].type
                    itemdata.id = item.drop[i].arg
                    itemdata.count = item.drop[i].arg2
                    itemdata.sell_type = item.drop[i].show_price_type
                    itemdata.sell_price = item.drop[i].show_price
                    itemdata.guild_level_limit = item.limitArg
                    table.insert(leagueShop[item.shop], itemdata)
                end
            end
        end
        return false
    end)
    TableReader:ForEachLuaTable("guildPackage", function(index, item) --奖励物品可以在道具商店和奖励商店显示，只能领取一次
    print("guildPackage")
    if item.id ~= nil then
        if item.which_shop == 20 or item.which_shop == 22 then
            local i = 0
            if type(item.drop) == "table" then
                i = 1
            end
            local itemdata = { type = "", id = 0, count = 1, posid = -1, per_limit_num = 1, guild_level_limit = 1, guild_limit_num = 0, guild_buy_num = 0, buy_num = 0, sell = false, sell_type = "gold", sell_num = 0, sell_discount = 100, sell_price = 888, step = 1, inc = 0 }
            itemdata.type = item.drop[i].type
            itemdata.id = item.drop[i].arg
            itemdata.count = item.drop[i].arg2
            itemdata.posid = item.id
            itemdata.per_limit_num = item.drop[i].limit
            itemdata.sell_type = item.consume[i].consume_type
            itemdata.sell_price = item.consume[i].consume_arg

            itemdata.guild_level_limit = item.guildlevel_limit
            table.insert(leagueShop[item.which_shop], itemdata)
            print("guildPackage item.which_shop" .. item.which_shop)
            print("guildPackage itemdata.type" .. itemdata.type)
            print("guildPackage itemdata.id" .. itemdata.id)
        end
    end
    return false
    end)
end

--shopid 20\21\22 ---道具\限时\奖励
function m:getShopDataFormServer(shopid)
    if shopid == 21 then
        leagueShop[21] = {}
    end
    Api:getShopList(shopid, function(result)
        print("guild id" .. Player.Info.guildId)

        print("getShopList success!")
        print(type(result.shop.items))
        --todo:获取商店数据
        local count = result.shop.items.Count
        print("count " .. count)
        local jsonres = json.decode(result:toString())
        local listshop = leagueShop[shopid]
        if count > 0 then
            for i = 1, count do
                local itemdata = nil
                local retitemdata = jsonres.shop.items[i]
                if retitemdata == nil then
                    print("retitemdata == nil")
                    break
                end
                for j = 1, #listshop do
                    if listshop[j].type == retitemdata.type and listshop[j].id == retitemdata.id then
                        itemdata = listshop[j]
                        break
                    end
                end
                if itemdata == nil then
                    print("itemdata " .. i)
                    itemdata = { type = "", id = 0, count = 1, posid = -1, per_limit_num = 1, guild_level_limit = 1, guild_limit_num = 0, guild_buy_num = 0, buy_num = 0, sell = false, sell_type = "gold", sell_num = 0, sell_discount = 100, sell_price = 888, step = 1, inc = 0 }
                    table.insert(listshop, itemdata)
                    itemdata.type = retitemdata.type
                    itemdata.id = retitemdata.id
                end
                if itemdata ~= nil then
                    itemdata.buy_num = retitemdata.buy_record
                    itemdata.count = retitemdata.count
                    itemdata.per_limit_num = retitemdata.per_limit_num
                    itemdata.guild_limit_num = retitemdata.guild_limit_num
                    itemdata.guild_buy_num = retitemdata.guild_buy_num
                    itemdata.sell = retitemdata.sell
                    itemdata.sell_type = retitemdata.sell_type
                    itemdata.sell_num = retitemdata.sell_num
                    itemdata.sell_discount = retitemdata.sell_discount
                    itemdata.sell_price = retitemdata.sell_price
                    itemdata.step = retitemdata.step
                    itemdata.inc = retitemdata.inc
                end
            end
            print("jsonres.shop.countdown  " .. jsonres.shop.countdown)
            local tab = os.date("*t", 1200 + jsonres.shop.countdown / 1000)
            self.txt_refresh_time.text =string.gsub(TextMap.GetValue("LocalKey_755"), "{0}", tab.hour)
            if shopid == 20 then
                self:updateItem(self.item_view)
            elseif shopid == 21 then
                self:updateItem(self.zahuo_view)
            end
        end
    end, function(result)
        print("getShopList fail!")
        return false
    end)
end

function m:Start()
    --加入顶部菜单
    LuaMain:ShowTopMenu()
    self:readLeagueShopData()
    m:onItem(go)
end

return m