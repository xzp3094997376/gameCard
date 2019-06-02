local taskList = {}

-- local bindList = {}
-- local bindLen = 0
function taskList:create(binding)
    self.binding = binding;
    return self
end

function taskList:onExit(...)
    self.exit = true
    Player:removeListener("taskList")
end

function taskList:onUpdate()
    self:getTaskList(self.task_type)
    if self.task_jifen then
        self.task_jifen:CallUpdate()
    end
	--if self.delegate ~= nil then self.delegate:updateRedPoint(true) end
end 

function taskList:update(_type)
    self.task_type = _type[1]
	self:onUpdate()
end

function taskList:Start()
    local that = self
    Player.Resource:addListener("taskList", "money", function(key, attr, newValue)
        that:update({ that.task_type })
    end)
end

function taskList:OnDestroy()
	Player:removeListener("taskList")
end

function taskList:getTaskList(_type)
    local tasks = Player.Tasks:getLuaTable()
    --从服务器获取任务列表
    local that = self
    self._taskList = {}
    table.foreach(tasks, function(k, v)
        local row = TableReader:TableRowByID('allTasks', k)
        if row == nil then
            if _type == "grow" and v.type == "gm" and v.gmDesc.invisable == 1 then
                local m = {}
                m.type = v.type
                m.id = k --任务id
                m.taskInfo = v --任务内容
                m.row = nil
                m.delegate = that
                m.drop = that:getDrop(v)
                table.insert(that._taskList, m)
                m = nil
            end
        else
            if row.task_type == _type and row.invisable == 1 then

                if _type == "grow" and v.state == 3 then

                    return
                end --如果是任务领取后消失，如果不是日常领取后不消失
                local m = {}
                m.type = _type
                m.id = k --任务id
                m.taskInfo = v --任务内容
                m.row = row
                m.delegate = that
                m.drop = that:getDropByTable(row.drop)
                table.insert(that._taskList, m)
                m = nil
            end
        end
    end)
    table.sort(self._taskList, function(a, b)
        if a.taskInfo.state ~= b.taskInfo.state then
            if a.taskInfo.state == 2 then return true --待领取的状态最前面，再是进行中，最后是领取完成
            elseif b.taskInfo.state == 2 then return false
            else return a.taskInfo.state < b.taskInfo.state
            end
            -- if a.taskInfo.state > b.taskInfo.state then
            --     return a.taskInfo.state > b.taskInfo.state
        elseif a.row.priority ~= b.row.priority then
            --     if a.row.priority < b.row.priority then
            return a.row.priority < b.row.priority
        elseif a.id ~= b.id then return a.id < b.id
        end
        --     else
        --         return false
        --     end       
        return false
    end)
    self.scrollView:refresh(self._taskList, self, false, -1)
    --  self.questITems.repositionNow = true
    --  self.binding:CallAfterTime(0.1, function(...)
    --     ClientTool.UpdateGrid("Prefabs/moduleFabs/questModule/quest", self.questITems, self._taskList)
    self._taskList = nil
    --    end)
    --  self.questITems.repositionNow = true
    --self.scrollView:refresh(self._taskList, self, false) --刷到上一次到的地方
end

function taskList:getDropByTable(drop)
    local _list = {}
    if drop.Count == 1 then
        if self:isUsedType(drop[0].type) then
            local m = {}
            m.type = drop[0].type
            m.arg = drop[0].arg
            m.arg2 = drop[0].arg2 or 0
            table.insert(_list, m)
        end
    else
        for i = 0, drop.Count - 1 do
            if self:isUsedType(drop[i].type) then
                local d = drop[i]
                local m = {}
                m.type = d.type
                m.arg = d.arg
                m.arg2 = d.arg2
                table.insert(_list, m)
                m = nil
            end
        end
    end
    return _list
end

function taskList:isUsedType(_type)
    if Tool.typeId(_type) then 
        return true 
    elseif Tool.notResType(_type) then 
        return true 
    end 
    return false
end

function taskList:getDrop(info)
    -- body
    --从服务器获取奖励的物品
    local drop = info.drop:getLuaTable()
    local _list = {}
    for i, v in pairs(drop) do
        if self:isUsedType(v.type) then
            local m = {}

            m.type = v.type
            m.arg = v.arg
            m.arg2 = v.arg2
            table.insert(_list, m)
            m = nil
        end
    end
    return _list
end

function taskList:onEnter()
	self:onUpdate()
   --if self.exit == true then
   --    local that = self
   --    Player.Resource:addListener("taskList", "money", function(key, attr, newValue)
   --        that:update({ that.task_type })
   --    end)
   --    -- self.questITems.repositionNow = true
   --    that:update({ that.task_type })
   --    -- that:update({ task_Type = that.task_type })
   --    self.exit = false
   --end
end

function taskList:showMsg(drop, style)
    --local list = RewardMrg.getList(drop)
    --local ms = {}
    --table.foreach(list, function(i, v)
    --    local g = {}
    --    g.type = v:getType()
    --    g.icon = v:getHeadSpriteName() -- "resource_fantuan"
    --    g.text = v.rwCount
    --    g.goodsname = v.name
    --    g.frame = v:getFrame()
    --    g.atlasName = packTool:getIconByName(g.icon)
    --    table.insert(ms, g)
    --end)
    --如果需要开启宝箱效果 请把下面3行注释打开。。 modify  2015 2 12 by guan
    -- if style == "daily" then
    --     OperateAlert.getInstance:showGetGoods(ms,self.msg.gameObject)
    -- else
    --OperateAlert.getInstance:showGetGoods(ms, self.msg.gameObject)
    -- end
    -- body
    if self.task_jifen then
        self.task_jifen:CallUpdate()
    end
end

function taskList:refresh(_type, ret)
    if ret then
        --        self.questITems.repositionNow = true
        --    self.questITems.repositionNow = true
        self.binding:CallManyFrame(function()
            --            self:getTaskList(_type)
            self:getTaskList(_type)
        end, 3)
    else
        --   self.questITems:Reposition()
        self:getTaskList(_type)
    end
end

return taskList