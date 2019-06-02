
-- 选择角色列表
local m = {}
-- data 
-- data.type
-- data.title
-- data.str_btn1
-- data.str_btn2
-- data.des1
-- data.des2

-- data.type = 1  出售忍者
-- data.type = 2  出售装备
-- data.type = 3  出售宝物
-- data.type = 4  出售忍灵

function m:update(lua)
    self.delegate = lua.delegate
    self.pos_index = lua.index
	self.type = lua.type
    m:onUpdate()
end



function m:onUpdate()
	self.sellType = nil 
	local list = nil 
	local str = ""
	self.btn_select.gameObject:SetActive(true)
	if self.type == 1 then 
		list = m:getListByHero()
		str = TextMap.GetValue("Text_1_773")
	elseif self.type == 2 then 
		self.btn_select.gameObject:SetActive(false)
		list = m:getListByEquip()
		str = TextMap.GetValue("Text_1_329")
	elseif self.type == 3 then 
		self.btn_select.gameObject:SetActive(false)
		list = m:getListByTreasure()
		str = TextMap.GetValue("Text_1_774")
    elseif self.type == 4 then 
        self.btn_select.gameObject:SetActive(false)
        list = m:getListByRenLing()
        str = TextMap.GetValue("Text_1_2965")
	end 
	
	if list == nil or #list == 0 then
		MessageMrg.show(TextMap.GetValue("Text_1_775").. str .. "！")
        self.scrollView:refresh({}, self)
		return 
	end 
	
    for k,v in pairs(list) do 
        if v.star == 1 then 
            if self.select_star_one~=nil and self.select_star_one==true then 
                v.isSelect = true 
                m:pushToTeam(v,true)
            else 
                v.isSelect=false
            end
        elseif v.star == 2 then 
            if self.select_star_two~=nil and self.select_star_two == true then 
                m:pushToTeam(v,true)
                v.isSelect=true 
            else 
                v.isSelect=false
            end
        elseif v.star == 3 then 
            if self.select_star_three ~= nil and self.select_star_three == true then 
                m:pushToTeam(v,true)
                v.isSelect = true 
            else 
                v.isSelect = false
            end
        end
    end
    list = self:getData(list)
    self.scrollView.gameObject:SetActive(true)
    self.scrollView:refresh(list, self)
    self.selectIndex = m:getGotoIndex(list)
	print("self.selectIndex = " .. self.selectIndex)
    self.binding:CallAfterTime(0.1,function()
        self.scrollView:goToIndex(self.selectIndex)
    end)
    self:updateDes()
    
    self.select_star_three=false
    self.select_star_two=false
    self.select_star_one=false
end

function m:create(binding)
    self.binding = binding
    return self
end

function m:getGotoIndex(list)
    if #list>0 then 
        for i=1,#list do 
            if self.select_star_three~=nil and self.select_star_three==true then 
                if list[i][1] and list[i][1].star== 3 or list[i][2] and list[i][2].star== 3 then 
                    return i-1
                end
            end
            if self.select_star_two~=nil and self.select_star_two==true then 
                if list[i][1] and list[i][1].star== 2 or list[i][2] and list[i][2].star== 2 then 
                    return i-1
                end
            end
            if self.select_star_one~=nil and self.select_star_one==true and list[i][1] ~= nil then 
				if list[i][1] and list[i][1].star== 1 or list[i][2] and list[i][2].star== 1 then 
                    return i-1
                end
            end 
        end
    end
    return 0
end

function m:getListByHero()
    local chars = Player.Chars:getLuaTable()
    local charsList = {}
    for k, v in pairs(chars) do
        local char = Char:new(k, v)
		if self.sellType == nil then 
			self.sellType = char.Table.sell_type
		end 
        if self.delegate.onFilter then
            if self.delegate:onFilter(char) then
				-- 按照星级再次过滤
				if self:onFilter(char) then 
					table.insert(charsList, char)
				end 
            end
        else
            table.insert(charsList, char)
        end
    end
    --if #charsList == 0 then
    --    UIMrg:pop()
    --    DialogMrg.ShowDialog(TextMap.GetValue("Text1388"), function()
    --        UIMrg:popWindow()
    --        uSuperLink.openModule(1)
    --    end, function() end, TextMap.GetValue("Text1136"), "openModule")
    --    return
    --end
    table.sort(charsList, function(a, b)
        if a.teamIndex ~= b.teamIndex then return a.teamIndex > b.teamIndex end
        if a.star ~= b.star then return a.star < b.star end
        if a.stage ~= b.stage then return a.stage < b.stage end
        if a.power ~= b.power then return a.power < b.power end
        return a.id < b.id
    end)
	return charsList
end 

local function isUsed(list, key)
    return list[key .. ""] ~= nil
end

