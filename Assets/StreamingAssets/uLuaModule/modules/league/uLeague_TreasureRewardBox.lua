-- 公会领奖面板
local m = {}

--初始化
function m:create(binding)
    self.binding = binding
    return self
end

function m:update(data)
    self.data = data
    if data.isOther == false then
        self:setData_self()
    else
        self:setData_other()
    end
    self.grid.repositionNow = true
    --0 还不能领奖 1可以领奖而未领  2 完成领奖
    print("lzh ---------------------------")
    print(data.state)
end

function m:setData_self(...)
    table.foreach(self.data.drop, function(i, v)
        local vo = {}
        --vo.type = v:getType()
        vo.data = v
        local binding = ClientTool.loadAndGetLuaBinding("Prefabs/moduleFabs/packModule/newpackDropitem", self.grid.gameObject)
        binding:CallUpdate(vo)
        binding = nil
    end)
    --self.grid:refresh("Prefabs/moduleFabs/leagueModule/league_TreasureRewardBoxItem", self.data.drop, self, #self.data.drop)
    self.LabelTip.text = TextMap.GetValue("Text1300")
end

function m:setData_other(...)
    local itemCount = self.data.drop.Count
    for i = 0, itemCount - 1 do
        local _type = self.data.drop[i]["t"]
        print("---------------_update------------------------" .. _type)
        print(self.data.drop[i])
        local vo = {}
        vo.type = _type
        local char = {}
        char = RewardMrg.getDropItem({type=_type, arg2=self.data.drop[i]["a2"], arg=self.data.drop[i]["a1"]})
        vo.data = char
        local infobinding = ClientTool.loadAndGetLuaBinding("Prefabs/moduleFabs/leagueModule/league_TreasureRewardBoxItem", self.grid.gameObject)
        infobinding:CallUpdate(vo)
    end
    self.LabelTip.text =string.gsub(TextMap.GetValue("LocalKey_732"),"{0}",self.data.name)
end


function m:onClick(go, name)
    if name == "closeBtn" then
        UIMrg:popWindow()
    elseif name == "btn_queren" then
        UIMrg:popWindow()
    end
end

return m