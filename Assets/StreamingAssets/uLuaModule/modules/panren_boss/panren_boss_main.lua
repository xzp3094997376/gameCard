local m = {}

local campStr = {TextMap.GetValue("Text_1_2945"), TextMap.GetValue("Text_1_2946"), TextMap.GetValue("Text_1_2947")}
local TIMEER_ID = 0
local TIMEER_ID2 = 0
function m:Start()
    --LuaMain:ShowTopMenu(6, nil, {[1]={type="Ethereal_coin"},[2]={type="money"},[3]={type="gold"}})
    LuaMain:ShowTopMenu()
	Tool.loadTopTitle(self.gameObject, TextMap.GetValue("Text_1_2948"))

    --self.top.atlas = GameManager.GetAtlas()

	self.totelTimes = TableReader:TableRowByID("taorenBossSetting", 2).arg1
    row = TableReader:TableRowByID("worldBoss_config", 1)
    local arg1 = m:getTime(row.arg1)
    local arg2 = m:getTime(row.arg2)
    local t1 = m:formatitTime(arg1)
    local t2 = m:formatitTime(m:addTime(arg1, arg2))
    local time = t1 .. " - " .. t2
    --self.txt_open_time.text = TextMap.getText("TXT_WORLD_BOSS_OPEN_TIME", { time })
    self.dpsScale = 0
	self.dpsShock = 1000000
    row = TableReader:TableRowByID("worldBoss_config", 4)
    Tool.setIcon(self.reset_icon, Tool.getResIcon(row.type))
    Events.AddListener("updateReward",funcs.handler(self, self.updateRedPoint))

    --m:setUnOpen()
    m:checkBoss()
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
        --ClientTool.ResetAnimation(self.img.gameObject, 0)
        --ClientTool.PlayAnimation(self.img.gameObject, "shock", function() end, true)
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
		
        if dmg ~=nil and not self._dpsList[name .. dmg] then
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
	--data.hp
    if data.open == true then
        m:setOpened(data)
        if (data.hp and data.maxHp) and data.hp < data.maxHp and data.DmgArr then
            m:showDps(data.DmgArr)
        end
    else
        m:setUnOpen(data)
    end
end

--未开启
function m:setUnOpen(data)
	self.btn_fight_ret.gameObject:SetActive(false)
	self.img.gameObject.transform.localPosition = self.left.transform.localPosition
    self.txt_jisha.gameObject:SetActive(false);
	self.unopen:SetActive(true)
    self.opened:SetActive(false)
	self.add:SetActive(false)
	self.txt_no_open.gameObject:SetActive(false)
    self.Btn_buzhen.gameObject:SetActive(false)
	self.txt_count_time.text = ""
	-- 展现名次
	if data.bestRankList ~= nil then 
		local list = {}
		for i = 0, data.bestRankList.Count -1 do 
			table.insert(list, data.bestRankList[i])
		end 
		table.sort(list, function(a, b)
			return a.camp < b.camp
		end)
		for i = 1, 3 do 
            local temp = nil
            --if data.camp ~= i then 
            --    data == nil
            --end 
            for j = 1, 3 do 
               local data = list[j]
               if data and data.camp == i then 
                    temp = data 
                    break
               end
            end 

			self["item"..i]:CallUpdate(temp)
		end 
	end 
    if data == nil then return end
    m:setPreDps(data)
    if data == nil then return end
    local id = data.id or 1
    if id ~= nil then 
        local row = TableReader:TableRowByID("taorenBossMaster", id)
        local mid = tonumber(row.model)
	    if mid == nil then 
	    	print("模型ID配置错误！")
	    else 
	    	self.img:LoadByModelId(mid, "idle", function() end, false, -1, row.big/1000)
	    end
        local name = row.name .. TextMap.GetValue("Text_1_2949") .. (data.lv or row.level)
        self.txt_boss_name.text = name
    else 
         self.txt_boss_name.text = ""
    end
	self.btn_fight.gameObject:SetActive(false)
	local tb = TableReader:TableRowByID("taorenBoss_open_time", 1)
	if tb ~= nil then 
		self.txt_no_open.gameObject:SetActive(true)
		self.txt_no_open.text = tb.remark
	else 
		self.txt_no_open.gameObject:SetActive(false)
	end 
    m:clearLabel()
end

function m:checkBoss()
    Api:checkTaoRenBoss(function(result)
        m:setData(result)
    end, function(ret)
        return true
    end)
