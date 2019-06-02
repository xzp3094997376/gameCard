local ChatSysItem = {}

--显示数据
function ChatSysItem:update(info)
    self.data = info.data
    self.delegate = info.delegate

    self.time.text = self.data.time
    self:SetMsg()
end

--设置前后左右
function ChatSysItem:SetMsg()
    self.msg.paddingLeft = 16
    self.msg.paddingRight = 16
    self.msg.paddingTop = 10
    self.msg.paddingBottom = 10
    self.msg.minWidth = 40

    self.msg.text = self.data.msgBody
    --self.msg.text = "这是一段很长的测试文字看看效果如何这是一段很长的测试文字看看效果如何这是一段很长的测试文字看看效果如何这是一段很长的测试文字看看效果如何"
end

return ChatSysItem