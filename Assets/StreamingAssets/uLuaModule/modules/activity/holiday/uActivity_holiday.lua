local m = {} 
local time_id=0

function m:create()
    return self
end

function m:OnDestroy()
	Player:removeListener("vipMenucurrency")
end

function m:Start()
    LuaMain:ShowTopMenu(6,nil,{[1]={ type="crystal"},[2]={ type="c_gold"},[3]={ type="money"},[4]={ type="gold"}})
    self._title=Tool.loadTopTitle(self.gameObject, TextMap.GetValue("Text_1_154"),function ()
        LuaMain:ShowTopMenu(1)
        Api:checkUpdate(function()end)
        UIMrg:pop()
    end)
end

function m:onEnter()
     LuaMain:ShowTopMenu(6,nil,{[1]={ type="crystal"},[2]={ type="c_gold"},[3]={ type="money"},[4]={ type="gold"}})
end

function m:update(data)
    if data then
        self.__curActId = data[1]
        self._type = data[2]
    else
        self.__curActId = nil
        self._type = nil
    end
    self.selectIndex=1
    self.curr_tap_index=0
    self.curr_task_index=1
    self.currentSelect=nil
    m:getActivityData()
end

function m:getActivityData(...)
    self.list = {}
    Api:getActivity("",self._type, function(result)
        self:ApiReqActivityandFuli(result)
        activityinfo_resp=result
        end, function(...) 
        LuaMain:ShowTopMenu(1)
        UIMrg:pop()
        return false
        end)
end

function m:refreshActivityData( ... )
     Api:getActivity("",self._type, function(result)
            m:refreshData(result,false)
            self:onEnter()
        end)
end

function m:refreshDataWhenVip( ... )
    Player.Resource:addListener("vipMenucurrency", "vip_exp", function(key, attr, newValue)
        print("refresh")
        self:refreshActivityData()
        Player:removeListener("vipMenucurrency")
    end)
end

function m:ApiReqActivityandFuli(result)
    m:refreshData(result,true)
    self.binding:CallManyFrame(function()
        self.canSelect=true
        Events.Brocast('SelectActCallBack_grade', self.selectIndex-1)
    end, 5)
    --self:showActivity(nil, result.ids[self._findIndex].act_id)  
end

function m:refreshData(result,_bool)
    if result.ids == nil then 
        return
    end
    self.data=nil 
    local count = result.ids.Count
    if count == 0 then 
        MessageMrg.show(TextMap.GetValue("Text1647")) 
        LuaMain:ShowTopMenu(1)
        UIMrg:pop() 
        return 
    end
    
    self.rp ={}
    if result.infos~=nil then
        local infos_drop = json.decode(result.infos:toString())
        table.foreach(infos_drop, function(i, v)
        	if v.event == "holiday" then 
        		self.data=v
        	end 
        end)
    end 
    if self.data~=nil then
    	self.list = {}
    	local index = 1
    	local find = true
    	--print_t(self.data.data)
    	table.foreach(self.data.data, function(i, v)
    		--print_t(v)
    		local info = {}
    		local red_state = false
    		local status = self.data.status[i] or {}
    		table.foreach(status, function(h, j)
    			table.foreach(j, function(m, n)
    				local drop = n.drop or 0 
    				if red_state==false and drop ==1 then 
    					red_state=true 
    				end 
    			end)
    		end)
    		self.rp[tonumber(i)] = red_state
    		if index==1 then 
    			info.is_selected = false
    		else 
    			info.is_selected = true
    		end 
            info.id = tonumber(i)
            info.title = v. name
            info.content=v
            info.delegate = self
            table.insert(self.list, info)
            index=index+1
            info = nil
    	end)
    	table.sort(self.list,function(a,b)
    		return a.id < b.id 
    	end)
    	for i,v in ipairs(self.list) do
    		if _bool and find then 
                local y = os.date('%Y', tonumber(Player.Info.create)/1000)
                local m = os.date('%m', tonumber(Player.Info.create)/1000)
                local d = os.date('%d', tonumber(Player.Info.create)/1000)
                local time = os.time({day=d, month=m, year=y, hour=0, minute=0, second=0}) *1000 
                local stage_startTime= v.content.stage_startTime
                local stage_endTime= v.content.stage_endTime
                if tonumber(v.content.stage_startTime) <1000 then 
                    stage_startTime=time +tonumber(v.content.stage_startTime)*24*60*60*1000
                end
                if tonumber(v.content.stage_endTime) <1000 then 
                    stage_endTime=time +tonumber(v.content.stage_endTime)*24*60*60*1000
                end 
    			if v.content.stage_startTime~=nil and tonumber(stage_startTime)/1000<= os.time() and v.content.stage_endTime ~=nil and tonumber(stage_endTime)/1000>=os.time() then 
    				find=false
    				self.selectIndex=i
    			end 
    		end 
    	end
    	if _bool then 
	    	self.leftScroll_View:refresh(self.list, self, true, 0)
	        self.binding:CallAfterTime(0.1,function()
                if self.selectIndex<7 then 
                    self.leftScroll_View:goToIndex(0)
                else 
                    self.leftScroll_View:goToIndex(self.selectIndex)
                end 
	        end) 
	    else 
	    	Events.Brocast("update_item_redPoint")
	    end 
    end 
    m:setRightTypeValue()  
    self.title:SetActive(true)
    m:refreshHeroModelAndTitle()
    m:setRightTime()
    if result.act_type ~= nil then
        self._type = result.act_type
    end 