end

function m:OnDestroy()
    LuaTimer.Delete(TIMEER_ID2)
    LuaTimer.Delete(TIMEER_ID)
    Events.RemoveListener("updateReward")
end

--已开启
function m:setOpened(data)
	self.txt_count_time.text = ""
	self.btn_fight_ret.gameObject:SetActive(true)
    self.txt_no_open.gameObject:SetActive(false)
	self.img.gameObject.transform.localPosition = self.center.transform.localPosition
	self.unopen:SetActive(false)
	self.opened:SetActive(Player.TaoRenBoss.camp >= 1)
	self.add:SetActive(true)
    --self.btn_reward.gameObject:SetActive(false)
    self.Btn_buzhen.gameObject:SetActive(true)
    local hp = data.hp or 0
    self.hp = hp
    local maxHp = data.maxHp or 0
    local val = hp / maxHp
    self.slider.value = val
    self.txt_boss_hp.text = hp .. "/" .. maxHp
    local time = data.time or 0
    self.time = time / 1000
    local id = data.id or 1
    local row = TableReader:TableRowByID("taorenBossMaster", id)
	local mid = tonumber(row.model)
	if mid == nil then 
		print("模型ID配置错误！")
	else 
		self.img:LoadByModelId(mid, "idle", function() end, false, -1, row.big/1000)
	end 
    --self.img.Url = UrlManager.GetImagesPath("sl_world_boss/" .. row.img .. ".png")
	self.txt_gongji.text = Player.TaoRenBoss.gongxun
	self.txt_dmg.text = Player.TaoRenBoss.maxDmg
	self.txt_rank.text = TextMap.GetValue("Text_1_2950")
	if campStr[Player.TaoRenBoss.camp] ~= nil then 
		self.txt_title.text = campStr[Player.TaoRenBoss.camp]
	else 
		self.txt_title.text = ""
	end 
	self.jisha:SetActive(hp<=0)
	self.btn_fight.gameObject:SetActive(hp>0)
	local cd = (data.bossPointTime or 0) / 1000
    local name = row.name .. "  Lv." .. data.lv
    self.bossLv = data.lv
    LuaTimer.Delete(TIMEER_ID2)
    if time and time > 0 then
        local count = 0
        TIMEER_ID2 = LuaTimer.Add(0, 1000, function(id)
            local min = self.time -  os.time() 
            local cd_time = os.date('%M:%S', (min))
            self.txt_boss_name.text = name
			if hp <= 0 then 
				self.txt_jisha.text = TextMap.GetValue("Text_1_2951") .. data.killPlayer .. TextMap.GetValue("Text_1_2952") .. "[00ff00]" ..(cd_time or "00:00") ..TextMap.GetValue("Text_1_2953")
			end 
			if Player.TaoRenBoss.has_fight < self.totelTimes then 
				local cd_t = os.date('%M:%S', (cd -  os.time() ))
                if cd_t == nil then 
                    self.txt_count_time.text = ""
                else
                    self.txt_count_time.text =string.gsub(TextMap.GetValue("LocalKey_735"),"{0}",cd_t)
                end
			else 
				self.txt_count_time.text = ""
			end 
           --self.time = self.time - 1
            if min <= -1 then
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
        self.txt_boss_name.text = row.name .. TextMap.GetValue("Text_1_2949") .. (data.lv or row.level)
    end

    m:setCurDps(data)

    m:onUpdate()

    m:updateRedPoint()
end

function m:onUpdate()
	self.txt_num.text = TextMap.GetValue("Text_1_2955") .. (Player.TaoRenBoss.has_fight) .. "/" .. self.totelTimes
end

function m:getNum(dps)
    dps = dps or 0
    if dps > 10000 then
        dps = math.floor(dps/1000)*1000
        local str = string.format("%.1f", (dps / 10000))
        return "[00ff00]" .. str .. TextMap.GetValue("Text_1_2931")
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
				 obj.gongxun = it.gongxun
                obj.index = i + 1
                table.insert(list, obj)
            --end
        end
    end
	if #list > 0 then 
		self.scrollView:refresh(list, self)
	end
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
        --ClientTool.UpdateMyTable("", self.rank_tatle, list, self) --上次伤害排行
    else
        --self.no_rank:SetActive(true)
    end

    local last = data.killPlayer
    self.lastKill = nil
    if last and last.name then
        --self.last_hit.gameObject:SetActive(true)
        local obj = {}
        obj.no = ""
        obj.name = last.name
        obj.dps = m:getNum(last.dmg)
        self.lastKill = obj
        --self.last_hit:CallUpdate(obj)

    else
        --self.last_hit.gameObject:SetActive(false)
    end
end

--伤害奖励
function m:onReward()
    UIMrg:pushWindow("Prefabs/activityModule/panRen_boss/gui_panren_reward")
end

--规则
function m:onRuler()
    UIMrg:pushWindow("Prefabs/moduleFabs/qiancengta/qiancengta_rule", { 21 })
end

function m:onEnter()
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
	
	if Player.TaoRenBoss.camp < 1 then 
		UIMrg:pushWindow("Prefabs/activityModule/panRen_boss/gui_panren_group")
		go.isEnabled = true
		return 
	end 
	
    Api:fightTaoRenBoss(function(result)
		 print("fight: " .. tostring(result))
        local fightData = {}
        fightData["battle"] = result
        fightData["mdouleName"] = "taoren_boss" --世界boss
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

function m:updateRedPoint()
	self.eff:SetActive(self:checkPoint())
end

function m:checkPoint()
    local red = false
	TableReader:ForEachLuaTable("taorenBossReward_exploit", function(index, item)
			if Player.TaoRenBoss.gongxunReward[item.id] == item.id then 
				red = true
				return true
			end 
		return false
	end)
    local lv = self.boss_lv or -1
    if self.hp > 0 then lv = lv -1 end
    TableReader:ForEachLuaTable("taorenBossReward_Kill", function(index, item)
			if (Player.TaoRenBoss.levelReward[item.id] == nil and lv and lv >= item.boss_lv) or 
               (Player.TaoRenBoss.levelReward[item.id] ~= nil and lv and Player.TaoRenBoss.levelReward[item.id] == 0 and lv >= item.boss_lv) then 
				red = true
				return true
			end 
		return false
	end)
	return red
end 

--当前伤害排行
function m:onCurRank()
    UIMrg:pushWindow("Prefabs/activityModule/world_boss/w_rankInfo", { tp = 1 })
end

--排行榜
function m:onRank(tp)
    UIMrg:pushWindow("Prefabs/activityModule/panRen_boss/gui_panren_rankInfo", { tp = tp })
end

function m:onClick(go, name)
    if name == "btn_r" then
        m:onRuler()
    elseif name == "btn_reward" then
        m:onReward()
    elseif name == "btn_fight" then
        m:onFight(go)
    elseif name == "btn_cur_rank" then
        m:onCurRank()
    elseif name == "btn_rank" then
        m:onRank(1)
	elseif name == "btnBack" then 
		UIMrg:pop()
    elseif name == "Btn_buzhen" then
        LuaMain:showFormation(0)
	elseif name == "btn_img" then 
		m:onBoss()
	elseif name == "btn_add" then 
		m:addFightTime()
	elseif name == "btn_rank_dmg" then 
		m:onRank(2)
    elseif name == "btn_shop" then
        LuaMain:showShop(9)
	elseif name == "btn_fight_ret" then 
		UIMrg:pushWindow("Prefabs/activityModule/panRen_boss/gui_panren_zhanbao")
    end
end

--买挑战次数
function m:addFightTime()
	local tb = TableReader:TableRowByUnique("taorenBoss_viptimes", "reset_time", Player.TaoRenBoss.buy_time+1)
	if tb == nil then 
		MessageMrg.show(TextMap.GetValue("Text_1_168"))
		return 
	end 
	local vip = tb.consume[1].consume_arg
	
	if Player.Info.vip < vip then 
		MessageMrg.show(TextMap.GetValue("Text_1_169"))
		return 
	end 
	local cost = tb.consume[0].consume_arg
	--local canBuy = 
	DialogMrg.ShowDialog(string.gsub(TextMap.GetValue("Text1811") .. "\n", "{0}", TextMap.GetValue("Text_1_170") .. cost), function()
		Api:addFightTimeByTaoRen(function(ret)
			m:onUpdate()
		end, function()
			return false
		end)
	end)
end

function m:onBoss()
	if Player.TaoRenBoss.camp < 1 then 
		UIMrg:pushWindow("Prefabs/activityModule/panRen_boss/gui_panren_group")
	end 
end

return m