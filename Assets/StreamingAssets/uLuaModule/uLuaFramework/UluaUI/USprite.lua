local sprite = {}
--设置精灵是否可见
function sprite:SetActive(mActionName, bool)
    local action = sendVO:new(mActionName, self.uModuleName, 'UISprite', 'PropertyInfoFun', 'gameObject/SetActive|MethodInfo', self.uSpriteName, bool)
    if mActionName ~= nil then
        SendBatching.addSendToList(action)
    else
        SendBatching.callFromCsharp(action)
    end
end

--设置精灵内容
function sprite:spriteName(mActionName, mSpriteName)
    local action = sendVO:new(mActionName, self.uModuleName, 'UISprite', 'MethodInfo', 'set_spriteName', self.uSpriteName, mSpriteName)
    if mActionName ~= nil then
        SendBatching.addSendToList(action)
    else
        SendBatching.callFromCsharp(action)
    end
end

--设置精灵大小
function sprite:SetDimensions(mActionName, widthAndHeight)
    local action = sendVO:new(mActionName, self.uModuleName, 'UISprite', 'MethodInfo', 'SetDimensions', self.uSpriteName, widthAndHeight)
    if mActionName ~= nil then
        SendBatching.addSendToList(action)
    else
        SendBatching.callFromCsharp(action)
    end
end

--设置精灵位置
function sprite:localPosition(mActionName, args)
    local action = sendVO:new(mActionName, self.uModuleName, 'UISprite', 'PropertyInfoFun', 'transform/localPosition|PropertyInfo', self.uSpriteName, args)
    if mActionName ~= nil then
        SendBatching.addSendToList(action)
    else
        SendBatching.callFromCsharp(action)
    end
end

function sprite:new(mModuleName, mSpriteName)
    local o = {
        uSpriteName = mSpriteName,
        uModuleName = mModuleName,
    }
    setmetatable(o, self)
    self.__index = self
    return o
end

return sprite;