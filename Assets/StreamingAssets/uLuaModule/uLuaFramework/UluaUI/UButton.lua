local button = {}
--设置按钮是否可见
function button:SetActive(mActionName, bool)
    local action = sendVO:new(mActionName, self.uModuleName, 'UIButton', 'PropertyInfoFun', 'gameObject/SetActive|MethodInfo', self.uButtonName, bool)
    if mActionName ~= nil then
        SendBatching.addSendToList(action)
    else
        SendBatching.callFromCsharp(action)
    end
end

--设置按钮是否可用
function button:isEnabled(mActionName, bool)
    local action = sendVO:new(mActionName, self.uModuleName, 'UIButton', 'PropertyInfo', 'isEnabled', self.uButtonName, bool)
    if mActionName ~= nil then
        SendBatching.addSendToList(action)
    else
        SendBatching.callFromCsharp(action)
    end
end

-- 如果按钮有UIToggle，那么设置按钮状态
function button:isSelected(mActionName, bool)
    local action = sendVO:new(mActionName, self.uModuleName, 'UIToggle', 'MethodInfo', 'set_value', self.uButtonName, bool)
    if mActionName ~= nil then
        SendBatching.addSendToList(action)
    else
        SendBatching.callFromCsharp(action)
    end
end

--设置按钮位置
function button:localPosition(mActionName, args)
    local action = sendVO:new(mActionName, self.uModuleName, 'UIButton', 'PropertyInfoFun', 'transform/localPosition|PropertyInfo', self.uButtonName, args)
    if mActionName ~= nil then
        SendBatching.addSendToList(action)
    else
        SendBatching.callFromCsharp(action)
    end
end

--增加按钮监听
function button:AddOnClick(args)
    UluaModuleFuncs.Instance.uBtnFun:AddClick(self.uModuleName, self.uButtonName, args)
end

--创建一个按钮
function button:new(mModuleName, mbuttonName)
    local o = {
        uButtonName = mbuttonName,
        uModuleName = mModuleName,
    }
    setmetatable(o, self)
    self.__index = self
    return o
end

return button;