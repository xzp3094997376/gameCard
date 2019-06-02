local checkinTips = {}

--关闭奖励显示
function checkinTips:destory()
    UIMrg:popWindow()
end

--设置基本数据
function checkinTips:setData()
end

function checkinTips:update(obj)

    self.item_kuangzi.gameObject:SetActive(false)
    local infobinding = ClientTool.loadAndGetLuaBindingFromPool("Prefabs/publicPrefabs/itemAll", self.go)
    if obj["tipType"] == "char" then
        infobinding:CallUpdate({ "char", obj.tipData, self.item_kuangzi.width, self.item_kuangzi.height })
        self.moneySprite:SetActive(false)
        self.havecountTxt.gameObject:SetActive(false)
        self.lvlTxt.text = TextMap.GetValue("Text581")
        self.desTxt.text = obj.tipData:getDesc()
        self.nameTxt.text = obj.tipData.name
    else
        infobinding:CallUpdate({ "itemvo", obj.tipData, self.item_kuangzi.width, self.item_kuangzi.height })
        self.desTxt.text = obj.tipData.itemPro
        self.nameTxt.text = obj.tipData.itemName
        if obj.tipData.isCommon == false and obj.tipData.itemType ~= "char" then --如果是道具的
        self.havecountTxt.text =string.gsub(TextMap.GetValue("LocalKey_701"),"{0}",packTool.getNumByID(obj.tipData.itemType, obj.tipData.itemID))
        self.lvlTxt.text = TextMap.GetValue("Text584") .. obj.tipData.itemLvl
        self.moneyLabel.text = obj.tipData.itemSell
        else
            self.moneySprite:SetActive(false)
            self.havecountTxt.gameObject:SetActive(false)
            self.lvlTxt.gameObject:SetActive(false)
        end
    end
    self.qiandao_txt.text =string.gsub(TextMap.GetValue("LocalKey_702"),"{0}",obj["index"])
    obj = nil
end

function checkinTips:onClick(go, name)
    checkinTips:destory()
end

function checkinTips:create(binding)
    self.binding = binding
    return self
end

return checkinTips