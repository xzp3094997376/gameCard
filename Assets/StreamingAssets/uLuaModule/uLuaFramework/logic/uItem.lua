--道具
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

--ui中显示的名字，带进阶等级
function M:getDisplayName()
    return self.name
end

--ui中显示角色名字，带颜色
function M:getDisplayColorName()
    local color = self:getColor()
    return color.color .. self.name .."[-]"
end

function M:updateInfo()
    self.count = Player.ItemBagIndex[self.id].count
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

function M:init(id, count)
    self.Table = TableReader:TableRowByID("item", id);
    if self.Table == nil then
        self.Table = TableReader:TableRowByUnique("item", "name", id)
    end
	if self.Table == nil then 
		Debug.LogError(TextMap.GetValue("Text_1_2902") .. id);
	end 
    local bag = Player.ItemBagIndex
    self.name = self.Table.show_name
    self.id = self.Table.id
    self.Info = bag[self.id]
    self.desc = self.Table.desc
    self.color = self.Table.color
    self.star=self.color
    self.count = count or 0
    self.typeIndex = 2
    if (count == nil and self.Info ~= nil) then
        self.count = self.Info.count
    end
end

function M:new(id, count)
    local o = {}
    setmetatable(o, self)
    self.__index = self
    o:init(id, count)
    return o
end

return M