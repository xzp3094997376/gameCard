local mainUI = {}
-- 主面ui

-- 充值
function mainUI:onCharge()
    --    SendBatching.OpenOrCloseModule('YOUWANT', "Prefabs/moduleFabs/alertModule/youwant", { 0 }, function() end)
    --Tool.push("purchase", "Prefabs/moduleFabs/vipModule/vip")
    Tool.push("activity", "Prefabs/moduleFabs/activityModule/activity_vip",{"","vip"})
end

-- 签到
function mainUI:onSin()
    UIMrg:pushWindow("Prefabs/moduleFabs/signModule/sign", {})
end

-- 公告
function mainUI:onNotice()
    -- print("公告")
    UIMrg:pushWindow("Prefabs/moduleFabs/noticeModule/xiTongGongGao", {}) --打开通知界面
end

--删档活动
function mainUI:onAct(...)
    Tool.push("activity", "Prefabs/moduleFabs/activityModule/moduleActivity",{"","common"})
end

-- 设置等级
function mainUI:setLevel(lv)
    self.txt_lvlnum.text = lv
end

-- 设置名字
function mainUI:setName(name)
	local char = Char:new(Player.Info.playercharid)
    local nameStr = Char:getItemColorName(char.star, name)
    if nameStr ~= nil then
        self.txt_name.text = nameStr
    else
        --    MessageMrg.show("vip头像表出错")
        return
    end
end


--根据vip不同显示不同的vip框和名字颜色
function mainUI:setVIPFrame(vip)
    local frame = Tool.getVIPHeadK(vip)
    if frame ~= nil then

        --self.bg.spriteName = frame
        --self.level_sprite.spriteName = frame .. "_1"
    else
        --    MessageMrg.show("vip头像表出错")
        return
    end
end

-- 设置vip
function mainUI:setVip(vip)
    self.txt_vipnum.text = "VIP " .. vip
    ClientTool.AddClick(self.txt_vipnum.transform, function()
        Tool.push("activity", "Prefabs/moduleFabs/activityModule/activity_vip",{"","vip"})
    end)
end

--设置经验进度
function mainUI:setExpProgress(leader)
    local bag = Player.Resource
    local pre = 1
    local i = 0
    if leader.level > 1 then
        pre = TableReader:TableRowByUnique("charExp", "lv", leader.level - 1).exp[i]
    end
    local tb = TableReader:TableRowByUnique("charExp", "lv", leader.level)
    local exp_d = tb.exp_d[i]
    self.expSlider.value = (bag.exp - pre) / exp_d
	local e = (bag.exp - pre)
	if e < 0 then e = 0 end 
	self.txtExp.text =  e .. "/" .. exp_d
end

--设置战力
function mainUI:setPower()
    local t = Player.Team[0]
    local teams = t.chars
    local power = 0
    if power == 0 then
        for i = 0, 5 do
            if teams.Count > i then
                if teams[i .. ""] ~= 0 and teams[i .. ""] ~= "0" then
                    local last_char = Char:new( teams[i .. ""])
                    power = power + last_char.power
                end
            end
        end
    end
    self.txt_power.text = toolFun.moneyNumber(power)
	local petId = Player.Team[0].pet
	if petId ~= nil and petId ~= 0 then
		local pet = Pet:new(petId)
		self.txt_pet_power.text = toolFun.moneyNumber(pet.power)
		self.pet:SetActive(true)
	else 
		self.pet:SetActive(false)
	end 
end

function mainUI:onRecycle(go)
    Tool.push("recycle", "Prefabs/moduleFabs/recycleModule/recycle", {})
end

function mainUI:onFriend(go)
    --Tool.push("friend", "Prefabs/moduleFabs/friendModule/friend_all", {})
    uSuperLink.openModule(120)
end

--日常
function mainUI:onRiChang()
    uSuperLink.openModule(219)
end

--成就
function mainUI:onChengJiu()
    --   Tool.push("questModule", "Prefabs/moduleFabs/questModule/quest_main", { "grow" })
    --	 Tool.push("questModule", "Prefabs/moduleFabs/achievementModule/moduleTask", { "1" })
	UIMrg:push("task", "Prefabs/moduleFabs/achievementModule/gui_task", {})
