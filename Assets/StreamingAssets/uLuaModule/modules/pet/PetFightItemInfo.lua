local m = {} 

local listobj = {}

function m:update(datas)

	if datas ~= nil then
		m:updateInfo(datas)
		m:createTeamInfo()
	end
end

function m:updateInfo(datas)
	self.data = datas.data
	self.index = datas.index
	self.Label_name.text = Char:getItemColorName(self.data.quality, self.data.nickname)
	self.Label_Lv.text =string.gsub(TextMap.GetValue("LocalKey_812"),"{0}",self.data.level)
	self.Label_PowValue.text = toolFun.moneyNumberShowOne(math.floor(tonumber(self.data.power)))
	self.JudgeMap.gameObject:SetActive(false)
	local modelTab = TableReader:TableRowByID("avter", self.data.modelId)
	if self.data.modelId ~= nil and self.data.modelId ~= "" and self.data.modelId ~= "0" and modelTab ~= nil then
		self.img_hero:LoadByModelId(tonumber(self.data.modelId), "idle", function() end, false, 0, 1, 255, 0)
		local yulingid = self.data.yulingid
		if yulingid~=nil and yulingid~=0 and yulingid~="0" and yulingid~="" then
	        local yulingM = Yuling:new(yulingid)
	        if yulingM.modelid~=nil then 
	            self.yuling.gameObject:SetActive(true)
	            self.yuling:LoadByModelId(yulingM.modelid, "idle", function() end, false, 100, 1)
	        end 
	    end 
	else
		self.img_hero:LoadByModelId(800, "idle", function() end, false, 0, 1, 255, 0)
	end

	local info = TableReader:TableRowByID("petChapterPrizeadd", Player.PetChapter.currentChapter)
	if info ~= nil then
		self.Label_SerTips.gameObject:SetActive(true)
		if (tonumber(info.proportion) / 10) == 0 then
			self.Label_SerTips.text = TextMap.GetValue("Text_1_950")
		else
			self.Label_SerTips.text = TextMap.GetValue("Text_1_951")..(tonumber(info.proportion) / 10).."%）"
		end
	else
		self.Label_SerTips.gameObject:SetActive(false)
	end
		
	local power = self.data.power
	local prePower = 0
	local nextPower = 0
	local preSh = 0
	local nextSh = 0
	local rewardPc = TableReader:TableRowByUniqueKey("petChapter", Player.PetChapter.currentChapter, datas.index)
	local index = 0
	local count = 0
	local iconType 
	for i = 1, 26 do
		local res = TableReader:TableRowByID("petChapterPrize", i)
		if power >= res.fight then
			index = i
			count = res.drop[0].arg
		end
		-- if power < res.fight then
		-- 	index = i - 1
		-- 	break
		-- elseif power >= res.fight then
		-- 	index = i
		-- 	break
		-- end
		-- index = index + 1
	end
	if rewardPc ~= nil then
		local item = RewardMrg.getDropItem({type=rewardPc.drop[0].type,arg2=1, arg=rewardPc.drop[0].arg})
		local iconPath = item.Table.img or item.Table.iconid
		local atlasName = packTool:getIconByName(iconPath)
		self.Sprite_icon_pc:setImage(iconPath, atlasName)
		self.Label_pc_value.text = rewardPc.drop[0].arg2
	end

	-- if index > 0 then
	-- 	for i = 1, index do
	-- 		local rec = TableReader:TableRowByID("petChapterPrize", i)
	-- 		if rec ~= nil then
	-- 			count = rec.drop[0].arg--count + 
	-- 		end
	-- 	end
	-- else
	-- 	count = 0
	-- end

	local pre = TableReader:TableRowByID("petChapterPrize", index)
	local nextP = TableReader:TableRowByID("petChapterPrize", index + 1)
	iconType = nextP.drop[0].type
	if pre ~= nil then
		prePower = pre.fight
		preSh = pre.drop[0].arg
	end
	if nextP ~= nil then
		nextPower = nextP.fight
		nextSh = nextP.drop[0].arg
	end
	local ss = math.floor((count + math.floor((power - prePower) / (nextPower - prePower) * (nextSh - preSh))) * (1 + (tonumber(info.proportion) / 1000)))
	local iconName = Tool.getResIcon(iconType)
	self.Sprite_icon_wr.Url = UrlManager.GetImagesPath("itemImage/"..iconName..".png")
	self.Label_winRw.text = ss
