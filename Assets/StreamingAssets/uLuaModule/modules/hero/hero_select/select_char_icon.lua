-- 头像
local m = {}


--点击事件
function m:onClick(uiButton, eventName)
    if eventName == "button" or eventName == "btn_go" then
        if self.char.tab == 1 then --跳转培养界面
			m:gotoCultivate()
        elseif self.char.tab == 2 then --跳转抽卡界面
			DialogMrg.showPieceDrop(self.char)
        elseif self.char.tab == 3 then --碎片合成
        	if Tool:judgeBagCount(self.dropTypeList) == false then return end
			m:showSummon(self.char)
        elseif self.char.tab == 4 then --跳去进化
			DialogMrg.showPieceDrop(self.char)
        end
    elseif eventName == "btn_hero" then
		if self.char.tab == 1 then 
			self:showInfoPanel()
		else 
			local temp = {}
			temp.obj = self.char
			if self.mType == "char" then 
				UIMrg:pushWindow("Prefabs/moduleFabs/hero/hero_info_dialog", temp)
			elseif self.mType == "pet" then 
				UIMrg:pushWindow("Prefabs/moduleFabs/hero/pet_info_dialog", temp)
			elseif self.mType == "yuling" then 
				UIMrg:pushWindow("Prefabs/moduleFabs/yuling/yuling_info_dialog", temp)
			end
		end 
    end
end

function m:gotoCultivate()
	if self.mType == "char" then 
		if self.char.id == Player.Info.playercharid then 
			UIMrg:push("new_hero", "Prefabs/moduleFabs/hero/newHero", { char = self.char, tp = 3 })
		else 
			if self.char.Table.can_lvup_consume == 1 then 
				UIMrg:push("new_hero", "Prefabs/moduleFabs/hero/newHero", { char = self.char, tp = 1 })
			else
				if self.char.star < 2 then
					local isOpen = m:checkLock(230, false)
					if isOpen == true then
						UIMrg:push("new_hero", "Prefabs/moduleFabs/hero/newHero", { char = self.char, tp = 5 })
					end
				end 
			end 
		end 
	elseif self.mType == "pet" then 
		UIMrg:push("pet_main", "Prefabs/moduleFabs/pet/pet_main", { pet = self.char, tp = 1 })
	elseif self.mType == "yuling" then 
		UIMrg:push("yuling", "Prefabs/moduleFabs/yuling/yuling_cultivate", { pet = self.char, tp = 1 })
	end 
end 

function m:checkLock(id, isCharLevel)
	local linkData = Tool.readSuperLinkById( id)
    local unlockType = linkData.unlock[0].type --解锁条件
    if unlockType ~= nil then
        local level = linkData.unlock[0].arg
		if isCharLevel then 
			if self.char.lv < level or Player.Info.vip < linkData.vipLevel then
				MessageMrg.show(string.gsub(TextMap.TXT_OPEN_MODULE_BY_CHAR_LEVEL, "{0}", level))
				return false
			end
		else
			if Player.Info.level < level or Player.Info.vip < linkData.vipLevel then
				MessageMrg.show(string.gsub(TextMap.GetValue("Text_1_777"), "{0}", level))
				return false
			end
		end
	end
	return true
end

