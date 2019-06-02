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
    local shoptype = 0
    TableReader:ForEachLuaTable("shop_refresh", function(k, v)
        if v.shop ==self._type then 
            shoptype=v.sell_type
        end
        return false
        end)
    self.shoptype=shoptype
    self:onUpdate()
end

--商店不支持直接卖英雄，只能买碎片和道具
local itemBind
function item_cell:onUpdate()
    local shop_item = self.shop_item
    local item = self.item
    if itemBind == nil then
        itemBind = ClientTool.loadAndGetLuaBindingFromPool("Prefabs/publicPrefabs/itemAll", self.pic.gameObject)
    end

    if shop_item ~= nil and shop_item.type ~= nil then
        self.dropType = shop_item.type
    else
        self.dropType = ""
    end
    local _item = nil
    if item:getType()=="item" and item.Table.aotu_use == 1 then 
        local cell = item.Table.drop[0]
        if cell.type=="petPiece" then 
            _item=PetPiece:new(cell.arg)
            itemBind:CallUpdate({ "char", _item, self.pic.width, self.pic.height,true,nil,nil,nil,false})
        elseif cell.type=="charPiece" then 
            _item=CharPiece:new(cell.arg) 
            itemBind:CallUpdate({ "char", _item, self.pic.width, self.pic.height,true,nil,nil,nil,false})
        else 
            itemBind:CallUpdate({ "char", item, self.pic.width, self.pic.height,true,nil,nil,nil,false})
        end 
    else 
        itemBind:CallUpdate({ "char", item, self.pic.width, self.pic.height,true,nil,nil,nil,false})
    end 
    local count = 1
    if shop_item.count > 1 then
        count = shop_item.count
    end
    if self.item.__count ~= nil then count = self.item.__count end
    item.rwCount = 1
    if self.shoptype==0 then
        self.number.gameObject:SetActive(true)
        if count>1 then 
            self.number.text = count
        else 
            self.number.text = ""
        end 
        item:updateInfo()
        if item:getType()=="charPiece" or item:getType()=="petPiece" or item:getType()=="ghostPiece" or item:getType()== "treasurePiece" then 
            if item.count>=item.needCharNumber then 
                self.xiangouLabel.text="[24FC24]（" .. item.count .. "/" .. item.needCharNumber .. "）[-]"
            else 
                self.xiangouLabel.text="[FFFFFF]（" .. item.count .. "/" .. item.needCharNumber .. "）[-]"
            end 
        elseif item:getType()=="item" and item.Table.aotu_use == 1 and _item~=nil then 
            if _item.count>=_item.needCharNumber then 
                self.xiangouLabel.text="[24FC24]（" .. _item.count .. "/" .. _item.needCharNumber .. "）[-]"
            else 
                self.xiangouLabel.text="[FFFFFF]（" .. _item.count .. "/" .. _item.needCharNumber .. "）[-]"
            end  
        elseif item:getType()=="item" and item.Table.aotu_use == 1 and item.Table.drop[0].type=="item" then 
            self.xiangouLabel.text=TextMap.GetValue("Text_1_2806") .. toolFun.moneyNumberShowOne(Tool.getCountByType(item.Table.drop[0].type, item.Table.drop[0].arg))
        else 
            self.xiangouLabel.text=TextMap.GetValue("Text_1_2806") .. Tool.getCountByType(item:getType(), item.id)
        end
        if shop_item.sell then
            self.sell:SetActive(true)
            self.new_img_icon.gameObject:SetActive(false)
        else
            self.sell:SetActive(false)
            self.new_img_icon.gameObject:SetActive(true)
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
            self.xiangouLabel.text =string.gsub(TextMap.GetValue("LocalKey_839"),"{0}",lastTimes .. "/".. shop_item.count)
        end
    end
    self.txt_name.text = item:getDisplayColorName()
    self._prize={}
    local priceList = {}
    --print_t(shop_item.price[0]:getLuaTable())
    if shop_item.price[0].sell_type~="" then 
        table.insert( priceList, shop_item.price[0])
    end 
    if shop_item.price[1].sell_type~="" then 
        table.insert( priceList, shop_item.price[1])
    end
    if #priceList==1 then 
        self.img_huobi1.gameObject:SetActive(true)
        self.img_huobi2.gameObject:SetActive(false)
    elseif #priceList==2 then 
        self.img_huobi1.gameObject:SetActive(true)
        self.img_huobi2.gameObject:SetActive(true)
        self.img_huobi1.gameObject.transform.localPosition = Vector3(-38,13, 0)
        self.img_huobi1.gameObject.transform.localPosition = Vector3(-38,-13, 0)
        local text=self.img_huobi1.gameObject:GetComponent("UITexture")
        text.width=25
        text.height=25
        local text1=self.img_huobi2.gameObject:GetComponent("UITexture")
        text1.width=25
        text1.height=25
    end
    if priceList==nil then return end 
    self.needBuyType={}
    self.canbuynum = 1
    local buy_num = shop_item.buy_num
    for i=1,#priceList do 
        self["effect" .. i]:SetActive(false)
        local price = priceList[i].sell_price
        local true_price = priceList[i].sell_num
        --出售上限
        if priceList[i].inc_limit ~= nil and true_price > priceList[i].inc_limit then 
            true_price = priceList[i].inc_limit 
        end
        if priceList[i].sell_discount ~= 100 and i==0 then
            self.img_discount.gameObject:SetActive(true)
            self.txt_sale.text = self:getDiscountStr(priceList[i].sell_discount)
            local disPlayPrice = price + math.floor(shop_item.buy_num / (priceList[i].step or 1)) * (priceList[i].inc or 0)
            --出售上限
            if priceList[i].inc_limit ~= nil and disPlayPrice > priceList[i].inc_limit then 
                disPlayPrice = priceList[i].inc_limit 
            end
        else
            self.img_discount.gameObject:SetActive(false)
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
            -- elseif item:getType()=="equip" then 
            --     if self:getCanEquip(item) then 
            --         self.img_discount.gameObject:SetActive(true)
            --         self.img_discount.spriteName="jiaobiao_1"
            --         self.txt_sale.text="可装备"
            --     end  
            end 
        end
        if self.shoptype==0 then 
            true_price=true_price*count
        end 
        local iconName=""
        if priceList[i].sell_type == "item" then 
            local itemcell=uItem:new(priceList[i].sell_arg)
            iconName = itemcell.Table.iconid
            local buynum =0
            local totalNum = itemcell.count
            for j=1,self.canbuynum do
                if totalNum>=true_price then 
                    buy_num=buy_num+1
                    local cur_price =price+math.floor((buy_num-1)/tonumber(priceList[i].step))*tonumber(priceList[i].inc)
                    --出售上限
                    if priceList[1].inc_limit ~= nil and cur_price > priceList[i].inc_limit then 
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
            local totalNum = Tool.getCountByType(priceList[i].sell_type)
            for j=1,self.canbuynum do
                if totalNum>=true_price then 
                    buy_num=buy_num+1
                    local cur_price =price+math.floor((buy_num-1)/tonumber(priceList[i].step))*tonumber(priceList[i].inc)
                    --出售上限
                    if priceList[1].inc_limit ~= nil and cur_price > priceList[i].inc_limit then 
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

