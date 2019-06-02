local m = {}
local REFRESH_TIMER = 0
function m:Start()
    local row = TableReader:TableRowByID("daxuSetting", 7)
    self.txt_item_num_nor.text = row.arg1

    row = TableReader:TableRowByID("daxuSetting", 8)
    self.txt_item_num_sp.text = row.arg1
    self._costSp = row.arg1
    row = TableReader:TableRowByID("daxuSetting", 16)
    self.max_point = row.arg1
    self.txt_desc.text = TextMap.GetValue("Text121")

    row = TableReader:TableRowByID("daxuSetting", 11)
    local arg1 = m:getTime(row.arg1)
    local arg2 = m:getTime(row.arg2)
    local t1 = m:formatitTime(arg1)
    local t2 = m:formatitTime(m:addTime(arg1, arg2))
    local txt1 = "[00ff00]" .. t1 .. " - " .. t2 .. "[-]  "

    row = TableReader:TableRowByID("daxuSetting", 12)

    arg1 = m:getTime(row.arg1)
    arg2 = m:getTime(row.arg2)
    t1 = m:formatitTime(arg1)
    t2 = m:formatitTime(m:addTime(arg1, arg2))
    txt2 = "[00ff00]" .. t1 .. " - " .. t2 .. "[-] "
    self.txt_left.text =string.gsub(TextMap.GetValue("Text123"),"{0}",txt1)
    self.txt_right.text = string.gsub(TextMap.GetValue("Text124"),"{0}",txt2)
    --同步一下服务器时间
    Api:checkRes(function(result)
    end)
end

function m:formatitTime(arg)
    local h = arg[1]
    local m = arg[2]
    local s = arg[3]
    local str = ""
    if h < 10 then
        str = str .. "0" .. h .. ":"
    else
        str = str .. h .. ":"
    end

    if m < 10 then
        str = str .. "0" .. m
    else
        str = str .. m
    end
    if s > 0 and s < 10 then
        str = str .. ":0" .. s
    elseif s > 0 then
        str = str .. ":" .. s
    end
    return str
end

function m:addTime(s1, s2)
    local list = {}
    for i = 1, #s1 do
        list[i] = s1[i] + s2[i]
    end
    return list
end

function m:getTime(time)
    local p = string.find(time, "h")
    local h = 0
    if p then
        h = string.sub(time, 1, p - 1) or 0
    end

    local p_m = string.find(time, "m")
    local m = 0
    if p_m then
        m = string.sub(time, p + 1, p_m - 1) or 0
    else
        p_m = p
    end
    local p_s = string.find(time, "s")
    local s = 0
    if p_s then
        s = string.sub(time, p_m + 1, p_s - 1) or 0
    end
    return { tonumber(h), tonumber(m), tonumber(s) }
end

function m:curHp(arg)
    local num = 0
    for i = 0, arg.Count - 1 do
        num = num + (arg[i] or 0)
    end
    return num
end

function m:update(data, delegate)
    self.data = data
    self.delegate = delegate or self.delegate

    local row = TableReader:TableRowByID("daxueMaster", data.id)
    local name = row.name
    local star = row.star
    local color = TableReader:TableRowByID("daxuColor", star)
    name = color.color .. name .. "[-]"
    self.txt_boss_name.text = name --.. " Lv." .. (data.lv)
    -- m:onUpdate()
    local that = self
    self.consumeHalf = false
    Api:checkDaxu(function(result)
        local list = result.daxu
        local dataList = json.decode(list:toString())
        local flag = false
        for i = 1, #dataList do
            if dataList[i].pid == that.data.pid then
                that.data = dataList[i]
                flag = true
            end
        end
        -- that.data = Player.DaXu
        that.consumeHalf = result.consumeHalf or false
        if flag == false then
            self.gameObject:SetActive(false)
        end
        m:onUpdate()
    end, function(ret)
        return true
    end)
end

