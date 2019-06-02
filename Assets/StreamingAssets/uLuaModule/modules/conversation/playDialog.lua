--
-- Created by IntelliJ IDEA.
-- User: xiyou
-- Date: 2014/12/13
-- Time: 20:27
-- To change this template use File | Settings | File Templates.
-- 播放字幕

local m = {}

function m:update(name, conent, time)
    self.txt_desc.text = conent
    --    self.txt_name.text = name
    time = time or 2
    self.binding:StopAllCoroutines()
    self.binding:CallAfterTime(time, function()
        self:fadeOut()
    end)
end

function m:fadeOut()
    --    local height = self.playDialog.height
    --
    --    TweenPosition.Begin(self.top.gameObject, 1, Vector3(0, height/2 + self.top.height, 0), false)
    --    TweenPosition.Begin(self.bottom.gameObject, 0.8, Vector3(0, -height/2 - self.bottom.height/2, 0), false)
    --    self.binding:CallAfterTime(0.8, function()
    --        self.binding:DestroyObject(self.binding.gameObject, 0)
    --    end)
    self.binding:fadeOut(self.txt_desc.gameObject, 0.3, function()
        self.binding:DestroyObject(self.binding.gameObject, 0)
    end)
end

function m:fadeIn()
    --    local height = self.playDialog.height
    --    self.top.transform.localPosition = Vector3(0,height/2 + self.top.height/2,0)
    --    self.bottom.transform.localPosition = Vector3(0,-height/2 - self.top.height,0)
    --    TweenPosition.Begin(self.top.gameObject, 1, Vector3(0, height/2 - self.top.height/2, 0), false)
    --    TweenPosition.Begin(self.bottom.gameObject, 0.8, Vector3(0, -height/2 + self.bottom.height/2, 0), false)
    self.binding:fadeIn(self.txt_desc.gameObject, 0.3)
end

function m:Start()
    -- self.top.width = self.playDialog.width
    -- self.bottom.width = self.playDialog.width
    self._acvite = false
    self:fadeIn()
end

return m