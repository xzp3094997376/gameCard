local taskList = {}

function taskList:Start(...)
    -- self.binding:CallManyFrame(function()
    --            	Events.Brocast('SelecttaskCallBack',0)  --默认第一个被选中
    --            end,1)
    --self:getDetailInfo(nil, nil)
end

function taskList:refresh(...)

end

function taskList:onEnter(...)
	self:onUpdate()
end

function taskList:onUpdate()
	self._List, refresh = self:sort(self._List)
    -- ClientTool.UpdateMyTable("Prefabs/moduleFabs/mailModule/mail_item", self._table, self.taskList)
    self.scrollView:refresh(self._List, self, refresh, -1)
	--self.delegate:updateRedPoint(true)
end 

function taskList:update(lua)
	--print_t(lua)
	if self.delegate == nil then 
		self.delegate = lua.delegate
	end 
    --   	self.bg.Url = UrlManager.GetImagesPath("tasksImage/taskbg.png")
    --    	self.rightup.Url = UrlManager.GetImagesPath("tasksImage/taskupbg.png")
    --任务
    local tasks = lua.data
    self._List = tasks
    self.id = lua.index
	self:onUpdate()
	self.firstInfo = lua.data[1]
    --排序  可领取，进行中，未解锁，前往
    --   print("updateRedPoint")
    --   print("update "..self.id)
    -- self.currentSelect = nil
    
    --  self:getDetailInfo(self.firstInfo, nil)
    --self:showDetail(self.firstInfo)
end

--可领取，进行中，未解锁，已领取
function taskList:sort(_list)
	local refresh = false 
    table.sort(_list, function(a, b)
        --print(b)
        if b ~= nil then
			if a.state == 2 or b.state == 2 then refresh = true end 
            if a.state ~= b.state then
                if a.state == 2 then return true --待领取的状态最前面，再是进行中，最后是领取完成
                elseif b.state == 2 then return false
                else return a.state < b.state
                end
            elseif a.taskInfo.priority ~= b.taskInfo.priority then
                return a.taskInfo.priority < b.taskInfo.priority
            elseif a.id ~= b.id then return a.id < b.id
            end
        end
    end)
    return _list, refresh
end

return taskList