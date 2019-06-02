local m = {} 
--右侧每日半价抢购的界面脚本

function m:update(data)
	--print_t(data)
	--print_t(data)
	self.dropList = data.info
	self.delegate = data.delegate
	self.actType = data.delegate.actType
	self.taksId = data.info[1].id
	self.Btn_next.gameObject:SetActive(false)
	self.Btn_Pre.gameObject:SetActive(false)
	self.Text_Tip.gameObject:SetActive(false)
	self.curStep = 1
	if self.dropList[self.curStep - 1] ~= nil then
		self.Btn_Pre.gameObject:SetActive(true)
	else
		self.Btn_Pre.gameObject:SetActive(false)
	end

	if self.dropList[self.curStep + 1] ~= nil then
		self.Btn_next.gameObject:SetActive(true)
	else
		self.Btn_next.gameObject:SetActive(false)
	end

	m:setViewData(self.curStep)
end

function m:setViewData(index)
	if self.dropList[index] ~= nil then
		self.taksId = self.dropList[index].id
		self.dayNum = self.dropList[index].day_num
		local dropInfo = self.dropList[index]
		local dropList = {}
		for i = 0, dropInfo.drop.Count do
			table.insert(dropList, dropInfo.drop[i])
		end
		self.Grid:refresh(self.ActItem, dropList)
		-- self.binding:CallAfterTime(0.01, function()
	         self.ScrollView:ResetPosition()
	 --    end)
	 	local iconName = {}
	 	if self.delegate.actType == "day7" then
		 	self.new_price.text = dropInfo.times--现价
		 	self.old_price.text = tonumber(dropInfo.times) * 2--原价
		 	self.Text_title.text = dropInfo.target_desc
		 	iconName = Tool.getResIcon(dropInfo.type)
		else
			self.new_price.text = dropInfo.consume[index - 1].consume_arg--现价
		 	self.old_price.text = tonumber(dropInfo.consume[index - 1].consume_arg) * 2--原价
		 	self.Text_title.text = dropInfo.target_desc
		 	iconName = Tool.getResIcon(dropInfo.consume[index - 1].consume_type)
	 	end

		self.old_Sprite.Url = UrlManager.GetImagesPath("itemImage/"..iconName..".png")
		self.new_Sprite.Url = UrlManager.GetImagesPath("itemImage/"..iconName..".png")
	end
	if self.actType == "day7" then
    	self.PlayactTypeList = Player.Day7s
		m:judgeBtnState(Player.Day7s)
	else
		self.PlayactTypeList=Player.DayNs[self.actType]
		m:judgeBtnState(Player.DayNs[self.actType])
	end
end

function m:judgeBtnState(PlayactTypeList)
	self.hasGet.gameObject:SetActive(false)
	self.btGet.gameObject:SetActive(false)
	--print_t("状态："..PlayactTypeList[self.taksId].state)
	if self.dayNum <= PlayactTypeList.day then
		if PlayactTypeList[self.taksId].state == 2 then
			self.btGet.gameObject:SetActive(true)
		elseif PlayactTypeList[self.taksId].state == 3 then
			self.hasGet.gameObject:SetActive(true)
		end
	end

	if self.dropList[self.curStep].drwc == 1 and self.Text_Tip ~= nil then
		self.Text_Tip.gameObject:SetActive(true)
    	if dropInfo.day_num == self.PlayactTypeList.day then
    		self.Text_Tip.text = TextMap.GetValue("Text_1_90")
    		if PlayactTypeList[self.taksId].state == 3 then
    			self.Text_Tip.text = ""
    		end
    	elseif dropInfo.day_num < self.PlayactTypeList.day then
    		if PlayactTypeList[self.taksId].state == 2 or PlayactTypeList[self.taksId].state == 3 then
    			self.Text_Tip.text = ""
			else
    			self.Text_Tip.text = TextMap.GetValue("Text_1_91")
    		end
    	else
			self.Text_Tip.gameObject:SetActive(false)
    	end
    end
end

function m:onClick(go,name)
	if name == "Btn_next" then
		self.curStep = self.curStep + 1
		m:setViewData(self.curStep)
		if self.dropList[self.curStep + 1] == nil then
			self.Btn_next.gameObject:SetActive(false)
		end
		if self.dropList[self.curStep - 1] ~= nil then
			self.Btn_Pre.gameObject:SetActive(true)
		end
	elseif name == "Btn_Pre" then
		self.curStep = self.curStep - 1
		m:setViewData(self.curStep)
		if self.dropList[self.curStep - 1] == nil then
			self.Btn_Pre.gameObject:SetActive(false)
		end
		if self.dropList[self.curStep + 1] ~= nil then
			self.Btn_next.gameObject:SetActive(true)
		end
	elseif name == "btGet" then
		if self.taksId ~= nil then
			if self.delegate.actType == "day7" then
				Api:subDay7(self.taksId, function(result)
						m:judgeBtnState(self.PlayactTypeList)
						--packTool:showMsg(result, nil, 2)
						Events.Brocast("UpdateRedPoint")
						self.delegate:showMsg(result)
					end, function() end)
			else
				Api:subDay14(self.delegate.actType, self.taksId, 1, function(result)
					m:judgeBtnState(self.PlayactTypeList)
					--packTool:showMsg(result, nil, 2)
					Events.Brocast("UpdateRedPoint")
					self.delegate:showMsg(result)
				end, function() end)
			end
		end
	end
end

return m