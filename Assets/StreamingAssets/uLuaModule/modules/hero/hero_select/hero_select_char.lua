
local m = {}

local cusrIndex = 0

function m:update(lua, flag)
    if self.mType == "pet" then
        self.gui_get_help.gameObject:SetActive(false)
    end
    local list = self:getShowList()
	self:updateView(list, flag or true)
end

function m:updateView(list, flag)
	if self.tab == 1 then 
		self.scrollView_hero.gameObject:SetActive(true)
		self.scrollView_hero:refresh(list, self, false, -1)
        self.binding:CallAfterTime(0.1,function()
            self.scrollView_hero:goToIndex(0)
        end) 
		self.scrollView_piece.gameObject:SetActive(false)
		if self.photos ~= nil then 
			self.photos.gameObject:SetActive(false)
		end
		--if flag == true then 
        if self.isScroll then
			self.binding:CallAfterTime(0.1, function()
				self.scrollView_hero:ResetPosition()
			end)
        end
		--end 
	elseif self.tab == 2 then  
		self.scrollView_piece.gameObject:SetActive(true)
		self.scrollView_piece:refresh(list, self, false, -1)
		self.scrollView_hero.gameObject:SetActive(false)
		if self.photos ~= nil then 
			self.photos.gameObject:SetActive(false)
		end 
        if self.isScroll then
            self.binding:CallAfterTime(0.1, function()
                self.scrollView_piece:ResetPosition()
            end)
        end
	elseif self.tab == 3 then 
		self.scrollView_piece.gameObject:SetActive(false)
		self.scrollView_hero.gameObject:SetActive(false)
		if self.photos == nil then 
			self.photos = ClientTool.loadAndGetLuaBinding("Prefabs/moduleFabs/pet/gui_pet_photo", self.con)
		end
		self.photos:CallUpdate({ delegate = that })
		self.photos.gameObject:SetActive(true)
        self.ShowNum.gameObject:SetActive(false)
	end
end 

function m:updateLocal()
	if self.tab == 1 then 
		self.scrollView_hero:updateLocal()
	elseif self.tab == 2 then  
		self.scrollView_piece:updateLocal()
	end
end

--更新列表
function m:onUpdate(flag)
	if self.mType == "char" then 
		--self.btn_tujian:SetActive(false)
	end 
    local list = {}
    if self.tab == 1 then
        if self.mType == "char" then 
			list = self:showHeroList()
			self.btn_sale.gameObject:SetActive(true)
		elseif self.mType == "pet" then 
			list = self:showPetList()
			self.img_tujian_Up:SetActive(false)
		end 
		self.img_hero:SetActive(true)
		self.img_pice_Up:SetActive(false)
    elseif self.tab == 2 then
		if self.mType == "char" then 
			list = self:showPiceList()
			self.btn_sale.gameObject:SetActive(false)
		elseif self.mType == "pet" then 
			list = self:showPetPiceList()
			self.img_tujian_Up:SetActive(false)
            self.gui_get_help.gameObject:SetActive(false)
			-- if self.helpUI ~= nil then 
			-- 	self.helpUI.gameObject:SetActive(false)--UIMrg:popWindow() 
			-- end 
		end
		self.img_hero:SetActive(false)
		self.img_pice_Up:SetActive(true)
	elseif self.tab == 3 then 
		if self.mType == "pet" then 
            self.gui_get_help.gameObject:SetActive(false)
			-- if self.helpUI ~= nil then 
			-- 	self.helpUI.gameObject:SetActive(false)--UIMrg:popWindow() 
			-- end 
			self.img_tujian_Up:SetActive(true)
		else
			self.btn_sale.gameObject:SetActive(false)
		end 
		self.img_hero:SetActive(false)
		self.img_pice_Up:SetActive(false)
    end 
    self:updateView(list, flag)
	
	local red1 = false
	local red2 = false
	if self.mType == "char" then 
		red1 = Tool.checkRedPoint("tujian")  or false
		red2 = Tool.checkRedPoint("char") or false
	else
		red1 = Tool.checkRedPoint("petPiece")  or false
		red2 = Tool.checkRedPoint("pet") or false	
	end 
    self.redPoint_for_pice:SetActive(red1)
	self.redPoint:SetActive(red2)
end

function m:onFilter(char)
	if char.id == Player.Info.playercharid then 
		return false 
	end 
	for i = 1, 6 do
        local it = Player.Agency[i]
        if tonumber(it.charId) == tonumber(char.id) then return false end
    end
	if self:checkFriend(char.id) then return false end 
	if m:isExitTeam(char.id) then return false end
	return true
end


function m:getShowList()
	if self.mType == "char" then 
		if self.tab == 2 then 
			return m:showPiceList()
		else 
			return m:showHeroList()
		end 
	elseif self.mType == "pet" then 
		if self.tab == 2 then 
			return m:showPetPiceList()
		else
			return m:showPetList()
		end
	end 
