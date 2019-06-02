local timerId = 0
local shop = {}
local total_free_time =0
local total_buy_time =0
local COST_TYPE = TextMap.GetValue("Text_1_1078")
local isStart=true
local isRefrshBtn=false
local isChongzu=false

--商店数据
function shop:getShopData(_type)
    local list = {}
    local shop_list = Player.Shop[_type]
    local count = shop_list.count
    if count==0 and isStart==true then 
        shop:checkUpdate()
        isStart=false
        return 
    end 
    for i = 0, count - 1 do
        local cell = shop_list[i]
        local item
        local type = cell.type
        item = RewardMrg.getDropItem({type=type,arg=cell.id,arg2=cell.count or 1})
        item.SHOP_TYPE = _type
        item.shop_pos = i
        item.shop_item = cell
        table.insert(list, item)
    end
    return list
end

--[[function shop:updateArenaShop()

    local list = self:getShopData(self._type) 
    ClientTool.UpdateGrid("Prefabs/moduleFabs/puYuanStoreModule/shop_item_cell_buy", self.arena_item_view, list, self)
    local shop_list = Player.Shop[self._type]
    local countdown = shop_list.countdown
    local tab = os.date("*t", 1200 + countdown / 1000)
    local now = os.date("*t")
    local str = ""
    LuaTimer.Delete(timerId)
    if tab.day == now.day then
        str = TextMap.TODAY
        shop:setRefreshTime(tab, now)
    elseif tab.day - now.day == 1 then
        str = TextMap.TOMORROW
    end
     self.binding:CallManyFrame(function()
            self.scrollView:ResetPosition()
        end, 1)
    
    self.txt_refresh_time.text = string.gsub(str, "{0}", tab.hour)
end]]

function shop:OnDestroy()
    LuaTimer.Delete(timerId)
    if timerDiscount ~= nil then
        LuaTimer.Delete(timerDiscount)
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
    LuaMain:ShowTopMenu(6,nil,self.resLis)
    if self.isRefrsh then
        self.isRefrsh = false
        shop:checkUpdate()
    end
end

function shop:onExit()
    self.isRefrsh = true
    LuaTimer.Delete(timerId)
end

function shop:onUpdate()
    shop:update({self.type})
    --if self.__curTab == nil then
     --   return
    --end
    print("shop:onUpdate()")
    --shop:update({ self.__curTab - 1 }, true)
	--if self.__curTab == 1 then 
	--	shop:updateArenaShop()
	--end 
end


--type：表示商店类型
function shop:update(_type)
    self.type=_type[1]
    local type =self.type
    local time  =Tool.FormatTime(1200 + Player.Shop[type].countdown / 1000 -os.time()) 
    shop:setRefreshTime(type)
    self.row = shop:getRowByType(type)
    self.Hero:LoadByModelId(self.row.model, "idle", function() end, false, 0, 1)
    self.tipLabel.gameObject:SetActive(true)
    self.tipLabel.text=self.row.desc
    self.name.text =self.row.desc
    shop:updateAllShopInType()
    shop:updateRes()
    shop:updateShoplist(type)
    shop:getRefreshTime(type)
    shop:setRefreshContent(type)
end

function shop:updateAllShopInType()
    local main_shop = TableReader:TableRowByID("shop_reset_config",self.type).main_shop
    self.shopList = {}
    TableReader:ForEachLuaTable("shop_reset_config", function(k, v)
        if tonumber(v.main_shop) == tonumber(main_shop) then 
            local superLink = v.superLink
            local level=Tool.getUnlockLevel(superLink)
            if Player.Info.level>=level then 
                v.delegate=self
                table.insert(self.shopList, v)
            end 
        end
        return false
        end)
    table.sort(self.shopList, function (a,b)
        return a.sort<b.sort
    end)
    if #self.shopList<=4 then 
        self.drag.enabled=false
    else
        self.drag.enabled=true
    end 
    self.scrollview:refresh(self.shopList,self,true,0)
    self.binding:CallAfterTime(0.1,function()
            self.scrollview:goToIndex(0)
        end)
end


--主界面打开时调用一下
function shop:updateOpenPath(ret)
    self.ret =ret 
end

function shop:setRefreshContent(type)
    
end

