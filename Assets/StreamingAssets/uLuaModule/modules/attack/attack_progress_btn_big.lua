-- 比武进程大按钮
local m = {}

function m:Start(...)
end

function m:update(data)
    if data == nil then return end
    -- self.txt_name.text = "我是玩家名字[00ff00][s111][-]\n[00ff00]VS[-]\n[ffffff7d]我是玩家名字[00ff00][s111][-][-]"
    self.player1 = data.player1
    self.player2 = data.player2
    self.result = data.result --1为player1赢，2为player2赢，0为没有结果
    self.index = data.index
    self.delegate = data.delegate
    -- self.txt_name.text = self.player1.pid.."\nVS\n"..self.player2.pid
    local sid1 = "[00ff00]["..self:getSid(self.player1.sid).."][-]"
    local sid2 = "[00ff00]["..self:getSid(self.player2.sid).."][-]"
    if self.result == nil then --比赛未开始
        if self.line_1 ~= nil then
        	self.line_1.spriteName = "KFBW-JC-xian01"
        end
        self.txt_name.text = self.player1.name..sid1.."\n[00ff00]VS[-]\n"..self.player2.name..sid2
    else      --比赛结束
        if self.line_1 ~= nil then
        	self.line_1.spriteName = "KFBW-JC-xian-liang"
        end
        if self.result == 1 then
            self.txt_name.text = self.player1.name..sid1.."\n[00ff00]VS[-]\n".."[ffffff7d]"..self.player2.name..sid2.."[-]"
        elseif self.result == 2 then
            self.txt_name.text = "[ffffff7d]"..self.player1.name..sid1.."[-]\n[00ff00]VS[-]\n"..self.player2.name..sid2
        else
            self.txt_name.text = self.player1.name..sid1.."\n[00ff00]VS[-]\n"..self.player2.name..sid2
        end
    end
end

--获取sid
function m:getSid(sid)
    if sid == nil then return end
    local showId = nil
    if sid <=10 then
        showId = "u"..sid
    elseif sid > 400 then
        showId = "f"..(sid-400)
    else
        showId = "s"..(sid-10)
    end
    return showId
end

function m:onClick(go, name)
    if name == "button" then
        if self.result ==1 or self.result == 2 then 
            MessageMrg.show(TextMap.GetValue("Text1719"))
            return 
        end
        UIMrg:pop()
        UIMrg:pop()
        uSuperLink.openModule(805)
        if self.delegate ~= nil then
            print("111111111")
            self.delegate:refreshByPid(self.player1.pid)
        end
    end
end

return m