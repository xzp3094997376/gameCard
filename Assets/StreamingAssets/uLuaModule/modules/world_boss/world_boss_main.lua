local m = {}

local TIMEER_ID = 0
local TIMEER_ID2 = 0
function m:Start()
    LuaMain:ShowTopMenu(6, nil, {[1]={type="Ethereal_coin"},[2]={type="money"},[3]={type="gold"}})
	Tool.loadTopTitle(self.gameObject, TextMap.GetValue("Text_1_344"))

    --self.top.atlas = GameManager.GetAtlas()

    row = TableReader:TableRowByID("worldBoss_config", 1)
    local arg1 = m:getTime(row.arg1)
    local arg2 = m:getTime(row.arg2)
    local t1 = m:formatitTime(arg1)
    local t2 = m:formatitTime(m:addTime(arg1, arg2))
    local time = t1 .. " - " .. t2
    self.txt_open_time.text =string.gsub(TextMap.GetValue("Text133"),"{0}",time)
    m:setBuff()
    row = TableReader:TableRowByID("worldBoss_config", 4)
    Tool.setIcon(self.reset_icon, Tool.getResIcon(row.type))
    self.txt_reset_cost.text = row.arg1
    row = TableReader:TableRowByID("worldBoss_config", 14)
    self.txt_drop.text = row.type

    self.dpsScale = TableReader:TableRowByID("worldBoss_config", 15).type
    local row = TableReader:TableRowByID("worldBoss_config", 16)
    self.dpsShock = row.type
    self.bossShock = m:getTime(row.arg1)[3]

    m:setUnOpen()
    m:checkBoss()

    --self.buff_desc_bg1.Url = UrlManager.GetImagesPath("world_boss/SJBOSS-jiacheng3.png")
    --self.buff_desc_bg2.Url = UrlManager.GetImagesPath("world_boss/SJBOSS-jiacheng3.png")
    --self.img_slider.Url = UrlManager.GetImagesPath("task_img/slider_task_bar.png")
    --self.slider_target.Url = UrlManager.GetImagesPath("task_img/slider_task_bar_light.png") 
    --self.img_bg.Url = UrlManager.GetImagesPath("world_boss/SJBOSS-beijing.png")
    local sell_type= "Ethereal_coin"
    self.ziyuanName.text =Tool.getResName(sell_type) .. ":"
    -- self.ziyuanNum.text =toolFun.moneyNumberShowOne(math.floor(tonumber(Tool.getCountByType(sell_type))))
    self.ziyuanNum.text =Player.Resource.Ethereal_coin

    local iconName = Tool.getResIcon(sell_type)
    self.ziyuanIcon.Url=UrlManager.GetImagesPath("itemImage/" .. iconName .. ".png")
end

local bossShockTime = 0
local canShock = false

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
        local t = s1[i] + s2[i]
        if i > 1 and t >= 60 then
            list[i - 1] = list[i - 1] + 1
            list[i] = t % 60
        else
            list[i] = t
        end
    end
    return list
end

function m:getTime(time)
    local p = string.find(time, "h")
    local h = 0
    if p then
        h = string.sub(time, 1, p - 1) or 0
    else
        p = 0
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
    if p_m and p_s then
        s = string.sub(time, p_m + 1, p_s - 1) or 0
    end
    return { tonumber(h), tonumber(m), tonumber(s) }
end


--震动
function m:showShock()
    if canShock == false then
        canShock = true
        ClientTool.ResetAnimation(self.img.gameObject, 0)
        ClientTool.PlayAnimation(self.img.gameObject, "shock", function() end, true)
    end
end

function m:createLabel(pos, item)
    local t = self.norText
    local dmg = item.dmg
    if dmg > self.dpsScale then
        t = self.scaleText
    end
    if dmg > self.dpsShock then
        m:showShock()
    end
    if t == nil then return nil end
    local go = NGUITools.AddChild(t.transform.parent.gameObject, t)
    local lab = go:GetComponent(UILabel)
    go.transform.localPosition = pos
    lab.text = Tool.red .. item.dmg .. "[-]\n" .. item.name
    return lab
