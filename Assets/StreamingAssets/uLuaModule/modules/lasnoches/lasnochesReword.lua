local xuyegongreword = {}

function xuyegongreword:update(data)
    local list = RewardMrg.getList(data.obj)
    table.foreach(list, function(i, v)
        local binding = ClientTool.loadAndGetLuaBinding("Prefabs/moduleFabs/xuyegongModule/Dropitem", self.grid.gameObject)
        binding:CallUpdate(v)
        binding = nil
        self.grid.repositionNow = true
    end)
    list = nil
end

function xuyegongreword:onClick(go, name)
    Events.Brocast('xuyegong_getReward')
    UIMrg:popWindow()
end

--初始化
function xuyegongreword:create(binding)
    self.binding = binding
    return self
end

return xuyegongreword