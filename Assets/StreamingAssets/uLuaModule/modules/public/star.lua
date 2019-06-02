--
-- Created by IntelliJ IDEA.
-- User: xiyou
-- Date: 2014/10/20
-- Time: 9:36
-- To change this template use File | Settings | File Templates.
--

local star = {}

function star:update(ret)
    self.img_star:SetActive(ret)
end

function star:create()
    return self
end

return star