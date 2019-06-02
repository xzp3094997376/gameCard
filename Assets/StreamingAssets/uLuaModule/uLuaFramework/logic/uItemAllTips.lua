local itemTips = {}

--关闭奖励显示
function itemTips:destory()
    UluaModuleFuncs.Instance.uTimer:removeFrameTime("tip_setPositon")
    UIMrg:popMessage()
end

--设置基本数据
function itemTips:setDataForMonsterORitem()
    self.item_kuangzi.gameObject:SetActive(false)
    if self.tipType == "monstervo" then
        self.lvlTxt.text = self.tipData.monserLvlSte
        self.desTxt.text = self.tipData.monsterObj.desc
        self.moneySprite:SetActive(false)
        self.nameTxt.text = self.tipData.monsterObj.show_name .. "  " .. self.tipData.monserStageLvlStr
        local infobinding = ClientTool.loadAndGetLuaBindingFromPool("Prefabs/publicPrefabs/itemAll", self.go)
        infobinding:CallUpdate({ "monstervo", self.tipData, self.item_kuangzi.width, self.item_kuangzi.height })
    else
        self.nameTxt.text = self.tipData.itemName
        self.lvlTxt.text = ""
        self.desTxt.text = self.tipData.itemPro
        self.moneySprite:SetActive(true)
        if self.tipType == "itemvo" and self.typeId(self.tipData.itemType) then
            self.moneyLabel.text = self.tipData.itemTable.sell
        else
            self.moneySprite:SetActive(false)
            self.moneyLabel.text = ""
        end
        local infobinding = ClientTool.loadAndGetLuaBindingFromPool("Prefabs/publicPrefabs/itemAll", self.go)
        infobinding:CallUpdate({ "itemvo", self.tipData, self.item_kuangzi.width, self.item_kuangzi.height })
    end
    self.content.transform.localPosition = Vector3(10000, 10000, 0) --很猥琐的方法
    UluaModuleFuncs.Instance.uTimer:frameTime("tip_setPositon", 2, 1, self.delaySetPositon, self)
end

--用于char类型的tips，暂时不支持显示人物
function itemTips:setDataForChar()
    self.item_kuangzi.gameObject:SetActive(false)
    self.nameTxt.text = self.tipData.name
    self.lvlTxt.text = ""
    self.desTxt.text = self.tipData.Table.desc
    self.moneySprite:SetActive(true)
    self.moneyLabel.text = ""
    if self.tipData:getType() ~= "char" then
        self.moneyLabel.text = self.tipData.Table.sell
    end
    local infobinding = ClientTool.loadAndGetLuaBindingFromPool("Prefabs/publicPrefabs/itemAll", self.go)
    infobinding:CallUpdate({ "char", self.tipData, self.item_kuangzi.width, self.item_kuangzi.height })
    self.content.transform.localPosition = Vector3(10000, 10000, 0) --很猥琐的方法
    UluaModuleFuncs.Instance.uTimer:frameTime("tip_setPositon", 2, 1, self.delaySetPositon, self)
end

function itemTips:delaySetPositon()
    UluaModuleFuncs.Instance.uTimer:removeFrameTime("tip_setPositon")
    local truex = -self.bg.width / 2 + self.positonX
    local truey = self.positonY + self.bg.height
    if (truex + self.bg.width) > Screen.width / 2 then
        truex = Screen.width / 2 - self.bg.width
    elseif -truex > Screen.width / 2 then
        truex = -Screen.width / 2
    elseif truey > Screen.height / 2 then
        truey = Screen.height / 2
    end

    self.content.transform.localPosition = Vector3(truex, truey, 0)
end


function itemTips:typeId(_type)
    local typeAll = { "equip", "equipPiece", "item", "char", "charPiece", "reel", "reelPiece" }
    for i, j in pairs(typeAll) do
        if _type == j then
            return true
        end
    end
    return false
end

function itemTips:update(obj)
    self.tipData = obj["tipData"]
    self.tipType = obj["type"]
    self.positonX = obj["x"]
    self.positonY = obj["y"]
    if self.tipType == "char" then
        itemTips:setDataForChar()
    else
        itemTips:setDataForMonsterORitem()
    end
end

function itemTips:show(tipData, type, x, y)
    local temp = {}
    temp["tipData"] = tipData
    temp["type"] = type
    temp["x"] = x
    temp["y"] = y
    itemAllTips = require("uLuaModule/uLuaFramework/logic/uItemAllTips")
    local binding = UIMrg:pushMessage("Prefabs/publicPrefabs/itemAllTips", temp)
    temp = nil
    return binding
end

function itemTips:create(binding)
    self.binding = binding
    return self
end

return itemTips