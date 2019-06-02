--
-- Created by IntelliJ IDEA.
-- User: jixinpeng
-- Date: 2015/8/20
-- Time: 13:43
-- To change this template use File | Settings | File Templates.
-- 推荐服务器

local m = {}

function m:update(lua)
    self.delegate = lua.delegate
    self.servers = lua.servers
    if self.servers then
        for i = 1, 4 do
            if self.servers[i] ~= nil then
                self["cell" .. i].gameObject:SetActive(true)
                self["cell" .. i]:CallUpdate({ server = self.servers[i], delegate = self.delegate })
            else
                self["cell" .. i].gameObject:SetActive(false)
            end
        end
    end
end

return m

