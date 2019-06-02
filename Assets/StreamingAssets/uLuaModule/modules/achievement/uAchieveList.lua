local achieve = {}

function achieve:create(binding)
    self.binding = binding
    return self
end

function achieve:Start(...)
    Tool.initMainTasks()
    -- Tool.saveTaskLastPos(Tool.lastTaskPos)
    self.mTasks = Tool.mainTasks
end

function achieve:update(data)
    if data then
        self.__curActId = data[1]
    else
        self.__curActId = nil
    end
	
	self.binding:CallManyFrame(function()
		if self.tasks == nil then 
			self.tasks = self:getTaskData()
		end
		self.BlockRight:CallUpdate({ data = self.tasks, index = 1, delegate = data.delegate})
    end, 1)
end

function achieve:refreshData()
    Tool.initMainTasks()
    self.mTasks = Tool.mainTasks
	self.tasks = self:getTaskData()
	self.BlockRight:CallUpdate({ data = self.tasks, index = 1})
end 

function achieve:getTaskData(refresh)
    local _find = false
    local _findIndex = 0
    local realIndex = 1 -- Tool.lastTaskPos
    self.realIndex = realIndex
    local playerTasks = Player.Tasks:getLuaTable() --玩家身上的任务
    local _taskArray = {}
    -- --将玩家身上的任务已任务id为key
    table.foreach(playerTasks, function(k, v)
        _taskArray[k] = v
    end)
    local lv = Player.Info.level
    --  local list = RewardMrg.getProbdropByTable(self.gift[index].drop)    --读表获取掉落
    --读表，获取该表的所有内容
   local ms = {}
    --先读取每一个可解锁的阶段任务并存储起来
    TableReader:ForEachLuaTable("mainTasks_config", function(index, item)
        local _tasks = {}
        local statue = 0 --非0时表示有东西可以领取
        local progress_c = 0 --完成了多少个
        local isLock = true
        local hasRewardNum = 0
		local firstId = item.first_task_id
        --达到解锁等级去主线任务查看对应的类型中的任务并存储起来，同时需要去对比玩家身上的任务
        if Player.Info.level >= item.unlock.level.arg then
			local findId, p = self:findTask(playerTasks, self.mTasks[firstId])
			if findId ~= nil and findId ~= -1 then
				local task = self.mTasks[findId]
				local m = {}
				m.drop = self:getDropByTable(task.drop)
				m.id = task.id
				m.is_selected = false
				local complete = p.complete:getLuaTable()
				for type, value in pairs(complete) do
					m.total = value.total
					m.progress = value.progress
				end
				m.state = p.state
				m.delegate = self
				m.taskInfo = task
				if tonumber(task.unlock.level.arg) <= tonumber(lv) then
					m.lock = true
				else
					m.lock = false
				end

				if p.state == 2 then --已完成未领取
					statue = statue + 1
					progress_c = progress_c + 1
				end
				table.insert(ms, m)
				m = nil
			end 
            isLock = false
        end
        local hasFinish = false

        if hasRewardNum == item.nums then
            hasFinish = true
        end

        if self.__curActId ~= nil and _find == false and item.id == self.__curActId then --找到当前的点击的对象
        _find = true
        _findIndex = item.stage
        end
        return false
    end)
	
	--print_t(_taskAll)
    --_taskAll = self:sortItem(_taskAll)
    --self.list = _taskAll
    --  _taskAll 排序将全部领取的显示在最下面
    --self.left:refresh(_taskAll, self, true)

    --判断选择的那一个
    self.binding:CallManyFrame(function()
        Events.Brocast('SelectActCallBack', realIndex - 1)
    end, 2)
    --获取上一次保存的数值lastTaskPos
    --self:showActivity(nil, _taskAll[1].id)
	return ms
end

