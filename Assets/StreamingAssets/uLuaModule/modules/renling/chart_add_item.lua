local m = {} 

function m:update(item, index, myTable, delegate)
	self.txt_name.text= item.star .. TextMap.GetValue("Text_1_2986")
	for i=1,#item._magic do
		if self["des".. i]==nil then
			local go = NGUITools.AddChild(self.gameObject, self["des".. ((i-1)%2+1)].gameObject)
			go.transform.localPosition = Vector3(self["des".. ((i-1)%2+1)].transform.localPosition.x, -2-30*(math.floor((i-1)/2)), 0)
			self["des".. i]=go:GetComponent(UILabel)
		end
		self["des".. i].text=item._magic[i]
	end
	for i=#item._magic+1,2 do
		self["des".. i].text=""
	end
	if item.star== item.cur_star then 
		self.Sprite:SetActive(true)
	else
		self.Sprite:SetActive(false)
	end 
end

function m:create(binding)
    self.binding = binding
    return self
end

return m