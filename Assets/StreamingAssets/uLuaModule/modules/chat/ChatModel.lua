local ChatModel =
{
    ChannelMsg = --每个频道对应一个table,包括一些信息以及消息列表
    {
        World = { Channel = 1, Type = "World", WildCard = "World", CurMsgIndex = 0, MsgList = {} }, --世界
        Sociaty = { Channel = 2, Type = "Sociaty", WildCard = nil, CurMsgIndex = 0, MsgList = {} }, --公会
    },
    P2PMsg =
    {--GameUserId = {}	--每个玩家游戏id对应一个table,key为玩家游戏id，value为{ChatUserId = , UserInfo = , IsInChat = , CurMsgIndex = 0, MsgList = {}},
        --UserInfo为私聊玩家的信息
    },
    SystemNotice = TextMap.GetValue("Text545"), --系统公告,只是一个字符串
}

--ChatController
local ChatController = nil

--初始化
function ChatModel:Initialize(_chatController)
    ChatController = _chatController
    ChatModel:SetSociatyWildCard()
end

--通知ChatController有消息，需要更新界面
function ChatModel:MsgNotify(msg)
    ChatController.MsgNotify(msg)
end

--设置公会
function ChatModel:SetSociatyWildCard()
    local sociatyExsit = ChatUtil.CheckSociatyExsit()

    if sociatyExsit then
        ChatModel.ChannelMsg.Sociaty.WildCard = Player.Info.guildId
    else
        ChatModel.ChannelMsg.Sociaty.WildCard = nil
        ChatModel.ChannelMsg.Sociaty.MsgList = {}
        ChatModel.ChannelMsg.Sociaty.CurMsgIndex = 0
    end
end

--添加系统公告
function ChatModel:AddSystemNotice(notice)
    ChatModel.SystemNotice = notice
end

--获取系统公告
function ChatModel:GetSystemNotice()
    return ChatModel.SystemNotice
end

--添加系统消息
function ChatModel:AddSystemMsg(msg)
    --消息格式
    local msgTb =
    {
        time = ChatUtil.GetCurTime(),
        msgType = ChatUtil.msgType.text,
        msgBody = msg,
        wildCard = "System",
    }

    --加入世界消息中
    local msgList, channelInfo = ChatModel:GetChannelMsgList(ChatModel.ChannelMsg.World.WildCard)
    msgTb.channelInfo = channelInfo
    ChatModel:CheckAddChannelMsg(msgList, msgTb)
    ChatModel:MsgNotify(msgTb)

    --加入公会消息中
    if ChatModel.ChannelMsg.Sociaty.WildCard then
        msgList, channelInfo = ChatModel:GetChannelMsgList(ChatModel.ChannelMsg.Sociaty.WildCard)
        msgTb.channelInfo = channelInfo
        ChatModel:CheckAddChannelMsg(msgList, msgTb)
        ChatModel:MsgNotify(msgTb)
    end
end

--添加频道消息,其他人的
function ChatModel:AddChannelMsg(msg)
    --消息格式
    local msgTb =
    {
        chatUserId = msg.userId,
        time = ChatUtil.GetCurTime(),
        msgBody = msg.messageBody, --如果为语音信息则为url
        wildCard = msg.wildcard,
        msgType = msg.messageType,
        voiceDuration = msg.voiceDuration,
        filePath = nil, --语音文件的路径
        ext = msg.ext1, --扩展字段,有一些玩家信息在里面
        extTable = ChatUtil.ParseUserExt(msg.ext1), --解析出来
        attach = msg.attach, --语音识别文字
        isHistory = false --是否是历史消息
    }

    --如果是黑名单，就不加入了，直接返回
    local isBlack = ChatUtil.CheckIsBlack(msgTb.extTable.gameUserId)
    if isBlack then return end

    local msgList, channelInfo = ChatModel:GetChannelMsgList(msgTb.wildCard)
    msgTb.channelInfo = channelInfo

    ChatModel:CheckAddChannelMsg(msgList, msgTb)
    ChatModel:MsgNotify(msgTb)
end

