local CharList = {}
local charNum = 0
local maxNum = 5
local gui_top_title = {}
--初始化，加载时由C#调用
function CharList:create(binding)
    self.binding = binding
    return self
end

function CharList:onEnter()
    if self.__onExit == true then
        self.__onExit = false
        self:update(false)
    end
end

function CharList:onExit()
    self.__onExit = true
end

function CharList:onUpdate()
    self:update()
end

function CharList:sort(charsList)
    table.sort(charsList, function(aData, bData)
        local a = aData.char
        local b = bData.char
        if a.teamIndex ~= b.teamIndex then return a.teamIndex < b.teamIndex end
        if a.star ~= b.star then return a.star < b.star end
        if a.stage ~= b.stage then return a.stage < b.stage end
        if a.power ~= b.power then return a.power < b.power end
        return a.id < b.id
    end)
    return charsList
end

local lists_choosed = {}

function CharList:saveChars(data, isChoose, num)
    local hasExist = false
    if data:getType() == "char" and isChoose == true then --直接添加
    local m = {}
    m.char = data
    m.num = num
    if self:checkNum(charNum) then
        table.insert(self.teams, m)
        charNum = charNum + 1
    end
    m = nil
    elseif data:getType() == "char" and isChoose == false then --已经选择了该英雄，直接将其删除掉
    table.foreach(self.teams, function(k, v)
        if v.char:getType() == data:getType() and v.char.id == data.id then
            charNum = charNum - 1
            table.remove(self.teams, k)
            hasExist = true
        end
    end)

    elseif data:getType() == "charPiece" and isChoose == true then --只存在选中该物品
    table.foreach(self.teams, function(k, v)
        if v.char:getType() == data:getType() and v.char.id == data.id then
            v.num = num
            hasExist = true
        end
    end)

    if hasExist ~= true then
        local m = {}
        m.char = data
        m.num = num
        if self:checkNum(charNum) then
            table.insert(self.teams, m)
            charNum = charNum + 1 --如果不存在，添加成员数量
        end
    end
    end
    self:updateNum(self.teams)
end


function CharList:checkNum(num)
    if num >= maxNum then
        MessageMrg.show(TextMap.GetValue("Text1375"))
        return false
    else
        return true
    end
end

function CharList:getData(data)
    local list = {}
    local row = 2
    for i = 1, table.getn(data), row do
        local li = {}
        local len = 0
        for j = 0, row - 1 do
            if data[i + j] then
                local d = data[i + j]
                if d.char:getType() == "char" then
                    d.realIndex = i + j
                end
                li[j + 1] = d
                len = len + 1
            end
        end
        if len > 0 then
            table.insert(list, li)
        end
    end
    return list
end

function CharList:getNum(...)
    return charNum
end

function CharList:updateNum(_list)
    local charNum = 0
    if _list ~= nil then
        charNum = table.getn(_list)
    end
end

--刷新
function CharList:update(lua)
    --获取那些角色被选择了的
    self.teams = lua.teams
    self.delegate = lua.delegate
    self.model=lua.model
    self.tp=lua.tp
    local title = ""
    if self.tp=="char" and self.model=="FJ" then 
        self:updateNum(self.teams)
        self:onHero(nil, ret)
        title=TextMap.GetValue("Text_1_1012")
    elseif self.tp=="char" and self.model=="CS" then  
        title=TextMap.GetValue("Text_1_1004")
        self:setChar()
        self.charList = self:getChars()
        if table.getn(self.charList) == 0 then
            MessageMrg.show(TextMap.GetValue("Text1377"))
            UIMrg:pop()
            return false
        else 
            self.scrollView:refresh(self.charList, self, false)
        end 
    elseif self.tp=="pet" and self.model=="FJ" then 
        self:setChar()
        self.charList=self:getPets()
        table.sort(self.charList, function(a, b)
            if a.char.star ~= b.char.star then return a.char.star > b.char.star end
            if a.char.dictid ~= b.char.dictid then return a.char.dictid > b.char.dictid end
            return a.char.dictid < b.char.dictid
        end)
        self.charList = self:getData(self.charList)
        if table.getn(self.charList) == 0 then
            title=TextMap.GetValue("Text_1_1006")
            MessageMrg.show(TextMap.GetValue("Text_1_992"))
            UIMrg:pop()
            return false
        else 
            self.scrollView:refresh(self.charList, self, false)
        end 
    elseif self.tp=="pet" and self.model=="CS" then 
        self:setChar()
        self.charList=self:getPets()
        table.sort(self.charList, function(a, b)
            if a.char.star ~= b.char.star then return a.char.star < b.char.star end
            if a.char.dictid ~= b.char.dictid then return a.char.dictid < b.char.dictid end
            return a.char.dictid < b.char.dictid
        end)
        self.charList = self:getData(self.charList)
        if table.getn(self.charList) == 0 then
            title=TextMap.GetValue("Text_1_1007")
            MessageMrg.show(TextMap.GetValue("Text_1_993"))
            UIMrg:pop()
            return false
        else 
            self.scrollView:refresh(self.charList, self, false)
        end       
    end 
    if gui_top_title then 
        gui_top_title:CallUpdateWithArgs({title = title})
    end 
