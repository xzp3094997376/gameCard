uLuaActin = {
    mActionName = "default",
    mModuleName = "TestPlayHead",
    mClassName = "UILabel",
    mProType = "MethodInfo",
    mProName = "testUILabel",
    mComponetName = "Label",
    mArgs = { 'hello4535', 1, {} }
}
--原子命令基本格式
--mActionName 批处理命令名字
--mModuleName 模块名
--mClassName 类名
--mProType 方法或者属性类型
--mProName 方法名或者属性名字
--mComponetName 当前组件名字
--mArgs 方法或者属性所需要的参数
function uLuaActin:init(mActionName, mModuleName, mClassName, mProType, mProName, mComponetName, mArgs)
    self.mActionName = mActionName
    self.mModuleName = mModuleName
    self.mClassName = mClassName
    self.mProType = mProType
    self.mProName = mProName
    self.mComponetName = mComponetName
    self.mArgs = mArgs
end

function uLuaActin:new(mActionName, mModuleName, mClassName, mProType, mProName, mComponetName, mArgs)
    local o = {}
    setmetatable(o, self)
    self.__index = self
    o:init(mActionName, mModuleName, mClassName, mProType, mProName, mComponetName, mArgs)
    return o
end

return uLuaActin