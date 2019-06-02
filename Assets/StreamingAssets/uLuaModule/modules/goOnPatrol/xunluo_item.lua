local m = {}

local hour_4 = 1
local hour_8 = 2
local hour_12 = 3

local normalType = 1
local middleType = 2
local advancedType =3

local model = {}
local time = {}
local isInited = false
function m:Start()
	self.timeType = 1
	self.lvType = 1
	
	for i = 1, 3 do
        local row = TableReader:TableRowByID("modelConfig", i)
		model[i] = row
        self["model_type" .. i]:CallUpdate(row)
    end
    for i = 1, 3 do
        local row = TableReader:TableRowByID("timeConfig", i)
		time[i] = row 
        self["btn_check" .. i]:CallUpdate(row)
    end
	
	m:updateLvBtn()
	m:updateTimeBtn()
end

function m:initInfo()
	local info = PlayerPrefs.GetString(Player.playerId .. "xunluo_plan")
	if info ~= "" then 
		local data = json.decode(info)
		for k, v in pairs(data) do
			if v.areaId == self.row.id then
				self.timeType = v.timeId
				self.lvType = v.mId
				local charId = v.charId
				local char = Char:new(charId)
				self.char = char
				m.delegate:setData(charId, v.areaId, self.timeType, self.lvType)
				if self.__itemAll == nil then
					self.__itemAll = ClientTool.loadAndGetLuaBindingFromPool("Prefabs/publicPrefabs/itemAll", self.img_frame.gameObject)
				end
				self.__itemAll:CallUpdate({ "char", self.char, self.img_frame.width, self.img_frame.height })
			
				m:updateLvBtn()
				m:updateTimeBtn()
				self.txt_name.text = self.char:getDisplayName()
				break
			end 
		end
	end
	isInited = true
end 

function m:update(row)
    self.row = row.data
	self.delegate = row.delegate
	self.txt_title.text = string.sub(self.row.area_name, -6)
	
	local data = Player.Agency[self.row.id]
	if tonumber(data.charId) ~= 0 then 
	    local charId = data.charId
        local char = Char:new(charId)
        self.char = char
		
        self.state = State4
		self.node_duration:SetActive(false)
		self.m_type:SetActive(false)
		self.txt_state.gameObject:SetActive(true)
		self.txt_state.text = TextMap.GetValue("Text_1_359")
		if self.__itemAll == nil then
			self.__itemAll = ClientTool.loadAndGetLuaBindingFromPool("Prefabs/publicPrefabs/itemAll", self.img_frame.gameObject)
		end
		self.__itemAll:CallUpdate({ "char", self.char, self.img_frame.width, self.img_frame.height })
	else 
		self.node_duration:SetActive(true)
		self.m_type:SetActive(true)
		self.txt_state.gameObject:SetActive(false)
	end
	if isInited == false then 
		m:initInfo()
	end
end


function m:setSelect(flag)
    -- local toggle = self.model_type.gameObject:GetComponent(UIToggle)
    -- toggle.value = true
    --self.select:SetActive(flag)
end

function m:onClick(go, name)
    if name == "btn_select" then 
	    local bind = UIMrg:pushWindow("Prefabs/moduleFabs/formationModule/formation/formation_select_char")
        bind:CallUpdate({ type = "single", module = "daili", delegate = self })
    elseif name == "model_type_1" then 
		self.timeType = hour_4
		self:updateTimeBtn()
	elseif name == "model_type_2" then 
		self.timeType = hour_8
		self:updateTimeBtn()
	elseif name == "model_type_3" then 
		self.timeType = hour_12
		self:updateTimeBtn()
	elseif name == "btn_check_1" then 
		self.lvType = normalType
		self:updateLvBtn()
	elseif name == "btn_check_2" then 
		self.lvType = middleType
		self:updateLvBtn()	
	elseif name == "btn_check_3" then 
		self.lvType = advancedType
		self:updateLvBtn()	
	end
	if self.char ~= nil then 
		self.delegate:setData(self.char.id, self.row.id, self.timeType, self.lvType)
	end
end

function m:updateLvBtn()
	if self.lvType == hour_4 then 
		self.btn_check_1.isEnabled = false --UIButtonColor.State.Pressed
		self.btn_check_2.isEnabled = true--UIButtonColor.State.Normal
		self.btn_check_3.isEnabled = true--UIButtonColor.State.Normal
	elseif self.lvType == hour_8 then 
		self.btn_check_1.isEnabled = true--UIButtonColor.State.Normal
		self.btn_check_2.isEnabled = false--UIButtonColor.State.Pressed
		self.btn_check_3.isEnabled = true--UIButtonColor.State.Normal
	elseif self.lvType == hour_12 then 
		self.btn_check_1.isEnabled = true--UIButtonColor.State.Normal
		self.btn_check_2.isEnabled = true--UIButtonColor.State.Normal
		self.btn_check_3.isEnabled = false--UIButtonColor.State.Pressed
	end 
end

function m:updateTimeBtn()
	if self.timeType == hour_4 then 
		self.model_type_1.isEnabled = false --(UIButtonColor.State.Pressed, false)
		self.model_type_2.isEnabled = true --(UIButtonColor.State.Normal, false)
		self.model_type_3.isEnabled = true --(UIButtonColor.State.Normal, false)
	elseif self.timeType == hour_8 then 
		self.model_type_1.isEnabled = true --(UIButtonColor.State.Normal, false)
		self.model_type_2.isEnabled = false --(UIButtonColor.State.Pressed, false)
		self.model_type_3.isEnabled = true --(UIButtonColor.State.Normal, false)
	elseif self.timeType == hour_12 then 
		self.model_type_1.isEnabled = true --(UIButtonColor.State.Normal, false)
		self.model_type_2.isEnabled = true --(UIButtonColor.State.Normal, false)
		self.model_type_3.isEnabled = false --(UIButtonColor.State.Pressed, false)
	end 
end

function m:onCallBack(char)
    UIMrg:popWindow()
    self.state = 3
	self.char = char
	self.delegate:setData(self.char.id, self.row.id, self.timeType, self.lvType)
    m:update({data = self.row, delegate = self.delegate})
	if self.__itemAll == nil then
        self.__itemAll = ClientTool.loadAndGetLuaBindingFromPool("Prefabs/publicPrefabs/itemAll", self.img_frame.gameObject)
    end
    self.__itemAll:CallUpdate({ "char", self.char, self.img_frame.width, self.img_frame.height })
	self.txt_name.text = self.char:getDisplayName()
end

return m