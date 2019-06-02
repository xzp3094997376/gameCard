local ChatUtil =
{
    AppId = 600005, --死神的AppId
    ChatUserId = nil, --自己的云娃Id，登陆成功后设置
    UserInfo = {}, --自己在游戏中的信息，如等级，vip等{nickname , gameUserId, gameServerId, head, level, vip, power, sociatyId}

    VoiceFilePath = Application.persistentDataPath .. "/ChatVoice", --保存语音文件的路径
    IsTest = false, --是否是测试环境
    IsInited = false, --是否已经初始化了
    IsLoginSuc = false, --是否已经登录成功
    MaxGetMsgNum = 20, --一次性向云娃获取的最大消息数量
    msgType = { voice = 1, text = 2 }, --聊天消息类型

    BlackList = {}, --黑名单,key为玩家游戏id，value也为玩家游戏id
    FriendList = {}, --好友名单，key为玩家游戏id，value也为玩家游戏id

    Settings = --一些设置
    {
        World = { Type = "World", MaxMsgNum = 30, MinSendTime = 10, RemainSendTime = 0, TimeId = nil, },
        Sociaty = { Type = "Sociaty", MaxMsgNum = 30, MinSendTime = 10, RemainSendTime = 0, TimeId = nil, },
        P2P = { Type = "P2P", MaxMsgNum = 30, MinSendTime = 3, RemainSendTime = 0, TimeId = nil, },
    },
    PlayVoiceInfo = { IsPlaying = false, CurVoiceItem = nil },
    WordsLimit = 25, --聊天字数限制
    LevelLimit = 5, --聊天等级限制
    UserInfoRefreshTime = 10 * 1000, --10秒去刷新玩家信息
}


local ChatController = nil
local ChatModel = nil
local ChatView = nil

--初始化
function ChatUtil.Initialize(_chatController, gameServerId)
    ChatController = _chatController
    ChatModel = ChatController.GetChatModel()
    ChatView = ChatController.GetChatView()

    ChatUtil.SetUserInfo(gameServerId)
    ChatUtil.LoadSettings()
    ChatUtil.RefreshUserInfo()
end

function ChatUtil.SetUserInfo(gameServerId)
    local userInfo = {}
    userInfo.gameServerId = gameServerId
    userInfo.nickname = Player.Info.nickname
    userInfo.gameUserId = Player.playerId
    userInfo.head = Player.Info.head
    userInfo.level = Player.Info.level
    userInfo.vip = Player.Info.vip
    userInfo.power = Tool.getTeamPower()
    userInfo.sociatyId = Player.Info.guildId
    userInfo.sociatyName = Player.Info.guildName

    ChatUtil.UserInfo = userInfo
end

--刷新玩家信息
function ChatUtil.RefreshUserInfo()
    LuaTimer.Add(ChatUtil.UserInfoRefreshTime, ChatUtil.UserInfoRefreshTime, function()
        ChatUtil.UserInfo.nickname = Player.Info.nickname
        ChatUtil.UserInfo.gameUserId = Player.playerId
        ChatUtil.UserInfo.head = Player.Info.head
        ChatUtil.UserInfo.level = Player.Info.level
        ChatUtil.UserInfo.vip = Player.Info.vip
        ChatUtil.UserInfo.power = Tool.getTeamPower()
        ChatUtil.UserInfo.sociatyId = Player.Info.guildId
        ChatUtil.UserInfo.sociatyName = Player.Info.guildName
    end)
end

--加载设置
function ChatUtil.LoadSettings()
    local settings = ChatUtil.Settings
    settings.World.MaxMsgNum = ChatUtil.ReadTable(1)
    settings.World.MinSendTime = ChatUtil.ReadTable(2)
    settings.Sociaty.MaxMsgNum = ChatUtil.ReadTable(3)
    settings.Sociaty.MinSendTime = ChatUtil.ReadTable(4)
    settings.P2P.MaxMsgNum = ChatUtil.ReadTable(5)
    settings.P2P.MinSendTime = ChatUtil.ReadTable(6)
    ChatUtil.WordsLimit = ChatUtil.ReadTable(7)
    ChatUtil.LevelLimit = ChatUtil.ReadTable(8)
end

--读表
function ChatUtil.ReadTable(id)
    local row = TableReader:TableRowByID("ChatConfig", id)
    print("id ========== " .. id)
    row = json.decode(row:toString())
    return row.args2
end

--设置自己的ChatUserId
function ChatUtil.SetChatUserId(chatUserId)
    ChatUtil.ChatUserId = chatUserId
end

--设置黑名单
function ChatUtil.SetBlackList(blackList)
    ChatUtil.BlackList = blackList
end

--设置好友名单
function ChatUtil.SetFriendList(friendList)
    ChatUtil.FriendList = friendList
end

--获取游戏中信息，返回json格式,发消息时作为扩展消息传入，收消息时再解析，这样就能获取发送的人的信息了
function ChatUtil.GetUserExt()
    local gameServerId = ChatUtil.UserInfo.gameServerId
    local nickname = ChatUtil.UserInfo.nickname
    local gameUserId = ChatUtil.UserInfo.gameUserId
    local head = ChatUtil.UserInfo.head
    local level = ChatUtil.UserInfo.level
    local vip = ChatUtil.UserInfo.vip
    local power = ChatUtil.UserInfo.power
    local sociatyId = ChatUtil.UserInfo.sociatyId
    local sociatyName = ChatUtil.UserInfo.sociatyName

    local ext = nil
    ext = string.format("{\"nickname\":\"%s\",\"gameUserId\":\"%s\",\"gameServerId\":\"%s\",\"head\":\"%s\",\"level\":\"%s\",\"vip\":\"%s\",\"power\":\"%s\",\"sociatyId\":\"%s\",\"sociatyName\":\"%s\"}",
        nickname, gameUserId, gameServerId, head, level, vip, power, sociatyId, sociatyName)

    return ext
