LuaMain = {}
isSdk = 0;
isInJibaiState = false
--点击建筑事件绑定
function LuaMain:onClickBuild(name)
    print(name)
    local that = self
    --通过超链接配置表来传递个关卡的id
    if (name == "GuanKa") then
        --闯关
        LuaMain:openWithSound(6)
        return true
    elseif name == "ZhaoHuang" then
        --抽卡
        LuaMain:openWithSound(8)
        return true
    elseif name == "Object14" then
        uSuperLink.openModule(70)
        return true
    elseif name == "Linwangta" then
        --灵王塔
        LuaMain:openWithSound(226)
        return true
    elseif name == "Yanjiushuo" then
        --轮回
        LuaMain:openWithSound(232)
        return true
    elseif name == "XuanShang" then
        --悬赏
        LuaMain:openWithSound(10)
        return true
    elseif name == "Shilian" then
        --试练
        uSuperLink.openModule(70)
        return true
    elseif name == "PuyuanShopx" then
        --潽源商店
        LuaMain:openWithSound(1)
        return true
    elseif name == "Mailbox" then
        --邮箱
        LuaMain:openWithSound(51)
        return true
    elseif name == "Jingji" then
        --竞技场
        LuaMain:openWithSound(801)
        return true
    elseif name == "Juedou" then
        --对决
        LuaMain:openWithSound(5)
        return true
    elseif name == "PaiHangBang" then
        --排行榜
        LuaMain:openWithSound(122)
        return true
    elseif name == "PuyuanShop" then
        --黑店
        LuaMain:openWithSound(233)
        --LuaMain:showShop(8)
        return true
    elseif name == "GougHui" then
        --公会
        uSuperLink.openModule(52)
        --GuildDatas:EnterLeague()
        return true
    elseif name == "fuben" then
        --公会副本
        if isInJibaiState == false then
            LeagueMain = require("uLuaModule/modules/league/uLeague_main_page")
            LeagueMain:on_btn_guildCopy()
        end
        return true
    elseif name == "gonggaopai" then
        --公会广告排
        return true
    elseif name == "gonghuishop" then
        --公会商店
        if isInJibaiState == false then
            LeagueMain = require("uLuaModule/modules/league/uLeague_main_page")
            LeagueMain:on_btn_guildShop()
        end
        return true
    elseif name == "jibai" then
        --膜拜
        if isInJibaiState == false then
            LeagueMain = require("uLuaModule/modules/league/uLeague_main_page")
            LeagueMain:on_btn_ShenXiang()
        end
        return true
    elseif name == "dating" then
        --公会信息
        if isInJibaiState == false then
            LeagueMain = require("uLuaModule/modules/league/uLeague_main_page")
            LeagueMain:on_btn_guildInfo()
        end
        return true
    elseif name == "player_1" then
        self:attack(1)
        return true
    elseif name == "player_2" then
        self:attack(2)
        return true
    elseif name == "player_3" then
        self:attack(3)
        return true
    end
    return false
end

--挑战跨服比武前三名
function LuaMain:attack(index)
    Events.Brocast('show_top3_info',index)
end

--修参拜状态，防止进入参拜时建筑物被多次调用！
function LuaMain:setInJibaiState(value)
    isInJibaiState = value
end

function LuaMain:openWithSound(id)
    if uSuperLink.openModule(id) ~= nil then
        MusicManager.playByID(16)
    else
        MusicManager.playByID(19)
    end
end

--登陆
function LuaMain:login()
    -- body
    MusicManager.stopAllMusic()
    MusicManager.playByID(15)

    UIMrg:pushWindow("Prefabs/moduleFabs/loginModule/zhanghao")
	--todo:zhangqingbin 移至其它地方
    --Tool:initCharPiece()
end

function LuaMain:logout()
    local that = self
    DialogMrg.ShowDialog(TextMap.TXT_LOGIN_OUT, function(...)
        --退出云娃
        --require("uLuaModule/modules/chat/ChatController.lua")
        --ChatController.Quit()
        if (ClientTool.Platform == "android" or ClientTool.Platform == "ios") and isSdk == 1 then
            mysdk:logout("")
        else
            ClientTool.LoadLevel("login", function(ll)
            end)
        end
    end, function(...)
    end)
end

