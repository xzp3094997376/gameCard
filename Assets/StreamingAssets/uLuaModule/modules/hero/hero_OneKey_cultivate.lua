local m = {} 

function m:update(delegate)
	self.delegate = delegate
	self.isCheck = false
	self.select.gameObject:SetActive(false)
end

function m:onClick(go, name)
	if name == "btn_sure" then
		if self.delegate ~= nil then
			self.delegate:CallBackOnekeyCul(self.isCheck)
			self.gameObject:SetActive(false)
		end
	elseif name == "btn_cancle" or name == "btn_close" then
		self.gameObject:SetActive(false)
	elseif name == "btn_check" then
		if self.isCheck == true then
			self.isCheck = false
			self.select.gameObject:SetActive(false)
		elseif self.isCheck == false then
			self.isCheck = true
			self.select.gameObject:SetActive(true)
		end
	end
end

return m