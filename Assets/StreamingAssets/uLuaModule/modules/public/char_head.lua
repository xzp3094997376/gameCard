--
-- Created by IntelliJ IDEA.
-- User: xiyou
-- Date: 2014/11/1
-- Time: 10:55
-- To change this template use File | Settings | File Templates.
-- 角色头像

local char_head = {}

function char_head:update(char)
    self.pic.Url = char:getHead()
    self.img_frame.spriteName = char:getFrame() --外框颜色

    self.lv_bg.spriteName = char:getLvFrame()
    local stars = {}
    for i = 1, 5 do
        stars[i] = i <= char.star
    end
    --    星级
    ClientTool.UpdateGrid("", self.star, stars)
    self.txt_lv.text = char.lv
    if self.img_shengjie then
        self.img_shengjie.spriteName = char:getStarFrame()
    end
end


function char_head:create()
    return self
end

return char_head

