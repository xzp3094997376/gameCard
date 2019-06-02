-- 选择角色列表
local m = {}

function m:update(lua)
    if lua.type == "single" or lua.type == "char" then
        self.delegate = lua.delegate
        self._type = "char"
        self.pos_index = lua.index
        self.module = lua.module
        m:showSingle(lua.module)
	elseif lua.type == "pet" or lua.type == "pet_huyou" then
		self.delegate = lua.delegate
        self._type = lua.type
        self.pos_index = lua.index
		m:showPets()
    elseif lua.type == "yuling" then
        self.delegate = lua.delegate
        self._type = lua.type
        self.pos_index = lua.index
        m:showYulings()
        --m:showSingle(lua.module)
    end
end

function m:showYulings()
    local ids = {}
    local yulings = Player.yuling:getLuaTable()
    local yulingsList = {}
    for k, v in pairs(yulings) do
        local yuling = Yuling:new(k)
        local info = Player.yuling[k] 
        if info.quality>0 and info.huyou<=0 then 
            table.insert(yulingsList, yuling)
        end
    end
    
    table.sort(yulingsList, function(a, b)
        if a.star ~= b.star then return a.star > b.star end
        return a.id < b.id
    end)
    
    if #yulingsList == 0 then
        UIMrg:popWindow()
        UIMrg:pushWindow("Prefabs/publicPrefabs/gui_get_help", {type = "yuling"})
        return
    end
    
    
    yulingsList = self:getData(yulingsList)
    self.scrollView:refresh(yulingsList, self, false, 0)
    self.binding:Hide("txt_has_select")
    self.binding:Hide("txt_power")
end

function m:showPets()
    local ids = {}
    local pets = Player.Pets:getLuaTable()
    local petsList = {}
	for k, v in pairs(pets) do
		local pet = Pet:new(k, v)
		if self.delegate.onFilterPet then
			if self.delegate:onFilterPet(pet) then
				table.insert(petsList, pet)
			end
		else
			table.insert(petsList, pet)
		end
	end
	
    table.sort(petsList, function(a, b)
		if a.star ~= b.star then return a.star > b.star end
		if a.dictid ~= b.dictid then return a.dictid > b.dictid end
        return a.dictid < b.dictid
    end)
	
	if #petsList == 0 then
        UIMrg:popWindow()
        UIMrg:pushWindow("Prefabs/publicPrefabs/gui_get_help", {type = "pet"})
        return
    end
	
    
    petsList = self:getData(petsList)
    self.scrollView:refresh(petsList, self, false, 0)
    self.binding:Hide("txt_has_select")
    self.binding:Hide("txt_power")
end


