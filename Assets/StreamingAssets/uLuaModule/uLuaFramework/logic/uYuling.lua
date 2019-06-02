local m = {}

local AttrNewDescList = 
{
    "MaxHp", --生命
    "PhyAtk", --物理攻击
    "PhyDef", --物理防御
    "MagDef"  --法术防御
}

local AttFactor = {
    "MaxHpFactor", --生命资质
    "PhyAtkFactor", --攻击资质
    "PhyDefFactor", --物防资质
    "MagDefFactor" --法防资质
}

function m:getType()
    return "yuling"
end

--角色小头像
function m:getHead()
    if (self._head) then return self._head end
    local img = self.modelTable.head_img

    if (img == "" or img == nil) then img = "default" end

    self._head = UrlManager.GetImagesPath("headImage/" .. img .. ".png")
    return self._head
end

--获取头像贴图名字
function m:getHeadSpriteName()
    local img = self.modelTable.head_img
    if (img == "" or img == nil) then img = "default" end
    return img
end

--ui中显示角色名字，带进阶等级
function m:getDisplayName()
    local name = m:getItemColorName(self.star, self.name)
    return name 
end

--ui中显示角色名字，带进阶等级
function m:getDisplayColorName()
    local name ="" 
	name = m:getItemColorName(self.star,self.name)
    return name
end

--进阶颜色与外框
function m:getColor()
    local color = Tool.getCharColor(self.star)
    return color
end

function m:getItemColorName(color, names)
    local _names = names
	if color == 1 then
        _names = "[ffffff]" .. _names .. "[-]"
    elseif color == 2 then
        _names = "[00ff00]" .. _names .. "[-]"
    elseif color == 3 then
        _names = "[00b4ff]" .. _names .. "[-]"
    elseif color == 4 then
        _names = "[ff00ff]" .. _names .. "[-]"
    elseif color == 5 then
        _names = "[ff9600]" .. _names .. "[-]"
    elseif color == 6 then
        _names = "[ff0000]" .. _names .. "[-]"
    end 
    return _names
end


--外框
function m:getFrame()
    local star = self.star
    local icon = "kuang_baise"
    if star == 2 then
        icon = "kuang_lvse"
    elseif star == 3 then
        icon = "kuang_lanse"
    elseif star == 4 then
        icon = "kuang_zise"
    elseif star == 5 then
        icon = "kuang_chengse"
    elseif star == 6 then
        icon = "kuang_hongse"
    end
    return icon
end

--头像背景
function m:getFrameBG()
    local star = self.star
    local icon = "tubiao_1"
    if star == 2 then
        icon = "tubiao_2"
    elseif star == 3 then
        icon = "tubiao_3"
    elseif star == 4 then
        icon = "tubiao_4"
    elseif star == 5 then
        icon = "tubiao_5"
    elseif star == 6 then
        icon = "tubiao_6"
    end
    return icon
end

function m:updateInfo()
    local info =Player.yuling[self.id]
    self.info = info
    self.lv = info.level or 0 --等级
    self.star_level =info.star or 0 --星级
    self.power =math.ceil(info.power) or 0 --战力
    if info.quality>0 then 
        self.star=info.quality
    end 
    self.exp=info.exp or 0
end

function m:getLevelUpExp(lv)
    local row = TableReader:TableRowByUnique("yulingExp","lv",lv)
    if row then 
        return row["exp_" .. self.star]
    end 
    
    return -1, -1
end

function m:getAttrSingle(attr, isnum)
    if isnum then
        local row = TableReader:TableRowByUnique("magics", "name", attr)
        local arg1 = self.info.propertys[row.id]
        arg1 = arg1 / row.denominator
        arg1 = math.floor(arg1)
        return arg1, "[ffff96]".. row.format .. "[-]"
    else
        return self:GetAttrByYuling(attr)
    end
end

function m:GetAttrByYuling(attr)
    local row = TableReader:TableRowByUnique("magics", "name", attr)
    local arg1 = self.info.propertys[row.id]
    if arg1 == nil then 
        print("御灵属性表里没有: " .. attr .. " id = " .. row.id)
    end 
    arg1 = arg1 / row.denominator
    arg1 = math.floor(arg1)
    local desc = string.gsub("[ffff96]".. row.format .. "[-]", "{0}", "[ffffff]" .. arg1 .. "[-]")
    return arg1, desc
end

