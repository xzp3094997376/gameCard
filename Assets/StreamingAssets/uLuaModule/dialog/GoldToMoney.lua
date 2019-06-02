local goldMoney = {}

function goldMoney:update(...)
    -- local viprow = TableReader:TableRowByUnique("buyLimitTimes", "vip_level", Player.Info.vip)
    --   self.money_limit_times = viprow.money_limit_times
    self:updateMoney()
end

function goldMoney:updateMoney()
    self.tip.text = TextMap.GET_MONEY
    self.buyType.text = TextMap.TITLE_MONEY
    local money_time = Player.Times.buymoney
    self.mao.Url = UrlManager.GetImagesPath("purchase/Tongyong_zhaocaimao.png")

    --   local times = self.money_limit_times - money_time
    --  self._times = times
    -- self.title.text = string.gsub(TextMap.TITLE_MONEY_NUM, "{0}", money_time)
    -- self.icon.spriteName = "resource_jinbi"
    local row = TableReader:TableRowByUniqueKey("buyMoney", money_time + 1, "buy_money")
    if row == nil then
        row = TableReader:TableRowByUniqueKey("buyMoney", money_time, "buy_money")
    end
    if row ~= nil then
        local consume = row.consume
        local i = 0
        local gold = consume[i].consume_arg
        consume = row.drop

        local num = consume[i].arg
        print("gole" .. gold)
        print("num" .. num)
        self.goldNum.text = gold
        self.moneyNum.text = num
    else
        MessageMrg.show(TextMap.GetValue("Text354"))
    end
end


function goldMoney:onOk(...)
    --   if self._times == 0 then MessageMrg.show(TextMap.TIMES_OUT) return end
    local that = self
    Api:buyMoney(function(reuslt)
        MessageMrg.show(TextMap.BUY_SUCC)
        that:updateMoney()
        MusicManager.playByID(25)
        self.ueffect_gold:SetActive(false)
        self.ueffect_gold:SetActive(true)
        --        UIMrg:popWindow()
    end)
end

function goldMoney:onCancel(go)
    UIMrg:popWindow()
end

function goldMoney:create(...)
    return
end

function goldMoney:Start(...)
    self:updateMoney()
end

function goldMoney:onClick(go, name)
    if name == "sure" then
        self:onOk(go)
    elseif name == "cancel" then
        self:onCancel(go)
    end
end

return goldMoney