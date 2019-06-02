local uNumberSelect = {}

--设置默认最大值
function uNumberSelect:SetMaxValue(mActionName, maxValue)
    local action = sendVO:new(mActionName, self.uModuleName, 'NunberSelect', 'MethodInfo', 'maxNumValue', self.uSelectNumName, maxValue)
    if mActionName ~= nil then
        SendBatching.addSendToList(action)
    else
        SendBatching.callFromCsharp(action)
    end
end

function uNumberSelect:SetCallFun(mActionName, callback)
    local action = sendVO:new(mActionName, self.uModuleName, 'NunberSelect', 'MethodInfo', 'setCallFun', self.uSelectNumName, callback)
    if mActionName ~= nil then
        SendBatching.addSendToList(action)
    else
        SendBatching.callFromCsharp(action)
    end
end

--创建一个按钮
function uNumberSelect:new(mModuleName, mSelectNumName)
    local o = {
        uSelectNumName = mSelectNumName,
        uModuleName = mModuleName,
    }
    setmetatable(o, self)
    self.__index = self
    return o
end

return uNumberSelect;