end

-- 宠物列表
 function m:showPetList()
    self.curNum = 0
    local petsList = {} --所有英雄
    local pets = Player.Pets:getLuaTable()
    local index = 1
    local list = {} --上阵宠物
    local friendList = {} --护佑
    for k, v in pairs(pets) do
        self.curNum = self.curNum + 1
        local pet = Pet:new(k, v)
        pet.tab = self.tab
		if Player.Team[0].pet and Player.Team[0].pet == pet.id then --上阵英雄
			table.insert(list, pet)
		elseif Tool.checkHuyou(pet.id) == true then
			table.insert(friendList,pet)
		else --未上阵英雄
			table.insert(petsList, pet)
		end
    end

    self.ShowNum.gameObject:SetActive(true)
    self.Label_Value_Bag.text = TextMap.GetValue("Text_1_326")..self.curNum.."/"..TableReader:TableRowByID("bagMax", "maxPet")["vip"..Player.Info.vip]

	
    -- 排列未上阵与不是小伙伴的角色
    table.sort(petsList, function(a, b)
        if a.star ~= b.star then return a.star > b.star end
        if a.lv ~= b.lv then
            return a.lv > b.lv
        end
        return a.dictid < b.dictid
    end)

    --排列小伙伴
    table.sort(friendList,function (a,b)
        if a.star ~= b.star then return a.star < b.star end
        if a.lv ~= b.lv then
            return a.lv < b.lv
        end
        return a.dictid > b.dictid
    end)
    local len = #friendList
    if len > 0 then
        for i=1,#friendList do
            local v = friendList[i]
            table.insert(petsList, 1, v)
        end
    end

    for i = 1, #list do
        local v = list[i]
        table.insert(petsList, 1, v)
    end
	
    --if GuideMrg.isPlaying() then 
    --    local pos = 1
    --    for i=1,#petsList do
    --        if petsList[i].id.."" == "19" then 
    --            pos = i
    --        end
    --    end
    --    if pos ~= 1 then 
    --        petsList[1],petsList[pos] = petsList[pos],petsList[1]
    --    end
    --end
	-- 
    petsList = self:getData(petsList)

    if #petsList == 0 then

        if self.tab == 1 and self.mType == "pet" then
            self.gui_get_help.gameObject:SetActive(true)
            self.gui_get_help:CallUpdate({type = "pet", style = 0})
        end

		-- --msg = "当前无宠物"
		-- if self.helpUI == nil then 
  --           self.gui_get_help:SetActive(true)
		-- 	--self.helpUI = UIMrg:pushWindow("Prefabs/publicPrefabs/gui_get_help", {type = "pet", style = 0})
  --           self.gui_get_help:CallUpdate({type = "pet", style = 0})
		-- else 
  --           print("helpUI")
		-- 	self.helpUI.gameObject:SetActive(true)
		-- end 
        return {}
    end
    return petsList
end

-- 是否存在上阵列表中
function m:isExitTeam(id)
    local teams = Player.Team[0].chars
    if teams == nil then
        return false
    end
    for i = 0, 5 do
        if teams.Count > i then
            if tonumber(teams[i]) == id then 
				return true
			end 
        end
    end
    return false
end

--刷新英雄列表
function m:showHeroList()
    self.curNum = 0
    local charsList = {} --所有英雄
    local chars = Player.Chars:getLuaTable()
    local index = 1
    local list = {} --上阵英雄
    local friendList = {} --小伙伴
	local pChar = Char:new(Player.Info.playercharid)
	pChar.tab = self.tab
    for k, v in pairs(chars) do
        self.curNum = self.curNum + 1
        local char = Char:new(k)
        char.tab = self.tab
		if char.id ~= Player.Info.playercharid then 
			if char.teamIndex ~= nil then
				if char.teamIndex <= 6 then --上阵英雄
					table.insert(list, char)
				elseif self:checkFriend(char.id) == true then
					table.insert(friendList,char)
				else --未上阵英雄
					table.insert(charsList, char)
				end
			end
		end 
    end

    self.ShowNum.gameObject:SetActive(true)
    self.Label_Value_Bag.text = TextMap.GetValue("Text_1_326")..self.curNum.."/"..TableReader:TableRowByID("bagMax", "maxTreasure")["vip"..Player.Info.vip]
    
	
    -- 排列未上阵与不是小伙伴的角色
    table.sort(charsList, function(a, b)
        if a.star ~= b.star then return a.star > b.star end
        if a.lv ~= b.lv then
            return a.lv > b.lv
        end
        return a.dictid < b.dictid
    end)

    --排列上阵角色
    table.sort(list, function(a, b)
        if a.star ~= b.star then return a.star < b.star end
        if a.lv ~= b.lv then
            return a.lv < b.lv
        end
        return a.dictid > b.dictid
    end)

    --排列小伙伴
    table.sort(friendList,function (a,b)
        if a.star ~= b.star then return a.star < b.star end
        if a.lv ~= b.lv then
            return a.lv < b.lv
        end
        return a.dictid > b.dictid
    end)
    local len = #friendList
    if len > 0 then
        for i=1,#friendList do
            local v = friendList[i]
            table.insert(charsList, 1, v)
        end
    end

    for i = 1, #list do
        local v = list[i]
        table.insert(charsList, 1, v)
    end
	table.insert(charsList, 1, pChar)
    if GuideMrg.isPlaying() then 
        local pos = 1
        for i=1,#charsList do
            if charsList[i].id.."" == "19" then 
                pos = i
            end
        end
        if pos ~= 1 then 
            charsList[1],charsList[pos] = charsList[pos],charsList[1]
        end
    end
	-- 
    charsList = self:getData(charsList)

    if #charsList == 0 then
        MessageMrg.show(TextMap.GetValue("Text1141"))
        return {}
    end
    return charsList