end

function CharList:petIsOnTeam()
    local ret = false 
    if Player.Team[0].pet ~= nil and tostring(Player.Team[0].pet) ~= "0" then 
        ret = true 
    end 
    return ret
end 

function CharList:petOnFilter(pet)
    if self:checkHuyou(pet.id) then return false end 
    return true
end 


function CharList:checkHuyou(petId)
    local ghostSlot = Player.ghostSlot
    for i = 0, 5 do 
        local slot = ghostSlot[i]
        local petid = slot.petid
        if petId == petid then 
            return true
        end 
    end 
    return false
end 

--对宠物进行筛选
function CharList:getPets()
    local ids = {}
    if self:petIsOnTeam() == true then
        ids[Player.Team[0].pet .. ""] = true
    end

    local function isShow(id)
        if ids[id .. ""] then
            return false
        end
        return true
    end

    local pets = Player.Pets:getLuaTable()
    local petsList = {}
    for k, v in pairs(pets) do
        local pet = Pet:new(k, v)
        if isShow(pet.id) then
            if self.petOnFilter then
                if self:petOnFilter(pet) then
                    local m = {}
                    m.num = 1
                    m.char = pet
                    m.char.isChoose = false
                    table.insert(petsList, m)
                    m = nil
                end
            else
                local m = {}
                m.num = 1
                m.char = pet
                m.char.isChoose = false
                table.insert(petsList, m)
                m = nil
            end
        end
    end
    return petsList
end

function CharList:isInTeam(char)
    local isIn = false
    table.foreach(self.teams, function(k, v)
        if char:getType() == v.char:getType() and char.id == v.char.id then
            isIn = true
        end
    end)
    return isIn
end

function CharList:getNewPieceNum(piece)
    local newNum = 0
    local isExist = false
    table.foreach(self.teams, function(k, v)
        if piece:getType() == v.char:getType() and piece.id == v.char.id then
            newNum = v.num
            isExist = true
        end
    end)
    if isExist ~= true then
        newNum = 0
    end
    return newNum
end

function CharList:setChar(char)
    self.char = char
    if self.char~=nil then 
        self:hasChooseChar()
    end
end

function CharList:hasChooseChar()
    self.delegate:getChar(self.char)
    UIMrg:pop()
end


function CharList:getCharId()
    if self.char ~= nil then
        return self.char.id
    else return nil
    end
    -- body
end

--对角色进行筛选，重生的时候选择已经培养过并未上阵的英雄, 等级lv 和进化等级 star_level
function CharList:getChars()
    local chars = Player.Chars:getLuaTable() --获取所有英雄列表
    local charsList = {}
    for k, v in pairs(chars) do
        local char = Char:new(k, v)
        if char.Table.can_return ~= 0 and char:getTeamIndex() == 7 and self:checkFriend(char) == false and self:onAgency(char) == false then  --表示不是初始状态, char:getTeamIndex() ==7 表示未上阵
            local m = {}
            m.num = 1
            m.char = char
            m.char.isChoose = false
            table.insert(charsList, m)
            m = nil
        end
    end
    --更具一定条件进行排序
    if #charsList>1 then 
        table.sort(charsList, function(a, b)
            if a.char.formation_pos ~= b.char.formation_pos then return a.char.formation_pos < b.char.formation_pos end
            if a.char.star ~= b.char.star then return a.char.star > b.char.star end
            if a.char.stage ~= b.char.stage then return a.char.stage > b.char.stage end
            if a.char.power ~= b.char.power then return a.char.power > b.char.power end
            return a.char.id < b.char.id
            end)
    end

    for k, v in pairs(chars) do
        local char = Char:new(k, v)
        if char.Table.can_return ~= 0 and char:getTeamIndex() ~= 7 or self:checkFriend(char) or self:onAgency(char) then  --表示不是初始状态, char:getTeamIndex() ==7 表示未上阵
            local m = {}
            m.num = 1
            m.char = char
            m.char.isChoose = false
            table.insert(charsList, m)
            m = nil
        end
    end
    charsList = self:getData(charsList)
    return charsList
