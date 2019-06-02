--
-- 头像
local m = {}


--点击事件
function m:onClick(uiButton, eventName)
    if self.delegate.CanSelect then 
        self.delegate.selectIndex = self.char.realIndex
        self.delegate:updateItem(self.char.realIndex)
        if self .delegate.type=="smelt" then 
            Events.Brocast('select_char_smelt')
        else 
            Events.Brocast('select_char_main')
        end
    end 
end

function m:isSelect(ret)
	self.select:SetActive(ret)
    if ret == true then
        self.delegate.selectIndex = self.char.realIndex
    end
end

function m:updateChar()
    local char = self.char
    self.img_frame.enabled = false
    if self.__itemAll == nil then
        self.__itemAll = ClientTool.loadAndGetLuaBindingFromPool("Prefabs/publicPrefabs/itemAll", self.img_frame.gameObject)
    end
    self.__itemAll:CallUpdate({ "treasure", self.char.treasure, self.img_frame.width, self.img_frame.height, nil, nil, })
	--self.txt_fight.gameObject:SetActive(true)
	
	--属性信
	self.name.text = char.treasure:getDisplayColorName()
	--self.txt_fight.text = self:getKindName(char.treasure.kind)
    if self:checkMaterial()==true then 
        self.red_point:SetActive(true)
    else 
        self.red_point:SetActive(false)
    end 

end

function m:getKindName(kind)
    if kind == "gong" then
        return "[00ff00]"..TextMap.GetValue("Text1749").."[-]"
    elseif kind == "fang" then
        return "[00ff00]"..TextMap.GetValue("Text1750").."[-]"
    end
    return ""
end

--判断角色是否上阵
function m:checkChar(charid)
    local teams = Player.Team[0].chars
    local list = {}
    for i = 0, 5 do
        if charid == tonumber(teams[i]) then
            return true
        end
    end
    return false
end


--检测角色是否可以培养
function m:check()
    if self.char == nil then return false end
    local char = self.char
    return char:checkRedPoint() or char:redPointForJinHua() or char:redPointForTransform() or char:redPointForSkill() or char:redPointForXueMai()
end

--检测合成材料是否足够
function m:checkMaterial()
    local cur_treasure = self.char.treasure
    local tb = TableReader:TableRowByID("treasure", cur_treasure.id)
    if tb == nil then return end
    local list = {}
    local consume = json.decode(tb.consume:toString())
    if consume ~= nil then
        table.foreach(consume, function(i, v)
            if v.consume_type == "treasurePiece" then
                table.insert(list,v)
            end
        end)
    end
    self.combineNum=0

    for i=1,#list do
        local piece = TreasurePiece:new(list[i].consume_arg,list[i].consume_arg2)
        if piece.count <= 0 then
            return false
        end
    end
    return true
end

--显示英雄详细信息面板
function m:showInfoPanel()
    if self.char == nil then return end
    Tool.push("heroInfo", "Prefabs/moduleFabs/hero/hero_info", self.char)
end

--更新角色列表
--@char 角色 uChar.lua
--@index 列表中的位置
--@delegate 数据控制
function m:update(lua)
	--print("data = " .. json.encode(lua))
    self.index = lua.realIndex
    self.char = lua
	--print("index = " .. tostring(lua.index))
    self.delegate = lua.delegate
    -- self.type = self.delegate:getTab()
    self:updateChar()
	
	self:onUpdate()
end

function m:onUpdate()
    self.select:SetActive(false)
	m:isSelect(self.delegate.selectIndex == self.char.realIndex)
end

function m:Start()
    Events.AddListener("select_char_smelt", function()
        --print (self.delegate.selectIndex .."smelt".. self.char.realIndex)
        if self .delegate.type=="smelt" then 
            m:isSelect(self.delegate.selectIndex == self.char.realIndex)
        end
        end)
     Events.AddListener("select_char_main", function()
        if self .delegate.type~="smelt" then 
            m:isSelect(self.delegate.selectIndex == self.char.realIndex)
        end
        end)
	--Events.AddListener("updateChar", funcs.handler(self, m.updateChar))
end

function m:OnDestroy()
    self.select:SetActive(false)
    if self .delegate.type=="smelt" then 
        Events.RemoveListener('select_char_smelt')
    else
        Events.RemoveListener('select_char_main') 
    end
end

return m