--觉醒装备的可装备判断
function item_cell:getCanEquip(item)
    local teams = Player.Team[0].chars
    local len = teams.Count
    for i = 1, 6 do
        if i - 1 < len and teams[i - 1]~=nil then
            local char = Char:new(teams[i - 1])
            if char~=nil then 
                local equips = char:getEquips(true)
                for i = 1, #equips do
                    local equip = equips[i]
                    if equip.id == item.id then 
                        equip:updateInfo()
                        if equip:getChar() == nil and equips.count==0 then 
                            return true 
                        end 
                    end  
                end
            end 
        end
    end
    return false
end

-- 急需判断
function item_cell:getCanNeed(item)
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
                local isShow = self:getCanNeedByRow(item,row)
                if isShow then 
                    return true
                end
            end 
        end 
    end
    return false
end

-- 急需判断
function item_cell:getCanNeedByRow(item,row)
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
function item_cell:getCanNeed_two(item)
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

function item_cell:getCanNeedByRow_two(item,row)
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

function item_cell:setIcon(old, name, ret)
    local assets = packTool:getIconByName(name)
    self[old]:setImage(name, assets)
    Tool.SetActive(self[old], ret)
end

function item_cell:getDiscountPic(discount)
    if discount == 100 then return "" end
    return "discount_" .. discount / 10