end

-- 宠物碎片
--显示碎片列表
function m:showPetPiceList()
    self.ShowNum.gameObject:SetActive(false)
    local piecesList = {}
    local enoughList = {}
    local hasList = {}
    local pieces = Tool.getAllPetPiece() --获取碎片列表
    table.foreachi(pieces, function(index, piece)
        piece:updateInfo() --更新碎片信息
        if piece.count > 0 then
            local char = piece --CharPiece:new(piece.id)
            local name = char:getDisplayName()
            local tb = TableReader:TableRowByUnique("petavter", "name", name)
			if char.count >= char.needCharNumber then --合成
				char.tab = 3
				table.insert(enoughList, char)
			else --去抽卡
				char.tab = 2
				table.insert(piecesList, char)
			end
        end
    end)

    table.sort(enoughList, function(a, b)
        if a.star ~= b.star then return a.star < b.star end
    end)

    table.sort(piecesList, function(a, b)
        if a.star ~= b.star then return a.star > b.star end
        if a.count ~= b.count then
            return a.count > b.count
        end
        return a.id < b.id
    end)

    table.sort(hasList, function(a, b)
        if a.star ~= b.star then return a.star < b.star end
        if a.count ~= b.count then
            return a.count < b.count
        end
        return a.id > b.id
    end)

    table.foreachi(hasList, function(i, v)
        table.insert(piecesList, 1, v)
    end)

    table.foreachi(enoughList, function(i, v)
        table.insert(piecesList, 1, v)
    end)

    piecesList = self:getData(piecesList)
    if #piecesList == 0 then
        MessageMrg.show(TextMap.GetValue("Text1142"))
        return {}
    end
    return piecesList
end

--显示碎片列表
function m:showPiceList()
    self.ShowNum.gameObject:SetActive(false)
    local piecesList = {}
    local enoughList = {}
    local hasList = {}
    local pieces = Tool.getAllCharPiece() --获取碎片列表
    table.foreachi(pieces, function(index, piece)
        piece:updateInfo() --更新碎片信息
        local char = piece
        local name = char:getDisplayName()
        local tb = TableReader:TableRowByUnique("avter", "name", name)
        --if self:checkPieceByChar(tb.id) == false then --无该碎片所对应的角色
			if char.count >= char.needCharNumber then --合成
				char.tab = 3
				table.insert(enoughList, char)
			else --去抽卡
				char.tab = 2
				table.insert(piecesList, char)
			end
        --else --已经拥有该角色(去进化)
		--	char.tab = 4
		--	table.insert(hasList, char)
        --end
        --end
    end)

    table.sort(enoughList, function(a, b)
        if a.star ~= b.star then return a.star < b.star end
    end)

    table.sort(piecesList, function(a, b)
        if a.star ~= b.star then return a.star > b.star end
        if a.count ~= b.count then
            return a.count > b.count
        end
        return a.id < b.id
    end)

    table.sort(hasList, function(a, b)
        if a.star ~= b.star then return a.star < b.star end
        if a.count ~= b.count then
            return a.count < b.count
        end
        return a.id > b.id
    end)

    table.foreachi(hasList, function(i, v)
        table.insert(piecesList, 1, v)
    end)

    table.foreachi(enoughList, function(i, v)
        table.insert(piecesList, 1, v)
    end)

    piecesList = self:getData(piecesList)
    if #piecesList == 0 then
        MessageMrg.show(TextMap.GetValue("Text1142"))
        return {}
    end
    return piecesList
end

