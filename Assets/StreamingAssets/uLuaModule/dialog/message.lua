--
-- Created by IntelliJ IDEA.
-- User: xiyou
-- Date: 2014/10/22
-- Time: 12:52
-- To change this template use File | Settings | File Templates.
-- 消息

local msg = {}

function msg:update(desc)
    self.msg.text = desc
    self.aMsg:ResetToBeginning()
    self.aMsg.enabled = true
end

function msg:create()
    return self
end

return msg