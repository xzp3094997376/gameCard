ChatController = {}
ChatUtil = require("uLuaModule/modules/chat/ChatUtil.lua")

local ChatModel = require("uLuaModule/modules/chat/ChatModel.lua")	
local ChatView = require("uLuaModule/modules/chat/ChatView.lua")
local YunVaAPI = require("uLuaModule/modules/chat/YunVaAPI.lua")

--初始化
function ChatController.Initialize(gameServerId)
	LuaTimer.Add(2 * 1000, function()
		if not gameServerId or ChatUtil.IsInited then return end

		print("ChatController.Initialize ++++++++++++++++++++++++++++++++++++++++")
		ChatUtil.IsInited = true
	 	ChatModel:Initialize(ChatController)
	 	ChatView:Initialize(ChatController)
	 	ChatUtil.Initialize(ChatController, gameServerId)

		ChatController.GetFriendList()
		ChatController.GetBlackList()

	 	ChatController.YunVa_Init()
	 	require("uLuaModule/modules/realTimeVoice/RealTimeVoiceController.lua")
	 	--RealTimeVoiceController.Initialize()
	end)
end 

--获取ChatView
function ChatController.GetChatView()
	return ChatView
end

--获取ChatModel
function ChatController.GetChatModel()
	return ChatModel
end

--获取好友名单
function ChatController.GetFriendList()
	Api:getSocialList("friend", ChatController.SetFriendList, function ()
	end)
end

--获取黑名单
function ChatController.GetBlackList()
	Api:getSocialList("black", ChatController.SetBlackList, function ()
	end)
end

--设置好友名单
function ChatController.SetFriendList(result)
	local friendList = {}
	local count = result.list.Count

	for i = 0, count - 1 do
		local pid = result.list[i].pid
		friendList[pid] = pid
	end
	ChatUtil.SetFriendList(friendList)
end

--设置黑名单
function ChatController.SetBlackList(result)
	local blackList = {}
	local count = result.list.Count

	for i = 0, count -1 do
		local pid = result.list[i].pid
		blackList[pid] = pid
	end
	ChatUtil.SetBlackList(blackList)

	--将ChatModel中关于黑名单的信息都删掉
	ChatModel:DeleteBlackListMsg(blackList)
end

--删除ChatView中的黑名单私聊消息
function ChatController.DeleteViewBlackMsg(userInfo)
	ChatView:DeleteViewBlackMsg(userInfo)
end

--ChatModel发来的消息通知
function ChatController.MsgNotify(msg)
	ChatUtil.IsLoginSuc = true	--收到消息也算成功了
	ChatView:MsgNotify(msg)
end

--设置频道消息的目前索引
function ChatController.SetChannelMsgIndex(msg)
	ChatModel:SetChannelMsgIndex(msg)
end

--设置玩家私聊消息的索引
function ChatController.SetP2PUserMsgIndex(gameUserId)
	ChatModel:SetP2PUserMsgIndex(gameUserId)
end

--初始化登录次数
local initRetryTimes = 0
--初始化云娃
function ChatController.YunVa_Init()
	
end

--登陆
function ChatController.Login()
	
end

--登录重试次数
local loginRetryTimes = 0
--登录
function ChatController.CheckLogin()
	if loginRetryTimes > 0 and loginRetryTimes < 5 then return end

	if not ChatUtil.IsLoginSuc then
		loginRetryTimes = 0
		ChatController.Login()
	end
end

--登陆回调
function ChatController.LoginRsp(data)
    if data.result == 0 then
    	ChatUtil.IsLoginSuc = true
    	ChatUtil.SetChatUserId(data.userId)

    	LuaTimer.Add(1 * 1000, function()
    		ChatController.GetAllHistoryMsg()
    	end)

    	LuaTimer.Add(2 * 1000, function()
			ChatController.AddChannelMsgNotify()
		    ChatController.AddP2PMsgNotify()  
		    ChatController.AddSystemMsgNotify()
	        ChatController.GetSystemNotice()
    	end)
    else
    	if loginRetryTimes < 5 then
    		loginRetryTimes = loginRetryTimes + 1
	    	print("data.result =========== " .. data.result)
	    	print("data.msg ============== " .. data.msg)
	    	print("登录失败，第" .. loginRetryTimes .. "次重新登录中")
	    	LuaTimer.Add(1 * 1000, function()
	    		ChatController.Login()
	    	end)
	    else
	    	loginRetryTimes = 0
	    	--MessageMrg.show("聊天登录失败，无法使用聊天功能，请见谅")
	    end
    end
