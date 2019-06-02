local rewardInfo = {}

function rewardInfo:create(...)
    return self
end

local infobinding

function rewardInfo:update(data)
    local info = data.v
    local name = ""
    local char = RewardMrg.getDropItem(info)
    self.item_kuangzi.gameObject:SetActive(false)
    if infobinding == nil then
        infobinding = ClientTool.loadAndGetLuaBindingFromPool("Prefabs/publicPrefabs/itemAll", self.go)
    end
    name = Tool.getNameColor(char.star or char.color or 1) .. char.name .. "[-]"
    infobinding:CallUpdate({ "char", char, self.item_kuangzi.width, self.item_kuangzi.height, isTip })
    if data.showName ~= nil then
        self.name.text = name
    end
end


return rewardInfo