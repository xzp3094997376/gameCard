local m = {}


function m:update(data)
    
    if data.reward == nil then return end
    local tb = data.reward
    self.delegate = data.delegate
    self.point = data.point

    local count = 0
    local list = {}
    table.foreach(tb, function(i, v)
        v.number = tonumber(i)
        table.insert(list,v)
        count = count + 1
    end)

    table.sort(list, function(a, b)
        return a.number < b.number
    end)

    --设置宝箱位置
    self.max = list[count].number
    if count ~= 0 then
        for i=1,count do
            local x = (-512) + list[i].number/self.max*1180
            self["box"..i].gameObject.transform.localPosition = Vector3(x, 136, 0)
        end
    end

    if self.delegate ~= nil then
        self:refreshSlider(self.delegate.point)
    end

    -- local number = 0
    for i=1,6 do
        if list[i] ~= nil then
            self["box"..i].gameObject:SetActive(true)
            self["box" .. i]:CallUpdateWithArgs(list[i].number, "turnTable",list[i],self.delegate.act_id,self.point)
            -- number = number + 1
        else
            self["box"..i].gameObject:SetActive(false)
        end
    end
end

--刷新积分进度条
function m:refreshSlider(point)
    if point == nil then return end
    if point >= self.max then
        self.slider.value = 1 
    else
        self.slider.value = point/self.max
    end
end

function m:Start()
    self.slider.value = 0
end

return m