--
-- Created by IntelliJ IDEA.
-- User: xiyou
-- Date: 2015/2/4
-- Time: 15:43
-- To change this template use File | Settings | File Templates.
-- 解锁对话框



local unlockDialog = {}

function unlockDialog:update(unlock)
    local step = unlock.guide
    self.step = step
    self.line =unlock.line
    local icons = unlock.icon
    self.desLab.text = unlock.desc
    ClientTool.UpdateGrid("", self.Grid, icons)
end

function unlockDialog:onClick(go, name)
    local step = self.step
    print ("step" .. step)
    UIMrg:popToRoot()
    GuideMrg.CallStep(step, 1)
end

function unlockDialog:Start()
end

return unlockDialog

