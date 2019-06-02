--
-- Created by IntelliJ IDEA.
-- User: xiyou
-- Date: 2015/3/3
-- Time: 9:58
-- To change this template use File | Settings | File Templates.
-- 突破装备

local hero_powerup = {}

function hero_powerup:update(lua)
    local nChar = lua.nChar
    local list = {}
    for i = 1, 11 do
        local tb = TableReader:TableRowByUniqueKey("powerUp", nChar.Table.powUpId, i)
        if tb == nil then
            return
        end
        local equip_id = tb.equipid

        local len = equip_id.Count
        local equipsList = {}

        for i = 1, len do
            local id = equip_id[i - 1]
            local equip = Equip:new(id)
            equipsList[i] = equip
        end
        table.insert(list, equipsList)
    end
    self.scrollView:refresh(list, self, true, 0)
end

return hero_powerup

