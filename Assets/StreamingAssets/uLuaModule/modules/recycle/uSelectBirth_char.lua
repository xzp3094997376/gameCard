local birthChars = {}

function birthChars:update(lua)
    --获取英雄列表
    self.delegate = lua.delegate
    self.model=lua.model
	local title = ""
    if self.model=="char" then
        title=TextMap.GetValue("Text_1_1004")
    elseif self.model=="treasure" then
        title=TextMap.GetValue("Text_1_1005")
    elseif self.model=="pet_FJ" then
        title=TextMap.GetValue("Text_1_1006")
    else 
        title=TextMap.GetValue("Text_1_1007")
    end 
	if gui_top_title then 
		gui_top_title:CallUpdateWithArgs({title = title})
	end 
    self:setChar()
    self:refresh()
end

--对角色进行筛选，重生的时候选择已经培养过并未上阵的英雄, 等级lv 和进化等级 star_level
function birthChars:getChars()
    local chars = Player.Chars:getLuaTable() --获取所有英雄列表
    local charsList = {}
    local index = 1
    for k, v in pairs(chars) do
        local char = Char:new(k, v)
        if char.Table.can_return~=0 and char:getTeamIndex() == 7 and self:checkFriend(char) == false and self:onAgency(char)==false then --表示不是初始状态, char:getTeamIndex() ==7 表示未上阵
            if self.char ~= nil  then
                if char.id == self.char.id then 
                    char.isChoose = true
                else
                    char.isChoose = false
                end
            else
                char.isChoose = false
            end
            charsList[index] = char
            index = index + 1
        end
    end
    --更具一定条件进行排序
    if index>1 then 
        table.sort(charsList, function(a, b)
            if a.formation_pos ~= b.formation_pos then return a.formation_pos < b.formation_pos end
            if a.star ~= b.star then return a.star > b.star end
            if a.stage ~= b.stage then return a.stage > b.stage end
            if a.power ~= b.power then return a.power > b.power end
            return a.id < b.id
            end)
    end
    print("chars " .. table.getn(charsList))
    charsList = self:getData(charsList)
    return charsList
end

function birthChars:petIsOnTeam()
    local ret = false 
    if Player.Team[0].pet ~= nil and tostring(Player.Team[0].pet) ~= "0" then 
        ret = true 
    end 
    return ret
end 

function birthChars:onFilter(pet)
    if self:checkHuyou(pet.id) then return false end 
    return true
end 


function birthChars:checkHuyou(petId)
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
function birthChars:getPets()
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
    local index = 1
    for k, v in pairs(pets) do
        local pet = Pet:new(k, v)
        if isShow(pet.id) then
            if self.onFilter then
                if self:onFilter(pet) then
                    if self.char ~= nil  then
                        if pet.id == self.char.id then 
                            pet.isChoose = true
                        else
                            pet.isChoose = false
                        end
                    else
                        pet.isChoose = false
                    end
                    petsList[index] = pet
                    index = index + 1
                end
            else
                if self.char ~= nil  then
                    if pet.id == self.char.id then 
                        pet.isChoose = true
                    else
                        pet.isChoose = false
                    end
                else
                    pet.isChoose = false
                end
                petsList[index] = pet
                index = index + 1
            end
        end
    end
    table.sort(petsList, function(a, b)
        if a.star ~= b.star then return a.star > b.star end
        if a.dictid ~= b.dictid then return a.dictid > b.dictid end
        return a.dictid < b.dictid
    end)
    petsList = self:getData(petsList)
    return petsList
end

function birthChars:onAgency(char)
    if char.id == Player.Info.playercharid then return true end 
    for i = 1, 6 do
        local it = Player.Agency[i]
        if tonumber(it.charId) == tonumber(char.id) then return true end
    end
    return false
end

function birthChars:checkFriend(char)
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

function birthChars:setChar(char)
    self.char = char
    if self.char~=nil then 
        self:hasChooseChar()
    end
end

function birthChars:hasChooseChar()
    self.delegate:getChar(self.char)
    UIMrg:pop()
end


function birthChars:getCharId()
    if self.char ~= nil then
        return self.char.id
    else return nil
    end
    -- body
end

function birthChars:getData(data)
    local list = {}
    local row = 2
    for i = 1, table.getn(data), row do
        local li = {}
        local len = 0
        for j = 0, row - 1 do
            if data[i + j] then
                local d = data[i + j]
                d.realIndex = i + j
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
function birthChars:getTreasure()
    local list = {}
    local all_list = Tool.getUnUseTreasure()
    for k,v in pairs(all_list) do
        local char = Treasure:new(v.value.id, v.key)
        char.isChoose = false
        table.insert(list, char)
    end
    table.sort(list, function(aData, bData)
        if aData.star ~= bData.star then return aData.star > bData.star end
        return aData.id<bData.id 
    end)
    list = self:getData(list)
    return list
end

function birthChars:refresh(...)
    if self.model=="char" then 
        self.charList = self:getChars()
    elseif self.model=="treasure" then 
        self.charList = self:getTreasure()
    else 
        self.charList=self:getPets()
    end 
    if table.getn(self.charList) == 0 then
        if self.model=="char" then
            MessageMrg.show(TextMap.GetValue("Text1377"))
        elseif self.model=="pet_FJ" then
            MessageMrg.show(TextMap.GetValue("Text_1_992"))
        else 
            MessageMrg.show(TextMap.GetValue("Text_1_993"))
        end 
        UIMrg:pop()
        return false
    else
        self.scrollView:refresh(self.charList, self, false)
    end
end

function birthChars:destory(...)
    UIMrg:pop()
end

function birthChars:Start()
	Tool.loadTopTitle(self.gameObject, TextMap.GetValue("Text_1_1004"))
    -- ClientTool.AddClick(self.bg, function(...)
    --     self:destory()
    -- end)
end

function birthChars:onClick(go, name)
    if name == "btnBack" then 
		UIMrg:pop()
	elseif name == "btSure" then
        self:hasChooseChar()
    end
end

return birthChars