end

function m:updateRightTableData( taskList,delegate)
	self.right_scrollview:refresh(taskList, delegate, true, 0)
	self.binding:CallAfterTime(0.1,function()
		self.right_scrollview:goToIndex(0)
		end) 
end

function m:showActivity(selected, id, go)
	self.curr_tap_index=0
    if self.currentSelect ~= nil then
        self.list[self.selectIndex].is_selected = false
        self.currentSelect.data.is_selected=false
        self.currentSelect:showSelect(false)
    end
    if selected ~= nil then
        self.currentSelect = selected
        self.selectIndex = self.currentSelect.id
        self.list[self.selectIndex].is_selected = true
        self.currentSelect.data.is_selected=true
        self.currentSelect:showSelect(true)
    end
    m:setRightTypeValue()  
    m:setRightTime()
end

function m:refreshHeroModelAndTitle()
    local bg_icon = self.data.bg_icon
    if self.title~=nil then
        if bg_icon~=nil and bg_icon~= "" then
            self.title:SetActive(true)
            self.title_pic.Url=UrlManager.GetImagesPath("sl_activity/" .. bg_icon .. ".png")
        else 
            self.title:SetActive(false)
        end  
        
    end
    local path = UrlManager.GetImagesPath("sl_activity/activity_tip/" .. self.data.title .. ".png")
    if self.tip ~= nil then 
        self.tip.Url=path
    end
    if self.hero~=nil then 
        local id = 0
        if self.data.title~=nil then 
            id =tonumber(self.data.title)
        end
        local row
        if id~=nil and id>0 and id <1000 then 
            row = TableReader:TableRowByID("char", id)
        end
        if row~=nil then 
            self.hero.gameObject:SetActive(true)
            self.hero:LoadByModelId(id, "idle", function() end, false, 0, 1)
        else 
            self.hero.gameObject:SetActive(false)
        end 
    else 
        self.hero.gameObject:SetActive(false)
    end
    if self.Content~=nil then 
        self.Content.gameObject:SetActive(true)
        self.Content.text = self.data.desc
        if self.data.desc=="" or self.data.desc==" " then 
            self.Content.gameObject:SetActive(false)
        end 
    end 
end