end

--公会--测试
function mainUI:onLeague()
    GuildDatas:EnterLeague()
end

function mainUI:onClick(go, btnName)
	print(btnName)
    if btnName == "btn_ChongZhi" then
        self:onCharge()
    elseif btnName == 'btn_GongGao' then
        self:onNotice()
    elseif btnName == 'btn_richang' then
        self:onRiChang()
	elseif btnName == "btn_zhengzhan" then 
		self:onZhengZhan(go)
    --elseif btnName == 'btn_chengjiu' then
    --    self:onChengJiu()
    elseif btnName == "head" then
        self:showInfo()
    elseif btnName == "btn_ACTI" then
        self:onAct()
    -- elseif btnName == "btn_day_frist" then
    --     mainUI:onDayFrist()
    elseif btnName == "btn_vip" then
        mainUI:onVip()
    elseif btnName == "btn_grow" then
        mainUI:onGrow()
    elseif btnName == "btn_frist" then
        mainUI:onFrist()
    elseif btnName == "btn_huishou" then
        self:onRecycle(go)
    elseif btnName == "btn_goodfriend" then
        self:onFriend(go)
    elseif btnName == "btn_league" then
        self:onLeague(go)
    elseif btnName == "btn_VipShop" then
        self:openVipShop(go)
    elseif btnName == "btn_welfare" then
        self:onWelfare()
    elseif btnName == "btn_kaifu" then
        self:onKaifu()
    elseif btnName == "btn_target" then
        self:onTarget()
    elseif btnName == "btn_reward" then
        if Tool:judgeBagCount(self.dropTypeList) == false then return end
        self:onTargetGet()
	elseif btnName == "btn_mail" then 
	    --邮箱
        --self:onMail()
		LuaMain:openWithSound(51)
	elseif btnName == "btn_setting" then 
		self:onSysSetting()
    elseif btnName == "btn_love" then
        Tool.push("activity", "Prefabs/moduleFabs/activityModule/moduleActivity", {"","like"})
    elseif btnName == "btn_dengji" then
        Tool.push("activity", "Prefabs/moduleFabs/activityModule/activity_gradeGift",{"","grade"})
        -- local act = Player.Activity.d
        -- if act then
        --     local item
        --     if ret or (not ret and act:ContainsKey("lvlup")) then
        --         item = act.lvlup 
        --     end
        --     if item then
        --         Tool.push("activity", "Prefabs/moduleFabs/activityModule/activity_gradeGift", { mainUI:getActIdByEvent("lvlup"),item.e})
        --     end
        -- end 
    elseif btnName == "btn_jiere" then
        Tool.push("activity", "Prefabs/moduleFabs/activityModule/holiday/activity_holiday",{"","holiday"})
        --UIMrg:push("SevenDay", "Prefabs/moduleFabs/activityModule/SevenDay", {type = self.actType})--day7, day14, offyear, SpringFestival
    elseif btnName == "btn_denglusongli" then
        UIMrg:push("SevenDay", "Prefabs/moduleFabs/activityModule/SevenDay", {type = self.qiriActType})--day7, day14, offyear, SpringFestival
        --Tool.push("activity", "Prefabs/moduleFabs/activityModule/holiday/activity_holiday",{"","openSv"})
    --[[elseif btnName == "btn_yueka" then
        local act = Player.Activity.d
        if act then
            local item
            if ret or (not ret and act:ContainsKey("monthCard")) then
                item = act.monthCard 
            end
            if item then
                Tool.push("activity", "Prefabs/moduleFabs/activityModule/moduleActivity", { mainUI:getActIdByEvent("monthCard"),item.e})
            end
        end ]]--
    elseif btnName == "btn_shouchong" then
        local act = Player.Activity.d
        if act then
            local item
            if ret or (not ret and act:ContainsKey("firstPayGift")) then
                item = act.firstPayGift 
            end
            if item then
                Tool.push("activity", "Prefabs/moduleFabs/activityModule/moduleActivity", { mainUI:getActIdByEvent("firstPayGift"),item.e})
            end
        end 
    end
end

--征战
function mainUI:onZhengZhan(go)
	uSuperLink.openModule(70)
