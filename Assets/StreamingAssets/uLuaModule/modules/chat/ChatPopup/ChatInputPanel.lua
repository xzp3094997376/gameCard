local ChatInputPanel = {}
local ChatModel = ChatController.GetChatModel()

local ChatTypes = { World = "World", Sociaty = "Sociaty", P2P = "P2P" } --聊天的类型
local ViewMode = { popup = "popup", icon = "icon" } --主城中的显示类型
local InputType = { Voice = 0, Text = 1 } --输入的类型

local curInputType = nil --当前输入类型
local curType = nil --当前聊天类型
local MinRecordTime = 1 --最小的录音时间，小于这个时间就不发送了
local MaxRecordTime = 40 --最大录音时间，大于这个时间就不发送了
local curRecordTime = 0 --当前录音时间
local recordTimeId = nil --录音定时器id
local voicePath = nil --当前录音文件的路径

function ChatInputPanel:Start()
    self.textInput.characterLimit = ChatUtil.WordsLimit
end

function ChatInputPanel:update(info)
    self.delegate = info.delegate
    curType = info.curType

    self.textInput.value = ""
    self:SetInputType(info.inputType)
    self:SetSelectMode()
end

--设置输入类型
function ChatInputPanel:SetInputType(inputType)
    curInputType = inputType

    if curInputType == InputType.Text then
        self.textInputGo:SetActive(true)
        self.voiceInputGo:SetActive(false)
    elseif curInputType == InputType.Voice then
        self.textInputGo:SetActive(false)
        self.voiceInputGo:SetActive(true)
    end

    self.binding:CallManyFrame(function()
        self:CheckRemainSendTime()
    end)
end

--设置选择模式的勾
function ChatInputPanel:SetSelectMode()
    local ChatView = ChatController.GetChatView()
    local mode = ChatView:GetMainTownMode()
    local toggle = self.btn_selectMode.gameObject:GetComponent(UIToggle)

    if mode == ViewMode.popup then
        toggle.value = true
    else
        toggle.value = false
    end
end

function ChatInputPanel:CheckRemainSendTime()
    local settings = ChatUtil.Settings

    for k, v in pairs(settings) do
        self:ShowRemainSendTime(v.Type, v.RemainSendTime)
    end
end

--显示发送倒计时
function ChatInputPanel:ShowRemainSendTime(_type, remainTime)
    --print("curType = " .. curType .. "   _type = " ..  _type)
    --print("remainTime = " .. remainTime)
    if curType == _type then
        local sendGo = self.btn_send.gameObject
        if sendGo.activeInHierarchy then
            if remainTime > 0 then
                self.btn_send.isEnabled = false
                self.btn_face.isEnabled = false
                self.textInput.enabled = false
                self.textInput.gameObject:GetComponent("BoxCollider").enabled = false
                sendGo.transform:FindChild("Label").gameObject:GetComponent(UILabel).text = TextMap.GetValue("Text550") .. remainTime .. ")"
            else
                self.btn_send.isEnabled = self.textInput.value ~= ""
                self.btn_face.isEnabled = true
                self.textInput.enabled = true
                self.textInput.gameObject:GetComponent("BoxCollider").enabled = true
                sendGo.transform:FindChild("Label").gameObject:GetComponent(UILabel).text = TextMap.GetValue("Text551")
            end
        end

        local voiceGo = self.btn_voice.gameObject
        if voiceGo.activeInHierarchy then
            if remainTime > 0 then
                self.btn_voice.isEnabled = false
                voiceGo.transform:FindChild("Label").gameObject:GetComponent(UILabel).text = TextMap.GetValue("Text552") .. remainTime .. ")"
            else
                self.btn_voice.isEnabled = true
                voiceGo.transform:FindChild("Label").gameObject:GetComponent(UILabel).text = TextMap.GetValue("Text553")
            end
        end
    end
end