function m:setRightTime()
	local data = self.data.data["" .. self.list[self.selectIndex].id]
	if self.time ~=nil and (data.stage_startTime~=nil or data.stage_endTime~=nil) then    
        local timeTxt = ""
        local y = os.date('%Y', tonumber(Player.Info.create)/1000)
        local m = os.date('%m', tonumber(Player.Info.create)/1000)
        local d = os.date('%d', tonumber(Player.Info.create)/1000)
        local time = os.time({day=d, month=m, year=y, hour=0, minute=0, second=0}) *1000 
        if data.stage_startTime~=nil then 
            local stage_startTime=data.stage_startTime
            if tonumber(data.stage_startTime) <1000 then 
                stage_startTime=time +tonumber(data.stage_startTime)*24*60*60*1000
            end 
            local start_time =Tool.getFormatTime(tonumber(stage_startTime) / 1000)
            timeTxt=TextMap.GetValue("Text_1_119") .. start_time .. "[-]"
            if data.stage_endTime~=nil then
                local stage_endTime=data.stage_endTime
                if tonumber(data.stage_endTime) <1000 then 
                    stage_endTime=time+tonumber(data.stage_endTime)*24*60*60*1000
                end 
                local end_time = Tool.getFormatTime(tonumber(stage_endTime) / 1000)
                timeTxt =timeTxt .. TextMap.GetValue("Text_1_120") .. end_time .. "[-]"
            end
        else 
            if data.stage_endTime~=nil then 
                local stage_endTime=data.stage_endTime
                if tonumber(data.stage_endTime) <1000 then 
                    stage_endTime=time+tonumber(data.stage_endTime)*24*60*60*1000
                end 
                local end_time = Tool.getFormatTime(tonumber(stage_endTime) / 1000)
                timeTxt =TextMap.GetValue("Text_1_121") .. end_time .. "[-]"
            end
        end
        self.time.gameObject:SetActive(true)
        self.time.text=timeTxt
        if data.stage_startTime~=nil and tonumber(data.stage_startTime) / 1000 > os.time() then 
            LuaTimer.Delete(time_id)
            self.time1.text=TextMap.GetValue("Text_1_155")
        elseif data.stage_endTime~=nil and tonumber(data.stage_endTime) / 1000 < os.time() then 
            LuaTimer.Delete(time_id)
            self.time1.text=TextMap.GetValue("Text_1_156")
        elseif data.stage_endTime~=nil and tonumber(data.stage_endTime) / 1000 > os.time() then 
            LuaTimer.Delete(time_id)
            time_id = LuaTimer.Add(0, 60000, function(id)
                local time  =Tool.FormatTime4(tonumber(data.stage_endTime) / 1000 - os.time()) 
                self.time1.text=TextMap.GetValue("Text_1_157") .. time 
                end)
        else 
            LuaTimer.Delete(time_id)
            self.time1.text=""
        end 
    else 
        self.time.text=""
        LuaTimer.Delete(time_id)
        self.time1.text=""
    end
end

function m:OnDestroy()
    LuaTimer.Delete(time_id)
end

function m:setRightTypeValue()
	local btnCon = {}
	local data = self.data.data["" .. self.list[self.selectIndex].id] or {}
	local status = self.data.status["" .. self.list[self.selectIndex].id] or {}
	--print_t(data)
	table.foreach(data, function(i, v)
		if type(v)~="string" and type(v) ~="number" and v ~=nil and v.tabName~=nil then 
			local temp = {}
			temp.title = v.tabName or ""
			temp.taskList = {}
			temp.index = i
			local _status=status[i] or {}
			local taskList= {}
			local _taskList= {}
			table.foreach(v, function(m, n)
				if type(n)~="string" and type(n) ~="number" and n ~=nil then 
					local task = {}
					task=n
					task.index=m
					task.status=_status[m] or {}
					task.delegate=self
					if task.status.drop~=nil and task.status.drop==1 then 
						table.insert(taskList, task)
					else 
						table.insert(_taskList, task)
					end 
				end
			end)
			table.sort(taskList, function (a,b)
				return tonumber(a.index) < tonumber(b.index) 
			end)
			table.sort(_taskList, function (a,b)
				return tonumber(a.index) < tonumber(b.index) 
			end)
			for i,v in ipairs(_taskList) do
				table.insert(taskList, v)
			end 
			temp.taskList=taskList
			temp.delegate = self
			table.insert(btnCon, temp)
		end 
	end)
	table.sort(btnCon, function (a,b)
		return tonumber(a.index)< tonumber(b.index)
	end )
	self.BtnAreaGrid:refresh(self.btn1.gameObject, btnCon, self)
end

function m:exchange_two(data)
	if self.Panel_Duihuan ~= nil then
		self.Panel_Duihuan.gameObject:SetActive(true)
		table.insert(data, self)
		self.Panel_Duihuan:CallUpdate(data)
	end
end

return m