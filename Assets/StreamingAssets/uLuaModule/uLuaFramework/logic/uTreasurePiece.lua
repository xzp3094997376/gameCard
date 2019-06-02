--
-- Created by IntelliJ IDEA.
-- User: jixinpeng
-- Date: 2015/11/16
-- Time: 17:50
-- To change this template use File | Settings | File Templates.
--
--宝物碎片
local M = {}
function M:getType()
    return self.Table.type
end

function M:getHead()
    if (self._head) then return self._head end
    local img = self.Table.iconid
    if (img == "" or img == nil) then img = "default" end
    self._head = UrlManager.GetImagesPath("guidao/" .. img .. ".png")
    return self._head
end


function M:getHeadSpriteName()
    local img = self.Table.iconid
    if (img == "" or img == nil) then img = "default" end
    return img
end

function M:getSuiPianFrame()
    local star = self.star
    local icon = "item_white_frame"
    if star == 2 then
        icon = "item_green_frame"
    elseif star == 3 then
        icon = "item_blue_frame"
    elseif star == 4 then
        icon = "item_zi_frame"
    elseif star == 5 then
        icon = "item_yellow_frame"
    elseif star == 6 then
        icon = "item_red_frame"
    end
    return icon
end

--颜色
function M:getColor()
    local color = Tool.getItemColor(self.Table.color)
    return color
end

--ui中显示的名字，带进阶等级
function M:getDisplayName()
    return self.name
end

--ui中显示角色名字，带颜色
function M:getDisplayColorName()
    return Tool.getNameColor(self.star) .. self.name
end

function M:updateInfo()
    if Player.treasurePieceBagIndex == nil then return end
    local pieces = Player.treasurePieceBagIndex[self.id]
    if pieces ~= nil then
        self.info = pieces
        self.count = pieces.count
    else
        self.info = nil
        self.count = 0
    end
end

--外框
function M:getFrame()
    local star = self.star
    return Tool.getFrame(star)
end

function M:getFrameNormal()
    local star = self.star
    local icon = "guidao1"
    if star == 2 then
        icon = "guidao1"
    elseif star == 3 then
        icon = "guidao2"
    elseif star == 4 then
        icon = "guidao3"
    elseif star == 5 then
        icon = "guidao4"
    elseif star == 6 then
        icon = "guidao5"
    end
    return icon
end

--外框
function M:getFrameBig()
    local star = self.star
    local icon = "ji_xian1"
    if star == 2 then
        icon = "ji_xian1"
    elseif star == 3 then
        icon = "ji_xian2"
    elseif star == 4 then
        icon = "ji_xian3"
    elseif star == 5 then
        icon = "ji_xian4"
    elseif star == 6 then
        icon = "ji_xian5"
    end
    return icon
end

function M:getFrameBG()
    local star = self.star
    return Tool.getBg(star)
end

function M:init(id, count)
    self.Table = TableReader:TableRowByID("treasurePiece", id);
    if self.Table == nil then
        self.Table = TableReader:TableRowByUnique("treasurePiece", "name", id)
    end

    self.name = self.Table.show_name
    self.id = self.Table.id
    local temp = self.Table.treasureId
    self.star = TableReader:TableRowByUnique("treasure", "id", temp).star
    self.desc = self.Table.desc
    self.color = self.Table.color
    self.count = count or 0
    self.kind = self.Table.kind

    self:updateInfo()
end

function M:new(id, count)
    local o = {}
    setmetatable(o, self)
    self.__index = self
    o:init(id, count)
    return o
end

return M


