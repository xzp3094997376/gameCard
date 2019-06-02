local taskView = {}

local tType = 1
local DAILY_TYPE = 1
local TASK_TYPE = 2

function taskView:create(binding)
    self.binding = binding
    return self
end

function taskView:update(data)
	if tType == 1 then 
		local ret = self:checkLockNoMsg(219)
		if ret == false then 
			tType = 2
			self:openModule(tType)
		else 
			self:openModule(tType)
		end
	else 
		self:openModule(tType)
	end 
	self:updateBtnStatus()
	self:updateRedPoint(true)
	--if tType == DAILY_TYPE then
	--	self.v_quest_main:CallUpdate( { "daily" } )
	--elseif tType == TASK_TYPE then 
	--	self.v_moduleTask:CallUpdate()
	--end
end

function taskView:checkLockNoMsg(id)
	local linkData = Tool.readSuperLinkById( id)
    local unlockType = linkData.unlock[0].type --解锁条件
    if unlockType ~= nil then
        local level = linkData.unlock[0].arg
        if Player.Info.level < level or Player.Info.vip < linkData.vipLevel then
           return false
        end
	end
	return true
end

function taskView:onEnter()
	if self._exit and self._exit == true then 
		self._exit = false
		if self.v_quest_main.gameObject.activeInHierarchy then 
			self.v_quest_main:CallOnEnter(false)
		end 
		if self.v_moduleTask.gameObject.activeInHierarchy then 
			self.v_moduleTask:CallOnEnter(false)
		end 
		self:updateRedPoint(true)
	end 
end

function taskView:Start()
	LuaMain:ShowTopMenu()
	Tool.loadTopTitle(self.gameObject, TextMap.GetValue("Text_1_9"))
	self.v_quest_main:CallTargetFunction( "setDelagate", {delegate = self} )
	Events.RemoveListener("updateTaskRedPoint")
	Events.AddListener("updateTaskRedPoint", funcs.handler(self, self.updateRedPoint))
end

function taskView:OnDestroy()
	Events.RemoveListener("updateTaskRedPoint")
end

function taskView:onExit(...)
	self._exit = true 
	print("onExit task")
end

function taskView:onClick(go, name)
	if name == "btnBack" then
		UIMrg:pop()
	elseif name == "v_btnDaily" then 
		if tType ~= DAILY_TYPE then 
			local ret = self:openModule(DAILY_TYPE)
			if ret == true then tType = DAILY_TYPE
			else tType = TASK_TYPE end 
			
		end
	elseif name == "v_btnTask" then 
		if tType ~= TASK_TYPE then 
			local ret = self:openModule(TASK_TYPE)
			if ret == true then tType = TASK_TYPE 
			else tType = DAILY_TYPE end 
		end
	elseif name == "btn_test" then 
		UIMrg:pushWindow("Prefabs/moduleFabs/alertModule/gui_test")
	end
	self:updateBtnStatus()
end

function taskView:updateRedPoint(refresh)
	print("刷新红点： " .. tostring(refresh))
	refresh = refresh or true
	self.red_richan:SetActive(Tool.checkRedPoint("active", nil, refresh) or false)
	self.red_zhuxian:SetActive(Tool.checkRedPoint("task", nil, refresh) or false)
end

function taskView:updateBtnStatus()
	if tType == DAILY_TYPE then 
		self.dailyselect:SetActive(true)
		self.taskselect:SetActive(false)
	elseif tType == TASK_TYPE then 
		self.dailyselect:SetActive(false)
		self.taskselect:SetActive(true)
	end 
end

-- 打开对应模块
function taskView:openModule(type)
	local superID = nil
	if (type == DAILY_TYPE) then 
		superID = 219  -- 每日
	elseif type == TASK_TYPE then 
		superID = 235
	else 
		print("未知的任务类型")
	end
    local linkData = Tool.readSuperLinkById( superID)
    --超链接的等级限制
    if linkData == nil then
        MessageMrg.show(TextMap.GetValue("Text_1_10") .. superID)
        return false
    else
        local moduleName = linkData.arg[0] --模块名
        local canGo = true
        local unlockType = linkData.unlock[0].type --解锁条件
        if unlockType ~= nil then
            --解锁条件
            local level = linkData.unlock[0].arg
            local vipLV = linkData.vipLevel
            --等级方式节解锁
            if unlockType == "level" then
                if Player.Info.level < level or Player.Info.vip < linkData.vipLevel then
                    MessageMrg.show(string.gsub(TextMap.TXT_OPEN_MODULE_BY_LEVEL, "{0}", level))
                    return false
                end
            end
        else --没有解锁条件
			MessageMrg.show(TextMap.GetValue("Text_1_11"))
			return false
        end

        local counts = linkData.arg.Count
        local args = {}
        if counts > 1 then
            for i = 1, counts - 1 do
                args[i] = linkData.arg[i]
            end
        end
        linkData = nil
        taskView:open(type, args)
		return true
    end
end

function taskView:open(type, arg)
    arg = arg or {}
	arg.delegate = self
    local uluabing = nil
	if type == DAILY_TYPE then 
		self.v_quest_main.gameObject:SetActive(true)
		self.v_moduleTask.gameObject:SetActive(false)
		uluabing = self.v_quest_main
	elseif type == TASK_TYPE then
		self.v_quest_main.gameObject:SetActive(false)
		self.v_moduleTask.gameObject:SetActive(true)
		uluabing = self.v_moduleTask
	end
	if uluabing ~= nil then 
		uluabing:CallUpdate(arg)
	end
	
    return uluabing
end

return taskView