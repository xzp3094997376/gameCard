local m = {} 

function m:update()
	if self.content.width>=self["_keyMap"].width then 
		self.content.pivot = UIWidget.Pivot.Right
	else
		self.content.pivot = UIWidget.Pivot.Left 
		self.content.transform.localPosition=Vector3(self["_keyMap"].startX,-2,0)
	end 
end

return m