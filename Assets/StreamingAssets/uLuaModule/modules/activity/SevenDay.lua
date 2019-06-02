local SevenDay = {} 
local timerId = 0

local sdData = {}
local leftDayList = { [1] = TextMap.GetValue("Text_1_67"), [2] = TextMap.GetValue("Text_1_68"), [3] = TextMap.GetValue("Text_1_69"),
					  [4] = TextMap.GetValue("Text_1_70"), [5] = TextMap.GetValue("Text_1_71"), [6] = TextMap.GetValue("Text_1_72"),
					  [7] = TextMap.GetValue("Text_1_73"), [8] = TextMap.GetValue("Text_1_74"), [9] = TextMap.GetValue("Text_1_75"),
					  [10] = TextMap.GetValue("Text_1_76"), [11] = TextMap.GetValue("Text_1_77"), [12] = TextMap.GetValue("Text_1_78"),
					  [13] = TextMap.GetValue("Text_1_79"), [14] = TextMap.GetValue("Text_1_80"), [15] = TextMap.GetValue("Text_1_81")}

function SevenDay:update(data)
	self.Panel_Duihuan.gameObject:SetActive(false)
	--需要从这里开始分类为四项，从而传递不同的参数，获取不同的列表
	self.title_day7:SetActive(false)
	self.title_day14:SetActive(false)
	self.title_offyear:SetActive(false)
	self.title_SpringFestival:SetActive(false)
	self.title_yuanxiaojie:SetActive(false)
	LuaTimer.Delete(timerId)
	if data.type == "day7" then
		sdData = Tool:LoadSevenDayData("day7")
		self.actType = "day7"
		self.leftStep = 1
		self.title_day7:SetActive(true)
		Tool.loadTopTitle(self.gameObject, TextMap.GetValue("Text_1_82"))
		SevenDay:refreshTime(Player.Day7s.ref_times)
	elseif data.type == "Day14s" then
		sdData = Tool:LoadSevenDayData("Day14s")
		self.actType = "Day14s"
		self.leftStep = 1
		self.title_day14:SetActive(true)
		Tool.loadTopTitle(self.gameObject, TextMap.GetValue("Text_1_83"))
		SevenDay:refreshTime(Player.DayNs.ref_time)
	elseif data.type == "offyear" then
		sdData = Tool:LoadSevenDayData("offyear")
		self.actType = "offyear"
		self.leftStep = 1
		self.title_offyear:SetActive(true)
		Tool.loadTopTitle(self.gameObject, TextMap.GetValue("Text_1_84"))
		SevenDay:refreshTime(Player.DayNs.ref_time)
	elseif data.type == "SpringFestival" then
		sdData = Tool:LoadSevenDayData("SpringFestival")
		self.actType = "SpringFestival"
		self.leftStep = 1
		self.title_SpringFestival:SetActive(true)
		Tool.loadTopTitle(self.gameObject, TextMap.GetValue("Text_1_85"))
		SevenDay:refreshTime(Player.DayNs.ref_time)
	elseif data.type == "yuanxiaojie" then
		sdData = Tool:LoadSevenDayData("yuanxiaojie")
		self.actType = "yuanxiaojie"
		self.leftStep = 1
		self.title_yuanxiaojie:SetActive(true)
		Tool.loadTopTitle(self.gameObject, TextMap.GetValue("Text_1_86"))
		SevenDay:refreshTime(Player.DayNs.ref_time)
	end
	self.Data = sdData
	SevenDay:setLeftDayData()
	--SevenDay:setRightTypeValue()
	SevenDay:DayChoiseCb(self.leftStep)
	self.leftScroll_View:ResetPosition()
	SevenDay:ActiTimeRefresh(data.type)
	SevenDay:SetModelId()
end

