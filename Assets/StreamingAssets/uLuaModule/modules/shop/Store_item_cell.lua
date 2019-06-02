local Store_item_cell = {}
local ITEM_HAS_NOT = TextMap.GetValue("Text1412")
local lastTimes = 0
function Store_item_cell:update(item, index, myTable, delegate)
    self.shop_item = item.shop_item
    self.item = item
    self.delegate = item.delegate
    self._type = item.SHOP_TYPE
    local shoptype = 0
    TableReader:ForEachLuaTable("shop_refresh", function(k, v)
        if v.shop ==self._type then 
            shoptype=v.sell_type
        end
        return false
        end)
    self.shoptype=shoptype
    self:onUpdate()

    if item.Table.type ~= nil then
        self.dropType = item.Table.type
    else
        self.dropType = ""
    end
    
end

--商店不支持直接卖英雄，只能买碎片和道具
local itemBind
function Store_item_cell:onUpdate()
    local shop_item = self.shop_item
    local item = self.item
    if itemBind == nil then
        itemBind = ClientTool.loadAndGetLuaBindingFromPool("Prefabs/publicPrefabs/itemAll", self.pic.gameObject)
    end
    itemBind:CallUpdate({ "char", item, self.pic.width, self.pic.height,true,nil,nil,nil,false})
    local count = 1
    if shop_item.count > 1 then
        count = shop_item.count
    end
    if self.item.__count ~= nil then count = self.item.__count end
    item.rwCount = 1
    if self.shoptype==0 then
        self.number.gameObject:SetActive(true)
        self.number.text = count
        self.xiangouLabel.gameObject:SetActive(false)
        if shop_item.sell then
            self.sell:SetActive(true)
        else
            self.sell:SetActive(false)
        end
    else
        self.number.gameObject:SetActive(false)
        lastTimes = shop_item.count - shop_item.buy_num
        self.xiangouLabel.gameObject:SetActive(true)
        if (lastTimes) <= 0 then
            self.sell:SetActive(true)
            self.xiangouLabel.text = TextMap.GetValue("Text_1_1072")
        else
            self.sell:SetActive(false)
            self.xiangouLabel.text =string.gsub(TextMap.GetValue("LocalKey_840"),"{0}",lastTimes)
        end
    end
    self.txt_name.text = item:getDisplayColorName()
    item:updateInfo()
    if item:getType()=="charPiece" or item:getType()=="petPiece" or item:getType()=="ghostPiece" or item:getType()== "treasurePiece" or item:getType()== "yulingPiece" then 
        if item.count>=item.needCharNumber then 
            self.Num.text="[24FC24]（" .. item.count .. "/" .. item.needCharNumber .. "）[-]"
        else 
            self.Num.text="[FFFFFF]（" .. item.count .. "/" .. item.needCharNumber .. "）[-]"
        end 
    else 
        self.Num.text=TextMap.GetValue("Text_1_2806") .. Tool.getCountByType(item:getType(), item.id)
    end 
    self._prize={}
    local priceList = {}
    if shop_item.price[1].sell_type~="" then 
        table.insert( priceList, shop_item.price[1])
    end 
    if shop_item.price[0].sell_type~="" then 
        table.insert( priceList, shop_item.price[0])
    end
    self.img_huobi1.gameObject:SetActive(false)
    self.img_huobi2.gameObject:SetActive(false)
    self.img_discount.gameObject:SetActive(false)

    if priceList==nil then return end 
    self.needBuyType={}
    self.canbuynum = lastTimes
    local buy_num = shop_item.buy_num
    for i=1,#priceList do 
        self["img_huobi" .. i].gameObject:SetActive(true)
        self["effect" .. i]:SetActive(false)
        local price = priceList[i].sell_price
        local true_price = priceList[i].sell_num
        --出售上限
        if priceList[i].inc_limit ~= nil and true_price > priceList[i].inc_limit then 
            true_price = priceList[i].inc_limit 
        end
        if priceList[i].sell_discount ~= 100 and i==1 then
            self.img_discount.gameObject:SetActive(true)
            self.txt_sale.text = self:getDiscountStr(priceList[i].sell_discount)
            local disPlayPrice = price + math.floor(shop_item.buy_num / (priceList[i].step or 1)) * (priceList[i].inc or 0)
            --出售上限
            if priceList[i].inc_limit ~= nil and disPlayPrice > priceList[i].inc_limit then 
                disPlayPrice = priceList[i].inc_limit 
            end
        else
            if item:getType()=="renling" then 
                item.rwCount=count
                if self:getCanNeed(item) then 
                    self.img_discount.gameObject:SetActive(true)
                    self.img_discount.spriteName="jiaobiao_1"
                    self.txt_sale.text=TextMap.GetValue("Text_1_2991")
                elseif self:getCanNeed_two(item) then 
                    self.img_discount.gameObject:SetActive(true)
                    self.img_discount.spriteName="jiaobiao_3"
                    self.txt_sale.text=TextMap.GetValue("Text_1_2992")
                end 
            end 
        end
        local iconName=""
        if priceList[i].sell_type == "item" then 
            local itemcell=uItem:new(priceList[i].sell_arg)
            iconName = itemcell.Table.iconid
            local buynum =0
            local totalNum =itemcell.count
            for j=1,self.canbuynum do
                if totalNum>=true_price then 
                    buy_num=buy_num+1
                    local cur_price =price+math.floor((buy_num-1)/tonumber(priceList[i].step))*tonumber(priceList[i].inc)
                    --出售上限
                    if priceList[i].inc_limit ~= nil and cur_price > priceList[i].inc_limit then 
                        cur_price = priceList[i].inc_limit 
                    end
                    if totalNum>=cur_price then 
                        buynum=buynum+1
                        totalNum=totalNum-cur_price
                    end 
                end 
            end
            self.canbuynum=math.min(self.canbuynum,buynum)
            if itemcell.count < true_price then
                table.insert(self.needBuyType,{type=priceList[i].sell_type,arg=itemcell})
            end
            self["txt_price" .. i].text ="[FFFFFF]" .. true_price .. "[-]"
        else 
            iconName = Tool.getResIcon(priceList[i].sell_type)
            local buynum =0
            local totalNum =Tool.getCountByType(priceList[i].sell_type)
            for j=1,self.canbuynum do
                if totalNum>=true_price then 
                    buy_num=buy_num+1
                    local cur_price =price+math.floor((buy_num-1)/tonumber(priceList[i].step))*tonumber(priceList[i].inc)
                    --出售上限
                    if priceList[i].inc_limit ~= nil and cur_price > priceList[i].inc_limit then 
                        cur_price = priceList[i].inc_limit 
                    end
                    if totalNum>=cur_price then 
                        buynum=buynum+1
                        totalNum=totalNum-cur_price
                    end 
                end 
            end
            self.canbuynum=math.min(self.canbuynum,buynum)
            if (Tool.getCountByType(priceList[i].sell_type) < true_price) then
               table.insert(self.needBuyType,{type=priceList[i].sell_type,arg=priceList[i].sell_arg})
            end
            self["txt_price" .. i].text ="[FFFFFF]" .. true_price .. "[-]"
        end
        self["img_huobi" .. i].Url =UrlManager.GetImagesPath("itemImage/" .. iconName .. ".png")
        if priceList[i].sell_type=="gold" then  --如果是钻石
            self["effect" .. i]:SetActive(true)
        end
        self._prize[i] = true_price
    end
