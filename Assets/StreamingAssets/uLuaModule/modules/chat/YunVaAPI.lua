local YunVaAPI = {}

--初始化注册SDK
function YunVaAPI:YunVa_Init(context, appid, path, isTest)
    local init = YunvaIM.YunVaImSDK.instance:YunVa_Init(context, appid, path, isTest)
    return init
end

--登录
function YunVaAPI:YunVaOnLogin(tt, gameServerID, wildCard, readStatus, Response)
    YunvaIM.YunVaImSDK.instance:YunVaOnLogin(tt, gameServerID, wildCard, readStatus, Response)
end

--登出
function YunVaAPI:YunVaLogOut()
    YunvaIM.YunVaImSDK.instance:YunVaLogOut()
end

--开始录音
function YunVaAPI:RecordStartRequest(filePath, ext)
    YunvaIM.YunVaImSDK.instance:RecordStartRequest(filePath, ext)
end

--结束录音
function YunVaAPI:RecordStopRequest(Response)
    YunvaIM.YunVaImSDK.instance:RecordStopRequest(Response)
end

--播放语音文件
function YunVaAPI:RecordStartPlayRequest(filePath, url, ext, Response)
    YunvaIM.YunVaImSDK.instance:RecordStartPlayRequest(filePath, url, ext, Response)
end

--停止播放语音
function YunVaAPI:RecordStopPlayRequest()
    YunvaIM.YunVaImSDK.instance:RecordStopPlayRequest()
end

--设置语音识别语言
function YunVaAPI:SpeechSetLanguage()
    local language = YunvaIM.Yvimspeech_language.im_speech_zn
    YunvaIM.YunVaImSDK.instance:SpeechSetLanguage(language)
end

--进行语音识别
function YunVaAPI:SpeechStartRequest(filePath, Response)
    YunvaIM.YunVaImSDK.instance:SpeechStartRequest(filePath, Response)
end

--上传语音文件
function YunVaAPI:UploadFileRequest(filePath, fileId, Response)
    YunvaIM.YunVaImSDK.instance:UploadFileRequest(filePath, fileId, Response)
end

--下载语音文件
function YunVaAPI:DownLoadFileRequest(url, filePath, fileid, Response)
    YunvaIM.YunVaImSDK.instance:DownLoadFileRequest(url, filePath, fileid, Response)
end

--获取第三方账号信息
function YunVaAPI:YunVaGetThirdBindInfo(appId, userId, Response)
    YunvaIM.YunVaImSDK.instance:YunVaGetThirdBindInfo(appId, userId, Response)
end

--发送私聊--文本
function YunVaAPI:SendP2PTextMessage(userId, textMsg, Response, flag, ext)
    YunvaIM.YunVaImSDK.instance:SendP2PTextMessage(userId, textMsg, Response, flag, ext)
end

--发送私聊--语音
function YunVaAPI:SendP2PVoiceMessage(userId, filePath, audioTime, txt, Response, flag, ext)
    YunvaIM.YunVaImSDK.instance:SendP2PVoiceMessage(userId, filePath, audioTime, txt, Response, flag, ext)
end


--发送频道聊天--文本
function YunVaAPI:SendChannelTextMessage(textMsg, wildCard, Response, ext, flag)
    YunvaIM.YunVaImSDK.instance:SendChannelTextMessage(textMsg, wildCard, Response, ext, flag)
end

--发送频道聊天--语音
function YunVaAPI:SendChannelVoiceMessage(voicePath, voiceDurationTime, wildCard, text, Response, ext, flag)
    YunvaIM.YunVaImSDK.instance:SendChannelVoiceMessage(voicePath, voiceDurationTime, wildCard, text, Response, ext, flag)
end

--添加频道（公会）
function YunVaAPI:AddChannel(channel, wildCard, Response)
    YunvaIM.YunVaImSDK.instance:AddChannel(channel, wildCard, Response)
end

--删除频道（公会）
function YunVaAPI:DleteChannel(channel, wildCard, Response)
    YunvaIM.YunVaImSDK.instance:DleteChannel(channel, wildCard, Response)
end

