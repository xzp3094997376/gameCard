local m = {}
--local COST_TYPE = "确定立即刷新商店商品吗?\n(本次操作需要消耗{0}{1})"
--local TODAY = TextMap.GetValue("Text54")
--local TOMORROW = TextMap.GetValue("Text55")

local npc = {
    [3] = "Prefabs/moduleFabs/puYuanStoreModule/shop_npc_union",
    [4] = "Prefabs/moduleFabs/puYuanStoreModule/shop_npc_arena",
    [5] = "Prefabs/moduleFabs/puYuanStoreModule/shop_npc_xuyegong",
    [6] = "Prefabs/moduleFabs/puYuanStoreModule/shop_npc_union",
    [8] = "Prefabs/moduleFabs/puYuanStoreModule/shop_npc_heidian", --黑店
    [9] = "Prefabs/activityModule/encirclementModule/shop_npc_daxu", --围剿大虚
   [15] = "Prefabs/activityModule/world_boss/shop_npc_worldboss",--破面来袭
   [31] = "Prefabs/moduleFabs/attack/shop_npc_biwu" --比武
}
local timerId = 0
--商店数据
function m:getShopData(SHOP_TYPE)
    local list = {}
    local shop_list = Player.Shop[SHOP_TYPE]
    local count = shop_list.count
    for i = 0, count - 1 do
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

function m:getDaXuShopData(_SHOP_TYPE)
    local SHOP_TYPE = _SHOP_TYPE
    local list = {}
    local shop_list = Player.Shop[SHOP_TYPE]
    local count = shop_list.count
    print(".........count="..count)
    for i = 0, count - 1 do
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

function m:setIcon(name)
    if name == "" then
        if self.img_coin then
            self.binding:Hide("img_coin")
        end
    end
    local assets = packTool:getIconByName(name)
    self.img_coin:setImage(name, assets)
    Tool.SetActive(self.img_coin, true)
end

function m:updateRes()
    local img = ""
    if self.type == 3 then
        img = Tool.getResIcon("donate")
        --self.txt_count.text = Player.Resource.donate
    elseif self.type == 4 then
        img = Tool.getResIcon("honor")
        --self.txt_count.text = Player.Resource.honor
    elseif self.type == 5 then
        img = Tool.getResIcon("credit")
        --self.txt_count.text = Player.Resource.credit
    elseif self.type == 8 then
        img = Tool.getResIcon("hunyu")
        --self.txt_count.text = Player.Resource.hunyu
    elseif self.type == 9 then
        img = Tool.getResIcon("battle_exploit")
        --self.txt_count.text = Player.Resource.battle_exploit
    elseif self.type == 15 then
        img = Tool.getResIcon("Ethereal_coin")
        --self.txt_count.text = Player.Resource.Ethereal_coin
        --print("......Ethereal_coin..."..Player.Resource.Ethereal_coin)
    elseif self.type == 31 then
        img = Tool.getResIcon("quiz_point")
        --self.txt_count.text = Player.Resource.quiz_point
    end
    --m:setIcon(img)
end

