--
-- Created by IntelliJ IDEA.
-- User: xiyou
-- Date: 2014/12/24
-- Time: 18:30
-- To change this template use File | Settings | File Templates.
--

local m = {}

function m:update(lua)
    local char = lua.char
    self.delegate = lua.delegate
    -- self.char = char
    self:transform(char)
end

function m:getImg(ret)
    if ret and self.char.stage < Tool.GetCharArgs("unlock_trans_level") then
        ret = false
    end
    return self.char:getImage(ret)
end

function m:setImg(url)
    -- if url == self.url then return end
    self.url = url
    self.imgHero.Url = url
    --    print(url)
end

function m:transform(char)
    if self.delegate == nil then return end
    if char.teamIndex < 7 then
        self.binding:Show("txt_pos")
        self.txt_pos.text = char.teamIndex .. ""
    else
        self.binding:Hide("txt_pos")
    end
    local ret = self.delegate.isChange
    self.char = char
    local url = self:getImg(ret)
    self:setImg(url)
end

return m