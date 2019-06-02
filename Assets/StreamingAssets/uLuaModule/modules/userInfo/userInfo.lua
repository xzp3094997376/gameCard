
-- 玩家信息

local m = {}

local REFRESH_SP_TIMER = "refreshSpTimer"
local REFRESH_VP_TIMER = "refreshVpTimer"
local REFRESH_ZFL_TIMER = "refreshZflTimer"
local ENERGYFULL = TextMap.GetValue("Text1452")
local TIMEUP = TextMap.GetValue("Text1453")
--退出公会
-- function m:onQuitGh(go)
-- end

--更换头像
function m:onChangeHead(go)
    -- self.binding.gameObject:SetActive(false)
    --获取默认头像列表
    UIMrg:pushWindow("Prefabs/moduleFabs/userinfoModule/headerPanel", self)
end

--更换名字
function m:onChangeName(go)
    self.fore = true
    --self.binding.gameObject:SetActive(false)
    UIMrg:pushWindow("Prefabs/moduleFabs/userinfoModule/changeName", self)
end

function m:refresh()
    self:setUserInfo()
end

--关闭此界面 
function m:onDestory()
    self.delegate:refreshUserInfo()
    UluaModuleFuncs.Instance.uTimer:removeSecondTime(REFRESH_SP_TIMER)
    UluaModuleFuncs.Instance.uTimer:removeSecondTime(REFRESH_VP_TIMER)
    UluaModuleFuncs.Instance.uTimer:removeSecondTime(REFRESH_ZFL_TIMER)
    UIMrg:popWindow()
end

-- function m:quit( ... )
--     LuaMain:QuitGame()
-- end

function m:onEnter(...)
    -- print("enter")
    -- Api:checkUpdate(function(res)
    --   print("check")
    --     self:setUserInfo()
    -- end)
    --self.binding.gameObject:SetActive(true)
end

function m:onSysSetting()
    --  self.binding.gameObject:SetActive(false)
    UIMrg:pushWindow("Prefabs/moduleFabs/userinfoModule/setting_new", {})
end

function m:onClick(go, name)

    if name == "btn_changename" then
        self:onChangeName(go)
    elseif name == "btn_changehd" then
        self:onChangeHead(go)
        -- elseif name == "btn_quit_gh" then
        --     self:onQuitGh(go)
    elseif name == "btn_Close" then
        self:onDestory()
    elseif name == "btn_Setting" then
        self:onSysSetting() --系统设置
        -- elseif name == "btquit" then
        --     -- self:quit()
    elseif name == "btn_userCenter" then
        --mysdk:userCenter("userCenter")
    end
end

function m:update(table)
    self.delegate = table.delegate
	self:setUserInfo()
    Api:checkUpdate(function(res)
        self:setUserInfo()
    end)
end

