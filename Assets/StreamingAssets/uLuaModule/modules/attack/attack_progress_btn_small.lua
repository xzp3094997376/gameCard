-- 比武进程小按钮
local m = {}

function m:Start(...)
end

function m:update(data)
    if data == nil then 
        self.txt_name.text = "?"
        return
    end
    self.player = data.player
    self.delegate = data.delegate
    if self.player ~= nil then
        self.result = tonumber(data.player.flag)
        self.txt_name.text = self.player.title 
    end
    
    if self.result == 1 then --赢了
        if self.line_1 ~= nil then
        	self.line_1.spriteName = "KFBW-JC-xian-liang"
        end
        if self.line_2 ~= nil then
        	self.line_2.spriteName = "KFBW-JC-xian-liang"
        end
        if self.line_3 ~= nil then
        	self.line_3.gameObject:SetActive(true)
        	self.line_3.spriteName = "KFBW-JC-xian-liang"
        end
        self.sprite.spriteName = "KFBW-JC2-han"
    elseif self.result == 2 then --输了
        if self.line_1 ~= nil then
        	self.line_1.spriteName = "KFBW-JC-xian01"
        end
        if self.line_2 ~= nil then
        	self.line_2.spriteName = "KFBW-JC-xian01"
        end
        if self.line_3 ~= nil then
        	self.line_3.gameObject:SetActive(false)
        end
        self.sprite.spriteName = "KFBW-JC2-hui"
    else                                    --未开始
        self.sprite.spriteName = "KFBW-JC2-han"
    end
end

function m:onClick(go, name)
    if name == "button" then
        if self.player ~= nil and self.result == 3 then --未开始
            UIMrg:pop()
            UIMrg:pop()
            uSuperLink.openModule(805)
            if self.delegate ~= nil then
                self.delegate:refreshByPid(self.player.pid)
            end
        elseif self.player ~= nil and (self.result ==1 or self.result == 2)  then    --已结束
            MessageMrg.show(TextMap.GetValue("Text1719"))
        else
            MessageMrg.show(TextMap.GetValue("Text1720"))
        end
    end
end

return m