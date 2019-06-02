local CharList = {}

local charNum = 0
local maxNum = 6
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
        if aData.char.star ~= bData.char.star then return aData.char.star < bData.char.star end
        if aData.char.id~=bData.char.id then return aData.char.id < bData.char.id end 
    end)
    return charsList
end

local lists_choosed = {}

function CharList:saveChars(data, isChoose, num)
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
    -- self:onHero()
end


function CharList:checkNum(num)

    if num >= maxNum then
        MessageMrg.show(TextMap.GetValue("Text1383"))
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
                -- if d.char:getType() == "char" then
                --     d.realIndex = i + j
                -- end
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
   -- self.num.text = TextMap.GetValue("Text1384") .. charNum .. "[-]" .. "/" .. maxNum
end

--刷新
function CharList:update(lua)
    --获取那些角色被选择了的
    self.teams = lua.teams
    --    print("teams"..table.getn(self.teams))
    self.delegate = lua.delegate
    self:updateNum(self.teams)
    self:onHero(ret)
end

function CharList:isInTeam(char)
    local isIn = false
    table.foreach(self.teams, function(k, v)
        if char.id == v.char.id and char.key == v.char.key then
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

--获取未培养的鬼道列表与鬼道碎片列表
function CharList:getList()
    local list = {}
    -- 获取没上阵的鬼道而且非初始化
    local ghost = Tool.getUnUseGhost()
    for i = 1, #ghost do
        local m = {}
        local gh = ghost[i]
        gh:updateInfo()
        --if gh.power.."" == "0" and gh.lv.."" == "1" and gh.xilian_times.."" == "0" then 
            local isChoose = self:isInTeam(gh)
            -- m.isChoose = isChoose
            m.char = gh
            m.char.isChoose = isChoose
            table.insert(list, m)
        --end
    end
    list = self:sort(list)
    list = self:getData(list)

    --[[--获取未上阵的鬼道碎片
    local piecesList = {}
    local pieces = Tool.GhostPieceList --获取碎片列表
    table.foreachi(pieces, function(index, p)
        p:updateInfo() --更新碎片信息
        if p.count > 0 then
            local m = {}
            -- m.isChoose = self:isInTeam(p)
            m.num = self:getNewPieceNum(p) --还剩多少个
            m.char = p
            m.char.isChoose = self:isInTeam(p)
            table.insert(piecesList, m)
            m = nil
        end
    end)

    table.sort(piecesList, function(aData, bData)
        local a = aData.char
        local b = bData.char
        if a.star ~= b.star then return a.star > b.star end
        return a.id < b.id
    end)
    self.piecesList = self:getData(piecesList)]]
    return list
end

--显示英雄
function CharList:onHero(ret)
    --  if self._oldCharList == nil then
    --  print("oldchar")
    self._oldCharList = self:getList()
    --  end
    if ret == nil then
        ret = true
    end
    self.scrollView:refresh(self._oldCharList, self, false)
    if table.getn(self._oldCharList) == 0 then
        MessageMrg.show(TextMap.GetValue("Text1380"))
        return false
    end
end

function CharList:onPiece(go)
    self:getList()
    self.scrollView:refresh(self.piecesList, self, false)
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



function CharList:onClick(go, name)
    if name == "btnBack" then
		UIMrg:pop()
    elseif name == "btSure" then --确认选择了那些英雄
		self:onSureTeam(go)
    elseif name == "btClose" then
        self.delegate:setFenYe()
        UIMrg:pop()
    end
end

function CharList:Start()
end

return CharList