function m:updateChar()
    local char = self.char
    self.img_frame.enabled = false
    if self.__itemAll == nil then
        self.__itemAll = ClientTool.loadAndGetLuaBindingFromPool("Prefabs/publicPrefabs/itemAll", self.img_frame.gameObject)
    end
    self.__itemAll:CallUpdate({ "char", self.char, self.img_frame.width, self.img_frame.height })
    if self.mType == "char" or self.mType == "charPiece" then 
		self.img_type.spriteName = char:getDingWei()
	else
		self.img_type.gameObject:SetActive(false)
	end 
	if char.tab == 1 then --英雄icon
		self.txt_lv.gameObject:SetActive(true)
		self.txt_xuemai.gameObject:SetActive(true)
		self.txt_power.gameObject:SetActive(true)
		self.txt_count.gameObject:SetActive(false)
		self.btn_go.gameObject:SetActive(false)
		self.button.gameObject:SetActive(true)
		--属性信息
		self.txt_lv.text = "[ffff96]" .. TextMap.GetValue("Text1143") .. "[-]" ..  char.lv
		self.txt_name.text = char:getDisplayName()
		if self.mType == "char" then 
			self.txt_xuemai.text = "[ffff96]" .. TextMap.GetValue("Text1144") .. "[-]" .. Player.Chars[char.id].bloodline.level
		else
			self.txt_xuemai.text = TextMap.GetValue("Text_1_782") .. char.shenlian
		end
		self.txt_power.text = "[ffff96]" .. TextMap.GetValue("Text408") .. "[-]" .. char.power
		self.font.text = TextMap.GetValue("Text_1_781")
		--按钮图标
		--self.btn_sprite.spriteName = "YX-yellow"
		--self.font.spriteName = "YX-peiyang"
		if self:checkChar(tonumber(self.char.id)) == true then
			self.pos:SetActive(true)
			self.friend_sprite:SetActive(false)
			self.redPoint:SetActive(self:check())
		else
			self.pos:SetActive(false)
			self.redPoint:SetActive(false)
			if self.mType == "char" then 
				if self.delegate:checkFriend(tonumber(self.char.id)) == true then
					self.friend_sprite:SetActive(true)
				else
					self.friend_sprite:SetActive(false)
				end
			else
				if self:checkHuyou(tonumber(self.char.id)) == true then
					self.friend_sprite:SetActive(true)
				else
					self.friend_sprite:SetActive(false)
				end
			end 
		end
		if self.mType == "char" then 
			if self.char.lv >= 50 then	
				self.stars.gameObject:SetActive(true)
				self.txt_juexing.text = TextMap.GetValue("Text_1_779") .. self.char:getStageStar()
				local star = math.floor ( self.char.stage / 10 )
				local starLists = {}
				local showStar = false
				for i = 1, 6 do
					showStar = false
					if i <= star then 
						showStar = true
					end
					starLists[i] = { isShow = showStar }
				end
				self.stars:refresh("", starLists, self)
				starLists = nil
				showStar = nil
			else
				self.txt_juexing.text = ""
				self.stars.gameObject:SetActive(false)
			end

			if self.HuaShenInfo ~= nil then self.HuaShenInfo.gameObject:SetActive(false) end

			if self.char.id ~= Player.Info.playercharid and self.char.star_level >= 8 and self.char.lv >= 90 and self.HuaShenInfo ~= nil then
				if self.char.star >= 5 then
					self.HuaShenInfo.gameObject:SetActive(true)
					self.Label_huashenLevel.text = self.char:getHuaShenLevel(self.char.id, self.char.dictid, self.char.quality) --TextMap.GetValue("Text_1_780")..
				else
					self.HuaShenInfo.gameObject:SetActive(false)
				end
			end
		end
    --图标
    else --英雄碎片icon
		char:updateInfo()
		self.txt_lv.gameObject:SetActive(false)
		self.txt_xuemai.gameObject:SetActive(false)
		self.txt_power.gameObject:SetActive(false)
		self.txt_count.gameObject:SetActive(true)
		self.redPoint:SetActive(false)
	
		self.button.gameObject:SetActive(true)
		self.txt_name.text = char:getDisplayColorName()
		--self.font.spriteName = "YX-qianwang"
		if char.count >= char.needCharNumber then --碎片可以进行合成
			self.font.text = TextMap.GetValue("Text_1_324")
			--self.btn_sprite.spriteName = "YX-red"
			self.btn_go.gameObject:SetActive(false)
			self.txt_count.text = "[ffff96]" .. TextMap.GetValue("Text1145") .. "[-][00ff00]" .. char.count .. "/" .. char.needCharNumber.."[-]"
			self.redPoint:SetActive(true)
		else
			self.txt_count.text = "[ffff96]" .. TextMap.GetValue("Text1145") .. "[-]" .. char.count .. "/" .. char.needCharNumber
			--self.font.spriteName = "YX-qianwang"
			self.btn_go.gameObject:SetActive(true)
			self.button.gameObject:SetActive(false)
		end
		self.pos:SetActive(false)
		self.friend_sprite:SetActive(false)
    end
end