--频道聊天通知
function YunVaAPI:AddChannelMsgNotify(OnChannelMsgNotify)
    YunvaIM.EventListenerManager.AddListener(YunvaIM.ProtocolEnum.IM_CHANNEL_MESSAGE_NOTIFY, OnChannelMsgNotify)
end

--系统消息通知
function YunVaAPI:AddSystemMsgNotify(OnSystemMsgNotify)
    YunvaIM.EventListenerManager.AddListener(YunvaIM.ProtocolEnum.IM_CHANNEL_PUSH_MSG_NOTIFY, OnSystemMsgNotify)
end

--好友私聊聊天通知
function YunVaAPI:AddP2PMsgNotify(OnP2PMsgNotify)
    YunvaIM.EventListenerManager.AddListener(YunvaIM.ProtocolEnum.IM_CHAT_FRIEND_NOTIFY, OnP2PMsgNotify)
end

--获取频道历史消息
function YunVaAPI:getChannelHistoryMsg(index, count, wildcard, Response)
    YunvaIM.YunVaImSDK.instance:getChannelHistoryMsg(index, count, wildcard, Response)
end

--最近联系人推送,获取最近联系人
function YunVaAPI:AddFriendNearListNotify(Response)
    YunvaIM.EventListenerManager.AddListener(YunvaIM.ProtocolEnum.IM_FRIEND_NEARLIST_NOTIFY, Response)
end

--云消息请求
function YunVaAPI:cloudMsgRequest(source, id, endIndex, limit, Response)
    YunvaIM.YunVaImSDK.instance:cloudMsgRequest(source, id, endIndex, limit, Response)
end

--监听云消息
function YunVaAPI:AddCloudMsgNotify(OnCloudMsgNotify)
    YunvaIM.EventListenerManager.AddListener(YunvaIM.ProtocolEnum.IM_CLOUDMSG_NOTIFY, OnChannelMsgNotify)
end

--离线消息忽略
function YunVaAPI:outLineMsgIgnoreRequest(source, id, index)
    YunvaIM.YunVaImSDK.instance:outLineMsgIgnoreRequest(source, id, index)
end

--获取公告信息
function YunVaAPI:getChannelGetParamReq(Response)
    YunvaIM.YunVaImSDK.instance:getChannelGetParamReq(Response)
end







----------------------------------
-------------- LBS-----------------
----------------------------------

--更新地理位置请求
function YunVaAPI:UploadLocationReq(Response)
    YunvaIM.YunVaImSDK.instance:UploadLocationReq(Response)
end

--获取位置信息请求(包括更新位置)
function YunVaAPI:GetLocationReq(Response)
    YunvaIM.YunVaImSDK.instance:GetLocationReq(Response)
end

--搜索（附近）用户(包括更新位置)
function YunVaAPI:SearchAroundReq(range, city, sex, time, pageIndex, pageSize, ext, Response, province, district, detail)
    YunvaIM.YunVaImSDK.instance:SearchAroundReq(range, city, sex, time, pageIndex, pageSize, ext, Response, province, district, detail)
end

--隐藏地理位置请求
function YunVaAPI:ShareLocationReq(hide, Response)
    YunvaIM.YunVaImSDK.instance:ShareLocationReq(hide, Response)
end

--设置定位方式
function YunVaAPI:ImLBSSetLocatingTypeReq(isGpsLocate, isWifiLocate, isCellLocate, isNetWork, isBluetooth, Response)
    YunvaIM.YunVaImSDK.instance:ImLBSSetLocatingTypeReq(isGpsLocate, isWifiLocate, isCellLocate, isNetWork, isBluetooth, Response)
end

--设置LBS本地化语言
function YunVaAPI:ImLBSSetLocalLangReq(lang_code, country_code, Response)
    YunvaIM.YunVaImSDK.instance:ImLBSSetLocalLangReq(lang_code, country_code, Response)
end

--获取支持的（包括搜索、返回信息等）本地化语言列表
function YunVaAPI:ImLBSGetSpportLangReq(Response)
    YunvaIM.YunVaImSDK.instance:ImLBSGetSpportLangReq(Response)
end

return YunVaAPI