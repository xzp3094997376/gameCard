local actSignin = {}
local haveAwardIndex = 0
local oldcolor = nil
function actSignin:Start()
end

function actSignin:update(_data)
    local analogData = {}
    local data = _data.data
    haveAwardIndex = 0
    for i = 1, 31 do
        i = i .. ""
        if data.data[i] ~= nil then
            local tempdata = {}
            tempdata.month = tonumber(data.month)
            tempdata.type = data.drop[i][1].type
            tempdata.id = data.drop[i][1].arg
            tempdata.num = tonumber(data.drop[i][1].arg2)
            tempdata.vip = tonumber(data.data[i].vip) or 0
            tempdata.state = data.status[i] or 1
            if tonumber(tempdata.state) == 2 and haveAwardIndex == 0 then
                haveAwardIndex = tonumber(i)
            end
            tempdata.price = tonumber(data.data[i].repairCost)
            tempdata.mul = tonumber(data.data[i].dropMultiple) or 0
            tempdata.index = i
            tempdata.father = _data.delegate
            tempdata.actID = data.id
            tempdata.event = data.event
            table.insert(analogData, tempdata)
        end
    end
    self.binding:CallAfterTime(0.05,
        function()
            self.scrollview:refresh(analogData, self)
            if haveAwardIndex ~= 0 and haveAwardIndex > 12 then
                local jump = math.ceil(haveAwardIndex / 6)
                if jump > 3 then --之所以大于5就=6 是因为后面三页其实可以不用跳转，调到第六页就可以看到所有的了
                jump = 3
                end
                self.scrollview:assignPage(jump)
            end
        end)
end


return actSignin