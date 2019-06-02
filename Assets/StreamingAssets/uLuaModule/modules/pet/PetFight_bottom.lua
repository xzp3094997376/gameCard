local m = {} 

function m:update()
	self.JudgeMap.gameObject:SetActive(false)
	self.Btn_Next.gameObject:SetActive(false)
	self.Btn_Chongxin.gameObject:SetActive(true)
		
	local resCost = TableReader:TableRowByID("petChapterArgs", 1)	--重置花费
	local tzInfo = TableReader:TableRowByID("petChapterArgs", 2)	--每天关卡挑战次数
	local viptimes = "vip"..Player.Info.vip.."_free_times"
	local resInfo = TableReader:TableRowByID("petChapterArgs", viptimes)	--免费重置次数
	self.costTimes = TableReader:TableRowByID("petChapterArgs", 5).arg	--每天付费重置次数
	self.Label_TiaoZhanValue.text = tzInfo.arg - Player.PetChapter.fightTimes
	self.TiaozhanValue = tzInfo.arg - Player.PetChapter.fightTimes
	self.Label_reset_value.text = resCost.arg2
	self.costZuanshi = resCost.arg2
	self.costType = resCost.arg

	--print("关卡挑战次数："..tzInfo.arg.." ,已挑战次数："..Player.PetChapter.fightTimes)
	if resInfo.arg - Player.PetChapter.resetTimes <= 0 then
		self.Label_Reset.text = "0"
	else
		self.Label_Reset.text = resInfo.arg - Player.PetChapter.resetTimes
	end

	self.resetValue = resInfo.arg - Player.PetChapter.resetTimes
	--print("可以重置次数："..resInfo.arg.." ，已经重置次数:"..Player.PetChapter.resetTimes)
	if self.resetValue == 0 then
		self.Label_Title_Reset.gameObject:SetActive(false)
		self.Reset_zuanshi.gameObject:SetActive(true)
		self.isCostGold = true
	else
		self.Label_Title_Reset.gameObject:SetActive(true)
		self.Reset_zuanshi.gameObject:SetActive(false)
		self.isCostGold = false
	end

	m:onUpdateChapter(Player.PetChapter.currentChapter)


	if Player.PetChapter[13].status == 1  then
		if Player.PetChapter.prizeTimes > 0 and self.TiaozhanValue > 0 then
			self.Btn_Next.gameObject:SetActive(true)
			self.Btn_Chongxin.gameObject:SetActive(false)
		else
			self.Btn_Next.gameObject:SetActive(false)
			self.Btn_Chongxin.gameObject:SetActive(true)
		end
	else
		self.Btn_Next.gameObject:SetActive(false)
		self.Btn_Chongxin.gameObject:SetActive(true)
	end

	if Player.PetChapter.currentChapter == 4 then
		self.Btn_Next.gameObject:SetActive(false)
		self.Btn_Chongxin.gameObject:SetActive(true)
	end
end

--更新下方的关卡显示信息
function m:onUpdateChapter(index)
	local offList = {}
	local onList = {}
	for i = 1, 4 do
		offList[i] = self["Guankapai_off_"..i]
		onList[i] = self["Next_icon_"..i]
		offList[i].gameObject:SetActive(true)
		onList[i].gameObject:SetActive(false)
	end

	for i = 1, index do
		onList[i].gameObject:SetActive(true)
		offList[i].gameObject:SetActive(false)
		if i == 4 then
			onList[i].gameObject:SetActive(false)
		end
	end
end

function m:ApiResetChapter()
	if self.isCostGold then
		desc=string.gsub(TextMap.GetValue("Text36"),"{0}",self.costZuanshi)
		desc=string.gsub(desc,"{1}", Tool.getResName(self.costType))
	            DialogMrg.ShowDialog(desc, function()
	           		Api:resetPetChapter(function(reuslt)
					 	Events.Brocast("RefreshPetGQInfo")
					 end)
	            end)
	else
			Api:resetPetChapter(function(reuslt)
				Events.Brocast("RefreshPetGQInfo")
			end)
	end
end


function m:onClick(go, name)
	if name == "Btn_Chongxin" then
		if self.resetValue <= 0 then
			m:ApiResetChapter()
			-- Api:resetPetChapter(function(reuslt)
			-- 		Events.Brocast("RefreshPetGQInfo")
			-- 	end)
			-- 	return
		elseif self.TiaozhanValue > 0 then
			self.JudgeMap.gameObject:SetActive(true)
			self.desc_value.text = self.TiaozhanValue
		else
			self.JudgeMap.gameObject:SetActive(false)
			m:ApiResetChapter()
		end
	elseif name == "Btn_Next" then
		Api:nextChapter(function(reuslt)
		 	Events.Brocast("RefreshPetGQInfo")
		 end)
	elseif name == "sure" then
		m:ApiResetChapter()
		self.JudgeMap.gameObject:SetActive(false)
	elseif name == "cancel" or name == "btnClose" then
		self.JudgeMap.gameObject:SetActive(false)
	end
end

return m