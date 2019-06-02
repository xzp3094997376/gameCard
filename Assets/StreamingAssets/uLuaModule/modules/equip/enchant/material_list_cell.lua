--
-- Created by IntelliJ IDEA.
-- User: xiyou
-- Date: 2015/1/2
-- Time: 17:25
-- To change this template use File | Settings | File Templates.
-- 材料
local m = {}


function m:update(data, index, delegate)
    for i = 1, 4 do
        local item = data[i]
        if item then
            self.binding:Show("material" .. i)
            self["material" .. i]:CallUpdate({ index = i, pIndex = index + 1, item = item, delegate = delegate })
        else
            self.binding:Hide("material" .. i)
        end
    end
end

return m