-- 找到这一系列任务中第一个进行中的任务
-- 1、 玩家的任务
-- 2、 系列任务中的起始任务Id
function achieve:findTask(playerTasks, firstTask)
	if firstTask == nil then return  end 
	local findId = firstTask.id
	local isFind = false
	local value = nil 
	for _k, _v in pairs(playerTasks) do  
		if _k == findId then 
			local p = _v
			p.complete:getLuaTable()
			if p.state == 2 or p.state == 0 then --未领取
				isFind = true
				value = p
			end
		end 
	end 
	
	if isFind == true then 
		return findId, value
	end 
	
	local nextId = self:getNextTaskId(firstTask.drop)
	if nextId == -1 then 
		return -1, nil
	else 
		return self:findTask(playerTasks, self.mTasks[nextId])
	end
end

function achieve:sortItem(_list)
    table.sort(_list, function(a, b)
        -- --if a.isLock ~= b.isLock then
        -- 	if a.isLock ==false and a.hasFinish == true then return false
        -- 	--if a.isLock == true and a.hasFinish == true then return false
        -- 	else return false end
        -- elseif a.hasFinish ~= b.hasFinish then
        -- 	if a.hasFinish == true then return false
        -- 	else return false end
        -- elseif a.id ~= b.id then
        -- 	return a.id < b.id
        -- end
        --if a.isLock ~= b.isLock then
        -- if a.isLock ==false and a.hasFinish == true then return false
        -- --if a.isLock == true and a.hasFinish == true then return false
        -- else return false end
        if a.hasFinish ~= b.hasFinish then
            if a.hasFinish ~= true then return true
            else return false
            end
        elseif a.isLock ~= b.isLock then
            if a.isLock == false then return true
            else return false
            end
        elseif a.id ~= b.id then
            return a.id < b.id
        end
    end)
    return _list
end

function achieve:showMsg(drop)

    local list = RewardMrg.getList(drop)
    local ms = {}
    table.foreach(list, function(i, v)
        local g = {}
        g.type = v:getType()
        g.icon = v:getHeadSpriteName() -- "resource_fantuan"
        g.text = v.rwCount
        g.goodsname = v.name
        g.frame = v:getFrame()
        g.atlasName = packTool:getIconByName(g.icon)
        table.insert(ms, g)
    end)

    OperateAlert.getInstance:showGetGoods(ms, self.PanelFront.gameObject)
end

function achieve:onExit(...)
    --Tool.saveTaskLastPos(self.currentID)
end

function achieve:onEnter(...)
    --self:updateRedPoint()
    --self:getContentData(self.currentID)
    --self.exit = false
	--self.BlockRight:CallOnEnter(false)
	self:refreshData()
end

function achieve:refresh(ret)

    if ret then
        self.ret = true
        self.binding:CallManyFrame(function()
            --	self:updateRedPoint()
            self:getTaskData()
        end, 3)
    else
        --self:updateRedPoint()
        self:getTaskData()
    end
end

function achieve:getDrop(info)
    -- body
    --从服务器获取奖励的物品
    local drop = info:getLuaTable()
    local _list = {}
    for i, v in pairs(drop) do
        --     if self:isUsedType(v.type) then
        local m = {}
        m.type = v.type
        m.arg = v.arg
        m.arg2 = v.arg2
        table.insert(_list, m)
        m = nil
        --    end
    end
    return _list
end

