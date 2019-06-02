local indiana_combine = {} 

function indiana_combine:update(lua)
	self.selectMax=lua.selectMax
	self.data=lua.data
	self.delegate=lua.delegate
    self.txt_name.text = self.data:getDisplayColorName()
    self.txt_XXX.text = TextMap.GetValue("Text_1_919") .. self.selectMax .. TextMap.GetValue("Text_1_920")
    self.img_kuangzi.gameObject:SetActive(false)
    local binding = ClientTool.loadAndGetLuaBindingFromPool("Prefabs/publicPrefabs/itemAll", self.newpackitem.gameObject)
    binding:CallUpdate({ "char", self.data, self.img_kuangzi.width, self.img_kuangzi.height })
    self.selectNum.text=self.selectMax
    self.numberSelect:maxNumValue(self.selectMax)
    self.numberSelect.selectNum = self.selectMax
end

function indiana_combine:onClick(go, name)
    if name == "btn_quxiao" or name == "btnClose" then
        UIMrg:popWindow()
    end
    if name == "btn_queren" then
    	local num = tonumber(self.selectNum.text)
    	local tp = self.data:getType()
        local treasureid = self.data.id
        local msg = TextMap.GetValue("Text_1_921") .. self.data:getDisplayColorName()
        self.delegate:onSyntheticCallBack(tp,treasureid,msg,num)
        UIMrg:popWindow()
    end
end

return indiana_combine