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
    ClientTool.UpdateMyTable("Prefabs/moduleFabs/questModule/txt_reward", self.rewardTable, drop)
end


function reward:onClick(go, btName)
    if btName == "btreward" then
        UIMrg:popWindow()
        -- self.delegate:changeState(false, TextMap.GetValue("Text397"))
    end
end

return reward