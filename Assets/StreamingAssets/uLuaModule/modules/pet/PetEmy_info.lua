local m = {} 

function m:update(data)
	if data ~= nil then
		self.data = data
		self.Label_hp.text =  string.format("%0.01f", tonumber(data.hp) / tonumber(data.max_hp)) * 100 .. "%"
		local curHp = data.hp / data.max_hp
		if curHp > 0.99 and curHp < 1 then
			self.Label_hp.text = "99%"
		end

		self.Sprite_slider.value = curHp

		if curHp < 0.06 and curHp > 0 then
			self.Label_hp.text = "1%"
		end
		
		local  char = Char:new(data.id)
    	local ima = char:getHeadSpriteName()

    	self.roleimage:setImage(ima, packTool:getIconByName(ima))
    	self.Sprite_bg.spriteName = char:getFrameBG()
    	self.Emy_info_kuang.spriteName = char:getFrame()
	end
end

function m:onClick(go, name)
	if name == "Btn_close" then
    	UIMrg:popWindow()
	end
end

return m