function m:showSingle(c)
    local ids = {}
    self._selectType = c

    --if self:getTeam then
    local team = self:getTeam()
    for i = 1, #team do
        local id = tonumber(team[i])
        if id ~= nil and id > 0 then
			ids[id .. ""] = true
        end
    end
    --end
    --if self:getXiaoHuoBanTeam then
    local team = self:getXiaoHuoBanTeam()
    for i = 1, #team do
        local id = tonumber(team[i])
        if id ~= nil and id > 0 then
            ids[id .. ""] = true
        end
    end

    local function isShow(id)
        if ids[id .. ""] then
            return false
        end
        return true
    end

    local chars = Player.Chars:getLuaTable()
    local charsList = {}
	local dictList = {}
	local teamList = {}
	local huobanList = {}
	-- 上阵的人提前加入过滤列表
	if c ~= "daili" then 
        if self.module == "formation" or self.module == "ghost" then --替换主阵上的角色
            local team = self:getTeam()
            for i = 1, #team do
                if i~=self.pos_index then 
                    local id = tonumber(team[i])
                    if id ~= nil and id > 0 then
                        local char = Char:new(id)
                        dictList[char.dictid] = 1
                    end
                end
            end
            local team2 = self:getXiaoHuoBanTeam()
            for i = 1, #team2 do
                local id = tonumber(team2[i])
                if id ~= nil and id > 0 then
                    local char = Char:new(id)
                    dictList[char.dictid] = 1
                end
            end
        elseif self.module == "teamer" then --替换小伙伴
            local team = self:getTeam()
            for i = 1, #team do
                local id = tonumber(team[i])
                if id ~= nil and id > 0 then
                    local char = Char:new(id)
                    dictList[char.dictid] = 1
                end
            end
            local team2 = self:getXiaoHuoBanTeam()
            for i = 1, #team2 do
                if i~=self.pos_index then
                    local id = tonumber(team2[i])
                    if id ~= nil and id > 0 then
                        local char = Char:new(id)
                        dictList[char.dictid] = 1
                    end
                end
            end
        end
	end
	for k, v in pairs(chars) do
		local char = Char:new(k, v)
		if c == "daili" then 
			if m:checkChar(char.id) == true and char.id ~= Player.Info.playercharid then 
				table.insert(teamList, char)
			elseif m:checkFriend(char.id) == true then 
				table.insert(huobanList, char)	
			end 
		end 
		
		if isShow(char.id) then
			-- 去除同名卡
			if c ~= "daili" then 
				if dictList[char.dictid] == nil then 
					--dictList[char.dictid] = 1
					if self.delegate.onFilter then
						if self.delegate:onFilter(char) then
							table.insert(charsList, char)
						end
					else
						table.insert(charsList, char)
					end
				end 
			else 
				if dictList[char.dictid] == nil then 
					--dictList[char.dictid] = 1
					--if m:checkChar(char.id) == true then char.onteam = 1 end 
					if self.delegate.onFilter then
						if self.delegate:onFilter(char) then
							table.insert(charsList, char)
						end
					else
						table.insert(charsList, char)
					end
				else
					--print("同名： " .. char.dictid)
				end 
			end 
		end
	end
	
    table.sort(charsList, function(a, b)
        if a.teamIndex ~= b.teamIndex then return a.teamIndex < b.teamIndex end
        if a.Table.sort_level ~= b.Table.sort_level then return a.Table.sort_level > b.Table.sort_level end
        if a.dictid ~= b.dictid then return a.dictid > b.dictid end
		if a.stage ~= b.stage then return a.stage > b.stage end
        if a.power ~= b.power then return a.power > b.power end
		--if m:checkChar(a) or
        return a.id < b.id
    end)
	
	table.sort(teamList, function(a, b)
        if a.teamIndex ~= b.teamIndex then return a.teamIndex > b.teamIndex end
        if a.Table.sort_level ~= b.Table.sort_level then return a.Table.sort_level < b.Table.sort_level end
        if a.dictid ~= b.dictid then return a.dictid < b.dictid end
		if a.stage ~= b.stage then return a.stage < b.stage end
        if a.power ~= b.power then return a.power < b.power end
		--if m:checkChar(a) or
        return a.id > b.id
    end)
	table.sort(huobanList, function(a, b)
        if a.teamIndex ~= b.teamIndex then return a.teamIndex > b.teamIndex end
        if a.Table.sort_level ~= b.Table.sort_level then return a.Table.sort_level < b.Table.sort_level end
        if a.dictid ~= b.dictid then return a.dictid < b.dictid end
		if a.stage ~= b.stage then return a.stage < b.stage end
        if a.power ~= b.power then return a.power < b.power end
		--if m:checkChar(a) or
        return a.id > b.id
    end)
	
	for i = 1, #huobanList do 
		if self.delegate.onFilter then
			if self.delegate:onFilter(huobanList[i]) then
				table.insert(charsList, 1, huobanList[i])
			end
		else
			table.insert(charsList, 1, huobanList[i])
		end
	end 
	for i = 1, #teamList do 
		if self.delegate.onFilter then
			if self.delegate:onFilter(teamList[i]) then
				table.insert(charsList, 1, teamList[i])
			end
		else
			table.insert(charsList, 1, teamList[i])
		end
	end 
	
	if #charsList == 0 then
        UIMrg:popWindow()
        DialogMrg.ShowDialog(TextMap.GetValue("Text1388"), function()
            UIMrg:popWindow()
            uSuperLink.openModule(1)
        end, function() end, TextMap.GetValue("Text1136"), "openModule")
        return
    end

    if c ~= "daili" then 
		-- TODO  羁绊还没有配置
        --charsList = self:configFetterNumber(charsList)
    end
    
    charsList = self:getData(charsList)
    self.scrollView:refresh(charsList, self, false, 0)
    self.binding:Hide("txt_has_select")
    self.binding:Hide("txt_power")
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

