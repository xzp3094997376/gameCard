local ChatFriendList = {}

function ChatFriendList:update(info)
    self.delegate = info.delegate
    self:GetData()
end

--向服务器端请求数据
function ChatFriendList:GetData()
    local friends = {}

    Api:getSocialList("friend", function(result)
        local count = result.list.Count

        for i = 0, count - 1 do
            local m = {}
            m.gameUserId = result.list[i].pid
            m.nickname = result.list[i].name
            m.level = result.list[i].level
            m.vip = result.list[i].vip
            m.head = result.list[i].head
            m.power = result.list[i].power
            m.offTime = 0 --result.list[i].time
            table.insert(friends, m)
        end
        self.list:refresh(friends, self, true, 0)
        --设置聊天好友列表
        --ChatController.SetFriendList(result)

        local row = TableReader:TableRowByID("FriendConfig", 1) --好友上限为id为1
        row = json.decode(row:toString())
        self.friend_num.text = tostring(count) .. "/" .. tostring(row.args2) --args2上限
    end, function()
    end)
end

--添加私聊
function ChatFriendList:AddChat(data)
    self.delegate:CheckAddChatItemFromUserInfo(data, true)
end

--点击事件
function ChatFriendList:onClick(go, name)
    if name == "btn_close" then
        self:OnClose()
    end
end

--关闭
function ChatFriendList:OnClose()
    UIMrg:popWindow()
end

return ChatFriendList