--[[
3	公会商店
4	竞技场商店
5	虚夜宫
-- ]]
function m:update(lua, ret)
    self.lua = lua
    --print_t(lua)  --[1] => 8
    --print(ret) --nil
    --print(type) --function: builtin#3
    local type = 3
    if lua ~= nil then
        type = lua[1]
    end
    if type == 3 then
        --协会商店
        self.topMenu:CallUpdate({ title = "Gonghuigongyingsuo_biaoti" })
    elseif type == 4 then
        --竞技场商店
        -- self.img_title.spriteName = "shangduan_jingjichang"
        --        self.shopName.text = "竞技场商店"
        self.topMenu:CallUpdate({ title = "Junxuchu_biaoti" })

    elseif type == 5 then
        --虚夜宫商店
        self.topMenu:CallUpdate({ title = "Nili_biaoti" })
    elseif type == 8 then
        --黑店
        --self.bt_lunhui.gameObject:SetActive(true)
        self.topMenu:CallUpdate({ title = "heidian" })
    elseif type == 9 then
        --围剿大虚
        self.topMenu:CallUpdate({ title = "zhangongstore" })
    elseif type == 15 then
        --世界BOSS
        self.topMenu:CallUpdate({ title = "bjsd" })
    elseif type == 31 then
        self.topMenu:CallUpdate({ title = "KFBW-biwushangdian" })
    end
    
    self.type = type
    --m:updateRes()  --设置商店任务图片 现已改成模型
    local row = m:getRowByType(type)
    self.hero:LoadByModelId(row.model, "idle", function() end, false, 0, 1)
    self.txtTitle.text = row.dec
    self.txt_mes.text = row.desc



    if self._inited == false then
        ClientTool.load(npc[type], self.npc_position)
        self._inited = true
    end

    -- ClientTool.UpdateGrid("Prefabs/moduleFabs/puYuanStoreModule/shop_item_cell", self.item_view, list, self)
    if type == 9 or type == 15 then
        list = m:getDaXuShopData(type)
        ClientTool.UpdateGrid("Prefabs/moduleFabs/puYuanStoreModule/shop_item_cell", self.item_view, list, self)
        local tab = os.date("*t", 1200 + Player.Shop[type].countdown / 1000)
        self.txt_refresh_time.text = string.gsub(TextMap.GetValue("LocalKey_750"), "{0}", tab.hour)
        self.binding:Hide("btn_Refresh")
        local go = self.gameObject.transform:Find("bg_back/npc_position/info/img_refreshDi/txt_refresh")
        Tool.SetActive(go, false)
    elseif type == 8 then
        self.txt_renhun_count.text = toolFun.moneyNumberShowOne(math.floor(tonumber(Player.Resource.hunyu)))
        self.npc_position:SetActive(false)
        local list = self:getShopData(type)  --获得商店数据 
        ClientTool.UpdateGrid("Prefabs/moduleFabs/puYuanStoreModule/shop_item_cell_renhun", self.item_view, list, self)

        local time  =Tool.FormatTime(1200 + Player.Shop[type].countdown / 1000 -os.time()) 
        self.txt_refresh_time.text = time
        m:setRefreshTime(self.type)
        -- local shop_list = Player.Shop[type]
        -- local countdown = shop_list.countdown
        -- local tab = os.date("*t", 1200 + countdown / 1000)
        -- local now = os.date("*t")
        -- local str = ""
        -- if tab.day == now.day then
        --     str = TextMap.TODAY
        --     m:setRefreshTime(tab, now)
        -- elseif tab.day - now.day == 1 then
        --     str = TextMap.TOMORROW
        -- end

        local the_row = TableReader:TableRowByUnique("buyLimitTimes", "vip_level", Player.Info.vip) --vip等级购买次数
        local free_times = Player.Shop[type].free_reset_times --已免费次数
        local total_times = 0 --已用次数
        if free_times ~= nil then
            total_times = the_row.heidian_reset_free
        end

        self.txt_count.text = ""          --  刷新令牌
        self.txt_tims.text = total_times - free_times .. "/" .. total_times          --  刷新次数
        --self.txt_mes.text = "欢迎光临忍魂商店，请随意选购"
        --self.txt_refresh_time.text = string.gsub(str, "{0}", tab.hour)   -- 刷新时间
    else   
        local list = self:getShopData(type)
        ClientTool.UpdateGrid("Prefabs/moduleFabs/puYuanStoreModule/shop_item_cell_buy", self.item_view, list, self)
        local shop_list = Player.Shop[type]
        local countdown = shop_list.countdown
        local tab = os.date("*t", 1200 + countdown / 1000)
        local now = os.date("*t")
        local str = ""
        if tab.day == now.day then
            str = TextMap.TODAY
            --m:setRefreshTime(tab, now)
            m:setRefreshTime(self.type)
        elseif tab.day - now.day == 1 then
            str = TextMap.TOMORROW
        end
        self.txt_refresh_time.text = string.gsub(str, "{0}", tab.hour)
    end

    self.binding:CallManyFrame(function()
        self.ScrollView:ResetPosition()
    end,
        1)
    if ret == nil then
        m:checkUpdate()
    end
    self.npc_position:SetActive(false)
end





function m:getRowByType(type)
    local row = {}
    if type==3 then --工会商店
        row=TableReader:TableRowByID("shop_refresh",5)  
    elseif type==4 then --竞技场商店
        if Player.Info.level <30 then
            row=TableReader:TableRowByID("shop_refresh",6)  
        elseif Player.Info.level < 50 then
            row=TableReader:TableRowByID("shop_refresh",12)  
        elseif Player.Info.level < 70 then
            row=TableReader:TableRowByID("shop_refresh",13)  
        else 
            row=TableReader:TableRowByID("shop_refresh",14)  
        end 
    elseif type==5 then --试练塔商店
        row=TableReader:TableRowByID("shop_refresh",7) 
    elseif type==7 then --商城
        row=TableReader:TableRowByID("shop_refresh",8) 
    elseif type==8 then --忍魂商店
        row=TableReader:TableRowByID("shop_refresh",11)   
    elseif type==9 then --战功商店
        row=TableReader:TableRowByID("shop_refresh",9)   
    elseif type==20 then --公会道具商店
        row=TableReader:TableRowByID("shop_refresh",5)   
    elseif type==21 then --公会限时商店
        row=TableReader:TableRowByID("shop_refresh",5) 
    elseif type==22 then --公会奖励商店
        row=TableReader:TableRowByID("shop_refresh",5)   
    elseif type==15 then --补给商店
        row=TableReader:TableRowByID("shop_refresh",15)  
    elseif type==30 then --跨服竞技场商店
        row=TableReader:TableRowByID("shop_refresh",30)  
    elseif type==31 then --跨服比武商店
        row=TableReader:TableRowByID("shop_refresh",31) 
    end 
    return row