--点击事件
function ChatInputPanel:onClick(go, name)
    if name == "btn_voiceMode" then
        self:onClick_voiceMode()
    elseif name == "btn_textMode" then
        self:onClick_textMode()
    elseif name == "btn_send" then
        self:onClick_send()
    elseif name == "btn_face" then
        self:onClick_face()
    elseif name == "btn_selectMode" then
        self:onClick_selectMode()
    end
end

--按下事件
function ChatInputPanel:onPress(go, name, state)
    if name == "btn_voice" then
        self:onPress_voice(state)
    end
end

--录音模式点击
function ChatInputPanel:onClick_voiceMode()
    self:SetInputType(InputType.Voice)
end

--文字模式点击
function ChatInputPanel:onClick_textMode()
    self:SetInputType(InputType.Text)
end

--点击表情
function ChatInputPanel:onClick_face()
    self.facePanel:CallUpdate({ delegate = self, input = self.textInput })
end

--长按voice
function ChatInputPanel:onPress_voice(state)
    local curPid = self.delegate:GetP2PCurPid()

    if not self:IsChannelType() and not curPid then
        MessageMrg.show(TextMap.GetValue("Text554"))
        return
    end

    if state then
        self:StartRecord()
    else
        if curRecordTime < MaxRecordTime then
            self:StopRecord()
        end
    end
end

--录音计时
function ChatInputPanel:CountDownRecord()
    curRecordTime = curRecordTime + 1
    if curRecordTime > MaxRecordTime - 10 and curRecordTime < MaxRecordTime then
        local desc =string.gsub(TextMap.GetValue("LocalKey_686"),"{0}",MaxRecordTime - curRecordTime)
        ChatInputPanel.voicePanel:CallUpdate({ desc = desc, isSuc = true, isStart = false, delegate = self })

    elseif curRecordTime >= MaxRecordTime then
        ChatController.StopRecord(function(data)
            os.remove(voicePath)
        end)

        LuaTimer.Delete(recordTimeId)
        local desc = TextMap.GetValue("Text557")
        ChatInputPanel.voicePanel:CallUpdate({ desc = desc, isSuc = false, isStart = false, delegate = self })
        LuaTimer.Add(1.5 * 1000, function()
            ChatInputPanel.voicePanel.gameObject:SetActive(false)
        end)
    end
end

--开始录音
function ChatInputPanel:StartRecord()
    local desc = TextMap.GetValue("Text558")
    curRecordTime = 0
    recordTimeId = LuaTimer.Add(1000, 1 * 1000, ChatInputPanel.CountDownRecord)

    self.voicePanel.gameObject:SetActive(true)
    self.voicePanel:CallUpdate({ desc = desc, isSuc = true, isStart = true, delegate = self })
    voicePath = ChatController.StartRecord()
end

--结束录音
function ChatInputPanel:StopRecord()
    LuaTimer.Delete(recordTimeId)

    local isInRect = ChatInputPanel:CheckIsInRect()
    if isInRect then
        self:ProcessRecordInRect()
    else
        self:ProcessRecordNotInRect()
    end
end

--检查是否在输入区域内，不在则取消发送语音
function ChatInputPanel:CheckIsInRect()
    local pos = Input.mousePosition
    local rect = self.voiceRect.localSize

    return pos.y <= rect.y
end

--处理区域中
function ChatInputPanel:ProcessRecordInRect()
    local desc = nil
    local isSuc = false

    if curRecordTime < MinRecordTime then
        desc = TextMap.GetValue("Text559")
        ChatController.StopRecord(function(data)
            os.remove(voicePath)
        end)
    else
        desc = TextMap.GetValue("Text560")
        isSuc = true
        ChatController.StopRecord(function(data)
            ChatUtil.CountDownSendTime(curType)
            self:SendVoiceMsg(data.time)
        end)
    end

    self.voicePanel:CallUpdate({ desc = desc, isSuc = isSuc, isStart = false, delegate = self })
    LuaTimer.Add(1.5 * 1000, function()
        self.voicePanel.gameObject:SetActive(false)
    end)
