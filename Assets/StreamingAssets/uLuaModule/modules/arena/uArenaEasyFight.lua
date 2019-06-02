local m = {} 
	
function m:update(info)
	self.data = info
	self.selectNum.text = 1
	self.Item_Num.text = 2
	local havenum = Player.ItemBagIndex[6].count --物品数量
	self.costValue = TableReader:TableRowByID("vsArgs", "vsconsume").consume[0].consume_arg -- 这里需要完善，不能写死
	self.isUseItem = false
	self.select.gameObject:SetActive(false)
end

function m:onClick(go, name)
	if name == "Btn_close" then
		UIMrg:popWindow()
	elseif name == "Btn_challenge" then
		local infoList = {}
        if Player.Resource.vp >= (self.costValue * self.selectNum.text) then
        	infoList.data = self.data
			infoList.isUseItem = self.isUseItem
			infoList.times = tonumber(self.selectNum.text)
			infoList.useCost = self.costValue
			UIMrg:popWindow()
			UIMrg:pushWindow("Prefabs/moduleFabs/arenaModule/ArenaEasyFightResult", infoList)
        else
        	if Player.ItemBagIndex[6].count > 0 then
        		if self.isUseItem == true then
        			infoList.data = self.data
					infoList.isUseItem = self.isUseItem
					infoList.times = tonumber(self.selectNum.text)
					infoList.useCost = self.costValue
					UIMrg:popWindow()
					UIMrg:pushWindow("Prefabs/moduleFabs/arenaModule/ArenaEasyFightResult", infoList)
        		else 
                    --MessageMrg.show("精力不足")
                    DialogMrg:BuyBpAOrSoul("vp", "", cb ,cb )
                end
            else
                DialogMrg:BuyBpAOrSoul("vp", "", cb ,cb )
            end
        end				
	elseif name == "Btn_cancle" then
		UIMrg:popWindow()
	elseif name == "btn_check" then
		if self.isUseItem == true then
			self.isUseItem = false
			self.select.gameObject:SetActive(false)
		elseif self.isUseItem == false then
			self.isUseItem = true
			self.select.gameObject:SetActive(true)
		end
	elseif name == "btn_add1" then
		self.selectNum.text = self.selectNum.text + 1
		if self.selectNum.text + 1 > 100 then
			self.selectNum.text = 100
		end
		self.Item_Num.text = self.selectNum.text * self.costValue
	elseif name == "btn_sub1" then
		if tonumber(self.selectNum.text) > 1 then
			self.selectNum.text = self.selectNum.text - 1
			self.Item_Num.text = self.selectNum.text * self.costValue
		end
	elseif name == "btn_add10" then
		self.selectNum.text = self.selectNum.text + 10
		if self.selectNum.text + 1 > 100 then
			self.selectNum.text = 100
		end
		self.Item_Num.text = self.selectNum.text * self.costValue
	elseif name == "btn_sub10" then
		if tonumber(self.selectNum.text) > 10 then
			self.selectNum.text = self.selectNum.text - 10
			self.Item_Num.text = self.selectNum.text * self.costValue
		end
	end
end

return m