end

function mainUI:onMail()
	local superID = 51
	local linkData = Tool.readSuperLinkById( superID)
    --超链接的等级限制
    if linkData == nil then
        MessageMrg.show(TextMap.GetValue("Text142") .. superID)
        return nil
    else
        local moduleName = linkData.arg[0] --模块名
		local counts = linkData.arg.Count
        local args = {}
        if counts > 1 then
            for i = 1, counts - 1 do
                args[i] = linkData.arg[i]
            end
        end
        linkData = nil
		
		if moduleName ~= nil then 
			uSuperLink.open(moduleName, args, 1)
		else
			MessageMrg.show(TextMap.GetValue("Text142") .. superID) 
		end 		
	end
end 

function mainUI:onSysSetting()
    --  self.binding.gameObject:SetActive(false)
    UIMrg:pushWindow("Prefabs/moduleFabs/userinfoModule/setting_new", {})
end

function mainUI:openVipShop()
    local uluabing = Tool.push("shop", "Prefabs/moduleFabs/puYuanStoreModule/shop")
    local args = { 5 }
    uluabing:CallUpdate(args)
end

function mainUI:onSysSetting()
    UIMrg:pushWindow("Prefabs/moduleFabs/userinfoModule/setting_new", {})
end

function mainUI:refreshUserInfo()
    local leader = Player.Info
    --local img = leader.head
    --if img == "" then img = "default" end
	local char = Char:new(Player.Info.playercharid)
	local img = char:getHeadSpriteName()
    self.headImg:setImage(img, packTool:getIconByName(img))
	self.imgFrame.spriteName = char:getFrame()
	self.img_bg.spriteName = char:getFrameBG()

    self:setLevel(leader.level)
    self:setVip(leader.vip)
    self:setExpProgress(leader)
    self:setVIPFrame(leader.vip)
    self:setName(leader.nickname)
    self:setPower()
end

--初始化
function mainUI:create(binding)
    self.binding = binding
    return self
end

function mainUI:showInfo()
    local _table = {}
    _table.delegate = self
    UIMrg:pushWindow("Prefabs/moduleFabs/userinfoModule/userinfo", _table)
end

function mainUI:Start()
    --好友按钮
    --self.btn_goodfriend.gameObject:SetActive(false)
    --local that = self
    --Api:getNoticeInfo(function(result)
    --    if result.info == TextMap.GetValue("Text1318") or result.info == "" then
    --        that.btn_GongGao.gameObject:SetActive(false)
    --    else
    --        that.btn_GongGao.gameObject:SetActive(true)
    --    end
    --end)

    --设置好友刷新时间
    self:setFriendRecommendTime()
end

function mainUI:update()
    self:refreshUserInfo()
    --self.red_point_for_richange:SetActive(Tool.checkRedPoint("active"))
    --self.red_point_for_chengjiu:SetActive(Tool.checkRedPoint("task"))
    print(type(Player.chars))
    mainUI:initActive()
    self:refreshTarget()
    self.dropTypeList = {}
	if self.cur_target ~= nil then 
		local ss = TableReader:TableRowByID("allTasks", self.cur_target.id)
		for i = 0, 10 do
			if ss.drop[i] ~= nil and ss.drop[i].type ~= nil then
				table.insert(self.dropTypeList, ss.drop[i].type)
			end
		end
	end 
    -- self.btn_jiere.gameObject:SetActive(false)--这里需要判断当前的活动那个，更换图标
    -- self.actType = "offyear"
    -- if mainUI:judgeNewQiriIsClose("offyear") then
    --     self.btn_jiere.gameObject:SetActive(true)
    --     self.sprite_jiere.spriteName = "icon_xiaonianxinyu"
    --     self.actType = "offyear"
    -- elseif mainUI:judgeNewQiriIsClose("SpringFestival") then
    --     self.btn_jiere.gameObject:SetActive(true)
    --     self.sprite_jiere.spriteName = "icon_xinchunhesui"
    --     self.actType = "SpringFestival"
    -- elseif mainUI:judgeNewQiriIsClose("yuanxiaojie") then
    --     self.btn_jiere.gameObject:SetActive(true)
    --     self.sprite_jiere.spriteName = "icon_yuanxiaoxile"
    --     self.actType = "yuanxiaojie"
    -- end

    if holiday_open~=nil and holiday_open==true then 
        self.sprite_jiere.spriteName = holiday_icon
        self.btn_jiere.gameObject:SetActive(true)
    else 
        self.btn_jiere.gameObject:SetActive(false)
    end
    if like_open~=nil and like_open==true then 
        self.btn_love.gameObject:SetActive(true)
    else 
        self.btn_love.gameObject:SetActive(false)
    end
    self.red_point_for_love:SetActive(Tool.checkRedPoint("like"))
    self.red_activity:SetActive(Tool.checkRedPoint("activity"))
    self.red_point_for_welfare:SetActive(Tool.checkRedPoint("fuli"))
    self.red_point_for_chengjiu:SetActive(Tool.checkRedPoint("recharge"))
    self.red_point_for_jiere:SetActive(Tool.checkRedPoint("holiday"))
    self.red_point_for_dengji:SetActive(Tool.checkRedPoint("grade"))
    self.red_point_vip:SetActive(Tool.checkRedPoint("vip"))
