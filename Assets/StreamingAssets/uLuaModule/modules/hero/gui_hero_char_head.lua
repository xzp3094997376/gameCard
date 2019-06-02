
local m = {}


--点击事件
function m:onClick(uiButton, eventName)
    if (eventName == "btnCell") then
        self:onSelect()
    end
end

function m:onSelect()
	if self.char.isSelected == false then 
		if self.delegate:isFull() then 
			self.char.isSelected = false
			MessageMrg.showMove(TextMap.GetValue("Text_1_783"))
			return 
		end 
	end 
    if self.char.isSelected == nil or self.char.isSelected == false then
		self.delegate:pushToTeam(self.char, self.char.isSelected)
		self.char.isSelected = true 
	else
        self.delegate:popToTeam(self.char, self.char.isSelected)
		self.char.isSelected = false
	end
	self.delegate:setInfo()
    self:updateState()
end

function m:updateItem()
    local char = self.char
	--if self._data == nil then 
		self._data = itemvo:new("item", 1, self.char.itemid, 1)
	--end 
    self.labName.text = self._data.itemColorName --名字
    self.txt_lv.text = "" --self._data.itemPro
	self.txt_exp.text = TextMap.GetValue("Text_1_784") .. self._data.itemTable.exp
    self.img_frame.enabled = false
    if self.__itemAll == nil then
        self.__itemAll = ClientTool.loadAndGetLuaBindingFromPool("Prefabs/publicPrefabs/itemAll", self.img_frame.gameObject)
    end

    self.__itemAll:CallUpdate({ "itemvo", self._data, self.img_frame.width, self.img_frame.height, true })
    self:updateState()
end 

function m:updateChar()
    local char = self.char
    self.labName.text = char:getDisplayName() --名字
    self.txt_lv.text = TextMap.GetValue("Text_1_772") .. char.lv
	self.txt_exp.text = TextMap.GetValue("Text_1_784") .. char.Table.exp + char.info.exp
    self.img_frame.enabled = false
    if self.__itemAll == nil then
        self.__itemAll = ClientTool.loadAndGetLuaBindingFromPool("Prefabs/publicPrefabs/itemAll", self.img_frame.gameObject)
    end
    self.__itemAll:CallUpdate({ "char", self.char, self.img_frame.width, self.img_frame.height })
    self:updateState()
end

function m:OnDestroy()
	self._data = nil
end 

function m:updateState()
	self.selected:SetActive(self.char.isSelected or false)
end

--更新角色列表
--@char 角色 uChar.lua
--@index 列表中的位置
--@delegate 数据控制
function m:update(lua)
    self.index = lua.index
	self.type = lua.char.type
    self.char = lua.char
    self.delegate = lua.delegate

	if self.type == "char" then 
		self:updateChar()
	elseif self.type == "pet" then 
		self:updateItem()
	end 
end


function m:Start()
	self.selected:SetActive(false)
end 

return m