function LuaMain:Slogout(code)
    local that = self
    Debug.Log("Slogout")
    Player:clear()
    local row = TableReader:TableRowByID("errCode", code or -200);
    local desc = TextMap.getText('Slogout')
    if row ~= nil then
        desc = row.desc or TextMap.getText('Slogout')
    end
    DialogMrg.ShowDialog(desc, function(...)
        --require("uLuaModule/modules/chat/ChatController.lua")
        --ChatController.Quit()
        PlayerPrefs.SetInt("FightSpeed", 0);
        ClientTool.LoadLevel("login", function(ll)
        end)
    end, function() 
        LuaMain:goToLoginUI() 
    end)
end

--跳回登录界面
function LuaMain:goToLoginUI()
    PlayerPrefs.SetInt("FightSpeed", 0);
    ClientTool.LoadLevel("login", function(ll)
    end)
end

function LuaMain:SDKlogout()
    --ChatController.Quit()
	--GameObject.DestroyObject(GlobalVar.UI)
    PlayerPrefs.SetInt("FightSpeed", 0);
    ClientTool.LoadLevel("login", function(ll)
    end)
end

--创建公会场景建筑名
function LuaMain:createGongHuiBuildName()
    -- if self.buildName_gonghui == nil then
    --     self.buildName_gonghui = ClientTool.loadAndGetLuaBinding("Prefabs/moduleFabs/mainScene/buildName_gonghui", GlobalVar.center)
    -- else
    --     GameObject.Destroy(self.buildName_gonghui.gameObject)
    --     self.buildName_gonghui = nil
    --     self.buildName_gonghui = ClientTool.loadAndGetLuaBinding("Prefabs/moduleFabs/mainScene/buildName_gonghui", GlobalVar.center)
    -- end
    -- self.buildName_gonghui:CallUpdate({})
end

--销毁公会场景建筑名
function LuaMain:destroyGongHuiBuildName()
    if self.buildName_gonghui ~= nil then
        GameObject.Destroy(self.buildName_gonghui.gameObject)
        self.buildName_gonghui = nil
    end
end

--主场景ui
function LuaMain:LoadMainMenu(mainScene)
    if self.bind_ == nil then
        self.bind_ = Tool.replace("main_menu", "Prefabs/moduleFabs/mainModule/main_menu", mainScene, true)
		self.bind_:CallUpdate(mainScene)
    else
        self.bind_:CallUpdate(mainScene)
    end
    return self.bind_
end

function LuaMain:ResetMainMenu()
end

--[[
3	公会商店
4	竞技场商店
5	虚夜宫
-- ]]
function LuaMain:showShop(type)
    local shoptype = 0
    TableReader:ForEachLuaTable("shop_refresh", function(k, v)
        if v.shop ==type then 
            shoptype=v.sell_type
        end
        return false
        end)
    local binding
    if shoptype==0 then 
        binding = Tool.push("store","Prefabs/moduleFabs/puYuanStoreModule/store",{type})
    else 
        binding = Tool.push("store","Prefabs/moduleFabs/puYuanStoreModule/storeTwo",{type}) 
    end
    binding:CallTargetFunction("updateOpenPath",true) 
end

--type
-- 1. 4个属性的 
-- 2. 3个属性的 不要精力
-- 3. 3个属性的 不要体力
function LuaMain:ShowTopMenu(type, close,data)
	type = type or 1
    local binding = self.topMenu_
    if (self.topMenu_ == nil) then
        binding = ClientTool.loadAndGetLuaBinding("Prefabs/moduleFabs/mainModule/top_menu", GlobalVar.MainUI)
        self.topMenu_ = binding
        UIMrg:setTopMenu(binding)
    end

    self.topMenu_.gameObject:SetActive(true)
    self.topMenu_:CallUpdate({ type = type or 1, close = close,data = data})

    local module = UIMrg:GetRunningModule()
    if module then
        module:showTopMenu({ type = type or 1, close = close,data = data})
    end
    return binding
end

function LuaMain:HideTopMenu( ... )
    if self.topMenu_~=nil then 
        self.topMenu_.gameObject:SetActive(false)
    end 
end

function LuaMain:refreshTopMenu()
    if (self.topMenu_ == nil) then
        binding = ClientTool.loadAndGetLuaBinding("Prefabs/moduleFabs/mainModule/top_menu", GlobalVar.MainUI)
        self.topMenu_ = binding
        UIMrg:setTopMenu(binding)
    end
    local binding = self.topMenu_
    if binding~=nil  then 
        binding:CallTargetFunction("onUpdate",true)
    end 
