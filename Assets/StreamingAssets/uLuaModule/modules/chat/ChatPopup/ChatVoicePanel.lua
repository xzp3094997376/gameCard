local ChatVoicePanel = {}

function ChatVoicePanel:update(info)
    self.delegate = info.delegate
    self.desc.text = info.desc

    if info.isSuc then
        self.icon.color = Color.white
    else
        self.icon.color = Color.red
    end

    if info.isStart then
        self.icon.gameObject:SetActive(false)
        self.anim.gameObject:SetActive(true)
        self.anim:ResetToBeginning()
        self.anim:Play()
    else
        self.icon.gameObject:SetActive(true)
        self.anim.gameObject:SetActive(false)
    end
end


return ChatVoicePanel