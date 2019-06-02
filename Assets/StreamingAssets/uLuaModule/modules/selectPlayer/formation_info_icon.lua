--
-- Created by IntelliJ IDEA.
-- User: jixinpeng
-- Date: 2015/7/6
-- Time: 16:42
-- To change this template use File | Settings | File Templates.
--

local m = {}

function m:update(lua)
end

--设置每个羁绊的信息
function m:setText(text1, text2)
    self.txt_name.text = text1
    self.txt_desc.text = text2
end

function m:Start()
end

return m