end

function item_cell:updatePiece()
    local shop_item = self.shop_item
    local priceList = {}
    if shop_item.price[0].sell_type~="" then 
        table.insert( priceList, shop_item.price[0])
    end 
    if shop_item.price[1].sell_type~="" then 
        table.insert( priceList, shop_item.price[1])
    end
    if priceList==nil then return end 
    self.needBuyType={}
    self.canbuynum = 1
    for i=1,#priceList do 
        if priceList[i].sell_type == "item" then 
            local itemcell=uItem:new(priceList[i].sell_arg)
            local buynum =math.floor(itemcell.count/self._prize[i])
            self.canbuynum=math.min(self.canbuynum,buynum)
            if itemcell.count < self._prize[i] then
                table.insert(self.needBuyType,{type=priceList[i].sell_type,arg=itemcell})
            end
        else 
            local buynum =math.floor(Tool.getCountByType(priceList[i].sell_type)/self._prize[i])
            self.canbuynum=math.min(self.canbuynum,buynum)
            if (Tool.getCountByType(priceList[i].sell_type) < self._prize[i]) then
                table.insert(self.needBuyType,{type=priceList[i].sell_type,arg=priceList[i].sell_arg})
            end
        end
    end
end

function item_cell:onClick()
    if self.shoptype==1 then
        if lastTimes <= 0 then
            MessageMrg.show(TextMap.GetValue("Text1411"))
            return
        end
        if Tool.CheckTypeBagCount(self.dropType) == false then return end
        UIMrg:pushWindow("Prefabs/moduleFabs/puYuanStoreModule/shop_zahuoBuy", {
            prize = self._prize,
            maxCount = lastTimes,
            item = self.item,
            delegate = self
        })
        return
    end
    if #self.needBuyType ==0 then 
        self:updatePiece()
    end 
    if #self.needBuyType>0 then
        local canbuyType = false
        local msg = ""
        for i=1,#self.needBuyType do
            if canbuyType==false and self:typeId(self.needBuyType[i].type) then 
                canbuyType=true
                local name = Tool.getResName(self.needBuyType[i].type)
                DialogMrg.ShowDialog(name .. TextMap.GetValue("Text_1_1076"), function()
                    UIMrg:pop()
                    uSuperLink.openModule(self.resource.droptype[0]) 
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
    local that = self
    if Tool.CheckTypeBagCount(self.dropType) == false then return end
    Api:buyShop(self.item.SHOP_TYPE, self.item.shop_pos, function(result)
        -- that.delegate:checkUpdate()
        that.item:updateInfo()
        packTool:showMsg(result, nil, 0,function ()
            print("GGGGGGGGGGGG")
            --that:onUpdate()
        end)
        if that.delegate.onUpdate then
            that.delegate:onUpdate()
        end
        --that:onUpdate()
    end)
end

function item_cell:item_cell()
    Events.RemoveListener('pack_itemChange')
end

function item_cell:OnDestroy()
    Events.RemoveListener('pack_itemChange')
end

function item_cell:typeId(_type)
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


function item_cell:Start()
    --ClientTool.AddClick(self.binding, funcs.handler(self, self.onBuy))
    --ClientTool.AddClick(self.new_img_icon,gameObject, funcs.handler(self, self.onBuy))
    Events.AddListener("pack_itemChange",
    function(params)
        item_cell:onUpdate()
    end
    )
end

return item_cell