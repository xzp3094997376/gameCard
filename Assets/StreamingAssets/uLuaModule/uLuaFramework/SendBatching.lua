funcs = require("uLuaModule/someFuncs.lua")

actionNum = 0
--get The actionName ,sure all actionName will be the only one.
function getActionName()
    actionNum = actionNum + 1
    return "actionName" .. actionNum
end

local actionDic = {}

-- 增加原子命令到字典
local function addSendToList(action)
    if funcs.isKeyInTabel(action.mActionName, actionDic) ~= true then
        actionDic[action.mActionName] = {}
    end
    table.insert(actionDic[action.mActionName], action)
end

--根据名字创建批处理字典
local function clearActionDic(actionname)
    actionDic[actionname] = nil
end

-- 发送批处理命令
local function beginTransaction(actionname)
    UluaModuleFuncs:luaBatchCommands(actionDic[actionname])
    clearActionDic(actionname)
end

--直接发送原子命令到C#，注意：不对外公开
local function callFromCsharp(action)
    UluaModuleFuncs:luaCommands(action)
end

--打开或者关闭一个模块（modulename：模块名，mprefabsUrl：模块预设地址，index：{0打开或者关闭，1打开，-1关闭}，callBack：打开或者关闭回调方法，不能为空）
local function OpenOrCloseModule(modulename, mprefabsUrl, index, callBack)
    UluaModuleFuncs.Instance.uOtherFuns:openOrCloseWindow(modulename, mprefabsUrl, index, callBack)
end

--销毁对象
local function DestroyGameOject(obj)
    UluaModuleFuncs.Instance.uOtherFuns:DestroyGameOject(obj)
end

--销毁对象
local function DestroyGameOjectByName(moduleName, prefabName)
    local tempObj = {}
    tempObj.mModuleName = moduleName
    tempObj.mGoName = prefabName
    UluaModuleFuncs.Instance.uOtherFuns:DestroyGameOjectByName(tempObj)
    tempObj = nil
end

--
local function CreateTableByNameAndNum(path, myTable, num)
    return UluaModuleFuncs.Instance.uOtherFuns:CreateTableByNameAndNum(path, myTable, num)
end

return {
    addSendToList = addSendToList,
    beginTransaction = beginTransaction,
    callFromCsharp = callFromCsharp,
    clearActionDic = clearActionDic,
    OpenOrCloseModule = OpenOrCloseModule,
    DestroyGameOject = DestroyGameOject,
    DestroyGameOjectByName = DestroyGameOjectByName,
    CreateTableByNameAndNum = CreateTableByNameAndNum
}