end

function m:createTeamInfo()
	local petData = {}
	for i = 1, 6 do
		if self.data.team[i - 1] ~= nil then
			listobj[i] = ClientTool.loadAndGetLuaBinding("Prefabs/moduleFabs/arenaModule/PetEmy_info", self.img_roleKuang)
			listobj[i]:CallUpdate(self.data.team[i - 1])
		end
	end
	if self.data.team[6] ~= nil then
		local petInfo = self.data.team[6]
		if petInfo.id ~= "" and petInfo.id ~= nil and petInfo.id ~= 0 and petInfo.id ~= "0" then
            local pet = Pet:new(nil, petInfo.id)
			pet.kind = "pet"
            petData = pet
			m:setPetInfo(petData)
        end
	end
end

function m:setPetInfo(item)
	if item ~= nil then
		local name = item:getHeadSpriteName()
	    local atlasName = packTool:getIconByName(name)
	    self.Ima_pet:setImage(name, atlasName)
	    self.bg_pet.spriteName = item:getFrameBG()
	    self.kuang.spriteName = item:getFrame()
	    self.name_pet.text = item.itemColorName
	end
end

function m:refreshItem()
	for i = 0, 5 do
		if listobj[i + 1] ~= nil and self.data.team[i] ~= nil then
			listobj[i + 1]:CallUpdate(self.data.team[i])
		end
	end
end

function m:isHasToReset()
	for i = 1, 12 do
		if Player.PetChapter[i].playerId ~= "" then
			local team = Player.PetChapter[i].team
			if team ~= nil and i ~= self.index then
				for j = 0, 5 do
					if team[j] ~= nil then
						if team[j].max_hp - team[j].hp > 0 then return false end
					end
				end
			end
		end
	end
	return true
end

function m:onClick(go, name)
	if name == "Btn_close" then
    	UIMrg:popWindow()
    elseif name == "tiaozhan_Button" then
    	if m:isHasToReset() == false then self.JudgeMap.gameObject:SetActive(true) return end
    	self.tiaozhan_Button.isEnabled = false
    	Api:fightEnemy(self.index, function(result)
    		local datas = {}
    		datas.data = Player.PetChapter[self.index]
    		datas.index = self.index
    		m:updateInfo(datas)
    		m:refreshItem()
    		UIMrg:popWindow()
    		m:fightIng(result)
    		Events.Brocast("RefreshPetGQInfo")
    		self.tiaozhan_Button.isEnabled = true
    	end)
    	self.binding:CallAfterTime(1, function()
    		self.tiaozhan_Button.isEnabled = true
    		end)
    elseif name == "Btn_buzhen" then
    	--uSuperLink.openModule(802)
    	LuaMain:showFormation(0)
    elseif name == "btn_jm_Close" or name == "btn_jm_cancel" then
    	self.JudgeMap.gameObject:SetActive(false)
    elseif name == "btn_jm_sure" then
    	Api:fightEnemy(self.index, function(result)
    		local datas = {}
    		datas.data = Player.PetChapter[self.index]
    		datas.index = self.index
    		m:updateInfo(datas)
    		m:refreshItem()
    		UIMrg:popWindow()
    		m:fightIng(result)
    		Events.Brocast("RefreshPetGQInfo")
    	end)
	end
end

function m:fightIng(result)
	TableReader:ForEachLuaTable("zhengzhanConfig", function(index, item)
        if item.name == TextMap.GetValue("Text_1_345") then
            self.returnId = item.droptype[0]
        end
        return false
    end)

	local fightData = {}
    fightData["battle"] = result
    fightData["mdouleName"] = "bzsc_pet"
    fightData["returnId"] = self.returnId
    Events.Brocast("ToRoot")
    UIMrg:pushObject(GameObject())
    UluaModuleFuncs.Instance.uOtherFuns:callBackFight(fightData)
    fightData = nil
end

return m