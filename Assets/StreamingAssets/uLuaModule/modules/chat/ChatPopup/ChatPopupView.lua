local ChatPopupView = {}
local ChatView = nil
local ChatModel = nil

local ChatTypes = { World = "World", Sociaty = "Sociaty", P2P = "P2P" } --聊天的类型
local InputType = { Voice = 0, Text = 1 } --输入的类型
local curType = nil --当前类型
local curPid = nil --当类型为P2P时,curPid为私聊的好友pid

function ChatPopupView:Start()
    ChatController.CheckLogin()

    MusicManager.stopAllMusic() --停掉所有音乐
    ChatModel = ChatController.GetChatModel() --获取ChatModel
    ChatView = ChatController.GetChatView() --获取ChatView
    ChatView:RegisterPopupView(self) --在ChatView中注册自身
    ChatModel:SetSociatyWildCard() --每次打开设置公会的WildCard
end

function ChatPopupView:onEnter()
    -- if curType == ChatTypes.World or curType == ChatTypes.Sociaty then
    -- 	self.groupPanel.target:RePosMsg()
    -- elseif curType == ChatTypes.P2P then
    -- 	self.p2pPanel.target:RePosMsg()
    -- end
end

function ChatPopupView:update(userInfo)
    if userInfo and userInfo.gameUserId then
        self:OpenP2PUserChat(userInfo)
    else
        self:SetChatType(ChatTypes.World)
    end
end

function ChatPopupView:OnDestroy()
    --注销
    ChatView:UnRegisterPopupView()
end

--消息通知
function ChatPopupView:MsgNotify(msg)
    if msg.wildCard then
        self:ProcessChannelMsg(msg)
    else
        self:ProcessP2PMsg(msg)
    end

    self:CheckAllRedPoint()
end

--显示系统公告
function ChatPopupView:ShowSystemNotice(notice)
    if self.groupPanel.target then
        self.groupPanel.target:ShowSystemNotice(notice)
    end
end

--处理频道消息
function ChatPopupView:ProcessChannelMsg(msg)
    local type = msg.channelInfo.Type

    if curType == type then
        self.groupPanel.target:ShowMsg(msg, true)
        ChatController.SetChannelMsgIndex(msg)
    end
end

--处理私聊消息
function ChatPopupView:ProcessP2PMsg(msg)
    local type = ChatTypes.P2P

    if curType == type then
        --发送给当前选中的这个人的或者是其他人发送给自己的
        if curPid and msg.p2pInfo.UserInfo.gameUserId == curPid then
            self.p2pPanel.target:ShowMsg(msg, true)
            ChatController.SetP2PUserMsgIndex(msg.p2pInfo.UserInfo.gameUserId)
        elseif curPid then
            --不是当前的这个人
            self.p2pPanel.target:CheckAddChatItemFromP2pInfo(msg.p2pInfo, false)
        elseif not curPid then
            --私聊面板没有人
            self.p2pPanel.target:CheckAddChatItemFromP2pInfo(msg.p2pInfo, true)
            ChatController.SetP2PUserMsgIndex(msg.p2pInfo.UserInfo.gameUserId)
        end
    end
end

--检查所有消息
function ChatPopupView:CheckAllRedPoint()
    self.binding:CallManyFrame(function()
        self:CheckChannelRedPoint()
        self:CheckP2PRedPoint()
    end)
end

--检查所有频道消息的小红点
function ChatPopupView:CheckChannelRedPoint()
    local channelMsg = ChatModel.ChannelMsg

    for k, v in pairs(channelMsg) do
        if v.CurMsgIndex < #v.MsgList then
            self:SetLeftRedPoint(v.Type, true)
        else
            self:SetLeftRedPoint(v.Type, false)
        end
    end
end

