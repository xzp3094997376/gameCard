-- 比武进程左边界面
local m = {}

function m:Start(...)
    LuaMain:ShowTopMenu()
end

function m:update(data)
    local four = data.four_data
    local seven = data.seven_data
    self.delegate = data.delegate
    for i=1,4 do
        four[i].delegate = self.delegate
        self["btn_big_"..i]:CallUpdate(four[i])
    end
    for i=1,7 do
        if seven[i] ~= nil then
            seven[i].delegate = self.delegate
        end
        self["btn_small_"..i]:CallUpdate(seven[i])
    end
end

function m:onClick(go, name)
end

return m