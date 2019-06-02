local shop = {}

function shop:onEnter()
end

function shop:showMsg(result)
    local list = RewardMrg.getList(result)
    local ms = {}
    table.foreach(list, function(i, v)
        local g = {}
        g.type = 0
        g.icon = "resource_fantuan"
        g.text = v.rwCount
        g.goodsname = v.name
        table.insert(ms, g)
        g = nil
    end)
    OperateAlert.getInstance:showGetGoods(ms, UIMrg.top)
end

function shop:create()
    return self
end

local list = {}
function shop:Start()
    LuaMain:ShowTopMenu()
    local find = -1
    local _index = 0
    TableReader:ForEachLuaTable("allTasks", function(index, item)
        if item.task_type == "module" then
            table.insert(list, item)
            if find == -1 then
                local a1 = Player.Tasks[item.id]
                if a1.state == 2 then find = _index end
            end
            _index = _index + 1
        end
        return false
    end)
    -- shop:sortList()  暂时不排序了
    self.gift_view:refresh(list, self, true, find)
    list = nil
    self.simpleImage.Url = UrlManager.GetImagesPath("activity/act_bg3.png")
end

function shop:sortList()
    table.sort(list, function(a, b)
        local a1 = Player.Tasks[a.id]
        local b1 = Player.Tasks[b.id]
        if a1.state ~= b1.state then return a1.state > b1.state end
        if a.complete.level.times ~= b.complete.level.times then return a.complete.level.times < b.complete.level.times end
    end)
end


return shop