function m:updateYuling()
    local char = self.char
    self.img_frame.enabled = false
    if self.__itemAll == nil then
        self.__itemAll = ClientTool.loadAndGetLuaBindingFromPool("Prefabs/publicPrefabs/itemAll", self.img_frame.gameObject)
    end
    self.__itemAll:CallUpdate({ "char", self.char, self.img_frame.width, self.img_frame.height })
	self.img_type.gameObject:SetActive(false)
	if char.tab == 1 then --英雄icon
		self.btn_go.gameObject:SetActive(false)
		self.button.gameObject:SetActive(true)
		--属性信息
		local iconName = TableReader:TableRowByUnique("resourceDefine", "name","haogandu").img
		self.img.Url=UrlManager.GetImagesPath("itemImage/"..iconName..".png")
		local name = TableReader:TableRowByUnique("resourceDefine", "name","haogandu").cnName
	    self.lv_name.text=name .. "："
		self.lv.text = char.lv
		self.txt_name.text = char:getDisplayName()
		--self.txt_power.text = "[ffff96]" .. TextMap.GetValue("Text408") .. "[-]" .. char.power
		self.font.text = TextMap.GetValue("Text_1_781")
		local piece = YulingPiece:new(char.id)
		local needNum=0
		local row = TableReader:TableRowByUniqueKey("yulingstarUp", char.id, char.star_level + 1)
		if row then
	        local consume = RewardMrg.getConsumeTable(row.consume, char.id)
	        table.foreach(consume, function(i, v)
	            local t = v:getType()
	            if t == "yulingPiece" then
	                needNum = v.rwCount
	            end
	        end)
	    end
		self.Slider.value = piece.count/needNum
		self.value.text =piece.count .. "/" .. needNum
		if char.info.huyou>0 then
			self.pos:SetActive(true)
			self.redPoint:SetActive(self:check())
		else
			self.pos:SetActive(false)
			self.redPoint:SetActive(false)
		end
		local star = char.star_level
		local maxStar = TableReader:TableRowByID("yulingArgs","max_yuling_starup").value
		local starList = {}
		for i=1, star do
			local temp = {}
			temp.isShow=true
			table.insert(starList,temp)
		end
		for i=star+1, tonumber(maxStar) do
			local temp = {}
			temp.isShow=false
			table.insert(starList,temp)
		end
		self.stars:refresh("", starList, self)
    --图标
    else --英雄碎片icon
		char:updateInfo()
		self.txt_lv.gameObject:SetActive(false)
		self.txt_xuemai.gameObject:SetActive(false)
		self.txt_power.gameObject:SetActive(false)
		self.txt_count.gameObject:SetActive(true)
		self.redPoint:SetActive(false)
	
		self.button.gameObject:SetActive(true)
		self.txt_name.text = char:getDisplayColorName()
		if char.count >= char.needCharNumber then --碎片可以进行合成
			self.font.text = TextMap.GetValue("Text_1_324")
			self.btn_go.gameObject:SetActive(false)
			self.txt_count.text = "[ffff96]" .. TextMap.GetValue("Text1145") .. "[-][00ff00]" .. char.count .. "/" .. char.needCharNumber.."[-]"
			if Player.yuling[char.id].quality >0 then 
				self.button.isEnabled = false
			else 
				self.redPoint:SetActive(true)
				self.button.isEnabled = true 
			end 
		else
			self.txt_count.text = "[ffff96]" .. TextMap.GetValue("Text1145") .. "[-]" .. char.count .. "/" .. char.needCharNumber
			self.btn_go.gameObject:SetActive(true)
			self.button.gameObject:SetActive(false)
		end
		self.pos:SetActive(false)
		self.friend_sprite:SetActive(false)
    end
end

