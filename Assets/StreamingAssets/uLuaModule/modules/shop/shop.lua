
-- 谱源商店
local timerId = 0
local shop = {}
local SHOP_TYPE = 2 --商店类型
local VIP_isopen = false
--local COST_TYPE = "显示一批新的货物需要消耗{0}{1}\n是否继续？(今日已刷新{3}次)"
--商店数据

function shop:getShopData(_type)
    local list = {}
    local shop_list = Player.Shop[_type]
    local count = shop_list.count
    local count = 0
    local istart = 0
    if SHOP_TYPE == 31 then
        shop_list = self.vipshop.goods_list
        count = #shop_list + 1
        istart = 1
    else
        shop_list = Player.Shop[SHOP_TYPE]
        count = shop_list.count
        istart = 0
    end
    for i = istart, count - 1 do
        local cell = shop_list[i]
        local item
        local type = cell.type
        if type == "char" then
            item = Char:new(nil,cell.id)
            item.SHOP_TYPE = _type
            item.shop_pos = i
            item.shop_item = cell
            table.insert(list, item)
        elseif type == "charPiece" then
            item = CharPiece:new(cell.id)
            item.SHOP_TYPE = _type
            item.shop_pos = i
            item.shop_item = cell
            table.insert(list, item)
        elseif type == "equip" then
            item = Equip:new(cell.id)
            item.SHOP_TYPE = _type
            item.shop_pos = i
            item.shop_item = cell
            table.insert(list, item)
        elseif type == "equipPiece" then
            item = EquipPiece:new(cell.id)
            item.SHOP_TYPE = _type
            item.shop_pos = i
            item.shop_item = cell
            table.insert(list, item)
        elseif type == "reel" then
            item = Reel:new(cell.id)
            item.SHOP_TYPE = _type
            item.shop_pos = i
            item.shop_item = cell
            table.insert(list, item)
        elseif type == "reelPiece" then
            item = ReelPiece:new(cell.id)
            item.SHOP_TYPE = _type
            item.shop_pos = i
            item.shop_item = cell
            table.insert(list, item)
        elseif type == "item" then
            item = uItem:new(cell.id)
            item.SHOP_TYPE = _type
            item.shop_pos = i
            item.shop_item = cell
            table.insert(list, item)
        elseif type == "fashion" then
            item = Fashion:new(cell.id)
            item.SHOP_TYPE = _type
            item.shop_pos = i
            item.shop_item = cell
            table.insert(list, item) 
        elseif type == "pet" then
            item = Pet:new(nil, cell.id)
            item.SHOP_TYPE = _type
            item.shop_pos = i
            item.shop_item = cell
            table.insert(list, item)
        elseif type == "petPiece" then
            item = PetPiece:new(cell.id)
            item.SHOP_TYPE = _type
            item.shop_pos = i
            item.shop_item = cell
            table.insert(list, item) 
        elseif type == "ghost" then
            item = Ghost:new(cell.id)
            item.SHOP_TYPE = _type
            item.shop_pos = i
            item.shop_item = cell
            table.insert(list, item)
        elseif type == "ghostPiece" then
            item = GhostPiece:new(cell.id)
            item.SHOP_TYPE = _type
            item.shop_pos = i
            item.shop_item = cell
            table.insert(list, item)
        elseif type == "treasure" then
            item = Treasure:new(cell.id)
            item.SHOP_TYPE = _type
            item.shop_pos = i
            item.shop_item = cell
            table.insert(list, item)
        elseif type == "treasurePiece" then
            item = TreasurePiece:new(cell.id)
            item.SHOP_TYPE = _type
            item.shop_pos = i
            item.shop_item = cell
            table.insert(list, item)
        else
            item = uRes:new(type, cell.id)
            item.SHOP_TYPE = _type
            item.shop_pos = i
            item.shop_item = cell
            item.isRes = true
            table.insert(list, item)
        end
    end
    return list
end

function shop:OnDestroy()
    --    UluaModuleFuncs.Instance.uTimer:removeSecondTime("updateShop")
    Events.RemoveListener('vipLibao_itemChange')
    LuaTimer.Delete(timerId)
    if timerDiscount ~= nil then
        LuaTimer.Delete(timerDiscount)
    end
