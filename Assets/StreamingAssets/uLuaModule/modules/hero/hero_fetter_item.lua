local m = {}

function m:update(lua)
    self.data = lua
    self.Label.text = self.data.fetter.desc_eff 
    if self.iscanGo ~= nil then
        self.newpackitem.gameObject:SetActive(self.iscanGo)
    end
	self.char = Char:new(nil, lua.did)
	if self.infobinding == nil then
        self.infobinding = ClientTool.loadAndGetLuaBindingFromPool("Prefabs/publicPrefabs/itemAll", self.img_item.gameObject)
    end
	self.txtName.text = self.char.itemColorName
    self.infobinding:CallUpdate({ "char", self.char, self.img_item.width, self.img_item.height})
end

function m:onClick(go, name)
	if name == "btn_go" then
		DialogMrg.showPieceDrop(self.char)
	end
end


--初始化
function m:create(binding)
    self.binding = binding
    return self
end

return m