--获取小伙伴队列
function m:checkFriend(charId)
    local teams = Player.Team[12].chars
    local list = {}
    for i = 0, 7 do
        if tonumber(teams[i]) == charId then
            return true
        end
    end
    return false
end

--计算每个角色上阵后能激活多少条羁绊
function m:configFetterNumber(charList)
    if charList == nil then return end
    --模拟上阵
    if self.delegate.getTeam then
        for i = 1, #charList do
            local team = self.delegate:getTeam()
            local friend = self.delegate:getXiaoHuoBanTeam()
            if self.module == "formation" or self.module == "ghost" then --替换主阵上的角色
                team[self.pos_index] = charList[i].id
                local number = self:config(team, friend, charList[i].dictid)
                charList[i].fetter_number = number
            elseif self.module == "teamer" then --替换小伙伴
                friend[self.pos_index] = charList[i].id
                local number = self:config(team, friend, charList[i].dictid)
                charList[i].fetter_number = number
            end
        end
    end
    return charList
end

--获取上阵角色队列
function m:getTeam()
    local teams = Player.Team[0].chars
    local list = {}
    self.team_count = 0
    for i = 0, 5 do
        if teams.Count > i then
            list[i + 1] = teams[i]
            if teams[i] ~= 0 and teams[i] ~= "0" then
                self.team_count = self.team_count + 1
            end
        else
            list[i + 1] = 0
        end
    end
    return list
end

--获取小伙伴队列
function m:getXiaoHuoBanTeam(...)
    local teams = Player.Team[12].chars
    local list = {}
    for i = 0, 7 do
        if teams.Count > i then
            list[i + 1] = teams[i]
        else
            list[i + 1] = 0
        end
    end
    return list
end

function m:config(team, friend, target)
    local relationid =TableReader:TableRowByID("char",target).relationid
    if team == nil and friend == nil then return 0 end
    local number = 0
    local list_1 = {}
    table.foreachi(team, function(i, v)
        table.insert(friend, v)
    end)
    --筛选出阵位上的角色与小伙伴上的角色的所有羁绊的触发条件中有目标角色id
    for j = 1, 6 do
        local id = team[j]
        if id ~= nil and id ~= 0 and id ~= "0" then
            local line = TableReader:TableRowByID("avter", Tool.getDictId(id))
            if line.relationship ~= nil then
                for i = 0, line.relationship.Count do
                    if line.relationship[i] ~= nil and line.relationship[i] ~= "" then
                        local tb = TableReader:TableRowByID("relationship", line.relationship[i])
                        for k = 0, 5 do
                            if tb.drop[k] ~= nil then
                                if tb.drop[k].condition_value ~= nil then
                                    if tb.drop[k].condition_value == relationid then
                                        local flag = self:checkFetter(tb, friend)
                                        if flag == true and tb.type == "char" then
                                            list_1["" .. tb.id] = 1
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end
    end
    table.foreach(list_1, function(i, v)
        if v == 1 then
            number = number + 1
        end
    end)
    return number
end

--检测某条羁绊的触发条件都满足
function m:checkFetter(tb, friend)
    for k = 0, 5 do
        if tb.drop[k] ~= nil then
            if tb.drop[k].condition_value ~= nil then
                if self:check(tb.drop[k].condition_value, friend) == false then
                    return false
                end
            end
        end
    end
    return true
end

--检测某个触发条件是否满足
function m:check(condition, friend)
    for i = 1, 14 do
        local id =friend[i]
        if id ~= nil and id ~= 0 and id ~= "0" then
            local relationid =TableReader:TableRowByID("char",Tool.getDictId(id)).relationid
            if tonumber(condition) == tonumber(relationid) then
                return true
            end
        end
    end
    return false
end


function m:onCallBack(char, tp)
    self.delegate:onCallBack(char, tp)
end

function m:Start()
    self.max_slot = Player.Resource.max_slot
    if self.max_slot > 6 then self.max_slot = 6 end
end

