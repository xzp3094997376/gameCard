local ChatFriendItem = {}
local itemIndex = 0

function ChatFriendItem:Start()
end

--刷新数据
function ChatFriendItem:update(info, index, delegate)
    self.delegate = delegate
    self.data = info
    itemIndex = index
    self.data.gameUserId = self.data.gameUserId or self.data.pid --适配gameUserId
    self.data.nickname = self.data.nickname or self.data.name --适配nickname

    --self.txt_time.text = self.data.offTime
    --self.txt_power.text = self.data.power
    self.txt_lv.text = self.data.level
    self.txt_name.text = self.data.nickname
    self.vipLv.text = self.data.vip
    self.simpleImage:setImage(self.data.head, packTool:getIconByName(self.data.head))
end

--onClick
function ChatFriendItem:onClick(go, name)
    if name == "btn_add" then
        self:onClick_add()
    end
end

--添加对话
function ChatFriendItem:onClick_add()
    self.delegate:AddChat(self.data)
    UIMrg:popWindow()
end

return ChatFriendItem