function m:setUserInfo()
    self.player = Player.Info
    local leader = Player.Info
    local bag = Player.Resource
    local pre = 1
    local i = 0
	--print_t(Player.CdTime:getLuaTable())
    if leader.level > 1 then
        pre = TableReader:TableRowByUnique("charExp", "lv", leader.level - 1).exp[i]
    end
    local tb = TableReader:TableRowByUnique("charExp", "lv", leader.level)
    local exp_d = tb.exp_d[i]
    local head = leader.head
    self.playerID = Player.playerId
    --    print("playerID"..self.playerID)
    self.nickname = leader.nickname
    local img = leader.head
    if head == "" then head = "default" end
    local desc = TextMap.GetValue("Text1367") .. leader.level .. "\n"
    self.txt_lv.text =  leader.level 
    self.coloredSlider.value = (bag.exp - pre) / exp_d
	local e = (bag.exp - pre)
	if e < 0 then e = 0 end 
    self.txt_exp.text = e .. "/" .. exp_d
    self.txt_vipnum.text = "VIP " .. leader.vip
	m:setPower()
	m:setHead()
	m:setDes()
	
	m:setName(leader.nickname)
    local cdTime = Player.CdTime["bp_inc"]
    local maxBp = Player.Resource.max_bp
	local maxVp = Player.Resource.max_vp
    local maxZfl = Player.Resource.max_daxu_point
    local bp = Player.Resource.bp
	local vp = Player.Resource.vp
    local zfl = Player.Resource.daxu_point
	
	local vp_reg = TableReader:TableRowByID("trsRobConfig", "vp_reg").value
	local vp_val = string.gsub(vp_reg, "m", "")
    print("vp_val:"..vp_val)
	local vp_cd = Player.CdTime["vp_inc"]
    local vp_times = ClientTool.GetNowTime(vp_cd)
	local vp_sec = tonumber(vp_val) * 60 * (maxVp - vp - 1) + vp_times
	self.vp_time = vp_times or 0

    
    --精力
    if self.vp_time <=0 then 
        self:updateVpTime()
    else
        UluaModuleFuncs.Instance.uTimer:removeSecondTime(REFRESH_VP_TIMER)
        UluaModuleFuncs.Instance.uTimer:secondTime(REFRESH_VP_TIMER, 1, 0, self.updateVpTime, self) --定时器
    end
    --self.delegate.refreshUserInfo()

    if os.time() >= os.time() + vp_sec then
        UluaModuleFuncs.Instance.uTimer:removeSecondTime(REFRESH_VP_TIMER)
        self.txt_jingli_huifu.text = TextMap.GetValue("Text_1_2829")
    else
        self.vp_finish_time = m:timeStr(vp_sec)
    end
    --

	--征伐令
	-- local point_reg = TableReader:TableRowByID("daxuSetting", "type", "time").arg1
	-- local point_val = string.gsub(point_reg, "h", "")
    local zfl_reg = TableReader:TableRowByID("daxuSetting", 17).arg1
    local zfl_val = string.gsub(zfl_reg, "h", "")
    local zfl_cd =  Player.CdTime["daxu_point_inc"]
    local zfl_times = ClientTool.GetNowTime(zfl_cd)
    local zfl_sec = tonumber(zfl_val) * 3600 * (maxZfl - zfl - 1) + zfl_times
    self.zfl_time = zfl_times or 0

    if self.zfl_time <=0 then 
        self:updateZflTime()
    else
        UluaModuleFuncs.Instance.uTimer:removeSecondTime(REFRESH_ZFL_TIMER)
        UluaModuleFuncs.Instance.uTimer:secondTime(REFRESH_ZFL_TIMER, 1, 0, self.updateZflTime, self) --定时器
    end
    --self.delegate.refreshUserInfo()

    if os.time() >= os.time() + zfl_sec then
        UluaModuleFuncs.Instance.uTimer:removeSecondTime(REFRESH_ZFL_TIMER)
        self.txt_zhengtao_huifu.text = TextMap.GetValue("Text_1_2830")
    else
        self.zfl_finish_time = m:timeStr(zfl_sec)
    end

    --
	
    --体力
	local arg = TableReader:TableRowByID("systemConfig", "bp_inc_interval").value
	local val = string.gsub(arg, "m", "")
    local time = ClientTool.GetNowTime(cdTime)
	local sec = tonumber(val) * 60 * (maxBp - bp - 1) + time
    self.sp_time = time or 0
    --    print("sp "..self.sp_time)
    if self.sp_time <= 0 then --时间已经到了就显示0点
		self:updateSpTime()
    else --否则用定时器倒计时
		UluaModuleFuncs.Instance.uTimer:removeSecondTime(REFRESH_SP_TIMER)
		UluaModuleFuncs.Instance.uTimer:secondTime(REFRESH_SP_TIMER, 1, 0, self.updateSpTime, self) --定时器
    end
    self.delegate:refreshUserInfo()
	if os.time() >= os.time() + sec then 
		UluaModuleFuncs.Instance.uTimer:removeSecondTime(REFRESH_SP_TIMER)
        self.txt_tili_huifu.text = TextMap.GetValue("Text_1_2831")
	else 
		self.bp_finish_time = m:timeStr(sec)
	end 
    --
end
-- 设置名字
function m:setName(name)
	local char = Char:new(Player.Info.playercharid)
    local nameStr = Char:getItemColorName(char.star, name)
    if nameStr ~= nil then
        self.nameTxt.text = nameStr
    else
        --    MessageMrg.show("vip头像表出错")
        return
    end
end
function m:timeStr(finish)
	local str = ""
	local day = os.date("%d", os.time()) 
	local fday = os.date("%d", os.time() + finish)  
	local ftime = os.date("%X", os.time() + finish)  
	if day == fday then 
		str = TextMap.GetValue("Text_1_2832")..ftime
	elseif fday > day then 
		str = TextMap.GetValue("Text_1_2833")..ftime
	else 
		str = ftime
	end 
	return str
end 

