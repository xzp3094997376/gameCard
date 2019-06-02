local m = {}
local State1 = 1 --挑战
local State2 = 2 --可选人
local State3 = 3 --已选人
local State4 = 4 --巡逻中
local State5 = 5 --可领奖
local Text1 = TextMap.GetValue("Text848")
local Text2 = TextMap.GetValue("Text849")
local Text3 = TextMap.GetValue("Text850")
local Text4 = TextMap.GetValue("Text851")
local Text5 = TextMap.GetValue("Text852")
local REFRESH_TIMER = 0

local baseConfig = nil
local frist = true
function m:Start()
    self.topMenu = LuaMain:ShowTopMenu()
    self.state = State1
    self._curSelectType = 1
    self._curSelectTime = 1
    Events.AddListener("select_time", funcs.handler(self, m.select_time))
    Events.AddListener("select_type", funcs.handler(self, m.select_type))
    baseConfig = TableReader:TableRowByID("baseConfig", 7)
	
	local that = self
	ClientTool.AddClick(self.hero, function()
		if that.state == State2 or that.state == State3 then 
			local bind = UIMrg:pushWindow("Prefabs/moduleFabs/formationModule/formation/formation_select_char")
			bind:CallUpdate({ type = "single", module = "daili", delegate = self })
		end 
	end)
end

function m:OnDestroy()
    LuaTimer.Delete(REFRESH_TIMER)
    Events.RemoveListener('select_time')
    Events.RemoveListener('select_type')
end

function m:onFilter(char)
	if char.id == Player.Info.playercharid then return false end 
    for i = 1, 6 do
        local it = Player.Agency[i]
        if it.charId ~= nil and it.charId ~= 0  then
            if tonumber(Tool.getDictId(it.charId)) == tonumber(char.dictid) then return false end--it.charId
        end
    end
    if char.star <= baseConfig.arg1 then
        return true
    end
    return false
end

function m:select_time(id)
    self._curSelectTime = id
    m:updateState()
    m:updateLeftByTime()
end

function m:select_type(id, isLocked, msg)
    if not isLocked then
        self._curSelectType = id
	else 
		MessageMrg.show(msg)
    end
    m:updateState()
end

function m:loadModel(id, big)
    if big then
        self.hero:LoadByModelId(id, "idle", function(ctl) self.ctl = ctl end, false, 1, big)
    else
        self.hero:LoadByModelId(id, "idle", function(ctl) self.ctl = ctl end, false, 1)
    end
end

function m:onEnter()
	if not self.topMenu.gameObject.activeInHierarchy then 
		self.topMenu.gameObject:SetActive(true)
		self.topMenu:CallTargetFunction("onUpdate",true)
	end 
end 

function m:updateState()
    if self.typeBinding then
        self.typeBinding:CallUpdate({ delegate = self })
    end
end

function m:update(row)
    if type(row) == "table" then
        row = row[1]
    end
	--print_t(row)
    local data = Player.Agency[row.id]
    if data.state == "1" then
        self.state = State2
        local charId = tonumber(data.charId) or 0
        if charId ~= 0 then
            self.state = State4
            local sTime = ClientTool.GetNowTime(data:getLong("PatrolTime"))
            if sTime <= 0 then
                if data.dropState == "1" then
                    self.state = State5
                elseif data.dropState == "2" then
                    self.state = State2
                end
            end
        end
    else
        self.state = State1
    end
	
    self.row = row
    m:onUpdate(row)
    if frist == true then
        frist = false
        m:checkEvent()
    end
    self.bg.Url = UrlManager.GetImagesPath("sl_go_on_patrol/"..row.img..".png")
end