function m:updatePet()
    local char = self.char
    self.img_frame.enabled = false
    if self.__itemAll == nil then
        self.__itemAll = ClientTool.loadAndGetLuaBindingFromPool("Prefabs/publicPrefabs/itemAll", self.img_frame.gameObject)
    end
    self.__itemAll:CallUpdate({ "char", self.char, self.img_frame.width, self.img_frame.height })
	self.img_type.gameObject:SetActive(false)
	if char.tab == 1 then --英雄icon
		self.txt_lv.gameObject:SetActive(true)
		self.txt_xuemai.gameObject:SetActive(true)
		self.txt_power.gameObject:SetActive(true)
		self.txt_count.gameObject:SetActive(false)
		self.btn_go.gameObject:SetActive(false)
		self.button.gameObject:SetActive(true)
		--属性信息
		self.txt_lv.text = "[ffff96]" .. TextMap.GetValue("Text1143") .. "[-]" ..  char.lv
		self.txt_name.text = char:getDisplayName()
		self.txt_power.text = "[ffff96]" .. TextMap.GetValue("Text408") .. "[-]" .. char.power
		self.font.text = TextMap.GetValue("Text_1_781")
		self.txt_xuemai.text = TextMap.GetValue("Text_1_782") .. char.shenlian
		
		if self:checkHuyou(tonumber(self.char.id)) == true then
			self.friend_sprite:SetActive(true)
		else
			self.friend_sprite:SetActive(false)
		end
		if self:checkChar(tonumber(self.char.id)) == true then
			self.pos:SetActive(true)
			self.friend_sprite:SetActive(false)
		else
			self.pos:SetActive(false)
		end
		
		if m:checkTeamHuyou(self.char.id) == true then 
			self.redPoint:SetActive(self:check())
		else
			self.redPoint:SetActive(false)		
		end 
		if self.mType == "pet" then
			if Player.Info.level >= 50 then
				local star = char.star_level
				local starLists = {}
				local showStar = false
				for i = 1, 5 do
					showStar = false
					if i <= star then 
						showStar = true
					end
					starLists[i] = { isShow = showStar }
				end
				self.stars:refresh("", starLists, self)
				starLists = nil
				showStar = nil
			else
				self.stars.gameObject:SetActive(false)
			end
		end
    --图标
    else --英雄碎片icon
		char:updateInfo()
		self.txt_lv.gameObject:SetActive(false)
		self.txt_xuemai.gameObject:SetActive(false)
		self.txt_power.gameObject:SetActive(false)
		self.txt_count.gameObject:SetActive(true)
		self.redPoint:SetActive(false)
	
		self.button.gameObject:SetActive(true)
		self.txt_name.text = char:getDisplayColorName()
		if char.count >= char.needCharNumber then --碎片可以进行合成
			self.font.text = TextMap.GetValue("Text_1_324")
			self.btn_go.gameObject:SetActive(false)
			self.txt_count.text = "[ffff96]" .. TextMap.GetValue("Text1145") .. "[-][00ff00]" .. char.count .. "/" .. char.needCharNumber.."[-]"
			self.redPoint:SetActive(true)
		else
			self.txt_count.text = "[ffff96]" .. TextMap.GetValue("Text1145") .. "[-]" .. char.count .. "/" .. char.needCharNumber
			self.btn_go.gameObject:SetActive(true)
			self.button.gameObject:SetActive(false)
		end
		self.pos:SetActive(false)
		self.friend_sprite:SetActive(false)
    end
end

--判断角色是否上阵
function m:checkChar(charid)
	if self.mType == "char" then 
		local teams = Player.Team[0].chars
		local list = {}
		for i = 0, 5 do
			if charid == tonumber(teams[i]) then
				return true
			end
		end
		return false
	else
		local id = Player.Team[0].pet
		if id ~= nil and id ~= 0 then 
			if charid == id then 
				return true
			end 
		else 	
			return false
		end 
	end
	return false
end

function m:checkTeamHuyou(petId)
	local id = Player.Team[0].pet
	if id ~= nil and id ~= 0 then 
		if petId == id then 
			return true
		end 
	end 
	local ghostSlot = Player.ghostSlot
	for i = 0, 5 do 
		local slot = ghostSlot[i]
		local petid = slot.petid
		if petId == petid then 
			return true
		end 
	end 
	return false
end

function m:checkHuyou(petId)
	local ghostSlot = Player.ghostSlot
	for i = 0, 5 do 
		local slot = ghostSlot[i]
		local petid = slot.petid
		if petId == petid then 
			return true
		end 
	end 
	return false
end 

--召唤
function m:showSummon(piece)
    -- local name = piece.Table.show_name
    -- local money = piece.Table.consume[1].consume_arg
    -- local dese = string.gsub(TextMap.TXT_SUMMON_CHAR_NEED_COST_MONEY, "{1}", money .. "")

    -- desc = string.gsub(dese, "{0}", name)
    -- DialogMrg.ShowDialog(desc, function(result)
        Api:combineFunc(piece:getType(), piece.id, function(result)
            local list = RewardMrg.getList(result)
            local luaTable = {
                char = list[1],
                cb = function()
                    --self.delegate:onUpdate()
                    UIMrg:pop()
                end
            }
            Tool.push("RewardChar", "Prefabs/moduleFabs/choukaModule/RewardChar", luaTable)
        end)
    -- end)
end