end

function shop:updateRes()
    -- body
end

function shop:setRefreshTime()
    local now = os.date("*t")
    LuaTimer.Delete(timerId)
    if now.hour == 23 and now.min >= 58 then
        timerId = LuaTimer.Add(10000, 30000, function(id)
            shop:checkUpdate()
            return true
        end)
    end
end

function shop:refreshTime()
    shop:checkUpdate()
end

function shop:checkUpdate()
    Api:checkUpdateShop(function()
        shop:onUpdate()
    end)
end

function shop:onEnter()
    if self.isRefrsh then
        self.isRefrsh = false
        self.isScroll = false
        shop:checkUpdate()
    end
end

function shop:onExit()
    self.isRefrsh = true
    LuaTimer.Delete(timerId)
end

function shop:onUpdate()
    if self.__curTab == nil then
        return
    end
    print("shop:onUpdate()")
    print(self.__curTab)
    if self.__curTab ==nil or self.__curTab == 1 then 
        self:onSummon()
    elseif self.__curTab == 3 then 
        if VIP_isopen then 
            self:onVIP(self.btn_VIP)
        else 
            self.__curTab=3
            self:onZahuo(self.btn_zahuo)
        end 
    else
        self:onZahuo(self.btn_zahuo)
    end
end

function shop:updateVIPState()
    Api:getVipShop(function(result)
        if result.ret == 0 then
            if result.isOpen==0 then 
                VIP_isopen=false
                self.btn_VIP.gameObject:SetActive(false)
            else 
                local result = json.decode(result:toString())
                self.limit_type = result.shop.limit_type
                self.limit_args = tonumber(result.shop.limit_args)
                if self.limit_type == "vip" then
                    if Player.Info.vip < self.limit_args then
                        VIP_isopen=false
                        self.btn_VIP.gameObject:SetActive(false)
                        return
                    end
                elseif self.limit_type == "lv" then
                    if Player.Info.level < self.limit_args then
                        VIP_isopen=false
                        self.btn_VIP.gameObject:SetActive(false)
                        return
                    end
                end
                VIP_isopen=true
                self.btn_VIP.gameObject:SetActive(true)
            end 
        else 
            VIP_isopen=false
            self.btn_VIP.gameObject:SetActive(false)
        end 
    end,function()
        VIP_isopen=false
        self.btn_VIP.gameObject:SetActive(false)
    end) 
end

function shop:update(args, ret)
    shop:updateVIPState()
    if self.__curTab ==nil or self.__curTab == 1 then 
        self:onSummon()
    elseif self.__curTab == 3 then 
        if VIP_isopen then 
            self:onVIP(self.btn_VIP)
        else 
            self.__curTab=2
            self:onZahuo(self.btn_zahuo)
        end 
    else
        self:onZahuo(self.btn_zahuo)
    end
    if args then
        local index = args[1]
        if index == 0 then
			-- 召唤
            self:onSummon()
        elseif index == 1  then
			-- 杂货
            self:onZahuo(self.btn_zahuo)
        elseif index == 2 then 
            if VIP_isopen then 
                self:onVIP(self.btn_VIP)
            else 
                self:onZahuo(self.btn_zahuo)
            end
        end
    end
end

--更新道具列表
function shop:updateItem(view)
    local list = self:getShopData(SHOP_TYPE)
    ClientTool.UpdateGrid("Prefabs/moduleFabs/puYuanStoreModule/shop_item_cell", view, list, self)
end

function shop:showMsg(result)
    packTool:showMsg(result, nil, 1)
end


--点击杂货
function shop:onZahuo(go)
    self.__curTab = 2
    self:SetBtSp()
    SHOP_TYPE = 7
    self:updateItem(self.zahuo_view)
    if self.isScroll ~= false then
        self.binding:CallAfterTime(0.1, function()
            self.zahuo_scroll_view:ResetPosition()
        end)
    end
    shop:setRefreshTime()
end

function shop:onSummon()
	self.__curTab = 1
	self:SetBtSp()
