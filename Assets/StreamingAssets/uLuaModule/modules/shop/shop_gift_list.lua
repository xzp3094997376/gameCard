local giftList = {}

function giftList:update(data, index, delegate)
    self.btnLeft.gameObject:SetActive(false)
    self.btnRight.gameObject:SetActive(false)
    self.vipLevel.text = data.id
    self.delegate = delegate
    self.id = data.id
    local obj = TableReader:TableRowByUnique("resourceDefine", "name", data.consume[0].consume_type)
    local consume = Tool.getResIcon("gold")
    if obj ~= nil then
        consume = obj.img
    end
    local atlasName = packTool:getIconByName(consume)
    self.gold:setImage(consume, atlasName)

    self.goldNum.text = data.consume[0].consume_arg
    --是否已购买
    self.vipPkg = Player.Vippkg
    self.btBuy.gameObject:SetActive(true)
    self.btBuy.isEnabled = true
    --   self.btBuy.isEnabled = false
    if self.vipPkg[data.id] == 1 then --已经购买
    self.hasBuy:SetActive(true)
    self.btBuy.gameObject:SetActive(false)
    else
        self.hasBuy:SetActive(false)
        if Player.Info.vip < data.id then
            --self.btBuy.gameObject:SetActive(true)
            self.btBuy.isEnabled = false
        else
            -- self.btBuy.gameObject:SetActive(true)
        end
    end

    self.binding:CallManyFrame(function()
        local list = RewardMrg.getProbdropByTable(data.drop)
        if table.getn(list) > 5 then
            self.btnRight.gameObject:SetActive(true)
        end
        self.binding:CallManyFrame(function()
            ClientTool.UpdateGrid("Prefabs/moduleFabs/puYuanStoreModule/cell", self.myGrid, list)
            self.myGrid:Reposition()
        end, 1)
        self.rewardList:SetDragAmount(0, 0, false)
    end)
end

function giftList:onLeft(...)
    self.rewardList:SetDragAmount(0, 0, false)
    self.binding:Show("btnRight")
    self.binding:Hide("btnLeft")
end

function giftList:onRight(...)
    self.rewardList:SetDragAmount(1, 0, false)
    self.binding:Hide("btnRight")
    self.binding:Show("btnLeft")
end

function giftList:onClick(go, name)

    if name == "btnLeft" then
        self:onLeft()
    elseif name == "btnRight" then
        self:onRight()
    elseif name == "btBuy" then
        Api:buyVipPackage(self.id, function(result)
            --   if result.ret == 0 then
            self.drop = self:onGetGift(result)
            -- print("sf "..)
            --end
        end)
    end
end


function giftList:onGetGift(result)
    local tween = self.hasBuy:AddComponent("TweenScale")
    tween.from = Vector3(1.7, 1.7, 1)
    tween.duration = 0.2
    self.hasBuy:SetActive(true)
    self.btBuy.gameObject:SetActive(false)
    self.binding:CallAfterTime(1, function()
        --      SendBatching.DestroyGameOject(self.binding.gameObject)
        self.delegate:showMsg(result)
        self.delegate:refreshGift(true)
    end)
    MusicManager.playByID(30)

    -- self:showGift(index, "恭喜你获得以下物品:")
    -- local g = {}
    -- g.type = 0
    -- g.icon = self.data.icon
    -- g.text = "VIP" .. id .. "礼包 [ceea1a]x1[-]"
    -- local g2 = {}
    -- table.insert(g2, g)
    -- OperateAlert.getInstance:showGetGoods(g2, self.txt_buyTip.gameObject)
end



function giftList:showMsg(result)
    -- drop = json.decode(drop:toString())
    local _list = RewardMrg.getList(result)
    local ms = {}
    local name = ""
    local goodsname = ""
    local num = 0
    local ms = {}
    local _type = 0
    table.foreachi(_list, function(i, v)
        print("v.." .. v.type)
        if v.type == "char" then
            name = TableReader:TableRowByID("avter", v.arg).head_img
            goodsname = TableReader:TableRowByID("avter", v.arg).name
            num = v.arg2 or 0
            _type = 1
        else
            local char = RewardMrg.getDropItem(v)
            name = char.Table.img or char.Table.iconid
            num = char.rwCount or 0
            goodsname = Tool.getNameColor(char.star or char.color or 1) .. char.name .. "[-]"
            _type = 0
        end
        local g = {}
        g.type = _type
        g.icon = name
        g.text = num
        g.goodsname = goodsname
        table.insert(ms, g)
        g = nil
    end)
    OperateAlert.getInstance:showGetGoods(ms, self.msg.gameObject)
end

return giftList