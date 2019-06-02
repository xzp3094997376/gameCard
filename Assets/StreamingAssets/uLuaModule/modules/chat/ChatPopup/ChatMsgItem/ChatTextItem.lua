local ChatTextItem = {}

--显示数据
function ChatTextItem:update(info)
    self.data = info.data
    self.delegate = info.delegate

    local userInfo = self.data.extTable
    self.img_icon:setImage(userInfo.head, packTool:getIconByName(userInfo.head))
    self.name.text = userInfo.nickname
    self.vipNum.text = userInfo.vip
    self.level.text = "LV." .. userInfo.level
    self.time.text = self.data.time
    self:SetMsg()
end

--设置前后左右
function ChatTextItem:SetMsg()
    self.msg.paddingLeft = 16
    self.msg.paddingRight = 16
    self.msg.paddingTop = 10
    self.msg.paddingBottom = 10
    self.msg.minWidth = 40

    print("self.data.msgBody == " .. self.data.msgBody)
    self.msg.text = self.data.msgBody
    --self.msg.text = "这是一段很长的测试文字看看效果如何这是一段很长的测试文字看看效果如何这是一段很长的测试文字看看效果如何这是一段很长的测试文字看看效果如何"
end


--点击事件
function ChatTextItem:onClick(go, name)
    if name == "btn_icon" then
        self:onClick_btn_icon()
    end
end

--点击头像
function ChatTextItem:onClick_btn_icon()
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


return ChatTextItem