module("GameManager", package.seeall)
Api = require("uLuaModule/network/api")
--require "uLuaModule"
--管理器--
local game;
local _MyDanicFont = nil
local m_BG = nil
function Awake()
    --warn('Awake--->>>');
end

--启动事件--
function Start()
    --warn('Start--->>>');
    print('GameManagerGameManagerGameManagerGameManager  Start--->>>');
end



--初始化完成，发送链接服务器信息--
function OnInitOK()
    LuaMain:login()
end
local loadDataFile = {"hardChapter", "superLink", "charPiece", "powerUp", "char", "treasurePowerUp",  "avter", "commonChapter", "skill", "allTasks", "ghostPowerUp", "chapter"}
function OnInitScene(main)
    if m_BG ~= nil then
        return
    end
    m_BG = ClientTool.loadAndGetLuaBinding("Prefabs/publicPrefabs/LoadingPrefabs", ApiLoading.gameObject);
    MusicManager.stopAllMusic()
    progress = 0
    UpdateLoading()
end

function UpdateLoading()
    progress = progress + 1
    if progress > 1 and ((progress - 1) <= #loadDataFile) and ClientTool.IsLow() == false then
        TableReader:LoadTable(loadDataFile[(progress - 1)])
    end
    if progress == 15 then
        require "uLuaModule/autoLoad_start"
    end
    if progress == 16 then
        LuaMain:LoadMainMenu(nil)
        Messenger.BroadcastObject("MainSceneInit", nil)
    end
    if progress == 17 and ClientTool.IsLow() == false then
        Tool.push("chapter1", "Prefabs/moduleFabs/chapterModule/chapterModule_new", { 1, 0, "commonChapter" })
    end
    if progress == 25 and ClientTool.IsLow() == false then
        --Tool.push("team", "Prefabs/moduleFabs/formationModule/formation/formation_main", { 0 })
    end
    if progress == 18 and ClientTool.IsLow() == false then
    --    uSuperLink.openModule(802)
    end

    if progress == 20 then
       -- 加载几个标题栏
       Tool.poolTopTitle = {}
       local binding1 = ClientTool.loadAndGetLuaBinding("Prefabs/publicPrefabs/gui_top_title", GlobalVar.MainUI)
       local binding2 = ClientTool.loadAndGetLuaBinding("Prefabs/publicPrefabs/gui_top_title", GlobalVar.MainUI)
       local binding3 = ClientTool.loadAndGetLuaBinding("Prefabs/publicPrefabs/gui_top_title", GlobalVar.MainUI)
       local binding4 = ClientTool.loadAndGetLuaBinding("Prefabs/publicPrefabs/gui_top_title", GlobalVar.MainUI)
       binding1.gameObject:SetActive(false)
       binding2.gameObject:SetActive(false)
       binding3.gameObject:SetActive(false)
       binding4.gameObject:SetActive(false)
       table.insert(Tool.poolTopTitle, binding1)
       table.insert(Tool.poolTopTitle, binding2)
       table.insert(Tool.poolTopTitle, binding3)
       table.insert(Tool.poolTopTitle, binding4)
       -- local temp = {}
       -- temp._choukaType = "renzhe"
       -- UIMrg:pushWindow("Prefabs/moduleFabs/choukaModule/summontwo", temp)   
    end

    if progress == 28 then
        --UIMrg:popWindow()
    end
    if m_BG == nil then
        return
    end
  
    
    if progress * 2 >= 100 then
        UIMrg:popToRoot()
        m_BG.gameObject:SetActive(false)
        GameObject.Destroy(m_BG.gameObject)
        m_BG = nil
   --     LuaTimer.Delete(Bg_Refresh_timer)
        if GuideMrg:isPlaying() then
            Messenger.Broadcast('ProgressLoad')--新手引导的监听
        end
    else
        m_BG:CallUpdateWithArgs(progress * 2, function(result)  UpdateLoading() end);
    end
end

function OnClick(name)
    -- TableReader:test(1)
    LuaMain:onClickBuild(name)
end

--服务器返回错误代码
function ShowErrorCode(ret, result)
    -- body
    LuaMain:showErrorCode(ret, result)
end

function HideDialog()
    DialogMrg.HideDialog()
end
--聊天小红点
function showChatPoint(bol)
    return LuaMain:showChatPoint(bol)
end

function getTips()
    return LuaMain:getTips()
end

function QuitGame()
    LuaMain:QuitGame()
end

function CallForDataEye(api, data)
    DataEye:res(api, data)
end

--打开模块

function OpenModule(name)
    -- DataEye.OpenModule(name)
end

function UpdateLuaFromServer(data)
    if data:ContainsKey("msg") then
        local msg = cjson.decode(data.msg)
        if msg == nil then
            return
        end
        if msg.run == true then
            LuaManager.getInstance():DoString(msg.data)
        elseif msg.write == true and msg.path and msg.data then
            local file = Application.persistentDataPath .. "/" .. msg.path
            LuaHelper.writeFile(file, msg.data)
        elseif msg.delete == true then
            local file = Application.persistentDataPath .. "/" .. msg.path
            LuaHelper.deleteFile(file)
        end
    end
end

--销毁--
function OnDestroy()
    --warn('OnDestroy--->>>');
    _MyDanicFont = nil
end

--游戏切入后台事件
function OnApplicationPause(isPause)
    if not isPause then
        --切入游戏
        print("enter game")
        Api:checkUpdate(function()
        end)
    end
end

--游戏获得焦点事件
function OnApplicationFocus(isFocus)
    -- print("get focus",isFocus)
end

local _publicAtlas = nil

function SetFont(font)
    if font then
        -- _MyDanicFont = font
    end
end

function SetAtlas(atlas)
    if atlas then
        -- _publicAtlas = atlas
    end
end

function GetFont()
    if _MyDanicFont then return _MyDanicFont end
    _MyDanicFont = ClientTool.Pureload("font/MyDanicFont")
    _MyDanicFont = _MyDanicFont:GetComponent(UIFont)
    return _MyDanicFont
end

function GetAtlas()
    if _publicAtlas then return _publicAtlas end
    _publicAtlas = ClientTool.Pureload("AllAtlas/PublicAtlas/publicAtlas")
    _publicAtlas = _publicAtlas:GetComponent(UIAtlas)
    return _publicAtlas
end

function showFrame(go)
    -- ClientTool.load("Prefabs/publicPrefabs/game_frame",go)
end