--
-- Created by IntelliJ IDEA.
-- User: xiyou
-- Date: 2015/1/2
-- Time: 18:27
-- To change this template use File | Settings | File Templates.
-- 选择英雄

local m = {}

function m:update(data, index, delegate)
    for i = 1, 2 do
        local item = data[i]
        if item then
            self.binding:Show("charHead" .. i)
            self["charHead" .. i]:CallUpdate({ char = item, delegate = delegate })
        else
            self.binding:Hide("charHead" .. i)
        end
    end
end

return m

