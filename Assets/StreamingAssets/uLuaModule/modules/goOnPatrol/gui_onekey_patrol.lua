
-- 一键巡逻
local m = {}
local baseConfig = nil
function m:update(lua)
    self.delegate = lua.delegate
    self.pos_index = lua.index
	self.type = lua.type
end

function m:create(binding)
    --self.binding = binding
    return self
end

function m:updateDes()
	-- 出售英雄
	--if self.type == 1 then 
	--end 
	self.txt_title.text = TextMap.GetValue("Text_1_349")
	self.txt_select.text = TextMap.GetValue("Text_1_350")
	self.txt_action.text = TextMap.GetValue("Text_1_349")
	self.txt_get_exp.text = TextMap.GetValue("Text_1_351") .. self.value1
	self.txt_need_exp.text = TextMap.GetValue("Text_1_352") .. self.value2
	self.img_icon:setImage(Tool.getResIcon(self.sellType), "itemImage")
end 

function m:Start()
	baseConfig = TableReader:TableRowByID("baseConfig", 7)
	self.currentSettingId = -1
	local list = m:parseData()
	self.list = {}
	if list == nil then 
		TableReader:ForEachLuaTable("areaConfig", function(index, item)
			table.insert(self.list, {data = item, char = nil, id = item.id, timeType = 1, kindType = 1})
			return false
		end)
	else 
		for i = 1, #list do 
			local cell = list[i]
			local row = TableReader:TableRowByID("areaConfig", cell.id)
			local char = nil
			local c = Player.Chars[cell.charid] 
			if cell.charid ~= -1 and c ~= nil then
				char = Char:new(cell.charid)
				if char.id == nil or char.name == nil then char = nil end 
			end 
			table.insert(self.list, {data = row, char = char, id = cell.id, timeType = cell.timeType, kindType = cell.kindType})
		end 
	end 
	m:onUpdate()
end

function m:tanslateData()
	local list = {}
	for i = 1, #self.list do 
		local item = self.list[i]
		local charid = -1
		if item.char ~= nil then 
			charid = item.char.id
		end 
		table.insert(list, {charid = charid, id = item.id, timeType = item.timeType, kindType = item.kindType})
	end 
	local str = json.encode(list)
	PlayerPrefs.SetString("yijianxunluo", str)
	MessageMrg.show(TextMap.GetValue("Text_1_353"))
end 

function m:parseData()
	local str = PlayerPrefs.GetString("yijianxunluo", "")
	if str ~= "" then 
		local data = json.decode(str)
		return data
	end
	return nil
end 

function m:onCallBack(char)
    m:updateData(nil, nil, char, true)
end


function m:updateCost()
	local jinli = 0
	local gold = 0
	for i = 1, #self.list do 
		local item = self.list[i]
		local rowTime = TableReader:TableRowByID("timeConfig", item.timeType)
		local rowModel = TableReader:TableRowByID("modelConfig", item.kindType)
		local cost = rowTime["consume_model" .. item.kindType]
		if rowModel.consume_type == "vp" then 
			jinli = jinli + cost
		elseif rowModel.consume_type == "gold" then 
			gold = gold + cost
		end 
	end 
	local res = uRes:new("vp")
	local res2 = uRes:new("gold")
	local img = res:getHeadSpriteName()
	local img2 = res2:getHeadSpriteName()
	local atlasName = packTool:getIconByName(img)
	local atlasName2 = packTool:getIconByName(img2)
	self.img_jingli:setImage(img, atlasName)
	self.img_icon:setImage(img2, atlasName2)
	self.txt_get_exp.text = TextMap.GetValue("Text_1_354") .. jinli
	self.txt_need_exp.text = TextMap.GetValue("Text_1_355") .. gold
	self.jingliCost = jinli
	self.goldCost = gold
end 

function m:onFilter(char)
	if char.id == Player.Info.playercharid then return false end 
    for i = 1, 6 do
        local it = Player.Agency[i]
        if tonumber(Tool.getDictId(it.charId)) == tonumber(char.dictid) then return false end
    end
	for i = 1, #self.list do 
		local it = self.list[i]
		if it.char ~= nil then 
			if it.char.dictid == char.dictid then return false end 
		end 
	end 
    if char.star <= baseConfig.arg1 then
        return true
    end
    return false
end

function m:onUpdate()
	local list2 = m:getData(self.list)
    self.scrollView:refresh(list2, self)
	m:updateCost()
end 

function m:updateData(tid, kid, char, isUpdateChar)
	for i = 1, #self.list do 
		if self.list[i].id == self.currentSettingId then
			if tid ~= nil then 
				self.list[i].timeType = tid
			end
			if kid ~= nil then 
				self.list[i].kindType = kid
			end 
			if isUpdateChar == true then 
				self.list[i].char = char
			end 
			break
		end 
	end 
	m:onUpdate()
end 

function m:updateItem(tid, kid, char, isUpdateChar)
	m:updateData(tid, kid, char, isUpdateChar)
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

function m:onXunLuo()
    if  Player.Resource.vp < self.jingliCost then
        DialogMrg:BuyBpAOrSoul("vp", "")
        return 
    end 
	local that = self
	for i = 1, #self.list do 
		local item = self.list[i]
		if item.char ~= nil then 
			local charId = item.char.id
			local areaId = item.id
			local timeId = item.timeType
			local modelId = item.kindType
			Api:startPatrol(charId, areaId, timeId, modelId, function(result)
				if result.ret == 0 then
					--that.binding:CallAfterTime(0.2, function()
						MessageMrg.show(TextMap.GetValue("Text_1_356"))
						self.delegate:onUpdate()
					--end)
				end 
			end)
		end 
	end
	UIMrg:popWindow()
end 

function m:onClick(go, name)
    if name == "btn_go" then
		
	elseif name == "btn_save" then 
		m:tanslateData()
	elseif name == "btn_ok" then 
		m:onXunLuo()
	elseif name == "btnBack" then 
		UIMrg:popWindow()
    end
end

return m

