local arenaHang = {}
local tempObj = {}
local maxInt = 0
local currentInt = 0

function arenaHang:destory()
    UIMrg:popWindow()
    UluaModuleFuncs.Instance.uTimer:removeFrameTime("refreshArenaHang")
end

--设置基本信息
function arenaHang:refreshData()
    if currentInt <= maxInt then
        local binding = ClientTool.loadAndGetLuaBinding("Prefabs/moduleFabs/arenaModule/arena_hangCell", self.mytable)
        binding:CallUpdate(tempObj[currentInt])
        binding = nil
        currentInt = currentInt + 1
        self.myhangtable.repositionNow = true
    else
        tempObj = nil
        UluaModuleFuncs.Instance.uTimer:removeFrameTime("refreshArenaHang")
        self.myhangtable.repositionNow = true
    end
end

function arenaHang:update(args)
    Api:getRankList(function(result)
        local count = result.rank_list.Count - 1
        maxInt = count
        for i = 0, count do
            local temp = {}
            temp.level = result.rank_list[i].level
            temp.id = result.rank_list[i].id
            temp.rank = result.rank_list[i].rank
            temp.name = result.rank_list[i].name
            temp.head = result.rank_list[i].head
            tempObj[i] = temp
            temp = nil
        end
        UluaModuleFuncs.Instance.uTimer:frameTime("refreshArenaHang", 1, 0, self.refreshData, self)
    end)
end

function arenaHang:onClick(go, name)
    if name == "btn_close" then
        self:destory()
    end
end

--初始化
function arenaHang:create(binding)
    self.binding = binding
    return self
end

return arenaHang