end

-- 急需判断
function Store_item_cell:getCanNeed(item)
    local activeList = Player.renling
    local openLv = TableReader:TableRowByID("renling_config",5).value2
    local maxStar = TableReader:TableRowByID("renling_config",6).value2
    for i=0,item.Table.show.Count-1 do
        local id = item.Table.show[i]
        local row = TableReader:TableRowByID("renling_group",id)
        local group_item = TableReader:TableRowByUnique("renling_tujian","group",tonumber(row.group))
        if Tool.getRenLingLock(group_item) then 
            if activeList[row.group]~=nil or activeList[row.group][id] ==nil or tonumber(activeList[row.group][id].level)<1 then 
                local isShow = self:getCanNeedByRow(item,row)
                if isShow then 
                    return true
                end 
            elseif Player.Info.level>=tonumber(openLv) and tonumber(player.renling[row.group][id].level)<tonumber(maxStar) then 
                local row = TableReader:TableRowByID("renling_group",id)
                if isShow then 
                    return true
                end
            end 
        end 
    end
    return false
end

-- 急需判断
function Store_item_cell:getCanNeedByRow(item,row)
    local bag = Player.renlingBagIndex
    for j=0,row.consume.Count do
        if row.consume[j]~=nil and row.consume[j].consume_type=="renling" then 
            local renlingId =row.consume[j].consume_arg
            if renlingId~=item.id then 
                if bag[renlingId]==nil or bag[renlingId].count<tonumber(row.consume[j].consume_arg2) then 
                    return false
                end 
            else
                local num = 0
                if bag[renlingId]~=nil then 
                    num=bag[renlingId].count
                end 
                if num +tonumber(item.rwCount) <tonumber(row.consume[j].consume_arg2) then 
                    return false
                elseif num >=tonumber(row.consume[j].consume_arg2) then 
                    return false
                end 
            end 
        end
    end 
    return true
end

