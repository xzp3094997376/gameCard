
local m = {}

function m:update(lua)
    --local nChar = lua.nChar
    self.char = lua.char
	self.type = lua.type
	if lua.type == "skill" then 
		self:onUpdateSkill()
	elseif lua.type == "other" then 
		self:onUpdateOther(lua.list)
	end 
end

function m:onUpdateOther(list)
	if #list==0 and self.desc~=nil and self.title~=nil then 
		self.desc.text=string.gsub(TextMap.GetValue("LocalKey_710"),"{0}",self.title.text)
		self.img_bg.height=70
		return 
	end
	if self.desc~=nil then 
		self.desc.text=""
	end 
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

function m:onUpdateSkill()
	local skills = self.char:getAllSkill()
	self.content:Reset(#skills, 1, #skills)
	self.bindings = {}
	for i = 0, #skills - 1 do
		local binding = nil
		local go = self.content.items[i]
		if go ~= nil then binding = go:GetComponent(UluaBinding) end 
		if binding ~= nil then binding:CallUpdate({index = i, type = "skill", data = skills[i+1]}) end
		self.bindings[i+1] = binding
	end 
	
	self.binding:CallManyFrame(function()
		m:getSetChildsHeight(50)
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
		self.img_bg.height = height + 50
	end
end 

function m:OnDestroy()
    Events.RemoveListener('select_skill')
end

function m:onSelectSkill(skill, go)
    ClientTool.AlignToObject(self.selected_node, go, 3)
    m:showSkill(skill)
end

function m:Start()
    Events.AddListener("select_skill", funcs.handler(self, m.onSelectSkill))
end

return m