end

function m:tween(lab)
    if lab == nil then return end
    local pos = lab.transform.localPosition
    pos.y = pos.y + 30
    TweenPosition.Begin(lab.gameObject, 0.6, pos, false)

    -- self.binding:CallAfterTime(0.6,function()
    -- 	lab.gameObject:SetActive(false)
    -- 	-- GameObject.Destroy(lab.gameObject)
    -- 	return false
    -- end)
    lab.gameObject:SetActive(true)
end

function m:clearLabel()
    if self.gameObjectList then
        for i = 1, #self.gameObjectList do
            if self.gameObjectList[i] then
                GameObject.Destroy(self.gameObjectList[i].gameObject)
            end
        end
    end
    self.gameObjectList = {}
end

function m:showDps(arg)
    if self._exit then return end
    local list = {}
    if self._dpsList == nil then
        self._dpsList = {}
    end
    for i = 0, arg.Count - 1 do
        local name = arg[i].name
        local dmg = arg[i].dmg

        if not self._dpsList[name .. dmg] then
            local it = {}
            it.name = name
            it.dmg = dmg
            table.insert(list, it)
            self._dpsList[name .. dmg] = it
        end
    end

    local minX = self.scaleText.transform.localPosition.x
    local maxX = self.norText.transform.localPosition.x

    local minY = self.scaleText.transform.localPosition.y
    local maxY = self.norText.transform.localPosition.y
    local that = self
    local len = #list
    m:clearLabel()


    self.binding:CallAfterTime(0.2, function()
        for i = 1, len do
            self.binding:CallAfterTime(0.2 * i, function()
                if self.binding == nil then return end
                local pos = Vector3(math.random(minX, maxX), math.random(minY, maxY), 0)
                local lab = m:createLabel(pos, list[i])
                if lab then
                    table.insert(self.gameObjectList, lab)
                    m:tween(lab)
                end
            end)
        end
    end)
end

--设置数据
function m:setData(data)
    if data.hp then
        m:setOpened(data)
        if data.DmgArr then
            m:showDps(data.DmgArr)
        end
    else
        m:setUnOpen(data)
    end
end

--未开启
function m:setUnOpen(data)
    self.opened:SetActive(false)
    self.un_open:SetActive(true)
    self.btn_reward.gameObject:SetActive(true)
    self.Btn_buzhen.gameObject:SetActive(false)
    if data == nil then return end
    m:setPreDps(data)
    if data == nil then return end
    local id = data.id
    local row = TableReader:TableRowByID("worldBoss_master", id)
    local mid = tonumber(row.model)
	if mid == nil then 
		print("模型ID配置错误！")
	else 
		self.img:LoadByModelId(mid, "idle", function() end, false, -1, row.big/1000)
	end 
    local name = row.show_name .. TextMap.GetValue("Text_1_2860") .. (data.lv or row.level)
    self.txt_boss_name.text = name
    local time = data.t or 0
    self.time = time / 1000
    LuaTimer.Delete(TIMEER_ID2)
    if time > 0 then
        TIMEER_ID2 = LuaTimer.Add(0, 1000, function(id)
            local t = Tool.FormatTime(self.time)
            self.txt_time.text =string.gsub(TextMap.GetValue("Text138"),"{0}",t)
            self.time = self.time - 1
            if self.time <= 0 then
                m:checkBoss()
                return false
            end
            return true
        end)
    else
        self.txt_time.text = ""
    end
    m:clearLabel()
end

function m:checkBoss()
    Api:checkBoss(function(result)
        m:setData(result)
    end, function(ret)
        return true
    end)
end

function m:OnDestroy()
    LuaTimer.Delete(TIMEER_ID2)
    LuaTimer.Delete(TIMEER_ID)