-- 需要判断
function Store_item_cell:getCanNeed_two(item)
    local activeList = Player.renling
    local openLv = TableReader:TableRowByID("renling_config",5).value2
    local maxStar = TableReader:TableRowByID("renling_config",6).value2
    for i=0,item.Table.show.Count-1 do
        local id = item.Table.show[i]
        local row = TableReader:TableRowByID("renling_group",id)
        local group_item = TableReader:TableRowByUnique("renling_tujian","group",tonumber(row.group))
        if Tool.getRenLingLock(group_item) then 
            if activeList[row.group]~=nil or activeList[row.group][id] ==nil or tonumber(activeList[row.group][id].level)<1 then 
                local isShow = self:getCanNeedByRow_two(item,row)
                if isShow then 
                    return true
                end 
            elseif Player.Info.level>=tonumber(openLv) and tonumber(player.renling[row.group][id].level)<tonumber(maxStar) then 
                local isShow = self:getCanNeedByRow_two(item,row)
                if isShow then 
                    return true
                end
            end 
        end 
    end
    return false
end

function Store_item_cell:getCanNeedByRow_two(item,row)
    local bag = Player.renlingBagIndex
    for j=0,row.consume.Count do
        if row.consume[j]~=nil and row.consume[j].consume_type=="renling" then 
            local renlingId =row.consume[j].consume_arg
            if renlingId==item.id then 
                local num = 0
                if bag[renlingId]~=nil then 
                    num=bag[renlingId].count
                end 
                if num < tonumber(row.consume[j].consume_arg2) then 
                    return true
                end 
            end 
        end
    end 
    return false
end

function Store_item_cell:setIcon(old, name, ret)
    local assets = packTool:getIconByName(name)
    self[old]:setImage(name, assets)
    Tool.SetActive(self[old], ret)
end

function Store_item_cell:getDiscountPic(discount)
    if discount == 100 then return "" end
    return "discount_" .. discount / 10
end

function Store_item_cell:onClick()
    if self.shoptype==1 then
        if lastTimes <= 0 then
            MessageMrg.show(TextMap.GetValue("Text1411"))
            return
        end
        local canbuynum=self.canbuynum
        if canbuynum <=0 then 
            local canbuyType = false
            local msg = ""
            for i=1,#self.needBuyType do
                if canbuyType==false and self:typeId(self.needBuyType[i].type) then 
                    canbuyType=true
                    local name = Tool.getResName(self.needBuyType[i].type)
                    DialogMrg.ShowDialog(name .. TextMap.GetValue("Text_1_1076"), function()
                        if tonumber(self.resource.droptype[0])==800 then 
                            Api:checkCross(function (reslut)
                                UIMrg:pop()
                                uSuperLink.openModule(self.resource.droptype[0]) 
                                return 
                            end,function (re)
                                local row = TableReader:TableRowByID("errCode", re);
                                if row ~= nil then
                                    local desc = row.desc
                                    local type = row.type
                                    if desc == "" or desc == nil then return end
                                    MessageMrg.show(desc)
                                end
                                return 
                            end)
                        else 
                            UIMrg:pop()
                            uSuperLink.openModule(self.resource.droptype[0]) 
                        end 
                    end)
                elseif canbuyType==false and self.needBuyType[i].type == "item" then  
                    if msg =="" then 
                        msg=self.needBuyType[i].arg:getDisplayColorName() ..TextMap.GetValue("Text_1_1077")
                    end 
                end 
            end
            if msg ~="" then 
                MessageMrg.show(msg)
            end 
            return
        end
        if Tool.CheckTypeBagCount(self.dropType) == false then return end
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
    -- UIMrg:pushWindow("Prefabs/moduleFabs/puYuanStoreModule/puYuanStore_buyTips", {
    --     delegate = self.delegate,
    --     item = self.item
    -- })
    local that = self
    if Tool.CheckTypeBagCount(self.dropType) == false then return end
    Api:buyShop(self.item.SHOP_TYPE, self.item.shop_pos, function(result)
        -- that.delegate:checkUpdate()
        local tp = 0
        if that.item:getType() == "char" then tp = 1 end
        packTool:showMsg(result, nil, tp)
        Store_item_cell:onUpdate()
        if that.delegate.updateRes then
            that.delegate:updateRes()
        end
    end)
end

function Store_item_cell:typeId(_type)
    self.resource = TableReader:TableRowByUnique("resourceDefine", "name", _type)
    -- local ret = false
    -- TableReader:ForEachLuaTable("resourceDefine", function(k, v)
    --     if _type == v.name then
    --         ret = true
    --         self.resource=v
    --         return false
    --     end
    -- end)
    return Tool.typeId(_type) 
end


function Store_item_cell:Start()
    --ClientTool.AddClick(self.binding, funcs.handler(self, self.onBuy))
    --ClientTool.AddClick(self.new_img_icon,gameObject, funcs.handler(self, self.onBuy))
end

return Store_item_cell