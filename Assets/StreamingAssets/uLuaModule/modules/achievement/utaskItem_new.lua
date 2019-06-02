local taskItem = {}

function taskItem:update(data, index, delegate)
    self.data = data
    self.taskInfo = data.taskInfo
    self.index = index
    self.redPoint:SetActive(false)
    self.delegate = data.delegate
    --self.initbg.spriteName = "task2"
    self.hasGet.gameObject:SetActive(false)
    self.id = data.id
    self.state = data.state
    self.drop = data.drop
    self.dropTypeList = {}
    for i = 1, #data.drop do
        table.insert(self.dropTypeList, data.drop[i].type)
    end
    self.data = data
    self.goID = 0
    --self.locked:SetActive(false)
	local icon = nil
	
	    --通过id读表
    self.row = TableReader:TableRowByID('allTasks', self.id)
    icon = self.row.icon
	
    if self.effect ~= nil then
        self.effect.gameObject:SetActive(false)
    end
    --print("data state "..data.state)
    self.progress.gameObject:SetActive(true)
    --self.lock:SetActive(false)
	--self.focus:SetActive(false)
	--self.nofocus:SetActive(true)
    if data.lock then
        if data.state == 2 then --已完成未领取
        --self.redPoint:SetActive(true)
        self.hasGet.gameObject:SetActive(false)
        self.btnGet.gameObject:SetActive(true)
        --self.locked:SetActive(false)
        self.statueLabel.text = TextMap.GetValue("Text376")
        self:checkEffect(self.statueLabel.text)
        self.drop = self:updateTable(self.drop, false)
		self.btn_go.gameObject:SetActive(false)
		--self.focus:SetActive(true)
		--self.nofocus:SetActive(false)
        --self.initbg.spriteName = "task2"
        elseif data.state == 3 then --已完成已领取
        --self.initbg.spriteName = "task1"
        self.hasGet.gameObject:SetActive(true)
        --self.locked:SetActive(false)
        self.btnGet.gameObject:SetActive(false)
        self.drop = self:updateTable(self.drop, true)
        self.progress.gameObject:SetActive(false)
		self.btn_go.gameObject:SetActive(false)
        elseif data.state == 0 then --进行中
        self.hasGet.gameObject:SetActive(false)
        self.btnGet.gameObject:SetActive(false)
		self.btn_go.gameObject:SetActive(true)
        --self.statueLabel.text = TextMap.GetValue("Text350")

        self.goID = data.taskInfo.jump
        --print("self goID "..self.goID)
        self.drop = self:updateTable(self.drop, false)
        end
    else --未解锁
    --self.lock:SetActive(true)
    --self.locked:SetActive(true)
    self.hasGet.gameObject:SetActive(false)
    self.btnGet.gameObject:SetActive(false)
    self.progress.gameObject:SetActive(false)
	self.btn_go.gameObject:SetActive(false)
    self.drop = self:updateTable(self.drop, false)
    --添加一个未解锁状态  self.locked:SetActive(false)
    end
    if data.progress > data.total then
        data.progress = data.total
    end
    --if data.progress == data.total then
    --self.progress.text = "[ffea01](已完成)[-]"
    --else
    -- if data.id == "zx024" then
    -- 	print("data id "..data.id)
    -- 	print("data desc "..data.taskInfo.target_desc)
    -- 	print(data.taskInfo.drop)
    -- end
	if data.progress == data.total then 
		self.progress.text = TextMap.GetValue("Text_1_12") .. data.progress .. "/" .. data.total .. "[-]"
	else 
		self.progress.text = TextMap.GetValue("Text_1_13") .. data.progress .. "/" .. data.total .. ""
    end
	--end
    self.txtTaskName.text = "[ffff96]" .. self.taskInfo.target_desc .. "[-]"
    --print("update ")
    --self.binding:CallManyFrame(function()
    --    self.rewardTable:refresh("Prefabs/moduleFabs/mailModule/mail_item_in", self.drop)
    --end, 2)
	
	ClientTool.UpdateGrid("Prefabs/moduleFabs/mailModule/mail_item_in", self.rewardTable, self.drop)
	--ClientTool.UpdateGrid("Prefabs/moduleFabs/questModule/img_reward", self.rewardTable, self.drop)
	self.taskImg.Url = UrlManager.GetImagesPath('tasksImage/' .. icon .. ".png")
