--公会信息页面
local m = {}

-- function m:Start()
-- 	self.binding:CallManyFrame(function()
--         		self:getGuildInfo()
--     		end,1)
-- end

-- function m:getGuildInfo(...)
-- 	-- 获取公会的基本信息
-- 	Api:getGuildBaseInfo(function(result)		
-- 		if tonumber(result.ret) == 0 then
-- 			GuildDatas:setMyGuildInfo(result.info, result.ext)
-- 			self:InitUI_Left(result.info)
-- 		else
-- 			MessageMrg.show(TextMap.GetValue("Text1181"))
-- 		end
-- 	end,function (result)
-- 		print("lzh print: getGuildBaseInfo 2222222222222222")
-- 		--UIMrg:pop()
-- 		print(result)
-- 	end)
-- 	-- 获取公会消息列表
-- 	Api:getGuildMessageList(function(result)
-- 		if tonumber(result.ret) == 0 then
-- 			if result.list.Count==0 then 
-- 				self.svDaymicMsgLis:refresh({},self,true,0)
-- 				self.lbl_tips.gameObject:SetActive(true)
-- 				self.lbl_tips.text = "没有公会动态消息"
-- 				return			
-- 			end
-- 			self.lbl_tips.gameObject:SetActive(false)
-- 			self:InitUI_Right(result.list)
-- 		else
-- 			MessageMrg.show(TextMap.GetValue("Text1242") .. result.ret)
-- 		end
-- 	end, function (result)
-- 		print("lzh print: getGuildMessageList 2222222222222222")
-- 		self.lbl_tips.gameObject:SetActive(true)
-- 		self.lbl_tips.text = "没有公会动态消息"
-- 	end)
-- end

function m:update(luaUserData)
    self.info = luaUserData.result.info
    self:InitUI_Left(luaUserData.result.info)
    -- 获取公会消息列表
    ApiLoading:show(15, nil)
    Api:getGuildMessageList(function(result)
        ApiLoading:hide()
        if tonumber(result.ret) == 0 then
            if result.list.Count == 0 then
                self.svDaymicMsgLis:refresh({}, self, true, 0)
                self.lbl_tips.gameObject:SetActive(true)
                self.lbl_tips.text = TextMap.GetValue("Text1241")
                return
            end
            self.lbl_tips.gameObject:SetActive(false)
            self:InitUI_Right(result.list)
        else
            MessageMrg.show(TextMap.GetValue("Text1242") .. result.ret)
        end
    end, function(result)
        ApiLoading:hide()
        print("lzh print: getGuildMessageList 2222222222222222")
        self.lbl_tips.gameObject:SetActive(true)
        self.lbl_tips.text = TextMap.GetValue("Text1241")
    end)
end

function m:InitUI_Left(userdata)
    --basic
    self.img_tubiao.spriteName = tostring(userdata.icon)
    self.txt_lv.text = userdata.guildLevel
    self.guildname = userdata.guildName
    self.txt_guildname.text = userdata.guildName
    self.txt_renshu.text = userdata.playerAmount .. "/" .. userdata.playerAmountLimit
    self.txt_mingzi.text = userdata.masterNickname
    --self.slider_di.value = 0.5--要通过读表计算
    self.slider_di.value = userdata.experience / GuildDatas:getExp(userdata.guildLevel)
    --self.labPieceCount.text = "要通过读表计算"
    self.labPieceCount.text = userdata.experience .. "/" .. GuildDatas:getExp(userdata.guildLevel)
    -- 与职位相关
    self.gg_content.text = userdata.notice
    self.xy_content.text = userdata.announce
    local job = self:getMyJob(userdata.masterId, userdata.viceMasterIds)
    --if Player.Info.guildJob==1 or Player.Info.guildJob==2 then
    if job == 1 or job == 2 then
        self.btn_edit_gg.gameObject:SetActive(true)
        self.btn_edit_xy.gameObject:SetActive(true)
        self.btn_shenhe.gameObject:SetActive(true)
    else
        self.btn_edit_gg.gameObject:SetActive(false)
        self.btn_edit_xy.gameObject:SetActive(false)
        self.btn_shenhe.gameObject:SetActive(false)
    end
    --if Player.Info.guildJob==1 then
    if job == 1 then
        self.btn_jiesan.gameObject:SetActive(true)
        self.btn_rename.gameObject:SetActive(true)
        if userdata.dissolutionStartTime == 0 then
            self.txt_jiesan.text = TextMap.GetValue("Text1243")
        else
            self.txt_jiesan.text = TextMap.GetValue("Text1244")
        end
    else
        self.btn_jiesan.gameObject:SetActive(false)
        self.btn_rename.gameObject:SetActive(false)
    end

    if userdata.dissolutionStartTime == 0 then
        self.txt_daojishi.gameObject:SetActive(false)
    else
        Api:checkRes(function()
            self.txt_daojishi.gameObject:SetActive(true)
            self:updateTime()
        end)
    end
