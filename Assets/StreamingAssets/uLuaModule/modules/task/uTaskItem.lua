local taskITem = {}

function taskITem:create(binding)
    self.binding = binding
    return self
end

function taskITem:update(_table, index)
    self.taskID = _table.id
    self.taskInfo = _table.taskInfo
    self.delegate = _table.delegate
    self.drop = _table.drop
    self.dropTypeList = {}
    for i = 1, #_table.drop do
        table.insert(self.dropTypeList, _table.drop[i].type)
    end
    self.task_type = _table.type
    -- self.rewardCollider.gameObject:SetActive(false)
    self.binding:Hide("hasReward")
    if self.effect ~= nil then
        self.effect.gameObject:SetActive(false)
    end
    local desc = "" --任务描述
    local taskName = "" --任务名称
    local icon = "" --任务图标
    local total = 0
    local progress = 0
    --self.isdoing:SetActive(false)
    --任务头像
    -- self.taskImg.Url = UrlManager.GetImagesPath('tasksImage/' .. row.icon .. ".png")
    --性能优化，在生成任务列表就是初始化好奖励信息，否则会无限解释奖励信息
    -- print("update"..table.getn(self.drop))
    -- print("")
    self.goTask.gameObject:SetActive(false)

    self.hasGet:SetActive(false)
    --    ClientTool.UpdateMyTable("Prefabs/moduleFabs/questModule/img_reward", self.rewardTable, _table.drop)
	 ClientTool.UpdateGrid("Prefabs/moduleFabs/questModule/img_reward", self.rewardTable, _table.drop)
    --if self.rewardTable.gameObject.activeInHierarchy then
    --    self.rewardTable:refresh("Prefabs/moduleFabs/questModule/img_reward", _table.drop)
    --end
    if self.task_type == "gm" then
        desc = self.taskInfo.gmDesc.target_desc
        taskName = self.taskInfo.gmDesc.show_name
        --  print(" self.taskInfo.gmDesc.icon" .. self.taskInfo.gmDesc.icon)
        icon = self.taskInfo.gmDesc.icon
        self.task_type = "grow"
        --  self.taskImg.Url = UrlManager.GetImagesPath('tasksImage/' .. row.icon .. ".png")
    else
        --通过id读表
        self.row = TableReader:TableRowByID('allTasks', self.taskID)
        icon = self.row.icon
        --  self.taskImg.Url = UrlManager.GetImagesPath('tasksImage/' .. row.icon .. ".png")
        desc = self.row.target_desc
        taskName = self.row.show_name
    end
	--self.focus:SetActive(false)
	--self.nofocus:SetActive(true)
    --该任务在完成中
    if self.taskInfo.state == 0 then
        if self.task_type == "daily" then
            self.goTask.gameObject:SetActive(false)
			self.btn_go.gameObject:SetActive(true)
            --self.taskTxt.text = TextMap.GetValue("Text350")
            self.goID = self.row.jump
        else
            --self.isdoing:SetActive(true)
            self.goTask.gameObject:SetActive(false)
			self.btn_go.gameObject:SetActive(false)
        end --任务完成进度   
        --跳转的id
    elseif self.taskInfo.state == 2 then --已完成未领取  
		--self.focus:SetActive(true)
		--self.nofocus:SetActive(false)
    --不显示进度
    --如果是月卡就显示剩余天数
    if self.taskID .. "" == "31" then --如果是月卡显示剩余天数
    self.goTask.gameObject:SetActive(false)
    elseif self.taskID .. "" == "32" then --如果是半年卡显示剩余天数
    self.goTask.gameObject:SetActive(false)
    elseif self.taskID .. "" == "33" then --如果是年卡显示剩余天数
    self.goTask.gameObject:SetActive(false)
    else
		self.btn_go.gameObject:SetActive(false)
        self.goTask.gameObject:SetActive(true)
        self.taskTxt.text = TextMap.GetValue("Text376")
        --self.rewardCollider.gameObject:SetActive(true)

        self:checkEffect(self.taskTxt.text)
    end
    elseif self.taskInfo.state == 3 then
        self.goTask.gameObject:SetActive(false)
		self.btn_go.gameObject:SetActive(false)
        self.hasGet:SetActive(true)
    end
    local complete = self.taskInfo.complete:getLuaTable()
    for type, value in pairs(complete) do
        total = value.total
        progress = value.progress
    end
    if total ~= 0 then
        if progress >= total then
            progress = total
        end
		if progress == total then 
			self.progress.text = TextMap.GetValue("Text_1_12") .. progress .. "/" .. total 
		else 
			self.progress.text = TextMap.GetValue("Text_1_13") .. progress .. "/" .. total
		end 
		self.txt_jifen.text = TextMap.GetValue("Text_1_2805") .. self.row.active_point
    else
        self.progress.text = ""
		self.txt_jifen.text = ""
    end
    self.txtTaskDes.text = "[ffff96]" .. desc .. "[-]"
    --self.txtTaskName.text = taskName
    self.taskImg.Url = UrlManager.GetImagesPath('tasksImage/' .. icon .. ".png")
    --  print("task ".. taskName.." drop "..table.getn(self.drop))
