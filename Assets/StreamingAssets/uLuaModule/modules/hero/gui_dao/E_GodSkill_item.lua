local m = {} 

function m:update(data)
	self.Label_Name.text = data.name
	self.Label_dis.text = data.desc
end

return m