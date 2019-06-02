local uChapterElite = {}
local currentChapter = 1 --当前关卡
local totelChapter = 3 --总的关卡
local bindingArr = {}
local bindingArrLength = 0
local currentSection = 0
local totaltimes = -1 --总的可挑战的次数-1
local isInit = false
function uChapterElite:sortAnalogData()
    if peopleDatas ~= nil then
        table.sort(peopleDatas, function(a, b)
            return a.char_num < b.char_num
        end)
    end
end

local selectHero
function uChapterElite:selectCallBack(bind)
    if selectHero ~= nil then
        selectHero.open:SetActive(false)
        selectHero.normal.transform.rotation = Quaternion.identity
        selectHero.normal:SetActive(true)
    end
    selectHero = bind
end

--之所以这个方法里面这么多注释，这么乱，是因为策划需求改变，请勿删除注释代码
local peopleDatas = {}
local peopleCounts = 0
function uChapterElite:setData()
    -- lzh add
    self.lbl_lefttimes.text = uChapterElite:getTotaltimes()
    -- lzh

    TableReader:ForEachLuaTable("heroChapterIndex",
        function(index, item)
            peopleDatas[index] = item
            peopleCounts = peopleCounts + 1
            return false
        end)
    uChapterElite:sortAnalogData()
    local fornum = peopleCounts - 1
    if fornum > 0 then
        for i = 0, fornum do
            local tempObj = {}
            tempObj = peopleDatas[i]
            tempObj.callBack = uChapterElite.selectCallBack
            if bindingArr[i + 1] == nil then
                bindingArrLength = bindingArrLength + 1
                bindingArr[bindingArrLength] = ClientTool.loadAndGetLuaBinding("Prefabs/moduleFabs/EliteModule/chapterElite_hero", self.grid.gameObject)
            end
            bindingArr[i + 1].gameObject:SetActive(true)
            bindingArr[i + 1]:CallUpdate(tempObj)
            tempObj = nil
        end
        self.grid.repositionNow = true
    end
    self.binding:CallManyFrame(function()
        if isInit == false then
            self.content:ResetPosition()
            isInit = true
        end
    end, 1)
end


function uChapterElite:Start()
    LuaMain:ShowTopMenu()
    uChapterElite:setData()
end

function uChapterElite:onEnter()
    peopleDatas = {}
    peopleCounts = 0
    uChapterElite:setData()
end

--初始化
function uChapterElite:create(binding)
    self.binding = binding
    return self
end

-- lzh 2015.05.07
-- 获取可挑战的次数
function uChapterElite:getTotaltimes()
    if totaltimes == -1 then
        local row = TableReader:TableRowByID("heroChapter_config", "max_time")
        if row.args1 ~= nil and tonumber(row.args1) ~= nil then
            totaltimes = row.args1
        else
            totaltimes = 0
        end
    end
    local lefttimes = totaltimes + Player.NBChapter.resettimes - Player.NBChapter.totaltimes
    return lefttimes;
end

function uChapterElite:onClick(go, name)
    if name == "btn_add" then
        DialogMrg:BuyBpAOrSoul("djq", "", toolFun.handler(self, self.updateForBuyBpAOrSoul),
            toolFun.handler(self, self.BuyBpAOrSoul_Change))
    end
end

function uChapterElite:BuyBpAOrSoul_Change()
    self:updateForBuyBpAOrSoul()
end

function uChapterElite:updateForBuyBpAOrSoul()
    self.lbl_lefttimes.text = uChapterElite:getTotaltimes()
end

return uChapterElite