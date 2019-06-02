local m = {} 

function m:update(info)
	self.Label_Title.gameObject:SetActive(true)
	self.Label_Title.text = info
end
return m