function m:updateLeftByTime(...)
    local list = {}
    for i = 1, #self.rewardList do
        table.insert(list, self.rewardList[i])
    end
    local piece = self.char:getPiece()
    piece.count = 1
    local timeRow = TableReader:TableRowByID("timeConfig", self._curSelectTime)
    local drop = timeRow.drop[0]
    local arg = drop.times
    local num = 1
    if arg.Count == 1 then
        num = arg[0]
    else
        num = arg[0] .. "~" .. arg[1]
    end
    piece.rwCount = num
    -- piece.name = piece.Table.show_name .. "[ffff00](" .. num .. ")[-]"
    table.insert(list, 1, piece)
    m:refreshLeft(list)
end

function m:onUpdate(row)
    local img = row.img
    if img == "" then img = row.id end
    --self.img_bg.Url = UrlManager.GetImagesPath("go_on_patrol/" .. img .. ".png")
    self.txt_sceneName.text = row.area_name
    self.txt_desc.text = row.desc
	self.topMenu:CallTargetFunction("onUpdate",true)
	--print_t(row.probdrop)
    if self.rewardList == nil then
        local rewardList = RewardMrg.getProbdropByTable(row.probdrop)

        self.probdropCharPiece = {}
        self.probdropItem = {}
        local _list = {}
        for i = 1, #rewardList do
            local it = rewardList[i]
            local tp = it:getType()
            if tp == "char" or tp == "charPiece" then
                table.insert(self.probdropCharPiece, it)
                -- table.insert(_list,1,it)
            else
                table.insert(self.probdropItem, it)
                -- table.insert(_list,it)
            end
        end
        table.sort(self.probdropCharPiece, function(a, b)
            return a.star > b.star
        end)

        for i = 1, #self.probdropCharPiece do
            table.insert(_list, self.probdropCharPiece[i])
        end

        for i = 1, #self.probdropItem do
            table.insert(_list, self.probdropItem[i])
        end

        rewardList = _list
        self.rewardList = rewardList
    end
    local s = self.state

    self.power_bg:SetActive(s == State1)
    --self.btn_fight.gameObject:SetActive(s == State1)
    self.goingFight:SetActive(s == State1)
    self.reward_item:SetActive(s == State2)
    self.ndoe_add:SetActive(s == State2)
    self.spr_redPoint:SetActive(s == State2)
    self.img_desc_bg:SetActive(s == State2)
    self.hero.gameObject:SetActive(s ~= State2)
    --self.btn_settings.gameObject:SetActive(s == State3)
    self.goingSettings:SetActive(s == State3)
    self.going:SetActive(s == State4)

    self.scroll_history:SetActive(s >= State4)
    self.goingDone:SetActive(s == State5)
    self.txt_next_time.text = ""

    self.binding:Hide("txt_next_time")
    if s == State1 then
        m:refreshLeft(RewardMrg.getProbdropByTable(row.drop))
        self.txt_title.text = Text1
        self.txt_power.text = row.power
        m:loadModel(row.model, row.big / 1000)
    elseif s == State2 then
        m:refreshLeft(self.probdropCharPiece)
        m:refreshRight(self.probdropItem)
        self.txt_title.text = Text2
        self.txt_title2.text = Text3

    elseif s == State3 then
        --把选中英雄加到前面
        m:updateLeftByTime()
        self.txt_title.text = Text4
        -- for i = 1, 3 do
        -- 	local row = TableReader:TableRowByID("timeConfig",i)
        -- 	self["btn_check"..i]:CallUpdate(row)
        -- end
        m:loadModel(self.char.modelTable.id)
        m:updateState()
    elseif s == State4 then
        --显示已获得奖励
        local data = Player.Agency[row.id]
        local charId = data.charId
        local char = Char:new(charId)
        self.char = char
        m:loadModel(char.modelTable.id)
        m:startTimer()
        local list = m:getReward()
        m:refreshLeft(list.dropList)
        self.txt_title.text = Text5

        local li = list.list
        -- local desc  = ""
        -- for i = 1, #li do
        -- 	mEnd = "\n"
        -- 	if i == 1 then mEnd = "" end
        -- 	desc = desc .. mEnd  .. li[i]
        -- end

        -- self.txt_history.text = desc
        ClientTool.UpdateMyTable("", self.myTable, li)
        self.binding:CallManyFrame(function()
            self.Table.repositionNow = true
            self.binding:CallManyFrame(function()
                self.hisotry_view:SetDragAmount(0, 1, false)
                self.hisotry_view:SetDragAmount(0, 1, true)
            end)
        end)
    elseif s == State5 then
        --显示已获得奖励
        local data = Player.Agency[row.id]
        local charId = data.charId
        local char = Char:new(charId)
        self.char = char
        m:loadModel(char.modelTable.id)
        local list = m:getReward()
        m:refreshLeft(list.dropList)
        self.txt_title.text = Text5

        local li = list.list
        -- local desc  = ""
        -- for i = 1, #li do
        -- 	mEnd = "\n"
        -- 	if i == 1 then mEnd = "" end
        -- 	desc = desc .. mEnd  .. li[i]
        -- end

        -- self.txt_history.text = desc
        ClientTool.UpdateMyTable("", self.myTable, li)
        self.binding:CallManyFrame(function()
            self.Table.repositionNow = true
            self.binding:CallManyFrame(function()
                self.hisotry_view:SetDragAmount(0, 1, false)
                self.hisotry_view:SetDragAmount(0, 1, true)
            end)
        end)
    end
