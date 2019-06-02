local reward = {}


function reward:Start()
    ClientTool.AddClick(self.bg, function()
        --刷新该item将目录改成已领取
        UIMrg:popWindow()
    end)
end

function reward:update(data)
    local drop = data.drop
    self.delegate = data.delegate
    self.id = data.id
    self.type = data.type
    ClientTool.UpdateMyTable("Prefabs/moduleFabs/questModule/txt_reward", self.rewardTable, drop)
end

function reward:onClick(go, btName)
    if btName == "btreward" then
        Api:submitTask(self.id, function()
            UIMrg:popWindow()
            self.delegate:hasRewardItween()
        end, function()
            return false
        end)
    end
end


return reward