--添加频道历史消息
function ChatModel:AddChannelHistoryMsg(msg)
    --消息格式
    local msgTb =
    {
        chatUserId = msg.userId,
        time = msg.ctime,
        msgBody = msg.messageBody,
        wildCard = msg.wildCard,
        msgType = msg.messageType,
        voiceDuration = msg.voiceDuration,
        filePath = nil, --语音文件的路径
        ext = msg.ext1, --扩展字段,有一些玩家信息在里面
        extTable = ChatUtil.ParseUserExt(msg.ext1), --解析出来
        attach = msg.attach, --语音识别文本
        isHistory = true --是否是历史消息
    }

    --如果是黑名单，就不加入了，直接返回
    local isBlack = ChatUtil.CheckIsBlack(msgTb.extTable.gameUserId)
    if isBlack then return end

    local msgList, channelInfo = ChatModel:GetChannelMsgList(msgTb.wildCard)
    msgTb.channelInfo = channelInfo

    ChatModel:CheckAddChannelMsg(msgList, msgTb)
    ChatModel:MsgNotify(msgTb)
end

--添加频道文本消息，自己的
function ChatModel:AddChannelTextMsgSelf(textMsg, wildCard, ext)
    --消息格式
    local msgTb =
    {
        chatUserId = ChatUtil.ChatUserId,
        time = ChatUtil.GetCurTime(),
        msgBody = textMsg,
        wildCard = wildCard,
        msgType = ChatUtil.msgType.text,
        filePath = nil, --语音文件的路径
        ext = ext, --扩展字段,有一些玩家信息在里面
        extTable = ChatUtil.ParseUserExt(ext), --解析出来
        isHistory = false --是否是历史消息
    }

    local msgList, channelInfo = ChatModel:GetChannelMsgList(msgTb.wildCard)
    msgTb.channelInfo = channelInfo

    ChatModel:CheckAddChannelMsg(msgList, msgTb)
    ChatModel:MsgNotify(msgTb)
    print("ChatModel:AddChannelTextMsgSelf msgTb.msgBody == " .. msgTb.msgBody)
end

--添加频道语音消息，自己的
function ChatModel:AddChannelVoiceMsgSelf(voicePath, voiceDurationTime, wildCard, ext, attach)
    --消息格式
    local msgTb =
    {
        chatUserId = ChatUtil.ChatUserId,
        time = ChatUtil.GetCurTime(),
        wildCard = wildCard,
        msgType = ChatUtil.msgType.voice,
        voiceDuration = voiceDurationTime,
        filePath = voicePath, --语音文件的路径
        ext = ext, --扩展字段,有一些玩家信息在里面
        extTable = ChatUtil.ParseUserExt(ext), --解析出来
        attach = attach, --语音文件的识别文字
        isHistory = false --是否是历史消息
    }

    local msgList, channelInfo = ChatModel:GetChannelMsgList(msgTb.wildCard)
    msgTb.channelInfo = channelInfo

    ChatModel:CheckAddChannelMsg(msgList, msgTb)
    ChatModel:MsgNotify(msgTb)
end

--加入私聊消息,其他人的
function ChatModel:AddP2PMsg(msg)
    --消息格式类型
    local msgTb =
    {
        chatUserId = msg.userID,
        time = ChatUtil.GetCurTime(),
        wildCard = nil, --私聊为nil，由此判断是私聊还是频道
        msgBody = msg.data,
        msgType = msg.type,
        voiceDuration = msg.audioTime,
        filePath = nil, --语音文件的路径
        ext = msg.ext1, --扩展字段
        extTable = ChatUtil.ParseUserExt(msg.ext1), --解析出来
        attach = msg.attach, --语音识别文本
        isHistory = false --是否是历史消息
    }

    --如果是黑名单，就不加入了，直接返回
    local isBlack = ChatUtil.CheckIsBlack(msgTb.extTable.gameUserId)
    if isBlack then return end

    local msgList, p2pInfo = ChatModel:GetP2PMsgList(msgTb.extTable.gameUserId, msgTb.chatUserId, msgTb.extTable)
    msgTb.p2pInfo = p2pInfo

    ChatModel:CheckAddP2PMsg(msgList, msgTb)
    ChatModel:MsgNotify(msgTb)
