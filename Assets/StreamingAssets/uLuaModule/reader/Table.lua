--
-- Created by IntelliJ IDEA.
-- User: xiyou
-- Date: 2015/4/10
-- Time: 10:13
-- To change this template use File | Settings | File Templates.
-- 表格
local Table = {
    TableName = "empty",
    rowCount = 0,
    Tags = {},
    rows = {},
    uniqueIndex = {},
    uniqueKeyIndex = {},
    uniqueKeyCols = {},
    uniqueKeyCount = 0
}

--遍历表格
function Table:ForEach(callBack)
    local rows = self.rows
    if callBack == nil or rows == nil then return end
    for i = 1, self.rowCount do
        if callBack(i, self:lazyLoad(rows[i])) then return end
    end
end

local function getOtherTableValue(sTableName, colSrc, value)
    return TableReader:TableRowByUnique(sTableName, colSrc, value)
end

function Table:lazyLoad(joRow)
    if joRow == nil then return nil end
    local lazy_load = joRow["lazy_load"]
    if lazy_load == nil then return joRow end
    local jo = cjson.decode(lazy_load)
    joRow.lazy_load = nil
    table.foreach(jo, function(i, item)
        joRow[i] = item
    end)
    local oTableTags = self.Tags
    table.foreach(oTableTags, function(key, item)
        local sColName = "$" .. key
        local _linkColName = "_" .. key
        local oTag = item
        if oTag.unlink == nil and oTag.linkCell and oTag.linkCell.type == "linkCell" then
            local oLinkCell = oTag.linkCell
            local tb = oLinkCell.table
            local colSrc = oLinkCell.colSrc
            local multiKey = oTag.multiCell
            local array = oTag.array
            local oRow = joRow
            if multiKey and multiKey == true then
                if oRow[sColName] ~= nil then
                    if array then
                        local vCell = oRow[sColName]
                        local vNewCell = {}
                        oRow[_linkColName] = vNewCell
                        if vCell ~= nil and vCell ~= cjson.null then
                            for i = 1, #vCell do
                                local vSubCell = vCell[i]
                                local vNewSubCell = {}
                                table.insert(vNewCell, vNewSubCell)
                                if vSubCell == cjson.null then
                                    table.insert(vNewSubCell, cjson.null)
                                else
                                    for j = 1, #vSubCell do
                                        table.insert(vNewSubCell, getOtherTableValue(tb, colSrc, vSubCell[j]))
                                    end
                                end
                            end
                        end
                    else
                        local vCell = oRow[sColName]
                        local vNewCell = {}
                        for i = 1, #vCell do
                            table.insert(vNewCell, getOtherTableValue(tb, colSrc, vCell[i]))
                        end
                        oRow[_linkColName] = vNewCell
                    end
                    oRow[sColName] = nil
                end
            elseif multiKey == nil then
                if oRow[sColName] then
                    if array then
                        local vCell = oRow[sColName]
                        local vNewCell = {}
                        if vCell ~= nil and vCell ~= cjson.null then
                            for i = 1, #vCell do
                                table.insert(vNewCell, getOtherTableValue(tb, colSrc, vCell[i]))
                            end
                        end
                        oRow[_linkColName] = vNewCell
                    else
                        oRow[_linkColName] = getOtherTableValue(tb, colSrc, oRow[sColName]);
                    end
                    oRow[sColName] = nil
                end
            else
                local vCell = oRow[multiKey]
                if vCell and vCell ~= cjson.null then
                    local n = string.sub(sColName, #multiKey + 3)
                    local sRealColName = "$" .. n
                    local linkRealColName = "_" .. n
                    for i = #vCell, 1, -1 do
                        local oCell = vCell[i]
                        if oCell and oCell ~= cjson.null then
                            if array then
                                local vSubCell = oCell[sRealColName]
                                local vNewSubCell = {}
                                if vSubCell and vSubCell ~= cjson.null then
                                    for j = 1, #vSubCell do
                                        table.insert(vNewSubCell, getOtherTableValue(tb, colSrc, vSubCell[j]))
                                    end
                                end
                                oCell[linkRealColName] = vNewSubCell
                                oCell[sRealColName] = nil
                            else
                                if oCell[sRealColName] then
                                    oCell[linkRealColName] = getOtherTableValue(tb, colSrc, oCell[sRealColName])
                                    oCell[sRealColName] = nil
                                end
                            end
                        end
                    end
                end
            end
        end
    end)

    return joRow;
end

function Table:ValueByUnique(sDstColName, sColName, sValue)
    local row = self:RowByUnique(sColName, sValue)
    if row then return row[sDstColName] end
    return nil
end

--表格长度
function Table:returnTableLength()
    return self.rowCount
end

--通过UniqueKey读表
function Table:RowByUniqueKey(...)
    local arg = { ... }
    local count = #arg
    local key = nil
    if count == self.uniqueKeyCount then
        key = arg[1]
        for i = 2, count do
            key = key .. "||"
            key = key .. arg[i]
        end
    elseif count == self.uniqueKeyCount * 2 then
        local aKeys = {}
        for i = 1, count, i + 2 do
            local nIndex = self.uniqueKeyCols[arg[i]]
            if nIndex == nil then
                print("传参不正确。")
                return
            end
            aKeys[nIndex] = arg[i + 1]
        end
        key = table.concat(aKeys, "||")
    elseif count == 1 and type(arg[1]) == "table" then
        local joArg = arg[1]
        local aKeys = {}
        for i, v in pairs(self.uniqueKeyCols) do
            if joArg[i] == nil then return nil end
            aKeys[v] = joArg[i]
        end
        key = table.concat(aKeys, "||")
    else
        return nil
    end
    local rowIndex = self.uniqueKeyIndex[key]
    if rowIndex then return self:lazyLoad(self.rows[rowIndex]) end
    return nil
end

function Table:RowByUnique(sColName, sValue)
    if sValue == nil or sColName == nil then
        error("*******Unique args can't empty*************")
        return nil
    end
    local col = self.uniqueIndex[sColName]
    if col then
        return self:lazyLoad(self.rows[col[sValue .. ""]])
    end
    return nil
end

function Table:RowByID(sValue)
    return self:RowByUnique("id", sValue)
end

function Table:init(jsonData)
    if jsonData == nil then
        error("***************can't find table*******************")
        return
    end
    self.uniqueIndex = {}
    self.uniqueKeyIndex = {}
    self.Tags = {}
    self.rows = {}

    self.TableName = jsonData.enName
    self.Tags = jsonData.tags
    local aTableRows = jsonData.rows
    self.rows = aTableRows
    self.rowCount = #self.rows
    local oTableTags = self.Tags
    local aUniqueCols = {} --唯一列
    local aUniqueKeyCols = {} --组合唯一列
    local oUniqueIndex = {}
    table.foreach(oTableTags, function(sColName, oColTag)
        if (oColTag.unique) then
            table.insert(aUniqueCols, sColName)
            oUniqueIndex[sColName] = {}
        elseif (oColTag.uniqueKey) then
            table.insert(aUniqueKeyCols, sColName)
        end
    end)
    self.uniqueKeyCount = #aUniqueKeyCols

    for i = 1, self.uniqueKeyCount do
        self.uniqueKeyCols[aUniqueKeyCols[i]] = i
    end

    local oUniqueKeyIndex = {} --组合唯一列
    for i = 1, self.rowCount do --对每一行进行解析
    local oRow = aTableRows[i] --第i+1行

    table.foreach(aUniqueCols, function(index, sColName)
        if oRow[sColName] and oRow[sColName] ~= "" then
            oUniqueIndex[sColName][oRow[sColName] .. ""] = i --记录唯一列值对应的行号。
        end
    end)
    if oRow["$key"] then
        oUniqueKeyIndex[oRow["$key"]] = i
    end
    end
    self.uniqueIndex = oUniqueIndex
    self.uniqueKeyIndex = oUniqueKeyIndex
end

local fields = {}

Table.__index = function(t, k)
    local var = rawget(Table, k)

    if var == nil then
        t = fields
        var = rawget(t, k)

        if var ~= nil then
            return var()
        end
    end

    return var
end

function Table.new(jsonData)
    local o = {}
    setmetatable(o, Table)
    o:init(jsonData)
    return o
end

return Table