end

--已开启
function m:setOpened(data)
    self.opened:SetActive(true)
    self.un_open:SetActive(false)
    self.btn_reward.gameObject:SetActive(false)
    self.Btn_buzhen.gameObject:SetActive(true)
    local hp = data.hp
    local maxHp = data.maxHp
    local val = hp / maxHp
    self.slider.value = val
    self.txt_boss_hp.text = hp .. "/" .. maxHp
    local time = data.time
    self.time = time / 1000
    local id = data.id
    local row = TableReader:TableRowByID("worldBoss_master", id)
	local mid = tonumber(row.model)
	if mid == nil then 
		print("模型ID配置错误！")
	else 
		self.img:LoadByModelId(mid, "idle", function() end, false, -1, row.big/1000)
	end 
    --self.img.Url = UrlManager.GetImagesPath("sl_world_boss/" .. row.img .. ".png")
    local name = row.name .. "  Lv." .. data.lv .. TextMap.GetValue("Text1470")
    LuaTimer.Delete(TIMEER_ID2)
    if time > 0 then
        local count = 0
        TIMEER_ID2 = LuaTimer.Add(0, 1000, function(id)
            local t = Tool.FormatTime(self.time)
            self.txt_boss_name.text = name
			self.txt_time_open.text =  t
            self.time = self.time - 1

            if self.time <= 0 then
                m:checkBoss()
                return false
            end
            count = count + 1
            if count == 4 then
                m:checkBoss()
                count = 0
            end
            if canShock == true then
                bossShockTime = bossShockTime + 1
                if bossShockTime == self.bossShock then
                    bossShockTime = 0
                    canShock = false
                end
            end
            return true
        end)
    else
        self.txt_boss_name.text = row.name .. TextMap.GetValue("Text_1_2860") .. (data.lv or row.level)
    end

    m:setCurDps(data)

    m:onUpdate()

    if self.jifen == nil then
        local top = self.gameObject.transform:Find("Panel").gameObject
        local go = ClientTool.loadAndGetLuaBinding("Prefabs/activityModule/task_jifen/task_jifen", top)
        go.transform.localPosition = Vector3(0, -266, 0)
        self.jifen = go
    end
    self.jifen:CallUpdate()
end

function m:onUpdate()
    local moneyBuff = Player.WorldBoss.moneyBuff
    local goldBuff = Player.WorldBoss.goldBuff
    local dmg = moneyBuff + goldBuff
    dmg = dmg * 100
    dmg = dmg
    self.txt_dps.text =string.gsub(TextMap.GetValue("Text136"),"{0}",dmg)
    local data = Player.WorldBoss

    local time = ClientTool.GetNowTime(data:getLong("CDTime"))
    LuaTimer.Delete(TIMEER_ID)
    delegate = self.delegate
    if time > 0 then
        self.btn_reset.gameObject:SetActive(true)
        self.txt_reset_time.gameObject:SetActive(true)
        self.btn_fight.gameObject:SetActive(false)
        TIMEER_ID = LuaTimer.Add(0, 1000, function(id)
            if self.binding == nil then return false end
            time = ClientTool.GetNowTime(data:getLong("CDTime"))
            if time > 0 then
                time = Tool.FormatTime(time)
                self.txt_reset_time.text = time
            else
                self.txt_reset_time.text = ""
                m:onUpdate()
                return false
            end
            return true
        end)
    else
        self.btn_reset.gameObject:SetActive(false)
        self.txt_reset_time.gameObject:SetActive(false)
        self.btn_fight.gameObject:SetActive(true)
    end
    m:setBuff()
end

