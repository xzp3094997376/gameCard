local m = {}
--local CAN_NOT_BUY = "您的{0}数目不足，无法购买"

function m:update(lua)
    self.delegate = lua.delegate
    local item = lua.item
    self.item = item
    self.txt_name.text = item.name

    self.item_frame.enabled = false
    if self.__itemAll == nil then
        self.__itemAll = ClientTool.loadAndGetLuaBindingFromPool("Prefabs/publicPrefabs/itemAll", self.item_frame.gameObject)
    end
    self.__itemAll:CallUpdate({ "char", item, self.item_frame.width, self.item_frame.height })

    local shop_item = item.shop_item
    local price = shop_item.sell_num
    if (Tool.getCountByType(shop_item.sell_type) < shop_item.sell_num) then
        price = "[ff0000]" .. price .. "[-]"
    end
    self.img_gold.spriteName = Tool.getResIcon(shop_item.sell_type)
    self.txt_price.text = price
    self.txt_tips.text = item.desc
    local count = 1
    if item.__count ~= nil then
        count = item.__count
    else
        count = shop_item.count
    end
    self.txt_count.text = count
end

function m:onYes(go)
    local delegate = self.delegate
    Api:buyShop(self.item.SHOP_TYPE, self.item.shop_pos, function(result)
        delegate.isRefrsh = true
        UIMrg:popWindow()
    end)
end

function m:onNo(go)
    UIMrg:popWindow()
end

function m:onClick(go, name)
    if name == "btn_yes" then
        self:onYes(go)
    elseif name == "btn_no" then
        self:onNo(go)
    end
end

function m:create()
    return self
end

return m