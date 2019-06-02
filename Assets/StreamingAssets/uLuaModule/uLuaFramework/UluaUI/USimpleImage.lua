local simpleImage = {}

--设置图片路径
function simpleImage:Url(mActionName, url)
    local action = sendVO:new(mActionName, self.uModuleName, 'SimpleImage', 'MethodInfo', 'set_Url', self.mSimpleImageName, url)
    if mActionName ~= nil then
        SendBatching.addSendToList(action)
    else
        SendBatching.callFromCsharp(action)
    end
end

--设置图片大小
function simpleImage:setSize(mActionName, widthAndHeight)
    local action = sendVO:new(mActionName, self.uModuleName, 'SimpleImage', 'MethodInfo', 'setSize', self.mSimpleImageName, widthAndHeight)
    if mActionName ~= nil then
        SendBatching.addSendToList(action)
    else
        SendBatching.callFromCsharp(action)
    end
end

function simpleImage:new(mModuleName, mSimpleImageName)
    local o = {
        mSimpleImageName = mSimpleImageName,
        uModuleName = mModuleName,
    }
    setmetatable(o, self)
    self.__index = self
    return o
end

return simpleImage;