local m = {}


function m:update(data)
	self.data = data.targetInfo
	self.list = data.list
	m:onUpdateOther(data.list)
end

function m:onUpdateOther(list)
	self.content:Reset(#list, 1, #list)
	self.bindings = {}
	for i = 0, #list - 1 do
		local binding = nil
		local go = self.content.items[i]
		if go ~= nil then binding = go:GetComponent(UluaBinding) end 
		if binding ~= nil then binding:CallUpdate({index = i, type = "other" , data = list[i+1]}) end
		self.bindings[i+1] = binding
	end 
	
	self.binding:CallManyFrame(function()
		m:getSetChildsHeight(0)
	end, 1)
end 

function m:getSetChildsHeight(offset)
	local height = 0
	if self.bindings ~= nil then 
		for i = 1, #self.bindings do 
			local h = self.bindings[i].target:height()
			height = height + h
			if i < #self.bindings then 
				self.content.items[i].transform.localPosition = Vector3(self.content.items[i].transform.localPosition.x, -height - (self.content.spacing.y), 0)
				height = height + self.content.spacing.y
			end 
		end 
	end
	if self.img_bg ~= nil then 
		self.img_bg.height = height + 40
	end
end 

return m