end

--加入私聊历史消息，其他人的
function ChatModel:AddP2PHistoryMsg(msg)
    --消息格式类型 msg为P2PChatMsg
    local msgTb =
    {
        chatUserId = msg.userID,
        time = msg.sendTime,
        wildCard = nil, --私聊为nil，由此判断是私聊还是频道
        msgBody = msg.data,
        msgType = msg.type,
        voiceDuration = msg.audioTime,
        filePath = nil, --语音文件的路径
        ext = msg.ext1, --扩展字段
        extTable = ChatUtil.ParseUserExt(msg.ext1), --解析出来
        attach = msg.attach, --语音识别文字
        isHistory = true --是否是历史消息
    }

    --如果是黑名单，就不加入了，直接返回
    local isBlack = ChatUtil.CheckIsBlack(msgTb.extTable.gameUserId)
    if isBlack then return end

    local msgList, p2pInfo = ChatModel:GetP2PMsgList(msgTb.extTable.gameUserId, msgTb.chatUserId, msgTb.extTable)
    msgTb.p2pInfo = p2pInfo

    ChatModel:CheckAddP2PMsg(msgList, msgTb)
    ChatModel:MsgNotify(msgTb)
end

--加入私聊文本消息,自己的
function ChatModel:AddP2PTextMsgSelf(gameUserId, userId, userInfo, textMsg, ext)
    --消息格式类型
    local msgTb =
    {
        chatUserId = ChatUtil.ChatUserId,
        time = ChatUtil.GetCurTime(),
        wildCard = nil,
        msgBody = textMsg,
        msgType = ChatUtil.msgType.text,
        filePath = nil, --语音文件的路径
        ext = ext, --扩展字段,有一些玩家信息在里面
        extTable = ChatUtil.ParseUserExt(ext), --解析出来
        isHistory = false --是否是历史消息
    }

    local msgList, p2pInfo = ChatModel:GetP2PMsgList(gameUserId, userId, userInfo)
    msgTb.p2pInfo = p2pInfo

    ChatModel:CheckAddP2PMsg(msgList, msgTb)
    ChatModel:MsgNotify(msgTb)
end

--加入私聊语音消息,自己的
function ChatModel:AddP2PVoiceMsgSelf(gameUserId, userId, userInfo, filePath, voiceDurationTime, ext, attach)
    --消息格式类型
    local msgTb =
    {
        chatUserId = ChatUtil.ChatUserId,
        time = ChatUtil.GetCurTime(),
        wildCard = nil,
        msgType = ChatUtil.msgType.voice,
        voiceDuration = voiceDurationTime,
        filePath = filePath, --语音文件的路径
        ext = ext, --扩展字段,有一些玩家信息在里面
        extTable = ChatUtil.ParseUserExt(ext), --解析出来
        attach = attach, --语音文件的识别文字
        isHistory = false --是否是历史消息
    }

    local msgList, p2pInfo = ChatModel:GetP2PMsgList(gameUserId, userId, userInfo)
    msgTb.p2pInfo = p2pInfo

    ChatModel:CheckAddP2PMsg(msgList, msgTb)
    ChatModel:MsgNotify(msgTb)
end

--获取频道消息table
function ChatModel:GetChannelMsgList(wildcard)
    local channelInfo = nil
    local msgList = nil

    if wildcard == ChatModel.ChannelMsg.World.WildCard then
        channelInfo = ChatModel.ChannelMsg.World
        msgList = channelInfo.MsgList
    elseif wildcard == ChatModel.ChannelMsg.Sociaty.WildCard then
        channelInfo = ChatModel.ChannelMsg.Sociaty
        msgList = channelInfo.MsgList
    end

    return msgList, channelInfo
end

--检查并插入频道消息
function ChatModel:CheckAddChannelMsg(msgList, msg)
    local maxMsgNum = 30
    if msg.wildCard == ChatModel.ChannelMsg.World.WildCard then
        maxMsgNum = ChatUtil.Settings.World.MaxMsgNum
    elseif msg.wildCard == ChatModel.ChannelMsg.Sociaty.WildCard then
        maxMsgNum = ChatUtil.Settings.Sociaty.MaxMsgNum
    end

    if #msgList >= maxMsgNum then
        table.remove(msgList, 1) --删掉第一条消息
        if msg.channelInfo.CurMsgIndex > 0 then
            msg.channelInfo.CurMsgIndex = msg.channelInfo.CurMsgIndex - 1
        end
    end

    table.insert(msgList, msg)
