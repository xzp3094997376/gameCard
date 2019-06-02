local topTitle = {}
--更新信息
-- title => string
-- close => function
--local moduleList = {}
function topTitle:update(lua)
    self.close = lua.close
	self.txt_title.text = lua.title
end
function topTitle:setTitle(str)
	self.txt_title.text = str
end

--[[
function topTitle:pushModule(data)
	table.insert(moduleList, {name = data.name, modName = data.modName, close = data.close})
	--print("进来一个")
	--print_t(moduleList)
end

function topTitle:popAll()
	moduleList = nil 
	moduleList = {}
	self.gameObject:SetActive(false)
end  

function topTitle:popModuleByPos(pos)
	self:popModule(pos)
end 

function topTitle:popModule(pos)
	if pos ~= nil then 
		table.remove(moduleList, pos)
	else 
		table.remove(moduleList)
	end 
	--print("出去一个")
	--print_t(moduleList)
	if table.getn(moduleList) <= 0 then 
		self.gameObject:SetActive(false)
		return 
	end
end 

function topTitle:updateNext()
	if table.getn(moduleList) <= 0 then 
		return 
	end
	self.binding:CallManyFrame(function()
		self:update({title = moduleList[#moduleList].name, close = moduleList[#moduleList].close})
	end)
end 

function topTitle:popModuleByUIMrg(name)
	for i = 1, #moduleList do 
		local item = moduleList[i]
		if item.modName == name then 
			self:popModuleByPos(i)
			break
		end 
	end 
end 

function topTitle:modulePopEvent(name)
	self:popModuleByUIMrg(name)
end 
]]--

function topTitle:onClick(go, name)
	print(name)
	if name == "btnBack" then 
		-- 回收
		Tool.pushTopTitleByPool(self.binding)
		if self.close ~= nil then 
			self.close() 
			return 
		end
		UIMrg:pop()
	end 
end

return topTitle