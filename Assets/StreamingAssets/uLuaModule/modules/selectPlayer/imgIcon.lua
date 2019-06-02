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

--更新texture
function m:updateTexture(data)
    if data == nil then return end
    if data.path == "" then
        self.shader:SetActive(true)
        -- self.texture.gameObject:SetActive(false)
        -- self.name.text = "该阵位无上阵"
        -- self.count.text = "已激活羁绊：0"
    else
        -- self.texture.gameObject:SetActive(true)
        self.shader:SetActive(false)
        self.texture:LoadByModelId(data.modelid, "idle", function() end, false, 0, 1)
        self.name.text =Tool.getNameColor(data.star) .. data.name
        --self.count.text = TextMap.GetValue("Text1396") .. data.count
        self.count.text =Tool.getNameColor(2) .. TextMap.GetValue("Text_1_1067") .. data.count 
        --local tb = self:getFrameName(data.star)
        --self.Sprite.spriteName = tb.icon
        --self.name_sprite.spriteName = tb.bg
    end
    -- body
end

--根据star获取外框名字
function m:getFrameName(star)
    -- local star = self.star
    local icon = "fetter_green01"
    local bg = "fetter_green02"
    if star == 2 then
        icon = "fetter_green01"
        bg = "fetter_green02"
    elseif star == 3 then
        icon = "fetter_blue01"
        bg = "fetter_blue02"
    elseif star == 4 then
        icon = "fetter_purple01"
        bg = "fetter_purple02"
    elseif star == 5 then
        icon = "fetter_orange01"
        bg = "fetter_orange02"
    elseif star == 6 then
        icon = "fetter_red01"
        bg = "fetter_red02"
    end
    local tb = { icon = icon, bg = bg }
    return tb
end

function m:Start()
    -- local that = self
    -- ClientTool.AddClick(self.item_drop, function()
    --     that:onSelect()
    -- end)
    -- self.binding:Hide("txt_info")
    -- self.drop_hero = self.item_drop:GetComponent("DragHero")
end

return m