function m:getListByEquip()
	local ghostList = {}
    local ghost = Player.Ghost:getLuaTable() or {}
    local hasUse = m:getHasUseGhost() or {}

    local equipList = {  }
    local list = {  }
    table.foreach(ghost, function(i, v)
        local gh = Ghost:new(v.id, i)
		if self.sellType == nil then 
			self.sellType = gh.Table.sell_type
		end 
        if not isUsed(hasUse, i) then
			if self.delegate.onFilter then
				if self.delegate:onFilter(char) then
					-- 按照星级再次过滤
					--if self:onFilter(char) then 
									table.insert(ghostList, gh)
					--end 
				end
			else
				table.insert(ghostList, gh)
			end
        end
    end)
	
    --table.sort(equipList, function(a, b)
    --    if a.star ~= b.star then return a.star < b.star end
    --    if a.lv ~= b.lv then
    --        return a.lv < b.lv
    --    end
    --    return a.id > b.id
    --end)

    table.sort(ghostList, function(a, b)
        if a.star ~= b.star then return a.star < b.star end
        if a.lv ~= b.lv then
            return a.lv < b.lv
        end
        return a.id > b.id
    end)

   --local len = #list
   --if len > 0 then
   --    for i=1,#list do
   --        local v = list[i]
   --        table.insert(ghostList, 1, v)
   --    end
   --end
   --
   --for i = 1, #equipList do
   --    local v = equipList[i]
   --    table.insert(ghostList, 1, v)
   --end
	equipList = nil
	return ghostList
end 

function m:getHasUseGhost()
    local ghostSlot = Player.ghostSlot
    local list = {}
    for i = 0, 5 do
        local slot = ghostSlot[i]
        local postion = slot.postion
        local len = postion.Count
        for j = 0, len - 1 do
            local pos = postion[j]
            if pos ~= nil and pos ~= "" and pos ~= 0 then
                list[pos .. ""] = slot.charid
            end
        end
    end
    return list
end

function m:getListByRenLing()
    local renlingList = {} --未装备的所有忍灵
    local renling = Player.renlingBag:getLuaTable()
    --local openLv = TableReader:TableRowByID("renling_config",5).value2
    --local maxStar = TableReader:TableRowByID("renling_config",6).value2
    local activeList = Player.renling
    for k,v in pairs(renling) do
        local _renling = RenLing:new(v.id)
        if self.sellType == nil then 
            self.sellType = "lingyu"
        end 
        _renling.count=v.count
        table.insert(renlingList, _renling)
        -- local haveNum = 0
        -- for i=0,_renling.Table.show.Count-1 do
        --     local id = _renling.Table.show[i]
        --     local row = TableReader:TableRowByID("renling_group",id)
        --     if activeList[row.group]~=nil and activeList[row.group][id] ~=nil and tonumber(activeList[row.group][id].level)>=1 then 
        --         local star = tonumber(activeList[row.group][id].level)
        --         if Player.Info.level>=tonumber(openLv) and star<tonumber(maxStar) then 
        --             haveNum=haveNum+1
        --         end 
        --     else 
        --         haveNum=haveNum+1
        --     end 
        -- end
        -- if haveNum ==0 then 
        --     table.insert(renlingList, _renling)
        -- end 
    end

    table.sort(renlingList, function(a, b)
        if a.star ~= b.star then return a.star < b.star end
        return a.id > b.id
    end)

    if #renlingList == 0 then
        return {}
    end
    return renlingList
end

function m:getHasUseGhost()
    local ghostSlot = Player.ghostSlot
    local list = {}
    for i = 0, 5 do
        local slot = ghostSlot[i]
        local postion = slot.postion
        local len = postion.Count
        for j = 0, len - 1 do
            local pos = postion[j]
            if pos ~= nil and pos ~= "" and pos ~= 0 then
                list[pos .. ""] = slot.charid
            end
        end
    end
    return list
end

function m:getListByTreasure()
	local treasuresList = {} --未装备的所有宝物
    local treasures = Player.Treasure:getLuaTable()

    local list = {} 
    local explist = {} --经验宝物
    for k,v in pairs(treasures) do
        local _treasure = Treasure:new(v.id, k)
	   	if self.sellType == nil then 
			self.sellType = _treasure.Table.sell_type
		end 
        if v.onPosition then
            --table.insert(list, _treasure)
        else
            if _treasure.kind == "jing" then
                table.insert(explist, _treasure)
            else
                table.insert(treasuresList, _treasure)
            end
        end
    end

    -- 排列未装备的宝物
    table.sort(treasuresList, function(a, b)
        if a.star ~= b.star then return a.star < b.star end
        if a.power ~= b.power then return a.power < b.power end
        if a.lv ~= b.lv then return a.lv < b.lv end
        return a.id > b.id
    end)

    --排列装备的宝物
    table.sort(list, function(a, b)
        if a.star ~= b.star then return a.star < b.star end
        if a.power ~= b.power then return a.power < b.power end
        if a.lv ~= b.lv then return a.lv < b.lv end
        return a.id > b.id
    end)

    --排列EXP宝物
    table.sort(explist, function(a, b)
        if a.star ~= b.star then return a.star < b.star end
        return a.id > b.id
    end)


    for i = 1, #treasuresList do
        local v = treasuresList[i]
        table.insert(list, v)
    end

    for i=1,#explist do
        local sz = explist[i]
        table.insert(list, sz)
    end

    if #list == 0 then
        return {}
    end
    return list
