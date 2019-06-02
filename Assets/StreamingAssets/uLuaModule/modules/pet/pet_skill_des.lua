
local m = {}

function m:update(lua)
	self.pet = lua.pet
	self:onUpdate()
end

function m:onUpdate()
	self.content:Reset(1, self.pet.modelTable.starup_skill.Count, self.pet.modelTable.starup_skill.Count)
	self.bindings = {}
	for i = 0, self.pet.modelTable.starup_skill.Count - 1 do
		local id = self.pet.modelTable.starup_skill[i]
		local binding = nil
		local go = self.content.items[i]
		if go ~= nil then binding = go:GetComponent(UluaBinding) end 
		if binding ~= nil then binding:CallUpdate({index = i, id = id}) end
		self.bindings[i+1] = binding
	end 
	
	self.binding:CallManyFrame(function()
		m:getSetChildsHeight()
	end, 1)
end 		

function m:getSetChildsHeight()
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
	--self.img_bg.height = height + 50
end 

function m:Start()

end

function m:onClick(go, name)
    if name == "btnBack" then
        UIMrg:popWindow()
	end
end

return m
