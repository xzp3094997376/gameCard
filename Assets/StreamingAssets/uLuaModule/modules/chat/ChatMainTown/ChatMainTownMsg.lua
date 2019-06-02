local ChatMainTownMsg = {}
local ChatTypes = { World = "World", Sociaty = "Sociaty", P2P = "P2P", System = "System" } --聊天的类型
local TypeSprite = { World = "chat_tips_world", Sociaty = "chat_tips_gand", P2P = "chat_tips_pri", System = "chat_tips_sys" }

--刷新数据
function ChatMainTownMsg:update(info)
    self.data = info.data
    self.delegate = info.delegate

    self.msg.paddingLeft = 16
    self.msg.paddingRight = 2
    self.msg.paddingTop = 4
    self.msg.paddingBottom = 4

    self:ShowType()
    self:ShowMsg()
end

--设置类型
function ChatMainTownMsg:ShowType()
    local msg = self.data

    if msg.wildCard then
        if msg.wildCard == "System" then
            self.txt_type.text = TextMap.GetValue("Text546")
            self.img_type.spriteName = TypeSprite.System
            return
        end

        local type = ChatUtil.GetChannelTypeFromWildCard(msg.wildCard)
        if type == ChatTypes.World then
            self.txt_type.text = TextMap.GetValue("Text547")
            self.img_type.spriteName = TypeSprite.World
        elseif type == ChatTypes.Sociaty then
            self.txt_type.text = TextMap.GetValue("Text548")
            self.img_type.spriteName = TypeSprite.Sociaty
        end
    else
        self.txt_type.text = TextMap.GetValue("Text549")
        self.img_type.spriteName = TypeSprite.P2P
    end
end

--显示消息
function ChatMainTownMsg:ShowMsg()
    local msg = self.data
    if msg.wildCard == "System" then
        self.msg.text = msg.msgBody
    else
        local ext = msg.extTable
        local isNum = tonumber(ext.nickname)
        local name = ext.nickname
        if isNum then name = " " .. name .. " " end

        if msg.msgType == ChatUtil.msgType.text then
            if msg.wildCard == "System" then
                self.msg.text = msg.msgBody
            else
                self.msg.text = "[" .. name .. "]:" .. msg.msgBody
            end
        elseif msg.msgType == ChatUtil.msgType.voice then
            self.msg.text = "[" .. name .. "]:/lb" .. msg.attach
        end
    end

    self.binding:CallManyFrame(function()
        local msgTran = ChatMainTownMsg.msg.transform
        local count = msgTran.childCount

        for i = 0, count - 1 do
            local childTran = msgTran:GetChild(i)
            if childTran.localPosition.y == -34 then return end

            childTran.localPosition = Vector3(childTran.localPosition.x, childTran.localPosition.y - 7, childTran.localPosition.z)
        end
    end, 1)
end

return ChatMainTownMsg