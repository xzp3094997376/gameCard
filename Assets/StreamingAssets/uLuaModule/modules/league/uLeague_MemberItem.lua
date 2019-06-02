-- 申请成员列表页面下的一个item项


local m = {}

function m:update(data, index, delegate)
    self.data = data
    self.delegate = delegate
    self:setData(data)
end

function m:setData(data)
    --self.img_touxiang.spriteName = data.	-- 缺少数据
    self.img_touxiang:setImage(data.icon, packTool:getIconByName(data.icon))
    self.txt_lv.text = tostring(data.level)
    self.txt_mingzi.text = data.nickname
    self.txt_zhanli.text = tostring(data.fight)
    self.txt_gongxian.text = tostring(data.contribution)
    --self.txt_lixian.text = data.offlineTime
    self:setLiXianStatus(data.offlineTime)
    if data.job == 1 then
        self.img_zhiwu.spriteName = "wfta_ltsf_01"
    elseif data.job == 2 then
        self.img_zhiwu.spriteName = "wfta_ltsf_02"
    else
        self.img_zhiwu.spriteName = "wfta_ltsf_04"
    end
    self:showBtns()
end

function m:setLiXianStatus(offlineTime)
    if offlineTime == 0 then
        self.txt_lixian.text = TextMap.GetValue("Text1257")
    elseif offlineTime == -1 then
        self.txt_lixian.text = TextMap.GetValue("Text1258")
    else
        local now = os.date("*t")
        local offtime = os.date("*t", offlineTime / 1000)
        if now.year > offtime.year or now.month > offtime.month then
            self.txt_lixian.text = TextMap.GetValue("Text1258")
        else
            local strTime = self:getFormatTime(tonumber(offlineTime) / 1000)
            print(strTime)
            if now.day > offtime.day then
                self.txt_lixian.text = string.gsub(TextMap.GetValue("LocalKey_718"),"{0}",now.day - offtime.day)
            else
                if now.hour > offtime.hour then
                    self.txt_lixian.text = string.gsub(TextMap.GetValue("LocalKey_719"),"{0}",now.hour - offtime.hour)
                else
                    if now.min > offtime.min then
                        self.txt_lixian.text = string.gsub(TextMap.GetValue("LocalKey_720"),"{0}",now.min - offtime.min)
                    else
                        self.txt_lixian.text = TextMap.GetValue("Text1262")
                    end
                end
            end
        end
    end
end

-- 自己的职位和成员职位来显示不同的按钮
-- 这里要稍微说明一下：
-- 我是会长：--看到自己	--上-无 	中-无 		下-无
--看到副会长 --上-解除 	中-无  		下-踢出
--看到成员 	--上-任命 	中-无  		下-踢出

-- 我是副会长--看到自己	--上-无 	中-退出 	下-无
--看到会长 	--上-无 	中-弹劾  	下-无
--看到副会长  --上-无 	中-无   	下-无
--看到成员 	--上-无 	中-踢出	下-无

