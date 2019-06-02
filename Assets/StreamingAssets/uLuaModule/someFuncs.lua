--清理一个表
local function tableClear(theTable)
    while true do
        local k = next(theTable)
        if not k then break end
        theTable[k] = nil
    end
end

--获取一个表的长度
local function tableLen(theTable)
    local count = 0
    for i, j in pairs(theTable) do
        count = count + 1
    end
    return count
end

--检测表内是否含有某个值，返回索引位置，不存在返回0
local function indexOf(arrTable, theValue)
    for i, j in pairs(arrTable) do
        if j == theValue then
            return i
        end
    end
end

--判断某个值是否在表内，返回布尔类型
local function isValueInTable(theValue, theTable)
    for i, j in pairs(theTable) do
        if j == theValue then
            return true
        end
    end
    return false
end

--判断某个key是否在表内，返回布尔类型
local function isKeyInTabel(theKey, theTable)
    for i, j in pairs(theTable) do
        if i == theKey then
            return true
        end
    end
    return false
end


--合并两个表
local function MergeTable(theTableA, theTableB)
    for m, v in pairs(theTableB) do
        theTableA[m] = v;
    end
end

local function handler(target, func)
    return function(...) return func(target, ...) end
end

--表格判空
local function empty(luaTable)
    return next(luaTable) == nil
end

local function moneyNumber(num)
    num = tonumber(num)
    if num == 1 then
        return " "
    end
    if num == nil then
        return ""
    end
    if num >= 100000 then
		local temp = ""
		if Localization.language == "EN" then 
			temp = math.floor(num / 10000) * 10 .. "k"
		else
			temp = math.floor(num / 10000) .. TextMap.GetValue("Text6")
		end
		
        return temp
    end
    return num
end

local function moneyNumberShowOne(num)
    if num == nil then
        return ""
    end
    -- if num >= 100000 then
    --     return math.floor(num / 10000) .. TextMap.GetValue("Text6")
    -- end
    if num >= 1000000000 then --大于一百万,显示单位为M
        return math.floor(num / 100000000) .. TextMap.GetValue("Text1640")
    elseif num >=100000 then --大于一千,小于一百万显示单位为K
        return math.floor(num / 10000) .. TextMap.GetValue("Text1641")
    end
    return num
end


local function typeId(_type)
    -- local ret = false
    -- TableReader:ForEachLuaTable("resourceDefine", function(k, v)
    --     if _type == v.name then
    --         ret = true
    --         return false
    --     end
    -- end)
    return Tool.typeId(_type) 
end

local function itemVoNumber(num, id, types)
    if typeId(types) == true then
        return moneyNumber(num)
    end
    if num == nil then
        return ""
    end
    if num <= 0 then
        return " "
    end
	return num
end 

local function itemNumber(num, id, types)
    if typeId(types) == true then
        return moneyNumber(num)
    end
	num = tonumber(num)
    if num == nil then
        return ""
    end
    if num <= 1 then
        return " "
    end
    -- if num >= 99 and types == "item" then
    --     if id ~= 26 and id ~= 27 then
    --         return "99+"
    --     end
    -- end
    -- if num > 999 then
    --     return "999+"
    -- end
    return num
end

--lua table 拷贝
local function table_copy_table(ori_tab)
    if (type(ori_tab) ~= "table") then
        return nil
    end
    local new_tab = {}
    for i, v in pairs(ori_tab) do
        local vtyp = type(v)
        if (vtyp == "table") then
            new_tab[i] = table_copy_table(v)
        elseif (vtyp == "thread") then
            new_tab[i] = v
        elseif (vtyp == "userdata") then
            new_tab[i] = v
        else
            new_tab[i] = v
        end
    end
    return new_tab
end

return {
    tableClear = tableClear,
    tableLen = tableLen,
    indexOf = indexOf,
    isKeyInTabel = isKeyInTabel,
    isValueInTable = isKeyInTabel,
    MergeTable = MergeTable,
    handler = handler,
    itemNumber = itemNumber,
	itemVoNumber = itemVoNumber,
    moneyNumberShowOne = moneyNumberShowOne,
    moneyNumber = moneyNumber,
    empty = empty,
    copy = table_copy_table
}