--卷轴
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


function M:getFrameBG()
    local color = self:getColor()
    return color.icon_bg
end

--ui中显示的名字，带进阶等级
function M:getDisplayName()
    return self.name
end

--ui中显示的名字，带进阶等级
function M:getDisplayColorName()
    return  Tool.getItemColor(self.Table.color) .. self.name
end

--外框
function M:getFrame()
    local color = self:getColor()
    return color.icon
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
    self.info = Player.ReelBagIndex[self.id]
    self.count = self.info.count
end

function M:isSelected(ret)
    if ret == nil then return self._selected end
    self._selected = ret
end


function M:init(id, info)
    self.Table = TableReader:TableRowByID("reel", id);
    if self.Table == nil then
        self.Table = TableReader:TableRowByUnique("reel", "name", id)
    end
    if self.Table == nil then
        --    print("readTable err reel" .. id)
        return
    end
    self.color = self.Table.color
    self.exp = self.Table.exp
    self.id = self.Table.id
    self:updateInfo()
    self.desc = self.Table.desc
    self.name = self.Table.name
end

function M:new(id, info)
    local o = {}
    setmetatable(o, self)
    self.__index = self
    o:init(id, info)
    return o
end

return M