end

function LuaMain:showFormation(teamIndex)
    UIMrg:pushWindow("Prefabs/moduleFabs/formationModule/formation/gui_formation", { teamIndex = teamIndex })
end


function LuaMain:getTeamByIndex(index)
    --    print(index)
    index = 0
    local teams = Player.Team[index].chars
    local t = {}
    local hasEnterCount = 0
    for i = 0, 5 do
        local id = 0
        if teams.Count > i then
            if teams[i .. ""] ~= 0 and teams[i .. ""] ~= "0" then --可以添加一个从服务器端传过来的死亡状态，如果死亡则不上阵
            id = teams[i .. ""]
            end
        end
        if id == 0 then
            hasEnterCount = hasEnterCount + 1
        end
        table.insert(t, id)
    end
    if hasEnterCount == 6 then
        if index ~= 0 then return nil end
        local row = TableReader:TableRowByUnique("teamid", "teamid", index)
        local chars = Player.Chars:getLuaTable()
        local index = 0
        for k, v in pairs(chars) do
            index = index + 1
            if index <= hasEnterCount then
                if row.team_limit_type == "level" and chars[k].level >= row.team_limit_arg then
                    t[index] = k
                elseif row.team_limit_type == "sex" then
                    local tb = TableReader:TableRowByID("char", Tool.getDictId(k) )
                    if tb.sex == tb.sex then
                        t[index] = k
                    end
                end
            else
                return t
            end
        end
    end
    return t
end

--检查错误代码是否要作特殊处理
function LuaMain:checkErrCode(errCode, errorObj)
    print(errCode)
    if errCode == 22 then
        --金币不足
        --if UIMrg:GetRunningModuleName() == "shop_puyuan" then
            MessageMrg.show(TextMap.GetValue("Text1"))
        --    return
        --end
       --[[ DialogMrg.ShowDialog(TextMap.getText("TXT_GO_TO_BUY_MONEY", {}), function()
            local shoptype = 0
            TableReader:ForEachLuaTable("shop_refresh", function(k, v)
                if v.shop ==7 then 
                    shoptype=v.sell_type
                end
                return false
                end)
            if shoptype==0 then 
                Tool.push("store","Prefabs/moduleFabs/puYuanStoreModule/store",{7})
            else 
                Tool.push("store","Prefabs/moduleFabs/puYuanStoreModule/storeTwo",{7})
            end
        end)]]
        return true
    elseif errCode == 28 or errCode == 103 then
        print_t(errorObj)
        if errorObj:ContainsKey("type") then
            local row = TableReader:TableRowByID("errCode", 103);
            local desc = row.desc
            local type = row.type
            local vo = itemvo:new(errorObj["type"], 1, errorObj["id"], 1, " ")
            if vo ~= nil then
                if vo.itemName == TextMap.getText("ITEM_GU_LING_WAN") or vo.itemName == TextMap.getText("ITEM_LING_HUA_XIAO_ZI") then
                    DialogMrg.ShowDialog(string.gsub(TextMap.TXT_GO_TO_SHOP_BUY_ITEM, "{0}", vo.itemName), function()
                        uSuperLink.openModule(127)
                    end)
                    return true
                end
                desc = UluaModuleFuncs.Instance.uOtherFuns:fillString({ vo.itemName }, desc)
            end
            if type == "message" then
                MessageMrg.show(desc)
            elseif type == "window" then
                DialogMrg.ShowDialog(desc)
            end
        elseif errCode == 28 then
            local row = TableReader:TableRowByID("errCode", 28);
            local desc = row.desc
            DialogMrg.ShowDialog(desc)
        end
        return true
    elseif errCode == 23 then
        --钻石不足
        local row = TableReader:TableRowByID("errCode", errCode)
        local desc = row.desc
        DialogMrg.ShowDialog(desc, function()
            DialogMrg.chognzhi()
        end)
        return true
    elseif errCode == 27 then
        --vip等级不足
        local row = TableReader:TableRowByID("errCode", errCode)
        local desc = row.desc
        DialogMrg.ShowDialog(desc, function()
            DialogMrg.chognzhi()
            --            MessageMrg.show("这里要弹充值。。")
        end)
        return true
    elseif errCode == 24 then
        --体力不足
        local cb = function()
            LuaMain:refreshTopMenu()
        end
        DialogMrg:BuyBpAOrSoul("bp", TextMap.GetValue("Text2"),cb,cb)
        return true

    elseif errCode == 17 then
        --灵子不足,跳到杂货
        local cb = function()
            LuaMain:refreshTopMenu()
        end
        DialogMrg:BuyBpAOrSoul("soul", TextMap.GetValue("Text3"),cb ,cb)
        return true
    elseif errCode == -11 then
        DialogMrg.ShowDialog(TextMap.GetValue("Text4"), function()
        end, true)
        return true
    elseif errCode == -200 then
        LuaMain:Slogout()
        -- Network:disconnectAll()
        return true
    elseif errCode == 152 then
		if errorObj and errorObj.url ~= nil then 
			-- 大版本不对， 去下载
			self:checkPackage(errCode, errorObj.url)
		else 
			LuaMain:Slogout(errCode)
		end 
        return true
    end

    return false
