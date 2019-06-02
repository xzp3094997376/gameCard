local m = {} 
local isup = false
-- 攻击0， 物防1， 法防3， 生命12
local propterty = {0, 12, 1, 3}
function m:update(lua)
	self.delegate = lua.delegate
	self.petGroups = {}
	self.petGroups = self:getPetGroups()
	
	self.bindings = {}
	self.content:Reset(1, #self.petGroups, #self.petGroups)
	for i = 1, #self.petGroups do
		local binding = self.content.items[i - 1]:GetComponent(UluaBinding)
		if binding ~= nil then 
			self.bindings[i] = binding
			self.bindings[i]:CallUpdate({index = i, data = self.petGroups[i]})
		end
	end
	self.binding:CallManyFrame(function()
		m:getSetChildsHeight()
	end, 1)
	if self.min == nil then 
		self.min = self.anim.from
		self.max = self.anim.to
	end 
	self:updateProperty()
end

function m:updateProperty()
	local magics = {}
	local tempKey = {}
	for i = 0, Player.Pets.suitid.Count - 1 do 
		local id = Player.Pets.suitid[i] 
		local tb = TableReader:TableRowByID("pettujian", id)
		if tb then 
			for j = 0, tb.addexpmagic.Count - 1 do 
				local m = tb.addexpmagic[j]
				if tempKey[m.magic_effect] == nil then 
					tempKey[m.magic_effect] =  m.magic_arg1 / m._magic_effect.denominator
				else 
					tempKey[m.magic_effect] = tempKey[m.magic_effect] + (m.magic_arg1 / m._magic_effect.denominator)
				end 
			end 
		end 
	end

	local left = ""
	local right = ""
	local left1 = ""
	local right1 = ""
	local descList = {left, left1, right, right1}
	local txtList = {self.left_desc, self.left_desc1, self.right_desc, self.right_desc2}
	local list = {}
	local life_index = nil
	for k,v in pairs(tempKey) do
		local row = TableReader:TableRowByID("magics", k)
		if row then 
			local text = string.gsub("[ffff96]" .. row.format .. "[-]","{0}", "[-] " .. v) .. "\n"
			local cell = {id = k, desc = text}
			-- 单独提升一下生命的排序， 蛋疼设计
			if k == 12 then 
				cell.id = 0.5
			end 
			table.insert(list, cell)
		end 
	end
	table.sort(list, function(a, b)
		return a.id < b.id
	end)
	local tempi = 1
	for i = 1, #list do 
		descList[tempi] = descList[tempi] .. list[i].desc 
		tempi = tempi + 1
		if tempi > 4 then 
			tempi = 1
		end 
	end 
	
	for i = 1, #txtList do 
		txtList[i].text = descList[i]
	end 
end 


function m:onClick(go, name)
    if name == "bg" then 
		if isup == true then 
			if self.anim == nil then return end 
			isup = false
			self.anim.from = self.max
			self.anim.to = self.min
			self.anim.enabled = true
			self.anim:ResetToBeginning()
			self.img_gengduo.transform.localRotation = Quaternion.Euler(0, 0, 90)
		else 
			if self.anim == nil then return end 
			isup = true
			self.anim.from = self.min
			self.anim.to = self.max
			self.anim.enabled = true
			self.anim:ResetToBeginning()
			self.img_gengduo.transform.localRotation = Quaternion.Euler(0, 0, -90)
		end 
    end
end 

function m:getSetChildsHeight()
	local width = 0
	if self.bindings ~= nil then 
		for i = 1, #self.bindings do 
			local h = self.bindings[i].target:width()
			width = width + h
			if i < #self.bindings then 
				self.content.items[i].transform.localPosition = Vector3(width + (self.content.spacing.x), self.content.items[i].transform.localPosition.y, 0)
				width = width + self.content.spacing.x
			end 
		end 
	end 
end 


function m:getPetGroups()
	local list = {}
	TableReader:ForEachTable("pettujian",
        function(index, item)
            if item ~= nil then
				local cell = {}
				cell.item = item
            	cell.active = true 
            	cell.delegate=self
            	table.insert(list,cell)
            end
            return false
        end)
	table.sort(list, function(a, b)
		return a.item.sort < b.item.sort
	end)
	return list
end

function m:getScrollView()
	return self.view
end

function m:Start()
	self.bg.gameObject:SetActive(false)	
	self.binding:CallManyFrame(function()
		self.bg.gameObject:SetActive(true)	
	end)
end

return m