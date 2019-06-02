--
-- Created by IntelliJ IDEA.
-- User: xiyou
-- Date: 2015/3/22
-- Time: 11:43
-- To change this template use File | Settings | File Templates.
-- 魂炼翻页
local m = {}


function m:update(data)
    self.frame.spriteName = data:getFrameBig()
    m:setIcon(data, self.icon)
    self.txt_attr.text = data:getMainAttr()
    self.data = data
end

function m:setIcon(item, icon)
    local name = item:getHeadSpriteName()
    local atlasName = packTool:getIconByName(name)
    icon:setImage(name, atlasName)
end

function m:onUpdate(char)
    m:setIcon(char, self.icon)
    self.txt_attr.text = char:getMainAttr()
end

function m:onClick()
    UIMrg:pushWindow("Prefabs/moduleFabs/guidao/guidao_desc", self.data)
end

return m

