local m = {} 

function m:update(date)
	self.item=date
	if self.__itemAll == nil then
		self.__itemAll = ClientTool.loadAndGetLuaBinding("Prefabs/publicPrefabs/itemAll", self.pic.gameObject)
	end
	self.__itemAll:CallUpdate({ "char", date, self.pic.width, self.pic.height, true, nil, })
	self.__itemAll:CallTargetFunctionWithLuaTable("HideNum")
	self.name.text=date:getDisplayColorName()
	self.number.text=TextMap.GetValue("Text_1_1068") .. date.rwCount
	self.selectNum.text ="1"
    self.numberSelect.selectNum = 1
    self.numberSelect:maxNumValue(tonumber(date.rwCount)) 
    self.numberSelect:setCallFun(self.setNumChange, self)
    local iconName = TableReader:TableRowByUnique("resourceDefine", "name",date.Table.sell_type).img
	self.img.Url=UrlManager.GetImagesPath("itemImage/"..iconName..".png")
    self.money.text=date.Table.sell
end

function m:setNumChange()
	local num = tonumber(self.selectNum.text)
	self.money.text=tonumber(self.item.Table.sell)*num
end

function m:onClick(go, name)
	if name == "btnClose" or name == "closeBtn" or name == "btn_quxiao" then
		UIMrg:popWindow()
	elseif name == "btn_queren" then
		local num = tonumber(self.selectNum.text)
		local date = "{\"" .. self.item.id .. "\":" .. num .. "}"
		Api:decomposeRenling(date,function (result)
			packTool:showMsg(result, nil, 0)
            UIMrg:popWindow()
            self.item.delegate:Start()
		end)   
	end 
end 


return m