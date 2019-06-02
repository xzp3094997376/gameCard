local m = {}
local showCharID = 22 --读表
local REFRESH_TIMER = 0

function m:Start()
    --self.bg.Url = UrlManager.GetImagesPath("encirclement/daxu.png")
    LuaMain:ShowTopMenu()
    Tool.loadTopTitle(self.gameObject, TextMap.GetValue("Text_1_307"))
    local row = TableReader:TableRowByID("daxuSetting", 18)
    showCharID = row.arg1
    self.hero:LoadByModelId(showCharID, "idle", function(ctl)
    end, false, -1, row.arg2 / 1000)
    self.desc.text = TextMap.GetValue("Text122")
    self.binding:Hide("boss_info")
    self.binding:Hide("rewardInfo")
    self.binding:Hide("rankInfo")
    local that = self
     REFRESH_TIMER = LuaTimer.Add(0, 5000, function(id)
        Api:checkDaxu(function(result)
            local data = result.daxu
            that.data = data
            m:onUpdate()
        end, function(ret)
            return true
        end)
         return true
     end)
    self.page = 1 --当前页面
    self:setRedTip()
end

function m:OnDestroy()
    LuaTimer.Delete(REFRESH_TIMER)
end

function m:judgeBoxEff()
    self.eff.gameObject:SetActive(false)
    TableReader:ForEachLuaTable("daxuGongxun", function(index, item)
        if item.id == Player.DaXu.gongxunReward[item.id] then
            self.eff.gameObject:SetActive(true)
            return
        end
    end)
end

function m:onUpdate()
    -- self.empty:SetActive(false)
    -- self.list:SetActive(false)
    local daXu = Player.DaXu
    -- if daXu.state == 0 then
    -- 	self.empty:SetActive(true)
    -- 	self.list:SetActive(false)
    -- 	Tool.SetActive(self.btnLeft,false)
    -- 	Tool.SetActive(self.btnRight,false)
    -- 	self.binding:Hide("boss_info")
    -- else
    -- 	self.empty:SetActive(false)
    -- 	self.list:SetActive(true)
    -- 	Tool.SetActive(self.btnLeft,false)
    -- 	Tool.SetActive(self.btnRight,false)

    -- 	self.heroNode1:CallUpdateWithArgs(data[1],self)
    -- 	self.binding:Hide("heroNode2")
    -- 	self.binding:Hide("heroNode3")
    -- 	-- for i = 1, 3 do
    -- 	-- 	self["heroNode"..i]:CallUpdate(i)
    -- 	-- end
    -- end
    local dataAll = self.data
    local dataList = {}
    if dataAll ~= nil then 
        dataList = json.decode(dataAll:toString())
    end

    if #dataList == 0 then
        self.empty:SetActive(true)
       Events.Brocast("FindDaXu")
    else
        self.empty:SetActive(false)
       Events.Brocast("FindDaXu")
    end

    self.list:SetActive(true)

    for i = 1, 3 do
        if dataList[(self.page - 1) * 3 + i] ~= nil then
            self["heroNode" .. i].gameObject:SetActive(true)
            self["heroNode" .. i]:CallUpdateWithArgs(dataList[(self.page - 1) * 3 + i], self)
        else
            self["heroNode" .. i].gameObject:SetActive(false)
        end
    end

    --若下一页无数据，则隐藏下一页按钮
    if dataList[(self.page - 1) * 3 + 4] ~= nil then
        Tool.SetActive(self.btnRight, true)
    else
        Tool.SetActive(self.btnRight, false)
    end

    --若上一页无数据，则隐藏上一页按钮
    if dataList[(self.page - 1) * 3] ~= nil then
        Tool.SetActive(self.btnLeft, true)
    else
        Tool.SetActive(self.btnLeft, false)
    end

    self.txt_gx.text = daXu.gongxun
    self.txt_unrank.text = ""
    local maxDmg = daXu.maxDmg
    self.txt_dps.text = maxDmg
    self.txt_unrank_dps.text = ""
    self.txt_zg.text = Player.Resource.battle_exploit
    self.txt_unrank_zg.text = ""
    m:judgeBoxEff()
end

function m:onExit()
    LuaTimer.Delete(REFRESH_TIMER)
end

function m:onEnter()
    -- m:onUpdate()
    LuaMain:ShowTopMenu()
    self:setRedTip()
    local that = self
    LuaTimer.Delete(REFRESH_TIMER)
    REFRESH_TIMER = LuaTimer.Add(0, 5000, function(id)
        Api:checkDaxu(function(result)
            local data = result.daxu
            that.data = data
            m:onUpdate()
        end, function(ret)
            return true
        end)
        return true
    end)
end

function m:ShowBoss(data)
    if data ~= nil and data.hp > 0 and tonumber(ClientTool.GetNowTime(data.CDTime)) > 0 then
        self.binding:Show("boss_info")
        self.boss_info:CallUpdateWithArgs(data, self)
    else
        MessageMrg.show(TextMap.GetValue("Text122"))
        m:onUpdate()
    end
end

function m:setRedTip()
    self.redSprite:SetActive(Tool.checkRedPoint("gongxun"))
end

function m:onClick(go, name)
    if name == "btn_reward" then
        self.binding:Show("rewardInfo")
        self.rewardInfo:CallUpdate({delegate = self})
    elseif name == "btn_shop" then
        LuaMain:showShop(9)
    elseif name == "btn_rank" then
        self.binding:Show("rankInfo")
        self.rankInfo:CallUpdate({})
    elseif name == "btn_friend" then
        -- MessageMrg.show("功能暂未开放，敬请期待！")
        UIMrg:pushWindow("Prefabs/moduleFabs/friendModule/recommandList")
    elseif name == "btn_go" then
        UIMrg:popToRoot()
        LuaMain:openWithSound(6)
	elseif name == "btnBack" then 
		UIMrg:pop()
    elseif name == "btnLeft" then
        self.page = self.page - 1
        self:onUpdate()
    elseif name == "btnRight" then
        self.page = self.page + 1
        self:onUpdate()
    elseif name == "Btn_buzhen" then
        LuaMain:showFormation(0)
    elseif name == "btn_rules" then
        UIMrg:pushWindow("Prefabs/moduleFabs/qiancengta/qiancengta_rule", {18, title = TextMap.GetValue("Text_1_308")})
	elseif name == "btn_boss" then 
        Api:checkTaoRenBoss(function(result)
            if result.open == true then 
	    	    uSuperLink.openModule(67)
            else 
                MessageMrg.show(TextMap.GetValue("Text_1_155"))
            end 
            end, function(ret)
                return true
            end)
        end
end

return m