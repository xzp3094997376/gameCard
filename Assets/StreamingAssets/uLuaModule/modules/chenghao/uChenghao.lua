local m = {}
local currentIndex = 1
local currentBing = {}
function m:Start()
	LuaMain:ShowTopMenu(1)
	self.chenghaoname = {}
	TableReader:ForEachLuaTable("playerstarlvup_setting", function(k, v)
		self.chenghaoname[k + 1] = {}
		self.chenghaoname[k + 1].tab = v
		self.chenghaoname[k + 1].delegate = self
		return false
	end)
	currentIndex = math.floor((Player.Info.ninjialvl) / 5) + 1
	local mystarlvup = TableReader:TableRowByID("playerstarlvup", Player.Info.ninjialvl + 1)
	if mystarlvup == nil then
		currentIndex = currentIndex - 1
	end
	self:update()
	local char = Char:new(Player.Info.playercharid)
	self.textureEasy:LoadByModelId(char.modelid, "idle", function() end, false, 2, 1)
	self.binding:CallAfterTime(0.5, function()
		self.list_name:goToIndex(currentIndex - 2)
	end)
end

function m:onEnter()
	LuaMain:ShowTopMenu()
end 

function m:getCurrentIndex()
	return currentIndex
end

function m:resetCurrentIndex()
	currentIndex = math.floor((Player.Info.ninjialvl) / 5) + 1
	if currentIndex > #self.chenghaoname then
		currentIndex = #self.chenghaoname
	end
	self:update()
	self.binding:CallAfterTime(0.05, function()
		self.list_name:goToIndex(currentIndex - 2)
	end)
end
function m:setCurrentIndex(val, noneed)
	if val < 1 then
		val = 1
	end

	if val > #self.chenghaoname then
		val = #self.chenghaoname
	end

	currentIndex = val
	self:updateEx()
	if noneed ~= nil and noneed == true then
		self.list_name:goToIndex(currentIndex - 2)
	end
end

function m:update()
	self.calcProperty()
 	self.list_name:refresh(self.chenghaoname, self, false, 0)
	self.chenghaoModule:setCallFun(self.setEachChapterData, self)
	self.chenghaoModule:setCallBackMessage(self.errorMessage, self)
	print("(#self.chenghaoname)"..#self.chenghaoname)
	self.chenghaoModule:setInit(currentIndex .. "", (#self.chenghaoname) .. "", true) --是否是最后一章
end

function m:calcProperty()
	local property = {}
	if  Player.Info.ninjialvl > 0 then
		for i=1, Player.Info.ninjialvl do
			local mystarlvup = TableReader:TableRowByID("playerstarlvup", i)
			for j=0,mystarlvup.drop.Count - 1 do
				if mystarlvup.drop[j] ~= nil then
					if mystarlvup.drop[j].type == "teamattrib" then

						if property[mystarlvup.drop[j].arg] == nil then
							property[mystarlvup.drop[j].arg] = mystarlvup.drop[j].arg2
						else
							property[mystarlvup.drop[j].arg] = property[mystarlvup.drop[j].arg] + mystarlvup.drop[j].arg2
						end
					end
				end
			end
		end
	end
	if property[12] == nil then --队伍生命_V
		property[12]  = 0
	end
	m.txt_pvalue_1.text = property[12]..""
	if property[0] == nil then --队伍攻击_V
		property[0]  = 0
	end
	m.txt_pvalue_2.text = property[0]..""
	if property[1] == nil then --队伍物防_V
		property[1]  = 0
	end
	m.txt_pvalue_3.text = property[1]..""
	if property[3] == nil then --队伍法防_V
		property[3]  = 0
	end
	m.txt_pvalue_4.text = property[3]..""
end

function m:updateEx()
	local luabns = self.list_name.gameObject:GetComponentsInChildren("UluaBinding")
	for i=1, #luabns do
		local tmp = {onlySelIcon = true}
		luabns[i]:CallUpdateWithArgs(tmp)
	end
	self.drag_chenghaoModule:SetCurrPage(currentIndex .. "") --是否是最后一章
end
--设置每一章的数据,重新生成
function m:setEachChapterData(go, index, bol)
    local tempObj = {}
    tempObj.delegate = self
    tempObj.index = tonumber(go.name)
    tempObj.tab = self.chenghaoname[tempObj.index]
    if go.transform.childCount > 0 then
        for i = 1, go.transform.childCount do
            go.transform:GetChild(i - 1).gameObject:SetActive(false)
        end
    end
    if currentBing[go.name] == nil then
        local binding = ClientTool.loadAndGetLuaBinding("Prefabs/moduleFabs/chenghaoModule/chenghao_content_item_1", go)
        currentBing[go.name] = binding
    end
    currentBing[go.name].transform.parent = go.transform
    currentBing[go.name].transform.localPosition = Vector3(0, 0, 0)
    currentBing[go.name].gameObject:SetActive(true)
    currentBing[go.name]:CallUpdate(tempObj)

    self.binding:CallAfterTime(0.0005, function()
	    local moveX = self.movePanel.transform.localPosition.x
	    for i=1,3 do
	    	local posx = self["currentP"..i].transform.localPosition.x
	    	if  posx + moveX > -1 and posx + moveX < 1 then
	    		currentIndex = tonumber(self["currentP"..i].name)
	    		break
	    	end
	    end
	    local luabns = self.list_name.gameObject:GetComponentsInChildren("UluaBinding")
		for i=1, #luabns do
			local tmp = {onlySelIcon = true}
			luabns[i]:CallUpdateWithArgs(tmp)
		end
	end)
end

function m:onClick(go, name)
	if name == "btnBack" then
		UIMrg:pop()
	elseif name == "up" then
		self.ScrollView:Scroll(0.5)
	elseif name == "down" then
		self.ScrollView:Scroll(-0.5)
	elseif name == "left" then
		self:setCurrentIndex(currentIndex + 1, true)
	elseif name == "right" then
		self:setCurrentIndex(currentIndex - 1, true)
	end
end

return m