end

function taskItem:checkEffect(str)
    if self.effect == nil then
        self.effect = Tool.LoadButtonEffect(self.btnGet.gameObject)
        self.effect.gameObject:SetActive(true)
    else
        self.effect.gameObject:SetActive(true)
        --self.effect:SetActive(str == TextMap.GetValue("Text376"))
    end
end

function taskItem:updateTable(drop, isGet)
    local m = {}
    table.foreach(drop, function(k, v)
        local l = {}
        l.v = v
        l.showName = true
        l.isGet = isGet
        l.isShowTips = true
        table.insert(m, l)
        l = nil
    end)
    return m -- body
end

function taskItem:callback(state)

    if state == 3 then --已完成已领取
    self.redPoint:SetActive(false)
    self.hasGet:SetActive(true)
    end
end

function taskItem:clickSelect(index)
    if self.index == index then
        --	print("self.index"..index)
        self.first = true
        self:showSelect(true)
        -- self.delegate.currentSelect = self
        -- self.delegate.currentID = self.index
    end
end


-- function taskItem:showSelect(isSelected)
--    -- print("isSelected"..self.isSelected)
--     if isSelected then
--     	print("show")
--         self.initbg.spriteName = "task2"
--     else
--         self.initbg.spriteName = "task1"
--     end
-- end

function taskItem:OnDestroy()
    --  Events.RemoveListener('SelecttaskCallBack')
end

function taskItem:getReward(...)
    local that = self
    Api:submitTask(self.id, function(result)
        self.btnGet.isEnabled = true
        DialogMrg.levelUp()
        self.redPoint:SetActive(false)
        -- self.delegate:updateRedPoint()
        self.progress.gameObject:SetActive(false)
		packTool:showMsg(result, nil,2)
		self.delegate:refreshData()
		Events.Brocast("updateTaskRedPoint")
        --local info = {}
        --info.title = "jingliicon"
        --info.drop = RewardMrg.getList(result) --self.drop
        --local charList = {}
        --table.foreach(info.drop, function(i, v)
        --    if v:getType() == "char" then
        --        table.insert(charList, v)
        --    end
        --end)
        --info.delegate = self
        --if #charList == 0 then
        --    UIMrg:pushWindow("Prefabs/moduleFabs/achievementModule/taskReward", info)
        --      --self.delegate:refresh()
        --    info = nil
        --else
        --    packTool:showChar(charList, function()
        --        self.binding:CallManyFrame(function()
        --            UIMrg:pushWindow("Prefabs/moduleFabs/achievementModule/taskReward", info)
        --            info = nil
        --        end, 2)
        --    end)
        --end
    end)
end

function taskItem:playAnimation()
    MusicManager.playByID(52)
    local drop = self:updateTable(self.data.drop, true)
    self:updateShowDrop(drop)
    self.btnGet.gameObject:SetActive(false)
    self.hasGet:ResetToBeginning()
    self.hasGet.enabled = true
    self.binding:Show("hasGet")
    self.binding:CallAfterTime(1, function()
        print("has refresh")
        --        self.binding.gameObject:SetActive(false)
        --    SendBatching.DestroyGameOject(self.binding.gameObject)
        		--更新
		self.delegate:refreshData()
    end)
end

function taskItem:updateShowDrop(drop)
    --self.binding:CallManyFrame(function()
    print("updateShowDrop ")
    print(drop)
    self.rewardTable:refresh("Prefabs/moduleFabs/mailModule/mail_item_in", drop)
    --   end,1)
end


function taskItem:Start(...)
    -- Events.AddListener("SelecttaskCallBack", funcs.handler(self, taskItem.clickSelect))
end

function taskItem:onClick(go, name)
	if name == "btn_go" then 
		if	self.state == 0 then
			local obj = Tool.readSuperLinkById( self.goID)
			uSuperLink.openModule(self.goID)
		end		
	elseif name == "btnGet" then 
		if self.state == 2 then
			if Tool:judgeBagCount(self.dropTypeList) == false then return end
            self.btnGet.isEnabled = false 
			self:getReward()
		elseif self.state == 0 then
			local obj = Tool.readSuperLinkById( self.goID)
			uSuperLink.openModule(self.goID)
		end		
	end 
    --self.delegate:getDetailInfo(self.data, self, self.index)
end

return taskItem