-- 我是成员：--看到自己	--上无 	  	中-退出	下-无
--看到会长 	--上-无 	中-弹劾  	下-无
--看到副会长 --上-无 		中-无   	下-无
--看到成员 	--上-无		中-无   	下-无
function m:showBtns()
    local myJob = self.delegate:getMyJob()
    print("myJob" .. myJob)
    print("self.data.job" .. self.data.job)
    if myJob == 1 then
        if self.data.job == 1 then
            self.btn_up.gameObject:SetActive(false)
            self.btn_middle.gameObject:SetActive(false)
            self.btn_down.gameObject:SetActive(false)
        elseif self.data.job == 2 then
            self.btn_up.gameObject:SetActive(true)
            self.btntxt_up.text = TextMap.GetValue("Text1263")
            self.btn_middle.gameObject:SetActive(false)
            self.btn_down.gameObject:SetActive(true)
            self.btntxt_down.text = TextMap.GetValue("Text1264")
        else
            self.btn_up.gameObject:SetActive(true)
            self.btntxt_up.text = TextMap.GetValue("Text1265")
            self.btn_middle.gameObject:SetActive(false)
            self.btn_down.gameObject:SetActive(true)
            self.btntxt_down.text = TextMap.GetValue("Text1264")
        end
    elseif myJob == 2 then
        if Player.playerId == self.data.playerId then
            self.btn_up.gameObject:SetActive(false)
            self.btn_middle.gameObject:SetActive(true)
            self.btntxt_middle.text = TextMap.GetValue("Text1266")
            self.btn_down.gameObject:SetActive(false)
        elseif self.data.job == 1 then
            self.btn_up.gameObject:SetActive(false)
            self.btn_middle.gameObject:SetActive(true)
            self.btntxt_middle.text = TextMap.GetValue("Text1267")
            self.btn_down.gameObject:SetActive(false)
            local tempd =  ClientTool.GetNowTime(self.data.offlineTime)
            print("offtimetempd"..tempd)
            if self.data.offlineTime == 0 or (self.data.offlineTime ~= -1 and  ClientTool.GetNowTime(self.data.offlineTime) > -(self:getImpeachTimeLimit())) then
                self.btn_middle.gameObject:SetActive(false)
            end
        elseif self.data.job == 2 then
            self.btn_up.gameObject:SetActive(false)
            self.btn_middle.gameObject:SetActive(false)
            self.btn_down.gameObject:SetActive(false)
        else
            self.btn_up.gameObject:SetActive(false)
            self.btn_middle.gameObject:SetActive(true)
            self.btntxt_middle.text = TextMap.GetValue("Text1264")
            self.btn_down.gameObject:SetActive(false)
        end
    else
        if Player.playerId == self.data.playerId then
            self.btn_up.gameObject:SetActive(false)
            self.btn_middle.gameObject:SetActive(true)
            self.btntxt_down.text = TextMap.GetValue("Text1266")
            self.btn_down.gameObject:SetActive(false)
        elseif self.data.job == 1 then
            self.btn_up.gameObject:SetActive(false)
            self.btn_middle.gameObject:SetActive(true)
            self.btntxt_middle.text = TextMap.GetValue("Text1267")
            self.btn_down.gameObject:SetActive(false)
            local temp = ClientTool.GetNowTime(self.data.offlineTime)
            print("offtimetempdddd"..temp)
            if self.data.offlineTime == 0 or (self.data.offlineTime ~= -1 and  ClientTool.GetNowTime(self.data.offlineTime) > -(self:getImpeachTimeLimit())) then
                self.btn_middle.gameObject:SetActive(false)
            end
        elseif self.data.job == 2 then
            self.btn_up.gameObject:SetActive(false)
            self.btn_middle.gameObject:SetActive(false)
            self.btn_down.gameObject:SetActive(false)
        else
            self.btn_up.gameObject:SetActive(false)
            self.btn_middle.gameObject:SetActive(false)
            self.btn_down.gameObject:SetActive(false)
        end
    end
end

function m:getImpeachTimeLimit()
    local impeachTimeLimit = TableReader:TableRowByID("GuildSetting", "impeachTimeLimit").args1
    if impeachTimeLimit == nil then
        impeachTimeLimit = "7d"
    end
    print("impeachTimeLimit"..impeachTimeLimit)
    local timelimit = 0
    local d = string.find(impeachTimeLimit, "d")
    if d ~= nil then
        timelimit = tonumber(string.sub(impeachTimeLimit, 1, d - 1)) * 24 * 60 * 60
    end
    local i = string.find(impeachTimeLimit, "h")
    if i ~= nil then
        timelimit = timelimit + tonumber(string.sub(impeachTimeLimit, d + 1, i - 1))* 60 * 60
    else
        i = 0
    end
    local j = string.find(impeachTimeLimit, "m")
    if j ~= nil then
        timelimit = timelimit + tonumber(string.sub(impeachTimeLimit, i + 1, j - 1))* 60
    end

    print("getImpeachTimeLimit"..timelimit)
    return timelimit