function m:onUpdate()
    local data = self.data
    local row = TableReader:TableRowByID("daxueMaster", data.id)
    local id = row.model
    self.hero:LoadByModelId(id, "idle", function(ctl)
    end, false, -1, 1)
    local hp = data.hp --m:curHp(data.masterHp)
    local maxhp = data.maxHp or 1
    self.slider.value = hp / maxhp
    self.txt_item_num.text = Player.Resource.daxu_point .. "/" .. self.max_point
    local time = ClientTool.GetNowTime(data.CDTime or 0)

    LuaTimer.Delete(REFRESH_TIMER)
    delegate = self.delegate
    if time > 0 then
        REFRESH_TIMER = LuaTimer.Add(0, 1000, function(id)
            if self.binding == nil then return false end
            local time = ClientTool.GetNowTime(data.CDTime or 0)
            if time > 0 then
                time = "[00FF00FF]"..Tool.FormatTime(time).."[-]"
                self.txt_run_time.text =string.gsub(TextMap.GetValue("Text120"),"{0}",time)
            else
                self.gameObject:SetActive(false)
                self.txt_run_time.text = ""
                m:update(self.data)
                delegate:onEnter()
                return false
            end
            return true
        end)
    else
        self.txt_run_time.text = ""
        self.gameObject:SetActive(false)
    end
    self.txt_boss_hp.text = hp .. "/" .. maxhp
    local name = row.name
    local star = row.star
    local color = TableReader:TableRowByID("daxuColor", star)
    name = color.color .. name .. "[-]"
    self.txt_boss_name.text = name --.. " Lv." .. (data.lv)
	self.txt_boss_lv.text = TextMap.GetValue("Text_1_306") .. "[00FF00FF]"..(data.lv or color.level).."[-]"

    if self.consumeHalf == true then
        self.txt_item_num_sp.text = self._costSp / 2
        self.costSP = self._costSp / 2
    else
        self.txt_item_num_sp.text = self._costSp
        self.costSP = self._costSp
    end
end

function m:OnDestroy()
    LuaTimer.Delete(REFRESH_TIMER)
end

function m:onFight(go, tp)
    go.isEnabled = false

    local delegate = self.delegate
    local that = self
    
    Api:fightDaxu(self.data.pid, tp, function(result)
        local fightData = {}
        fightData["battle"] = result
        fightData["mdouleName"] = "encirclement" --围剿大虚
        fightData["model"] = tp
        fightData["pid"] = self.data.pid
        fightData.gongxun = result.gongxun or 0
        fightData.dmg = result.dmg or 0
        UIMrg:pushObject(GameObject())
        UluaModuleFuncs.Instance.uOtherFuns:callBackFight(fightData)
        fightData = nil
        go.isEnabled = true
        m:update(self.data)
        --delegate:onEnter()
    end, function(ret)
        go.isEnabled = true
        that.gameObject:SetActive(false)
        return false
    end)
end

function m:useItem()
    -- Api:useTaoFaLing(function(result)

    --     --print_t(result)
    --     --packTool:showMsg(result, nil, 0)
    -- end)
end

function m:onClick(go, name)
    if name == "btn_close" then
        self.gameObject:SetActive(false)
        m:OnDestroy()
    elseif name == "btnFormation" then
        LuaMain:showFormation(0)
    elseif name == "btn_add" then
        -- DialogMrg:BuyBpAOrSoul("daxu_point", "", function() end, function()
        --     m:update(self.data)
        -- end, function()
        --     m:useItem()
        -- end)
        DialogMrg:BuyBpAOrSoul("daxu_point", "", toolFun.handler(self, self.onUpdate))
    elseif name == "btnAtkSp" then
        if self.costSP ~= tonumber(self.txt_item_num_sp.text) then
            self.costSP = tonumber(self.txt_item_num_sp.text)
        end
        if Player.Resource.daxu_point < self.costSP then 
            DialogMrg:BuyBpAOrSoul("daxu_point", "", toolFun.handler(self, self.onUpdate))
            return
        end
        m:onFight(go, "Special")
    elseif name == "btnAtkNor" then
        if Player.Resource.daxu_point < 1 then 
            DialogMrg:BuyBpAOrSoul("daxu_point", "", toolFun.handler(self, self.onUpdate))
            return
        end
        m:onFight(go, "common")
    end
end

return m