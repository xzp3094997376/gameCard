local m = {}
--_type
-- style 0 隐藏模式
function m:update(lua)
	self.hero:LoadByCharId(33, "idle", function(ctl)
    end, false, -1)
	self.type = lua.type
	self.style = lua.style or 1
	
	if self.style == 0 then 
		self.widget:SetActive(false)
	end 
	local list = m:getList()
	self.scrollView:refresh(list, self)
end

function m:getList()
	local list = {}
	if self.type == "pet" then 
		local item = TableReader:TableRowByID("lvuptxt", 30)
		table.insert(list, item)
		item = TableReader:TableRowByID("lvuptxt", 31)
		table.insert(list, item)
		self.desc.text=TextMap.GetValue("LocalKey_381")
	elseif self.type == "yuling" then 
		local item = TableReader:TableRowByID("lvuptxt", 37)
		table.insert(list, item)
		local item = TableReader:TableRowByID("lvuptxt", 38)
		table.insert(list, item)
		self.desc.text=TextMap.GetValue("Text_1_2993")
	end 
	return list
end 

--按钮点击事件
function m:onClick(go, name)
	if name == "btnClose" then 
		UIMrg:popWindow()
	end 
end

--初始化
function m:create(binding)
    self.binding = binding
    return self
end

return m