--忍灵
local M = {}
function M:getType()
    return "renling"
end

function M:getHead()
    if (self._head) then return self._head end
    local img = self.Table.icon
    if (img == "" or img == nil) then img = "default" end
    self._head = UrlManager.GetImagesPath("headImage/" .. img .. ".png")
    return self._head
end

function M:getHeadSpriteName()
    local img = self.Table.icon
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

--ui中显示的名字，带进阶等级
function M:getDisplayColorName()
    return  Tool.getItemColor(self.star).color .. self.name .. "[-]"
end

function M:getDisplayName()
    return  Tool.getItemColor(self.star).color .. self.name .. "[-]"
end

function M:getFrameBG()
    local color = self:getColor()
    return color.icon_bg
end

--外框
function M:getFrame()
    return "lingkuang_" .. self.Table.star
    -- local color = self:getColor()
    -- return color.icon
end


function M:updateInfo()
    self.info = Player.renlingBag[self.id]
    self.count = self.info.count
end



--初始化
function M:init(id, info)
    self.Table = TableReader:TableRowByID("renling", id);
    if self.Table == nil then
        self.Table = TableReader:TableRowByUnique("renling", "name", id)
    end
    if self.Table == nil then
        print("readTable err renling" .. id)
        return
    end
    self.star = self.Table.star
    self.id = self.Table.id
    self:updateInfo()
    self.desc = self.Table.desc
    --self.name = self.Table.name
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