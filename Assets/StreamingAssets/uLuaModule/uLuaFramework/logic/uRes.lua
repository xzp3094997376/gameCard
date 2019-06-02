--
-- Created by IntelliJ IDEA.
-- User: xiyou
-- Date: 2014/11/5
-- Time: 16:34
-- To change this template use File | Settings | File Templates.
-- 基本货币

local M = {}
function M:getType()
    return self.id
end

function M:getHead()
    if (self._head) then return self._head end
    if self.Table == nil then return "" end
    local img = self.Table.img
    if (img == "" or img == nil) then img = "default" end
    self._head = UrlManager.GetImagesPath("itemImage/" .. img .. ".png")
    return self._head
end

--获取头像贴图名字
function M:getHeadSpriteName()
    if (self._head) then return self._head end
    if self.Table == nil then return "" end
    local img = self.Table.img
    if (img == "" or img == nil) then img = "default" end
    return img
end

--颜色
--return { icon = "",color = "" }
function M:getColor()
    local color = Tool.getItemColor(self.star)
    return color
end

--ui中显示的名字，带进阶等级
function M:getDisplayName()
    return self.cnName
end

--ui中显示的名字，带进阶等级
function M:getDisplayColorName()
    return Tool.getNameColor(self.star) .. self.name .. "[-]"
end

--外框
function M:getFrame()
    local color = self:getColor()
    return color.icon
end

function M:updateInfo()
    self.count = Tool.getCountByType(self:getType())
end

function M:getFrameBG()
    local color = self:getColor()
    return color.icon_bg
end

--初始化
function M:init(key, num)
    self.typeIndex = 1
    self.count = 0
    if key == "vstime" then
        self.cnName = TextMap.GetValue("Text1484")
        self.name = self.cnName
        self.rwCount = num
        self.id = key
        return
    end
    if key == "herotime" then
        self.cnName = TextMap.GetValue("Text1485")
        self.name = self.cnName
        self.rwCount = num
        self.id = key
        return
    end
    self.Table = TableReader:TableRowByUnique("resourceDefine", "name", key);
    if self.Table == nil then
        print("readTable err resourceDefine " .. key)
        return
    end
    self.cnName = self.Table.cnName
    self.name = self.Table.cnName
    self.rwCount = num
    self.id = self.Table.name
    if key=="gold" then
        self.star=5
    else 
        self.star=1
    end 
    self:updateInfo()
end

function M:new(id, info)
    local o = {}
    setmetatable(o, self)
    self.__index = self
    o:init(id, info)
    return o
end

return M

