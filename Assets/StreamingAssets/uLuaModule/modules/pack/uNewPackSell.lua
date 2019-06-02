local newPackSell = {}

function newPackSell:update(tempdata)
    self.vo = tempdata.obj
    self.go = tempdata.go
    self.txt_name.text = self.vo.itemColorName
    local count = self.vo.itemShowCount
    if count == " " then 
        count = 1
    end 
    self.txt_XXX.text = TextMap.GetValue("Text1345") .. count
    self.img_kuangzi.gameObject:SetActive(false)
    self.moneySprite.gameObject:SetActive(true)
    if self.vo.itemType == "charPiece" and self.vo.star > 3 then
        self.moneySprite.spriteName = "p_btn"
    else
        self.moneySprite.spriteName = "main_coin"
    end

    if tempdata.sellType == "juexing" then
        self.img_ShenHun.gameObject:SetActive(true)
        self.moneySprite.gameObject:SetActive(false)
    else
        self.img_ShenHun.gameObject:SetActive(false)
    end

    if tempdata.type == "sell" then
        self.btntxt_nor.text = TextMap.GetValue("Text1346")
        self.moneyGo:SetActive(true)
        self.titleName.text = TextMap.GetValue("Text1335")
        self.numberSelect:setCallFun(newPackSell.setMoneyChange, self)
    else
        --self.numberSelect.transform.localPosition = Vector3(0, -60, 0)
        self.titleName.text = TextMap.GetValue("Text363")
        self.moneyGo:SetActive(false)
        self.btntxt_nor.text = TextMap.GetValue("Text363")
    end
    local binding = ClientTool.loadAndGetLuaBindingFromPool("Prefabs/publicPrefabs/itemAll", self.newpackitem)
    binding:CallUpdate({ "itemvo", self.vo, self.img_kuangzi.width, self.img_kuangzi.height })
    self.selectNum.text="1"
    self.numberSelect.selectNum = 1
    newPackSell:setMoneyChange(1)
    local maxCount = 0
    if self.vo.itemType == "item" then
        maxCount = self:limitNum(self.vo.itemID)
    end
    if maxCount ~= 0 then --说明是item的特殊的几个宝箱
        self.numberSelect:maxNumValue(maxCount) --传过去最大值
    else
        if self.vo.itemCount ~= nil then
            self.numberSelect:maxNumValue(self.vo.itemCount)
        elseif self.vo.itemShowCount ~= nil and self.vo.itemShowCount ~= " " then
            --print("xxxxx "..self.vo.itemShowCount)
            self.numberSelect:maxNumValue(tonumber(self.vo.itemShowCount))
        else
            self.numberSelect:maxNumValue(1)
        end
        --  self.txt_XXX.text = "拥有数量："..self.vo.itemCount
        -- if self.vo.itemCount > 99 then
        --     self.numberSelect:maxNumValue(99)
        --     self.txt_XXX.text = "当前拥有数量：99+"
        -- else
        --     self.numberSelect:maxNumValue(self.vo.itemCount)
        -- end
    end
end

function newPackSell:limitNum(id)
    if self.titleName.text == TextMap.GetValue("Text_1_349") then
        return Player.ItemBagIndex[id].count
    end
    local num = Player.ItemBagIndex[id].count
    local msg = ""
    local row =TableReader:TableRowByID("item", id)

    local maxUseCount =row.use_limit
    local consume=row.consume
    --print_t (consume)
    if consume~=nil and consume[0].consume_type =="item" then 
        local consumeid=consume[0].consume_arg
        if consumeid== id then 
            if num > maxUseCount then
                num = maxUseCount
            end
        else 
            print (consume[0].consume_arg2)
            local consumenum=newPackSell:limitNum(consumeid)/consume[0].consume_arg2
            if num > maxUseCount then
                num = maxUseCount
                if num >consumenum then 
                    num =consumenum
                end
            end
        end
    else
        if num > maxUseCount then
            num = maxUseCount
        end
    end
    return num
end

function newPackSell:setMoneyChange()
    self.money.text = self.selectNum.text * self.vo.itemSell --强制类型转换
end

function newPackSell:useSellBack()
    Events.Brocast('pack_itemChange')
    UIMrg:popWindow()
end

function newPackSell:onClick(go, name)
    if name == "btn_quxiao" or name == "btnClose" then
        UIMrg:popWindow()
    end
    if name == "btn_queren" then
        if self.btntxt_nor.text == TextMap.GetValue("Text1346") then
            Api:sellItem(self.vo['itemType'], self.vo['itemKey'], tonumber(self.selectNum.text),
                function(result)
                    -- newPackSell:showGetItems(result)
                    local tp = self.vo.itemTable.use_type or 0
                    packTool:showMsg(result, nil, tp)
                    UIMrg:popWindow()
                    newPackSell:useSellBack()
                end)
        else --如果是使用
        Api:useItem(self.vo['itemType'], self.vo['itemKey'], tonumber(self.selectNum.text),
            function(result)
                local tp = self.vo.itemTable.use_type or 0
                packTool:showMsg(result, nil, tp)
                UIMrg:popWindow()
                newPackSell:useSellBack()
                return true
            end, self.vo.itemID)
        end
    end
end

function newPackSell:typeId(_type)
    local typeAll = { "exp", "skill_point", "vip_exp", "money", "gold", "bp", "soul", "popularity", "credit", "honor", "hunyu", "donate" }
    for i, j in pairs(typeAll) do
        if _type == j then
            return true
        end
    end
    return false
end

function newPackSell:showGetItems(result)
    local temp = {}
    temp.obj = result
    if result.drop.Count > 1 then
        packTool:showMsg(result, self.go, 2)
        UIMrg:popWindow()
        return
    end

    if result.drop.Count == 1 and result.drop:ContainsKey("vstime") then --2015.4.27 根据服务端要求,竞技场增加次数不放入资源表,所以单独判断
    MessageMrg.showMove(string.gsub(TextMap.GetValue("LocalKey_741"),"{0}",result.drop.vstime))
    UIMrg:popWindow()
    return
    end
    if result.drop.Count == 1 and result.drop:ContainsKey("herotime") then --2015.4.27 根据服务端要求,竞技场增加次数不放入资源表,所以单独判断
    MessageMrg.showMove(string.gsub(TextMap.GetValue("LocalKey_742"),"{0}",result.drop.herotime))
    UIMrg:popWindow()
    return
    end

    local itemvalue
    -- local list = RewardMrg.getList(result)
    -- table.foreach(list,
    --     function(i, v)
    --         if newPackSell:typeId(v:getType()) then
    --             itemvalue = v
    --         end
    --     end)
    if itemvalue ~= nil then
        MessageMrg.showMove(TextMap.GetValue("Text367") .. itemvalue:getDisplayName() .. "[-] X " .. itemvalue.rwCount)
        if itemvalue:getDisplayName() == TextMap.GetValue("Text40") then --临时解决方案,以后记得更改
        MusicManager.playByID(25)
        end
        itemvalue = nil
    else
        packTool:showMsg(result, self.go, 0)
        temp = nil
    end
    UIMrg:popWindow()
end

--初始化
function newPackSell:create(binding)
    self.binding = binding
    return self
end

return newPackSell