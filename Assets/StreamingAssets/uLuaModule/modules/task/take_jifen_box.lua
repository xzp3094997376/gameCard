local m = {}


function m:update(id, tp,reward,act_id,point)
    self.id = id
    self.tp = tp
    self.reward = reward
    self.act_id = act_id
    self.point = point
    if self.tp == "task" then
        if self.row == nil then
            self.row = TableReader:TableRowByID("activeTasks_config", id)
            self.txt_jifen.text = self.row.active_point --.. TextMap.GetValue("Text1431")
        end
        local state = 0
        local s = Player.Tasks.pointReward[id]
        if s ~= 0 then
            state = 1
        elseif Player.Tasks.point >= self.row.active_point then
            state = 2
        end
        self:updateState(state)
    elseif self.tp == "world_boss" then
        if self.row == nil then
            self.row = TableReader:TableRowByID("world_boss_damagePrize", id)
            self.txt_jifen.text = (tonumber(self.row.need)/10000)..TextMap.GetValue("Text6")
        end
        local state = 0
        local s = Player.WorldBoss.dmgReward[id]
        if s ~= 0 then
            state = 1
        elseif Player.WorldBoss.dmg >= self.row.need then
            state = 2
        end
        self:updateState(state)
    elseif self.tp == "turnTable" then
        if self.act_id == nil then return end
        local state = self:checkBox()
        self.txt_jifen.text = self.id
        -- if s ~= 0 then
        --     state = 1
        -- elseif Player.Tasks.point >= self.row.active_point then
        --     state = 2
        -- end
        self:updateState(state)
    end
end

--检测大转盘积分奖励宝箱是否可领
function  m:checkBox()
    local act = Player.Activity[self.act_id..""]["reward"]
    if act ~= nil then
        local i = 0
        while act[i] ~= nil do
            if tonumber(act[i]) == tonumber(self.id) then --可领
                return 1
            end
            i = i + 1
        end
        if self.point >= self.id then --已领
            return 2
        else                                  --不可领
            return 0
        end
    else
        if self.point >= self.id then
            return 2
        else
            return 0
        end
    end
end

function m:updateState(state)
    self.eff:SetActive(state == 1)
    self.box_un_open:SetActive(state == 0 or state == 1)
    self.box_opened:SetActive(state == 2)
    self.state = state
end

function m:onReward()
    local id = self.id
    if self.tp == "task" then
        Api:getPointReward(self.id, function(result)
            m:update(id, "task")
			Events.Brocast("updateTaskRedPoint")
            UIMrg:popWindow()
            packTool:showMsg(result, nil, 1)
        end)
    elseif self.tp == "world_boss" then
        Api:getBossReward(id, function(result)
            m:update(id, "world_boss")
            UIMrg:popWindow()
            packTool:showMsg(result, nil, 1)
        end)
    elseif self.tp == "turnTable" then
        Api:getTurnTableReward(self.act_id,self.id,function(result)
            self.eff:SetActive(false)
            self.box_un_open:SetActive(false)
            self.box_opened:SetActive(true)
            UIMrg:popWindow()
            packTool:showMsg(result, nil, 1)
        end)
        -- UIMrg:popWindow()
    end
end

function m:onClickItem()
    if self.state == 2 then
        return
    end
    local temp = {}
    if self.tp == "task" then
        temp.title = TextMap.GetValue("Text1432")
        temp.onOk = function()
            m:onReward()
        end
        temp.type = "showInfo"
        temp.state = self.state --== 1
        local drop = RewardMrg.getProbdropByTable(self.row.drop)
        for i = 1, #drop do
            drop[i].__tp = "char"
        end
        temp.drop = drop
        UIMrg:pushWindow("Prefabs/moduleFabs/chapterModule/chapterbox", temp)
    elseif self.tp == "world_boss" then
        temp.title = TextMap.GetValue("Text1433")
        temp.onOk = function()
            m:onReward()
        end
        temp.type = "showInfo"
        temp.state = self.state --== 1
        local drop = RewardMrg.getProbdropByTable(self.row.drop)
        -- for i = 1, #drop do
        -- 	drop[i].__tp = "char"
        -- end
        temp.drop = drop
        UIMrg:pushWindow("Prefabs/moduleFabs/chapterModule/chapterbox", temp)
    elseif self.tp == "turnTable" then
        temp.title = TextMap.GetValue("Text1432")
        temp.onOk = function()
            m:onReward()
        end
        temp.type = "showInfo"
        temp.state = self.state --== 1
        local drop =  self.reward
        drop.number = nil
        temp.drop = drop
        UIMrg:pushWindow("Prefabs/moduleFabs/chapterModule/chapterbox", temp)
    end
end

function m:Start()
    ClientTool.AddClick(self.gameObject, function()
        m:onClickItem()
    end)
    local img = self.box_un_open:GetComponent(SimpleImage)
    if img then img.Url = UrlManager.GetImagesPath("task_img/boxClose.png") end

    local img = self.box_opened:GetComponent(SimpleImage)
    if img then img.Url = UrlManager.GetImagesPath("task_img/boxEmpty.png") end
end

return m