function m:GetAttrNew(attr, propertys,isGreen)
    local row = TableReader:TableRowByUnique("magics", "name", attr)
    if row == nil then return "" end
    local desc = ""
    local arg1 = 0
    if propertys.Count == nil then
        arg1 = propertys[row.id]
        arg1 = arg1 / row.denominator
        arg1 = math.floor(arg1)
        if isGreen~=nil and isGreen==true then 
            desc = string.gsub("[ffff96]" .. row.format .. "[-]", "{0}", "[24FC24]" .. arg1 .. "[-]")
        else 
            desc = string.gsub("[ffff96]" .. row.format .. "[-]", "{0}", "[ffffff]" .. arg1 .. "[-]")
        end 
    else
        if propertys.Count > row.id then
            arg1 = propertys[row.id]
            arg1 = math.floor(arg1)
            if isGreen~=nil and isGreen==true then 
                desc = string.gsub("[ffff96]" .. row.format .. "[-]", "{0}", "[24FC24]" .. arg1 .. "[-]")
            else 
                desc = string.gsub("[ffff96]" .. row.format .. "[-]", "{0}", "[ffffff]" .. arg1 .. "[-]")
            end
        end 
    end
    return desc or ""
end

--角色属性描述（升级进化界面，英雄属性界面）
function m:getAttrDesc(isNext)
    --print("升级： 英雄属性")
    local info = self.info 
    local propertys = info.propertys 
    local desc = {}

    table.foreach(AttrNewDescList, function(i, v)
        local d = ""
        if v == "" then
            table.insert(desc, "\n")
        else
            local row = TableReader:TableRowByUnique("magics", "name", v)
            if propertys.Count > row.id then
                local rate = propertys[row.id] or 0
                local arg1 = rate / row.denominator
                local factor_arg=0
                local color = "[ffffff]"
                if isNext~=nil and isNext==true then
                    local factor_id=AttFactor[i]
                    local row1 = TableReader:TableRowByUnique("magics", "name", factor_id)
                    local rate1 = propertys[row1.id] or 0
                    local factor_arg = rate1 / row1.denominator
                    color="[24FC24]"
                    arg1=arg1+factor_arg
                end  
                arg1 = math.floor(arg1)
                local newColor = "[ffff96]" .. row.format .. "[-]"
                d = string.gsub(newColor, "{0}", color .. arg1 .. "[-]")
            end
            if d ~= "" then
                table.insert(desc, d .. "\n")
            end
        end
    end)
    return desc
end

--可升级
function m:redPointForStrong()
    local ret = false
    --可升级
    ret = Player.Info.level <= self.lv
    if ret == true then return false end 
    local list = getServerPackDataBySubType("item", "yulingItem", Player.ItemBag)
    local xihaoid = self.Table.xihaoid
    local _list = {}
    for k,v in pairs(list) do
        for i=0,xihaoid.Count-1 do
            if tonumber(v.itemID) == tonumber(xihaoid[i]) then 
                table.insert(_list,v)
            end 
        end
    end
    list=_list
    local exp = 0
    for i = 1, #list do 
        local item = list[i]
        exp = exp + item.itemTable.exp * item.itemCount 
    end 
    local total = self.exp
    local lvupExp = self:getLevelUpExp(self.lv + 1)
    if exp>=lvupExp-total then 
        ret =true
    end 
    return ret
end

--可进化提示
function m:redPointForJinHua()
    local ret = false 
    local row = TableReader:TableRowByUniqueKey("yulingstarUp", self.id, self.star_level + 1)
    if row == nil then return false end 
    local lv = row.limitLv
    if lv == nil then return false end 
    if self.lv < lv then return false end
    --材料
    if row then
        local consume = RewardMrg.getConsumeByTable(row.consume)
        local list = {}
        ret = true
        table.foreach(consume, function(i, v)
            local t = v.type
            local num = Tool.getCountByType(t, v.name)
            if v.count > num then ret = false return ret end
        end)
    end
    return ret
end

function m:init(id)
    self.Table = TableReader:TableRowByID("yuling", id)
    if self.Table == nil then
        self.Table = TableReader:TableRowByUnique("yuling", "name", id)
    end
    if self.Table == nil then
        print("readTable err yuling , 读表请使用新的ID: dictid " .. id)
        return
    end

    self.modelTable = TableReader:TableRowByID("petavter", self.Table.model_id) 
	
    self.star = self.Table.star
    self.name=self.Table.show_name
    self.modelid = self.Table.model_id
    self.lv=0
    self.id = tonumber(id or -1)
    self.desc=self.Table.desc
    self:updateInfo()
end

function m:new(id)
    local o = {}
    setmetatable(o, self)
    self.__index = self
    o:init(id)
    return o
end

return m