function m:onUpdate()
	if self.mType == "char" then 
		self:updateChar()
	elseif self.mType == "pet" then
		self:updatePet()
	end
end 

--检测角色是否可以培养
function m:check()
    if self.char == nil then return false end
    local char = self.char
	if self.mType == "char" then
		if self.open_lv ==nil then 
			self.open_lv = self:checkLockNoMsg(227, true)
		end 
		if self.open_jinjie ==nil then 
			self.open_jinjie = self:checkLockNoMsg(228, true)
		end
		if self.open_peiyang==nil then
			self.open_peiyang = self:checkLockNoMsg(230, true)
		end 
		if self.open_juexing ==nil then 
			self.open_juexing = self:checkLockNoMsg(229, false)
		end 
		if self.open_xuemai then 
			self.open_xuemai = self:checkLockNoMsg(72, false)
		end
		local bool_lv=char:redPointForStrong() and self.open_lv --升级突破
		local bool_jinjie=char:redPointForJinHua() and self.open_jinjie --进化
		local bool_peiyang= char:redPointForCultivate() and self.open_peiyang --灵络
		local bool_juexing= char:redPointForEquip() or char:redPointForJueXing() and self.open_juexing
		local bool_xuemai = char:redPointForXueMai() and self.open_xuemai
		return bool_lv or bool_jinjie or bool_peiyang or bool_juexing or bool_xuemai or false--or char:redPointForJinHua() or char:redPointForTransform() or char:redPointForSkill() or char:redPointForXueMai()
	elseif self.mType == "yuling" then
		if self.open_lv == nil then 
			self.open_lv = self:checkLockNoMsg(27, false)
		end 
		if self.open_jinjie ==nil then 
			self.open_jinjie = self:checkLockNoMsg(27, false)
		end
		local bool_lv = char:redPointForStrong() and self.open_lv --升级
		local bool_jinjie = char:redPointForJinHua() and self.open_jinjie --升星
		return bool_lv or bool_jinjie or false 
	else 
		if self.open_lv == nil then 
			self.open_lv = self:checkLockNoMsg(151, false)
		end 
		if self.open_jinjie ==nil then 
			self.open_jinjie = self:checkLockNoMsg(152, false)
		end
		if self.open_shenlian==nil then
			self.open_shenlian = self:checkLockNoMsg(153, false)
		end
		local bool_lv = char:redPointForStrong() and self.open_lv --升级
		local bool_jinjie = char:redPointForJinHua() and self.open_jinjie --升星
		local bool_shenlian = char:redPointForShenlian() and self.open_shenlian --神炼
		return bool_lv or bool_jinjie or bool_shenlian or false 
	end
	
	return false
end

function m:checkLockNoMsg(id, isCharLv)
	local ischar = isCharLv
	local linkData = Tool.readSuperLinkById( id)
    local unlockType = linkData.unlock[0].type --解锁条件
    if unlockType ~= nil then
        local level = linkData.unlock[0].arg
		if ischar == true then 
			if self.char.lv < level or Player.Info.vip < linkData.vipLevel then
				return false
			end
		else 
			if Player.Info.level < level or Player.Info.vip < linkData.vipLevel then
				return false
			end
		end 
	end
	return true
end

--显示英雄详细信息面板
function m:showInfoPanel()
    if self.char == nil then return end
	if self.mType == "char" then 
		Tool.push("heroInfo", "Prefabs/moduleFabs/hero/hero_info", self.char)
	elseif self.mType == "pet" then 
		Tool.push("petInfo", "Prefabs/moduleFabs/hero/pet_info", self.char)
	elseif self.mType == "yuling" then 
		Tool.push("yulingInfo", "Prefabs/moduleFabs/yuling/yuling_info", {pet = self.char, delegate = self.delegate,isShow=false})
	end
end

--更新角色列表
--@char 角色 uChar.lua
--@index 列表中的位置
--@delegate 数据控制
function m:update(lua)
	self.dropTypeList = {}
    self.index = lua.index
	self.mType = lua.char.mType
	table.insert(self.dropTypeList, self.mType)
    self.char = lua.char
    self.delegate = lua.delegate
    -- self.type = self.delegate:getTab()
	if self.mType == "char" then 
		self:updateChar()
	elseif self.mType == "pet" then
		self:updatePet()
	elseif self.mType == "yuling" then
		self:updateYuling()
	end
end

return m

