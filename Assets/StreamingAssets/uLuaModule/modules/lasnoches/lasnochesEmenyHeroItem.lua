local lasnochesEmemyitem = {}

function lasnochesEmemyitem:update(peppleData)
    self.frame.gameObject:SetActive(false)
    if peppleData ~= nil then
        self.Sprite:SetActive(false)
        self.width = peppleData.hp / peppleData.maxhp * 85
        local infobinding = ClientTool.loadAndGetLuaBindingFromPool("Prefabs/publicPrefabs/itemAll", self.myPeople)
        infobinding:CallUpdate({ "char", peppleData, self.frame.width, self.frame.height })
        if peppleData.dead then
            BlackGo.setBlack(0.5, self.myPeople.transform)
        end
    else
        self.Sprite:SetActive(true)
    end
end

--初始化
function lasnochesEmemyitem:create(binding)
    self.binding = binding
    return self
end

return lasnochesEmemyitem