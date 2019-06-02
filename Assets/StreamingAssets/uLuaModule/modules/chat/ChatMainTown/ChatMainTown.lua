local ChatMainTown = {}
local ChatModel = nil
local ChatView = nil

local MaxMsgNum = 5 --最大显示的消息数
local curMsgNum = 0 --当前显示的消息数量
local dragTimeId = nil --拖动的定时器
local msgTimeId = nil --定时删除消息
local curCamera = nil --当前的摄像机
local chatTran = nil --聊天按钮的transform
local canDrag = false --是否可以拖动

local ViewMode = { popup = "popup", icon = "icon" } --主城中的显示类型
local viewType = "" --主城或者公会

local lastSysMsg = nil --上一次的系统消息,防止系统消息重复显示

function ChatMainTown:Start()
    ChatModel = ChatController.GetChatModel() --获取ChatModel
    ChatView = ChatController.GetChatView() --获取ChatView

    self:SetViewType()
    self:SetViewMode()
    self:RegisterView()
    self:CheckDeleteMsg()
    self:ShowHistoryMsg()

    local goName = "/GameManager/Camera"
    curCamera = GameObject.Find(goName):GetComponent(Camera)
    chatTran = self.btn_chat.gameObject.transform
end

function ChatMainTown:OnDestroy()
    ChatMainTown:UnRegisterView()

    if msgTimeId then
        LuaTimer.Delete(msgTimeId)
        msgTimeId = nil
    end
end

--注册自身
function ChatMainTown:RegisterView()
    ChatView:RegisterMainTownView(viewType, self)
end

--注销自身
function ChatMainTown:UnRegisterView()
    ChatView:UnRegisterMainTownView(viewType)
end

--设置主城或者是公会
function ChatMainTown:SetViewType()
    local rootGo = self.gameObject.transform.parent.parent.gameObject

    if rootGo.name == "main_menu" then
        viewType = "MainTown"
        ChatView:SetMainTownMode(ViewMode.popup)
    elseif rootGo.name == "league_main_page" then
        viewType = "Sociaty"
        ChatView:SetMainTownMode(ViewMode.icon)
    end
end

--设置显示模式
function ChatMainTown:SetViewMode()
    local mode = ChatView:GetMainTownMode()

    if mode == ViewMode.popup then
        self.chatBtnGo:SetActive(false)
        --self.chat_win:SetActive(true)
    else
        self.chatBtnGo:SetActive(true)
       -- self.chat_win:SetActive(false)
    end
end

--设置小红点
function ChatMainTown:SetRedPoint(isShow)
    self.redPoint:SetActive(isShow)
end

--从聊天界面返回到主场景
function ChatMainTown:BackToMainTown()
    self.binding:CallManyFrame(function()
        ChatMainTown:CheckAllRedPoint()
        ChatMainTown.Content:GetComponent(UITable).repositionNow = true
    end)
end

--获取历史消息显示到主界面
function ChatMainTown:ShowHistoryMsg()
    local delay = 0
    if viewType == "MainTown" then
        delay = 2 * 1000
    elseif viewType == "Sociaty" then
        delay = 0.2 * 1000
    end

    LuaTimer.Add(delay, function()
        ChatMainTown:GetShowHistoryMsg()
    end)
end

--获取历史消息
function ChatMainTown:GetShowHistoryMsg()
    --只显示世界频道消息
    local channelMsg = ChatModel.ChannelMsg.World.MsgList

    if #channelMsg > 0 then
        local msgs = {}
        for i = #channelMsg, 1, -1 do
            if #msgs < MaxMsgNum then
                table.insert(msgs, channelMsg[i])
            end
        end

        for i = #msgs, 1, -1 do
            ChatMainTown:AddMsg(msgs[i], false)
        end

        ChatMainTown.Content:GetComponent(UITable).repositionNow = true
    else
        LuaTimer.Add(1 * 1000, ChatMainTown.GetShowHistoryMsg)
    end
end

