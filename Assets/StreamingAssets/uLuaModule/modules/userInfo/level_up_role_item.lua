local m = {}

function m:update(data)
	self.data = data.data
	local data = self.data
	self.txt_name.text = data.show_name
	self.txt_des.text = data.decs
	self.img_icon.Url = UrlManager.GetImagesPath("tasksImage/" .. data.icon ..".png")
	local unlock_lv = data.unlock_lv
	if Player.Info.level >= tonumber(unlock_lv) then 
		if data.droptype == nil or data.droptype == "" then 
			self.img_go.gameObject:SetActive(false)
			self.txt_lock.gameObject:SetActive(true)
			self.txt_lock.text = TextMap.GetValue("Text_1_2826")
		else 
			self.img_go.gameObject:SetActive(true)
			self.txt_lock.gameObject:SetActive(false)
		end 
	else 
		self.img_go.gameObject:SetActive(false)
		self.txt_lock.gameObject:SetActive(true)
		self.txt_lock.text = "[ff0000]" ..string.gsub(TextMap.GetValue("LocalKey_737"),"{0}",unlock_lv .."[-]")
	end 
end


function m:onClick(go, name)
    if name == "img_go" then
		if not GuideMrg:isPlaying() and self.data.droptype then 
			UIMrg:popWindow()
			uSuperLink.openModule(tonumber(self.data.droptype))
		end 
    end
end

function m:Start()

end

return m