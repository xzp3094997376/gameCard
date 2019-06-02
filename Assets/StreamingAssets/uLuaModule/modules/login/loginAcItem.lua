local m = {} 

function m:update(data)
	self.Label_Name.text = data.name
	self.uid = data.name
	self.delegate = data.delegate
	self.isRegist = data.isRegist
    self.uidIndex = data.index
end

function m:onClick(go, name)
    if name == "ItemButton" then
        if self.isRegist then
            self.delegate:choiseACuLogin(self.uidIndex, self.uid, true)
        else
            self.delegate:choiseACuLogin(self.uidIndex, self.uid, false)
        end
        UIMrg:popWindow()
    end
end

return m