end

--list存放的是每一个英雄
--piecesList  --存放每一个碎片
function CharList:getList()
    --获取角色列表和碎片列表
    local chars = Player.Chars:getLuaTable() --获取所有英雄
    local index = 1
    local list = {}
    --遍历所有角色
    for k, v in pairs(chars) do
        local char = Char:new(k, v)
        if char.Table.can_return~=0 and char:getTeamIndex() == 7 and self:checkFriend(char) == false and self:onAgency(char)==false then --是初始状态并且未上阵
        --判断该char是否在选中列表中
            local m = {}
            local isChoose = self:isInTeam(char)
            m.num = 1
            m.char = char
            m.char.isChoose = isChoose
            table.insert(list, m)
            m = nil
        end
    end
    list = self:sort(list)

    for k, v in pairs(chars) do
        local char = Char:new(k, v)
        if char.Table.can_return~=0 and char:getTeamIndex() ~= 7 or self:checkFriend(char) or self:onAgency(char) then --是初始状态并且未上阵
        --判断该char是否在选中列表中
            local m = {}
            local isChoose = self:isInTeam(char)
            m.num = 1
            m.char = char
            m.char.isChoose = isChoose
            table.insert(list, m)
            m = nil
        end
    end
    list = self:getData(list)
    return list
end

function CharList:onAgency(char)
    if char.id == Player.Info.playercharid then return true end 
    for i = 1, 6 do
        local it = Player.Agency[i]
        if tonumber(it.charId) == tonumber(char.id) then return true end
    end
    return false
end

--显示英雄
function CharList:onHero(go, ret)
    self._oldCharList = self:getList()
    if ret == nil then
        ret = true
    end
    self.scrollView:refresh(self._oldCharList, self, ret)
    --self.binding:CallAfterTime(0.3, function()
    --    self:setButtonEnable(true)
    --end)
    if table.getn(self._oldCharList) == 0 then
        MessageMrg.show(TextMap.GetValue("Text1379"))
        UIMrg:pop()
        return false
    end
end

function CharList:onPiece(go)
    self:getList()
    self.scrollView:refresh(self.piecesList, self, false)
    --self.binding:CallAfterTime(0.3, function()
    --    self:setButtonEnable(true)
    --end)
    if table.getn(self.piecesList) == 0 then
        MessageMrg.show(TextMap.GetValue("Text1380"))
        return false
    end
end

function CharList:onSureTeam(go)
    --自身的一个选择列表
    self.delegate:setTeamInfo(self.teams)
    self.delegate:setFenYe()
    UIMrg:pop()
end

function CharList:setButtonEnable(bool)
    if bool == false then
        self.btn_hero.isEnabled = false
        self.btn_piece.isEnabled = false

    else
        self.btn_hero.isEnabled = true
        self.btn_piece.isEnabled = true
    end
end

function CharList:onClick(go, name)
	if name == "btSure" then --确认选择了那些英雄
		self:onSureTeam(go)
	elseif name == "btnBack" then 
		UIMrg:pop()
    elseif name == "btClose" then
        self.delegate:setFenYe()
        UIMrg:pop()
    end
end

function CharList:checkFriend(char)
    local teams = Player.Team[12].chars
    local list = {}
    local len = teams.Count
    for i = 0, 7 do
        if i < len then
            if char.id .. "" == teams[i] .. "" then
                return true
            end
        end
    end
    return false
end

function CharList:Start()
	gui_top_title=Tool.loadTopTitle(self.gameObject, TextMap.GetValue("Text_1_1012"))
end

return CharList