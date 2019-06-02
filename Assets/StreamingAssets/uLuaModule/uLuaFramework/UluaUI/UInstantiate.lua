funcs = require("uLuaModule/someFuncs.lua")

local InstantiateGo = {
    mUrlString = "uLuaModule/TestPlayHead",
    mModuleName = "ulua",
    mGoName = "hahah",
    mPos = { 0, 0, 0 },
    mLocale = { 1, 1, 1 },
    mActionName = "default",
    mParentName = "testUILabel"
}

local actionDic = {}

-- 增加一个原子命令
function InstantiateGo:addActionToList(action)
    if funcs.isKeyInTabel(action.mActionName, actionDic) ~= true then
        actionDic[action.mActionName] = {}
    end
    table.insert(actionDic[action.mActionName], action)
end

--删除一个批处理字典
local function clearActionDic(actionname)
    actionDic[actionname] = nil
end

-- 发送批处理命令
function InstantiateGo:beginTransaction(actionname, callback)
    UluaModuleFuncs.Instance.uOtherFuns:instantiateCommands(actionDic[actionname], callback)
    clearActionDic(actionname)
end

--生成一个预设
function InstantiateGo:init(mActionName, mGoName, mUrlString, mModuleName, mPos, mLocale, mParentName)
    self.mUrlString = mUrlString
    self.mModuleName = mModuleName
    self.mPos = mPos
    self.mGoName = mGoName
    self.mActionName = mActionName
    self.mLocale = mLocale
    self.mParentName = mParentName
end

function InstantiateGo:new(mActionName, mGoName, mUrlString, mModuleName, mPos, mLocale, mParentName)
    local o = {}
    setmetatable(o, self)
    self.__index = self
    o:init(mActionName, mGoName, mUrlString, mModuleName, mPos, mLocale, mParentName)
    if mActionName ~= nil then
        o:addActionToList(o)
    else
        UluaModuleFuncs.Instance.uOtherFuns:instantiateGmeObject(o)
    end
    return o
end

return InstantiateGo