--设置详细信息
function m:setDes()
	self.txt_diamond.text = TextMap.GetValue("Text_1_2834") .. toolFun.moneyNumberShowOne(math.floor(tonumber(Player.Resource.gold)))
	self.txt_coin.text = TextMap.GetValue("Text_1_2835") .. toolFun.moneyNumberShowOne(math.floor(tonumber(Player.Resource.money)))
	self.txt_renhun.text = TextMap.GetValue("Text_1_2836") .. toolFun.moneyNumberShowOne(math.floor(tonumber(Player.Resource.hunyu)))
	self.txt_shengwang.text = TextMap.GetValue("Text_1_2837") .. toolFun.moneyNumberShowOne(math.floor(tonumber(Player.Resource.credit)))
	self.txt_zhangong.text = TextMap.GetValue("Text_1_2838") .. toolFun.moneyNumberShowOne(math.floor(tonumber(Player.Resource.battle_exploit)))
	self.txt_gongxian.text = TextMap.GetValue("Text_1_2839") .. toolFun.moneyNumberShowOne(math.floor(tonumber(Player.Resource.donate)))
	self.txt_jingli_title.text = TextMap.GetValue("Text_1_2840")
	self.txt_tili_title.text = TextMap.GetValue("Text_1_2841") 
	self.txt_zhengtao_title.text = TextMap.GetValue("Text_1_2842")
    self.txt_jingli_value.text =  toolFun.moneyNumberShowOne(math.floor(tonumber(Player.Resource.vp))) .. "/" .. Player.Resource.max_vp
    self.txt_tili_value.text = toolFun.moneyNumberShowOne(math.floor(tonumber(Player.Resource.bp))) .. "/" .. Player.Resource.max_bp
    self.txt_zhengtao_value.text = toolFun.moneyNumberShowOne(math.floor(tonumber(Player.Resource.daxu_point))) .. "/" .. Player.Resource.max_daxu_point
end 

--设置头像
function m:setHead()
	local char = Char:new(Player.Info.playercharid)
	local img = char:getHeadSpriteName()
    self.headImg:setImage(img, packTool:getIconByName(img))
	self.imgFrame.spriteName = char:getFrame()
    self.headBgImg.spriteName = char:getFrameBG()
end 

--设置战力
function m:setPower()
    local t = Player.Team[0]
    local teams = t.chars
    local power = 0
    if power == 0 then
        for i = 0, 5 do
            if teams.Count > i then
                if teams[i .. ""] ~= 0 and teams[i .. ""] ~= "0" then
                    local last_char = Char:new(teams[i .. ""])
                    power = power + last_char.power
                end
            end
        end
    end
    self.txt_power.text = power
end

function m:updateZflTime()
    if self.zfl_time > 0 then
        local time = Tool.FormatTime(self.zfl_time)
        self.txt_zhengtao_huifu.text = TextMap.GetValue("Text_1_2843") .. time .. TextMap.GetValue("Text_1_2844") .. self.zfl_finish_time
    end
    local cdTime = Player.CdTime["daxu_point_inc"]
    local time = ClientTool.GetNowTime(cdTime)
    local maxZfl = Player.Resource.max_daxu_point
    local Zfl = Player.Resource.daxu_point
    self.zfl_time = time
end

function m:updateVpTime()
    if self.vp_time > 0 then
        local time = Tool.FormatTime(self.vp_time)
        self.txt_jingli_huifu.text = TextMap.GetValue("Text_1_2845") .. time .. TextMap.GetValue("Text_1_2846") .. self.vp_finish_time
    end
    local cdTime = Player.CdTime["vp_inc"]
    local time = ClientTool.GetNowTime(cdTime)
    local maxVp = Player.Resource.max_vp
    local vp = Player.Resource.vp
    self.vp_time = time
end

function m:updateSpTime()

    if self.sp_time > 0 then
        --      print("read cd  time"..self.sp_time)
        local time = Tool.FormatTime(self.sp_time)
        self.txt_tili_huifu.text = TextMap.GetValue("Text_1_2847") .. time .. TextMap.GetValue("Text_1_2848") .. self.bp_finish_time
    end
    local cdTime = Player.CdTime["bp_inc"]
    --  print("cd Time "..cdTime)
    local time = ClientTool.GetNowTime(cdTime)
    local maxBp = Player.Resource.max_bp
    local bp = Player.Resource.bp
    --print("cd Time "..cdTime)
    --local time = ClientTool.GetNowTime(cdTime)
    --if maxBp > bp then
    --    time = time + (maxBp - bp - 1) * 6 * 60
    --end
    self.sp_time = time
end


function m:Start()
    -- ClientTool.AddClick(self.bg, function()
    --     UIMrg:popWindow()
    -- end)
end

function m:create()
    return self
end

return m