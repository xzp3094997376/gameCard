local m = {} 
local xoffset = 65

function m:update(data)
	self.delegate = data.delegate
	self.index = data.index
	self.data = data.data
	self.fashions = data.data.fashions
	--Tool.getNameColor(math.min(self.data.star,self.data.star)) .. 
	self.name.text = self.data.item.name .."[-]"
	self.bg.width = #self.fashions * self.unitWidth - (#self.fashions - 1) * xoffset
	self.itemContent:Reset(1, #self.fashions, #self.fashions)
	for i = 1, #self.fashions do
		self.itemContent.items[i - 1]:GetComponent(UluaBinding):CallUpdate({char = self.fashions[i]})
	end
	--if self.data.fashions[2]~=nil then 
	--	self.item2:CallUpdate({delegate=self,char=self.data.fashions[2]})
	--end
	if self.data.active==true then 
		self.active:SetActive(true)
	else 
		self.active:SetActive(false)
	end 
	local addexpmagic = self.data.item.magic
	for i=1,addexpmagic.Count do
		if addexpmagic[i-1]._magic_effect ~=nil  then 
			local text="[F0E77B]" .. addexpmagic[i-1]._magic_effect.format .. "[-]"
			if self.data.active==true then
				local tb =split(addexpmagic[i-1]._magic_effect.format, "{0}")
				if tb[2]~=nil then 
					self["baselabel".. i].text="[F0E77B]" .. tb[1] .. "[24FC24] " .. addexpmagic[i-1].magic_arg1/tonumber(addexpmagic[i-1]._magic_effect.denominator or 1) ..tb[2] .."[-]"
				else 
					self["baselabel".. i].text=string.gsub(text,"{0}","[-][24FC24] " .. addexpmagic[i-1].magic_arg1/tonumber(addexpmagic[i-1]._magic_effect.denominator or 1) ) 
				end 
			else 
				self["baselabel".. i].text=string.gsub(text,"{0}","[-] " .. addexpmagic[i-1].magic_arg1/tonumber(addexpmagic[i-1]._magic_effect.denominator or 1))
			end   
		else 
			self["baselabel".. i].text=""
		end
	end
	for i=addexpmagic.Count+1,4 do
		self["baselabel".. i].text=""
	end
	if addexpmagic.Count<=2 then 
		self.des.transform.localPosition = Vector3(0, 10, 0)
	else 
		self.des.transform.localPosition = Vector3(0, 26, 0)
	end 
end

function m:width()
	return self.bg.width
end 

function m:Start()
	self.unitWidth = self.bg.width
end 

--初始化
function m:create(binding)
    self.binding = binding
    self.gameObject = self.binding.gameObject
    return self
end

return m