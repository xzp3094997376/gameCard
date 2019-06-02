local money_cell = {}
local true_price = 0

--商店不支持直接卖英雄，只能买碎片和道具
function money_cell:onUpdate()
    self.thisMoneyData = TableReader:TableRowByID("moneyShop", self.thisGO.name)
    self.thisZhekouData = TableReader:TableRowByID("moneyShopArg", Player.Info.vip)
    self.txt_name.text = self.thisMoneyData.name
    self.Label.text =string.gsub(TextMap.GetValue("LocalKey_757"),"{0}",toolFun.moneyNumber(self.thisMoneyData.drop[0].arg))
    money_cell:Setdata()
end

function money_cell:Setdata()
    self.buyTimes = Player.Times["moneyShop" .. self.thisGO.name]
    self.vipTimes = self.thisZhekouData.discount_time[self.thisGO.name - 1].discount_time
    local price = self.thisMoneyData.consume[0].consume_arg
    if self.buyTimes < self.vipTimes then
        self.img_discount:SetActive(true)
        true_price = price * (self.thisMoneyData.discount / 1000)
    else
        self.img_discount:SetActive(false)
        true_price = price
    end
    --  self.true_price.text = true_price
    self.txt_price_normal.gameObject:SetActive(false)
    self.txt_price.gameObject:SetActive(false)
    if (Tool.getCountByType(self.thisMoneyData.consume[0].consume_type) < true_price) then
        self.txt_price.gameObject:SetActive(true)
        self.txt_price.text = true_price
        --self.true_price.text = "[ff0000]" .. true_price .. "[-]"
    else
        self.txt_price_normal.gameObject:SetActive(true)
        self.txt_price_normal.text = true_price
    end
    self.img_huobi.spriteName = Tool.getResIcon(self.thisMoneyData.consume[0].consume_type)
end


function money_cell:onBuy()
    if Player.Resource.gold < true_price then
        DialogMrg.ShowDialog(TextMap.GetValue("Text1420"),
            function()
                DialogMrg.chognzhi()
            end)
    else
        local msg = string.gsub(TextMap.GetValue("LocalKey_670"),"{0}",true_price)
        msg=string.gsub(msg,"{1}",self.thisMoneyData.name)
        DialogMrg.ShowDialog(msg,
            function()
                local that = self
                Api:buyShopMoney(tonumber(that.thisGO.name), self.buyTimes,
                    function(result)
                        MessageMrg.showMove(string.gsub(TextMap.GetValue("LocalKey_743"),"{0}",toolFun.moneyNumber(result.drop.money)))
                        MusicManager.playByID(25)
                        that:Setdata()
                    end)
            end, nil, TextMap.GetValue("Text249"))
    end
end

function money_cell:onOk()
end


function money_cell:create()
    return self
end

function money_cell:Start()
    ClientTool.AddClick(self.binding, funcs.handler(self, self.onBuy))
    self:onUpdate()
end

return money_cell