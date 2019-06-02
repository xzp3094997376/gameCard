

local m = {}

function m:Start()
	ClientTool.AddClick(self.gameObject, function()
		if self.char == nil then return end 
		Tool.push("heroInfo", "Prefabs/moduleFabs/hero/hero_info", self.char)
	end)
	UIEventListener.Get(self.binding.gameObject).onDrag = function(name, delta)
		if delta.x > 0.5 then
			if self.delegate then 
				self.delegate:onDragStart()
				self.delegate:onCallBackDir(2)
			end 
		elseif(delta.x < -0.5) then
			if self.delegate then 
				self.delegate:onDragStart()
				self.delegate:onCallBackDir(1)
			end 
		end
	end
	
	UIEventListener.Get(self.binding.gameObject).onPress = function(go, ret)
		self.delegate:onCallbackPress(ret)
	end
end

function m:update(lua)
	self.char = lua.char
	self.delegate = lua.delegate
	if self.char == nil then 
		self.hero.gameObject:SetActive(false)
	else 
		self.hero.gameObject:SetActive(true)
		self.hero:LoadByModelId(self.char.modelid, "idle", function()
		end, false, 0, 1)
	end 
end

return m

