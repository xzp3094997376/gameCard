--
-- Created by IntelliJ IDEA.
-- User: xiyou
-- Date: 2015/3/3
-- Time: 13:43
-- To change this template use File | Settings | File Templates.
-- 技能

local m = {}

function m:update(sk)
    self.skill = sk
    self.img.Url = sk:getIcon()
end

function m:onSelect()
    Events.Brocast('select_skill', self.skill, self.binding.gameObject)
end

function m:Start()
    ClientTool.AddClick(self.binding, function()
        m:onSelect()
    end)
end

return m