end
-- 点击头像来查看成员信息
function m:onHeadImg(...)
    --MessageMrg.show("暂无查看成员详细信息的接口")
    if self.data.playerId == Player.playerId then return end
    local userInfo = {}
    userInfo.gameUserId = self.data.playerId
    userInfo.level = self.data.level
    userInfo.nickname = self.data.nickname
    userInfo.power = self.data.fight
    userInfo.vip = self.data.vipLevel
    userInfo.head = self.data.icon
    userInfo.mdouleName = "leagueFriendFight"
    UIMrg:pushWindow("Prefabs/moduleFabs/chatModule/PlayerInfo", { data = userInfo })
end

-- 退出公会
function m:onExitGuild()
    print("m:onExitGuild( )")
    local function api(...)
        Api:exitGuild(function(result)
            print("lzh print: exitGuild 1111111111111111")
            print(result.ret)
            if tonumber(result.ret) == 0 then
                MessageMrg.show(TextMap.GetValue("Text1268"))
                GuildDatas:LeaveLeague(function(...)
                    UIMrg:pop()
                    UIMrg:pop()
                end)
            else
                GuildDatas:ShowTipByReturnCode_zg(tonumber(result.ret))
            end
        end, function(...)
            print("lzh print: exitGuild 2222222222222222")
            print(result)
        end)
    end

    UIMrg:pushMessage("Prefabs/moduleFabs/alertModule/dialog", {
        type = "tips",
        msg = TextMap.GetValue("Text1269"),
        btnName = TextMap.GetValue("Text1266"),
        title = TextMap.GetValue("Text70"),
        onOk = api or function() end,
        onCancel = function() end
    })
end

-- 任命
function m:onRenming()
    self.delegate:ShowRenmingBtns(self.data)
end

-- -- 任命副会长
-- function m:onRenmingJob( )
-- 	print("1111111111111111111111")
-- 	local function api( ... )
-- 		Api:appointJob(self.data.playerId, function(result)
-- 	    		print("lzh print: appointJob 1111111111111111")
-- 	    		print(result.ret)
-- 			if tonumber(result.ret) == 0 then
-- 				MessageMrg.show("任命副会长成功")
-- 				self.delegate:HideRenmingBtns()
-- 			end
-- 		end,function ( ... )
-- 			print("lzh print: appointJob 2222222222222222")
-- 	    		print(result)
-- 		end)
-- 	end

-- -- 移交会长
-- function m:onMoveMonsterJob( )
-- 	print("22222222222222222222")
-- 	local function api( ... )
-- 		Api:appointMasterJob(self.data.playerId, function(result)
-- 	    		print("lzh print: appointMasterJob 1111111111111111")
-- 	    		print(result.ret)
-- 			if tonumber(result.ret) == 0 then
-- 				MessageMrg.show("移交会长职务成功")
-- 				self.delegate:HideRenmingBtns()
-- 			end
-- 		end,function ( ... )
-- 			print("lzh print: appointMasterJob 2222222222222222")
-- 	    		print(result)
-- 		end)
-- 	end

-- 	UIMrg:pushMessage("Prefabs/moduleFabs/alertModule/dialog", {
--         		type = "tips",
--        		msg = "确定要将会长职位移交给[00ff00]" .. m.data.nickname .. "[-]",
--         		btnName = "移交",
--         		title = TextMap.getText("TIPS"),
--         		onOk = api or function() end,
--         		onCancel = function() end
--     	})
-- end

