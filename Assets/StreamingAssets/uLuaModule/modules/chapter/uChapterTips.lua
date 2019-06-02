local chapterTips = {}
local isClose = false
--关闭奖励显示
function chapterTips:destory()
    isClose = true
    UIMrg:popWindow()
end

--设置基本数据
function chapterTips:setData()
    self.item_kuangzi.gameObject:SetActive(false)
    if self.tipType == "monster" then
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
        if self.tipData.itemTable:ContainsKey("sell") then
            self.moneyLabel.text = self.tipData.itemTable.sell
        end
        local infobinding = ClientTool.loadAndGetLuaBindingFromPool("Prefabs/publicPrefabs/itemAll", self.go)
        infobinding:CallUpdate({ "itemvo", self.tipData, self.item_kuangzi.width, self.item_kuangzi.height })
    end
    self.content.transform.localPosition = Vector3(10000, 10000, 0) --很猥琐的方法
    UluaModuleFuncs.Instance.uTimer:frameTime("tip_setPositon", 2, 1, self.delaySetPositon, self)
end


function chapterTips:delaySetPositon()
    UluaModuleFuncs.Instance.uTimer:removeFrameTime("tip_setPositon")
    local truex = self.positonX - self.item_kuangzi.width
    local truey = self.positonY + self.bg.height
    if (truex + self.bg.width) > Screen.width / 2 then
        truex = Screen.width / 2 - self.bg.width
    elseif -truex > Screen.width / 2 then
        truex = -Screen.width / 2
    elseif truey > Screen.height / 2 then
        truey = Screen.height / 2
    end
    if isClose == false then
        self.content.transform.localPosition = Vector3(truex, truey, 0)
    end
end

function chapterTips:update(obj)
    self.tipData = obj["tipData"]
    self.tipType = obj["type"]
    self.positonX = obj["x"]
    self.positonY = obj["y"]
    self:setData()
end

function chapterTips:show(tipData, type, x, y)
    local temp = {}
    temp["tipData"] = tipData
    temp["type"] = type
    temp["x"] = x
    temp["y"] = y
    local binding = UIMrg:pushWindow("Prefabs/moduleFabs/chapterModule/chapterTips", temp)
    temp = nil
    isClose = false
    return binding
end

function chapterTips:create(binding)
    self.binding = binding
    return self
end

return chapterTips