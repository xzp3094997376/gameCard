local buyEquip = {}

function buyEquip:update(tempdata)
    self.callFunction = tempdata.callback
    self.vo = tempdata.obj
    self.numberSelect:maxNumValue(100) --2015.2.28号将最大数量由999改成100
    if (self.vo._costCount - self.vo.count) <= 0 then
        self.money.text = self.vo.Table.buy_gold
        self.txt_XXX.text = ""
        buyEquip:setMoneyChange(1)
        self.numberSelect.selectNum = 1
    else
        self.numberSelect.selectNum = self.vo._costCount - self.vo.count
        buyEquip:setMoneyChange(self.vo._costCount - self.vo.count)
        self.money.text = self.vo.Table.buy_gold * (self.vo._costCount - self.vo.count)
        self.txt_XXX.text = TextMap.GetValue("Text523") .. (self.vo._costCount - self.vo.count)
    end
    self.txt_name.text = self.vo.name
    self.img_kuangzi.gameObject:SetActive(false)
    local binding = ClientTool.loadAndGetLuaBindingFromPool("Prefabs/publicPrefabs/itemAll", self.newpackitem)
    binding:CallUpdate({ "char", self.vo, self.img_kuangzi.width, self.img_kuangzi.height })
    self.moneyGo:SetActive(true)
    self.numberSelect:setCallFun(buyEquip.setMoneyChange, self)
end

function buyEquip:setMoneyChange()
    self.money.text = self.selectNum.text * self.vo.Table.buy_gold
end

function buyEquip:onClick(go, name)
    if name == "btn_queren" then
        local that = self
        Api:buyEquip(self.vo:getType(), self.vo.id, tonumber(self.selectNum.text),
            function(result)
                self:callFunction(nil)
                --                MessageMrg.show(TextMap.GetValue("Text435"))
                local list = RewardMrg.getList(result)
                local ms = {}
                table.foreach(list, function(i, v)
                    local g = {}
                    g.type = 0
                    g.icon = "resource_fantuan"
                    g.text = v.rwCount
                    g.goodsname = v.name
                    table.insert(ms, g)
                end)
                UIMrg:popWindow()
                OperateAlert.getInstance:showGetGoods(ms, UIMrg.top)
            end)
    else
        UIMrg:popWindow()
    end
end

--初始化
function buyEquip:create(binding)
    self.binding = binding
    return self
end

return buyEquip