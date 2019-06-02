local m = {} 

function m:update(data,index,delegate)
	for i=1,7 do 
		self["info" .. i].gameObject:SetActive(false)
	end 
	for i=1,#data do
		self["info" .. i].gameObject:SetActive(true)
		self["info" .. i]:CallUpdate(data[i],i-1,self)
	end
end

return m