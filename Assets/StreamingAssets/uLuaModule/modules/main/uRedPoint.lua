uRedPoint = uRedPoint or {}

local qiancengtaNum = 0


function uRedPoint:GetAwardState(index)
    local state = 0 --已经领取
    if index < Player.qianCengTa.lastTower and Player.qianCengTa.specialBox[index] == 0 then
        return state
    end
    state = 1 --未完成
    if Player.qianCengTa.specialBox[index] ~= 0 then
        state = 2 --可领取
    end
    return state
end

function uRedPoint.checkChapterPoint(_type)
    local tasks = Player.Tasks:getLuaTable()
    local ret = false
    table.foreach(tasks, function(k, v)
        if v.state == 2 then
            local row = TableReader:TableRowByID('allTasks', k)
            if row ~= nil and row.task_type == "chapter" then
                local i = string.find(k, _type)
                if i ~= nil then
                    ret = true
                    return true --这个return只是结束这个闭包循环
                end
            end
        end
    end)
    tasks = nil
    return ret
end

--获取英雄数量
function uRedPoint.getCharCount()
    local chars = Player.Chars:getLuaTable()
    local index = 0
    for k, v in pairs(chars) do
        index = index + 1
    end
    return index
end

--检查队伍的小红点
function uRedPoint.checkTeamRedPoint()
    local max_slot = Player.Resource.max_slot
    if max_slot > 6 then max_slot = 6 end
    local teams = Player.Team[0].chars
    local hasEnterCount = 0
    for i = 0, 5 do
        local char = {}
        if teams.Count > i then
            if teams[i .. ""] ~= 0 and teams[i .. ""] ~= "0" then
                hasEnterCount = hasEnterCount + 1
            end
        end
    end
    if hasEnterCount < max_slot and uRedPoint.getCharCount() > hasEnterCount then
        return true
    end
    return false
end

--检查小红点
function uRedPoint.checkRedPoint(_type)
    local tasks = Player.Tasks:getLuaTable()
    local ret = false

    if _type == "qianchengta" then
        if qiancengtaNum == 0 then
            qiancengtaNum = TableReader:TableRowByID("tower_config", "totelFloors").args1 --拿到千层塔最大层数
        end
        for i = 0, (qiancengtaNum + 1), 5 do
            if uRedPoint:GetAwardState(i) == 2 then
                ret = true
                return ret
            end
        end
        return ret
    end

    table.foreach(tasks, function(k, v)
        if v.state == 2 then
            local row = TableReader:TableRowByID('allTasks', k)

            -- 闯关小红点,主线任务，活动等都可以直接使用这个
            if row ~= nil and row.task_type == _type then
                ret = true
                return true
            end
        end
    end)
    return ret
end

return uRedPoint