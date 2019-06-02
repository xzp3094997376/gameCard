-- 选择角色列表
local m = {}

function m:update(lua)
    self.delegate = lua.delegate
    m:showHeros()
end

function m:showHeros()
    local chars = Player.Chars:getLuaTable()
    local charsList = {}
	for k, v in pairs(chars) do
		local char = Char:new(k, v)
        char.mType = "char"
		if self.delegate.onFilter and self.delegate:onFilter(char) then
			table.insert(charsList, char)
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

    for k, v in pairs(chars) do
        local char = Char:new(k, v)
        char.mType = "char"
        if self.delegate.onCheckCantHero and self.delegate:onCheckCantHero(char) then
            table.insert(charsList, char)
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

    charsList = self:getData(charsList)
    self.scrollView:refresh(charsList, self, false, 0)
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

function m:onClick(go, name)
    if name == "btnBack" then
		UIMrg:popWindow()
    end
end

return m