end

function m:startTimer(...)
    LuaTimer.Delete(REFRESH_TIMER)
    local data = Player.Agency[self.row.id]
    self.time = ClientTool.GetNowTime(data:getLong("PatrolTime"))
    local ctl = self.ctl
    local aniList = { "idle"}
    local count = 0
    local check = 0
    REFRESH_TIMER = LuaTimer.Add(0, 1000, function(id)
        if self.binding == nil then return false end
        if self.time > 0 then
            local time = Tool.FormatTime(self.time)
            self.txt_time.text = time
            self.binding:Show("txt_next_time")

        else
            --倒计时结束
            self.state = State5
            m:onUpdate(self.row)
            self.txt_next_time.text = ""
            self.binding:Hide("txt_next_time")
            m:checkEvent()
            return false
        end
        self.time = ClientTool.GetNowTime(data:getLong("PatrolTime"))

        if count >= 5 then
            count = 1
            if ctl then
                ani = aniList[math.random(1, #aniList)]
                --ctl:PlayAnimation(ani, true)
            end
        end
        count = count + 1

        local t = ClientTool.GetNowTime(data:getLong("countDown"))
        if t > 0 then
            local t = Tool.FormatTime(t)
            self.txt_next_time.text = TextMap.GetValue("Text117") .. t
        else
            self.binding:Hide("txt_next_time")
            self.txt_next_time.text = ""
            m:checkEvent()
        end
        return true
    end)
end

function m:checkEvent()
    local row = self.row
    Api:checkPatrol(row.id, function()
        m:update(row)
    end, function(ret)
        return true
    end)
end

--累计奖励
function m:getReward(...)
    local data = Player.Agency[self.row.id]
    local events = data.events
    local list = {}
    local dropList = {}
    for i = 0, events.Count - 1 do
        local event = events[i]
        local row = TableReader:TableRowByID("randomEvent", event.eventId)
		--print("event.drop = " .. tostring(event.drop))
        local drop = RewardMrg.getProbdropByTable({ event.drop })
        -- for j = 1, #drop do
        -- 	table.insert(dropList,drop[j])
        -- end
		local s1 = string.find(row.event, "{0}")
		local s2 = string.find(row.event, "{1}")
        local desc = ""
		if s1 ~= nil then 
			desc = string.gsub(row.event, "{0}", self.char.name)
		end 
		if s2 ~= nil then 
			desc = string.gsub(desc, "{1}", self.row.area_name)
		end 
        if #drop > 0 then
			local name = string.find(desc, "{drop_name}")
			--print("name = " .. desc)
			--print("eventId = " .. event.eventId)
			--print_t(drop)
			if name ~= nil then 
				desc = string.gsub(desc, "{drop_name}", drop[1].name)
			end
			local num = string.find(desc, "{drop_num}")
			if num ~= nil then 
				desc = string.gsub(desc, "{drop_num}", drop[1].rwCount)
			end 
        end
        local time = event.t or 0
        local tab = Tool.getFormatTime(time / 1000, "%X")

        -- desc = "[ffff00][".. tab .."][-]" .. desc
        local obj = {
            time = "[ffff00][" .. tab .. "][-]",
            desc = desc
        }
        table.insert(list, obj)
    end
    local drop = data.drop
    dropList = RewardMrg.getProbdropByTable(drop)
    table.sort(dropList, function(a, b)
        if a.star and b.star then return a.star > b.star end
        return a.typeIndex > b.typeIndex
    end)
    return { list = list, dropList = dropList }
end

function m:refreshLeft(list)
    ClientTool.UpdateGrid("", self.GridLeft, list, self)
    if #list > 5 then
        --self.reward_bg:GetComponent(BoxCollider).enabled = true
        self.leftView:ResetPosition()
    else
        --self.reward_bg:GetComponent(BoxCollider).enabled = false
    end
    -- self.binding:CallAfterTime(0.1,function()
    -- 	self.leftView:ResetPosition()
    -- end)
end

function m:refreshRight(list)
    ClientTool.UpdateGrid("", self.GridRight, list, self)
    self.rightView:ResetPosition()
end

function m:onCallBack(char)
    UIMrg:popWindow()
    self.state = State3
    self.char = char
    m:onUpdate(self.row)
end

--挑战
function m:onFight(...)
    self.btn_fight.isEnabled = false
    local row = self.row
    Api:onFight(self.row.id, function(result)
        local fightData = {}
        fightData["battle"] = result
        fightData["mdouleName"] = "go_on_patrol"
        UIMrg:pushObject(GameObject())
        UluaModuleFuncs.Instance.uOtherFuns:callBackFight(fightData)
        fightData = nil
        self.btn_fight.isEnabled = true
        m:update(row)
        -- Events.Brocast("reloadDelegate")
    end, function(ret)
        self.btn_fight.isEnabled = true
        return false
    end)
end

--领奖
function m:onGoingDone()
    local row = self.row
    Api:getReward(self.row.id, function(result)
        packTool:showMsg(result, nil, 1)
        m:update(row)
    end)
end

--开始巡逻
function m:onStartGoing()
    local charId = self.char.id
    local areaId = self.row.id
    local timeId = self._curSelectTime
    local modelId = self._curSelectType
    local row = self.row
    Api:startPatrol(charId, areaId, timeId, modelId, function(result)
        m:update(row)
    end)
end

function m:onClick(go, name)
    if name == "btn_settings" then
        self.typeBinding = UIMrg:pushWindow("Prefabs/activityModule/goOnPatrol/select_type")
        self.typeBinding:CallUpdate({ delegate = self })
    elseif name == "btn_add" then
        local bind = UIMrg:pushWindow("Prefabs/moduleFabs/formationModule/formation/formation_select_char")
        bind:CallUpdate({ type = "single", module = "daili", delegate = self })
    elseif name == "btn_fight" then
        m:onFight()
    elseif name == "btn_going_done" then
        m:onGoingDone()
	elseif name == "btnBack" then 
		UIMrg:pop()
    end
end

function m:findSprite(name)
    local tran = self.gameObject.transform:Find(name)
    if tran == nil then return nil end
    m:setAssets(tran.gameObject:GetComponent(UISprite))
end

function m:setAssets(sp)
    if sp then
        sp.atlas = myAtlas
    end
end

function m:findFont(name)
    local tran = self.gameObject.transform:Find(name)
    if tran == nil then return nil end
    local lab = tran.gameObject:GetComponent(UILabel)
    if lab then
        lab.bitmapFont = myFont
    end
end


return m