end

function m:updateDes()
	-- 出售英雄
	--if self.type == 1 then 
	--end 
	--self.txt_title.text = TextMap.GetValue("Text_1_349")
	self.txt_select.text = TextMap.GetValue("Text_1_350")
	self.txt_action.text = TextMap.GetValue("Text_1_349")
	self.txt_get_exp.text = TextMap.GetValue("Text_1_351") .. self.value1
	self.txt_need_exp.text = TextMap.GetValue("Text_1_352") .. self.value2
	self.img_icon:setImage(Tool.getResIcon(self.sellType), "itemImage")
end 


function m:onCallBack() 
    self.teamList={}
    local list = nil 
    if self.type == 1 then 
        list = m:getListByHero()
    elseif self.type == 2 then 
        list = m:getListByEquip()
    elseif self.type == 3 then 
        list = m:getListByTreasure()
    elseif self.type == 4 then 
        list = m:getListByRenLing()
    end 
    if list == nil or #list == 0 then
        self.scrollView:refresh({}, self)
        return 
    end 
    
    for k,v in pairs(list) do 
        if v.star == 1 then 
            if self.select_star_one~=nil and self.select_star_one==true then 
                v.isSelect = true 
                m:pushToTeam(v,true)
            else 
                v.isSelect=false
            end
        elseif v.star == 2 then 
            if self.select_star_two~=nil and self.select_star_two == true then 
                m:pushToTeam(v,true)
                v.isSelect=true 
            else 
                v.isSelect=false
            end
        elseif v.star == 3 then 
            if self.select_star_three ~= nil and self.select_star_three == true then 
                m:pushToTeam(v,true)
                v.isSelect = true 
            else 
                v.isSelect = false
            end
        end
    end
    list = self:getData(list)
    self.scrollView.gameObject:SetActive(true)
    self.scrollView:refresh(list, self)
    self.selectIndex = m:getGotoIndex(list)
    self.binding:CallAfterTime(0.1,function()
        self.scrollView:goToIndex(self.selectIndex)
    end)
    self:updateDes()
end

function m:Start()
	Tool.loadTopTitle(self.gameObject, TextMap.GetValue("Text_1_349"))
	LuaMain:ShowTopMenu()
	self.value1 = 0
	self.value2 = 0
	self.teamList = {}
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
            if self.type==4 then 
                index = index + v.count
            else 
                index = index + 1
            end 
        end
    end)
    return index
end

function m:setInfo()
    local num = 0
    table.foreach(self.teamList, function(i, v)
        if v ~= "0" and v ~= 0 then
			local data = nil 
			if self.type == 1 then 
				data = Char:new(v.id)
                num = num + data.Table.sell
			elseif self.type == 2 then 
				data = Ghost:new(v.id, v.key)
                num = num + data.Table.sell
			elseif self.type == 3 then 
				data = Treasure:new(v.id, v.key)
                num = num + data.Table.sell
            elseif self.type == 4 then 
                data = RenLing:new(v.id)
                num = num + data.Table.sell*v.count
			end 
			--if data.Table.can_sell == 1 then 
				
			--end 
        end
    end)
	self.value1 = m:getTeamCount()
	self.value2 = num
	self:updateDes()
end

function m:onFilterCallback(star)
	if self.starList[star] == nil then 
		self.starList[star] = 1
	else 
		self.starList[star] = nil
	end 
end 

function m:onFilter(char)
	if self.starList == nil or #self.starList <= 0 then 
		return true
	else 
		if self.starList[char.star] ~= nil then 
			return true 
		else 
			return false 
		end 
	end  
end 

function m:pushToTeam(char, ret)
	if self.type == 1 then 
		self.teamList[char.id] = char
	elseif self.type == 2 or self.type == 3 then 
		self.teamList[char.key] = char
    elseif self.type==4 then  
        self.teamList[char.id] = char
	end 
end

function m:popToTeam(char, ret)
  	if self.type == 1 then 
		self.teamList[char.id] = nil		
   	elseif self.type == 2 or self.type == 3 then 
		self.teamList[char.key] = nil
    elseif self.type == 4 then 
        self.teamList[char.id] = nil
	end 
end

function m:onClick(go, name)
    if name == "btnBack" then
        local delegate = self.delegate
		UIMrg:pop() 
	elseif name == "btn_select" then 
		m:onFilterPanel()
	elseif name == "btn_ok" then 
		self.delegate:onSaleCallBack(self.teamList,self)
    end
end

function m:onFilterPanel()
	self.starList = {}
	UIMrg:pushWindow("Prefabs/moduleFabs/hero/gui_select_filter", {delegate = self})
end 

return m

