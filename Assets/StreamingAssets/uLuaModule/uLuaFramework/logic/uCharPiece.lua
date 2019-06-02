--灵魂石
local M = {}



--类型
function M:getType()
    return self.Table.type
end


local StarToNeedPiece = {}



--进化star星所需的灵魂石
function M:maxPiece(star)
    if funcs.empty(StarToNeedPiece) then
        for i = 1, Tool.GetCharArgs("max_power_Leader") do
            StarToNeedPiece[i] = Tool.GetCharArgs("star_" .. i .. "_need_charPiece")
        end
    end
    if star == nil then
        return self.needCharNumber
    else
        return 0
    end
    star = math.max(star, 1)
    star = math.min(star + 1, Tool.GetCharArgs("max_power_Leader"))
    local max = StarToNeedPiece[star]
    return max
end


--显示灵子
function M:pieceInfo(star)
    self:updateInfo()
    local max = M.maxPiece(self, star)
    local cur = self.count

    local value = cur / max
    value = math.max(0, value)
    value = math.min(1, value)
    local lv = 100
    star = star or 0
    if star < Tool.GetCharArgs("max_power_Leader") then
        lv = Tool.GetCharArgs("star_" .. star + 1 .. "_need_level")
    end
    return
    {
        desc = cur .. "/" .. max,
        value = value,
        need = lv,
        max = Tool.GetCharArgs("max_power_Leader")
    }
end

--头像
function M:getHead()
    if (self._head) then return self._head end
    local img = self.Table.iconid
    if (img == "" or img == nil) then img = "default" end
    self._head = UrlManager.GetImagesPath("headImage/" .. img .. ".png")
    return self._head
end

--获取头像贴图名字
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

--外框颜色
function M:getColor()
    local color = Tool.getCharColor(0)
    return color
end

--ui中显示角色名字，带进阶等级
function M:getDisplayName()
    return self.Table.name
end

--ui中显示角色名字，带颜色
function M:getDisplayColorName()
    -- print(self.star)
    -- print(self.Table.name)
    -- print(self.star)
    -- print(Tool.getItemColor(self.star))
    -- return Tool.getItemColor(self.star or 0).color .. self.Table.name
    return Tool.getItemColor(self.star or 0).color .. self.name
end

--外框
function M:getFrame()
    local star = self.star
    return Tool.getFrame(star)
end

function M:getFrameBG()
    local star = self.star
    return Tool.getBg(star)
end

--角色图片
function M:getImage()
    if (self._img) then return self._img end
    local tb = self._charTable
    local img = tb._model_id.full_img_d
    if (img == "" or img == nil) then img = "default" end
    self._img = UrlManager.GetImagesPath("cardImage/" .. img .. ".png")
    return self._img
end
function M:getDingWei()
    local type = self._charTable.party
    if type == 1 then
        return "zhenying_shan"
    elseif type == 2 then
        return "zhenying_e"
    elseif type == 3 then
        return "zhenying_ying"
    else
        return ""
    end
end
function M:getDingWei2()
    local dw = self._charTable.char_dingwei
    if dw == TextMap.GetValue("Text_1_2888") then
        return "dw_adatk"
    elseif dw == TextMap.GetValue("Text_1_2889") then
        return "dw_mpatk"
    elseif dw == TextMap.GetValue("Text_1_2890") or dw == TextMap.GetValue("Text_1_2891") or dw == TextMap.GetValue("Text_1_2892") then

        return "dw_def"
    elseif dw == TextMap.GetValue("Text_1_2893") then
        return "dw_huifu"
    elseif dw == TextMap.GetValue("Text_1_2894") then
        return "dw_zuzhou"
    end
end

function M:updateInfo()
    local pieces = Player.CharPieceBagIndex[self.id]
    self.info = pieces
	if pieces ~= nil then
		self.count = pieces.count
	end
end

function M:getStar()
    return self.Table.star
end

function M:init(id, info)
    self.Table = TableReader:TableRowByID("charPiece", id);
    if self.Table == nil then
        self.Table = TableReader:TableRowByUnique("charPiece", "name", id)
    end
    if self.Table == nil then
        --     print("readTable err equipPiece" .. id)
        return
    end
    self.typeIndex = 3;

    self.id = self.Table.id
    local drop=self.Table.drop
    if drop~=nil and drop.Count > 0 and drop[0].type=="char" then 
        self._charTable = TableReader:TableRowByID("char", drop[0].arg)
    end
    if self._charTable == nil then
        self._charTable = TableReader:TableRowByID("charPiece", self.id)
    end
    self.star = self.Table.star
    self.desc = self.Table.desc
    if self.Table.consume.Count > 0 then
        self.needCharNumber = self.Table.consume[0].consume_arg2
    else
        self.needCharNumber = 0
    end
    self:updateInfo()
    self.teamIndex = 7
    self.name = self.Table.show_name
    self.power = 0
    self.itemColorName = Char:getItemColorName(self.star, self.name)
end

function M:new(id, info)
    local o = {}
    setmetatable(o, self)
    self.__index = self
    o:init(id, info)
    return o
end

return M