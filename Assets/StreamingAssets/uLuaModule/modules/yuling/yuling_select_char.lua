local m = {}

local cusrIndex = 0

function m:update()
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
    local list = {}
    if self.tab == 1 then
        list = self:showYulingList() 
		self.img_hero:SetActive(true)
		self.img_pice_Up:SetActive(false)
    elseif self.tab == 2 then
		list = self:showYulingPiceList()
        self.gui_get_help.gameObject:SetActive(false)
		self.img_hero:SetActive(false)
		self.img_pice_Up:SetActive(true)
    end 
    self:updateView(list, flag)
	
	local red1 = false
	local red2 = false
	red1 = Tool.checkRedPoint("yulingPiece")  or false
	red2 = Tool.checkRedPoint("yuling") or false
    self.redPoint_for_pice:SetActive(red1)
	self.redPoint:SetActive(red2)
end


function m:getShowList()
	if self.tab == 2 then 
		return m:showYulingPiceList()
    elseif self.tab == 1 then 
        return m:showYulingList()
	end
end

-- 御灵列表
 function m:showYulingList()
    self.curNum = 0
    local yulingList = {} --所有英雄
    local yilings =Player.yuling:getLuaTable()
    local index = 1
    local friendList = {} --护佑
    for k, v in pairs(yilings) do
        self.curNum = self.curNum + 1
        local yuling = Yuling:new(k)
        if yuling ~=nil  and yuling.Table~=nil then 
            yuling.tab = self.tab
    		if yuling.info.huyou >0 then
    			table.insert(friendList,yuling)
    		else --未上阵英雄
    			table.insert(yulingList,yuling)
    		end
        end 
    end
    self.ShowNum.gameObject:SetActive(true)
    self.Label_Value_Bag.text = TextMap.GetValue("Text_1_326")..self.curNum.."/"..TableReader:TableRowByID("bagMax", "maxPet")["vip"..Player.Info.vip]

    table.sort(yulingList, function(a, b)
        if a.star ~= b.star then return a.star > b.star end
        if a.lv ~= b.lv then
            return a.lv > b.lv
        end
        return a.id < b.id
    end)

    table.sort(friendList,function (a,b)
        if a.star ~= b.star then return a.star < b.star end
        if a.lv ~= b.lv then
            return a.lv < b.lv
        end
        return a.id > b.id
    end)
    local len = #friendList
    if len > 0 then
        for i=1,#friendList do
            local v = friendList[i]
            table.insert(yulingList, 1, v)
        end
    end
    yulingList = self:getData(yulingList)
    if #yulingList == 0 then
        if self.tab == 1 then
            self.gui_get_help.gameObject:SetActive(true)
            self.gui_get_help:CallUpdate({type = "yuling", style = 0})
        end
        return {}
    end
    return yulingList   
end


-- 御灵碎片
--显示碎片列表
function m:showYulingPiceList()
    self.ShowNum.gameObject:SetActive(false)
    local piecesList = {}
    local enoughList = {}
    local hasList = {}
    local pieces = Tool.getAllYulingPiece() --获取碎片列表
    table.foreachi(pieces, function(index, piece)
        piece:updateInfo() --更新碎片信息
        if piece.count > 0 then
            local char = piece --CharPiece:new(piece.id)
            local name = char:getDisplayName()
            local tb = TableReader:TableRowByUnique("petavter", "name", name)
            if Player.yuling[char.id].quality >0 then 
                char.tab = 3
                table.insert(hasList, char)
			elseif char.count >= char.needCharNumber then --合成
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
        if a.count ~= b.count then
            return a.count < b.count
        end
        return a.id > b.id
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
				d.mType = "yuling"
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

function m:onEnter()
    print("onEnter")
    m:onUpdate(false)
    LuaMain:ShowTopMenu()
	self:updateLocal()
end

function m:OnDestroy()
    
end

function m:Start()
    self.tab = 1 -- (1为显示英雄列表,2为显示碎片列表,默认是英雄列表)
    Tool.loadTopTitle(self.gameObject, TextMap.GetValue("Text_1_2993"))
    LuaMain:ShowTopMenu()
    self:onUpdate(false)
end

return m