--buff数据
function m:setBuff()
    if self.moneyCost == nil then
        local row = TableReader:TableRowByID("worldBoss_config", 5) --金币助威消耗，基础值&成长值
        local tp = row.type
        local num = row.arg1
        Tool.setIcon(self.buff_icon1, Tool.getResIcon(tp))
        self.moneyCost = num
        self.moneyArg = row.arg2
        row = TableReader:TableRowByID("worldBoss_config", 7)
        self.moneyCostUp = row.type / 1000
        self.buff_add_1.text = "+" .. (row.type / 10) .. "%"

        row = TableReader:TableRowByID("worldBoss_config", 6) --钻石助威消耗，基础值&成长值
        tp = row.type
        num = row.arg1
        Tool.setIcon(self.buff_icon2, Tool.getResIcon(tp))
        self.goldCost = num
        self.goldArg = row.arg2

        row = TableReader:TableRowByID("worldBoss_config", 8)
        self.goldCostUp = row.type / 1000
        self.buff_add_2.text = "+" .. (row.type / 10) .. "%"
    end
    self.txt_reset_cost1.text = self.moneyCost + self.moneyArg * Player.WorldBoss.moneyBuff / self.moneyCostUp

    self.txt_reset_cost2.text = self.goldCost + self.goldArg * Player.WorldBoss.goldBuff / self.goldCostUp
end

--加buff
function m:addBuff(tp)
    local cost = 0
    local num = 0
    local desc = ""
    if tp == "money" then
        cost = self.moneyCost + self.moneyArg * Player.WorldBoss.moneyBuff / self.moneyCostUp
        num = Player.WorldBoss.moneyBuff
        desc =string.gsub(TextMap.GetValue("Text131"),"{0}",cost)
    elseif tp == "gold" then
        cost = self.goldCost + self.goldArg * Player.WorldBoss.goldBuff / self.goldCostUp
        num = Player.WorldBoss.goldBuff
        desc = string.gsub(TextMap.GetValue("Text132"),"{0}",cost)
    end

    DialogMrg.ShowDialog(desc, function()
        Api:addWorldBuff(tp, function(result)
            if tp == "money" then
                num = Player.WorldBoss.moneyBuff - num
            elseif tp == "gold" then
                cost = self.goldCost
                num = Player.WorldBoss.goldBuff - num
            end
            if num == 0 then
                MessageMrg.show(TextMap.GetValue("Text134"))
            else
                MessageMrg.show(string.gsub(TextMap.GetValue("Text135"),"{0}",num * 100))
            end
            m:onUpdate()
        end)
    end)
end

function m:getNum(dps)
    dps = dps or 0
    if dps > 10000 then
        dps = math.floor(dps/1000)*1000
        local str = string.format("%.1f", (dps / 10000))
        return "[00ff00]" .. str .. TextMap.GetValue("Text_1_2861")
    end
    return dps
end

