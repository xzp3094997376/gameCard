local m = {} 

function m:update(data,index,delegate)
    self.index = index
    self.data = data
    self.delegate = delegate
    self.desc.text=data
	
	self.Sprite.height = self.desc.height+20
end

return m