local m = {} 

function m:update(info)
	self.data = info.data
	print_t(self.data)
	self.char = info.char
	local proIdList = {}
	local proTitleList = {}
	local titleList = {}
	local valueList = {}
	local list = {}
	local afterList = {}
	local index = 0


	local qlv = self.data.level
	if qlv > 0 then

		for i = 1, qlv - 1 do
			local preInfo = TableReader:TableRowByUniqueKey("qualitylevel", self.char.dictid, i)
			for j = 0, preInfo.magic.Count do
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
		end
	end
	self.ScrollView_Pre:refresh(list)
	list = nil
	for i = 0, self.data.magic.Count do
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
			else
				afterList[#afterList + 1] = name.."[05fc17]"..value.."[-]"
			end
		end
	end
	self.ScrollView_Next:refresh(afterList)
	afterList = nil

	local text = TextMap.GetValue("Text_1_828")
	local level = 0
	if self.data.level > 5 then
		text = TableReader:TableRowByUniqueKey("qualitylevel", self.char.dictid, (math.ceil(self.data.level / 5) - 1) * 5).desc
	end
	if self.data.level >= 1 then
		local preInfo = TableReader:TableRowByUniqueKey("qualitylevel", self.char.dictid, self.data.level - 1)
		prelevel = preInfo.desc
	else
		prelevel = TextMap.GetValue("Text_1_829")
	end
	level = self.data.desc
	if self.data.level % 5 ~= 0 then
		self.Label_title_next.text = text..level
	else
		self.Label_title_next.text = level
	end
	if self.preData ~= nil then
		if self.preData.level % 5 ~= 0 then
			self.Label_title_pre.text = text..prelevel
		else
			self.Label_title_pre.text = prelevel
		end
	else
		self.Label_title_pre.text = text..prelevel
	end

	--

end

function m:onClick(go, name)
	if name == "Btn_close_detail" then
		self.gameObject:SetActive(false)
	end
end


return m