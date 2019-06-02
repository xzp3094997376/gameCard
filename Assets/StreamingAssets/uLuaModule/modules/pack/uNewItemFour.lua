--
-- Created by IntelliJ IDEA.
-- User: xiyou
-- Date: 2014/11/30
-- Time: 14:53
-- To change this template use File | Settings | File Templates.
--

local m = {}

function m:update(data, index, delegate)
    self.packGrid:refresh("Prefabs/moduleFabs/packModule/newpackitem", data, delegate, 5)
end

function m:create()
    return self
end

return m