end


function mainUI:showOrHide(go, ret)
    if go == nil then return end
    if ret then
        go:SetActive(true)
    else
        go:SetActive(false)
    end
end

--设置好友刷新时间
function mainUI:setFriendRecommendTime()
    local row = TableReader:TableRowByID("FriendConfig", 6) --刷新时间id为1
    row = json.decode(row:toString())
    local refreshTime = row.args2
    --好友
    require("uLuaModule/modules/friends/friendUtil.lua")


    friendUtil.SetRecommendRefreshTime(refreshTime)
end

--好友小红点是否显示
function mainUI:setFriendRedPoint()
    --self.red_point_for_more.gameObject::SetActive(Tool.checkRedPoint("friend"))--并没有该红点，好友红点在其他脚本
end

function mainUI:checkActButton(show, hide, redPoint, state)
    mainUI:showOrHide(show, state ~= 2)
    mainUI:showOrHide(hide, false)
    mainUI:showOrHide(redPoint, state == 1)
    --    print(redPoint .. " state:"..state.." ->"..1)
end

function mainUI:judgeQiriIsClose()
    local state = false
    local tab = Player.Day7s.time / 1000
    local now = os.time()
    if now > tab then
        state = false
        return state
    else
        state = true
        return state
    end
    return state
end

function mainUI:judgeNewQiriIsClose(actType)
    local state = true
    -- print("判断活动类型："..actType)
    -- print_t(Player.DayNs[actType].actState)
    if Player.DayNs[actType].actState == 1 then
         --print(actType..":开启")
        state = true
    else
         --print(actType..":尚未开启或已结束")
        state = false
    end
    -- local tabStar = 0
    -- local tabEnd = 0
    -- if Player.DayNs ~= nil then
    --     tabStar = Player.DayNs[actType].startTime / 1000
    --     tabEnd = Player.DayNs[actType].endTime / 1000
    -- end
    -- local now = os.time()
    -- print("判断活动类型："..actType)
    -- if tabStar < now and now < tabEnd then
    --     print(actType..":开启")
    --     state = false--true
    --     return state
    -- else
    --     print(actType..":尚未开启，开启时间为:"..Tool.getFormatTime(tonumber(tabStar)))
    --     state = true--false
    --     return state
    -- end
    return state
end

