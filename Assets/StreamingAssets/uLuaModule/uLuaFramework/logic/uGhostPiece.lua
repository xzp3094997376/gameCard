--
--鬼道
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

--颜色
--return { icon = "",color = "" }
function M:getColor()
    local color = Tool.getItemColor(self.Table.star)
    return color
end

--ui中显示的名字，带进阶等级
function M:getDisplayName()
    return self.name
end

--ui中显示角色名字，带颜色
function M:getDisplayColorName()
    return Tool.getItemColor(self.Table.star).color .. self.name .. "[-]"
end

function M:updateInfo()
    local pieces = Player.GhostPieceBagIndex[self.id]
    self.info = pieces
    self.count = pieces.count
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
    self.Table = TableReader:TableRowByID("ghostPiece", id);
    if self.Table == nil then
        self.Table = TableReader:TableRowByUnique("ghostPiece", "name", id)
    end

    --    local bag = Player.ItemBagIndex
    self.name = self.Table.show_name
    self.id = self.Table.id
    self.star = self.Table.star

    if self.Table.consume.Count > 0 then
        self.needCharNumber = self.Table.consume[0].consume_arg2
    else
        self.needCharNumber = 0
    end
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