--检测碎片所对应角色是否已经拥有
function m:checkPieceByChar(charid)
    if charid == nil then return end
    local list = {}
    local charsList = Player.Chars:getLuaTable()
    for k, v in pairs(charsList) do
        local char = Char:new(k, v)
        table.insert(list, char)
    end
    for i = 1, #list do
        if list[i] ~= nil and list[i].id == charid then
            return true
        end
    end
    return false
end

--检测该角色是否上阵
function m:check(charid)
    local teams = Player.Team[0].chars
    local list = {}
    for i = 0, 5 do
        if teams.Count > i then
            list[i + 1] = teams[i]
        else
            list[i + 1] = 0
        end
    end
    for i = 1, 6 do
        if charid == list[i] and charid ~= "0" and charid ~= 0 then
            return true
        end
    end
    return false
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
				d.mType = self.mType
            end
        end
        if len > 0 then
            table.insert(list, li)
        end
    end

    return list
end

--获取当前的类型(1为英雄列表,2为碎片列表)
function m:getTab()
    return self.tab
end

--获取小伙伴队列
function m:checkFriend(charId)
    local teams = Player.Team[12].chars
    local list = {}
    for i = 0, 7 do
        if teams[i]~= nil and teams[i] == charId then
            return true
        end
    end
    return false
end

function m:onClick(go, name)
    if name == "btn_lvup_down" then --显示英雄列表
        self.isScroll = true
		if self.tab == 1 then return end
		self.tab = 1
		self:onUpdate(false)
	elseif name == "btn_pice_down" then --显示碎片列表
        self.isScroll = true
		if self.tab == 2 then return end
		self.tab = 2
		self:onUpdate(true)
	elseif name == "btn_tujian_down" then -- 宠物图鉴
		if self.tab == 3 then return end
		self.tab = 3
		self:onUpdate(false)
	elseif name == "btnBack" then 
		--if self.helpUI ~= nil then UIMrg:popWindow() end 
		UIMrg:pop()
	elseif name == "btn_sale" then 
		self:onSale()
    end
end

function m:getCanSale()
    local chars = Player.Chars:getLuaTable()
    local charsList = {}
    for k, v in pairs(chars) do
        local char = Char:new(k, v)
        if self.sellType == nil then 
            self.sellType = char.Table.sell_type
        end 
        if self.onFilter then
            if self:onFilter(char) then
                return true
            end
        else
            return true
        end
    end
    return false
end 

function m:onSale()
    if m:getCanSale() then 
        local bind = Tool.push("common_hero_select", "Prefabs/moduleFabs/hero/gui_common_select_hero", {delegate = self, type = 1})
    else 
         MessageMrg.show(TextMap.GetValue("Text_1_917"))
    end
end 

function m:onSaleCallBack(teamList, delegate)
	if teamList == nil then return end 
	local saleList = {}
	local index = 1 
	for k, v in pairs(teamList) do 
		saleList[index] = v.id
		index = index + 1
	end 
	if #saleList < 1 then return end 
	Api:sellOneCard(saleList, function(ret)
		if ret.ret == 0 then 
			MessageMrg.show(TextMap.GetValue("Text_1_328"))
            packTool:showMsg(ret, nil, 0)
            delegate:onCallBack()
		end 
	end,function()
		return false 
	end )
end 

function m:onEnter()
    --m:refreshListIndex()
    self.isScroll = false
    m:update(nil, false)
    LuaMain:ShowTopMenu()
	self:updateLocal()
end

-- function m:setCurUserItemPos(index)
--     cusrIndex = index
--     self.postionY = (math.floor(self.UIScrollView_piece.transform.localPosition.y / 178 - 0.5) * -2.8)
-- end

-- function m:refreshListIndex()
--     if cusrIndex ~= nil and cusrIndex > 0 then
--         self.binding:CallAfterTime(0.2, function()
--             self.UIScrollView_piece:Scroll(self.postionY)
--         end)
--     elseif cusrIndex == 0 then
--         self.binding:CallAfterTime(0.2, function()
--             self.scrollView_piece:goToIndex(0)
--         end)
--     end
-- end

function m:OnDestroy()
    -- Events.RemoveListener('updateHeroList')
end

function m:Start()
    if self.mType == "pet" then
        self.gui_get_help.gameObject:SetActive(false)
    end
    self.tab = 1 -- (1为显示英雄列表,2为显示碎片列表,默认是英雄列表)
	self.mType = self["_keyMap"].model_type or "char"
    local titleName = ""
    if self.mType == "char" then
        titleName = TextMap.GetValue("Text_1_773")
    elseif self.mType == "pet" then
        titleName = TextMap.GetValue("Text_1_918")
    end
    Tool.loadTopTitle(self.gameObject, titleName, function()
		UIMrg:pop()
	end)
    LuaMain:ShowTopMenu()
    local teams = Player.Team[0].chars
    self:onUpdate(false)
end

return m

