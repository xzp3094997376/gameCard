local CampItemShow = {} 
local timeId = 0

--初始化
function CampItemShow:create(binding)
    self.binding = binding
    self.gameObject = self.binding.gameObject
    return self
end

function CampItemShow:update(lua)
	if lua ~=nil then
		self.data=lua.data
	end
	if self.data~=nil and self.data.star>5 then 
		self.zhenying_hongseqiu:SetActive(true)
		self.zhenying_lanseqiu:SetActive(false)
		self.effect_hong:SetActive(true)
		self.effect_lan:SetActive(false)
	else 
		self.zhenying_hongseqiu:SetActive(false)
		self.zhenying_lanseqiu:SetActive(true)
		self.effect_hong:SetActive(false)
		self.effect_lan:SetActive(true)
	end
	--local txt =self.text:GetComponent(TextMesh)
	--txt.text =self.data.name 
	--txt.color=Tool.getTxtColor(self.data.star)
	if self.data~=nil then
		self.Name.text=self.data:getDisplayColorName()
	end
	self.ani.enabled=false
end

function CampItemShow:playEffect()
	if self.ani==nil then return end
	self.ani:ResetToBeginning()
	self.ani.enabled=true
	self.ani.gameObject:SetActive(true)
	self.binding:CallAfterTime(1, function()
 			self.ani.enabled=false
 			self.ani:ResetToBeginning()
 		end)
end

function CampItemShow:ResetAni()
	if self.ani==nil then return end
	self.ani:ResetToBeginning()
	self.ani.enabled=false
end



return CampItemShow