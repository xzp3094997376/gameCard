local ChatTypesPanel = {}
local ChatModel = ChatController.GetChatModel()

local ChatTypes = { World = "World", Sociaty = "Sociaty", P2P = "P2P" } --聊天的类型
local curType = nil

--显示
function ChatTypesPanel:update(info)
    self.delegate = info.delegate
    curType = info.type

    self.binding:CallManyFrame(function()
        ChatTypesPanel:SetBtns()
    end)
end

--设置当前类型高亮按钮
function ChatTypesPanel:SetBtns()
    local btnGo = nil
    local sociatyBtnGo = self.Sociaty.gameObject

    if curType == ChatTypes.World then
        btnGo = self.World.gameObject
    elseif curType == ChatTypes.Sociaty then
        btnGo = self.Sociaty.gameObject
    elseif curType == ChatTypes.P2P then
        btnGo = self.P2P.gameObject
    end

    if not ChatModel.ChannelMsg.Sociaty.WildCard then
        sociatyBtnGo:GetComponent(UIToggle).enabled = false
    else
        sociatyBtnGo:GetComponent(UIToggle).enabled = true
    end

    local toggle = btnGo:GetComponent(UIToggle)
    toggle.value = true
end

--设置小红点
function ChatTypesPanel:SetRedPoint(type, isShow)
    local btnGo = nil

    if type == ChatTypes.World then
        btnGo = self.World.gameObject
    elseif type == ChatTypes.Sociaty then
        btnGo = self.Sociaty.gameObject
    elseif type == ChatTypes.P2P then
        btnGo = self.P2P.gameObject
    end

    btnGo.transform:FindChild("redPoint").gameObject:SetActive(isShow)
end


--点击事件
function ChatTypesPanel:onClick(go, name)
    if name == "World" then
        self:SetChatType(ChatTypes.World)
    elseif name == "Sociaty" then
        self:SetChatType(ChatTypes.Sociaty)
    elseif name == "P2P" then
        self:SetChatType(ChatTypes.P2P)
    end
end

--设置聊天类型
function ChatTypesPanel:SetChatType(type)
    --没有公会
    if type == ChatTypes.Sociaty and not ChatModel.ChannelMsg.Sociaty.WildCard then
        MessageMrg.show(TextMap.GetValue("Text566"))
        ChatTypesPanel:SetBtns()
        return
    end

    self.delegate:SetChatType(type)
end

return ChatTypesPanel