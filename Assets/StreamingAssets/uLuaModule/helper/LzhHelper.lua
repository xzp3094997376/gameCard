local m = {}

function m:GetCurDate()
    local curtime = os.time()
    local curDate = os.date("*t", curtime)
    return curDate
end

-- 时间格式化 00:00:00 样式
function m:GetFormatTime(seconds)
	if Localization.language == "EN" then
		--转换美国时间
		second = second - 3600 * 12
	end
    local str = ""
    local t = 0
    if seconds >= 3600 then
        t = math.floor(seconds / 3600)
        if t < 10 then
            str = str .. "0" .. t .. ":"
        else
            str = str .. t .. ":"
        end
        seconds = seconds % 3600
    else
        str = str .. "00:"
    end
    if seconds >= 60 then
        t = math.floor(seconds / 60)
        if t < 10 then
            str = str .. "0" .. t .. ":"
        else
            str = str .. t .. ":"
        end
        seconds = seconds % 60
    else
        str = str .. "00:"
    end
    t = math.floor(seconds)
    if t < 10 then
        str = str .. "0" .. t
    else
        str = str .. t
    end
    return str
end

function m:GetHMS(seconds)
    local temp = {}
    local hour = math.floor(seconds / 3600) or 0
    local minute = math.floor((seconds % 3600) / 60) or 0
    local second = math.floor((seconds % 3600) % 60) or 0
    temp.hour = hour
    temp.minute = minute
    temp.second = second
    return temp
end

-- “5*60*1000” --> 300000
function m:GetMillSecondsFromFormat(format)
    if format == nil then
        return 0
    end
    local ret = 1
    local has = false
    for d in string.gmatch(format, "%d+") do
        ret = ret * tonumber(d)
        if has == false then
            has = true
        end
    end
    if has == false then
        ret = 0
    end

    return ret
end

return m