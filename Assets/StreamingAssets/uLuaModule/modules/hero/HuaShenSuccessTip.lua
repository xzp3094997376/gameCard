local m = {} 



local proIdList = {}
local proTitleList = {}
local titleList = {}
local valueList = {}
local list = {}
local afterList = {}
local index = 0

function m:update(info)
	m:setContenList()
	self.char = info
	local qlv = Player.Chars[self.char.id].qualitylvl 
	if qlv == 0 then
		qlv = qlv +1
	end
	self.data = TableReader:TableRowByUniqueKey("qualitylevel", self.char.dictid, qlv)
	self.preData = TableReader:TableRowByUniqueKey("qualitylevel", self.char.dictid, qlv - 1)

	if self.char.star == 5 then
		self.Label_huashen.text = TextMap.GetValue("Text_1_825")
		self.Label_shengjiang.text = TextMap.GetValue("Text_1_826")
	elseif self.char.star == 6 then
		self.Label_huashen.text = ""
		self.Label_shengjiang.text = ""
	end

	local text = TextMap.GetValue("Text_1_828")
	local level = 0
	if self.data.level > 5 then
		text = TableReader:TableRowByUniqueKey("qualitylevel", self.char.dictid, (math.ceil(self.data.level / 5) - 1) * 5).desc
	end

	if self.data.level >= 1 and self.preData ~= nil  then
		prelevel = self.preData.desc
	else
		prelevel = TextMap.GetValue("Text_1_829")
	end

	level = self.data.desc

	if self.data.level % 5 ~= 0 then
		self.Label_Next.text = text..level
	else
		self.Label_Next.text = level
	end

	if self.data.quality == 5 then
		self.Label_Next.text = "[ff9600]"..self.Label_Next.text.."[-]"
	elseif self.data.quality == 6 then
		self.Label_Next.text = "[ff0000]"..self.Label_Next.text.."[-]"
	end

	if self.preData ~= nil then
		if self.preData.quality == 5 then
			self.Label_Pre.text = "[ff9600]"..text..prelevel.."[-]"
		elseif self.preData.quality == 6 then
			self.Label_Pre.text = "[ff0000]"..text..prelevel.."[-]"
		end
	end

	self.Pre_name.text = self.char:getDisplayName()
	self.Next_name.text = self.char:getDisplayName()
	self.img_hero:LoadByModelId(self.char.modelid, "idle", function() end, false, -1, 1)
	m:showResult()

		for i = 0, 7 do
			-- if self.data.magic[i] ~= nil then
				self.objContentList[i + 1].gameObject:SetActive(true)
				self.nexContentList[i + 1].gameObject:SetActive(true)
				self.nexContentList[i + 1].text = afterList[i]
			-- end
			if list[i] ~= nil then
				self.preContentList[i + 1].gameObject:SetActive(true)
				self.preContentList[i + 1].text = list[i]
			end
		end

end

function m:showResult()
	local qlv = Player.Chars[self.char.id].qualitylvl
	if qlv > 0 then

		for i = 1, qlv - 1 do
			local preInfo = TableReader:TableRowByUniqueKey("qualitylevel", self.char.dictid, i)
			for j = 0, 7 do
				if preInfo.magic[j] ~= nil then
					local id = preInfo.magic[j].magic_effect
					local title = string.gsub(preInfo.magic[j]._magic_effect.format, "{0}", "")
					if proIdList[id] ~= nil then
						proIdList[id] = preInfo.magic[j].magic_arg1 + proIdList[id]
					else
						proIdList[id] = preInfo.magic[j].magic_arg1
					end

					if proTitleList[id] == nil then
						proTitleList[id] = "[ffff96]"..title.."[-]"
					end
				end
			end
		end

		for k, v in pairs(proIdList) do
			if k == 12 then 
				list[0] = proTitleList[k]..proIdList[k]
				afterList[0] = proTitleList[k]..proIdList[k]
				titleList[0] = proTitleList[k]
				valueList[0] = proIdList[k]
			elseif k == 0 then
				list[1] = proTitleList[k]..proIdList[k]
				afterList[1] = proTitleList[k]..proIdList[k]
				titleList[1] = proTitleList[k]
				valueList[1] = proIdList[k]
			elseif k == 3 then
				list[2] = proTitleList[k]..proIdList[k]
				afterList[2] = proTitleList[k]..proIdList[k]
				titleList[2] = proTitleList[k]
				valueList[2] = proIdList[k]
			elseif k == 1 then
				list[3] = proTitleList[k]..proIdList[k]
				afterList[3] = proTitleList[k]..proIdList[k]
				titleList[3] = proTitleList[k]
				valueList[3] = proIdList[k]
			else
				list[index] = proTitleList[k]..proIdList[k]
				afterList[index] = proTitleList[k]..proIdList[k]
				titleList[index] = proTitleList[k]
				valueList[index] = proIdList[k]
			end
			index = index + 1
			-- list[index] = proTitleList[k]..proIdList[k]
			-- titleList[index] = proTitleList[k]
			-- valueList[index] = proIdList[k]
			-- afterList[index] = proTitleList[k]..proIdList[k]
			-- index = index + 1
		end
	end
	for i = 0, 7 do
		if self.data.magic[i] ~= nil then
			local name = "[ffff96]"..string.gsub(self.data.magic[i]._magic_effect.format, "{0}", "").."[-]"
			local value = self.data.magic[i].magic_arg1
			local ishas = false
			local index = 0
			for i = 0, 7 do
				if titleList[i] == name then 
					ishas = true 
					index = i
					break
				end
			end

			if ishas then
				afterList[index] = titleList[index].."[05fc17]"..valueList[index] + value.."[-]"
				self["Sprite_Up_"..index + 1]:SetActive(true)
			else
				afterList[#afterList + 1] = name.."[05fc17]"..value.."[-]"
				--self["Sprite_Up_"..#afterList + 1]:SetActive(true)
			end
		end
	end
end

function m:setContenList()
	self.objContentList = {}
	self.preContentList = {}
	self.nexContentList = {}
	for i = 1, 8 do
		self.objContentList[i] = self["Value_list_"..i]
		self.preContentList[i] = self["Label_Pre_"..i]
		self.nexContentList[i] = self["Label_Next_"..i]
		self.objContentList[i].gameObject:SetActive(false)
		self.preContentList[i].gameObject:SetActive(false)
		self.nexContentList[i].gameObject:SetActive(false)
		self["Sprite_Up_"..i]:SetActive(false)
	end
end

function m:onClick(go, name)
	if name == "closeBtnAll" then
        UIMrg:popWindow()
    end
end

return m