local uTable = {}

--更改文本内容
function uTable:Reposition(mActionName)
    local action = sendVO:new(mActionName, self.uModuleName, 'UITable', 'MethodInfo', 'Reposition', self.uTableName, { nil })
    if mActionName ~= nil then
        SendBatching.addSendToList(action)
    else
        SendBatching.callFromCsharp(action)
    end
end

--新建文本类
function uTable:new(mModuleName, mTableName)
    local o = {
        uTableName = mTableName,
        uModuleName = mModuleName,
    }
    setmetatable(o, self)
    self.__index = self
    return o
end

return uTable;