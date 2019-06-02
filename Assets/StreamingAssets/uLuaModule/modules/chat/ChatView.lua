local ChatView =
{
    MainTownChatView = { MainTown = nil, Sociaty = nil }, --主场景上的聊天框，包括主场景和公会场景
    PopupChatView = nil, --点击按钮打开的聊天弹出框
}

--ChatController
local ChatController = nil
local ViewMode = { popup = "popup", icon = "icon" } --主城中的显示类型
local mainTownMode = nil --主城中的显示类型

--初始化
function ChatView:Initialize(_ChatController)
    ChatController = _ChatController
    mainTownMode = ViewMode.popup
end

--ChatController发来的消息通知
function ChatView:MsgNotify(msg)
    --通知聊天view
    if ChatView.PopupChatView then
        ChatView.PopupChatView:MsgNotify(msg)
    end

    --通知主城view
    for k, v in pairs(ChatView.MainTownChatView) do
        if v then
            v:MsgNotify(msg)
        end
    end
end

--显示系统公告
function ChatView:ShowSystemNotice(notice)
    if ChatView.PopupChatView then
        ChatView.PopupChatView:ShowSystemNotice(notice)
    end
end

--注册主场景view
function ChatView:RegisterMainTownView(type, mtChatView)
    ChatView.MainTownChatView[type] = mtChatView
end

--注销主场景聊天view
function ChatView:UnRegisterMainTownView(type)
    ChatView.MainTownChatView[type] = nil
end


--注册聊天弹出框view
function ChatView:RegisterPopupView(popChatView)
    ChatView.PopupChatView = popChatView
end

--注销弹出框聊天view
function ChatView:UnRegisterPopupView()
    ChatView.PopupChatView = nil

    for k, v in pairs(ChatView.MainTownChatView) do
        if v then
            v:BackToMainTown()
        end
    end
end

--删除私聊中的黑名单消息
function ChatView:DeleteViewBlackMsg(userInfo)
    if ChatView.PopupChatView then
        ChatView.PopupChatView:DeleteP2PBlackMsg(userInfo)
    end
end


--设置主城中聊天的显示模式
function ChatView:SetMainTownMode(mode)
    mainTownMode = mode

    for k, v in pairs(ChatView.MainTownChatView) do
        if v then
            v:SetViewMode()
        end
    end
end

--获取当前主城聊天的现实模式
function ChatView:GetMainTownMode()
    return mainTownMode
end

--打开聊天私聊
function ChatView:OpenP2PUserChat(userInfo)
    if ChatView.PopupChatView then
        ChatView.PopupChatView:OpenP2PUserChat(userInfo)
    else
        Tool.push("chat", "Prefabs/moduleFabs/chatModule/ChatPopup", userInfo)
    end
end

--获取输入界面
function ChatView:ShowRemainSendTime(type, remainTime)
    if ChatView.PopupChatView then
        ChatView.PopupChatView.inputPanel.target:ShowRemainSendTime(type, remainTime)
    end
end

return ChatView