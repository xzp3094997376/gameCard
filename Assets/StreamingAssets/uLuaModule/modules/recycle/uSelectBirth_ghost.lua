local m = {}

local charNum = 0
local maxNum = 6

function m:onEnter()
    if self.__onExit == true then
        self.__onExit = false
        self:update(false)
    end
end

function m:onExit()
    self.__onExit = true
end

function m:onUpdate()
    self:update()
end

function m:update(lua)
    self.delegate = lua.delegate
    self.tp=lua.tp
    self.model=lua.model
    if self.tp=="ghost" and self.model=="CS" then
        self.title.text=TextMap.GetValue("Text_1_1008")
        self:setChar()
        self:refresh()
    elseif self.tp=="treasure" and self.model=="CS" then 
        self.title.text=TextMap.GetValue("Text_1_1005")
        self:setChar()
        self:refresh()
    elseif self.tp=="ghost" and self.model=="FJ" then
        self.title.text=TextMap.GetValue("Text_1_1009")
        self.teams=lua.teams
        self:updateNum(self.teams)
        self:onHero(ret)
    end 
end

function m:sort(charsList)
    table.sort(charsList, function(aData, bData)
        if aData.char.star ~= bData.char.star then return aData.char.star < bData.char.star end
        if aData.char.id~=bData.char.id then return aData.char.id < bData.char.id end 
    end)
    return charsList
end

local lists_choosed = {}

function m:saveChars(data, isChoose, num)
    local hasExist = false
    if data:getType() == "ghost" then --如果是鬼道
        if isChoose == true then --选中该物体加入到队列中
            local m = {}
            m.char = data
            m.num = num
            if self:checkNum(charNum) then
                table.insert(self.teams, m)
                charNum = charNum + 1
            end
            m = nil
        else --已经选择了该英雄，直接将其删除掉
            table.foreach(self.teams, function(k, v)
                -- print("v.char.getType() " .. v.char:getType() .. data:getType() .. "  id " .. v.char.key .. data.key)
                if v.char:getType() == data:getType() and v.char.key == data.key then
                    charNum = charNum - 1
                    table.remove(self.teams, k)
                    hasExist = true
                end
            end)
        end
    elseif data:getType() == "ghostPiece" and isChoose == true then --已经选择了该英雄，直接将其删除掉
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
            --  m.isChoose = true
            if self:checkNum(charNum) then
                table.insert(self.teams, m)
                charNum = charNum + 1 --如果不存在，添加成员数量
            end
        end
    end
    self:updateNum(self.teams)
end


function m:checkNum(num)

    if num >= maxNum then
        MessageMrg.show(TextMap.GetValue("Text1383"))
        return false
    else
        return true
    end
end

function m:getData(data)
    local list = {}
    local row = 2
    for i = 1, table.getn(data), row do
        local li = {}
        local len = 0
        for j = 0, row - 1 do
            if data[i + j] then
                local d = data[i + j]
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

function m:getNum(...)
    return charNum
end

function m:updateNum(_list)
    local charNum = 0
    if _list ~= nil then
        charNum = table.getn(_list)
    end
end

function m:isInTeam(char)
    local isIn = false
    if self.teams~=nil then 
        table.foreach(self.teams, function(k, v)
            if char.id == v.char.id and char.key == v.char.key then
                isIn = true
            end
        end)
    end 
    return isIn
end

--获取未培养的鬼道列表与鬼道碎片列表
function m:getList()
    local list = {}
    -- 获取没上阵的鬼道而且非初始化
    local ghost = Tool.getUnUseGhost()
    for i = 1, #ghost do
        local m = {}
        local gh = ghost[i]
        gh:updateInfo()
        local isChoose = self:isInTeam(gh)
        m.char = gh
        m.char.isChoose = isChoose
        table.insert(list, m)
    end
    list = self:sort(list)
    list = self:getData(list)
    return list
end

