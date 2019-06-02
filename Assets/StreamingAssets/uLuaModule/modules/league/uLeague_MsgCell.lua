local m = {}

function m:update(data, index, delegate)
    self.data = data
    self.delegate = delegate

    self:setData(data)
end

function m:setData(data)
    --local strTime = data.time
    local strTime = self:getFormatTime(tonumber(data.time) / 1000)
    local message = data.message
    self.txt_des.text = "[1cff00]" .. strTime .. "[-] " .. message
end

function m:getFormatTime(time)
    local tab = ""
    if time then
        tab = os.date('{%m-%d %H:%M}', time)
    else
        tab = os.date('{%m-%d %H:%M}')
    end
    return tab
end

return m