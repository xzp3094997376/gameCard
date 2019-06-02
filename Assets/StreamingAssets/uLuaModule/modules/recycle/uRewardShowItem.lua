local m = {}

local infobinding

function m:update(data)
    local info = data
    self.frame.gameObject:SetActive(false)
    local name = ""
    local num = 0
    local char = RewardMrg.getDropItem({type=info.goodsType,arg2=1,arg=info.text})
    if infobinding == nil then
        infobinding = ClientTool.loadAndGetLuaBindingFromPool("Prefabs/publicPrefabs/itemAll", self.go)
    end
    infobinding:CallUpdate({ "char", char, self.frame.width, self.frame.height })
    name = Tool.getNameColor(char.star or char.color or 1) .. char.name .. "[-]"
    self.num.text = info.text
    self.name.text = "[00ba00]" .. name .. "[-]"
end

return m