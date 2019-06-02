module("GuideMrg", package.seeall)
local StepData = require("uLuaModule/modules/guide/guide_setting")
local GuideNext = "GuideNext" --下一步
local ClickBuild = "ClickBuild" --点击建筑，下一步
local ClickCpapter = "ClickCpapter" --点击关卡。。
local mStep = "step1"
local mStepLine = 1 --每个分组步骤行数
local mStepCount = 1 --每个分组总步骤数
local CurStep = nil
local CurStepRow = nil
local _isPlaying = false
local BattleState = {
    Start = 0,
    Round = 1,
    WinEnd = 2,
    LoseEnd = 3
}

local _hasStep = false

function Talk(isLeft, name, text, img, black,pic)
    -- 对话
    RotateCamera.canMove = false
    GuideManager.getInstance():ShowTalk(GuideMrg, isLeft, name, text, img, black or false,pic)
end

--隐藏对话
function HideTalk()
    GuideManager.getInstance():HidePlot()
end


--播放剧情
function PlayThePlot()
    GuideManager.getInstance():PlayThePlot()
end


function Find(path)
    local go = nil
    if string.find(path, "GameManager/") then
        path = string.gsub(path, "GameManager/", "")
        local find = GlobalVar.UI.transform:FindChild(path)
        go = find
    else
        go = GameObject.Find(path)
    end
    return go
end

local FindObjectPos = nil
local FindObjectLocalPos = nil
local FindOldParent = nil
local FindObject = nil

function Reset()
    if not Slua.IsNull(FindObject) and not Slua.IsNull(FindOldParent) then
        FindObject.parent = FindOldParent
        NGUITools.SetLayer(FindObject.gameObject, FindOldParent.gameObject.layer)
        FindObject.position = FindObjectPos
        FindObject.gameObject:SetActive(false)
        FindObject.gameObject:SetActive(true)
        FindObject = nil
        FindOldParent = nil
    elseif not Slua.IsNull(FindObject) then
        GameObject.Destroy(FindObject.gameObject)
    end
    GuideManager.getInstance():showNpc("")
    GuideManager.getInstance():hideHand()
    if ObjectParent then 
        local count = ObjectParent.childCount
        for i = 0, count - 1 do 
            local tran = ObjectParent:GetChild(i)
            GameObject.Destroy(tran.gameObject)
        end
    end
end

function Log(log,to_server)
    local res = Player.Resource
    local lastChapter = Player.Chapter.lastChapter
    lastChapter = math.max(lastChapter, 1)
    local lastSection = Player.Chapter.lastSection
    lastSection = math.max(lastSection, 1)
    local pf = GlobalVar.sdkPlatform
    if pf == "android" then 
        pf = GlobalVar.dataEyeChannelID
    end
    local network = "none"
    local _state = Application.internetReachability
    if _state == 2 then 
        network = "wifi"
    elseif _state == 1 then
        network = "other"
    end
    local map = {
        pf, --渠道
        NowSelectedServer, --服务器
        network,
        deviceModel or "null",
        Screen.currentResolution.width .."x"..Screen.currentResolution.height,
        SystemInfo.operatingSystem,
        deviceUniqueIdentifier or "", --设备号
        Player.playerId, --玩家id
        Player.Info.vip.."", --vip
        Player.Info.level.."", --等级
        res.gold.."", --金币
        res.money.."", --银币
        res.bp.."", --体力
        res.soul.."", --灵子
        res.hunyu.."", --魂玉
        lastChapter .. "_" .. lastSection,--关卡进度
        mStep,--当前步骤
        log,--新手log
        (os.time() * 1000) .."",--操作时间
        Player.Info.create .."", --创建日期
        Player.Info.lastLogin .. "", --最后登陆
        -- GlobalVar.dataEyeAppID
    }
    DataEye.logGuide(map)
    local c = 0
    c =  Player.guide:getItem(log)
    c = c+1
    Api:setGuide(log,c,function(result)
        
    end)
end

function SaveLog()
    local id = string.gsub(mStep, "step", "")
    id = tonumber(id) or 0
    if id == nil then return end
    if CurStepRow[2] then
        Api:setGuide(CurStepRow[2], 2, function()
        end)
    else
        Api:setGuide(0, id, function()
        end)
    end
end

local ObjectParent = nil

local model_pre = nil
local size_old = nil
local center_old = nil
local showHand_num = 0