end

function LuaMain:checkPackage(code, url)
	local that = self
    local row = TableReader:TableRowByID("errCode", code or -200);
    local desc = TextMap.getText('Slogout')
    if row ~= nil then
        desc = row.desc or TextMap.getText('Slogout')
    end
    DialogMrg.ShowDialog(desc, function(...)
        that:downPackage(url)
    end, function() 
		ClientTool.onQuit()
    end, TextMap.GetValue("Text_1_1"), "", "下载", "退出")
end 

function LuaMain:downPackage(url)
	Application.OpenURL(url)
end

--显示灵络
function LuaMain:showLingLuo(char, target)
    --    UIMrg:CallRunnigModuleFunction("setLingLuo",{ll = ll})
    ClientTool.LoadLevel("linLuoPan", function(ll)
        Tool.push("lingluo", "Prefabs/moduleFabs/charModule/lingluo/lingluo", {
            char = char,
            delegate = target,
            ll = ll
        })
    end)
end

--显示服务器错误代码,以及对应参数
function LuaMain:showErrorCode(errCode, oRet)
    if errCode == 114 then 
        print("活动已结束")
        return
    end 
    if LuaMain:checkErrCode(errCode, oRet) then return end
    local row = TableReader:TableRowByID("errCode", errCode);
    if row ~= nil then
        local desc = row.desc
        local type = row.type
        if desc == "" or desc == nil then return end
        if type == "message" then
            require("uLuaModule/dialog/MessageMrg")
            MessageMrg.show(desc)
        elseif type == "window" then
            DialogMrg.ShowDialog(desc, function() end, true)
        elseif type == "none" then
        end
    end
end

--1 显示小红点  0 隐藏小红点
function LuaMain:showChatPoint(bol)
    Events.Brocast('chat_redPoint', bol)
end

function LuaMain:showChatWindow()
    local _table = {}
    _table.id = "hi"
    Tool.push("chat", "Prefabs/moduleFabs/chatModule/chatModule", _table)
end

--退出游戏
function LuaMain:QuitGame()
    if (ClientTool.Platform == "android" or ClientTool.Platform == "ios") and isSdk == 1 then
        mysdk:exit(function()
            Debug.Log("onExit callback")
            DialogMrg.ShowDialog(TextMap.GetValue("Text5"), function()
                print("asdf" .. ClientTool.Platform)
                ClientTool.onQuit()
                --ChatController.Quit()
            end)
        end, function()
            -- body
            ClientTool.onQuit()
            --ChatController.Quit()
        end)
    else
        print("android is enter")
        DialogMrg.ShowDialog(TextMap.GetValue("Text5"), function()
            print("asdf " .. ClientTool.Platform)
            ClientTool.onQuit()
            --ChatController.Quit()
        end)
    end
end

--关闭页面回收内存
function LuaMain:collect()
    --    local count = collectgarbage("count")
    collectgarbage("collect")
    --    print("lua回收了：" .. count - collectgarbage("count"))
end

--显示loading tips
function LuaMain:getTips()
    if self.__messageListCount == nil then
        self.__messageList = {}
        self.__messageListCount = TableReader:getTableRowCount("loadTips")
    end

    local index = math.random(self.__messageListCount)
    if self.__messageList[index] == nil then
        local row = TableReader:TableRowByID("loadTips", index)
        if row then
            local desc = row.desc
            self.__messageList[index] = desc
        end
    end
    return self.__messageList[index] or ""
end

return LuaMain