--显示英雄
function m:onHero(ret)
    self._oldCharList = self:getList()
    if ret == nil then
        ret = true
    end
    self.scrollView:refresh(self._oldCharList, self, false)
    if table.getn(self._oldCharList) == 0 then
        MessageMrg.show(TextMap.GetValue("Text1380"))
        return false
    end
end

function m:onSureTeam(go)
    --自身的一个选择列表
    self.delegate:setTeamInfo(self.teams)
    self.delegate:setFenYe()
    UIMrg:pop()
end


--对鬼道进行筛选，筛选出有培养过的鬼道
function m:getGhostList()
    local ghost = Tool.getUnUseGhost()
    local list = {}
    for i = 1, #ghost do
        local m = {}
        local gh = ghost[i]
        gh:updateInfo()
        if gh.star>=3 then 
            local isChoose = self:isInTeam(gh)
            m.isChoose = isChoose
            m.char = gh
            m.char.isChoose = isChoose
            table.insert(list, m)
        end
    end
    list = self:sort(list)
    list = self:getData(list)
    return list
end

function m:sort(charsList)
    table.sort(charsList, function(aData, bData)
        if aData.char.star ~= bData.char.star then return aData.char.star > bData.char.star end
        if aData.char.id ~= bData.char.id then return aData.char.id < bData.char.id end
    end)
    return charsList
end

function m:setChar(char)
    self.char = char
    if self.char ~=nil then 
        m:hasChooseChar()
    end
end

function m:hasChooseChar()
    if self.tp=="ghost" and self.model=="CS" then 
        self.delegate:getChar(self.char)
    elseif self.tp=="treasure" and self.model=="CS" then  
        self.delegate:selectedRebornTreasure(self.char)
    end 
    UIMrg:pop()
end

function m:getCharId()
    if self.char ~= nil then
        return self.char.id
    else return nil
    end
end


function m:getTreasure()
    local list = {}
    local all_list = Tool.getUnUseTreasure()
    for k,v in pairs(all_list) do
        local m = {}
        local char = Treasure:new(v.value.id, v.key)
        if char.lv>1 or char.power>0 then
            m.isChoose = false
            m.char = char
            m.char.isChoose = false
            table.insert(list, m)
        end 
    end
    table.sort(list, function(aData, bData)
        if aData.star ~= bData.star then return aData.star > bData.star end  
		if aData.id == nil then return false end 
        return aData.id<bData.id 
    end)
    list = self:getData(list)
    return list
end

function m:refresh(...)
    if self.tp=="ghost" and self.model=="CS" then
        self.ghostList = self:getGhostList()
        if table.getn(self.ghostList) == 0 then
            MessageMrg.show(TextMap.GetValue("Text_1_1010"))
            UIMrg:pop()
            return false
        else
            self.scrollView:refresh(self.ghostList, self, false)
        end
    elseif self.tp=="treasure" and self.model=="CS" then 
        self.list = self:getTreasure()
        if table.getn(self.list) == 0 then
            --MessageMrg.show(TextMap.GetValue("Text1380"))
            MessageMrg.show(TextMap.GetValue("Text_1_1011"))
            UIMrg:pop()
            return false
        else
            self.scrollView:refresh(self.list, self, false)
        end
    end 
end

function m:selectGhost(char,isChoose,num)
    if self.tp=="ghost" and self.model=="CS" then 
        self.delegate:selectGhost(char,isChoose,num)
        if isChoose == true then
            self.char = char
            self:setChar(char)
        else
            self.char = nil
            self:setChar()
        end
    elseif self.tp=="treasure" and self.model=="CS" then  
        if isChoose==true then 
            self.char = char
            self:setChar(char)
        end 
    end 

end

function m:destory(...)
    UIMrg:pop()
end

function m:Start()
    -- ClientTool.AddClick(self.bg, function(...)
    --     self:destory()
    -- end)
end

function m:onClick(go, name)
	if name == "btnBack" then
		UIMrg:pop()
	elseif name == "btSure" then
        self:onSureTeam(go)
    elseif name == "btClose" then
        self.delegate:setFenYe()
        UIMrg:pop()
    end
end

return m