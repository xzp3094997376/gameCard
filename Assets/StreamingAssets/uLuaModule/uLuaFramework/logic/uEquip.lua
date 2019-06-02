--装备
local equip = {}
EquipComposeList = {}
ReelComposeList = {}

ITEM_STATE = {
    wear = 1, --已穿
    no = 2, --没有装备，不可合成
    can = 3, --有装备，可以装备
    en = 4, -- 有碎片，可合成
    cant = 5, --等级不足
    en_cant = 6 --有
}

function CheckCanCompose(type, id, arg)
    local ret = false
    if type == "equip" then
        local eq = EquipComposeList[id]
        if not eq then
            eq = {}
            local row = TableReader:TableRowByID(type, id)
            local consume = row.consume
            local count = consume.Count
            for i = 0, count - 1 do
                local item = consume[i]
                local type = item.consume_type
                local arg = item.consume_arg
                local arg2 = item.consume_arg2
                if type ~= "money" then
                    if count > 0 then
                        table.insert(eq, {
                            type = type,
                            id = arg,
                            arg = arg2
                        })
                    end
                end
            end

            EquipComposeList[id] = eq
        end
        local count = Player.EquipmentBagIndex[id].count
        ret = count >= arg
        if ret or table.getn(eq) == 0 then return ret end
        table.foreachi(eq, function(o, v)
            ret = CheckCanCompose(v.type, v.id, v.arg)
            if not ret then return ret end
        end)
    elseif type == "reel" then
        local reel = ReelComposeList[id]
        if not reel then
            reel = {}
            local row = TableReader:TableRowByID(type, id)
            local consume = row.consume
            local count = consume.Count
            for i = 0, count - 1 do
                local item = consume[i]
                local type = item.consume_type
                local arg = item.consume_arg
                local arg2 = item.consume_arg2
                if type ~= "money" then
                    if count > 0 then
                        table.insert(eq, {
                            type = type,
                            id = arg,
                            arg = arg2
                        })
                    end
                end
            end

            ReelComposeList[id] = reel
        end
        local count = Player.ReelBagIndex[id].count
        ret = count >= arg
        if ret or table.getn(reel) == 0 then return ret end

        table.foreachi(ereelq, function(o, v)
            ret = CheckCanCompose(v.type, v.id, v.arg)
            if not ret then return ret end
        end)
    elseif type == "equipPiece" then
        local count = Player.EquipmentPieceBagIndex[id].count
        ret = count >= arg
    elseif type == "reelPiece" then
        local count = Player.ReelPieceBagIndex[id].count
        ret = count >= arg
    end
    return ret
end

local EquipAttrColor = "[00ff00]" --装备附魔颜色
function equip:getType()
    return self.Table.type
end

--外框颜色
function equip:getColor()
    local color = Tool.getItemColor(self.Table.color)
    return color
end

--ui中显示角色名字，带颜色
function equip:getDisplayColorName()
    return Tool.getItemColor(self.Table.color).color .. self.name
end

--ui中显示的名字，带进阶等级
function equip:getDisplayName()
    return self.name
end

--外框
function equip:getFrame()
    local color = self:getColor()
    return color.icon
end

function equip:getFrameBG()
    local color = self:getColor()
    return color.icon_bg
end

--小头像图标
function equip:getHead()
    if (self._head) then return self._head end
    local img = self.Table.iconid
    if (img == "" or img == nil) then img = "default" end
    self._head = UrlManager.GetImagesPath("equipImage/" .. img .. ".png")
    return self._head
end

--获取头像贴图名字
function equip:getHeadSpriteName()
    --    if (self._head) then return self._head end
    local img = self.Table.iconid
    if (img == "" or img == nil) then img = "default" end
    return img
end

--判断是否可以被合成
function equip:canCompose()
    local ret = CheckCanCompose(self:getType(), self.id, 1)
    return ret
end

--这个装备已被角色char穿带
--角色穿该装备的位置
function equip:setChar(char, index)
    self.char = char
    self.index = index
    self:updateInfo()
end

--获取装备的穿带者
function equip:getChar()
    return self.char
end



--从哪个角色查看装备
function equip:forChar(char)
    self._forChar = char
end

--装备状态
function equip:getState(char)
    char = char or self._forChar
    if self.char ~= nil then
        return ITEM_STATE.wear
    elseif self.lv > char.lv then
        --等级不足
        return ITEM_STATE.cant
    elseif self.count == 0 or self.count == nil then
        --没有装备，判断是否有碎片可合成
        --TODO
        local ret = self:canCompose()
        if ret then
            if char.lv >= self.lv then
                return ITEM_STATE.en
            else
                --可合成等级不足
                return ITEM_STATE.en_cant
            end
        end
        return ITEM_STATE.no
    elseif char ~= nil then
        --角色等级小于等于装备需求等级，可以装备
        return ITEM_STATE.can
    else
        return ITEM_STATE.no
    end