function achieve:getContentData(id) --获取某一个阶段的信息
	local lv = Player.Info.level
	self.binding:CallManyFrame(function()
    -- Events.Brocast('SelecttaskCallBack',0)  --默认第一个被选中
	end, 1)

	local playerTasks = Player.Tasks:getLuaTable() --玩家身上的任务
	local ms = {}
	local pro_item = 0
	local redPointNum = 0
	local row = TableReader:TableRowByID("mainTasks_config", id)
	local hasRewardNum = 0
	local total = row.nums
	--达到解锁等级去主线任务查看对应的类型中的任务并存储起来，同时需要去对比玩家身上的任务
	if Player.Info.level >= row.unlock.level.arg then
    table.foreach(self.mTasks, function(k, v)
        local isf = false

        table.foreach(playerTasks, function(_k, _v)
            if _k == v.id and isf == false then --如果从玩家身上找到该任务
            local p = _v
            local m = {}
            m.drop = self:getDropByTable(v.drop)
            m.id = v.id
            m.is_selected = false
            local complete = p.complete:getLuaTable()
            for type, value in pairs(complete) do
                m.total = value.total
                m.progress = value.progress
            end

            m.state = p.state
            m.taskInfo = v
            if p.state == 2 then --已完成未领取
				redPointNum = redPointNum + 1
				pro_item = pro_item + 1
            end
			if tonumber(v.unlock.level.arg) <= tonumber(lv) then
				m.lock = true
			else
				m.lock = false
			end
			m.delegate = self
			table.insert(ms, m)
			m = nil
			isf = true
            end
        end)

        if isf == false then --未找到表示已完成并已领取
        local m = {}
        m.drop = self:getDropByTable(v.drop) --RewardMrg.getProbdropByTable(v.drop)  --读表获取掉落
        m.id = v.id
        m.total = 0
        m.is_selected = false
        m.progress = m.total
        m.taskInfo = v
        if tonumber(v.unlock.level.arg) <= tonumber(lv) then
            m.lock = true
            m.state = 3
            hasRewardNum = hasRewardNum + 1
            pro_item = pro_item + 1

        else
            m.lock = false
            m.state = 1
        end
        m.delegate = self
        table.insert(ms, m)
        m = nil
        end
    end)
end
--对根据任务优先级进行排序
table.sort(ms, function(a, b)
    if a.taskInfo.priority ~= b.taskInfo.priority then return a.taskInfo.priority < b.taskInfo.priority
    elseif a.id ~= b.id then return a.id > b.id
    end
end)
self.BlockRight:CallUpdate({ data = ms, index = id, delegate = self })
ms = nil
--更新每一个item的状态

if self.currentSelect ~= nil then
    local hasFinish = false
    if hasRewardNum == total then
        hasFinish = true
    end

    --self.hasFinish = hasFinish
    self.list[self.index].statue = redPointNum
    self.list[self.index].progress = pro_item
    self.list[self.index].hasFinish = hasFinish
    self.currentSelect:refreshState(redPointNum, pro_item, hasFinish)
end
end


function achieve:isUsedType(_type)
    if Tool.typeId(_type) then 
        return true 
    elseif Tool.notResType(_type) then 
        return true 
    end 
    return false
end

function achieve:getDropByTable(drop)
    local _list = {}

    if drop.Count == 1 then
        if self:isUsedType(drop[0].type) then
            local m = {}
            m.type = drop[0].type
            m.arg = drop[0].arg
            m.arg2 = drop[0].arg2 or 0
            table.insert(_list, m)
            m = nil
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

function achieve:getNextTaskId(drop)
    local _list = {}

    if drop.Count == 1 then
        if drop[0].type == "accept_task" then
            return drop[0].arg
        end
    else
        for i = 0, drop.Count - 1 do
            if drop[i].type == "accept_task" then
                return drop[i].arg
            end
        end
    end
    return -1
end

--function achieve:updateRedPoint(...)
--    self:getContentData(self.currentID)
--    local statue = self:getProgressByID(self.currentID)
--    self.list[self.currentID].statue = statue
--    --self.currentSelect.statue =
--    self.currentSelect:statueNum(statue)
--end

function achieve:getProgressByID(id)
    local statue = 0
    local playerTasks = Player.Tasks:getLuaTable() --玩家身上的任务
    local row = TableReader:TableRowByID("mainTasks_config", id)
    if Player.Info.level >= row.unlock.level.arg then
        table.foreach(self.mTasks, function(k, v)
            local isf = false
            table.foreach(playerTasks, function(_k, _v)
                if _k == v.id and isf == false then --如果从玩家身上找到该任务
                if _v.state == 2 then --已完成未领取
                statue = statue + 1
                end
                end
            end)
        end)
    end
    return statue
end

function achieve:refreshContent()
    -- body
end

return achieve