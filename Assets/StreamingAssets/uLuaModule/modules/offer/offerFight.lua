--悬赏试炼界面
local challengeFight = {}
local selectPanel = {}

local currentFightTimes = 0
local currentLingCount = 0 --玩家当前悬赏令或者挑战令的数量
local selectSprite
local selectID = 1 --当前选中的id

local moduleBaseData --数据
local moduleItemData = {} --每一个子模块的难度，默认是6个，但是我会读表
local moduleDiffCellBind = {} --对应的bind列表
local itemBind = {} --物品bind

function challengeFight:Start()
    LuaMain:ShowTopMenu()
end

function challengeFight:onEnter()
    challengeFight:setRetText()

    self.itemCounts.text = Player.ItemBagIndex[43].count
    currentLingCount = Player.ItemBagIndex[43].count
end

--打开悬赏试炼，1为悬赏，其他为试炼
function challengeFight:update(data)
    moduleBaseData = data
    selectID = data.id

    self.binding:CallAfterTime(0.05, function()
        self:chapterRefreashData()
    end)
end

-- 选择之后刷新数据
function challengeFight:chapterRefreashData()
    challengeFight:setRetText()
    self.Label_dec.text = moduleBaseData.desc
    self.Label_enemyName.text = moduleBaseData.remark

    self.itemName.text = TableReader:TableRowByID("item", 43)["show_name"]
    self.itemCounts.text = Player.ItemBagIndex[43].count
    currentLingCount = Player.ItemBagIndex[43].count
    self.itemSprite.spriteName = "xuanshang"

    challengeFight:CreateDiffCell()
end


function challengeFight:setRetText()
    local specialChapter = Player.specialChapter[selectID]
    local times = specialChapter.max_fight - specialChapter.fight
    self.txt_ciShu.text = TextMap.FIGHT_TIMES .. "[00ff00]" .. times

    if times > 0 then
        self.reset:SetActive(false)
        self.sectionDes:SetActive(true)
        self.txt_ciShu.gameObject:SetActive(true)
        self.btnSprite.spriteName = "Chuangguan_btn_tiaozhan"
    else
        self.sectionDes:SetActive(false)
    end
end

--赋值或者创建6个难度的小格子，要求必须所有的难度个数一致
function challengeFight:CreateDiffCell()
    local tempInt = 1

    TableReader:ForEachLuaTable("specialChapter", function(index, item)
        if item.chapter == selectID then
            moduleItemData[item.id] = item
            local tempData = {}
            tempData.data = item
            tempData.Chapter = selectID
            tempData.index = tempInt
            tempData.callBack = self.callBackDiffCellClick

            if moduleDiffCellBind[tempInt] == nil then
                local infobind = ClientTool.loadAndGetLuaBinding("Prefabs/moduleFabs/offer_challenge/diff_cell", self.diffcellTable.gameObject)
                moduleDiffCellBind[tempInt] = infobind
            end

            moduleDiffCellBind[tempInt]:CallUpdate(tempData)
            tempInt = tempInt + 1
        end

        return false
    end)

    self.diffcellTable.repositionNow = true
end


local isHaveSelectDiff = false
local isSelectDiffSprite
local selectDIffCell = 0
function challengeFight:callBackDiffCellClick(id, sprite, bol)
    if bol and isHaveSelectDiff == false then
        isHaveSelectDiff = true
        isSelectDiffSprite = sprite
        isSelectDiffSprite:SetActive(true)
        selectDIffCell = id
    else --这是直接点击的那种
    if isSelectDiffSprite ~= nil then
        isSelectDiffSprite:SetActive(false)
    end
    isSelectDiffSprite = sprite
    isSelectDiffSprite:SetActive(true)
    selectDIffCell = id
    end

    challengeFight:chapterRefreashModelAndItems()
end

--赋值模型和可能获得物品
function challengeFight:chapterRefreashModelAndItems()
    self.textureEasy:LoadByModelId(moduleItemData[selectDIffCell].model, "stand", function() end, false, 0, moduleItemData[selectDIffCell].big / 1000)

    local tempObj = moduleItemData[selectDIffCell]
    local dropCount = tempObj.probdrop.Count - 1
    if dropCount > 3 then
        dropCount = 3
    end

    for i = 0, 3 do
        if i <= dropCount then
            local vo = itemvo:new(tempObj.probdrop[i]["type"], 1, tempObj.probdrop[i]["arg"], 1, "1")
            if itemBind[i] == nil then
                local infobinding = ClientTool.loadAndGetLuaBinding("Prefabs/moduleFabs/offer_challenge/challengeItemCell", self.itemTable.gameObject)
                itemBind[i] = infobinding
            end

            itemBind[i].gameObject:SetActive(true)
            itemBind[i]:CallUpdate(vo)
        else
            if itemBind[i] ~= nil then
                itemBind[i].gameObject:SetActive(false)
            end
        end
    end

    self.itemTable.repositionNow = true
end

--体力是否足够
--2014.1.23  高原说悬赏试炼不消耗体力
function challengeFight:isBp()
    --return Player.Resource.bp < self.tb.consume[1].consume_arg
    return false
end

-- 挑战
function challengeFight:onChallenge(go)
    if self:isBp() == true then
        DialogMrg.ShowDialog(TextMap.GetValue("Text1329"), DialogMrg.buyBp)
        return
    end

    challengeFight:fightIng(LuaMain:getTeamByIndex(0))
end

function challengeFight:SendResetAPI(dlg)
    Api:resetSpecialChapterTicket(selectID, function(result)
        self:setRetText()

        if dlg ~= nil then
            if dlg.refreash ~= nil then
                dlg:refreash()
            end

            if dlg.showMoveDlg ~= nil then
                dlg:showMoveDlg()
            end
        end
    end)
end

-- 重置
function challengeFight:onReset(go)
    local that = self

    local buyType = "xs" .. selectID
    DialogMrg:BuyBpAOrSoul(buyType, "", toolFun.handler(self, self.updateForBuyBpAOrSoul),
        toolFun.handler(self, self.BuyBpAOrSoul_Change),
        toolFun.handler(self, self.SendResetAPI))
end

function challengeFight:fightIng(arr)
    if arr == nil then
        DialogMrg.ShowDialog(TextMap.GetValue("Text83"))
        return
    end

    Api:fightSpecialChapter(selectDIffCell, arr, 0, function(result)
        local fightData = {}
        fightData["battle"] = result
        fightData["mdouleName"] = "shilian"
        fightData["id"] = selectDIffCell
        fightData["arr"] = arr
        UIMrg:pushObject(GameObject())
        fightData["team"] = 0
        UluaModuleFuncs.Instance.uOtherFuns:callBackFight(fightData)
        fightData = nil
    end, function(ret, reuslt)
        return false
    end)
end

function challengeFight:onClick(go, name)
    if name == "challengeBtn" then
        local specialChapter = Player.specialChapter[selectID]
        local times = specialChapter.max_fight - specialChapter.fight

        if times > 0 then
            self:onChallenge(go)
        else
            self:onReset(go)
        end
    elseif name == "btn_add_times" then
        local buyType = "xs" .. selectID
        DialogMrg:BuyBpAOrSoul(buyType, "", toolFun.handler(self, self.updateForBuyBpAOrSoul),
            toolFun.handler(self, self.BuyBpAOrSoul_Change),
            toolFun.handler(self, self.SendResetAPI))
    end
end

function challengeFight:BuyBpAOrSoul_Change()
end

function challengeFight:updateForBuyBpAOrSoul()
end

return challengeFight
