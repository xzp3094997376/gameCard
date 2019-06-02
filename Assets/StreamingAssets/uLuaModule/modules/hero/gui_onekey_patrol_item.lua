
local m = {}
local color = {"[00ff00]", "[00b4ff]", "[ff0000]"}
--点击事件
function m:onClick(uiButton, name)
    if (name == "btnCell") then
        --self:onSelect(uiButton)
	elseif name == "btn_close" then 
		self.delegate.currentSettingId = self.data.id
		self.delegate:updateItem(nil, nil, nil, true)
	elseif name == "btn_add" then 
		self.delegate.currentSettingId = self.data.id
		local bind = UIMrg:pushWindow("Prefabs/moduleFabs/formationModule/formation/formation_select_char")
        bind:CallUpdate({ type = "single", module = "daili", delegate = self.delegate })
	elseif name == "btn_setting" then 
		self.delegate.currentSettingId = self.data.id
	    self.typeBinding = UIMrg:pushWindow("Prefabs/activityModule/goOnPatrol/select_type")
        self.typeBinding:CallUpdate({ delegate = self.delegate, type = 1, timeType = self.timeType, kindType = self.kindType })
    end
end

function m:updateData()
	self.txt_title_name.text = self.data.area_name
	self.txt_hour.text = color[self.timeType] ..TextMap.GetValue("Text_1_343").. self.tiemList[self.timeType].name  .. "[-]"
	self.txt_kind.text = color[self.kindType] .. self.modelList[self.kindType].name..TextMap.GetValue("Text_1_790")
    if self.char == nil then 
		self.btn_close.gameObject:SetActive(false)
		self.txt_name.text = TextMap.GetValue("Text_1_791")
		if self.infobinding ~= nil then 
			self.infobinding.gameObject:SetActive(false)
		end 
	else
		self.txt_name.text = TextMap.GetValue("Text_1_792") .. Char:getItemColorName(self.char.star, self.char.name)
		if self.infobinding == nil then
            self.infobinding = ClientTool.loadAndGetLuaBindingFromPool("Prefabs/publicPrefabs/itemAll", self.img_frame.gameObject)
        else 
			self.infobinding.gameObject:SetActive(true)
		end
        self.infobinding:CallUpdate({ "char", self.char, self.img_frame.width, self.img_frame.height, nil })
	end 
end


function m:update(lua)
    self.index = lua.index
    self.data = lua.char.data
	self.char = lua.char.char
	self.timeType = lua.char.timeType or 1
	self.kindType = lua.char.kindType or 1
    self.delegate = lua.delegate
	self:updateData()
end


function m:Start()
	self.modelList = {}
    for i = 1, 3 do
        local row = TableReader:TableRowByID("modelConfig", i)
		self.modelList[i] = row
    end
	self.tiemList = {}
    for i = 1, 3 do
        local row = TableReader:TableRowByID("timeConfig", i)
        self.tiemList[i] = row
    end
end 

return m

