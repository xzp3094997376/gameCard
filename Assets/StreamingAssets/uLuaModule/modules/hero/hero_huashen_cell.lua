local m = {} 


function m:update(data)
	self.data = data.data
	self.preData = data.preData
	self.char = data.char
	local text = TextMap.GetValue("Text_1_828")
	local level = 0
	if self.data.level > 5 then
		text = TableReader:TableRowByUniqueKey("qualitylevel", self.char.dictid, (math.ceil(self.data.level / 5) - 1) * 5).desc
	end
	if self.data.level >= 1 and self.preData ~= nil then
		prelevel = self.preData.desc
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

	-- if self.data.quality == 5 then
	-- 	self.Label_title_next.text = self.Label_title_next.text
	-- 	self.Label_title_pre.text = self.Label_title_pre.text
	-- elseif self.data.quality == 6 then
	-- 	self.Label_title_next.text = self.Label_title_next.text
	-- 	self.Label_title_pre.text = self.Label_title_pre.text
	-- end

	m:updateInfoContent()


	self.item1.gameObject:SetActive(true)
	self.item2.gameObject:SetActive(true)
	self.Label_gray.gameObject:SetActive(false)

	for i = 1, 8 do
		if self["Sprite_Up_"..i] ~= nil then
			self["Sprite_Up_"..i]:SetActive(false)
		end
	end

	local proIdList = {}
	local proTitleList = {}
	local titleList = {}
	local valueList = {}
	local list = {}
	local afterList = {}
	local index = 0


	local qlv = Player.Chars[data.char.id].qualitylvl
	if qlv > 0 then

		for i = 1, qlv do
			local preInfo = TableReader:TableRowByUniqueKey("qualitylevel", data.char.dictid, i)
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
			if #proIdList > 4 then
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
			else
				list[index] = proTitleList[k]..proIdList[k]
				afterList[index] = proTitleList[k]..proIdList[k]
				titleList[index] = proTitleList[k]
				valueList[index] = proIdList[k]
			end
			index = index + 1
		end
	end
	local listtip = {}
	for i = 0, 7 do
		if self.data.magic[i] ~= nil then
			local name = "[ffff96]"..string.gsub(self.data.magic[i]._magic_effect.format, "{0}", "").."[-]"
			local value = self.data.magic[i].magic_arg1
			local ishas = false
			local index = 0
			for j = 0, 7 do
				if titleList[j] == name then 
					ishas = true 
					index = j
					break
				end
			end

			if ishas then
				afterList[index] = titleList[index].."[05fc17]"..valueList[index] + value.."[-]"
				self["Sprite_Up_"..index + 1]:SetActive(true)
			else
				if afterList[i] == nil then
					afterList[i] = name.."[05fc17]"..value.."[-]"
				else
					afterList[#afterList + 1] = name.."[05fc17]"..value.."[-]"
				end
				self["Sprite_Up_"..#afterList + 1]:SetActive(true)
			end
		end
	end

	for i = 0, 7 do
		--if self.data.magic[i] ~= nil then
			self.nextList[i + 1].gameObject:SetActive(true)
			self.nextList[i + 1].text = afterList[i]
		--end
		if list ~= nil and  list[i] ~= nil then
			self.preList[i + 1].gameObject:SetActive(true)
			self.preList[i + 1].text = list[i]
		end
	end
	local index = 1

	for i = 0, self.data.consume.Count do
		local item = self.data.consume[i]
		print_t(item)
		if item ~= nil then
			local typeInfo = item.consume_type
			local name =item["$consume_arg"]

			if typeInfo == "money" then
				local needNum = tonumber(item.consume_arg)
				if Player.Resource.money < needNum then
					self.txt_value1_money.text = "[ff0000]"..toolFun.moneyNumberShowOne(math.floor(tonumber(needNum))).."[-]"
				else
					self.txt_value1_money.text = toolFun.moneyNumberShowOne(math.floor(tonumber(needNum)))
				end
			else
				local needNum = tonumber(item.consume_arg2)
				if Tool.typeId(typeInfo) then 
					needNum = tonumber(item.consume_arg)
				end 
				local itemId = item.consume_arg
				local num =Tool.getCountByType(typeInfo,name)
				local itemInfo = RewardMrg.getDropItem({type=typeInfo,arg2=1,arg=itemId})
				
    			if index==1 then 
    				m:showItemInfo(itemInfo, self.ima_huashendan,index)
    			else 
    				m:showItemInfo(itemInfo, self.ima_suipian,index)	
    			end 
				self["item" .. index .."Name"].text = itemInfo:getDisplayColorName()
				if num < needNum then
					self["item" .. index .."Count"].text = "[ff0000]"..toolFun.moneyNumberShowOne(num).."/"..needNum.."[-]"
				else
					self["item" .. index .."Count"].text = toolFun.moneyNumberShowOne(num).."/"..needNum
				end
				index=index+1
			end
		end
	end

	if self.preData ~= nil then
		local endInfo = TableReader:TableRowByUniqueKey("qualitylevel", data.char.dictid, self.preData.level + 1)
		if endInfo == nil then
			for i = 1, 8 do
				self.nextList[i].gameObject:SetActive(false)
			end
			self.ima_huashendan.gameObject:SetActive(false)
			self.ima_hunyu.gameObject:SetActive(false)
			self.ima_suipian.gameObject:SetActive(false)
			self.ima_jinghua.gameObject:SetActive(false)
			--self.content_item2.gameObject:SetActive(false)
			--self.content_item1.gameObject:SetActive(false)
			self.item1.gameObject:SetActive(false)
			self.item2.gameObject:SetActive(false)
			self.Icon_money.gameObject:SetActive(false)
			self.Label_title_next.gameObject:SetActive(false)
			self.txt_value1_money.gameObject:SetActive(false)
			self.Label_gray.gameObject:SetActive(true)
		end
	end
end

function m:showItemInfo(item, targetObj, index)
	if self["instanItem" .. index] == nil then
		self["instanItem" .. index] = ClientTool.loadAndGetLuaBindingFromPool("Prefabs/publicPrefabs/itemAll", targetObj.gameObject)
	end
	self["instanItem" .. index]:CallUpdate({ "char", item, targetObj.width, targetObj.height,true })
end

function m:getServerPackData(type, itemId, Bag)
    local bag = Bag:getLuaTable()
    if not bag then error("bag have nothing") end
    local num = 0
    for k, v in pairs(bag) do
        local vo = {}
        vo = itemvo:new(type, v.count, v.id, v.time, k)

        if type == "charPiece" then
    		local piece = Player.CharPieceBagIndex[itemId]
    		if piece ~= nil then
	    		num = piece.count
        		break
    		end
        end
        if vo.itemType == type and vo.itemID == itemId  then
        	num = vo.itemCount
        	break
        end
    end
    return num
end

function m:updateInfoContent()
	self.preList = {}
	self.nextList = {}
	for i = 1, 8 do
		self.preList[i] = self["Label_Pre_value"..i]
		self.nextList[i] = self["Label_Next_value"..i]
		self.preList[i].gameObject:SetActive(false)
		self.nextList[i].gameObject:SetActive(false)
	end
end


return m