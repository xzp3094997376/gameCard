local rewardInfo = {}

local infobinding
function rewardInfo:update(data)
    -- print("type start " .. table.type .. "arg" .. table.arg .. "arg2" .. table.arg2)
    local _type = data.type
    if _type == "char" then
        local char = Char:new(data.arg)
        char.lv = 0
        self.frame.gameObject:SetActive(false)
        if infobinding == nil then
            infobinding = ClientTool.loadAndGetLuaBindingFromPool("Prefabs/publicPrefabs/itemAll", self.go)
        end
        infobinding:CallUpdate({ "char", char, self.frame.width, self.frame.height, true, nil, true })
        --num = data.arg2
    else
        local char = {}
        char = RewardMrg.getDropItem(data)
        self.frame.gameObject:SetActive(false)
        if infobinding == nil then
            infobinding = ClientTool.loadAndGetLuaBindingFromPool("Prefabs/publicPrefabs/itemAll", self.go)
        end
        infobinding:CallUpdate({ "char", char, self.frame.width, self.frame.height, true, nil, true })
    end
end

function rewardInfo:create()
    return self
end

return rewardInfo