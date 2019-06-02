local m = {}
local canClick = false

function m:Start()
    self.ItemIcon = ClientTool.loadAndGetLuaBinding("Prefabs/moduleFabs/activityModule/RouletteItemIcon", self.gameObject)
    self.ItemIcon.gameObject.transform.localPosition = Vector3(0, -80, 0)
    self.ItemIcon.gameObject:SetActive(false)
    --self.bgEff.Url = UrlManager.GetImagesPath("activity/huodong_huode_di.png")
    ClientTool.AddClick(self.bgBox, self.bgBox_click)
end

function m:update(luaTable)
    --table是drop数组的某个数据，还没读表
    self.delegate = luaTable.delegate
    self.data = luaTable.data
    self.ItemIcon.gameObject:SetActive(true)

    local item = self.data
    if item.type == "char" then
        local it = Char:new(item.arg)
        self.ItemIcon:CallUpdate(it)
    else
        local vo = itemvo:new(item.type, item.arg2, item.arg)
        self.ItemIcon:CallUpdate(vo)
    end
    --self.ItemIcon:PlayTween("ani", 0.3, funcs.handler(self, self.setBgBox))

    self.binding:CallManyFrame(function()
        self.ItemIcon:PlayTween("ani", 0.3, function()
            canClick = true
        end)
    end, 2)
end

function m:bgBox_click()
    if canClick then
        UIMrg:popWindow()
    end
end

--显示
function m:show(luaTable)
    UIMrg:pushWindow("Prefabs/moduleFabs/activityModule/RouleteeRewardOne", luaTable)
end

return m