end 

--点击VIP
function shop:onVIP(go)
    self.__curTab = 3
    self:SetBtSp()
    SHOP_TYPE = 31
    self:updateVipdata()

    --shop:setRefreshTime()
end

function shop:updateVipdata()
    Api:getVipShop(function(result)
        if result.ret == 0 then
            self.vipshop = { start_time = 0, end_time = 0, limit_type = "", limit_args = 0, discount_time1 = 0, discount_time2 = 0, discount = 100, shopid = 0, goods_list = {} }
            local result = json.decode(result:toString())
            self.vipshop.limit_type = result.shop.limit_type
            self.vipshop.limit_args = tonumber(result.shop.limit_args)
            if self.vipshop.limit_type == "vip" then
                if Player.Info.vip < self.vipshop.limit_args then
                    VIP_isopen=false
                    self.btn_VIP.gameObject:SetActive(false)
                    shop:onZahuo()
                    return
                end
            elseif self.vipshop.limit_type == "lv" then
                if Player.Info.level < self.vipshop.limit_args then
                    VIP_isopen=false
                    self.btn_VIP.gameObject:SetActive(false)
                    shop:onZahuo()
                    return
                end
            end
            self.vipshop.start_time = tonumber(result.shop.start_time)
            self.vipshop.end_time = tonumber(result.shop.end_time)

            local shopDiscount = false
            self.vipshop.discount_time1  = tonumber(result.shop.discount_time1)
            self.vipshop.discount_time2 = tonumber(result.shop.discount_time2)
            if self.vipshop.discount_time1 ~= nil and self.vipshop.discount_time2 ~= nil then
                local time1 = ClientTool.GetNowTime(self.vipshop.discount_time1)
                local time2 = ClientTool.GetNowTime(self.vipshop.discount_time2)
                if time1 > 0 then
                    self.binding:CallAfterTime(time1/1000,function ()
                        self:updateVipdata()
                    end)
                end
                if time1 <= 0 and time2 > 0 then
                    self.binding:CallAfterTime(time2/1000,function ()
                        self:updateVipdata()
                    end)
                end
            end

            self.vipshop.discount = tonumber(result.shop.discount)
            self.vipshop.shopid = (result.shop.vip_shop_id)
            self.vipshop.goods_list = {}
            local jsontable = result.shop.goods
            local playerbuyinfo = nil
            
            playerbuyinfo = result.buyInfo
            for k, v in pairs(jsontable) do
                local cell = {}
                cell.type = v.drop[1].type
                cell.id = tonumber(v.drop[1].arg)
                cell.count = tonumber(v.drop[1].arg2)
                if cell.count == nil then
                    cell.count = tonumber(v.drop[1].arg)
                end
                cell.itemid = k
                cell.sell = false
                cell.buy_num = 0
                if playerbuyinfo ~= nil then
                    itembuynum = playerbuyinfo[cell.itemid]
                    if itembuynum ~= nil then
                        cell.buy_num = tonumber(itembuynum)
                        if cell.buy_num == nil then
                            cell.buy_num = 0
                        end
                    end
                end
                cell.sell_price = tonumber(v.new_price)
                cell.sell_oldprice = tonumber(v.old_price)
                cell.sell_type = v.consume_type
                cell.sell_discount = tonumber(v.item_discount)
                if shopDiscount then
                    cell.sell_discount = tonumber(v.item_discount) * self.vipshop.discount / 100
                end
                cell.step = 1
                cell.vipshopid = (result.shop.vip_shop_id)

                cell.item_limit_type = v.item_limit_type
                cell.item_limit_args = tonumber(v.item_limit_args)
                cell.max_num = tonumber(v.max_num)
                cell.old_price = tonumber(v.old_price)
                cell.pri = tonumber(v.pri)
                table.insert(self.vipshop.goods_list, cell)
            end
            table.sort(self.vipshop.goods_list, function(item, item2) return item.pri > item2.pri end)
            local list = self:getShopData(SHOP_TYPE)
			ClientTool.UpdateGrid("Prefabs/moduleFabs/puYuanStoreModule/shop_vip_item_cell", self.view_vip, list, self)
        else
        end
    end)
