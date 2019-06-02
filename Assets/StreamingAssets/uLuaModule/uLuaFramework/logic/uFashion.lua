local Fashion = {}
function Fashion:getType()
    return "fashion"
end

--角色小头像
function Fashion:getHead()
    if (self._head) then return self._head end
    local img = self.Table.icon

    if (img == "" or img == nil) then img = "default" end

    self._head = UrlManager.GetImagesPath("equipImage/" .. img .. ".png")
    return self._head
end

--获取头像贴图名字
function Fashion:getHeadSpriteName()
    local img = self.Table.icon
    if (img == "" or img == nil) then img = "default" end
    return img
end

--ui中显示角色名字，带进阶等级
function Fashion:getDisplayName()
	local name =""
	name = Fashion:getItemColorName(self.star,self.name)
    return name
end

--ui中显示角色名字，带进阶等级
function Fashion:getDisplayColorName()
    local name ="" 
	name = Fashion:getItemColorName(self.star,self.name)
    return name
end

--进阶颜色与外框
function Fashion:getColor()
    local color = Tool.getCharColor(self.star)
    return color
end

function Fashion:getItemColorName(color, names)
    local _names = names
	if color == 1 then
        _names = "[ffffff]" .. names .. "[-]"
    elseif color == 2 then
        _names = "[00ff00]" .. names .. "[-]"
    elseif color == 3 then
        _names = "[00b4ff]" .. names .. "[-]"
    elseif color == 4 then
        _names = "[ff00ff]" .. names .. "[-]"
    elseif color == 5 then
        _names = "[ff9600]" .. names .. "[-]"
    elseif color == 6 then
        _names = "[ff0000]" .. names .. "[-]"
    end
    return _names
end

function Fashion:getItemQuality()
    local _names=""
    if self.star == 1 then
        _names = TextMap.GetValue("Text_1_2895")
    elseif self.star == 2 then
        _names = TextMap.GetValue("Text_1_2896")
    elseif self.star == 3 then
        _names = TextMap.GetValue("Text_1_2897")
    elseif self.star == 4 then
        _names = TextMap.GetValue("Text_1_2898")
    elseif self.star == 5 then
        _names = TextMap.GetValue("Text_1_2899")
    elseif self.star == 6 then
        _names = TextMap.GetValue("Text_1_2900")
    end
    return _names
end

--外框
function Fashion:getFrame()
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
function Fashion:getFrameBG()
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

function Fashion:getAllSkill()
    local tb = {}
    if self._allSkills == nil then
        self._allSkills = {}
        local sk_list = self.modelTable.skill
        local sk = {} 
        -- 普通攻击
        sk.lv = 1
        sk.Table = TableReader:TableRowByID("skill", self.modelTable.normal_skill)
        if sk.Table == nil then
            sk.Table = TableReader:TableRowByUnique("skill", "name", self.modelTable.normal_skill)
            return
        end
        sk.id = sk.Table.id
        sk.name = sk.Table.show
        sk.desc=sk.Table.desc
        sk.customType = 1
        table.insert(self._allSkills, sk)
        -- 普通技能
        for i = 0, sk_list.Count - 1 do
            if sk_list[i] ~= "" then
                sk = {} 
                sk.lv = 1
                sk.Table = TableReader:TableRowByID("skill", sk_list[i])
                if sk.Table == nil then
                    sk.Table = TableReader:TableRowByUnique("skill", "name", sk_list[i])
                    return
                end
                sk.id = sk.Table.id
                sk.name = sk.Table.show
                sk.desc=sk.Table.desc
                sk.customType = 2
                table.insert(self._allSkills, sk)
            end
        end
        -- 合体技
        local ht_list = self.modelTable.xp_skill
        for i = 0, ht_list.Count - 1 do
            if ht_list[i] ~= "" then
                sk = {} 
                sk.lv = 1
                sk.Table = TableReader:TableRowByID("skill", ht_list[i])
                if sk.Table == nil then
                    sk.Table = TableReader:TableRowByUnique("skill", "name", ht_list[i])
                    return
                end
                sk.id = sk.Table.id
                sk.name = sk.Table.show
                sk.desc=sk.Table.desc
                sk.customType = 3
                table.insert(self._allSkills, sk)
            end
        end
    end
    return self._allSkills
end

function Fashion:updateInfo()
    self.lv = Player.fashion[self.id].powerlvl
end

function Fashion:init(id)
    self.Table = TableReader:TableRowByID("fashion", id)
    if self.Table == nil then
        self.Table = TableReader:TableRowByUnique("fashion", "name", id)
    end
    if self.Table == nil then
        print("readTable err char , 读表请使用新的ID: dictid " .. dictid)
        return
    end

    self.modelTable = TableReader:TableRowByID("avter", self.Table.modelid) 
    self.charTable= TableReader:TableRowByID("char", self.Table.modelid) 
	
    self.star = self.Table.star
    self.name=self.Table.show_name
    self.lv=0
    self.id = tonumber(id or -1)
    self.desc=self.Table.desc
    self:updateInfo()
end

function Fashion:new(id)
    local o = {}
    setmetatable(o, self)
    self.__index = self
    o:init(id)
    return o
end

return Fashion