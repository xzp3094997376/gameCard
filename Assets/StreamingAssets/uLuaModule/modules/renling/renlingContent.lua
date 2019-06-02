local m = {} 

function m:update(date)
	self.item=date
	if self.__itemAll == nil then
		self.__itemAll = ClientTool.loadAndGetLuaBinding("Prefabs/publicPrefabs/itemAll", self.pic.gameObject)
	end
	self.__itemAll:CallUpdate({ "char", date, self.pic.width, self.pic.height, false, nil, })
	self.__itemAll:CallTargetFunctionWithLuaTable("HideNum")
	self.name.text=date:getDisplayColorName()
	self.desc.text=date.Table.desc
	local activeNum = 0 -- 已激活数目
	local totalNum = 0 -- 最大激活数目
	local activeList = Player.renling
	local showList = {}
	for i=0,date.Table.show.Count-1 do
		local id = date.Table.show[i]
		local temp = {}
		temp.id = id 
		local row = TableReader:TableRowByID("renling_group",id)
		temp.name =row.show_name
		totalNum=totalNum+1
		if activeList[row.group]~=nil and activeList[row.group][id] ~=nil and tonumber(activeList[row.group][id].level)>=1 then 
			activeNum=activeNum+1
			temp.color="[FF2626]"
		else 
			temp.color="[702200]"
		end 
		table.insert( showList, temp )
	end
	self.des.text=TextMap.GetValue("Text_1_2967") .. activeNum .. "/" .. totalNum 
	showList=m:getData(showList)
	self.scrollView:refresh(showList, self, false,0)
end

function m:getData(data)
    local list = {}
    local row = 3
    for i = 1, table.getn(data), row do
        local li = {}
        local len = 0
        for j = 0, row - 1 do
            if data[i + j] then
                local d = data[i + j]
                d.realIndex = i + j
                li[j + 1] = d
                len = len + 1
                d.mType = self.mType
            end
        end
        if len > 0 then
            table.insert(list, li)
        end
    end
    return list
end

function m:onClick(go, name)
	if name == "btnClose" or name == "closeBtn" then
		UIMrg:popWindow()
	elseif name == "btn_queren" then
		-- 去获取
		UIMrg:popWindow()
		local id = TableReader:TableRowByID("renling_config",4).value
		uSuperLink.openModule(id)   
	end 
end 

return m