end

function m:InitUI_Right(udList)
    local count = udList.Count
    self.msgDatas = {}
    local joinTime = GuildDatas:getMyGuildExt().joinTime or 0
    for i = 0, count - 1 do
        if joinTime <= udList[i].time then
            local t = {}
            t.time = udList[i].time
            t.message = udList[i].message
            table.insert(self.msgDatas, 1, t) --插到最前面
        end
    end
    if #self.msgDatas == 0 then
        self.svDaymicMsgLis:refresh({}, self, true, 0)
        self.lbl_tips.gameObject:SetActive(true)
        self.lbl_tips.text = TextMap.GetValue("Text1241")
        return
    end
    self.svDaymicMsgLis:refresh(self.msgDatas, self, true, 0)
end

function m:onJiesan(...)
    if self.info.dissolutionStartTime == 0 then
        self:onJiesan1()
    else
        self:onJiesan2()
    end
end

-- 解散公会
function m:onJiesan1(...)
    local function api()
        Api:dissolutionGuildInfo(false, function(result)
            print("lzh print: dissolutionGuildInfo 1111111111111111")
            print(result.ret)
            if tonumber(result.ret) == 0 then
                MessageMrg.show(TextMap.GetValue("Text1245"))
                GuildDatas:downloadGuildBaseInfo(function(args)
                    self:update(args)
                end)
            elseif tonumber(result.ret) == 1032 then
                MessageMrg.show(TextMap.GetValue("Text1246"))
            end
        end, function(...)
            print("lzh print: dissolutionGuildInfo 2222222222222222")
            print(result)
        end)
    end

    UIMrg:pushMessage("Prefabs/moduleFabs/alertModule/dialog", {
        type = "tips",
        msg = TextMap.GetValue("Text1247"),
        btnName = TextMap.GetValue("Text1248"),
        title = TextMap.GetValue("Text70"),
        onOk = api or function() end,
        onCancel = function() end
    })
end

-- 取消解散公会
function m:onJiesan2(...)
    local function api()
        Api:dissolutionGuildInfo(true, function(result)
            print("lzh print: dissolutionGuildInfo 1111111111111111")
            print(result.ret)
            if tonumber(result.ret) == 0 then
                MessageMrg.show(TextMap.GetValue("Text1249"))
                if my_timer ~= nil then
                    LuaTimer.Delete(my_timer)
                end

                GuildDatas:downloadGuildBaseInfo(function(args)
                    self:update(args)
                end)
            elseif tonumber(result.ret) == 1032 then
                MessageMrg.show(TextMap.GetValue("Text1250"))
            end
        end, function(...)
            print("lzh print: dissolutionGuildInfo 2222222222222222")
            print(result)
        end)
    end

    UIMrg:pushMessage("Prefabs/moduleFabs/alertModule/dialog", {
        type = "tips",
        msg = TextMap.GetValue("Text1251"),
        btnName = TextMap.GetValue("Text1244"),
        title = TextMap.GetValue("Text70"),
        onOk = api or function() end,
        onCancel = function() end
    })
