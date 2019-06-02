--比武竞猜奖励界面
local m = {}

function m:update(data)
    self.delegate = data.delegate
end

function m:initData(list)
    if list == nil then return end
    self.show_list = {}
    for i=0,list.Count-1 do
        table.insert(self.show_list,list[i])
    end
    self.scrollview:refresh(self.show_list, self)
    if #self.show_list == 0 then
        self.un_reward:SetActive(true)
        self.btn_get.isEnabled = false
    else
        self.un_reward:SetActive(false)
        self.btn_get.isEnabled = true
    end
end

--飘字
function m:showMsg(drop)
    local list = RewardMrg.getList(drop)
    local ms = {}
    table.foreach(list, function(i, v)
        local g = {}
        g.type = v:getType()
        g.icon = "resource_fantuan"
        g.text = v.rwCount
        g.goodsname = v.name
        table.insert(ms, g)
        g = nil
    end)
    OperateAlert.getInstance:showGetGoods(ms, self.msg)
    self:refreshData()
end

function m:refreshTimes()
    if self.delegate ~= nil then
        self.delegate:refreshTimes()
    end
end

function m:onClick(go, name)
    if name == "btn_close" then
        UIMrg:popWindow()
    elseif name == "btn_get" then
        local that = self
        Api:getGuessReward("ones",0,0,function (result)
            that:showMsg(result)
        end)
    end
end

--刷新数据
function m:refreshData()
    local that = self
    Api:getGuessRewardShow(function (result)
        that:initData(result.showArr)
    end)
end

function m:Start(...)
    self:refreshData()
end

return m