end

function ChatInputPanel:ProcessRecordNotInRect()
    local desc = TextMap.GetValue("Text561")
    local isSuc = false

    ChatController.StopRecord(function(data)
        os.remove(voicePath)
    end)

    self.voicePanel:CallUpdate({ desc = desc, isSuc = isSuc, delegate = self })
    LuaTimer.Add(1.5 * 1000, function()
        self.voicePanel.gameObject:SetActive(false)
    end)
end

--发送语音
function ChatInputPanel:SendVoiceMsg(voiceTime)
    if self:IsChannelType() then
        self:onSendChannelVoiceMsg(voiceTime)
    else
        self:onSendP2pVoiceMsg(voiceTime)
    end
end

--发送频道语音消息
function ChatInputPanel:onSendChannelVoiceMsg(voiceTime)
    local wildCard = self:GetChannelWildCard()

    self:SpeechStart(voicePath, function(attach)
        ChatController.SendChannelVoiceMessage(voicePath, voiceTime, wildCard, attach)
    end)
end

--发送私聊语音消息
function ChatInputPanel:onSendP2pVoiceMsg(voiceTime)
    local pid, userInfo = self.delegate:GetP2PCurPid()

    if pid then
        self:SpeechStart(voicePath, function(attach)
            ChatController.SendP2PVoiceMessage(pid, userInfo, voicePath, voiceTime, attach)
        end)
    else
        MessageMrg.show(TextMap.GetValue("Text554"))
    end
end

--进行语音识别
function ChatInputPanel:SpeechStart(filePath, callBack)
    ChatController.SpeechStart(filePath, function(data)
        local text = ""

        if data.result == 0 then
            text = data.text
        else
            text = TextMap.GetValue("Text562")
        end
        callBack(text)
    end)
end

--点击发送文本
function ChatInputPanel:onClick_send()
    local text = self.textInput.value
    if not text or text == "" then
        MessageMrg.show(TextMap.GetValue("Text563"))
        return
    end

    if self:IsChannelType() then
        self:onSendChannelTextMsg(text)
    else
        self:onSendP2PTextMsg(text)
    end

    self.textInput.value = ""
end

--发送频道文本消息
function ChatInputPanel:onSendChannelTextMsg(text)
    local wildCard = self:GetChannelWildCard()

    if wildCard then
        ChatUtil.CountDownSendTime(curType)
        ChatController.SendChannelTextMsg(text, wildCard)
    else
        MessageMrg.show(TextMap.GetValue("Text564"))
    end
end

--发送私聊文本消息
function ChatInputPanel:onSendP2PTextMsg(text)
    local pid, userInfo = self.delegate:GetP2PCurPid()

    if pid then
        ChatUtil.CountDownSendTime(curType)
        ChatController.SendP2PTextMessage(pid, userInfo, text)
    else
        MessageMrg.show(TextMap.GetValue("Text554"))
    end
end

--判断是频道还是私聊
function ChatInputPanel:IsChannelType()
    return curType ~= ChatTypes.P2P
end

--获取频道的wildcard
function ChatInputPanel:GetChannelWildCard()
    local wildCard = nil

    if curType == ChatTypes.World then
        wildCard = ChatModel.ChannelMsg.World.WildCard
    elseif curType == ChatTypes.Sociaty then
        wildCard = ChatModel.ChannelMsg.Sociaty.WildCard
    end

    return wildCard
end

--点击模式
function ChatInputPanel:onClick_selectMode()
    local ChatView = ChatController.GetChatView()
    local mode = ChatController.GetChatView():GetMainTownMode()

    if mode == ViewMode.popup then
        mode = ViewMode.icon
    else
        mode = ViewMode.popup
    end

    ChatView:SetMainTownMode(mode)
    self.binding:CallManyFrame(function()
        ChatInputPanel:SetSelectMode()
    end)
end

return ChatInputPanel