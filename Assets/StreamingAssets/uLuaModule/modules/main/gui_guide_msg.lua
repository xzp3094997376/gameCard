local m = {}
local Timer = nil
function m:onUpdate()
	local isData = false
	for i = Player.Info.level + 1, self.maxLv do 
		local tb = TableReader:TableRowByID("lvUpTarget", i)
		if tb ~= nil then
			isData = true
			self.txt_desc.text = tb.desc
			self.txt_title.text = TextMap.GetValue("Text_1_935") .. tb.id .. TextMap.GetValue("Text_1_936")
			break
		end 
	end 
	if isData == false then 
		self.binding.gameObject:SetActive(false)
	end 
end

function m:flyOut()
	if self.isToTarget == false then 
		m:onUpdate()
		self.go_msg:SetActive(false)
		self.anim_btn.from = self.zeroPos.transform.localPosition
		self.anim_btn.to = self.targetPos.transform.localPosition
		self.anim_btn.enabled = true
		self.anim_btn:ResetToBeginning()
		Timer = LuaTimer.Add((self.anim_btn.duration + self.img_bg.duration)*1000, function(id)
			self.btn_tishi.isEnabled = true
		end)
		self.binding:CallAfterTime(self.anim_btn.duration, function()
			self.go_msg:SetActive(true)
			self.btn_tishi.isEnabled = true
			
			self.img_bg.from = self.origin_scale
			self.img_bg.to = self.target_scale
			self.img_bg.enabled = true
			self.img_bg:ResetToBeginning()

			self.anim_desc.from = self.origin_scale
			self.anim_desc.to = self.target_scale
			self.anim_desc.enabled = true
			self.anim_desc:ResetToBeginning()
			
			self.anim_title.from = self.origin_scale
			self.anim_title.to = self.target_scale
			self.anim_title.enabled = true
			self.anim_title:ResetToBeginning()
		end)
		self.isToTarget = true
	end 
end

function m:fly()
	self.btn_tishi.isEnabled = false
	if self.isToTarget == false then 
		m:flyOut()
	else
		self.go_msg:SetActive(true)
		
		self.img_bg.from = self.target_scale
		self.img_bg.to = self.origin_scale
		self.img_bg.enabled = true
		self.img_bg:ResetToBeginning()
		
		self.anim_desc.from = self.target_scale
		self.anim_desc.to = self.origin_scale
		self.anim_desc.enabled = true
		self.anim_desc:ResetToBeginning()		

		self.anim_title.from = self.target_scale
		self.anim_title.to = self.origin_scale
		self.anim_title.enabled = true
		self.anim_title:ResetToBeginning()
	
		Timer = LuaTimer.Add((self.anim_btn.duration + self.img_bg.duration)*1000, function(id)
			self.btn_tishi.isEnabled = true
		end)
		self.binding:CallAfterTime(self.img_bg.duration, function()
			self.go_msg:SetActive(false)
			self.btn_tishi.isEnabled = true
			self.anim_btn.from = self.targetPos.transform.localPosition
			self.anim_btn.to = self.zeroPos.transform.localPosition
			self.anim_btn.enabled = true
			self.anim_btn:ResetToBeginning()
		end)
		self.isToTarget = false
	end 
	--self.isToTarget = not self.isToTarget
	--self.binding:CallAfterTime(self.anim_btn.duration + self.scale_msg.duration, function()
	--	self.btn_tishi.isEnabled = true
	--end)
end  

function m:onClick(go, name)
	if name == "btn_tishi" then 
		m:fly()
	end 
end 

function m:onPos()
	if self.isToTarget == false then 
		self.anim_btn.gameObject.transform.localPosition = self.zeroPos.transform.localPosition
	end
end

function m:Start()
	m:onPos()
	self.go_msg:SetActive(false)
	--self.origin 
	self.origin_scale = self.img_bg.from
	self.target_scale = self.img_bg.to
	self.isToTarget = false
	self.maxLv = Tool.GetCharArgs("max_lv")
end

return m

