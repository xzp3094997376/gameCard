
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
end

function m:onUpdate()
	self.selectCharCell1:CallTargetFunction("onUpdate")
	self.selectCharCell2:CallTargetFunction("onUpdate")
end

return m
