local uPanel = {}

--更改panel的深度
function uPanel:setDepth(mActionName, mDepth)
    local action = sendVO:new(mActionName, self.uModuleName, 'UIPanel', 'MethodInfo', 'set_depth', self.uPanelName, mDepth)
    if mActionName ~= nil then
        SendBatching.addSendToList(action)
    else
        SendBatching.callFromCsharp(action)
    end
end

--新建面板
function uPanel:new(mModuleName, mPanelName)
    local o = {
        uPanelName = mPanelName,
        uModuleName = mModuleName,
    }
    setmetatable(o, self)
    self.__index = self
    return o
end

return uPanel;