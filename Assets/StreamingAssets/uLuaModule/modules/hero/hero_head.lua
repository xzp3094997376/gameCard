-- 卡片头像
-- 进化材料

local m = {}

function m:update(lua)
	if lua.dictid > 0 then 
	    self.char = Char:new(nil, lua.dictid)
	end
	self.add:SetActive(false)
	if lua.showadd ~= nil and lua.showadd == true then 
		self.add:SetActive(true)
	end 
    self.go.enabled = false
    if self.__itemAll == nil then
        self.__itemAll = ClientTool.loadAndGetLuaBindingFromPool("Prefabs/publicPrefabs/itemAll", self.go.gameObject)
    end
	if self.char ~= nil then 
		self.__itemAll:CallUpdate({ "char", self.char, self.go.width, self.go.height, false, nil, nil, false })
		self.txtName.text = self.char.itemColorName
	end 
end

function m:Start()

end

return m