end

--获取特定频道的数据
function ChatModel:GetChannelMsgListFromType(type)
    local msgList = nil

    if type == ChatModel.ChannelMsg.World.Type then
        msgList = ChatModel.ChannelMsg.World.MsgList
    elseif type == ChatModel.ChannelMsg.Sociaty.Type then
        msgList = ChatModel.ChannelMsg.Sociaty.MsgList
    end

    return msgList
end

--根据玩家游戏id获取私聊消息table
function ChatModel:GetP2PMsgList(gameUserId, chatUserId, userInfo)
    if not ChatModel.P2PMsg[gameUserId] then
        local p2pInfo =
        {
            ChatUserId = nil,
            UserInfo = nil,
            IsInChat = false,
            CurMsgIndex = 0,
            MsgList = {},
        }

        ChatModel.P2PMsg[gameUserId] = p2pInfo
    end

    local p2pInfo = ChatModel.P2PMsg[gameUserId]
    if chatUserId then
        p2pInfo.ChatUserId = chatUserId
    end
    if userInfo then
        p2pInfo.UserInfo = userInfo
    end

    return p2pInfo.MsgList, p2pInfo
end

--检查并插入私聊消息
function ChatModel:CheckAddP2PMsg(msgList, msg)
    local maxMsgNum = ChatUtil.Settings.World.MaxMsgNum

    if #msgList >= maxMsgNum then
        table.remove(msgList, 1) --删掉第一条消息
        if msg.p2pInfo.CurMsgIndex > 0 then
            msg.p2pInfo.CurMsgIndex = msg.p2pInfo.CurMsgIndex - 1
        end
    end

    table.insert(msgList, msg)
end

--根据玩家游戏id获取云娃id
function ChatModel:GetChatUserIdFromGameUserId(gameUserId)
    if not ChatModel.P2PMsg[gameUserId] then return nil end

    return ChatModel.P2PMsg[gameUserId].ChatUserId
end

--获取私聊玩家信息
function ChatModel:GetP2PUserInfo(gameUserId)
    if not ChatModel.P2PMsg[gameUserId] then return nil end

    return ChatModel.P2PMsg[gameUserId].UserInfo
end

--设置私聊玩家信息
function ChatModel:SetP2PUserInfo(gameUserId, chatUserId, userInfo)
    local msgList, userTable = ChatModel:GetP2PMsgList(gameUserId)

    if chatUserId then
        userTable.ChatUserId = chatUserId
    end

    if userInfo then
        userTable.UserInfo = userInfo
    end
end

--设置频道所读消息索引
function ChatModel:SetChannelMsgIndex(msg)
    --说明读完了
    msg.channelInfo.CurMsgIndex = #msg.channelInfo.MsgList
end

--设置玩家所读消息索引
function ChatModel:SetP2PUserMsgIndex(gameUserId)
    --说明读完了
    local msgList, p2pInfo = ChatModel:GetP2PMsgList(gameUserId)
    p2pInfo.CurMsgIndex = #msgList
end

--设置玩家是否显示在聊天中
function ChatModel:SetP2PUserInChat(gameUserId, isInChat)
    local msgList, p2pInfo = ChatModel:GetP2PMsgList(gameUserId)
    p2pInfo.IsInChat = isInChat

    --清空消息
    if not isInChat then
        for k, v in pairs(msgList) do
            msgList[k] = nil
        end
    end
end

--删除黑名单的所有消息
function ChatModel:DeleteBlackListMsg(blackList)
    for k, v in pairs(blackList) do
        local p2pInfo = ChatModel.P2PMsg[k]
        if p2pInfo then
            ChatModel.P2PMsg[k] = nil
            ChatController.DeleteViewBlackMsg(p2pInfo.UserInfo)
        end
    end
end

return ChatModel