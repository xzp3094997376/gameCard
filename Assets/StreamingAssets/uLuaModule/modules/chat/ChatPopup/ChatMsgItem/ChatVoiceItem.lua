local ChatVoiceItem = {}

--显示数据
function ChatVoiceItem:update(info)
    self.data = info.data
    self.delegate = info.delegate

    local msg = self.data
    local userInfo = msg.extTable

    self.img_icon:setImage(userInfo.head, packTool:getIconByName(userInfo.head))
    self.name.text = userInfo.nickname
    self.vipNum.text = userInfo.vip
    self.level.text = "LV." .. userInfo.level
    self.time.text = msg.time

    local voiceDuration = math.floor(msg.voiceDuration / 1000)
    if voiceDuration == 0 then voiceDuration = 1 end
    self.voiceTime.text = voiceDuration .. "'"

    self:SetMsg()
end

--设置前后左右
function ChatVoiceItem:SetMsg()
    self.msg.paddingLeft = 16
    self.msg.paddingRight = 20
    self.msg.paddingTop = 24
    self.msg.paddingBottom = 26
    self.msg.minWidth = 40

    self.msg.text = self.data.attach
    --self.msg.text = "这是一段很长的测试文字看看效果如何这是一段很长的测试文字看看效果如何这是一段很长的测试文字看看效果如何这是一段很长的测试文字看看效果如何"
end

--点击事件
function ChatVoiceItem:onClick(go, name)
    if name == "btn_icon" then
        self:onClick_btn_icon()
    elseif name == "btn_voice" then
        self:onPlayVoice()
    end
end

--点击头像
function ChatVoiceItem:onClick_btn_icon()
    local userInfo = self.data.extTable
    local isSelf = ChatUtil.IsMsgSelf(userInfo)
    local isBlack = ChatUtil.CheckIsBlack(userInfo.gameUserId)

    if not isSelf and not isBlack then
        local delegate = self.delegate.delegate --ChatPopupView
        UIMrg:pushWindow("Prefabs/moduleFabs/chatModule/PlayerInfo", { delegate = delegate, data = userInfo })
    elseif isBlack then
        MessageMrg.show(TextMap.GetValue("Text567"))
    end
end

--点击播放录音
function ChatVoiceItem:onPlayVoice()
    if ChatUtil.PlayVoiceInfo.IsPlaying and ChatUtil.PlayVoiceInfo.CurVoiceItem then
        if ChatUtil.PlayVoiceInfo.CurVoiceItem == self then
            self:StopPlayRecord()
        else
            ChatUtil.PlayVoiceInfo.CurVoiceItem:StopPlayRecord()
            self.binding:CallManyFrame(function()
                self:StartPlayRecordSelf()
            end)
        end
    else
        self:StartPlayRecordSelf()
    end
end

function ChatVoiceItem:StartPlayRecordSelf()
    local msg = self.data
    local isSelf = ChatUtil.IsMsgSelf(msg.extTable)

    if isSelf and msg.filePath and ChatUtil.FileExists(msg.filePath) then
        print("onPlayVoice filePath = " .. msg.filePath)
        self:StartPlayRecord(msg.filePath, nil)
    else
        --不存在就用url来播放
        print("onPlayVoice url = " .. msg.msgBody)
        self:StartPlayRecord(nil, msg.msgBody)
    end
end

--开始播放语音文件
function ChatVoiceItem:StartPlayRecord(filePath, url)
    self.voiceIcon:SetActive(false)
    self.voiceAnim.gameObject:SetActive(true)
    self.voiceAnim:ResetToBeginning()
    self.voiceAnim:Play()

    ChatUtil.SetPlayVoiceInfo(true, self)

    ChatController.StartPlayRecord(filePath, url, function(data)
        ChatUtil.SetPlayVoiceInfo(false, nil)

        ChatVoiceItem.voiceIcon:SetActive(true)
        ChatVoiceItem.voiceAnim.gameObject:SetActive(false)

        if data.result == 0 then print("播放完成")
        else print("播放失败")
        end
    end)
end

--停止播放语音文件
function ChatVoiceItem:StopPlayRecord()
    ChatUtil.SetPlayVoiceInfo(false, nil)
    ChatController.StopPlayRecord()
    self.voiceIcon:SetActive(true)
    self.voiceAnim.gameObject:SetActive(false)
end

return ChatVoiceItem