end

--通过消息扩展字段解析玩家信息
function ChatUtil.ParseUserExt(ext)
    local extTb = json.decode(ext)
    return extTb
end

--判断是否是玩家自己的信息
function ChatUtil.IsMsgSelf(extTable)
    return extTable.gameUserId == ChatUtil.UserInfo.gameUserId
end

--获取当前时间
function ChatUtil.GetCurTime()
    local time = os.time()
    local tab = ""

    if time then
        tab = os.date('%Y-%m-%d %X', time)
    else
        tab = os.date('%Y-%m-%d %X')
    end

    return tab
end

--根据云娃userId设置录音文件的路径
function ChatUtil.GetUserVoicePath(chatUserId)
    local time = os.time()
    local filePath = ChatUtil.VoiceFilePath .. "/" .. chatUserId .. time .. ".amr"

    return filePath
end

--获取自己的录音文件路径
function ChatUtil.GetUserSelfVoicePath()
    local userId = ChatUtil.ChatUserId
    local filePath = ChatUtil.GetUserVoicePath(userId)

    return filePath
end

--判断文件是否存在
function ChatUtil.FileExists(path)
    local file = io.open(path, "rb")
    if file then file:close() end

    return file ~= nil
end

--通过wildCard获取聊天类型
function ChatUtil.GetChannelTypeFromWildCard(wildCard)
    local chnInfo = ChatModel.ChannelMsg
    for k, v in pairs(chnInfo) do
        if v.WildCard == wildCard then
            return v.Type
        end
    end
end

--检测是否是好友
function ChatUtil.CheckIsFriend(gameUserId)
    return ChatUtil.FriendList[gameUserId] ~= nil
end

--检测是否是黑名单
function ChatUtil.CheckIsBlack(gameUserId)
    return ChatUtil.BlackList[gameUserId] ~= nil
end

--检测公会是否存在
function ChatUtil.CheckSociatyExsit()
    local sociatyId = Player.Info.guildId

    return sociatyId and sociatyId ~= ""
end

--聊天发送计时
function ChatUtil.CountDownSendTime(type)
    if type == ChatUtil.Settings.World.Type then
        ChatUtil.CountDownWorld()
    elseif type == ChatUtil.Settings.Sociaty.Type then
        ChatUtil.CountDownSociaty()
    elseif type == ChatUtil.Settings.P2P.Type then
        ChatUtil.CountDownP2P()
    end
end

--世界发送计时
function ChatUtil.CountDownWorld()
    local world = ChatUtil.Settings.World
    world.RemainSendTime = world.MinSendTime
    ChatView:ShowRemainSendTime(world.Type, world.RemainSendTime)

    if world.RemainSendTime > 0 and not world.TimeId then
        world.TimeId = LuaTimer.Add(1000, 1000, function()
            world.RemainSendTime = world.RemainSendTime - 1
            ChatView:ShowRemainSendTime(world.Type, world.RemainSendTime)

            if world.RemainSendTime <= 0 then
                LuaTimer.Delete(world.TimeId)
                world.TimeId = nil
            end
        end)
    end
end

--公会发送计时
function ChatUtil.CountDownSociaty()
    local sociaty = ChatUtil.Settings.Sociaty
    sociaty.RemainSendTime = sociaty.MinSendTime
    ChatView:ShowRemainSendTime(sociaty.Type, sociaty.RemainSendTime)

    if sociaty.RemainSendTime > 0 and not sociaty.TimeId then
        sociaty.TimeId = LuaTimer.Add(1000, 1000, function()
            sociaty.RemainSendTime = sociaty.RemainSendTime - 1
            ChatView:ShowRemainSendTime(sociaty.Type, sociaty.RemainSendTime)

            if sociaty.RemainSendTime <= 0 then
                LuaTimer.Delete(sociaty.TimeId)
                sociaty.TimeId = nil
            end
        end)
    end
end

--私聊发送计时
function ChatUtil.CountDownP2P()
    local p2p = ChatUtil.Settings.P2P
    p2p.RemainSendTime = p2p.MinSendTime
    ChatView:ShowRemainSendTime(p2p.Type, p2p.RemainSendTime)

    if p2p.RemainSendTime > 0 and not p2p.TimeId then
        p2p.TimeId = LuaTimer.Add(1000, 1000, function()
            p2p.RemainSendTime = p2p.RemainSendTime - 1
            ChatView:ShowRemainSendTime(p2p.Type, p2p.RemainSendTime)

            if p2p.RemainSendTime <= 0 then
                LuaTimer.Delete(p2p.TimeId)
                p2p.TimeId = nil
            end
        end)
    end
end

--设置播放语音信息
function ChatUtil.SetPlayVoiceInfo(isPlaying, curVoiceItem)
    ChatUtil.PlayVoiceInfo.IsPlaying = isPlaying
    ChatUtil.PlayVoiceInfo.CurVoiceItem = curVoiceItem
end

return ChatUtil