--初始化活动
function mainUI:initActive()
    -- self.btn_denglusongli.gameObject:SetActive(openSv_open)
    -- if openSv_open then
    --     self.sprite_denglusongli.spriteName = openSv_icon
    -- end 
    local act = Player.Activity.d
    self.qiriActType = "day7"
    self.btn_denglusongli.gameObject:SetActive(false)
    if mainUI:judgeQiriIsClose() then
        self.btn_denglusongli.gameObject:SetActive(true)
        self.qiriActType = "day7"
    elseif mainUI:judgeNewQiriIsClose("Day14s") then
        self.btn_denglusongli.gameObject:SetActive(true)
        self.sprite_denglusongli.spriteName = "icon_shisitianqing"
        self.qiriActType = "Day14s"
    end


    if act then
        -- local sendActBylevel
        -- if ret or (not ret and act:ContainsKey("sendActBylevel")) then
        --     sendActBylevel = act.sendActBylevel 
        -- end

        -- if sendActBylevel then
        --     mainUI:checkActButton(self.btn_love.gameObject, nil, self.red_point_for_love.gameObject, sendActBylevel.f)
        -- end

        -- local lvlup
        -- if ret or (not ret and act:ContainsKey("lvlup")) then
        --     lvlup = act.lvlup 
        -- end

        -- if lvlup then
        --     mainUI:checkActButton(self.btn_dengji.gameObject, nil, self.red_point_for_dengji.gameObject, lvlup.f)
        -- end

        -- local dailyGift
        -- if ret or (not ret and act:ContainsKey("dailyGift")) then
        --     dailyGift = act.dailyGift 
        -- end

        -- if dailyGift then
        --     mainUI:checkActButton(self.btn_changwan.gameObject, nil, self.red_point_for_changwan.gameObject, dailyGift.f)
        -- end

        -- local firstPayGift
        -- if ret or (not ret and act:ContainsKey("firstPayGift")) then
        --     firstPayGift = act.firstPayGift --首充
        -- end

        -- if firstPayGift then
        --     mainUI:checkActButton(self.btn_shouchong.gameObject, nil, self.red_point_for_shouchong.gameObject, firstPayGift.f)
        --     --self.btn_yueka.gameObject:SetActive(false)
        -- end

        --if firstPayGift==nil or firstPayGift.f==nil or firstPayGift.f ==2 then 
        --    local monthCard
        --    if ret or (not ret and act:ContainsKey("monthCard")) then
        --        monthCard = act.monthCard --月卡
        --    end
        --
        --    if monthCard then
        --        mainUI:checkActButton(self.btn_yueka.gameObject, nil, self.red_point_for_yueka.gameObject, monthCard.f)
        --    end
        --end 
    end
end

function mainUI:getActIdByEvent(id)
    local act = Player.Activity.d
    if act and act[id] then
        return act[id].i
    end
    return "0"
end