--刷新每一天的功能刷新，到达时间后会开启对应天数的tab页
function SevenDay:refreshTime(refTime)
	--print_t(Player.Day7s.ref_times)
	-- if Player.Day7s.day + 1 < 8 then
	--  	for k, v in pairs(Player.Day7s.ref_times:getLuaTable()) do
	--  		if v == sdData[Player.Day7s.day + 1][1][1].id then
					self.refreshDayTime = refTime--Player.DayNs.ref_time
	  				SevenDay:timeset()
	--  			return
	--  		end
	--  	end
	-- end
end

function SevenDay:showMsg(drop)
    local list = RewardMrg.getList(drop)
    --local ms = {}
    local isShowTp = 0
    table.foreach(list, function(i, v)
        -- local g = {}
        -- g.type = v:getType()
        if isShowTp == 0 and v.Table.use_type ~= nil then
        	isShowTp = v.Table.use_type
        end
        -- g.icon = "resource_fantuan"
        -- g.text = v.rwCount
        -- g.goodsname = v.name
        -- print(g.goodsname)
        -- table.insert(ms, g)
        -- g = nil
    end)
		packTool:showMsg(drop, nil, isShowTp)
	--	OperateAlert.getInstance:showGetGoods(ms, self.ShowObj.gameObject)
end

function SevenDay:openDuiFrom(data)
	if self.Panel_Duihuan ~= nil then
		self.Panel_Duihuan.gameObject:SetActive(true)
		table.insert(data, self)
		self.Panel_Duihuan:CallUpdate(data)
	end
end

--倒计时
function SevenDay:timeset()
	LuaTimer.Delete(timerId)
    timerId = LuaTimer.Add(0, 1000, function(id)
        local tab = os.date("*t", self.refreshDayTime / 1000)
        local now = os.date("*t")
        --print(tab.day.." : "..tab.hour.." : "..tab.min.." ："..now.day.." : "..now.hour.." : "..now.min)
        if (tab.day <= now.day and Tool:isRefreSevenDay()) or 
        	(tab.hour == now.hour and tab.min == now.min and tab.sec == now.sec) then
            SevenDay:refreshFrom()
        end
    end)
end

function SevenDay:refreshFrom()
	Api:checkUpdate(function()end)
	    self.binding:CallAfterTime(0.5, function()
	        SevenDay:setLeftDayData()
	             	SevenDay:DayChoiseCb(1)
	             	if self.actType == "day7"then
						SevenDay:DayChoiseCb(1)
						if Player.Day7s.day > 6 then
							LuaTimer.Delete(timerId)
						else
		         	    	SevenDay:refreshTime(Player.Day7s.ref_times)
		         	    end
					elseif self.actType == "Day14s" or self.actType == "offyear" or self.actType == "SpringFestival" or self.actType=="yuanxiaojie" then
						SevenDay:DayChoiseCb(1)
						if Player.DayNs[self.actType].day > 6 then
							LuaTimer.Delete(timerId)
						else
		         	    	SevenDay:refreshTime(Player.DayNs.ref_time)
		         	    end
					end
	     	end)
end

--活动上方的截止时间
function SevenDay:ActiTimeRefresh(actType)
	self.timeValue.gameObject:SetActive(false)
	local time
	-- if Player.Day7s.time ~= nil then
	-- 	self.timeValue.gameObject:SetActive(true)
	-- end
	if actType == "day7" then
		self.timeValue.gameObject:SetActive(true)
		if Player.Day7s.day >= 7 then
			self.timeTitle.text = TextMap.GetValue("Text_1_87")
		else
			self.timeTitle.text = TextMap.GetValue("Text_1_88")
		end
		time = Tool.getFormatTime(tonumber(Player.Day7s.time) / 1000)
	else
		self.timeValue.gameObject:SetActive(true)
		self.timeTitle.text = TextMap.GetValue("Text_1_88")
		time = Tool.getFormatTime(tonumber(Player.DayNs[actType].endTime / 1000))
		--print(actType)
		--print("截止时间:"..Player.DayNs[actType].endTime)
		if Player.DayNs[actType].endTime == 0 then
			time = ""
		end
	end
    self.timeValue.text = time
end