function shop:getRefreshTime(type)
    local type =self.type
    local row = TableReader:TableRowByUnique("buyLimitTimes", "vip_level", Player.Info.vip)
    local shop_reset = TableReader:TableRowByID("shop_reset_config",self.type)
    if row ~= nil then
        total_free_time=row[shop_reset.reset_free]
        total_buy_time=row[shop_reset.limit_times]
    end
    self.shuaxinNum.text=TextMap.GetValue("Text_1_1079") .. total_buy_time-Player.Shop[type].reset_times .. "/" .. total_buy_time
    self.txt_refresh_time.text=TextMap.GetValue("Text_1_1080") .. total_free_time-Player.Shop[type].free_reset_times .. "/" .. total_free_time

    TableReader:ForEachTable("resetShop",
        function(k, item)
            if item ~= nil and item.reset_time == Player.Shop[type].reset_times+1 and item.type==type then 
                --print_t(item)
                self.refresh_type=item.consume[0].consume_type
                self.refresh_id=item.consume[0].consume_arg
                self.refresh_num=item.consume[0].consume_arg2
            end
            return false
        end)
    if self.refresh_type ~=nil then 
        self.con:SetActive(true)
        self.des2.text=""
        self.xiaohaoziyuan.gameObject:SetActive(true)
        self.xiaohao1.gameObject:SetActive(true)
        self.xiaohao3.gameObject:SetActive(true)
        if self.refresh_type=="item" then 
            local item = uItem:new(self.refresh_id)
            local iconName=item :getHeadSpriteName()
            self.xiaohaoziyuan.Url=UrlManager.GetImagesPath("itemImage/" .. iconName .. ".png")
            if item.count<self.refresh_num then 
                self.xiaohaoziyuanNum.text="[FF0000]" .. item.count .. "/" .. self.refresh_num .."[-]"
                if total_free_time>Player.Shop[type].free_reset_times then 
                    self.isChongzu=true
                    if isRefrshBtn==false then 
                        self.arena_btn_Refresh.isEnabled = true
                    end 
                else 
                    self.isChongzu=false
                    self.arena_btn_Refresh.isEnabled = false
                end 
            else 
                self.isChongzu=true
                if isRefrshBtn==false then 
                    self.arena_btn_Refresh.isEnabled = true
                end 
                self.xiaohaoziyuanNum.text="[FFFFFF]" .. item.count .. "/" .. self.refresh_num .."[-]"
            end
            self.xiaohao1.Url=UrlManager.GetImagesPath("itemImage/" .. iconName .. ".png")
        else
            local iconName = Tool.getResIcon(self.refresh_type)
            self.xiaohaoziyuan.Url=UrlManager.GetImagesPath("itemImage/" .. iconName .. ".png")
            if Tool.getCountByType(self.refresh_type)< self.refresh_id then 
                if total_free_time>Player.Shop[type].free_reset_times then 
                    self.arena_btn_Refresh.isEnabled = true
                else 
                    self.arena_btn_Refresh.isEnabled = false
                end 
                self.xiaohaoziyuanNum.text="[FF0000]" .. toolFun.moneyNumberShowOne(math.floor(tonumber(Tool.getCountByType(self.refresh_type)))) .. "/" ..self.refresh_id
            else 
                self.arena_btn_Refresh.isEnabled = true
                self.xiaohaoziyuanNum.text="[FFFFFF]" .. toolFun.moneyNumberShowOne(math.floor(tonumber(Tool.getCountByType(self.refresh_type)))) .. "/" ..self.refresh_id
            end
            self.xiaohao1.Url=UrlManager.GetImagesPath("itemImage/" .. iconName .. ".png")
        end 
    else
        self.con:SetActive(false)
        self.des2.text=shop_reset.desc2
        self.xiaohaoziyuan.gameObject:SetActive(false)
        self.xiaohao1.gameObject:SetActive(false)
        self.xiaohao3.gameObject:SetActive(false)
    end

end

function shop:updateRes()
    local row = self.row
    local sell_typeList=row.show_consume
    local count = sell_typeList.Count
    local list = {}
    for i=count-1,0,-1 do 
        local item =sell_typeList[i]
        local ziyuan  = {}
        ziyuan.type=item.consume_type
        if item.consume_type == "item" then 
            ziyuan.arg=item.consume_arg
        end
        table.insert(list,ziyuan)
    end 
    self.resLis=list
    --加入顶部菜单
    LuaMain:ShowTopMenu(6,nil,self.resLis)
end

function shop:updateShoplist(type)
    local list = self:getShopData(type) 
   -- self.scroll:refresh(list, self)
    ClientTool.UpdateGrid("Prefabs/moduleFabs/puYuanStoreModule/shop_item_cell_buy", self.Content, list, self)
    self.binding:CallManyFrame(function()
            self.view:ResetPosition()
        end, 1)
