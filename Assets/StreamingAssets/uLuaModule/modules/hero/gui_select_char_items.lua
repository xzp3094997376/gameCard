--
-- Created by IntelliJ IDEA.
-- User: xiyou
-- Date: 2014/12/20
-- Time: 17:23
-- To change this template use File | Settings | File Templates.
-- 角色列表项
local m = {}

function m:update(data, index, delegate)
    self.selectCharCell1:CallUpdate({ char = data[1], delegate = delegate, index = data[1] })

    if data[2] then
        self.selectCharCell2:CallUpdate({ char = data[2], delegate = delegate, index = data[2] })
        self.binding:Show("selectCharCell2")
    else
        self.binding:Hide("selectCharCell2")
    end
    --    if data[3] then
    --        self.selectCharCell3:CallUpdate({ char = data[3], delegate = delegate, index = data[3] })
    --        self.binding:Show("selectCharCell3")
    --    else
    --        self.binding:Hide("selectCharCell3")
    --    end
end

return m