--设置右边的四个类型按钮
function SevenDay:setRightTypeValue()
	local btnCon = {}
	for i = 1, 5 do
		if sdData[self.leftStep] ~= nil and sdData[self.leftStep][i] ~= nil then
			local data = {}
			data.title = sdData[self.leftStep][i][1].tab_name
			data.dayNum = sdData[self.leftStep][i][1].day_num
			data.taskList = {}
			data.index = sdData[self.leftStep][i][1].tab_id
			for j = 1, #sdData[self.leftStep][i] do
				table.insert(data.taskList, sdData[self.leftStep][i][j].id)
			end
			data.delegate = self
			table.insert(btnCon, data)
		end
	end
	self.BtnAreaGrid:refresh(self.btn1.gameObject, btnCon, self)

end

--选中左边日期
function SevenDay:DayChoiseCb(step)
	self.leftStep = step
	SevenDay:TypeChoiseCb(1)
	SevenDay:setRightTypeValue()
	SevenDay:SetModelId()
end

--设置模型id
function SevenDay:SetModelId()
	local modelData = {}
	if self.actType == "day7" then
		modelData = TableReader:TableRowByUnique("day7_setting", "id", "model_day"..self.leftStep)
	elseif self.actType == "Day14s" then
		modelData = TableReader:TableRowByUnique("day14_setting", "id", "model_day"..self.leftStep)
	elseif self.actType == "offyear" then
		modelData = TableReader:TableRowByUnique("offyear_setting", "id", "model_day"..self.leftStep)
	elseif self.actType == "SpringFestival" then
		modelData = TableReader:TableRowByUnique("SpringFestival_setting", "id", "model_day"..self.leftStep)
	elseif self.actType == "yuanxiaojie" then
		modelData = TableReader:TableRowByUnique("yuanxiaojie_setting", "id", "model_day"..self.leftStep)
	end
	if modelData ~= nil then
		local modelTab = TableReader:TableRowByID("avter", modelData.value1)
		if modelTab ~= nil then
			self.hero:LoadByModelId(modelData.value1, "idle", function() end, false, 0, 1, 255, 0)
		else
			self.hero:LoadByModelId(12, "idle", function() end, false, 0, 1, 255, 0)
		end
	else
		self.hero:LoadByModelId(12, "idle", function() end, false, 0, 1, 255, 0)
	end
end

--选中右边类型
function SevenDay:TypeChoiseCb(step)
	if step ~= nil then 
		self.rightStep = step
	end
	if self.rightStep == 4 then
		self.WidOne.gameObject:SetActive(false)
		self.WidTwo.gameObject:SetActive(true)
		self.WidThree.gameObject:SetActive(false)
	elseif self.rightStep == 3 and self.actType ~= "day7" then
		self.WidOne.gameObject:SetActive(false)
		self.WidTwo.gameObject:SetActive(false)
		self.WidThree.gameObject:SetActive(true)
	else
		self.WidOne.gameObject:SetActive(true)
		self.WidTwo.gameObject:SetActive(false)
		self.WidThree.gameObject:SetActive(false)
	end
		SevenDay:showOneTypeList()
end

