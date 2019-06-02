local m = {}

function m:testTime(...)
    local curtime = os.time()
    local curDate = os.date("*t", curtime)
    -- print(curtime)
    -- for i, v in pairs(curDate) do
    --       print(i);
    --       print(v);
    -- end
    local timeData = {}
    timeData.year = 2015
    timeData.month = 7
    timeData.day = 28
    timeData.hour = curDate.hour
    timeData.min = curDate.min
    timeData.sec = curDate.sec
    local mytime = os.time(timeData)

    print(curtime)
    print(mytime)
end

return m