function m:getChars(teams, ret)
    self.teamList = {}
    local hasChar = {}
    for i = 1, 6 do
        hasChar[teams[i] .. ""] = i
        self.teamList[i] = teams[i]
    end
    local chars = Player.Chars:getLuaTable()
    self._count = 0
    local charsList = {}

    if not ret then
        local index = 1
        for k, v in pairs(chars) do
            local char = Char:new(k, v)
            local filter = false
            if self.team_limit_type == "level" then
                filter = char.lv >= self.team_limit_arg
            elseif self.team_limit_type == "sex" then
                filter = char.sex == self.team_limit_arg
            end
            if filter then
                if hasChar[char.id .. ""] ~= nil then
                    char.isSelected = true
                    self._count = self._count + 1
                    char.formation_pos = hasChar[char.id .. ""]
                else
                    char.isSelected = false
                    char.formation_pos = 7
                end

                charsList[index] = char
                index = index + 1
            end
        end
        table.sort(charsList, function(a, b)
            if a.formation_pos ~= b.formation_pos then return a.formation_pos < b.formation_pos end
            if a.star ~= b.star then return a.star > b.star end
            if a.stage ~= b.stage then return a.stage > b.stage end
            if a.power ~= b.power then return a.power > b.power end
            return a.id < b.id
        end)
        charsList = self:getData(charsList)
    else
        table.foreach(self.charList, function(i, v)
            table.foreach(v, function(index, char)
                if hasChar[char.id .. ""] ~= nil then
                    char.isSelected = true
                    self._count = self._count + 1
                    char.formation_pos = hasChar[char.id .. ""]
                else
                    char.isSelected = false
                    char.formation_pos = 7
                end
            end)
        end)
        return self.charList
    end
    return charsList
end

function m:pushToTeam(char, ret)
	if self.teamList == nil then self.teamList = {} end 
    if ret and self.fristIndex ~= -1 then
        if self.teamList[self.fristIndex] == 0 or self.teamList[self.fristIndex] == "0" then
            self.teamList[self.fristIndex] = char.id
            local pos = self.fristIndex
            self.fristIndex = -1
            local full = self:isFull()
            if full then
                self.team = self.teamList
                self:refresh(true)
            end
            return pos
        end
    end

    for i = 1, 6 do
        local id = self.teamList[i] .. ""
        if ret and id == "0" then
            self.teamList[i] = char.id
            if self:isFull() then
                self.team = self.teamList
                self:refresh(true)
                return -1
            end
            return i
        elseif not ret and id == char.id .. "" then
            local full = self:isFull()
            self.teamList[i] = 0
            if full then
                self.team = self.teamList
                self:refresh(true)
                return -1
            end
            return i
        end
    end

    return 7
end

function m:isFull()
    return self:getTeamCount() >= self.max_slot
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
                d.realIndex = i + j
                li[j + 1] = d
                len = len + 1
				d.type = self._type
            end
        end
        if len > 0 then
            table.insert(list, li)
        end
    end

    return list
end

function m:getTeamCount()
    local index = 0
    table.foreach(self.teamList, function(i, v)
        if v ~= "0" and v ~= 0 then
            index = index + 1
        end
    end)
    return index
end

function m:setInfo()
    local max_slot = Player.Resource.max_slot
    if max_slot > 6 then max_slot = 6 end
    self.txt_has_select.text =string.gsub(TextMap.GetValue("Text71"),"{0}",self:getTeamCount() .. "/" .. max_slot)
    local power = 0
    table.foreach(self.teamList, function(i, v)
        if v ~= "0" and v ~= 0 then
            local char = Char:new(v)
            power = power + char.power
        end
    end)
    self.txt_power.text = power --TextMap.getText("TXT_TEAM_POWER", { power })
end

function m:refresh(ret)
    self.charList = self:getChars(self.team, ret)
    self.scrollView:refresh(self.charList, self, false, 0)
    self:setInfo()
end

function m:equlpsTeam(team)
    for i = 1, 6 do
        if self.old_team[i] ~= team[i] then
            return true
        end
    end
    return false
end

function m:saveTeam(go)
    if not self:equlpsTeam(self.teamList) then
        UIMrg:popWindow()
        return
    end
    Api:saveTeam(self.teamList, self.team_type, function(result)
        UIMrg:popWindow()
    end, function()
        return false
    end)
end

function m:onClick(go, name)
    if name == "btnBack" then
		UIMrg:popWindow()
        --if self._type == "single" then
        --    UIMrg:popWindow()
        --    return
        --end
        --if self.module == "formation" then
        --    self:saveTeam(go)
        --elseif self.module == "teamer" then
        --    print("teame=============")
        --end
    end
end

return m

