

local m = {}

function m:Start()
	--ClientTool.AddClick(self.gameObject, function()
	--	if self.char == nil then return end 
	--	if self.isClick == true then
	--		Tool.push("heroInfo", "Prefabs/moduleFabs/hero/hero_info", self.char)
	--	end
	--end)
	UIEventListener.Get(self.binding.gameObject).onDrag = function(name, delta)
		self.delegate:herosMove(delta)
		self.yuling.gameObject:SetActive(self.have_yuling and self.hero.gameObject.activeInHierarchy)
	end
	
	UIEventListener.Get(self.binding.gameObject).onPress = function(go, ret)
		self.delegate:onCallbackPress(ret)
		self.yuling.gameObject:SetActive(self.have_yuling and self.hero.gameObject.activeInHierarchy)
	end
end

function m:onClick(go, name)
	if name == "btn_hero" then 
		if self.char == nil then return end 
		if self.isClick == true then
			Tool.push("heroInfo", "Prefabs/moduleFabs/hero/hero_info", self.char)
		end
	end 
end

function m:update(lua)
	self.char = lua.char
	self.isClick = lua.isClick
	self.delegate = lua.delegate
	self.yuling.gameObject:SetActive(false)
	self.have_yuling =false
	if self.char == nil then 
		self.hero.gameObject:SetActive(false)
	else 
		self.hero.gameObject:SetActive(true)
		self.hero:LoadByModelId(self.char.modelid, "idle", function()
		end, false, 0, 1)
	    local yulingid = self.char:getYuling(self.char.id)
	    if yulingid ~= nil and yulingid ~= "0" and yulingid ~= 0 then
	    	self.yuling.gameObject:SetActive(true)
	    	self.have_yuling =true
	    	local _yuling = Yuling:new(yulingid)
	        self.yuling:LoadByModelId(_yuling.modelid, "idle", function() end, false, 100, 1)
	    end 
	end 
end

return m

