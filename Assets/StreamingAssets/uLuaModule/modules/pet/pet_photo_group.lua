local m = {} 
local xoffset = 65
function m:update(lua)
	self.delegate = lua.data.delegate
	self.data = lua.data
	self.txt_name.text = self.data.item.name
	
	local idArr = self.data.item.petid
	self.bg.width = idArr.Count * self.unitWidth - (idArr.Count - 1) * xoffset
	self.itemContent:Reset(1, idArr.Count, idArr.Count)
	for i = 1, idArr.Count do
		self.itemContent.items[i - 1]:GetComponent(UluaBinding):CallUpdate({delegate=self.delegate,show = self.data.item.can_show, index = i, data = idArr[i-1]})
	end
	self.active:SetActive(m:checkActive(self.data.item.id))
	m:updateProperty()
end

function m:checkActive(id)
	for i = 0, Player.Pets.suitid.Count - 1 do 
		if id == Player.Pets.suitid[i] then 
			return true
		end 
	end 
	return false
end 

function m:width()
	return self.bg.width
end 

function m:Start()
	self.unitWidth = self.bg.width
end 

function m:updateProperty()
	for i = 0, 3 do 
		local addexpmagic = self.data.item.addexpmagic[i]
		if addexpmagic ~= nil then 
			local text = "[ffff96]" .. addexpmagic._magic_effect.format .. "[-]"
			if m:checkActive(self.data.item.id) then 
				self["baselabel".. (i+1)].text = string.gsub(text,"{0}","[-][00ff00] " .. (addexpmagic.magic_arg1 / addexpmagic._magic_effect.denominator) .. "") 
			else
				self["baselabel".. (i+1)].text = string.gsub(text,"{0}","[-] " .. (addexpmagic.magic_arg1 /  addexpmagic._magic_effect.denominator)) 
			end 
		else
			self["baselabel".. (i+1)].text = ""
		end
	end
end

return m