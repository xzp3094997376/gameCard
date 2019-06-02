local m = {}

local canClick = false

function m:Start()
    ClientTool.AddClick(self.bgBox, self.bgBox_click)
    --self.bgEff.Url = UrlManager.GetImagesPath("activity/huodong_huode_di.png")
end

function m:bgBox_click()
    if canClick then
        UIMrg:popWindow()
    end
end

function m:Next()
    local comp = self.itemsList[self.index]
    if comp ~= nil then
        comp:PlayTween("ani", 0.3, funcs.handler(self, self.play))
    end
end

function m:play()
    local list = self.rewardList
    local count = table.getn(list)

    self.index = self.index + 1
    if (self.index > count) then
        canClick = true
        return
    end

    self:Next()
end

--luaTable = {delegate = self, list = reward_list}
function m:update(luaTable)
    self.delegate = luaTable.delegate

    local list = luaTable.list
    self.rewardList = list
    self.index = 0

    local item_list = {}
    for i = 1, #list do
        local drop = list[i]
        local item = {}

        if drop.type == "char" then
            item = Char:new(drop.arg)
        else
            item = itemvo:new(drop.type, drop.arg2, drop.arg)
        end
        table.insert(item_list, item)
    end

    self.itemsList = ClientTool.UpdateGrid('Prefabs/moduleFabs/activityModule/RouletteItemIcon', self.Table, item_list)
    for i = 1, #self.itemsList do
        local it = self.itemsList[i]
        local tran = it.transform:Find("ani")
        if tran then
            tran.localScale = Vector3(0, 0, 0)
        end
    end
    local that = self
    self.binding:CallAfterTime(0.2, function()
        that:play()
    end)
end

--显示
function m:show(luaTable)
    UIMrg:pushWindow("Prefabs/moduleFabs/activityModule/RouleteeRewardTen", luaTable)
end

return m