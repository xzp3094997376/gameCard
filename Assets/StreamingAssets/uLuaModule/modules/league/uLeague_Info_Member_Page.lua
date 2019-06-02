local m = {}

local curTab = 1 -- 1:表示公会信息页面，2:表示公会成员列表页面

function m:Start()
    curTab = 1
    LuaMain:ShowTopMenu()
    Tool.loadTopTitle(self.gameObject, TextMap.GetValue("LocalKey_657"))
    GuildDatas:downloadGuildBaseInfo(function(args)
        m:update(args)
    end)
end

function m:onEnter()
    GuildDatas:downloadGuildBaseInfo(function(args)
        m:update(args)
    end)
end

function m:update(luaUserData)
    if curTab == 1 then
        self.league_InfoTab.gameObject:SetActive(true)
        self.league_MemberTab.gameObject:SetActive(false)
    else
        self.league_InfoTab.gameObject:SetActive(false)
        self.league_MemberTab.gameObject:SetActive(true)
    end
    self.league_InfoTab:CallUpdate(luaUserData)
end

function m:onClick(go, btnName)
    if btnName == "btn_info" then
        print("222222222222222")
        if curTab == 1 then return end
        print("333333333333333")
        curTab = 1
        self:onBtn_Info()
    elseif btnName == "btn_member" then
        if curTab == 2 then return end
        curTab = 2
        self:onBtn_Member()
    end
end

function m:onBtn_Info(...)
    -- 获取公会的基本信息
    -- Api:getGuildBaseInfo(function(result)
    -- 	if tonumber(result.ret) == 0 then
    -- 		GuildDatas:setMyGuildInfo(result.info, result.ext)
    -- 		self.league_InfoTab.gameObject:SetActive(true)
    -- 		self.league_MemberTab.gameObject:SetActive(false)
    -- 		local args = {}
    -- 		args.result = result
    -- 		self.league_InfoTab:CallUpdate(args)
    -- 	else
    -- 		MessageMrg.show(TextMap.GetValue("Text1181"))
    -- 	end
    -- end,function (result)
    -- 	print("lzh print: getGuildBaseInfo 2222222222222222")
    -- 	--UIMrg:pop()
    -- 	print(result)
    -- end)
    GuildDatas:downloadGuildBaseInfo(function(args)
        self.league_InfoTab.gameObject:SetActive(true)
        self.league_MemberTab.gameObject:SetActive(false)
        self.league_InfoTab:CallUpdate(args)
    end)
end

function m:onBtn_Member(...)
    -- 获取公会消息列表
    Api:getGuildMemberList(function(result)
        if tonumber(result.ret) == 0 then
            self.league_InfoTab.gameObject:SetActive(false)
            self.league_MemberTab.gameObject:SetActive(true)
            local args = {}
            args.result = result
            self.league_MemberTab:CallUpdate(args)
        else
            MessageMrg.show(TextMap.GetValue("Text1181"))
        end
    end, function(result)
        print("lzh print: getGuildBaseInfo 2222222222222222")
        --UIMrg:pop()
        print(result)
    end)
end

return m