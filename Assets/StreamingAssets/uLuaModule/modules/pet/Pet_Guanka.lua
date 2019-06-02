local petGk = {} 

function petGk:update(datas)
	if datas ~= nil then
		self.data = datas.data
		if datas.allRefresh then
			self.hero.gameObject:SetActive(false)
			self.GuanKa.gameObject:SetActive(false)
			self.Emy_Icon_back.gameObject:SetActive(true)
			self.Sprite_talk:SetActive(false)
			self.Bai_qi.gameObject:SetActive(false)
		else
			self.datas = datas
			self.index = datas.index
			petGk:updateState()
		end
		petGk:updateLine()
	end
end

--//状态 (0:未激活 1:已激活 2:受伤 3:已击杀)
function petGk:updateState()
	self.hero.gameObject:SetActive(false)
	self.GuanKa.gameObject:SetActive(false)
	self.Emy_Icon_back.gameObject:SetActive(false)
	self.Sprite_talk:SetActive(false)
	self.Bai_qi.gameObject:SetActive(false)
	if self.data.status == 3 then
		self.Bai_qi.gameObject:SetActive(true)
	elseif self.data.status == 2 or self.data.status == 1 then
		self.hero.gameObject:SetActive(true)
		self.GuanKa.gameObject:SetActive(true)
		self.Sprite_talk:SetActive(true)
		petGk:setEmyDetail()
	else
		self.Emy_Icon_back.gameObject:SetActive(true)
	end
end

function petGk:updateLine()
	local lineList = {}
	for i = 1, 3 do
		if self["Line_"..i] ~= nil then
			lineList[i] = self["Line_"..i]
			lineList[i]:SetActive(false)
		end
	end

	if self.data ~=nil and self.data.status ~= 0 then
		for i = 1, #lineList do
			lineList[i]:SetActive(true)
		end
	end
end

function petGk:setEmyDetail()
	self.Label_name.text = Char:getItemColorName(self.data.quality, self.data.nickname)
	self.Label_lv.text =string.gsub(TextMap.GetValue("LocalKey_812"),"{0}",self.data.level)
	self.Label_zhandouli.text = toolFun.moneyNumberShowOne(math.floor(tonumber(self.data.power)))--self.data.power
	local modelTab = TableReader:TableRowByID("avter", self.data.modelId)
	--print("模型ID:"..self.data.modelId)
	if self.data.modelId ~= nil and self.data.modelId ~= "" and self.data.modelId ~= "0" and modelTab ~= nil then
		self.hero:LoadByModelId(tonumber(self.data.modelId), "idle", function() end, false, 0, 1, 255, 2)
	else
		self.hero:LoadByModelId(800, "idle", function() end, false, 0, 1, 255, 2)
	end
end

function petGk:onClick(go, name)
	if name == "GuanKa" then
		if Player.PetChapter[self.datas.index].playerId ~= nil and 
			Player.PetChapter[self.datas.index].playerId == self.datas.data.playerId then
    			UIMrg:pushWindow("Prefabs/moduleFabs/pet/PetFightInfo", self.datas)
		end
		-- print_t(self.datas)
		-- for i = 1, 12 do
		-- 	if Player.PetChapter[i].playerId ~= "" and self.datas.data.playerId == Player.PetChapter[i].playerId then
  --   			UIMrg:pushWindow("Prefabs/moduleFabs/pet/PetFightInfo", self.datas)
  --   			return
		-- 	end
		-- end
	end
end

return petGk