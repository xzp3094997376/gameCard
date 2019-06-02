local m = {} 

function m:update(data, index, _table, delegate)
	local char = Char:new(data.head)
	self.pic.Url= UrlManager.GetImagesPath("headImage/"..char:getHeadSpriteName() ..".png")
	self.kuang.Url= UrlManager.GetImagesPath("sl_kuang/"..Tool.getFrame(data.quality) ..".png")
	self.frame.spriteName=Tool.getBg(data.quality)
	self.vip_num.text="VIP " .. data.vip
	self.name.text=Tool.getItemColor(data.quality).color .. data.from .. "[-]"
	self.delegate=data.delegate
	if self.delegate.tp==3 then 
		if data.to~=nil then 
			self.desc.text=string.gsub(TextMap.GetValue("LocalKey_864"),"{0}",data.to) .. data.content
		else
			local char = Char:new(Player.Info.playercharid)
			self.desc.text=string.gsub(TextMap.GetValue("LocalKey_864"),"{0}",char.itemColorName) .. data.content
		end 
	else 
		self.desc.text=data.content
	end 
	self.data=data
	if self.desc.height>38 then 
		self.descSprite.height=self.desc.height+20
	else
		self.descSprite.height=58
	end
	self.time.text=Tool.getFormatTime(data.t / 1000)
end

--点击事件
function m:onClick(uiButton, eventName)
	print(eventName)
	if eventName == "btn_name" then
		self.delegate:setInputName(self.data.from)
	end 
end 

return m