end

function equip:getDescList()
    local list = {}
    local magics = self.Table.magic
    for i = 0, magics.Count - 1 do
        local magic = magics[i]
        local _num = magic.magic_arg1 / magic._magic_effect.denominator
        if _num ~= 0 then
            if _num % 1 == 0 then math.floor(_num) end
            _num = "+" .. _num
            _num = string.gsub(magic._magic_effect.format, "{0}", _num)
            table.insert(list, _num)
        end
    end
    return list
end

--装备属性
function equip:getAttrDesc()
    local info = self.info
    local char = self:getChar()
    local function getAddNum(num, level)
        local n = math.floor(num * level)
        if n > 0 then return "[1ada00] +" .. n .. "[-]" end
        return ""
    end

    if char ~= nil and self.level > 0 then
        --穿在角色身上。带附魔信息
        local _desc = ""
        local magics = self.Table.magic
        for i = 0, magics.Count - 1 do
            local magic = magics[i]
            local gn = getAddNum(magic.magic_arg2, self.level)
            local _num = math.floor(magic.magic_arg1 / magic._magic_effect.denominator)
            if _num ~= 0 then
                _num = _num .. gn
                if gn == "" then _num = "+" .. _num end
                local dc = string.gsub(magic._magic_effect.format, "{0}", _num) .. "\n"
                _desc = _desc .. dc
            end
        end
        __desc = string.sub(_desc, 1, -2)
        return __desc
    end
    --基本属性
    if (self._desc) then return self._desc end
    local _desc = ""
    local magics = self.Table.magic
    for i = 0, magics.Count - 1 do
        local magic = magics[i]
        local _num = magic.magic_arg1 / magic._magic_effect.denominator
        if _num ~= 0 then
            if _num % 1 == 0 then math.floor(_num) end
            _num = "+" .. _num
            _desc = _desc .. string.gsub(magic._magic_effect.format, "{0}", _num) .. "\n"
        end
    end
    self._desc = string.sub(_desc, 1, -2) --去掉最后一个\n
    return self._desc
end

--更新装备信息
function equip:updateInfo()
    local equips = Player.EquipmentBagIndex
    local info = equips[self.id] --:getLuaTable()
    --    table.foreach(info,print)
    if info ~= nil then
        self.count = info.count
    else
        self.count = 0
    end
    if self.char then
        local eq = self.char.info.equip
        local e = eq[self.index]
        if e.id ~= nil then
            self.level = e.level
            self.exp = e.exp
        end
    end
end

--选择装备
function equip:isSelected(ret)
    if ret == nil then return self._selected end
    self._selected = ret
end

--合成要消耗的数量
function equip:setCostCount(count)
    self._costCount = count
end

--装备颜色表，存放装备强化信息
function equip:colorTable()
    if self._color then return self._color end
    self._color = TableReader:TableRowByID("equipSetting", self.Table.color)
    return self._color
end

--合成数量与当前数量
function equip:getCostDesc()
    return self.count .. "/" .. self._costCount
end

--最大强化等级
function equip:getMaxLevel()
    local color = self:colorTable()
    return color.max_level
end

--获得当前等级所需要的升级经验
function equip:getNeedExp(lv)
    local color = self:colorTable()
    local lv = math.min(self:getMaxLevel(), lv or (self.level + 1))
    local lv = math.max(1, lv)
    return color["level" .. lv .. "_exp"]
end

function equip:getCostNum()
    local color = self:colorTable()
    return color.money_cost_num
end

--初始化
function equip:init(id, info)
    self.Table = TableReader:TableRowByID("equip", id);
    if self.Table == nil then
        self.Table = TableReader:TableRowByUnique("equip", "name", id)
    end
    if not self.Table then
        --     print("readTable err equip" .. id)
        return
    end
    self.color = self.Table.color

    self.level = 0
    self.exp = 0
    self.exp = self.Table.exp

    self.id = self.Table.id
    self._costCount = 1
    self:updateInfo()
    self.name = self.Table.show_name
    self.lv = self.Table.lowest_level
    self.desc = self.Table.desc
end

function equip:new(id, info)
    local o = {}
    setmetatable(o, self)
    self.__index = self
    o:init(id, info)
    return o
end



return equip