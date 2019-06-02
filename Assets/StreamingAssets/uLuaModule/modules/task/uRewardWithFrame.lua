local rewardInfo = {}

function rewardInfo:create(...)
    return self
end

local infobinding

function rewardInfo:update(data)
    local _type = data.type
    local num = 0
    if _type == "char" then
        local char = Char:new(data.arg)
        char.lv = 0
        self.frame.gameObject:SetActive(false)
        if infobinding == nil then
            infobinding = ClientTool.loadAndGetLuaBindingFromPool("Prefabs/publicPrefabs/itemAll", self.go)
        end
        infobinding:CallUpdate({ "char", char, self.frame.width, self.frame.height })
        num = data.arg2
    else
        local char = RewardMrg.getDropItem({type=data.type,arg2=1,arg=data.arg})
        self.frame.gameObject:SetActive(false)
        if infobinding == nil then
            infobinding = ClientTool.loadAndGetLuaBindingFromPool("Prefabs/publicPrefabs/itemAll", self.go)
        end
        infobinding:CallUpdate({ "char", char, self.frame.width, self.frame.height })
        num = char.rwCount or 0
    end
    self.txt_number.text = "[00ba00]" .. num .. "[-]"
end


return rewardInfo