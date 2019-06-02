
-- 选择角色列表
local m = {}

function m:update(lua)
    self.delegate = lua.delegate
    self.pos_index = lua.index
	self.max = lua.max
	
	self.data = lua.data
	self.type = lua.type
	self.selectList = lua.selectList
	if self.type == "char" then 
		self.char = lua.char
		m:showSingle()
	elseif self.type == "pet" then 
		self.char = lua.pet
		m:showPetMaterial()
	end 
	m:setInfo()
end

function m:isSelected(charid)
	if self.selectList == nil then return false end 
	if #self.selectList > self.max then return end
	for i = 1, #self.selectList do 
		if self.type == "char" and self.selectList[i] == charid then return true end 
		if self.type == "pet" and self.selectList[i].realIndex == charid then return true end 
	end 
	return false
end 

function m:showPetMaterial()
    local ids = {}
	local items = {}
	local list = getServerPackDataBySubType("item", "petItem", Player.ItemBag)
	table.sort(list, function(a, b)
		return a.itemTrueColor > b.itemTrueColor
	end)
	for i = 1, #list do
        local item = list[i]
		for j = 1, item.itemCount do 
			--if #items >= 50 then break end 
			table.insert(items, { itemid = item.itemID, exp = item.itemTable.exp })
		end 
    end

    if #items == 0 then
        UIMrg:popWindow()
        DialogMrg.ShowDialog(TextMap.GetValue("Text1810"), function()
            UIMrg:popWindow()
            uSuperLink.openModule(15)
        end, function() end, TextMap.GetValue("Text1136"), "openModule")
        return
    end
    table.sort(items, function(a, b)
        return a.exp > b.exp
    end)
    items = self:getData(items)
	for i = 1, #items do
        local item = items[i]
		for j = 1, #item do 
			local cell = item[j]
			cell.isSelected = self:isSelected(cell.realIndex)
			if cell.isSelected then 
				self:pushToTeam(cell)
			end 
		end
    end
	
    self.scrollView:refresh(items, self, false, 0)
	self:updatePetDes()
end

function m:updatePetDes()
	local lvexp = self.char:GetPetExp(self.char.lv, self.char.star)
	local cur = m:getCurrentExp()
	local exp = (lvexp - cur)
	if exp < 0 then exp = 0 end 
	self.txt_need_exp.text = TextMap.GetValue("Text_1_787") .. exp
end 


function m:showSingle()
    local ids = {}

    local function isShow(id)
        if ids[id .. ""] then
            return false
        end
        return true
    end

    local chars = Player.Chars:getLuaTable()
	local whiteList = {}
    local charsList = {}
    for k, v in pairs(chars) do
        local char = Char:new(k, v)
		if char.Table.can_lvup_yjtj == 1 then	
			char.isSelected = self:isSelected(char.id)
			if char.isSelected then 
				self:pushToTeam(char)
			end 
			--if isShow(char.id) then
				if self.delegate.onFilter then
					if self.delegate:onFilter(char) then
						if char.star < 2 then 
							table.insert(whiteList, char)
						else 
							table.insert(charsList, char)
						end 
					end
				else
					if char.star < 2 then 
						table.insert(whiteList, char)
					else 
						table.insert(charsList, char)
					end 
				end
			--end
		end
    end
    if #charsList == 0 and #whiteList == 0 then
        UIMrg:popWindow()
        DialogMrg.ShowDialog(TextMap.GetValue("Text1388"), function()
            UIMrg:popWindow()
            uSuperLink.openModule(1)
        end, function() end, TextMap.GetValue("Text1136"), "openModule")
        return
    end
    table.sort(charsList, function(a, b)
        --if a.teamIndex ~= b.teamIndex then return a.teamIndex > b.teamIndex end
		--if a.star ~= b.star then return a.star < b.star end
		if a.Table.sort_level ~= b.Table.sort_level then return a.Table.sort_level < b.Table.sort_level end 
        --if a.stage ~= b.stage then return a.stage < b.stage end
        --if a.power ~= b.power then return a.power < b.power end
        return a.id < b.id
    end)
	for i = 1, #whiteList do 
		table.insert(charsList, 1, whiteList[i])
	end 
    
    charsList = self:getData(charsList)
    self.scrollView:refresh(charsList, self, false, 0)
	self:updateDes()
end

function m:updateDes()
	local lvexp = GetCharExp(self.char.lv, self.char.quality)
	local cur = m:getCurrentExp()
	local exp = (lvexp - cur)
	if exp < 0 then exp = 0 end 
	self.txt_need_exp.text = TextMap.GetValue("Text_1_787") .. exp
end 

function m:getCurrentExp()
	local total = self.char.info.exp
	local lv = self.char.lv
	local lvupExp = 0
	if self.type == "char" then -- 满足89级的经验，就升级到90
		lvupExp = GetCharTotalExp(lv-1, self.char.quality)
	elseif self.type == "pet" then 
		lvupExp = self.char:GetPetTotalExp(lv-1, self.char.star)
	end 
	if total >= lvupExp then 
		total = total - lvupExp
	end 
	return total
end

function m:onCallBack(char, tp)
    --self.delegate:onCallBack(char, tp)
end

function m:Start()
     -- 5个材料  --Player.Resource.max_slot
    --if self.max_slot > 5 then self.max_slot = 5 end
	self.teamList = {}
end


function m:isFull()
    return self:getTeamCount() > self.max
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
				d.type = self.type
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

function m:getTeamCount()
    local index = 1
    table.foreach(self.teamList, function(i, v)
        if v ~= "0" and v ~= 0 then
            index = index + 1
        end
    end)
    return index
end

function m:setInfo()
    local exp = 0
    table.foreach(self.teamList, function(i, v)
        if v ~= "0" and v ~= 0 then
			local char = nil
			if self.type == "char" then 
				char = Char:new(v.id)
				exp = exp + char.Table.exp + char.info.exp
			elseif self.type == "pet" then 
				char = v
				exp = exp + char.exp
			end 
        end
    end)
	self.txt_get_exp.text = TextMap.GetValue("Text_1_788") .. exp
end

function m:pushToTeam(char, ret)
    local count = m:getTeamCount()
    if count > self.max then 
		if self.max == 5 then MessageMrg.showMove(TextMap.GetValue("Text_1_789")) 
		else MessageMrg.showMove(TextMap.GetValue("Text_1_783")) end 
		return 
	end

	if self.type == "char" then 
		self.teamList[char.id] = char
	elseif self.type == "pet" then 
		self.teamList[char.realIndex] = char
	end
end

function m:popToTeam(char, ret)
	if self.type == "char" then 
		self.teamList[char.id] = nil
   	elseif self.type == "pet" then 
		self.teamList[char.realIndex] = nil
	end
end

function m:onClick(go, name)
    if name == "btnBack" then
		UIMrg:popWindow()
	elseif name == "btn_ok" then 
		self.delegate:onCallBack(self.teamList, tp)
		UIMrg:popWindow()
    end
end

return m