--显示指示箭头
function ShowHand(row)
    showHand_num=showHand_num+1
    if row.condition and type(row.condition) == "function" then 
        print (row.condition()) 
        if not row.condition() then
            RotateCamera.canMove = true
            CallNextStep()
            return
        end
    end
    local path = row.path
    -- print(path)
    local say = row.say or ""
    local pos = row.pos or "left"
    local cb = row.call
    local isBuild = false
    local isCopy = true
    local event = row.event or GuideNext
    local find = Find(path)
    if find == nil then
        if showHand_num<=5 then 
            LuaTimer.Add(500, function()
                print(TextMap.GetValue("Text_1_62") .. showHand_num .."次没找到步骤" .. path)
                ShowHand(row)
            end)
        else 
            print("没找到步骤" .. path)
            RotateCamera.canMove = true
            CallNextStep()
        end 
        return
    end
    local mrg = GuideManager.getInstance()
    if ObjectParent == nil then 
        ObjectParent = GameObject("parent").transform
        ObjectParent.parent = mrg.mParent.transform
        NGUITools.SetLayer(ObjectParent.gameObject, mrg.mParent.layer)
        ObjectParent.localScale = Vector3(1,1,1)
    end

    if model_pre==nil then 
        if Find("GameManager/Camera/mainUI/GuidePanel/GuideCamera/model_pre") ~=nil then 
            model_pre=Find("GameManager/Camera/mainUI/GuidePanel/GuideCamera/model_pre"):GetComponent("UIWidget")
        end 
    end 

    local target = find.gameObject:GetComponent(BuildCtrlTarget)
    RotateCamera.canMove = false
    if target then
        --点击3d模型
        isBuild = true
        RotateCamera.MoveToBuild(target, function()
            mrg:showHand(find.transform, isBuild)
            mrg:showNpc(say, pos)
            RotateCamera.canMove = true
        end)
        Messenger.AddListenerObject(event, function(go)
            if find.gameObject == go then
                Messenger.RemoveListenerObject(event)
                CallNextStep()
            end
        end)
    elseif isCopy then
        --点击按钮
        --复制
        isShowBg(true)
        FindObject = find.transform
        FindObjectPos = find.transform.position
        FindOldParent = find.transform.parent
        FindObjectPos.z = 0
        FindObjectLocalPos = find.transform.localPosition
        FindObjectLocalPos.z = 0

        find.transform.parent = ObjectParent--mrg.mParent.transform
        NGUITools.SetLayer(find.gameObject, mrg.mParent.layer)
        find.transform.position = FindObjectPos

        local box = nil
        if find~=nil then 
            box = find.gameObject:GetComponent("BoxCollider")
            if box ~=nil then 
                size_old=box.size
                center_old=box.center
                if model_pre~=nil then
                    box.size =Vector3(model_pre.width/find.transform.localScale.x,model_pre.height/find.transform.localScale.y,0) 
                else 
                    box.size =Vector3(Screen.width/find.transform.localScale.x,Screen.height/find.transform.localScale.y,0)
                end 
                box.center=Vector3(-find.transform.localPosition.x,-find.transform.localPosition.y,0)
            end 
        end 

        find.gameObject:SetActive(false)
        find.gameObject:SetActive(true)
        print("******event****" .. event)
        if cb then
            UIEventListener.Get(find.gameObject).onClick = function(go)
                print("overwire")
                cb(go)
            end
            Messenger.AddListenerObject(event, function(go)
                if box~=nil then 
                    box.size=size_old
                    box.center=center_old
                end 
                if find.gameObject == go then
                    Messenger.RemoveListenerObject(event)
                    CallNextStep()
                elseif go == event then
                    if string.find(event,"logic") then 
                        local id = string.gsub(mStep, "step", "")
                        id = tonumber(id) or 0
                        PlayerPrefs.SetInt(Player.playerId.."_guide_"..0, id)
                    end
                    Messenger.RemoveListenerObject(event)
                    CallNextStep()
                end
            end)
        else
            Messenger.AddListenerObject(event, function(go)
                if box~=nil then 
                    box.size=size_old
                    box.center=center_old
                end 
                if find.gameObject == go then
                    Messenger.RemoveListenerObject(event)
                    CallNextStep()
                elseif go == event then
                    if string.find(event,"logic") then 
                        local id = string.gsub(mStep, "step", "")
                        id = tonumber(id) or 0
                        PlayerPrefs.SetInt(Player.playerId.."_guide_"..0, id)
                    end
                    
                    Messenger.RemoveListenerObject(event)
                    CallNextStep()
                end
            end)
        end
        mrg:showHand(find.transform, isBuild)
        mrg:showNpc(say, pos)
    else
        print("不复制")
        CallNextStep()
        mrg:showHand(find.transform, isBuild)
        mrg:showNpc(say, pos)
    end
end

function isPlaying()
    return _isPlaying
end

--战斗中是否要播放新手
function IsPlayGuide(state, round)
    if BattleState.WinEnd == state then
        Messenger.Broadcast("BattleWin")
    elseif BattleState.LoseEnd == state then
    end
    return false
end

function isModel(ret)
    GuideManager.isModel(ret)
end

function isShowBg(ret)
    GuideManager.getInstance().show_bg = ret
end

function saveLineEnd()
    mStepLine=mStepCount
end

