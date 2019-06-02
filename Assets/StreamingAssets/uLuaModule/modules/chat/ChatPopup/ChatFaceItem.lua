local ChatFaceItem = {}

--刷新数据
function ChatFaceItem:update(info)
    self.input = info.input --输入框
    self.symbol = info.symbol --表情,类型为BMSymbol
    self.delegate = info.delegate --上一级

    --图片
    self.face_icon.spriteName = self.symbol.spriteName
end

--点击事件
function ChatFaceItem:onClick(go, name)
    if name == "btn_face" then
        self:onClick_face()
    end
end

--表情点击
function ChatFaceItem:onClick_face()
    local input = self.input
    UIInput.selection = input
    input.value = input.value .. self.symbol.sequence
    UIInput.selection = null
    --关闭面板
    self.delegate:OnClose()
end

return ChatFaceItem