local m = {} 

function m:ShowBtn()
	self.chat_btn.gameObject:SetActive(true)
end

function m:HideBtn( ... )
	self.chat_btn.gameObject:SetActive(false)
end

function m:ShowRed()
	self.red_point:SetActive(true)
end

function m:HideRed( ... )
	self.red_point:SetActive(false)
end

--点击事件
function m:onClick(uiButton, eventName)
	if eventName == "chat_btn" then 
		uSuperLink.openModule(106)
	end
end 

function m:OnDrag(go,name,detal)
	if name == "chat_btn" then 
		go.transform.localPosition = go.transform.localPosition+ Vector3(detal.x,detal.y,0)
	end 
end

return m