end

--退出处理
function ChatController.Quit()
	
end

--添加公会聊天频道
function ChatController.AddSociatyChannel()
	
end

--删除公会聊天频道
function ChatController.DeleteSociatyChannel()
	
end

--发送频道文本消息
function ChatController.SendChannelTextMsg(textMsg, wildCard)
	local sociatyExsit = ChatUtil.CheckSociatyExsit()

	if wildCard ~= ChatModel.ChannelMsg.World.WildCard and not sociatyExsit then
		ChatController.DeleteSociatyChannel()
		print("请先加入军团")
	else
		ChatController.YunVaSendChannelTextMsg(textMsg, wildCard)
	end
end

--发送频道语音
function ChatController.SendChannelVoiceMessage(voicePath, voiceDurationTime, wildCard, attach)
	local sociatyExsit = ChatUtil.CheckSociatyExsit()

	if wildCard ~= ChatModel.ChannelMsg.World.WildCard and not sociatyExsit then
		ChatController.DeleteSociatyChannel()
		print("请先加入军团")
	else
		ChatController.YunVaSendChannelVoiceMsg(voicePath, voiceDurationTime, wildCard, attach)
	end
end

--发送频道文本消息
function ChatController.YunVaSendChannelTextMsg(textMsg, wildCard)
	
end

--发送频道语音
function ChatController.YunVaSendChannelVoiceMsg(voicePath, voiceDurationTime, wildCard, attach)
	
end


--发送私聊文字，私聊没有禁言
function ChatController.SendP2PTextMessage(gameUserId, userInfo, textMsg)

end

--发送私聊语音，私聊没有禁言
function ChatController.SendP2PVoiceMessage(gameUserId, userInfo, filePath, voiceDurationTime, attach)
	
end

--添加监听,频道聊天通知
function ChatController.AddChannelMsgNotify()

end

--添加监听，系统消息通知
function ChatController.AddSystemMsgNotify()
	
end

--获取系统公告，pc上不返回
function ChatController.GetSystemNotice()
	
end

--添加监听,私聊聊天通知
function ChatController.AddP2PMsgNotify()

end

local hisTimeId = nil 	--定时器id
--获取所有历史消息，包括频道和好友
function ChatController.GetAllHistoryMsg()
	
	--ChatController.GetChannelHistoryMsg(0, -3, ChatModel.ChannelMsg.World.WildCard)

	--获取好友历史消息
	--ChatController.AddFriendNearListNotify()
end

--获取频道历史消息
function ChatController.GetChannelHistoryMsg(index, count, wildcard)
	--index传0就是从最后一条消息获取,填负数是向前请求.
	
end

--最近联系人推送,获取最近联系人
function ChatController.AddFriendNearListNotify()
	
end

--云消息请求,获取玩家聊天记录
function ChatController.CloudMsgRequest(userId, endIndex, limit)
	--source是获取什么类型的消息，你这里填“P2P”
	
end

--监听云消息
function ChatController.AddCloudMsgNotify()
	
end

--开始录音
function ChatController.StartRecord()

end
 
--结束录音
function ChatController.StopRecord(callBack)
--	YunVaAPI:RecordStopRequest(callBack)
end

--播放语音文件
function ChatController.StartPlayRecord(filePath, url, callBack)
--	YunVaAPI:RecordStartPlayRequest(filePath, url, "", callBack)
end

--停止播放语音文件
function ChatController.StopPlayRecord()
--	YunVaAPI:RecordStopPlayRequest()
end

--设置语音识别语言
function ChatController.SpeechSetLanguage()
--	YunVaAPI:SpeechSetLanguage()
end

--进行语音识别
function ChatController.SpeechStart(filePath, callBack)
--	YunVaAPI:SpeechStartRequest(filePath, callBack)
end

--下载语音文件
function ChatController.DownLoadVoiceFile(url, filePath, callBack)
	--YunVaAPI:DownLoadFileRequest(url, filePath, "", callBack)
end

--通过玩家游戏id获取云娃id
function ChatController.GetChatUserId(gameUserId, userInfo, callBack)
	
end

--设置私聊玩家信息
function ChatController.SetP2PUserInfo(gameUserId, chatUserId, userInfo)

end

--打开聊天私聊
function ChatController.OpenP2PUserChat(userInfo, callBack)
	
end

return ChatController