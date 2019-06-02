local timerId = 0
local StoreTwo = {}
local total_free_time =0
local total_buy_time =0
local COST_TYPE = TextMap.GetValue("Text_1_1078")

--商店数据
local isCheck=false
function StoreTwo:getShopData(_type)
    local list = {}
    local shop_list = Player.Shop[_type]
    local count = shop_list.count
    if count==0 and isCheck==false then 
        isCheck=true
        StoreTwo:checkUpdate()
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


--type：表示商店类型
function StoreTwo:update(type)
    self.type=type[1]
    local type = type[1]
    local time  =Tool.FormatTime(1200 + Player.Shop[type].countdown / 1000 -os.time()) 
    StoreTwo:setRefreshTime(type)
    local row = StoreTwo:getRowByType(type)
    self:updateAllShopInType()
    self.Hero:LoadByModelId(row.model, "idle", function() end, false, 0, 1)
    self.tipLabel.gameObject:SetActive(true)
    self.tipLabel.text=row.desc
    self.name.text =row.desc
   
    StoreTwo:updateRes(row)
    StoreTwo:updateShoplist(type)
end

function StoreTwo:updateAllShopInType()
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
    self.scrollview_btn:refresh(self.shopList,self,true,0)
    self.binding:CallAfterTime(0.1,function()
            self.scrollview_btn:goToIndex(0)
        end)
end

function StoreTwo:updateRes(row)
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
    self.resList=list
    --加入顶部菜单
    LuaMain:ShowTopMenu(6,nil,list)
end

function StoreTwo:OnDestroy()
    LuaTimer.Delete(timerId)
    StoreTwo = nil
    Events.RemoveListener('shop_change')
    if timerDiscount ~= nil then
        LuaTimer.Delete(timerDiscount)
    end
end

function StoreTwo:onEnter()
    LuaMain:ShowTopMenu(6,nil,self.resList)
end

function StoreTwo:refreshTime()
    if isCheck==false then 
        isCheck=true
        StoreTwo:checkUpdate()
    end 
end

function StoreTwo:checkUpdate()
    Api:checkUpdateShop(function()
        StoreTwo:update({self.type})
    end)
end

function StoreTwo:updateShoplist(type)
    local list = self:getShopData(type) 
    if list==nil then return end
    --ClientTool.UpdateGrid("Prefabs/moduleFabs/puYuanStoreModule/Store_item_cell", self.Content, list, self)
    self.scrollview:refresh(list,self,true,0)
end

function StoreTwo:setRefreshTime(type)
    LuaTimer.Delete(timerId)
    timerId = LuaTimer.Add(0,1000, function(id)
        local tab = os.date("*t", 1200 + Player.Shop[type].countdown / 1000)
        local now = os.date("*t")
        if tab.hour - now.hour >= 1 and now.min >= 56 then
            if isCheck==false then 
                isCheck=true
                StoreTwo:checkUpdate()
            end 
            return true
        end
    end)
end

function StoreTwo:getRowByType(type)
    local row = {}
    local list ={}
    TableReader:ForEachLuaTable("shop_refresh", function(k, v)
        if v.shop ==type then 
            table.insert(list, v)
        end
        return false
        end)
    local count =#list
    if count>1 then 
        if list[count].unlock.unlock_arg<=Player.Info.level then 
            row=list[count]
        else 
            for i=1,count-1 do 
                if list[count].unlock.unlock_arg<=Player.Info.level and list[count+1].unlock.unlock_arg>Player.Info.level then 
                    row=list[i]
                end
            end
        end 
    else 
        row =list [1]
    end
    return row
end

function StoreTwo:updateOpenPath(ret)
    print (ret)
    self.ret =ret 
end


function StoreTwo:onClick(go, name)
    if name == "btnBack" then 
        LuaMain:ShowTopMenu(1)
        UIMrg:pop()
    elseif name == "btn_rank" then
        MessageMrg.show(TextMap.GetValue("Text_1_1085"))
    end
end

function StoreTwo:Start()
	self.__curTab = 1
	--self:onUpdate()
    Events.AddListener("shop_change",function()
       StoreTwo:update({self.type})
    end)
end


return StoreTwo