end

function shop:SetBtSp()
    if self.__curTab == 1 then
		self.CheckBox_summon:SetActive(true)
		self.CheckBox_VIP:SetActive(false)
        self.CheckBox_zahuo:SetActive(false)
        self.zahuo:SetActive(false)
        self.item:SetActive(false)
		self.zhaomu:SetActive(true)
        self.summonBinding:CallUpdate({})
    elseif self.__curTab == 2 then
        self.CheckBox_summon:SetActive(false)
        self.CheckBox_zahuo:SetActive(true)
        self.CheckBox_VIP:SetActive(false)
        self.zahuo:SetActive(true)
        self.item:SetActive(false)
        self.zhaomu:SetActive(false)
    elseif self.__curTab == 3 then
        self.CheckBox_summon:SetActive(false)
        self.CheckBox_zahuo:SetActive(false)
        self.CheckBox_VIP:SetActive(true)
        self.zahuo:SetActive(false)
        self.item:SetActive(true)
        self.zhaomu:SetActive(false)
    end
end



function shop:onRefresh(go)
    print("shop:onRefresh(go)")
    if SHOP_TYPE == 31 then
		self.vip_scrollview.gameObject:SetActive(false)
        local list = self:getShopData(31)
        ClientTool.UpdateGrid("Prefabs/moduleFabs/puYuanStoreModule/shop_vip_item_cell", self.vip_view, list, self)
        return
    end
    local that = self
    local _shop = Player.Shop[SHOP_TYPE]
    local free_reset_times = Player.Shop[SHOP_TYPE].free_reset_times --已免费次数
    local desc = ""
    local therow = TableReader:TableRowByUnique("buyLimitTimes", "vip_level", Player.Info.vip)
    local total_reset_times = 0
    if SHOP_TYPE == 2 then
        total_reset_times = therow.puyuan_reset_free
    elseif SHOP_TYPE == 7 then
        total_reset_times = therow.zahuo_reset_free
    end

    if free_reset_times == total_reset_times then --表示已经没有次数可用了
    desc = TextMap.getText("COST_TYPE", { _shop.reset_arg, TextMap[_shop.reset_type], _shop.reset_times + total_reset_times })
    elseif total_reset_times ~= 0 then
        desc = TextMap.getText("VIP_REFRESH_SHOP", { total_reset_times - free_reset_times, total_reset_times })
    end

    DialogMrg.ShowDialog(desc, function()
        Api:refreshShop(SHOP_TYPE, function()
            MusicManager.playByID(20)
            if SHOP_TYPE == 2 then
                that:updateItem(that.item_view)
            elseif SHOP_TYPE == 7 then
                that:updateItem(that.zahuo_view)
            end
        end)
    end)
end

function shop:onChouka()
    local temp = {}
    temp._choukaType = self._choukaType
    Tool.push("summontwo", "Prefabs/moduleFabs/choukaModule/summontwo", temp)     
    temp = nil
end

function shop:onClick(go, name)
    print("click : " .. name)
    if name == "btnBack" then 
		UIMrg:pop()
	elseif name == "btn_zahuo" then
        self.isScroll = true
        self:onZahuo(go)
    elseif name == "btn_VIP" then
        self:onVIP(go)
	elseif name == "btn_summon" then 
		self:onSummon()
    elseif name == "btn_zhaomuleft" then 
        self._choukaType = "renzhe"
        self:onChouka()
    elseif name == "Texturezhenying" then 
        self._choukaType = "zhenying"
        self:onChouka()
    elseif name == "btn_zhaomuright" then 
        self._choukaType = "shenren"
        self:onChouka()
    elseif name == "teQuan" then
        Tool.push("activity", "Prefabs/moduleFabs/activityModule/activity_gradeGift",{"","recharge"})
    end
end


function shop:Start()
    --加入顶部菜单
    LuaMain:ShowTopMenu(1)
	Tool.loadTopTitle(self.gameObject, TextMap.GetValue("Text_1_1071"))
end

function shop:getScrollView()		
			return self.view;
end

return shop