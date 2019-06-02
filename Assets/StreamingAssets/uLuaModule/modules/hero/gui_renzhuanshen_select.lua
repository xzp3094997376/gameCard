-- 选择角色列表
local m = {}
local isInited = false
function m:update(lua)
    self.delegate = lua.delegate
	self.sourceChar = lua.sourceChar
	if not isInited then 
		m:initHerosData()
	end 
	self.tp = self.sourceChar.party
	m:updateBtnStatus()
    m:showHeros()
end

function m:showHeros()
    local charsList = nil
	if self.tp == 1 then 
		charsList = self.shanren
	elseif self.tp == 2 then 
		charsList = self.eren
	elseif self.tp == 3 then 
		charsList = self.yingren
	end 
    
    charsList = self:getData(charsList)
    self.scrollView:refresh(charsList, self, false, 0)
end

function m:onCallBack(char, tp)
    self.delegate:onCallBack(char, tp)
end

function m:Start()
	self.tp = 1
	m:updateBtnStatus()
end

function m:initHerosData()
	self.shanren = {}
	self.eren = {}
	self.yingren = {}
	TableReader:ForEachTable("char",
		function(index, item)
			if item ~= nil and item.star == self.sourceChar.Table.star then
				if self:filter(item) then 
					local char = Char:new(nil, item.id)
					if self.sourceChar ~= nil then 
						m:copyInfo(self.sourceChar, char)
					end 
					if item.party == 1 then 
						table.insert(self.shanren, char)
					elseif item.party == 2 then 
						table.insert(self.eren, char)
					elseif item.party == 3 then 
						table.insert(self.yingren, char)
					end 
				end
			end
		return false
	end)
	table.sort(self.shanren, function(a, b)
		return a.Table.id < b.Table.id
	end)
	table.sort(self.eren, function(a, b)
		return a.Table.id > b.Table.id
	end)
	table.sort(self.yingren, function(a, b)
		return a.Table.id < b.Table.id
	end)
	isInited = true
end

function m:filter(charTable)
	if charTable.id == self.sourceChar.dictid then 
		return false 
	end 
	return true
end

function m:copyInfo(source, target)
	if source.bloodlv == nil then 
		local bloodline = Player.Chars[source.id].bloodline
		source.bloodlv = bloodline.level
	end 
	if source.qualitylvl == nil then 
		local qlv = Player.Chars[source.id].qualitylvl
		source.qlv = qlv
	end 
	target.info = source.info
	target.lv = source.lv
	target.source = source.info
	target.bloodlv = source.bloodlv
	target.qlv = source.qlv
	target.star_level = source.star_level
end

function m:OnDestroy()
	self.shanren = nil
	self.eren = nil
	self.yingren = nil
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

function m:refresh(ret)
    self.charList = self:getChars(self.team, ret)
    self.scrollView:refresh(self.charList, self, false, 0)
    self:setInfo()
end

function m:isLockParty()
	local lv = TableReader:TableRowByID("renzhuanshen", "renzhuanshen_unlock_party").value2
	if Player.Info.level < lv then 
		MessageMrg.show(TextMap.GetValue("Text_1_803")..lv..TextMap.GetValue("Text_1_804"))
		return true
	end 
	return false 
end 

function m:onClick(go, name)
    if name == "btnBack" then
		UIMrg:popWindow()
	elseif name == "btn_shan" or name == "btn_shan_g" then
        --m:onGx()
		if self.tp == 1 then return end 
		if m:isLockParty() == true then return end
		self.tp = 1
		m:updateBtnStatus()
		m:showHeros()
    elseif name == "btn_e" or name == "btn_e_g" then
        --m:onDps()
		if self.tp == 2 then return end 
		if m:isLockParty() == true then return end
		self.tp = 2
		m:updateBtnStatus()
		m:showHeros()
    elseif name == "btn_ying" or name == "btn_ying_g" then
       -- m:onReward()
	    if self.tp == 3 then return end 
	    if m:isLockParty() == true then return end
		self.tp = 3
		m:updateBtnStatus()
		m:showHeros()
    end
end

function m:updateBtnStatus()
	if self.tp == 1 then 
        self.btn_shan.gameObject:SetActive(true)
        self.btn_shan_g.gameObject:SetActive(false)
        self.btn_e.gameObject:SetActive(false)
        self.btn_e_g.gameObject:SetActive(true)
        self.btn_ying.gameObject:SetActive(false)
        self.btn_ying_g.gameObject:SetActive(true)
	elseif self.tp == 2 then 
        self.btn_e.gameObject:SetActive(true)
        self.btn_e_g.gameObject:SetActive(false)
        self.btn_shan.gameObject:SetActive(false)
        self.btn_shan_g.gameObject:SetActive(true)
        self.btn_ying.gameObject:SetActive(false)	
        self.btn_ying_g.gameObject:SetActive(true)
	elseif self.tp == 3 then 	
        self.btn_e.gameObject:SetActive(false)
        self.btn_e_g.gameObject:SetActive(true)
        self.btn_shan.gameObject:SetActive(false)
        self.btn_shan_g.gameObject:SetActive(true)
        self.btn_ying.gameObject:SetActive(true)    
        self.btn_ying_g.gameObject:SetActive(false)
	end 
end 

return m