--刷新新的目标
function mainUI:refreshTarget()
    local playerTasks = Player.Tasks:getLuaTable() --玩家身上的所有任务
    self.target_list = {}
    table.foreach(playerTasks, function(k, v)
		--print_t(v)
		local ret = Tool.checkTarget(k)
		--print("id = " .. k .. "  state = " .. v.state .. "  ret = " .. tostring(ret))
        if ret == true and (v.state.."" == "0" or v.state.."" == "2" or v.state == nil )then  -- 筛选出已接受且未完成的目标或已完成且未领取的目标
            local item = {}
            item.id = k
            item.value = v
            local index = string.gsub(k, "tg", "")
            item.index = tonumber(index)
            table.insert(self.target_list,item)
        end
    end)
	--print("______________v = " .. #self.target_list)
    --排序
    table.sort(self.target_list, function (a,b)
        return a.index < b.index
    end )

    local count = #self.target_list
    if count < 1 then      --若当前没有接受的目标，直接隐藏目标按钮
        self.target_obj:SetActive(false)
    else                          --显示出当前的第一条目标
        self.target_obj:SetActive(true)
        local text = TableReader:TableRowByID("allTasks", self.target_list[1].id).show_name
        local complete = self.target_list[1].value.complete:getLuaTable()
        for type, value in pairs(complete) do
            self.target_list[1].total = value.total
            self.target_list[1].progress = value.progress
        end
        self.txt_target.text = text.."  [00ff00]"..self.target_list[1].progress.."/"..self.target_list[1].total.."[-]"

        if self.target_list[1].value.state.."" == "2" then --已完成未领取
            self.btn_target.gameObject:SetActive(false)
            self.btn_reward.gameObject:SetActive(true)
        else                                                                  --已接受未完成
            self.btn_target.gameObject:SetActive(true)
            self.btn_reward.gameObject:SetActive(false)
        end
        self.cur_target = self.target_list[1]
    end
end

------------------------------------------- 为活动加入新的快速入口---------------------------------------------------
function mainUI:onFrist()
    local act = Player.Activity.d
    if act then
        local item
        if ret or (not ret and act:ContainsKey("firstPayGift")) then
            item = act.firstPayGift 
        end
        if item then
            Tool.push("activity", "Prefabs/moduleFabs/activityModule/moduleActivity", { mainUI:getActIdByEvent("firstPayGift"),item.e})
        end
    end 
end

function mainUI:onDayFrist()
    local act = Player.Activity.d
    if act then
        local item
        if ret or (not ret and act:ContainsKey("dailyFirstPay")) then
            item = act.dailyFirstPay 
        end
        if item then
            Tool.push("activity", "Prefabs/moduleFabs/activityModule/moduleActivity", { mainUI:getActIdByEvent("dailyFirstPay"),item.e})
        end
    end 
end

function mainUI:onVip()
    local act = Player.Activity.d
    if act then
        local item
        if ret or (not ret and act:ContainsKey("vipGift")) then
            item = act.vipGift 
        end
        if item then
            Tool.push("activity", "Prefabs/moduleFabs/activityModule/moduleActivity", { mainUI:getActIdByEvent("vipGift"),item.e})
        end
    end 
end

function mainUI:onGrow()
    local act = Player.Activity.d
    if act then
        local item
        if ret or (not ret and act:ContainsKey("investPlan")) then
            item = act.investPlan 
        end
        if item then
            Tool.push("activity", "Prefabs/moduleFabs/activityModule/moduleActivity", { mainUI:getActIdByEvent("investPlan"),item.e})
        end
    end 
end

function mainUI:onYuka()
    local act = Player.Activity.d
    if act then
        local item
        if ret or (not ret and act:ContainsKey("monthCard")) then
            item = act.monthCard 
        end
        if item then
            Tool.push("activity", "Prefabs/moduleFabs/activityModule/moduleActivity", { mainUI:getActIdByEvent("monthCard"),item.e})
        end
    end 
end

--福利
function mainUI:onWelfare()
    Tool.push("activity", "Prefabs/moduleFabs/activityModule/moduleActivity", {"","fuli"})
end

--开服大礼包
function mainUI:onKaifu()
    Tool.push("activity", "Prefabs/moduleFabs/activityModule/moduleActivity", {"","openSv"})
end

--目标
function mainUI:onTarget()
    -- print("弹出目标面板")
-- self.goID = TableReader:TableRowByID("allTasks", self.cur_target.id).jump
    -- uSuperLink.openModule(self.goID)
    local data = self.cur_target
    UIMrg:pushWindow("Prefabs/moduleFabs/achievementModule/target_info", {data = data, type = 1, delegate = self})
end

--目标达成，领取奖励
function mainUI:onTargetGet()
    if self.cur_target == nil then return end
	local data = self.cur_target
	UIMrg:pushWindow("Prefabs/moduleFabs/achievementModule/target_info", {data = data, type = 2, delegate = self})
    -- Api:submitTask(self.cur_target.id,function (result)
    --     UIMrg:pushWindow("Prefabs/moduleFabs/achievementModule/target_reward", {})
    -- end)
    
    --local that = self
    --Api:submitTask(self.cur_target.id, function(result)
    --    print("领取成功")
    --    packTool:showMsg(result, nil,2)
    --    --UIMrg:popWindow()
	--	self:refreshTarget()
        -- DialogMrg.levelUp()
        --local info = {}
        --info.drop = RewardMrg.getList(result) --self.drop
        --info.data = that.cur_target
        --local charList = {}
        --table.foreach(info.drop, function(i, v)
        --    if v:getType() == "char" then
        --        table.insert(charList, v)
        --    end
        --end)
        --info.delegate = that
        --if #charList == 0 then
        --    UIMrg:pushWindow("Prefabs/moduleFabs/achievementModule/target_reward", info)
        --    info = nil
        --else
        --    packTool:showChar(charList, function()
        --        self.binding:CallManyFrame(function()
        --            UIMrg:pushWindow("Prefabs/moduleFabs/achievementModule/target_reward", info)
        --            info = nil
        --        end, 2)
        --    end)
        --end
    --end)
end

return mainUI