--消息通知
function ChatMainTown:MsgNotify(msg)
    --历史消息不加入
    if msg.isHistory then return end

    --防止系统消息重复显示
    if msg.wildCard == "System" then
        if msg ~= lastSysMsg then
            self:AddMsg(msg, true)
            lastSysMsg = msg
        end
    else
        self:AddMsg(msg, true)
    end
end

function ChatMainTown:AddMsg(msg, needRepos)
    curMsgNum = curMsgNum + 1
    self:CheckViewMsgNum()

    local itemGo = GameObject.Instantiate(self.itemModel)
    itemGo.transform.parent = self.Content.transform
    itemGo.transform.localRotation = Quaternion.identity
    itemGo.transform.localScale = Vector3.one
    itemGo:SetActive(true)

    local binding = itemGo:GetComponent(UluaBinding)
    binding:CallUpdate({ data = msg, delegate = self })
    if needRepos then
        self.Content:GetComponent(UITable).repositionNow = true
        self:CheckAllRedPoint()
    end
end

--检查当前显示消息是否超过最大数目
function ChatMainTown:CheckViewMsgNum()
    local trans = self.Content.transform

    if curMsgNum > MaxMsgNum then
        curMsgNum = MaxMsgNum

        local childGo = trans:GetChild(0).gameObject --删掉第一条
        if childGo then
            childGo:SetActive(false)
            GameObject.Destroy(childGo)
        end
    end
end

--检查所有消息
function ChatMainTown:CheckAllRedPoint()
    local set = false

    local channelMsg = ChatModel.ChannelMsg
    for k, v in pairs(channelMsg) do
        if v.CurMsgIndex < #v.MsgList then
            set = true
            break
        end
    end

    local p2pMsgList = ChatModel.P2PMsg
    for k, v in pairs(p2pMsgList) do
        if v.CurMsgIndex < #v.MsgList then
            set = true
            break
        end
    end

    self:SetRedPoint(set)
end

--点击事件
function ChatMainTown:onClick(go, name)
    if name == "bgBox" then
        self:OpenChatPopup()
    elseif name == "btn_chat" then
        self:OpenChatPopup()
    end
end

--点击背景,弹出聊天界面
function ChatMainTown:OpenChatPopup()
    --ChatController.OpenP2PUserChat({})
    --Tool.push("chat", "Prefabs/moduleFabs/chatModule/ChatPopup", {})
end

--按下事件
function ChatMainTown:onPress(go, name, state)
    if name == "btn_chat" then
        self:onPressIcon(state)
    end
end

--长按图标
function ChatMainTown:onPressIcon(state)
    if state then
        self:StartDrag()
    else
        self:StopDrag()
    end
end

--开始拖动
function ChatMainTown:StartDrag()
    canDrag = true

    LuaTimer.Add(0.2 * 1000, function()
        if canDrag then
            dragTimeId = LuaTimer.Add(0, 0.02 * 1000, function()
                self:CheckIconInScreen(screenPos)
                return true
            end)
        end
    end)
end

--结束拖动
function ChatMainTown:StopDrag()
    canDrag = false

    if dragTimeId then
        LuaTimer.Delete(dragTimeId)
        dragTimeId = nil
    end
end

--检查图标是否在屏幕内
function ChatMainTown:CheckIconInScreen(screenPos)
    local sc_width = Screen.width
    local sc_height = Screen.height
    local minX = 44
    local maxX = sc_width - minX
    local minY = 44
    local maxY = sc_height - minY

    local screenPos = Input.mousePosition
    if screenPos.x < minX then screenPos.x = minX end
    if screenPos.x > maxX then screenPos.x = maxX end
    if screenPos.y < minY then screenPos.y = minY end
    if screenPos.y > maxY then screenPos.y = maxY end

    local worldPos = curCamera:ScreenToWorldPoint(screenPos)
    chatTran.position = Vector3(worldPos.x, worldPos.y, chatTran.position.z)
end

--删除消息
function ChatMainTown:CheckDeleteMsg()
    msgTimeId = LuaTimer.Add(0, 5 * 1000, function()
        local trans = self.Content.transform
        local count = trans.childCount

        if count > MaxMsgNum then
            local delta = count - MaxMsgNum
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

return ChatMainTown