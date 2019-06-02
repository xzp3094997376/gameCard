local m = {}
local leagueShop = {}
local SHOP_TYPE = 22 --商店类型
function m:update(data)
	self:readLeagueShopData()
	local list = self:getShopData()
    list = self:SortList(list)
    self.svLeagueList:refresh(list, self, true, 0)
	--self:getShopDataFormServer(SHOP_TYPE)   
end

function m:SortList(list)
    table.sort(list,function(a,b)
        local bool_a = false
        local bool_b = false

        if Player.GuildPkg ~= nil and Player.GuildPkg[a.shop_item.posid] == 1 then
            bool_a = true
        else
            bool_a = false
        end

        if Player.GuildPkg ~= nil and Player.GuildPkg[b.shop_item.posid] == 1 then
            bool_b = true
        else
            bool_b = false
        end

        if bool_a ~= bool_b then
            return not bool_a and bool_b
        end


        return a.shop_item.posid < b.shop_item.posid
    end)
    return list
end


function m:getShopData()
    local list = {}
    local shop_list = leagueShop[SHOP_TYPE]
    local count = #shop_list

    for i = 1, count do
        local cell = shop_list[i]
        local item
        local type = cell.type
        if type == "char" then
            item = Char:new(cell.id)
            --fix[浦沅商店]已拥有英雄等级会错误的显示在整卡上.
            if item.info.level > 0 then
                item = CharPiece:new(item.id)
                item.__count = item.needCharNumber
            end
        elseif type == "charPiece" then
            item = CharPiece:new(cell.id)
        elseif type == "equip" then
            item = Equip:new(cell.id)
        elseif type == "equipPiece" then
            item = EquipPiece:new(cell.id)
        elseif type == "ghostPiece" then
            item = GhostPiece:new(cell.id)
        elseif type == "ghost" then
            item = Ghost:new(cell.id)
        elseif type == "reel" then
            item = Reel:new(cell.id)
        elseif type == "reelPiece" then
            item = ReelPiece:new(cell.id)
        elseif type == "item" then
            item = uItem:new(cell.id)
        end
        item.SHOP_TYPE = SHOP_TYPE
        item.shop_pos = i
        item.shop_item = cell
        table.insert(list, item)
    end
    return list
end

function m:readLeagueShopData()
    leagueShop[22] = {}

    TableReader:ForEachLuaTable("guildPackage", function(index, item) --奖励物品可以在道具商店和奖励商店显示，只能领取一次
    if item.id ~= nil then
        if item.which_shop == 22 then
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

        end
    end
    return false
    end)
end


function m:getShopDataFormServer(shopid)
	print("............")
    Api:getShopList(shopid, function(result)
    		
        local count = result.shop.items.Count
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
        end
        
    end, function(result)
        print("getShopList fail!")
        return false
    end)
end


function m:onClick(go, btnName)
    if btnName == "btn_close" then
        UIMrg:popWindow()
    end
end

return m