--检查所有的私聊信息并设置小红点
function ChatPopupView:CheckP2PRedPoint()
    local p2pMsgList = ChatModel.P2PMsg
    local set = false

    for k, v in pairs(p2pMsgList) do
        if v.CurMsgIndex < #v.MsgList then
            --有小红点
            set = true
            break
        end
    end

    self:SetLeftRedPoint(ChatTypes.P2P, set)
end

--设置左边的小红点
function ChatPopupView:SetLeftRedPoint(type, isShow)
    self.chatTypesPanel.target:SetRedPoint(type, isShow)
end

--获取当前的聊天类型
function ChatPopupView:GetChatCurType()
    return curType
end

--获取当前私聊的好友id
function ChatPopupView:GetP2PCurPid()
    if self.p2pPanel.target then
        local userInfo = self.p2pPanel.target:GetCurUserInfo(curPid)
        return curPid, userInfo
    end
end

--设置当前私聊的好友id
function ChatPopupView:SetP2PCurPid(gameUserId)
    curPid = gameUserId
end

--设置当前的聊天类型，如世界、公会、私聊等
function ChatPopupView:SetChatType(type)
    if curType == type then return end

    curType = type
    self.chatTypesPanel:CallUpdate({ type = curType, delegate = self })
    self.inputPanel:CallUpdate({ curType = curType, inputType = InputType.Text, delegate = self })
    self:ShowChatTypeView()
end

--显示当前类型消息
function ChatPopupView:ShowChatTypeView()
    if curType == ChatTypes.World or curType == ChatTypes.Sociaty then
        self.groupPanel.gameObject:SetActive(true)
        self.p2pPanel.gameObject:SetActive(false)
        self.groupPanel:CallUpdate({ type = curType, delegate = self })

        self.binding:CallManyFrame(function()
            local channelMsgList = ChatModel:GetChannelMsgListFromType(curType)
            self.groupPanel.target:ShowMsgList(channelMsgList)
            if channelMsgList and #channelMsgList > 0 then
                local msg = channelMsgList[1]
                ChatController.SetChannelMsgIndex(msg)
            end
            self:CheckAllRedPoint()
        end)

    elseif curType == ChatTypes.P2P then
        self.groupPanel.gameObject:SetActive(false)
        self.p2pPanel.gameObject:SetActive(true)
        self.p2pPanel:CallUpdate({ type = curType, delegate = self })

        local p2pMsgList = ChatModel.P2PMsg
        self.binding:CallManyFrame(function()
            self.p2pPanel.target:ProcessAllP2PMsg(p2pMsgList)
            self:CheckAllRedPoint()
        end)
    end
end

--根据玩家游戏中的信息获取聊天数据
function ChatPopupView:GetP2PUserChatMsg(userInfo)
    --设置curPid
    self:SetP2PCurPid(userInfo.gameUserId)
    ChatController.SetP2PUserMsgIndex(userInfo.gameUserId)
    self:CheckAllRedPoint()

    p2pMsgList = ChatModel:GetP2PMsgList(userInfo.gameUserId)
    self.p2pPanel.target:ShwoP2PChatMsg(p2pMsgList)
end

--设置玩家是否显示在聊天中
function ChatPopupView:SetP2PUserInChat(gameUserId, isInChat)
    ChatModel:SetP2PUserInChat(gameUserId, isInChat)
end

--点击人物信息中的私聊，进行私聊
function ChatPopupView:OpenP2PUserChat(userInfo)
    self:SetChatType(ChatTypes.P2P)
    self.binding:CallManyFrame(function()
        self.p2pPanel.target:CheckAddChatItemFromUserInfo(userInfo, true)
    end, 2)
end

--删除私聊中的黑名单消息
function ChatPopupView:DeleteP2PBlackMsg(userInfo)
    if self.p2pPanel.target then
        self.p2pPanel.target:DeleteBlackMsg(userInfo)
    end
end



--点击事件
function ChatPopupView:onClick(go, name)
    if name == "btn_close" then
        self:OnClose()
    end
end

--关闭处理
function ChatPopupView:OnClose()
    UIMrg:pop()
end

return ChatPopupView