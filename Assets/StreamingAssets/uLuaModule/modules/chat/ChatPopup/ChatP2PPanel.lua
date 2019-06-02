local ChatP2PPanel = {}
local ChatModel = ChatController.GetChatModel()

local p2pList = {} --左边聊天好友的binding以及data的列表

--刷新数据
function ChatP2PPanel:update(info)
    self.type = info.type
    self.delegate = info.delegate
end

--重新排版
function ChatP2PPanel:RePosMsg()
    local table = self.Content:GetComponent(UITable)
    table.repositionNow = true
end


--显示p2p聊天信息
function ChatP2PPanel:ShwoP2PChatMsg(msgList)
    --先清除当前的信息
    self:ClearMsg()

    for i = 1, #msgList do
        local msg = msgList[i]
        self:ShowMsg(msg, false)
    end

    if #msgList > 0 then
        local msg = msgList[1]
        local p2pInfo = msg.p2pInfo
        local userInfo = p2pInfo.UserInfo
        local exsit, item_bind = self:CheckExist(userInfo.gameUserId)
        self:CheckP2PUserRedPoint(p2pInfo, item_bind)
    end

    self.binding:CallManyFrame(function()
        local table = self.Content:GetComponent(UITable)
        table.repositionNow = true
    end)
end

--显示相应的消息
function ChatP2PPanel:ShowMsg(msg, needRopos)
    self:CheckViewMsgNum()

    local prefab = self:GetMsgPrefab(msg)
    local res = ClientTool.Pureload(prefab)

    local itemGo = GameObject.Instantiate(res)
    itemGo.transform.parent = self.Content.transform
    itemGo.transform.localRotation = Quaternion.identity
    itemGo.transform.localScale = Vector3.one
    local binding = itemGo:GetComponent(UluaBinding)
    binding:CallUpdate({ data = msg, delegate = self })

    --定位
    local widget = itemGo:GetComponent(UIWidget)
    widget.leftAnchor:Set(self.Content.transform.parent, 0, 0)
    widget.rightAnchor:Set(self.Content.transform.parent, 1, 0)

    if needRopos then
        self.binding:CallManyFrame(function()
            local table = self.Content:GetComponent(UITable)
            table.repositionNow = true
        end)
    end
end

--检查当前显示消息是否超过最大数目
function ChatP2PPanel:CheckViewMsgNum()
    local maxMsgNum = ChatUtil.Settings.World.MaxMsgNum
    local trans = self.Content.transform

    if trans.childCount >= maxMsgNum then
        local childGo = trans:GetChild(0) --删掉第一条
        GameObject.DestroyImmediate(childGo.gameObject)
    end
end

--处理所有的私聊消息
function ChatP2PPanel:ProcessAllP2PMsg(p2pMsgList)
    local curPid = self:GetP2PCurPid()

    if not curPid then
        local needSelect = true

        for k, v in pairs(p2pMsgList) do
            if v.IsInChat then
                self:CheckAddChatItemFromP2pInfo(v, needSelect)
                needSelect = false
            elseif v.CurMsgIndex < #v.MsgList then
                self:CheckAddChatItemFromP2pInfo(v, needSelect)
                needSelect = false
            end
        end
    else
        for k, v in pairs(p2pMsgList) do
            if v.UserInfo.gameUserId == curPid then
                local exsit, item_bind = self:CheckExist(v.UserInfo.gameUserId)
                if exsit then
                    item_bind.target:SelectCurChat()
                end
            elseif v.CurMsgIndex < #v.MsgList then
                self:CheckAddChatItemFromP2pInfo(v, false)
            end
        end
    end
end

--清除当前的消息
function ChatP2PPanel:ClearMsg()
    local trans = self.Content.transform
    for i = 0, trans.childCount - 1 do
        local child = trans:GetChild(i)
        GameObject.Destroy(child.gameObject)
    end
end

--获取相应的prefab
function ChatP2PPanel:GetMsgPrefab(msg)
    local prefab = nil
    local isSelf = ChatUtil.IsMsgSelf(msg.extTable)

    if msg.msgType == ChatUtil.msgType.text then
        if isSelf then
            prefab = "Prefabs/moduleFabs/chatModule/P2PTextRight"
        else
            prefab = "Prefabs/moduleFabs/chatModule/P2PTextLeft"
        end
    elseif msg.msgType == ChatUtil.msgType.voice then
        if isSelf then
            prefab = "Prefabs/moduleFabs/chatModule/P2PVoiceRight"
        else
            prefab = "Prefabs/moduleFabs/chatModule/P2PVoiceLeft"
        end
    end

    return prefab
end