end


function m:OnDestroy()
    --    UluaModuleFuncs.Instance.uTimer:removeSecondTime("updateShop")
    --LuaTimer.Delete(timerId)
    shop = nil
    Events.RemoveListener('shop_change')
end

function m:onExit()
    self.isRefrsh = true

    LuaTimer.Delete(timerId)
end


function m:setRefreshTime(type)
    LuaTimer.Delete(timerId)
    timerId = LuaTimer.Add(0,60, function(id)
        local tab = os.date("*t", 1200 + Player.Shop[type].countdown / 1000)
        local now = os.date("*t")
        local time  =Tool.FormatTime(1200 + Player.Shop[type].countdown / 1000 -os.time()) 
        self.txt_refresh_time.text = time
        if tab.hour - now.hour >= 1 and now.min >= 56 then
            --m:checkUpdate()
            return true
        end
    end)
end
-- function m:setRefreshTime(tab, now)
--     --    UluaModuleFuncs.Instance.uTimer:removeSecondTime("updateShop")
--     LuaTimer.Delete(timerId)
--     if tab.hour - now.hour >= 1 and now.min >= 56 then
--         --        UluaModuleFuncs.Instance.uTimer:secondTime("updateShop", 30, 0, self.refreshTime, self) --定时器
--         timerId = LuaTimer.Add(10000, 30000, function(id)
--             m:checkUpdate()
--             return true
--         end)
--     end
-- end

function m:refreshTime()
    m:checkUpdate()
end

function m:onEnter()
    if self.isRefrsh then
        self.isRefrsh = false
        m:checkUpdate()
    end
end


function m:checkUpdate()
    local _type = self.type
    Api:checkUpdateShop(function()
        m:update({ _type }, true)
    end)
end

function m:onRefresh(go)

    local that = self
    local SHOP_TYPE = self.type
    local _shop = Player.Shop[SHOP_TYPE]
    -- if _shop == nil then 
    --     print("shop is nil")
    -- end
    local therow = TableReader:TableRowByUnique("buyLimitTimes", "vip_level", Player.Info.vip) --vip等级购买次数
    local free_reset_times = Player.Shop[SHOP_TYPE].free_reset_times --已免费次数


    local total_reset_times = 0
    local desc = ""
    if SHOP_TYPE == 8 then --如果是黑店， 有vip刷新
        if free_reset_times ~= nil then
            total_reset_times = therow.heidian_reset_free
        end

        print("free_reset_times" .. free_reset_times)

        if free_reset_times == total_reset_times then --表示已经没有次数可用了
            desc = TextMap.getText("COST_TYPE", { _shop.reset_arg, TextMap[_shop.reset_type], _shop.reset_times })
        elseif total_reset_times ~= 0 then
            desc = TextMap.getText("VIP_REFRESH_SHOP", { total_reset_times - free_reset_times, total_reset_times })
        end
    else
        print(_shop.reset_arg)
        print(_shop.reset_type)
        print(_shop.reset_times)
        desc = TextMap.getText("COST_TYPE", { _shop.reset_arg, TextMap[_shop.reset_type], _shop.reset_times })
    end
    DialogMrg.ShowDialog(desc, function()
        Api:refreshShop(SHOP_TYPE, function()
            MusicManager.playByID(20)
            that:update({ SHOP_TYPE })
        end)
    end)
end

function m:isReplace(name)
    local moduleName = UIMrg:GetRunningModuleName()

    if moduleName == "recycle" then
        return true
    end
end

function m:onRecycoe(go)
    --    if self:isReplace("recycle") == true then
    --        UIMrg:replaceToLevel("recycle", "Prefabs/moduleFabs/recycleModule/recycle",2)
    --    else
    uSuperLink.openModule(232)
    --        --    Tool.push("activeModule", "Prefabs/moduleFabs/questModule/quest_main", { task_Type = "daily" })
    --    end
    --    UIMrg:replaceToLevel("recycle", "Prefabs/moduleFabs/recycleModule/recycle",2)

    --    UIMrg:replaceToLevel("recycle", "Prefabs/moduleFabs/recycleModule/recycle",2)

    -- uSuperLink.openModule(232)
    -- Tool.replace("recycle", "Prefabs/moduleFabs/recycleModule/recycle")
end

function m:onClick(go, name)
    if name == "btn_Refresh" then
        self:onRefresh(go)
	elseif name == "btnShopClose" or name == "btn_get" then
		UIMrg:popWindow()
    end
end

function m:Start()
    self.topMenu = LuaMain:ShowTopMenu()
    Events.AddListener("shop_change",
    function()
       shop:update(self.lua)
    end)
end

function m:create()
    self._inited = false
    return self
end

return m