end

-- 审核
function m:onShenhe(...)
    Tool.push("leagueModule", "Prefabs/moduleFabs/leagueModule/league_applyList")
end

-- 编辑宣言
function m:onEditxy(...)
    local args = {}
    args.type = 2
    args.title = TextMap.GetValue("Text1252")
    args.content = self.xy_content.text
    args.sucCallback = function(newContent)
        self.xy_content.text = newContent
    end
    UIMrg:pushMessage("Prefabs/moduleFabs/leagueModule/league_Edit_NoticeandAnnounce_Dlg", args)
end

-- 编辑公告
function m:onEditgg(...)
    local args = {}
    args.type = 3
    args.title = TextMap.GetValue("Text1253")
    args.content = self.gg_content.text
    args.sucCallback = function(newContent)
        self.gg_content.text = newContent
    end
    UIMrg:pushMessage("Prefabs/moduleFabs/leagueModule/league_Edit_NoticeandAnnounce_Dlg", args)
end

function m:onRename( ... )
    UIMrg:pushWindow("Prefabs/moduleFabs/leagueModule/league_rename", self)
end


function m:onClick(go, name)
    if name == "btn_jiesan" then
        self:onJiesan()
    elseif name == "btn_shenhe" then
        self:onShenhe()
    elseif name == "btn_edit_xy" then
        self:onEditxy()
    elseif name == "btn_edit_gg" then
        self:onEditgg()
    elseif name == "btn_rename" then
        self:onRename()
    end
end

function m:updateTime()
    print(self.info.dissolutionTime)
    print("------------------updateTime--------------11-----------------")
    local targetTime = ClientTool.GetNowTime(self.info.dissolutionStartTime + self.info.dissolutionTime)
    print(self.info.dissolutionStartTime)
    targetTime = math.ceil(targetTime)
    if my_timer ~= nil then
        LuaTimer.Delete(my_timer)
    end
    my_timer = LuaTimer.Add(0, 1000, function(id)
        if targetTime <= 0 then
            MessageMrg.show(TextMap.GetValue("Text1254"))
            GuildDatas:LeaveLeague(function(...)
                UIMrg:pop()
                UIMrg:pop()
            end)
            return false
        end
        --self.txt_daojishi.text = TextMap.GetValue("Text1255") .. targetTime
        self.txt_daojishi.text = TextMap.GetValue("Text1255") .. self:getFormatTime(targetTime)
        targetTime = targetTime - 1
        return true
    end)

    print("------------------updateTime---------------22----------------")
end

---------------------------------------------------------------------------------------------
function m:getMyJob(masterId, viceMasterIds)
    if Player.playerId == masterId then
        return 1
    end
    local count = viceMasterIds.Count
    for i = 0, count do
        if Player.playerId == viceMasterIds[i] then
            return 2
        end
    end
    return 3
end

function m:getFormatTime(seconds)
    local str = ""
    local t = 0
    if seconds >= 3600 then
        t = math.floor(seconds / 3600)
        if t < 10 then
            str = str .. "0" .. t .. ":"
        else
            str = str .. t .. ":"
        end
        seconds = seconds % 3600
    else
        str = str .. "00:"
    end
    if seconds >= 60 then
        t = math.floor(seconds / 60)
        if t < 10 then
            str = str .. "0" .. t .. ":"
        else
            str = str .. t .. ":"
        end
        seconds = seconds % 60
    else
        str = str .. "00:"
    end
    t = math.floor(seconds)
    if t < 10 then
        str = str .. "0" .. t
    else
        str = str .. t
    end
    return str
end

function m:OnDestroy()
    print("---------lzh-----------uLeague_InfoTab-----------OnDestroy-----------")
    if my_timer ~= nil then
        LuaTimer.Delete(my_timer)
    end
end


return m