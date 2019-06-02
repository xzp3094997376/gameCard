local m = {}

function m:update(data, index, delegate)
    self.data = data
	self.txt_name.text = "[FFFF96FF]"..(data.bossName or "") .. "[-] ".. (data.lv or 1).."级" 
	local t2 = os.date('(%H:%M)', (data.ltime or 0) / 1000)
	self.txt_time.text = t2
    local tb = {}
    local tb2 = {}
    local str1 = ""
    if data.drop then 
        local t1 = os.date('(%H:%M)', (data.time or 0) / 1000)
        self.txt_time2.text = t1
        for i = 0, data.drop.Count-1 do 
            local d = RewardMrg.getDropItem(data.drop[i])
            if d ~= nil then table.insert( tb, d ) end
        end
        for i = 1, #tb do 
		    str1 = ("[913D00FF]"..tb[i].name .. "X"..  tb[i].rwCount .. "[-] ")
	    end 
        self.txt_kill.text = "[00ff00]"..data.name .. TextMap.GetValue("Text_1_2944").. str1
    else 
        self.txt_kill.text = ""
    end
    for i = 0, data.ldrop.Count-1 do 
        local d = RewardMrg.getDropItem(data.ldrop[i])
        if d ~= nil then table.insert( tb2, d ) end
    end

	--local tb = RewardMrg.getDropItem(data.drop)
	--local tb2 = RewardMrg.getDropItem(data.ldrop)
	local str2 = ""
	for i = 1, #tb2 do 
		str2 = ("[913D00FF]"..tb2[i].name .. "X"..  tb2[i].rwCount .. "[-] ")
	end 
	self.txt_lucky.text = "[00ff00]"..data.lname .. TextMap.GetValue("Text_1_2943") .. str2
end
	
function m:Start()
  --RewardMrg.getList(data)
end

function m:formatitTime(arg)
    local h = arg[1]
    local m = arg[2]
    local s = arg[3]
    local str = ""
    if h < 10 then
        str = str .. "0" .. h .. ":"
    else
        str = str .. h .. ":"
    end

    if m < 10 then
        str = str .. "0" .. m
    else
        str = str .. m
    end
    if s > 0 and s < 10 then
        str = str .. ":0" .. s
    elseif s > 0 then
        str = str .. ":" .. s
    end
    return str
end

function m:addTime(s1, s2)
    local list = {}
    for i = 1, #s1 do
        local t = s1[i] + s2[i]
        if i > 1 and t >= 60 then
            list[i - 1] = list[i - 1] + 1
            list[i] = t % 60
        else
            list[i] = t
        end
    end
    return list
end

return m