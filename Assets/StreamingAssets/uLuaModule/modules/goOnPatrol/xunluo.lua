local m = {}

local hour_4 = 1
local hour_8 = 2
local hour_12 = 3

local normalType = 1
local middleType = 2
local advancedType =3

local model = {}
local time = {}

local goData = {}

function m:Start()
	self.timeType = 1
	self.lvType = 1
	self.isPatrol = false
	
    for i = 1, 3 do
        local row = TableReader:TableRowByID("modelConfig", i)
		model[i] = row
        --self["model_type" .. i]:CallUpdate(row)
    end
    for i = 1, 3 do
        local row = TableReader:TableRowByID("timeConfig", i)
		time[i] = row 
        --self["btn_check" .. i]:CallUpdate(row)
    end
	
	local list = {}
	local that = self
    TableReader:ForEachLuaTable("areaConfig", function(index, item)
		local ret = m:checkUn_lock(item)
		if ret == "" then 
			local state = Player.Agency[item.id]
			if state.state == "1" then
				-- 可选人状态， 能加入一键巡逻
				local t = {}
				t.data = item
				t.delegate = that
				table.insert(list, t)
				if tonumber(state.charId) == 0 then 
					self.isPatrol = true
				end 
			end
		end 
        return false
    end)
    self.list = list
    --self.Label1.bitmapFont = myFont
    -- self.Label.bitmapFont = myFont
	self:update(nil)
end

function m:setData(charId, areaId, timeId, mId)
	if charId == nil or areaId == nil or timeId == nil or mId == nil then 
		print("data is null, set data fail.....")
		if charId == nil then print("charId is nil ") end 
		if areaId == nil then print("areaId is nil ") end 
		if timeId == nil then print("timeId is nil ") end 
		if mId == nil then print("mId is nil ") end 
		return 
	end
	local t = {}
	t.charId = charId
	t.areaId = areaId 
	t.timeId = timeId
	t.mId = mId
	goData[areaId] = t
	
	m:updateCost()
end

function m:updateCost()
	local cost_t = {}
	cost_t[1] = {}
	for k, v in pairs(goData) do
		local rowTime = TableReader:TableRowByID("timeConfig", v.timeId)
		local rowModel = TableReader:TableRowByID("modelConfig", v.mId)
		local cost = rowTime["consume_model" .. v.mId]
		local res = uRes:new(rowModel.consume_type)
		if cost_t[1].type == nil then 
			cost_t[1].type = rowModel.consume_type
			cost_t[1].cost = cost
		else 
			if cost_t[1].type == rowModel.consume_type then 
				cost_t[1].cost = cost_t[1].cost + cost
			else 
				if cost_t[2] == nil then 
					cost_t[2] = {}
				end 
				if cost_t[2].type == nil then 
					cost_t[2].type = rowModel.consume_type
					cost_t[2].cost = cost
				elseif cost_t[2].type == rowModel.consume_type then 
					cost_t[2].cost = cost_t[2].cost + cost
				end
			end 
		end
	end
	for i = 1, table.getn(cost_t) do
		local t = cost_t[i]
		local res = uRes:new(t.type)
		local img = res:getHeadSpriteName()
		local atlasName = packTool:getIconByName(img)

		self["icon_cost" .. i]:setImage(img, atlasName)
		self["txt_cost"..i].text = t.cost
	end
	
	if table.getn(cost_t) == 1 then 
		self.cost2:SetActive(false)
	else
		self.cost2:SetActive(true)
	end 
end

function m:update(data)
	if data ~= nil then 
		self.delegate = data.delegate
	end
	self.scrollView:refresh(self.list, self, true, 0)
	
	if self.isPatrol == true then 
		self.btn_start_going.gameObject:SetActive(true)
	else
		self.btn_start_going.gameObject:SetActive(false)
	end 
end

function m:checkUn_lock(row)
    local id = tonumber(row.id)
    local txt = ""
    local un_lock = row.unlock
    for i = 0, un_lock.Count - 1 do
        local it = un_lock[i]
        if it.unlock_condition == "lv" then
            local lv = it.unlock_arg
            if Player.Info.level < lv then
                txt = txt .. string.gsub(TextMap.GetValue("Text115"),"{0}",lv)
            end
        elseif it.unlock_condition == "area" then
            local preRow = TableReader:TableRowByID("areaConfig", it.unlock_arg)
            local pre = Player.Agency[preRow.id]
            if pre and pre.state ~= "1" then
                txt = txt .. string.gsub(TextMap.GetValue("Text116"),"{0}",preRow.area_name)
            end
        end
    end
    return txt
end

function m:updateState()
    local rowTime = TableReader:TableRowByID("timeConfig", self.timeType)
    local rowModel = TableReader:TableRowByID("modelConfig", self.lvType)
    local res = uRes:new(rowModel.consume_type)
    local img = res:getHeadSpriteName()
    local atlasName = packTool:getIconByName(img)
    self.icon_cost:setImage(img, atlasName)
    local cost = rowTime["consume_model" .. self.lvType]
    self.txt_cost.text = cost
end

local isGoing = false
--开始巡逻
function m:onStartGoing()
	if isGoing == true then return end
	for k, v in pairs(goData) do
		local item = v
		local charId = item.charId
		local areaId = item.areaId
		local timeId = item.timeId
		local modelId = item.mId
		local row = self.row
		isGoing = true
		Api:startPatrol(charId, areaId, timeId, modelId, function(result)
			--m:update(row)
			m.delegate:update(row)
			isGoing = false
		end)
	end
end

function m:savePlan()
	local str = json.encode(goData)
	PlayerPrefs.SetString(Player.playerId .. "xunluo_plan", str)
end 

function m:onUpdate()

end

function m:onClick(go, name)
    if name == "btn_close" then
        UIMrg:popWindow()
    elseif name == "btn_start_going" then
        m:onStartGoing()
        UIMrg:popWindow()
	elseif name == "btn_save" then 
		m:savePlan()
	end
end

function m:onCallBack(char)
    UIMrg:popWindow()
    self.delegate.state = 3
	self.delegate.char = char
    self.char = char
    m:onUpdate(self.row)
	if self.__itemAll == nil then
        self.__itemAll = ClientTool.loadAndGetLuaBindingFromPool("Prefabs/publicPrefabs/itemAll", self.img_frame.gameObject)
    end
    self.__itemAll:CallUpdate({ "char", self.char, self.img_frame.width, self.img_frame.height })
	self.txtName.text = self.char:getDisplayName()
end


return m