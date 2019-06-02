local uLabel = {}

--更改文本内容
function uLabel:setText(mActionName, mText)
    local action = sendVO:new(mActionName, self.uModuleName, 'UILabel', 'MethodInfo', 'set_text', self.uLabelName, mText)
    if mActionName ~= nil then
        SendBatching.addSendToList(action)
    else
        SendBatching.callFromCsharp(action)
    end
end

--更改文本大小
function uLabel:SetDimensions(mActionName, widthAndHeight)
    local action = sendVO:new(mActionName, self.uModuleName, 'UILabel', 'MethodInfo', 'SetDimensions', self.uLabelName, widthAndHeight)
    if mActionName ~= nil then
        SendBatching.addSendToList(action)
    else
        SendBatching.callFromCsharp(action)
    end
end

--设置文本是否可见
function uLabel:SetActive(mActionName, bool)
    local action = sendVO:new(mActionName, self.uModuleName, 'UILabel', 'PropertyInfoFun', 'gameObject/SetActive|MethodInfo', self.uLabelName, bool)
    if mActionName ~= nil then
        SendBatching.addSendToList(action)
    else
        SendBatching.callFromCsharp(action)
    end
end

--设置文本位置
function uLabel:localPosition(mActionName, args)
    local action = sendVO:new(mActionName, self.uModuleName, 'UILabel', 'PropertyInfoFun', 'transform/localPosition|PropertyInfo', self.uLabelName, args)
    if mActionName ~= nil then
        SendBatching.addSendToList(action)
    else
        SendBatching.callFromCsharp(action)
    end
end

--新建文本类
function uLabel:new(mModuleName, mLabelName)
    local o = {
        uLabelName = mLabelName,
        uModuleName = mModuleName,
    }
    setmetatable(o, self)
    self.__index = self
    return o
end

return uLabel;