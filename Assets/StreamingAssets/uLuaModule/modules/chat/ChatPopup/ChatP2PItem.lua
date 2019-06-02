local ChatP2PItem = {}

--刷新数据
function ChatP2PItem:update(info)
    print("ChatP2PItem update")

    self.data = info.data
    self.delegate = info.delegate
    self.data.gameUserId = self.data.gameUserId or self.data.pid --适配gameUserId
    self.data.nickname = self.data.nickname or self.data.name --适配nickname

    self.level.text = "LV." .. self.data.level
    self.name.text = self.data.nickname
    self.vipNum.text = self.data.vip

    self.img_icon:setImage(self.data.head, packTool:getIconByName(self.data.head))
end

--设置小红点
function ChatP2PItem:SetRedPoint(isShow)
    self.redPoint:SetActive(isShow)
end

--onClick
function ChatP2PItem:onClick(go, name)
    if name == "btn_close" then
        self:onCloce()
    elseif name == "btn_bg" then
        self:onSelect()
    end
end

--点击关闭
function ChatP2PItem:onCloce()
    --删除这个item
    self.delegate:DeleteChatItem(self.binding)
end

--点击背景
function ChatP2PItem:onSelect()
    --如果是当前选中的好友就返回
    local curPid = self.delegate:GetP2PCurPid()
    if curPid == self.data.gameUserId then return end

    self:SelectCurChat()
end

--选中当前的聊天
function ChatP2PItem:SelectCurChat()
    self.delegate:GetP2PUserChatMsg(self.data)

    local toggle = self.btn_bg.gameObject:GetComponent(UIToggle)
    toggle.value = true
end


return ChatP2PItem