-- 解除职位
function m:onJiechu()
    local function api(...)
        Api:fireJob(self.data.playerId, function(result)
            print("lzh print: fireJob 1111111111111111")
            print(result.ret)
            if tonumber(result.ret) == 0 then
                MessageMrg.show(TextMap.GetValue("Text1270"))
                self.delegate:refreashList()
            else
                GuildDatas:ShowTipByReturnCode_zg(tonumber(result.ret))
            end
        end, function(...)
            print("lzh print: fireJob 2222222222222222")
            print(result)
        end)
    end

    UIMrg:pushMessage("Prefabs/moduleFabs/alertModule/dialog", {
        type = "tips",
        msg =string.gsub(TextMap.GetValue("LocalKey_721"),"{0}",self.data.nickname),
        btnName = TextMap.GetValue("Text1263"),
        title = TextMap.GetValue("Text70"),
        onOk = api or function() end,
        onCancel = function() end
    })
end

-- 踢出
function m:onTichu()
    local function api()
        Api:kickMember(self.data.playerId, function(result)
            print("lzh print: kickMember 1111111111111111")
            print(result.ret)
            if tonumber(result.ret) == 0 then
                MessageMrg.show(TextMap.GetValue("Text1273"))
                self.delegate:refreashList()
            else
                GuildDatas:ShowTipByReturnCode_zg(tonumber(result.ret))
            end
        end, function(...)
            print("lzh print: kickMember 2222222222222222")
            print(result)
        end)
    end

    UIMrg:pushMessage("Prefabs/moduleFabs/alertModule/dialog", {
        type = "tips",
        msg =string.gsub(TextMap.GetValue("LocalKey_722"),"{0}",self.data.nickname),
        btnName = TextMap.GetValue("Text1264"),
        title = TextMap.GetValue("Text70"),
        onOk = api or function() end,
        onCancel = function() end
    })
end

-- 弹劾
function m:onTanhe()
    local function api(...)
        Api:impeach(function(result)
            print("lzh print: impeach 1111111111111111")
            print(result.ret)
            if tonumber(result.ret) == 0 then
                MessageMrg.show(TextMap.GetValue("Text1275"))
                self.delegate:refreashList()
            else
                GuildDatas:ShowTipByReturnCode_zg(tonumber(result.ret))
            end
        end, function(...)
            print("lzh print: impeach 2222222222222222")
            print(result)
        end)
        --MessageMrg.show("暂无服务端接口")
    end

    local _msg =string.gsub(TextMap.GetValue("LocalKey_724"),"{0}","500")
    UIMrg:pushMessage("Prefabs/moduleFabs/alertModule/dialog", {
        type = "tips",
        msg = _msg,
        btnName = TextMap.GetValue("Text1267"),
        title = TextMap.GetValue("Text70"),
        onOk = api or function() end,
        onCancel = function() end
    })
end

function m:onClick(go, name)
    print(name)
    if name == "btn_touxiang" then
        self:onHeadImg()
    elseif name == "btn_up" then
        self:onUpMiddleDown(self.btntxt_up.text)
    elseif name == "btn_middle" then
        self:onUpMiddleDown(self.btntxt_middle.text)
    elseif name == "btn_down" then
        self:onUpMiddleDown(self.btntxt_down.text)
    end
end

function m:onUpMiddleDown(btnText)
    print(btnText)
    if btnText == TextMap.GetValue("Text1266") then
        self:onExitGuild()
    elseif btnText == TextMap.GetValue("Text1265") then
        self:onRenming()
    elseif btnText == TextMap.GetValue("Text1264") then
        self:onTichu()
    elseif btnText == TextMap.GetValue("Text1263") then
        self:onJiechu()
    elseif btnText == TextMap.GetValue("Text1267") then
        self:onTanhe()
    else
        MessageMrg.show(TextMap.GetValue("Text1278") .. btnText)
        --print(btnText == TextMap.GetValue("Text1266"))
    end
end

function m:getFormatTime(time)
    local tab = ""
    if time then
        tab = os.date('{%m-%d %H:%H}', time)
    else
        tab = os.date('{%m-%d %H:%H}')
    end
    return tab
end

return m