--当前伤害排行
function m:setCurDps(data)
    local rankList = data.ranklist
    local list = {}
    local max = 5
    if rankList then
        for i = 0, rankList.Count - 1 do
            --if i < max then
                local it = rankList[i]
                local obj = {}
                obj.no = i + 1
                obj.name = it.name --(i + 1) .. "." .. 
                obj.dps = m:getNum(it.dmg)
                obj.index = i + 1
                table.insert(list, obj)
            --end
        end
    end
    self.txt_no_cur_dps_rank:SetActive(#list == 0)

    ClientTool.UpdateMyTable("", self.cur_rank_tatle, list, self)
end

function m:setPreDps(data)
    local rankList = data.ranklist
    local list = {}
    local max = 5
    if rankList then
        for i = 0, rankList.Count - 1 do
            --if i < max then
                local it = rankList[i]
                local obj = {}
                obj.no = i + 1
                obj.name = it.name
                obj.dps = m:getNum(it.dmg)
                obj.index = i + 1
                table.insert(list, obj)
            --end
        end
    end
    if #list > 0 then
        self.no_rank:SetActive(false)
        self.has:SetActive(true)
        ClientTool.UpdateMyTable("", self.rank_tatle, list, self) --上次伤害排行
    else
        self.no_rank:SetActive(true)
        self.has:SetActive(false)
    end

    local last = data.killPlayer
    self.lastKill = nil
    if last and last.name then
        self.no_player:SetActive(false)
        self.last_hit.gameObject:SetActive(true)
        local obj = {}
        obj.no = ""
        obj.name = last.name
        obj.dps = m:getNum(last.dmg)
        self.lastKill = obj
        self.last_hit:CallUpdate(obj)

    else
        self.no_player:SetActive(true)
        self.last_hit.gameObject:SetActive(false)
    end

    local luckPlayer = data.luckPlayer
    list = {}
    if luckPlayer then
        for i = 0, luckPlayer.Count - 1 do
            local it = luckPlayer[i]
            local obj = {}
            obj.no = i + 1
            obj.name = it.name
            obj.dps = m:getNum(it.dmg)
            obj.index = i + 1
            table.insert(list, obj)
        end
    end
    self.luckyList = nil

    if #list > 0 then
        self.no_lucky:SetActive(false)
        self.lucky_tatle.gameObject:SetActive(true)
        ClientTool.UpdateMyTable("", self.lucky_tatle, list, self) --上次幸运玩家
        self.luckyList = list
    else
        self.no_lucky:SetActive(true)
        self.lucky_tatle.gameObject:SetActive(false)
    end
end

--伤害奖励
function m:onReward()
    UIMrg:pushWindow("Prefabs/activityModule/world_boss/w_rewardInfo")
end

--规则
function m:onRuler()
    UIMrg:pushWindow("Prefabs/moduleFabs/qiancengta/qiancengta_rule", { 8 })
end

function m:onEnter()
    self.ziyuanNum.text =Player.Resource.Ethereal_coin
    self._exit = false
    m:checkBoss()
    LuaMain:ShowTopMenu(6, nil, {[1]={type="Ethereal_coin"},[2]={type="money"},[3]={type="gold"}})
end

function m:onExit()
    self._exit = true
    m:OnDestroy()
end

--挑战
function m:onFight(go)
    go.isEnabled = false

    Api:fightBoss(function(result)
        local fightData = {}
        fightData["battle"] = result
        fightData["mdouleName"] = "world_boss" --世界boss
        fightData["model"] = tp
        fightData.total_dmg = result.total_dmg or 0
        UIMrg:pushObject(GameObject())
        UluaModuleFuncs.Instance.uOtherFuns:callBackFight(fightData)
        fightData = nil
        go.isEnabled = true
        m:checkBoss()
    end, function(ret)
        go.isEnabled = true
        return false
    end)
end

--重置cd
function m:onReset()
    Api:clearBossCDTime(function(result)
        m:onUpdate()
    end)
end



--当前伤害排行
function m:onCurRank()
    UIMrg:pushWindow("Prefabs/activityModule/world_boss/w_rankInfo", { tp = 1 })
end

--前一次排行榜
function m:onPreRank()
    UIMrg:pushWindow("Prefabs/activityModule/world_boss/w_rankInfo", { tp = 2, lastKill = self.lastKill, luckyList = self.luckyList })
end

function m:onClick(go, name)
    if name == "btn_r" then
        m:onRuler()
    elseif name == "btn_reward" then
        m:onReward()
    elseif name == "btn_fight" then
        m:onFight(go)
    elseif name == "buff1" then
        m:addBuff("money")
    elseif name == "buff2" then
        m:addBuff("gold")
    elseif name == "btn_reset" then
        m:onReset()
    elseif name == "btn_cur_rank" then
        m:onCurRank()
    elseif name == "btn_rank" then
        m:onPreRank()
	elseif name == "btnBack" then 
		UIMrg:pop()
    elseif name == "btn_shop" then
        LuaMain:showShop(15)
    elseif name == "Btn_buzhen" then
        LuaMain:showFormation(0)
    end
end


return m