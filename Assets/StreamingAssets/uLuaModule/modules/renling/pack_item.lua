local m = {} 

function m:update(item, index, myTable, delegate)
	self.item=item.char
	if self.__itemAll == nil then
		self.__itemAll = ClientTool.loadAndGetLuaBinding("Prefabs/publicPrefabs/itemAll", self.Sprite.gameObject)
	end
	self.__itemAll:CallUpdate({ "char", item.char, self.Sprite.width, self.Sprite.height, true, nil, })
	self.__itemAll:CallTargetFunctionWithLuaTable("HideNum")
	self.txtName.text=item.char:getDisplayColorName()
	self.txtNum_value.text=TextMap.GetValue("Text_1_2972") .. item.char.rwCount
	local activeNum = 0 -- 已激活数目
	local totalNum = 0 -- 最大激活数目
	local activeList = Player.renling
	for i=0,item.char.Table.show.Count-1 do
		local id = item.char.Table.show[i]
		local row = TableReader:TableRowByID("renling_group",id)
		totalNum=totalNum+1
		if activeList[row.group]~=nil and activeList[row.group][id] ~=nil and tonumber(activeList[row.group][id].level)>=1 then 
			activeNum=activeNum+1
		end 
	end
	self.txtDes.text=TextMap.GetValue("Text_1_2967") .. activeNum .. "/" .. totalNum 
end

function m:onClick(go, name)
	if name == "btn_fenjie" then
		UIMrg:pushWindow("Prefabs/moduleFabs/renlingModule/renling_fenjie", self.item)  
	elseif name == "btn_chakan" then
		UIMrg:pushWindow("Prefabs/moduleFabs/renlingModule/renlingContent", self.item)     
	end 
end 

return m