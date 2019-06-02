--
-- Created by IntelliJ IDEA.
-- User: xiyou
-- Date: 2015/4/10
-- Time: 9:19
-- To change this template use File | Settings | File Templates.
-- 读表工具
local Table = require "uLuaModule/reader/Table"

module("JsonTableReader", package.seeall)

local allTables = {}

function GetTable(self, sTableName)
    local tb = allTables[sTableName]
    if tb then return tb end
    local data = ConfigManager.getInstance():getTableJson(sTableName)
    if data == nil then
        --        print("can't find table file -> " .. sTableName)
        return nil
    end
    local jsonData = cjson.decode(data)
    local tb = Table.new(jsonData)
    allTables[sTableName] = tb
    return tb
end

function TableRowByUnique(self, sTableName, sColName, sValue)
    local tb = GetTable(self, sTableName)
    if tb then
        return tb:RowByUnique(sColName, sValue)
    end
    return nil
end


function TableRowByID(self, sTableName, sValue)
    local tb = GetTable(self, sTableName)
    if tb then
        return tb:RowByID(sValue)
    end
    return nil
end

function TableRowByUniqueKey(self, sTableName, ...)
    local tb = GetTable(self, sTableName)
    if tb then
        return tb:RowByUniqueKey(...)
    end
    return nil
end

function TableValueByUnique(self, sTableName, sDstColName, sColName, sValue)
    local tb = GetTable(self, sTableName)
    if tb then
        return tb:TableValueByUnique(sDstColName, sColName, sValue)
    end
    return nil
end

function ForEachTable(self, sTableName, fCallback)
    local tb = GetTable(self, sTableName)
    if tb then
        tb:ForEach(fCallback)
    end
end

function ForEachLuaTable(self, sTableName, fCallback)
    ForEachTable(self, sTableName, fCallback)
end

function getTableLengthByTableName(self, sTableName)
    local tb = GetTable(self, sTableName)
    if tb then
        return tb.rowCount
    end
    return 0
end

function getTableRowCount(self, sTableName)
    local tb = GetTable(self, sTableName)
    if tb then
        return tb.rowCount
    end
    return 0
end

