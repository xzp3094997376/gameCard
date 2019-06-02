--
-- Created by IntelliJ IDEA.
-- User: xiyou
-- Date: 20`14/11/12
-- Time: 14:35
-- To change this template use File | Settings | File Templates.
-- 选服
SERVER_LIST_FOR_UC = false

NowSelectedServer = 0
local m = {}
local selectList = {}

function m:getData2(data)
    local list = {}
    local row = 2
    for i = 1, table.getn(data), row do
        local li = {}
        local len = 0
        for j = 0, row - 1 do
            if data[i + j] then
                local d = data[i + j]
                d.realIndex = i + j
                li[j + 1] = d
                len = len + 1
            end
        end
        if len > 0 then
            table.insert(list, li)
        end
    end

    return list
end
--uc 分线
function m:updateUC()
    local list = {}
    for k, qu in pairs(self._server_list) do
        local sv_qu = tonumber(k)
        local line = {}
        for i = 1, #qu do
            local sv = {}
            local v = qu[i]
            sv.name = v.name
            sv.number = v.id
            sv.status = v.status
            sv.delegate = self
            if sv.number == self._lastServer then
                --上一次登陆的服务器
                sv.isSelected = true
            else
                sv.isSelected = false
            end
            table.insert(line, sv)
        end
        --若这一项只有一个服务器（uc支持一项多个服务器）
        if #qu == 1 then
            sv_qu = qu[1].id
            sv_qu = tonumber(sv_qu)
        end

        table.insert(list, { server_name = self._server_name[k], qu_number = sv_qu, line = line })
    end

    table.sort(list, function(a, b)
        return a.qu_number < b.qu_number
    end)
    local number = #list
    self.myLast = list[number].line
    
    -- list = m:getData2(list)

    --将推荐服务器与我的服务器选项插入最前
    local o = {
        delegate = self,
        servers = nil
    }
    table.insert(list, 1, o)
    self.__svList = list
    local idx = tonumber(self._lastServer)
    self.curSelect = self:getPos(idx, selectList) -- selectList[pre][pos]
    self._oldNumber = idx
    self:lastServer()

    m:refreshList() --刷新推荐服务器列表和我的服务器列表
end

function m:refreshList()
    local temp = {}
    if self._server_list ~= nil then
        self.xuanfu:SetActive(true)
        local allList = {}
		--print_t(self._server_list)
        for k, v in pairs(self._server_list) do
            --local line = {}
                local sv = {}
				local value = v[1]
                sv.name = value.name
                sv.realId = k
				sv.number = value.id
                sv.status = value.status
                --sv.delegate = self
				sv.value = value
                if sv.number.."" == self._lastServer.."" then
                    --上一次登陆的服务器
                    sv.isSelected = true
                else
                    sv.isSelected = false
                end
                --table.insert(line, sv)
				temp[sv.number] = sv.name
                --table.insert(temp,sv.number,sv.name)
            --end
            table.insert(allList, sv)
        end
        table.sort(allList, function(a, b)
            return a.number > b.number
        end)

        local list4 = self:getData2(allList)
        self._allServer = list4
        self.all_scrollView:refresh(list4, self, true, 0)
    else
        self.xuanfu:SetActive(false)
    end


    if self.myServer ~= nil then
        self.scrollView.gameObject:SetActive(true)
        local myList = {}
        for i = 1, #self.myServer do
            local  sv = {}
            local   v = self.myServer[i]
            sv.lv = tonumber(v.lv)              --角色等级
            sv.number = v.id          --服务器id
            sv.pid = v.name            --角色名字
            sv.name = temp[v.id] or ""         --服务器名字
            sv.delegate = self
            if sv.number.."" == self._lastServer.."" then
                    --上一次登陆的服务器
                sv.isSelected = true
            else
                sv.isSelected = false
            end
            table.insert(myList, sv)
        end
        table.sort(myList, function(a, b)
            return a.lv > b.lv
        end)
        local list3 = self:getData2(myList)
        self._myServer = list3
		if #list3 > 0 then 
			self.scrollView:refresh(list3, self, true, -1)
		end
    else
        self.scrollView.gameObject:SetActive(false)
    end

    

end



function m:update(uid, skey, sever_list, lastServer, ret,channelCode)
    self._uid = uid
    self._skey = skey
    self.channelCode = channelCode
	--print("server_list")
	--print_t(sever_list)
	--
	--print("ret")
	--print_t(ret)
    self.recommendServer = {}
    self.prefix = ret["prefix"]
    if self.prefix ==  nil then
        self.prefix = ""
    end
    if ret["recommendServer"] == nil or ret["recommendServer"].Count == 0 then
        self.rec_count = 0
    else
        self.recommendServer = json.decode(ret["recommendServer"]:toString()) --推荐服务器
    end
    self.myServer = {}
    PlayerPrefs.SetString("Language", "English");
    if ret["myServer"] then
        self.myServer = json.decode(ret["myServer"]:toString()) --我的服务器
    end
    self._server_list = json.decode(sever_list)

    self._lastServer = lastServer
    self._server_name = ret.server_name or {}
    SERVER_LIST_FOR_UC = #self._server_list == 0
    local count = 0
    if SERVER_LIST_FOR_UC then
        m:updateUC()
    else
        --所有的服务列表
        if self.__svList == nil then
            local servers = {}
            table.foreach(self._server_list, function(i, v)
                local sv = {}
                sv.name = v.name
                sv.number = v.id
                sv.status = v.status
                sv.delegate = self
                if sv.number == lastServer then
                    sv.isSelected = true
                else
                    sv.isSelected = false
                end
                table.insert(servers, sv)
            end)
            self.__svList = servers
        end
        local idx = string.format("%d", lastServer)
        self.curSelect = self:getPos(idx, selectList) -- selectList[pre][pos]
        self._oldNumber = idx
        self:lastServer()
        m:refreshList()
    end
end

function m:getPos(idx, _list)
    local cur = nil
    local lastIdx = 0
    --选线版本
    if SERVER_LIST_FOR_UC then
        table.foreach(self._server_list, function(i, qu)
            for i = 1, #qu do
                local v = qu[i]
                if v.id .. "" == idx .. "" then
                    local sv = {}
                    sv.name = v.name
                    sv.number = v.id
                    sv.status = v.status
                    sv.delegate = self
                    sv.isSelected = true
                    cur = sv
                    return cur
                end
                -- lastIdx = v.id
                local num = tonumber(v.id)
                if num > lastIdx then
                    lastIdx = num
                end
            end
        end)
    else

        -- --不选线版本
        -- for key, value in pairs(tbtest) do      
        --      XXX  
        -- end

        table.foreach(self._server_list, function(i, v)
            if v.id .. "" == idx .. "" then
                local sv = {}
                sv.name = v.name
                sv.number = v.id
                sv.status = v.status
                sv.delegate = self
                sv.isSelected = true
                cur = sv
                return cur
            end
            -- lastIdx = v.id
            local num = tonumber(v.id)
            if num > lastIdx then
                lastIdx = num
            end
        end)
    end
    if cur == nil then
        self._lastServer = lastIdx
        return m:getPos(lastIdx, _list)
    end
    return cur
end


--回修改后的服务器列表
function m:setNumServer(idx, _list, state)
    if SERVER_LIST_FOR_UC then
        table.foreach(_list, function(k, v)
            if v.servers ~= nil then
                table.foreach(v.servers, function(ki, vi)
                    table.foreach(vi.line, function(kj, vj)
                        if vj.number ~= nil and vj.number .. "" == idx .. "" then
                            vj.isSelected = state
                        end
                    end)
                end)
            end
        end)
    else
        table.foreach(_list, function(k, v)
            if v.servers ~= nil then
                table.foreach(v.servers, function(ki, vi)
                    if vi.number ~= nil and vi.number .. "" == idx .. "" then
                        print("state " .. vi.number)
                        vi.isSelected = state
                    end
                end)
            end
        end)
    end

    return _list
end

function m:getServerList()
    local old = tonumber(self._oldNumber)
    local new = tonumber(self._lastServer)
    self.__svList = m:setNumServer(old, self.__svList, false)
    self.__svList = m:setNumServer(new, self.__svList, true)

    return self.__svList
end

function m:getLast()
    local sv = self:getServerList()
    local idx = tonumber(self._lastServer)
    return self:getPos(idx, sv)
end

function m:lastServer()
    local last = self:getLast()
    local name = string.gsub(TextMap.GetValue("LocalKey_736"),"{0}",last.number)
    self.txt_server.text =string.gsub(name,"{1}",last.name)
    --self.pre_server:CallUpdate(last)
end


function m:onSelect(server)
    self._oldNumber = self._lastServer
    self.curSelect = server
    local name = string.gsub(TextMap.GetValue("LocalKey_736"),"{0}",server.number)
    self.txt_server.text =string.gsub(name,"{1}",server.name)
    self._lastServer = server.number
    self:refreshList()
    self.node_start:SetActive(true)
    self.node_select:SetActive(false)
end


--检测是否在我的服务器与推荐服务器列表中
function m:isMyServer()
    for i = 1, #self._myServer do
        if self._myServer[i].isSelected == true then
            return true
        end
    end
    for i = 1, #self._recServer do
        if self._recServer[i].isSelected == true then
            return true
        end
    end
    return false
end

--显示服务器列表
function m:showQufuList(go)
    self.node_start:SetActive(false)
    self.node_select:SetActive(true)
    local list = self:getServerList()
    local show = 0
    -- if self:isMyServer() == true then
    --     show = 0
    -- else
    --     for i=1,#list do
    --         --为了评审，暂时屏蔽
    --         local data = list[i]
    --         if data.servers ~= nil then
    --             table.foreach(data.servers, function(ii, qu)
    --                 for j = 1, #qu.line do
    --                     local v = qu.line[j]
    --                     if v.isSelected == true then
    --                         show = i - 1
    --                     end
    --                 end
    --             end)
    --         end          
    --     end
    -- end
    self.selectIndex = show
    local txt =string.gsub(TextMap.GetValue("LocalKey_735"),"{0}", (show * 10 + 1) .. " - " .. (show * 10 + 10))
    local d = list[show + 1].servers
    m:showServerList(d, txt)
    --self.xuanqu:refresh(list, self, false, show)
    self:refreshList()
end

function m:showServerList(data, txt)

    -- self.xuanfu:SetActive(true)
    -- local listall = self:getServerList()
    -- print("aaaaaaaaaaaaaa.........."..#listall)
    -- local listbb = self:getData2(listall)
    -- self.all_scrollView:refresh(listbb, self, true, 0)
 


    -- end
    -- if data ~= nil then
    --     self.xuanfu:SetActive(true)
    --     local list = self:getData2(data)
    --     self.all_scrollView:refresh(list, self, true, 0)
    -- else
    --     self.xuanfu:SetActive(false)
    --     --self.my_server:SetActive(true)
    --     self:refreshList()
    -- end
end

function m:onCreateCallback()
	local gold = Player.Resource.gold
    local vip = 0
    if (Player.Info.vip == nil) then
        vip = 0
    else
        vip = Player.Info.vip
    end

    if (ClientTool.Platform == "android" or ClientTool.Platform == "ios") and isSdk == 1 then
        mysdk:createRole(Tool.CUR_UID, Player.Info.nickname, Player.Info.level, self.curSelect.number, self.curSelect.name, gold, vip, "")
    end

    -- if Player.Info.level == 0 then
    --     m:callBack()
    --     return
    -- end

    DataEye.selectServer(self._uid, self.curSelect.number)
    PlayerPrefs.SetInt("FightSpeed", 0);
    --PlayerPrefs.DeleteAll()
    --PlayerPrefs.SetString("uid", self._uid)
    PlayerPrefs.SetString("music", "1")
    DataEyeTool.Login(Player.playerId, self.curSelect.number .. "")
    --dataEye 登陆，包含服务器。

    m:StartGame()
end 

function m:onRandomName(go)
    Tool.CUR_UID = self._uid
    --选人
	Tool.replace("select_role", "Prefabs/moduleFabs/role/gui_select_role", {delegate = self})

    local id = Player.guide:getItem(0)
    print(TextMap.GetValue("Text_1_305") .. id)
    if id == 0 then
        GuideMrg.CallStep("step1")
    elseif id < 4 then
        GuideMrg.CallStep("step" .. (id + 1))
    else
        RotateCamera.canMove = false
        GameManager.OnInitScene(nil)
        --ClientTool.beginLoadScene("main_scene", function()
            GuideMrg.CallStep("step" .. (id + 1))
        --end)
    end
    --[[local that = self
    Api:randomName(1, function(result)
        local name = result.name
        Api:createPlayer(name, that._uid, 1, function(result)
            local gold = Player.Resource.gold
            local vip = 0
            if (Player.Info.vip == nil) then
                vip = 0
            else
                vip = Player.Info.vip
            end

            if (ClientTool.Platform == "android" or ClientTool.Platform == "ios") and isSdk == 1 then
                mysdk:createRole(that._uid, Player.Info.nickname, Player.Info.level, that.curSelect.number, that.curSelect.name, gold, vip, "")
            end

            -- if Player.Info.level == 0 then
            --     m:callBack()
            --     return
            -- end

            DataEye.selectServer(that._uid, that.curSelect.number)
            PlayerPrefs.SetInt("FightSpeed", 0);
            --PlayerPrefs.DeleteAll()
            PlayerPrefs.SetString("uid", that._uid)
            PlayerPrefs.SetString("music", "SETTING_ON")
            DataEyeTool.Login(Player.playerId, that.curSelect.number .. "")
            --dataEye 登陆，包含服务器。

            m:StartGame()
        end, function(resut)
            return true
        end)
    end)]]--
end

function m:StartGame()
    local info = {}
     local network = "none"
    local _state = Application.internetReachability
    if _state == 2 then 
        network = "wifi"
    elseif _state == 1 then
        network = "other"
    end
    if GlobalVar.dataEyeChannelID == "ios" then
        info = {
            idfa = MySdk.Idfa,
            deviceUniqueIdentifier = deviceUniqueIdentifier or "null", --唯一的设备标识。
            deviceName = deviceName or "null", --用户指定的设备名称。
            deviceModel = deviceModel or "null", --设备型号。
            operatingSystem = operatingSystem or "null" ,--操作系统名称和版本。
            network = network,
            resolution = Screen.currentResolution.width .."x"..Screen.currentResolution.height,
            channel = GlobalVar.dataEyeChannelID,
            gameid = GlobalVar.dataEyeAppID
        }
    else
        info = {
            deviceUniqueIdentifier = deviceUniqueIdentifier or "null", --唯一的设备标识。
            deviceName = deviceName or "null", --用户指定的设备名称。
            deviceModel = deviceModel or "null", --设备型号。
            operatingSystem = operatingSystem or "null" ,--操作系统名称和版本。
            network = network,
            resolution = Screen.currentResolution.width .."x"..Screen.currentResolution.height,
            channel = GlobalVar.dataEyeChannelID,
			subchannel = GlobalVar.subChannelID,
            gameid = GlobalVar.dataEyeAppID,
			memory = SystemInfo.supportsVibration,
			sysMemory = SystemInfo.systemMemorySize,
			graphicsMemory = SystemInfo.graphicsMemorySize
        }
    end

    info = json.encode(info)
    Api:collectDeviceInfo(info, function(result)
    end)
    self:ReqActivity_FuliInfoInLogining()
    if not SettingConfig.isGuideOpen() or Player.Info.level > 5 then
		GameManager.OnInitScene(nil)
        return
    end
    if not GuideMrg:isPlaying() then
        print(Player.guide[0])
        local id = Player.guide:getItem(0)
        print(TextMap.GetValue("Text_1_305") .. id)
        GuideMrg.CallStep("step" .. (id + 1))
    end 
    RotateCamera.canMove = false
    GameManager.OnInitScene(nil)
end

--播放开场动画
function m:playPlot()
    local data = require "uLuaModule/modules/conversation/uGameStart.lua"
    TranslateScripts.Inst:TranslateString(data)
end

local tryLoadPlayerTime = 0
local resChat = nil
--开始游戏
function m:onStartGame(go)
    tryLoadPlayerTime = 0
    sel_sever = self.curSelect
    local that = self
    self.go = go
    print("self.channelCode==========="..self.channelCode)
    self.fightMgr = nil
    Api:selectServer(sel_sever.number, self._skey, self.channelCode,GlobalVar.dataEyeAppID,function(res)
        local pid = res["pid"]
        local skey = res["skey"]
        that._pid = pid
        PlayerPrefs.SetString("serverId", (sel_sever.number or 0))
        PlayerPrefs.SetString("serverName", sel_sever.name)
        NowSelectedServer = sel_sever.number
        PlayerPrefs.SetString("pid", pid)
        PlayerPrefs.SetString("skey", skey)
        resChat = res
        --PlayerPrefs.SetString("serverId", sel_sever.number)
        that:callBack()
        if self.fightMgr ~= nil then
            self.fightMgr:SetActive(false)
        end
    end)

	if self.fightMgrInit == nil then 
		ClientTool.loadAssets("Prefabs/moduleFabs/fightmodule/FightManager", true, null, function (go)
			self.fightMgrInit = true
			self.fightMgr = go
		end)
	end 
end

holiday_open=false
like_open=false
holiday_icon=""

function m:ReqActivity_FuliInfoInLogining()
    Api:getActivity("","holiday", function(result)
        if result.ids == nil then 
            holiday_open=false
        else
            local count = result.ids.Count
            if count == 0 then 
                holiday_open=false
            else 
                holiday_icon=result.ids[0].icon
                holiday_open=true
            end
        end 
    end)
    Api:getActivity("","like", function(result)
        if result.ids == nil then 
            like_open=false
        else
            local count = result.ids.Count
            if count == 0 then 
                like_open=false
            else 
                like_open=true
            end
        end 
    end)
    if like_open == false or holiday_open == false then 
        local times = Tool.getRefreshTime()
        LuaTimer.Add(times*1000, function()
            m:ReqActivity_FuliInfoInLogining()
        end)
    end 
end


function m:callBack()
    local that = self
    if tryLoadPlayerTime == 3 then
        DialogMrg.ShowDialog(TextMap.GetValue("Text1315"), function(...)
        end)
        return
    end
    tryLoadPlayerTime = tryLoadPlayerTime + 1
    Api:loadPlayer(self._pid, function(result)
        if Player.playerId == "" then
            m:callBack()
            return
        end

        if (ClientTool.Platform == "android" or ClientTool.Platform == "ios") and isSdk == 1 then
            local gold = Player.Resource.gold
            local vip = 0
            if (Player.Info.vip == nil) then
                vip = 0
            else
                vip = Player.Info.vip
            end
            mysdk:enterServer(that._uid, Player.Info.nickname, Player.Info.level, that.curSelect.number, that.curSelect.name, gold, vip, "")
            -- mysdk:levelUp(that._uid, Player.Info.nickname, Player.Info.level, that.curSelect.number, that.curSelect.name, gold, vip, "")
        end

        --聊天初始化
        print("resChat.serverId   ================== " .. resChat.serverId)
        local gameServerId = resChat.serverId .. ""

        if GlobalVar.sdkPlatform == "ios" then      --ios正版聊天服务器区分
            gameServerId = "ios" .. gameServerId
        end
        
        if ClientTool.Platform ~= "pc" then
            --ChatController.Initialize("1000405_" .. gameServerId)
        end

        if Player.Info.nickname == "" or Player.Info.nickname == nil then
            that:onRandomName(self.go)
        else
            DataEyeTool.Login(Player.playerId,that.curSelect.number)

            m:StartGame()
        end
    end)
end

function m:backStart(go)
    self.node_start:SetActive(true)
    self.node_select:SetActive(false)
    self:lastServer()
end


function m:logout()
    if (ClientTool.Platform == "android" or ClientTool.Platform == "ios") and isSdk == 1 then
        mysdk:logout("")
    end
end


function m:onClick(go, name)
    if name == "btn_select" then
        self:showQufuList(go)
    elseif name == "btn_start" then
        self:onStartGame(go)
    elseif name == "btBack" then
        self:backStart(go)
    elseif name == "btn_logout" then
        self:logout()
    end
end

--初始化
function m:create(binding)
    self.binding = binding
    return self
end

function m:Start()
    GameManager.showFrame(self.node_select)

    Events.AddListener("select_server", function(server)
        m:onSelect(server)
    end)
end

function m:OnDestroy()
    Events.RemoveListener('select_server')
end


return m