function TranslateLine()
    Reset()
    CurStepRow = GetCurRow()
    mStepLine = mStepLine + 1
    if CurStepRow == nil or #CurStepRow == 0 then
        CallNextStep()
        return
    end
    _hasStep = true
    isModel(true)
    _isPlaying = true
    local tp = CurStepRow[1]
	print("________TranslateLine")
	print("step = " .. mStep)
	print("mStepLine = " .. mStepLine) --每个分组步骤行数
	print("mStepCount = " .. mStepCount) --每个分组总步骤数
    print ("tp=" .. tp)
	
    if CurStepRow.log then
        Log(CurStepRow.log,CurStepRow.server)
    end
    if tp ~= "talk" then
        HideTalk()
    end

    isShowBg(false)
    if tp == "talk" then
        --对话
        isShowBg(true)
        Talk(CurStepRow[2], CurStepRow[3], CurStepRow[4], CurStepRow[5], CurStepRow[6], CurStepRow[7])
    elseif tp == "text" then
        isShowBg(true)
        local text=ClientTool.loadAndGetLuaBinding("Prefabs/moduleFabs/conversationModule/wenzhang", GuideManager.getInstance().gameObject);
        text:CallUpdate({CurStepRow[2], CurStepRow[3], CurStepRow[4],"guide"})
    elseif tp == "play" then 
        local data = CurStepRow[2]
        local temp = {}
        temp["script"] = data
        temp["battle"] = {["scene"] = "map_015"}
        UluaModuleFuncs.Instance.uOtherFuns:callBackFightFromScrip(temp)
        --TranslateScripts.Inst:ExcuteLuaFile(data)
        CallNextStep()
    elseif tp == "call" then
        --执行下一分组
        CallStep(CurStepRow[2], CurStepRow[3])
    elseif tp == "callFunc" then
        --执行方法
        local fn = CurStepRow[2]
        if fn then fn() end
        CallNextStep()
    elseif tp == "wait" then
        --等待下一个命令
        local msg = CurStepRow[2]
        print("msg=" .. msg)
        if msg == "" or msg == nil then
            CallNextStep()
            return
        end
        local cb = CurStepRow[5]
        if cb == nil then
            Messenger.AddListener(msg, function()
                print("接受msg=" .. msg)
                Messenger.RemoveListenerObject(msg)
                CallNextStep()
            end)
        else
            Messenger.AddListenerObject(msg, cb)
        end
        isModel(false)
    elseif tp == "guide" then
        showHand_num=0
        LuaTimer.Add(500, function()
            ShowHand(CurStepRow)
        end)
    elseif tp == "sleep" then
        --暂停
        local time = tonumber(CurStepRow[2]) or 0
        if time == 0 then
            CallNextStep()
            return
        end
        LuaTimer.Add(time, function()
            CallNextStep()
        end)
    elseif tp == "jump" then
        --跳转页面
        local moudleName, modulePath, openType, arg = CurStepRow[2], CurStepRow[3], CurStepRow[4], CurStepRow[5]
        if openType == "window" then
            UIMrg:pushWindow(modulePath, arg)
        elseif openType == "replace" then
            Tool.replace(moudleName, modulePath, arg)   
        else
            Tool.push(moudleName, modulePath, arg)
        end
        CallNextStep()
    elseif tp == "scene" then
        ClientTool.beginLoadScene(CurStepRow[2], CurStepRow[3] or function(scene)
            print("*********loadScene******")
        end)
        CallNextStep()
    elseif tp == "save" then        
        SaveLog()
        CallNextStep()
    elseif tp == "end" then
        mStepLine = mStepCount + 1
        CallNextStep()
    end
end


function Stop()
    RotateCamera.canMove = true
    HideTalk()
    Reset()
    _isPlaying = false
    isModel(false)
    _hasStep = false
    isShowBg(false)
end

function CallStep(step, line)
    line = line or 1
    if StepData[step] == nil then return end
    if not SettingConfig.isGuideOpen() then 
        Stop()
        return false 
    end
    mStep = step
    mStepLine = line
    CurStep = GetCurStep()
    local isplay = true
    if CurStep.condition and type(CurStep.condition) == "function" then
        isplay = CurStep.condition()
    end
    if not isplay then 
        Stop()
        return false 
    end
    mStepCount = #CurStep
    CallNextStep()
    return true
end

--当前分组
function GetCurStep()
    return StepData[mStep] or {}
end

--当前步骤
function GetCurRow()
    if CurStep then return CurStep[mStepLine] end
    return nil
end

function CallNextStep()
    if mStepLine > mStepCount then
        --没有执行步骤了
        Stop()
        return
    end
    TranslateLine()
end

function hasStep()
    return _hasStep
end

function Brocast(tp, char)
    if tp == "changeSkill" then
        if tonumber(char.id) == 19 and char.lv >= 20 and char.stage == Tool.GetCharArgs("unlock_trans_level") then
            return CallStep("change_skill")
        end
    elseif tp == "charJinHua" then
        if tonumber(char.id) == 19 and char.lv >= 10 then
            return CallStep("jin_hua")
        end
    elseif tp == "charXilian" then
        if char.lv >= 30 then
            return CallStep("xi_lian")
        end
    end
    return false
end