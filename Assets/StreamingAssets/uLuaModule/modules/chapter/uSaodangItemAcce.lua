local saodangItemAcce = {}

function saodangItemAcce:Start()
    if self.name then self.name.fontSize = 16 end
end

local infobinding

function saodangItemAcce:update(data)
    if data ~= nil then
        local it = data
        if infobinding == nil then
            infobinding = ClientTool.loadAndGetLuaBindingFromPool("Prefabs/publicPrefabs/itemAll", self.go)
        end
        name = Tool.getNameColor(data.star or data.color or 1) .. data.name .. "[-]"
        self.item_kuangzi.gameObject:SetActive(false)
        infobinding:CallUpdate({ "char", data, self.item_kuangzi.width, self.item_kuangzi.height, true, nil, true })
        if data.showName ~= nil then
            if self.name then
                self.name.text = name
            end
        end
    end
end

return saodangItemAcce