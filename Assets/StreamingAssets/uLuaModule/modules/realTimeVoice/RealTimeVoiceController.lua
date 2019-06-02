RealTimeVoiceController = {}

local realTimeVoiceAPI = nil

--初始化
function RealTimeVoiceController.Initialize()
    -- local go = GameObject("RealTimeVoice")
    -- realTimeVoiceAPI = go:AddComponent(RealTimeVoiceAPI)

    -- LuaTimer.Add(1 * 1000, RealTimeVoiceController.DelayInit)
end

--延迟初始化
function RealTimeVoiceController.DelayInit()
    realTimeVoiceAPI:RegisterHandler(RealTimeVoiceController.OnMicModeChangeNotify, RealTimeVoiceController.OnSendRealTimeVoiceMsgErr,
        RealTimeVoiceController.OnRealTimeVoiceMsgNotify, RealTimeVoiceController.OnKickOutNotify, RealTimeVoiceController.OnUserStateNotify)

    RealTimeVoiceController.YvChatSDKInit()
end

--实时语音初始化
function RealTimeVoiceController.YvChatSDKInit()
    local appId = ChatUtil.AppId
    local isTest = ChatUtil.IsTest

    realTimeVoiceAPI:YvChatSDKInit(appId, isTest, function(data)
        print("RealTimeVoiceController.YvChatSDKInit result = " .. data)
    end)
end

--队伍模式更换通知
function RealTimeVoiceController.OnMicModeChangeNotify(data)
end

--发送实时语音失败回调
function RealTimeVoiceController.OnSendRealTimeVoiceMsgErr(data)
end

--收到实时语音通知
function RealTimeVoiceController.OnRealTimeVoiceMsgNotify(data)
end

--收到实时语音通知
function RealTimeVoiceController.OnKickOutNotify(data)
end

--用户状态通知
function RealTimeVoiceController.OnUserStateNotify(data)
end


return RealTimeVoiceController