local m = {} 

function m:Start()
	local lv = Player.yuling.yulingshu.curLevel
	local item1=TableReader:TableRowByID("yulingshu_lvup",lv)
	local item2=TableReader:TableRowByID("yulingshu_lvup",lv+1)
	self.name1.text=item1.name
	self.pic1.spriteName=item1.icon
	for i=0,item1.magic.Count-1 do
		local row = item1.magic[i]
		local arg1 = row.magic_arg1/row._magic_effect.denominator
		self["des".. (i+1)] .text=string.gsub("[ffff96]" .. row._magic_effect.format .. "[-]", "{0}", "[-][24FC24]" .. arg1)
	end
	if item2==mnil then 
		self.item2:SetActive(false)
		self.jiantou:SetActive(false)
		self.item1.transform.localPosition=Vector3(0,110,0)
	else 
		self.name2.text=item2.name
		self.pic2.spriteName=item2.icon
		for i=0,item2.magic.Count-1 do
			local row = item2.magic[i]
			local arg1 = row.magic_arg1/row._magic_effect.denominator
			self["des_".. (i+1)] .text=string.gsub("[ffff96]" .. row._magic_effect.format .. "[-]", "{0}", "[-][24FC24]" .. arg1)
		end
	end 
end

function m:onClick(go, name)
    if name == "closeBtn" then 
    	UIMrg:popWindow()
    end
end

return m