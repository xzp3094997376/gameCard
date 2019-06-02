local grid = {}
--重置位置
function grid:SetReposition(mActionName)
    local action = sendVO:new(mActionName, self.uModuleName, 'UIGrid', 'MethodInfo', 'Reposition', self.uGridName, { nil })
    if mActionName ~= nil then
        SendBatching.addSendToList(action)
    else
        SendBatching.callFromCsharp(action)
    end
end

--init a gameObject
function grid:new(mModuleName, mGridName)
    local o = {
        uGridName = mGridName,
        uModuleName = mModuleName,
    }
    setmetatable(o, self)
    self.__index = self
    return o
end

return grid;