end

function taskITem:checkEffect(str)
    --print("str" .. str)
    if self.effect == nil then
        --print("show ")
        self.effect = Tool.LoadButtonEffect(self.goTask.gameObject)
        self.effect:SetActive(true)
    else
        --print("check")
        --self.effect.gameObject:SetActive(true)
        self.effect:SetActive(str == TextMap.GetValue("Text376"))
    end
end

function taskITem:onClick(go, btName)
    if btName == "goTask" then
        if self.taskInfo.state == 0 then
            local obj = Tool.readSuperLinkById( self.goID)
            uSuperLink.openModule(self.goID)
        elseif self.taskInfo.state == 2 then
            if Tool:judgeBagCount(self.dropTypeList) == false then return end
            self:getReward()
        end
        -- elseif btName == "rewardCollider" then
        --     self:getReward()
	elseif btName == "btn_go" then 
        if self.taskInfo.state == 0 then
            local obj = Tool.readSuperLinkById( self.goID)
            uSuperLink.openModule(self.goID)	
		end
    end
end

function taskITem:hasRewardItween(...)
    self.goTask.gameObject:SetActive(false)
	self.btn_go.gameObject:SetActive(false)
    --  self.rewardCollider.gameObject:SetActive(false)

    self.hasReward:ResetToBeginning()
    self.hasReward.enabled = true
    self.binding:Show("hasReward")
    self.binding:CallAfterTime(1, function()
        --        self.binding.gameObject:SetActive(false)
        --    SendBatching.DestroyGameOject(self.binding.gameObject)
        self.delegate:refresh(self.task_type, true)
    end)
end

function taskITem:getReward()
    -- local info = {}
    -- info.drop = self.drop
    -- info.delegate = self
    -- info.id = self.taskID
    -- UIMrg:pushWindow("Prefabs/moduleFabs/questModule/finish_reward", info)
    -- info = nil
    DialogMrg.updateBp()
    Api:submitTask(self.taskID, function(result)
        print("领取成功")
        DialogMrg.levelUp()
        --       print("drop "..table.getn(self.drop))
        --      print(self.drop)
        self.delegate:showMsg(result, self.task_type)
		packTool:showMsg(result, nil, 2)
		self.delegate:onUpdate()
		Events.Brocast("updateTaskRedPoint")
        --self:hasRewardItween()
    end)
end

function taskITem:Start()
    --self.progress.overflowMethod = UILabel.Overflow.ResizeFreely
    --self.progress.pivot = UIWidget.Pivot.Left
    --self.progress.transform.localPosition = Vector3(-265, -18, 0)
end


return taskITem