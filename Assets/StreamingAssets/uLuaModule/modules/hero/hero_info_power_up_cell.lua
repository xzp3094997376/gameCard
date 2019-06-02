--
-- Created by IntelliJ IDEA.
-- User: xiyou
-- Date: 2015/3/3
-- Time: 14:38
-- To change this template use File | Settings | File Templates.
-- 突破

local m = {}

function m:update(equips, index)
    self.xibie.spriteName = "xibie_" .. (index + 2)
    if self.binds == nil then
        self.binds = {}
        local tran = self.equips.transform
        for i = 0, tran.childCount - 1 do
            local go = tran:GetChild(i).gameObject
            local bind = ClientTool.loadAndGetLuaBindingFromPool("Prefabs/publicPrefabs/itemAll", go)
            bind.gameObject:SetActive(true)
            self.binds[i + 1] = bind
        end
    end
    for i = 1, 6 do
        local bind = self.binds[i]
        bind:CallUpdate({ "char", equips[i], 70, 70, true, nil, true })
    end
end

return m

