notice = {}
local noticeArray = {} --接下来需要播放的电视节目
local bool isPlayTV = false -- 是否正在播放节目
local highWeight = {} --最高权重的数据集合 -- 弃用
local middleWeight = {} --一般默认权重的数据集合 -- 弃用
local randomMsgArr = {} --随机飘字的信息
local showInterval = 30 --默认60秒--30
local tempInterval = 0 --临时间隔
local randomIndex = 1
local REFRESH_TIMER = 0
local isMoving = false

local msgList = {} -- 消息列表
-- local msgList = { --test
-- {weight = 7, content = "7777777777", time=1434019458},
-- {weight = 2, content = "22222222222", time=1434099458},
-- {weight = 4, content = "44444444444", time=1434099458}} 


--2为最优先级数据   1为一般数据
function notice:update(str, times, weight)
    -- if weight ==1 then
    --     for i=1,times do
    --        table.insert(highWeight,str)
    --     end
    --     return
    -- end
    -- for i=1,times do
    --     table.insert(middleWeight,str)
    -- end

    for i = 1, times do
        local msg = {}
        msg.weight = tonumber(weight)
        msg.content = str
        msg.time = os.time()
        table.insert(msgList, msg)
    end
end

function notice:GetNextMsg()
    -- 清理超过一个小时之前的消息
    local seconds = 60 * 60 -- 一个小时的秒数
    local len = #msgList
    local _time
    local _now = os.time()
    if len > 0 then
        for index = len, 1, -1 do
            _time = msgList[index].time
            if os.difftime(_now, _time) > seconds then
                table.remove(msgList, index)
            end
        end
    end

    -- 获取优先级调用更高的消息第一条消息
    local len = #msgList
    if len > 0 then
        local lucky = 1
        for i, msg in pairs(msgList) do
            if msgList[i].weight > msgList[lucky].weight then
                lucky = i;
            end
        end
        return msgList[lucky], lucky
    end

    -- 没有消息返回nil
    return nil, nil
end

function notice:SortData()
    if isMoving == true then return end
    -- if #highWeight>0 then --如果有最高级，先播放最高级的电视台
    --      notice:showTV(self.move:analysisUrlEncry(highWeight[1]))
    --       table.remove(highWeight, 1)
    --       return
    -- end
    -- if #middleWeight>0 then
    --      notice:showTV(self.move:analysisUrlEncry(middleWeight[1]))
    --       table.remove(middleWeight, 1)
    --       return
    -- end
    local msg = nil
    local index = -1
    msg, index = notice:GetNextMsg()
    if msg ~= nil then
        notice:showTV(self.move:analysisUrlEncry(msg.content))
        table.remove(msgList, index)
        return
    end

    self.content:SetActive(false)
    tempInterval = tempInterval + 5
    if tempInterval >= showInterval then
        randomIndex = randomIndex + 1
        if randomIndex > #randomMsgArr then
            randomIndex = 1
        end
        notice:showTV(randomMsgArr[randomIndex])
        --local testmsg = "部分<blink colors=00ffff|fff600| gap=200>【英雄碎片】</blink> 要在<blink colors=00ffff|fff600 gap=300>【对决】</blink>中才能获得。<blink colors=00ffff gap=150>【不闪】</blink>"
        --local testmsg = "部分[fff600]英雄碎片】要在对决中才能获得************aaaaaaaaaaaa*******bbbbbbbbbbb********ccccccccccccc*****"
        --notice:showTV(testmsg)
    end
end

function notice:Start()
    self.label.text = ""
    self:hideTV()
    TableReader:ForEachLuaTable("loadTips",
        function(index, item)
            table.insert(randomMsgArr, item.desc)
            return false
        end)
    local obj = TableReader:TableRowByID("GMconfig", 1)
    if obj ~= nil then
        showInterval = obj.args1
    else
        showInterval = 300
    end
    --showInterval =5
    REFRESH_TIMER = LuaTimer.Add(0, 5000,
        function(id)
            notice:SortData() --分类数据
            return true
        end)
end

function notice:hideTV()
    tempInterval = 0
    isMoving = false
    self.content:SetActive(false)
    tagTextParser = require("uLuaModule/helper/TagTextParser")
    if tagTextParser ~= nil then
        tagTextParser:Destory()
    end
end

function notice:showTV(msg)
    isMoving = true
    tempInterval = 0
    self.content:SetActive(true)
    --self.label.text = msg    
    tagTextParser = require("uLuaModule/helper/TagTextParser")
    tagTextParser:new(msg, 1, function(newMsg)
        if self.label ~= nil then
            self.label.text = newMsg
        end
    end)

    self.move:beginMove(funcs.handler(self, self.hideTV))
end

function notice:OnDestroy()
    LuaTimer.Delete(REFRESH_TIMER)
end

function notice:create()
    return self
end

return notice