--
-- Created by IntelliJ IDEA.
-- User: xiyou
-- Date: 2014/12/4
-- Time: 1:10
-- To change this template use File | Settings | File Templates.
--

local m = {}

function m:update(data, index, delegate)
    self.charCell1:CallUpdate({ char = data[1], delegate = delegate, index = data[1].realIndex })

    if data[2] then
        self.charCell2:CallUpdate({ char = data[2], delegate = delegate, index = data[2].realIndex })
        self.binding:Show("charCell2")
    else
        self.binding:Hide("charCell2")
    end
    if self.charCell3 == nil then return end
    if data[3] then
        self.charCell3:CallUpdate({ char = data[3], delegate = delegate, index = data[3].realIndex })
        self.binding:Show("charCell3")
    else
        self.binding:Hide("charCell3")
    end
    if data[4] then
        self.charCell4:CallUpdate({ char = data[4], delegate = delegate, index = data[4].realIndex })
        self.binding:Show("charCell4")
    else
        self.binding:Hide("charCell4")
    end
end


function m:create()
    return self
end

return m

