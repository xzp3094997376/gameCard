local scrollview = {}

function scrollview:Reposition(mActionName)
    local action = sendVO:new(mActionName, self.uModuleName, 'UIScrollView', 'MethodInfo', 'ResetPosition', self.uScrollViewName, { nil })
    if mActionName ~= nil then
        SendBatching.addSendToList(action)
    else
        SendBatching.callFromCsharp(action)
    end
end

function scrollview:new(mModuleName, mScrollViewName)
    local o = {
        uScrollViewName = mScrollViewName,
        uModuleName = mModuleName,
    }
    setmetatable(o, self)
    self.__index = self
    return o
end

return scrollview