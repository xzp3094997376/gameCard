local m = {}

function m:update(data, delegate)
    self.selectCharCell1:CallUpdate({ _treasure = data[1], delegate = delegate})
    if data[2] then
        self.selectCharCell2:CallUpdate({ _treasure = data[2], delegate = delegate })
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
