local uGameObject = {}
--设置是否可见
function uGameObject:SetActive(mActionName, bool)
    local action = sendVO:new(mActionName, self.uModuleName, 'UnityEngine.GameObject', 'MethodInfo', 'SetActive', self.goName, bool)
    if mActionName ~= nil then
        SendBatching.addSendToList(action)
    else
        SendBatching.callFromCsharp(action)
    end
end

--设置gameObject位置
function uGameObject:localPosition(mActionName, args)
    local action = sendVO:new(mActionName, self.uModuleName, 'UnityEngine.GameObject', 'PropertyInfoFun', 'transform/localPosition|PropertyInfo', self.goName, args)
    if mActionName ~= nil then
        SendBatching.addSendToList(action)
    else
        SendBatching.callFromCsharp(action)
    end
end

--设置gameObject大小
function uGameObject:localScale(mActionName, args)
    local action = sendVO:new(mActionName, self.uModuleName, 'UnityEngine.GameObject', 'PropertyInfoFun', 'transform/localScale|PropertyInfo', self.goName, args)
    if mActionName ~= nil then
        SendBatching.addSendToList(action)
    else
        SendBatching.callFromCsharp(action)
    end
end

--init a gameObject
function uGameObject:new(mModuleName, mGoName)
    local o = {
        goName = mGoName,
        uModuleName = mModuleName,
    }
    setmetatable(o, self)
    self.__index = self
    return o
end

return uGameObject;