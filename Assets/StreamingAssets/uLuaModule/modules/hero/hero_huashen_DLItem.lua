local dl = {} 

function dl:update(info, index)
	if info ~= nil then
		self.data = info.data
		self.char = info.char
		self.charLevel = index
		self.delegate = info.delegate
		local desc = self.data.desc
		local qlv = Player.Chars[self.char.id].qualitylvl
		self.DenglongXiao_Off.gameObject:SetActive(false)
		self.DenglongDa_Off.gameObject:SetActive(false)
		self.DenglongDa_On.gameObject:SetActive(false)
		-- if self.data.level < 5 then
		-- 	self.DenglongXiao_Off.gameObject:SetActive(true)
		-- else
		if self.data.level % 5 == 0 then
			self.DenglongDa_Off.gameObject:SetActive(true)
			self.isDaDl = true
		else
			self.DenglongXiao_Off.gameObject:SetActive(true)
			self.isDaDl = false
		end

		if qlv >= self.data.level then
			self.DenglongXiao_Off.gameObject:SetActive(false)
			self.DenglongDa_Off.gameObject:SetActive(false)
			--self.DenglongDa_On.gameObject:SetActive(false)
			self.DenglongDa_On.gameObject:SetActive(true)
			self.DenglongDa_On.spriteName = self.data.icon
			desc = "[ffff00]"..desc.."[-]"
		end
		self.Label_level.text = desc
	end
end

function dl:onClick(go, name)
	if name == "Btn_Denglong" then
		if self.isDaDl == true then
			if self.data ~= nil then
			self.DetailInfoForDa.gameObject:SetActive(true)
			local info = {}
			info.data = self.data
			info.char = self.char
			self.DetailInfoForDa:CallUpdate(info)
			info = nil
			end
		elseif self.isDaDl == false then
			if self.data ~= nil then
				self.DetailInfo.gameObject:SetActive(true)
				self.Label_Click_Title.text = string.gsub(self.data.magic[j]._magic_effect.format, "：{0}", "")
				self.Label_Click_value1.text = " +"..self.data.magic[j].magic_arg1
			end
		end

	elseif name == "Btn_close_detail" then
		self.DetailInfo.gameObject:SetActive(false)
	end
end

return dl