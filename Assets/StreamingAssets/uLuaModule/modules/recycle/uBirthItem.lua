local item = {}
local isChoose = false
local num = 1
function item:update(lua)
    self.index = lua.index --表示第几个
    self.char = lua.char
    self.delegate = lua.delegate
    self:updateChar()
    self:updateSelect(lua.char.isChoose)
end

function item:updateChar()
    local char = self.char
    self.labName.text = char:getDisplayName()
    if self.char:getType() == "treasure" then 
        self.pic:setImage(char:getHeadSpriteName(), "equipImage") --头像
    else 
        self.pic:setImage(char:getHeadSpriteName(), "headImage") --头像
    end 
    self.Sprite_kuang.spriteName = char:getFrameBG()
    self.img_frame.spriteName = char:getFrame() --图像看颜色
    self.txt_lv.text =TextMap.GetValue("Text_1_306") .. char.lv
end

function item:updateSelect(flag)
    isChoose = flag
    self.selected:SetActive(flag)
end

function item:saveChar(go, char)
    self.delegate:setChar(char)
end

function item:onClick(go, name)
    if self.delegate:getCharId() == nil or self.delegate:getCharId() == self.char.id then
        if name == "btn_select" and isChoose then
            self.selected:SetActive(false)
            self.char.isChoose = false
            self:saveChar(go)
            isChoose = false
        elseif name == "btn_select" and isChoose == false then      
            self.selected:SetActive(true)
            self.char.isChoose = true
            self:saveChar(go, self.char)
            isChoose = true
        end
    elseif self.delegate:getCharId() ~= nil then
        MessageMrg.show(TextMap.GetValue("Text1375"))
        return false
    end
end

return item