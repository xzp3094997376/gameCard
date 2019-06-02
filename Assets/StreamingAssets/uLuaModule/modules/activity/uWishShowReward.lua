local m = {}

local canClick = false

function m:Start()
    ClientTool.AddClick(self.bgBox, self.bgBox_click)
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
        self.delegate:updateRes()
        canClick = true
        return
    end

    self:Next()
end

--luaTable = {delegate = self, list = reward_list}
function m:update(luaTable)
    self.delegate = luaTable.delegate

    local list = luaTable.data
    self.rewardList = list
	self.index = 0

    self.itemsList = ClientTool.UpdateGrid('Prefabs/moduleFabs/activityModule/WishWellItemIcon', self.Table, list)
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
    UIMrg:pushWindow("Prefabs/moduleFabs/activityModule/WishWeelRewardShow", luaTable)
end

return m