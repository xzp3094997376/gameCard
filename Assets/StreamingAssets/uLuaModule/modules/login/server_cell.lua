--
-- Created by IntelliJ IDEA.
-- User: xiyou
-- Date: 2014/11/12
-- Time: 13:43
-- To change this template use File | Settings | File Templates.
-- 服务器

local m = {}

function m:update(server, index)
    self.delegate = server.delegate
    self.server = server
    if server then
        self.txt_number.text = server.number
        self.txt_status.text = server.status
        self.txt_name.text = server.name
    end
end

function m:onClick(go, name)
    if self.delegate and self.delegate.onSelect then
        self.delegate:onSelect(self.server)
    end
end

-- function m:create()
--     return self
-- end

return m