end

function shop:setRefreshTime(type)
    LuaTimer.Delete(timerId)
    timerId = LuaTimer.Add(0,1000, function(id)
        local tab = os.date("*t", 1200 + Player.Shop[type].countdown / 1000)
        local now = os.date("*t")
        local time  =Tool.FormatTime(1200 + Player.Shop[type].countdown / 1000 -os.time()) 
        if tab.hour - now.hour >= 1 and now.min >= 59 and now.sec >=59 then
            shop:checkUpdate()
            return true
        end
    end)
end

function shop:getRowByType(type)
    --print (type)
    local row = {}
    local list ={}
    TableReader:ForEachLuaTable("shop_refresh", function(k, v)
        if v.shop ==type then 
            table.insert(list, v)
        end
        return false
        end)
    local count =0
    if list ~=nil then 
        count =#list 
    end
    if list~=nil and count>1 then 
        if list[count].unlock[0].unlock_arg<=Player.Info.level then 
            row=list[count]
        else 
            for i=1,count-1 do 
                if list[i].unlock[0].unlock_arg<=Player.Info.level and list[i+1].unlock[0].unlock_arg>Player.Info.level then 
                    row=list[i]
                end
            end
        end 
    else 
        row =list [1]
    end
    return row
end

function shop:clickBack()
    LuaMain:ShowTopMenu(1)
    UIMrg:pop()
end

function shop:onClick(go, name)
    print (name)
    if name == "btnBack" then 
        shop:clickBack()
    elseif name == "btn_Refresh" then
        self:onRefresh(go)
	elseif name == "arena_btn_Refresh" then 
		self:onShopRefresh()
    end
end

function shop:onShopRefresh()
    self.arena_btn_Refresh.isEnabled=false
    isRefrshBtn=true
    local that = self
    local SHOP_TYPE = self.type
    local _shop = Player.Shop[SHOP_TYPE]
    local free_reset_times = Player.Shop[SHOP_TYPE].free_reset_times --已免费次数
    local free_time =total_free_time-free_reset_times
    if free_time>0 then 
        Api:refreshShop(SHOP_TYPE, function()
            MusicManager.playByID(20)
            that:update({SHOP_TYPE})
            self.binding:CallAfterTime(0.5, function()
                if self.isChongzu~=nil then 
                    isRefrshBtn=false
                    self.arena_btn_Refresh.isEnabled=self.isChongzu 
                end 
                end)
             end)
    else 
        buy_time =total_buy_time-_shop.reset_times
        if self.refresh_type ~=nil and buy_time>0 then 
            if self.refresh_type=="item" then 
                local item = uItem:new(self.refresh_id)
                --desc = TextMap.getText("COST_TYPE", { _shop.reset_arg2, item:getDisplayColorName(), _shop.reset_times })
                --DialogMrg.ShowDialog(desc, function()
                Api:refreshShop(SHOP_TYPE, function()
                    MusicManager.playByID(20)
                    that:update({SHOP_TYPE})
                    self.binding:CallAfterTime(0.5, function()
                        if self.isChongzu~=nil then 
                            isRefrshBtn=false
                            self.arena_btn_Refresh.isEnabled=self.isChongzu 
                        end 
                        end)
                    end)
                --end)
            else
                desc = TextMap.getText("COST_TYPE", { _shop.reset_arg, Tool.getResName(self.refresh_type), _shop.reset_times })
                DialogMrg.ShowDialog(desc, function()
                Api:refreshShop(SHOP_TYPE, function()
                    MusicManager.playByID(20)
                    that:update({SHOP_TYPE})
                    self.binding:CallAfterTime(0.5, function()
                        if self.isChongzu~=nil then 
                            isRefrshBtn=false
                            self.arena_btn_Refresh.isEnabled=self.isChongzu 
                        end 
                        end)
                    end)
                end)
            end 
        else 
            MessageMrg.show(TextMap.GetValue("Text_1_1081"))
        end
    end
end

function shop:Start()
	self.__curTab = 1
    isRefrshBtn=false
    self.isChongzu=false
    Events.AddListener("shop_change",
    function()
       shop:update({self.type})
    end)
end

function shop:OnDestroy()
    shop = nil
    LuaTimer.Delete(timerId)
    Events.RemoveListener('shop_change')
end

return shop