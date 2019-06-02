local ChatGroupPanel = {}

local ChatTypes = { World = "World", Sociaty = "Sociaty", P2P = "P2P" } --聊天的类型
local ChatModel = ChatController.GetChatModel()
local curMsgNum = 0 --当前显示的消息数量
local msgTimeId = nil --定时删除消息

function ChatGroupPanel:Start()
    self:CheckDeleteMsg()
end

--刷新数据
function ChatGroupPanel:update(info)
    self.type = info.type
    self.delegate = info.delegate

    local sysNotice = ChatModel:GetSystemNotice()
    self:ShowSystemNotice(sysNotice)
end

function ChatGroupPanel:OnDestroy()
    if msgTimeId then
        LuaTimer.Delete(msgTimeId)
        msgTimeId = nil
    end
end

--重新排版
function ChatGroupPanel:RePosMsg()
    local table = self.Content:GetComponent(UITable)
    table.repositionNow = true
end

--显示系统公告
function ChatGroupPanel:ShowSystemNotice(notice)
    self.txt_system.text = notice
end

--显示当前频道的所有消息
function ChatGroupPanel:ShowMsgList(msgList)
    --先清空信息
    self:ClearMsg()

    if msgList == nil or #msgList == 0 then return end

    for i, v in ipairs(msgList) do
        self:ShowMsg(v, false)
    end

    self.binding:CallManyFrame(function()
        local table = self.Content:GetComponent(UITable)
        table.repositionNow = true
    end)
end

--显示相应的消息
function ChatGroupPanel:ShowMsg(msg, needRopos)
    curMsgNum = curMsgNum + 1
    self:CheckViewMsgNum()

    local prefab = self:GetMsgPrefab(msg)
    local res = ClientTool.Pureload(prefab)
    local itemGo = GameObject.Instantiate(res)

    itemGo.transform.parent = self.Content.transform
    itemGo.transform.localRotation = Quaternion.identity
    itemGo.transform.localScale = Vector3.one
    itemGo:SetActive(true)
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
function ChatGroupPanel:CheckViewMsgNum()
    local curType = self.delegate:GetChatCurType()
    local maxMsgNum = 30

    if curType == ChatModel.ChannelMsg.World.Type then
        maxMsgNum = ChatUtil.Settings.World.MaxMsgNum
    elseif curType == ChatModel.ChannelMsg.World.Type then
        maxMsgNum = ChatUtil.Settings.Sociaty.MaxMsgNum
    end

    if curMsgNum > maxMsgNum then
        curMsgNum = maxMsgNum

        local trans = self.Content.transform
        local childGo = trans:GetChild(0).gameObject --删掉第一条
        if childGo then
            childGo:SetActive(false)
            GameObject.Destroy(childGo)
        end
    end
end

--删除消息
function ChatGroupPanel:CheckDeleteMsg()
    msgTimeId = LuaTimer.Add(0, 5 * 1000, function()
        local trans = self.Content.transform
        local count = trans.childCount
        local maxMsgNum = 30

        if curType == ChatModel.ChannelMsg.World.Type then
            maxMsgNum = ChatUtil.Settings.World.MaxMsgNum
        elseif curType == ChatModel.ChannelMsg.World.Type then
            maxMsgNum = ChatUtil.Settings.Sociaty.MaxMsgNum
        end

        if count > maxMsgNum then
            local delta = count - maxMsgNum
            local childs = {}

            for i = 0, delta - 1 do
                local childGo = trans:GetChild(i).gameObject
                table.insert(childs, childGo)
            end

            for i, v in ipairs(childs) do
                GameObject.DestroyImmediate(v)
            end
            self.Content:GetComponent(UITable).repositionNow = true
        end
    end)
end

--清除当前的消息
function ChatGroupPanel:ClearMsg()
    curMsgNum = 0
    local trans = self.Content.transform

    for i = 0, trans.childCount - 1 do
        local childGo = trans:GetChild(i)
        GameObject.Destroy(childGo.gameObject)
    end
end

--获取相应的prefab
function ChatGroupPanel:GetMsgPrefab(msg)
    --系统消息单独处理
    if msg.wildCard == "System" then return "Prefabs/moduleFabs/chatModule/SysGroupText" end

    local prefab = nil
    local isSelf = ChatUtil.IsMsgSelf(msg.extTable)

    if msg.msgType == ChatUtil.msgType.text then
        if isSelf then
            prefab = "Prefabs/moduleFabs/chatModule/GroupTextRight"
        else
            prefab = "Prefabs/moduleFabs/chatModule/GroupTextLeft"
        end
    elseif msg.msgType == ChatUtil.msgType.voice then
        if isSelf then
            prefab = "Prefabs/moduleFabs/chatModule/GroupVoiceRight"
        else
            prefab = "Prefabs/moduleFabs/chatModule/GroupVoiceLeft"
        end
    end

    return prefab
end

return ChatGroupPanel