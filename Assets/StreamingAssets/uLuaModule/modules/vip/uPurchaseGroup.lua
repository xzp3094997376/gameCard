local m = {}

function m:update(data, index, delegate)
	if data==nil then 
		self.cell1.gameObject:SetActive(false)
		self.cell2.gameObject:SetActive(false)
	else
		self.cell1.gameObject:SetActive(true)
		self.cell1:CallUpdate(data[1])
		if data[2] then
			self.cell2:CallUpdate(data[2])
			self.cell2.gameObject:SetActive(true)
		else
			self.cell2.gameObject:SetActive(false)
			self.cell1.gameObject.transform.localPosition=Vector3(0,-12,0)
		end
    end
end

function m:onUpdate()
	self.cell1:CallTargetFunction("onUpdate")
	self.cell2:CallTargetFunction("onUpdate")
end

return m