--显示右边的类型详情列表
function SevenDay:showOneTypeList()
	if sdData[self.leftStep] ~= nil and sdData[self.leftStep][self.rightStep] ~= nil then
		local list = {}
		if self.rightStep == 4 then
			list.info = sdData[self.leftStep][self.rightStep]
			list.delegate = self
			self.WidTwo:CallUpdate(list)
		elseif self.rightStep == 3 and self.actType ~= "day7" then
			for i = 1, #sdData[self.leftStep][self.rightStep] do
				local data = {}
				data.info = sdData[self.leftStep][self.rightStep][i]
				data.delegate = self
				table.insert(list, data)
			end

			if self.actType == "day7" then
				if self.leftStep <= Player.Day7s.day then
					list = SevenDay:sortItemList(list, Player.Day7s)
				end
			else
				if self.leftStep <= Player.DayNs[self.actType].day then
					list = SevenDay:sortItemList(list, Player.DayNs[self.actType])
				end
			end
			self.WidThreeGrid:refresh(self.ItemThree, list)
			if self.isScroll then
				self.ScrollViewThree:ResetPosition()
			end
		else
			for i = 1, #sdData[self.leftStep][self.rightStep] do
				local data = {}
				data.info = sdData[self.leftStep][self.rightStep][i]
				data.delegate = self
				table.insert(list, data)
			end

			if self.actType == "day7" then
				if self.leftStep <= Player.Day7s.day then
					list = SevenDay:sortItemList(list, Player.Day7s)
				end
			else
				if self.leftStep <= Player.DayNs[self.actType].day then
					list = SevenDay:sortItemList(list, Player.DayNs[self.actType])
				end
			end
			
			self.WidOneGrid:refresh(self.ItemOne, list)
			if self.isScroll then
				self.ScrollViewOne:ResetPosition()
			end
		end
	elseif sdData[self.leftStep] == nil then
		self.WidOne.gameObject:SetActive(false)
		self.WidTwo.gameObject:SetActive(false)
		self.WidThree.gameObject:SetActive(false)
	end
end

--排序，登录福利的第一，充值的第二，其他的排在后面
function SevenDay:sortItemList(list, PlayactTypeList)
	local afterList = {}
    local count = 1
    local count1 = #list
	for i = 1, #list do
		local it = list[i]
		if it.info.type == "daily_fuli" then
			table.insert(afterList, 1, it)
            count = count + 1
		elseif it.info.type == "chongzhi" then
			table.insert(afterList, count, it)
            count = count + 1
        else
        	table.insert(afterList, it)
		end
	end

	return SevenDay:sorItemTwo(afterList, PlayactTypeList)
end

--对忍务的完成情况进行排序，可以领取的第一，未完成第二，已领取的最后
function SevenDay:sorItemTwo(list, PlayactTypeList)
	local afterList = {}
    local count = 1
    local count1 = #list
	for i = #list, 1, -1 do
		local it = list[i]
		if PlayactTypeList[it.info.id].state == 2 then
			table.insert(afterList, 1, it)
            count = count + 1
        elseif PlayactTypeList[it.info.id].state == 3 then
        	table.insert(afterList, count1, it)
            count1 = count1 - 1
        else
        	table.insert(afterList, count, it)
		end
	end
	return afterList
end

function SevenDay:onExit()
    LuaTimer.Delete(timerId)
end

function SevenDay:onEnter()
    LuaMain:ShowTopMenu()
    --SevenDay:setLeftDayData()
    --SevenDay:DayChoiseCb(self.leftStep)
    self.isScroll = false
    SevenDay:TypeChoiseCb(self.rightStep)
    Events.Brocast("UpdateRedPoint")
    if self.actType == "day7" then
    	SevenDay:refreshTime(Player.Day7s.ref_times)
    else
    	SevenDay:refreshTime(Player.DayNs.ref_time)
	end
end

function SevenDay:OnDestroy()
    LuaTimer.Delete(timerId)
end

function SevenDay:setLeftDayData()
	local day = {}

	for i = 1, #leftDayList do
		if sdData[tonumber(i)] ~= nil then
			local data = {}
			if self.actType == "Day14s" then
				data.title = leftDayList[i + 7]
			else
				data.title = leftDayList[i]
			end
			data.delegate = self
			data.index = i
			-- --这里需要增加判断是否7天还是14天，改变type的值
			-- if self.actType = "day7" or self.actType = "offyear" or self.actType = "SpringFestival" then
			-- 	data.actType = 1
			-- elseif self.actType = "day14" then
			-- 	data.actIndex = 8
			-- end
			table.insert(day, data)
		end 
	end
	self.leftGrid:refresh(self.FirD.gameObject, day, self)
end

--开始
function SevenDay:Start()
    self.isScroll = true
    LuaMain:ShowTopMenu()
	Api:checkUpdate(function()end)
	self.rightStep = 1
end

return SevenDay