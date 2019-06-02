--装备
local M = {}

function M:getType()
    return self.Table.type
end

function M:getHead()
    if (self._head) then return self._head end
    local img = self.Table.iconid
    if (img == "" or img == nil) then img = "default" end
    self._head = UrlManager.GetImagesPath("itemImage/" .. img .. ".png")
    return self._head
end


--获取头像贴图名字
function M:getHeadSpriteName()
    local img = self.Table.iconid
    if (img == "" or img == nil) then img = "default" end
    return img
end

--颜色
--return { icon = "",color = "" }
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
    return Tool.getItemColor(self.Table.color).color .. self.name
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
--外框
function M:getFrame()
    local color = self:getColor()
    return color.icon
end

function M:getFrameBG()
    local color = self:getColor()
    return color.icon_bg
end


--合成要消耗的数量
function M:setCostCount(count)
    self._costCount = count
end

--合成数量与当前数量
function M:getCostDesc()
    return self.count .. "/" .. self._costCount
end

function M:updateInfo()
    self.info = Player.EquipmentPieceBagIndex[self.id]
    self.count = self.info.count
end

function M:isSelected(ret)
    if ret == nil then return self._selected end
    self._selected = ret
end


--初始化
function M:init(id, info)
    self.Table = TableReader:TableRowByID("equipPiece", id);
    if self.Table == nil then
        self.Table = TableReader:TableRowByUnique("equipPiece", "name", id)
    end
    if self.Table == nil then
        print("readTable err equipPiece" .. id)
        return
    end
    self.id = self.Table.id
    self.color = self.Table.color
    self.exp = self.Table.exp

    self._costCount = 1
    self:updateInfo()
    self.desc = self.Table.desc
    self.name = self.Table.show_name
end

function M:new(id, info)
    local o = {}
    setmetatable(o, self)
    self.__index = self
    o:init(id, info)
    return o
end

return M