--通过好友面板，添加左边的对话item
function ChatP2PPanel:CheckAddChatItemFromUserInfo(userInfo, needSelect)
    Api:PlayerisOnline(userInfo.gameUserId, function(result)
        if result.online then
            local exsit, item_bind = self:CheckExist(userInfo.gameUserId)

            if exsit then
                if needSelect then
                    item_bind.target:SelectCurChat()
                end

                local msgList, p2pInfo = ChatModel:GetP2PMsgList(userInfo.gameUserId)
                self:CheckP2PUserRedPoint(p2pInfo, item_bind)
            else
                --不存在就实例化出来
                local item_bind = self:CreateChatItem(userInfo)
                self.binding:CallManyFrame(function()
                    item_bind:CallUpdate({ data = userInfo, delegate = self })
                    if needSelect then --选中当前
                    item_bind.target:SelectCurChat()
                    end

                    self.delegate:SetP2PUserInChat(userInfo.gameUserId, true)
                    local msgList, p2pInfo = ChatModel:GetP2PMsgList(userInfo.gameUserId)
                    self:CheckP2PUserRedPoint(p2pInfo, item_bind)
                end)
            end
        else
            MessageMrg.show(string.gsub(TextMap.GetValue("LocalKey_688"),"{0}",userInfo.nickname))
        end
    end)
end

--通过玩家聊天相关信息，添加左边的对话item
function ChatP2PPanel:CheckAddChatItemFromP2pInfo(p2pInfo, needSelect)
    local userInfo = p2pInfo.UserInfo
    local exsit, item_bind = self:CheckExist(userInfo.gameUserId)

    if exsit then
        if needSelect then
            item_bind.target:SelectCurChat()
        end

        self:CheckP2PUserRedPoint(p2pInfo, item_bind)
    else
        --不存在就实例化出来
        local item_bind = self:CreateChatItem(userInfo)
        self.binding:CallManyFrame(function()
            item_bind:CallUpdate({ data = userInfo, delegate = self })
            if needSelect then --选中当前
            item_bind.target:SelectCurChat()
            end

            self.delegate:SetP2PUserInChat(userInfo.gameUserId, true)
            self:CheckP2PUserRedPoint(p2pInfo, item_bind)
        end)
    end
end

--检测是否需要显示小红点,p2pInfo单个人的信息表
function ChatP2PPanel:CheckP2PUserRedPoint(p2pInfo, item_bind)
    local set = p2pInfo.CurMsgIndex < #p2pInfo.MsgList
    item_bind.target:SetRedPoint(set)
end

--创建左边的聊天item
function ChatP2PPanel:CreateChatItem(friendInfo)
    local itemGo = GameObject.Instantiate(self.itemModel)
    itemGo:SetActive(true)
    itemGo.transform.parent = self.p2pListGo.transform
    itemGo.transform.localRotation = Quaternion.identity
    itemGo.transform.localScale = Vector3.one

    local item_bind = itemGo:GetComponent(UluaBinding)
    self.p2pListGo:GetComponent(UIGrid).repositionNow = true
    table.insert(p2pList, { binding = item_bind, data = friendInfo }) --保存到p2pList中
    ChatController.SetP2PUserInfo(friendInfo.gameUserId, nil, friendInfo) --创建出来就去设置

    return item_bind
end

--检查左边是否已经有这个聊天好友了
function ChatP2PPanel:CheckExist(gameUserId)
    for i, v in ipairs(p2pList) do
        local data = v.data
        if data.gameUserId == gameUserId then
            return true, v.binding
        end
    end

    return false
end

--删除左边的聊天好友
function ChatP2PPanel:DeleteChatItem(bind)
    for i, v in ipairs(p2pList) do
        if v.binding == bind then

            table.remove(p2pList, i)
            GameObject.Destroy(v.binding.gameObject)
            self.delegate:SetP2PUserInChat(v.data.gameUserId, false)

            if i > #p2pList then i = #p2pList end --删除之后获取下一个

            if #p2pList == 0 then
                self:ClearMsg()
                self.delegate:SetP2PCurPid(nil)
            else
                local binding = p2pList[i].binding
                binding.target:SelectCurChat()
            end

            self.p2pListGo:GetComponent(UIGrid).repositionNow = true
            return
        end
    end
end

--删除黑名单的聊天消息
function ChatP2PPanel:DeleteBlackMsg(userInfo)
    for i, v in ipairs(p2pList) do
        if v.data.gameUserId == userInfo.gameUserId then

            table.remove(p2pList, i)
            GameObject.Destroy(v.binding.gameObject)

            if i > #p2pList then i = #p2pList end --删除之后获取下一个

            if #p2pList == 0 then
                self:ClearMsg()
                self.delegate:SetP2PCurPid(nil)
            else
                local binding = p2pList[i].binding
                binding.target:SelectCurChat()
            end

            self.p2pListGo:GetComponent(UIGrid).repositionNow = true
            return
        end
    end
end

--获取当前选中的那个人的userInfo
function ChatP2PPanel:GetCurUserInfo(curPid)
    for i, v in ipairs(p2pList) do
        if v.data.gameUserId == curPid then
            return v.data
        end
    end

    return nil
end

--根据玩家信息获取聊天消息
function ChatP2PPanel:GetP2PUserChatMsg(userInfo)
    self.delegate:GetP2PUserChatMsg(userInfo)
end

--获取当前私聊的好友id
function ChatP2PPanel:GetP2PCurPid()
    local curPid = self.delegate:GetP2PCurPid()
    return curPid
end



--点击事件
function ChatP2PPanel:onClick(go, name)
    if name == "btn_addChat" then
        self:onAddChat()
    end
end

--添加对话按钮
function ChatP2PPanel:onAddChat()
    --打开好友面板
    UIMrg:pushWindow("Prefabs/moduleFabs/chatModule/ChatFriendList", { delegate = self })
end

return ChatP2PPanel