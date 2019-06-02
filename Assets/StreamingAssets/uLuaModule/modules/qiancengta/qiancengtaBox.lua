local boxGet = {}
local analogData = {}
local isHaveAward = false
local totelNum = 0
function boxGet:GetAwardState(index)
    local state = 0 --已经领取
    if index < Player.qianCengTa.lastTower and Player.qianCengTa.specialBox[index] == 0 then
        return state
    end
    state = 1 --未完成
    if Player.qianCengTa.specialBox[index] ~= 0 then
        state = 2 --可领取
    end
    return state
end

local function sortAnalogData()
    if analogData ~= nil then
        table.sort(analogData, function(a, b)
            if a.state ~= b.state then return a.state > b.state end
            if a.index ~= b.index then return a.index < b.index end
        end)
    end
end

--遍历300，然后%5 再判断一遍是否领取，然后再排序
function boxGet:update(tables)
    self.callself = tables
    totelNum = TableReader:TableRowByID("tower_config", "totelFloors").args1 --拿到千层塔最大层数
    isHaveAward = false
    analogData = {}
    for i = 0, (totelNum + 1), 3 do
        if i % 3 == 0 then
            local tempData = {}
            tempData.index = i
            tempData.state = boxGet:GetAwardState(i)
            if tempData.state ~= 0 then
                tempData.cb = self
                isHaveAward = true
                table.insert(analogData, tempData)
            end
            tempData = nil
        end
    end
    if isHaveAward == false then
        MessageMrg.show(TextMap.GetValue("Text1361"))
        UIMrg:popWindow()
    else
        sortAnalogData()
        self.binding:CallAfterTime(0.03,
            function()
                self.scrollview:refresh(analogData, self)
            end)
    end
end

function boxGet:onClick(go, name)
    if name == "close" then
        self.callself:showAwardBox()
        --self.callself =nil
        UIMrg:popWindow()
    end
end

--初始化
function boxGet:create(binding)
    self.binding = binding
    return self
end

return boxGet