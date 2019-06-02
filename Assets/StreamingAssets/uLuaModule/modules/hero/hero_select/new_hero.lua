local m = {}

--[[
-- 1 升级与突破
-- 2 进化
-- 3 技能
-- 4 灵络
-- 5 洗练
-- 6 血脉
-- 7 化神
]]
function m:onUpdate(top, refresh)
    local title = "shengji"
    local tp = self.tp	
	-- 更新列表
	--local list = {}
    --list = self:showHeroList()
	if self.char == nil then return end
	local isGuide = false
	if self.char == nil  and tp == 2 then 
		isGuide = true
	end
	if self.char.star < 2 then 
		tp = 5
	end 
	--if list ~= nil then
	--	self.char = list[self.selectIndex]
	--end
	m:updateColor()
		
    if tp == 1 then --升级进化
        if self.tabList[1] == nil then
            self.tabList[1] = ClientTool.loadAndGetLuaBinding("Prefabs/moduleFabs/hero/gui_heroLvUp", self.con)
			self.tabList[1].gameObject:SetActive(false)
			self.binding:CallManyFrame(function()
				self.tabList[1].gameObject:SetActive(tp == 1)	
			end)
        end
        self.tab = self.tabList[1]
	elseif tp == 2 then  -- 突破
        if self.tabList[2] == nil then
            self.tabList[2] = ClientTool.loadAndGetLuaBinding("Prefabs/moduleFabs/hero/heroEquip", self.con)
			self.tabList[2].gameObject:SetActive(false)
			self.binding:CallManyFrame(function()
				self.tabList[2].gameObject:SetActive(tp == 2)	
			end, 2)
		end
        self.tab = self.tabList[2]
    elseif tp == 3 then --进化
		if self.tabList[3] == nil then
			self.tabList[3] = ClientTool.loadAndGetLuaBinding("Prefabs/moduleFabs/hero/heroJinhua", self.con)
			self.tabList[3].gameObject:SetActive(false)
			self.binding:CallManyFrame(function()
				self.tabList[3].gameObject:SetActive(tp == 3)	
			end)
		end
		self.tab = self.tabList[3]
		if isGuide then
			self.char = GuideConfig.tempData
			GuideConfig.tempData = nil
		end
	elseif tp == 4 then --血脉
		if self.tabList[4] == nil then
			self.tabList[4] = ClientTool.loadAndGetLuaBinding("Prefabs/activityModule/bloodModlue/hero_blood", self.con)
			self.tabList[4].gameObject:SetActive(false)
			self.binding:CallManyFrame(function()
				self.tabList[4].gameObject:SetActive(tp == 4)	
			end)
		end
		self.tab = self.tabList[4]
	elseif tp == 5 then -- 培养
		if self.tabList[5] == nil then
			self.tabList[5] = ClientTool.loadAndGetLuaBinding("Prefabs/moduleFabs/hero/gui_cultivate", self.con)
			self.tabList[5].gameObject:SetActive(false)
			self.binding:CallManyFrame(function()
				self.tabList[5].gameObject:SetActive(tp == 5)	
			end)
		end
		self.tab = self.tabList[5]
	elseif tp == 6 then -- 化神
		if self.tabList[6] == nil then
			self.tabList[6] = ClientTool.loadAndGetLuaBinding("Prefabs/moduleFabs/hero/hero_huashen", self.con)
			self.tabList[6].gameObject:SetActive(false)
			self.binding:CallManyFrame(function()
				self.tabList[6].gameObject:SetActive(tp == 6)	
			end)
		end
		self.tab = self.tabList[6]
	end
    self:updatePanel(tp)
    if self.tab then
        self.tab:CallUpdate({ delegate = self, char = self.char })
    end
end

function m:updateColor()
	self.open_lv = self:checkLockNoMsg(227, true)
	self.open_jinjie = self:checkLockNoMsg(228, false)
	self.open_peiyang = self:checkLockNoMsg(230, false)
	self.open_juexing = self:checkLockNoMsg(229, true)
	self.open_xuemai = self:checkLockNoMsg(72, false)
	self.open_huashen = self:checkLockNoMsg(75, true)--读超级链接表


	self.btn_lvup_down.gameObject:SetActive(self.open_lv)
	self.btn_lvup_gray.gameObject:SetActive(not self.open_lv)
	
	self.btn_tupo_down.gameObject:SetActive(self.open_juexing)
	self.btn_tupo_gray.gameObject:SetActive(not self.open_juexing)
	
	self.btn_jinjie_down.gameObject:SetActive(self.open_jinjie)
	self.btn_jinjie_gray.gameObject:SetActive(not self.open_jinjie)
	
	self.btn_blood_down.gameObject:SetActive(self.open_xuemai)
	self.btn_blood_gray.gameObject:SetActive(not self.open_xuemai)	
	
	self.btn_cultivate_down.gameObject:SetActive(self.open_peiyang)
	self.btn_cultivate_gray.gameObject:SetActive(not self.open_peiyang)	

	self.btn_huashen_down.gameObject:SetActive(self.open_huashen)--self.open_haushen
	self.btn_huashen_gray.gameObject:SetActive(not self.open_huashen)	--not self.open_haushen

	
	self.targetlvInfo = TableReader:TableRowByUniqueKey("qualitylevel", self.char.dictid, Player.Chars[self.char.id].qualitylvl + 1)
	if self.targetlvInfo == nil then
		self.btn_huashen_down.gameObject:SetActive(false)--self.open_haushen
		self.btn_huashen_gray.gameObject:SetActive(true)	--not self.open_haushen
	end
end 

function m:onEnter()
	LuaMain:ShowTopMenu()
	if self.tab then
		self.char:updateInfo()
        self.tab:CallUpdate({ delegate = self, char = self.char })
    end
	m:updateRedPoint()
end 

function m:update(lua)
    self.char = lua.char
    self.tp = lua.tp
	if self.char == nil then return end 
	if self.char.id == Player.Info.playercharid or self.char.Table.can_lvup_consume ~= 1 then 
		if self.tp == 1 then self.tp = 3 end 
	end 
    --if self.__itemAll == nil then
    --    self.__itemAll = ClientTool.loadAndGetLuaBindingFromPool("Prefabs/publicPrefabs/itemAll", self.img_frame.gameObject)
    --end
    --self.__itemAll:CallUpdate({ "char", self.char, self.img_frame.width, self.img_frame.height })
    --self.txt_name.text = self.char:getDisplayName()
    --self.txt_power.text = self.char.power
    self:onUpdate(true, true)
    self:updateRedPoint()
	self:updateBtnState()
	--local list = self:showHeroList()
    --self.hero_list_bg:refresh(list, self, true, 0)
end

function m:updateItem(index)
	print("需要更新： " .. index)
	self:onUpdate(false, false)
	--if self.tab then
    --    self.tab:CallUpdate({ delegate = self, char = self.char })
    --end
end

--更新红点提示
function m:updateRedPoint()
    local char = self.char
	if m:isExitTeam(char.id) then 
		self.redPoint_lvup:SetActive(char:redPointForStrong() and self.open_lv) --升级突破
		self.redPoint_jinjie:SetActive(char:redPointForJinHua() and self.open_jinjie) --进化
		self.redPoint_cultivate:SetActive(char:redPointForCultivate() and self.open_peiyang) --灵络
		self.redPoint_tupo:SetActive(char:redPointForEquip() or char:redPointForJueXing() and self.open_juexing)
		self.redPoint_blood:SetActive(char:redPointForXueMai() and self.open_xuemai)
	end 
	self.redPoint_huashen:SetActive(char:redPointForHuaShen(char) and self.open_huashen)--化神红点
end

-- 是否存在上阵列表中
function m:isExitTeam(id)
    local teams = Player.Team[0].chars
    if teams == nil then
        return false
    end
    for i = 0, 5 do
        if teams.Count > i then
            if tonumber(teams[i]) == id then 
				return true
			end 
        end
    end
    return false
end

function m:updateHeroInfo(char)
    if char == nil then return end
	self:updateRedPoint()
    if self.__itemAll ~= nil then
		self.char:updateInfo()
        self.__itemAll:CallUpdate({ "char", self.char, self.img_frame.width, self.img_frame.height })
        self.txt_name.text = self.char:getDisplayName()
        self.txt_power.text = self.char.power
    end
end

function m:checkLockNoMsg(id, isCharLevel)
	local linkData = Tool.readSuperLinkById( id)
    local unlockType = linkData.unlock[0].type --解锁条件
    if unlockType ~= nil then
        local level = linkData.unlock[0].arg
		if isCharLevel then
			if id == 75 then
				if self.char.lv < level or self.char.star_level < self.jinhuaLV then
					return false
				end
			else
				if self.char.lv < level or Player.Info.vip < linkData.vipLevel then
					return false
				end
			end
		else
			if Player.Info.level < level or Player.Info.vip < linkData.vipLevel then
				return false
			end
		end
	end
	return true
end

function m:checkLock(id, isCharLevel)
	local linkData = Tool.readSuperLinkById( id)
    local unlockType = linkData.unlock[0].type --解锁条件
    if unlockType ~= nil then
        local level = linkData.unlock[0].arg
		if isCharLevel then 
			if id == 75 then
				if self.char.lv < level or self.char.star_level < self.jinhuaLV then
					MessageMrg.show(TextMap.GetValue("Text_1_845")..level..TextMap.GetValue("Text_1_846")..self.jinhuaLV..TextMap.GetValue("Text_1_847"))
					return false
				end
			else
				if self.char.lv < level or Player.Info.vip < linkData.vipLevel then
					MessageMrg.show(string.gsub(TextMap.GetValue("Text1806"), "{0}", level))
					return false
				end
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

function m:onClick(go, name)
    if name == "btn_lvup_down" or name == "btn_lvup_gray" then 
		local isOpen = self:checkLock(227, true)
		if isOpen == true then 
			self.tp = 1
			self:check(1)
			self:updateBtnState()
		else 
			return 
		end
	elseif name == "btn_cultivate_down" or name == "btn_cultivate_gray" then 
		local isOpen = self:checkLock(230, false)
		if isOpen == true then 
			self.tp = 5
			self:updateBtnState()
			self:check(5)
		else 
			return 
		end
	elseif name == "btn_tupo_down" or name == "btn_tupo_gray" then 
		local isOpen = self:checkLock(229, true)
		if isOpen == true then 
			self.tp = 2
			self:updateBtnState()
			self:check(2)
		else 
			return 
		end
	elseif name == "btn_jinjie_down" or name == "btn_jinjie_gray" then 
		local isOpen = self:checkLock(228, false)
		if isOpen == true then 
			self.tp = 3
			self:check(3)
			self:updateBtnState()
		else 
			return 
		end
	elseif name == "btn_blood_down" or name == "btn_blood_gray" then 
		local isOpen = self:checkLock(72, false)
		if isOpen == true then 
			self.tp = 4
			self:updateBtnState()
			self:check(4)
		else 
			return 
		end
	elseif name == "btn_huashen_down" or name == "btn_huashen_gray" then 
		local isOpen = self:checkLock(75, true)--读表
		if isOpen then
			isOpen = m:checkHuashenTop()
		end
		if isOpen == true then 
			self.tp = 6
			self:updateBtnState()
			self:check(6)
		else 
			return 
		end
	elseif name == "btnBack" then 
		UIMrg:pop()
    end
    -- if self.char ~= nil then
    --     self:onUpdate()
    -- end
end

function m:checkHuashenTop()
	local initInfo = TableReader:TableRowByUniqueKey("qualitylevel", self.char.dictid, 1)
	if initInfo ~= nil then
		local topInfo = TableReader:TableRowByUniqueKey("qualitylevel", self.char.dictid, Player.Chars[self.char.id].qualitylvl + 1)
		if topInfo == nil then
			MessageMrg.show(TextMap.GetValue("Text_1_844"))
			return false
		end
	end
	return true
end

function m:updateBtnState()
	-- 1 升级  2 突破 3 进阶 4 血脉 5 培养 6 化神
	local list = {}
	list[1] = self.img_lvUp
	list[2] = self.imgTupoUp
	list[3] = self.imgJinjieUp
	list[4] = self.imgBloodUp
	list[5] = self.imgCultivateUp
	list[6] = self.imghuashenUp

	for i = 1, 6 do 
		if i == self.tp then list[i]:SetActive(true)
		else list[i]:SetActive(false) end
	end 
	
	for i = 1, 6 do
		self.btns[i].gameObject:SetActive(true)
	end 
		
	if self.char.id == Player.Info.playercharid or self.char.Table.can_lvup_consume ~= 1 then 
		self.btn_lvup:SetActive(false)
		self.btn_huashen:SetActive(false)
		for i = 2, 5 do
			self.btns[i].gameObject.transform.localPosition = self.btnPos[i-1]
			self.btns[i].gameObject:SetActive(true)
		end 
		--self.btn_lvup_down.isEnabled = false
		--BlackGo.setBlack(0.5, self.btn_lvup.transform)
	end 

	local qlv = Player.Chars[self.char.id].qualitylvl
	local info
	if qlv > 0 then
		info = TableReader:TableRowByUniqueKey("qualitylevel", self.char.dictid, qlv)
	elseif qlv == 0 then
		info = TableReader:TableRowByUniqueKey("qualitylevel", self.char.dictid, qlv + 1)
 	end

 	if info == nil then
		self.btn_huashen:SetActive(false)
	end
 	 
	
	if self.char.star < 2 then 
		self.btn_lvup_down.gameObject:SetActive(false)
		self.btn_jinjie_down.gameObject:SetActive(false)
		self.btn_tupo_down.gameObject:SetActive(false)
		self.btn_blood_down.gameObject:SetActive(false)
		self.btn_huashen_down.gameObject:SetActive(false)
		
		self.btn_lvup_gray.isEnabled = false 
		self.btn_jinjie_gray.isEnabled = false 
		self.btn_tupo_gray.isEnabled = false 
		self.btn_blood_gray.isEnabled = false 
		self.btn_huashen_gray.isEnabled = false 
		
		self.btn_lvup_gray.gameObject:SetActive(true)
		self.btn_jinjie_gray.gameObject:SetActive(true)
		self.btn_tupo_gray.gameObject:SetActive(true)
		self.btn_blood_gray.gameObject:SetActive(true)
		self.btn_huashen_gray.gameObject:SetActive(true)
	end 
end

--显示当前的培养面板，隐藏其余面板
function m:updatePanel(tp)
    for i = 1, 6 do
        if i == tp then
            self.tabList[tp].gameObject:SetActive(true)
        else
            if self.tabList[i] ~= nil then
                self.tabList[i]:CallTargetFunction("hideEffect") --将其余面板中的特效隐藏或销毁
                self.tabList[i].gameObject:SetActive(false)
            end
        end
    end
end

function m:onExit()
    self._exit = true
    -- if self.tp == 1 then
    --     self.tab:CallTargetFunction("hideEffect")
    -- end
end

--获取小伙伴队列
function m:checkFriend(charId)
    local teams = Player.Team[12].chars
    local list = {}
    for i = 0, 7 do
        if teams[i]~= nil and teams[i] == charId then
            return true
        end
    end
    return false
end

function m:check(tp)
	if self.char.star < 2 then tp = 5  return end 
    self.tp = tp
    self:onUpdate(false, true)
end

function m:onClose()
    if self.tp == 6 then
        self.tab:CallTargetFunction("onClose")
    else
        UIMrg:pop()
    end
end

function m:switch(tp)
    if tp == nil then return end
    self.tp = tp
    self:onUpdate(false, true)
end

function m:OnDestroy()
	
end 

function m:Start()
	Tool.loadTopTitle(self.gameObject, TextMap.GetValue("Text_1_773"))
	LuaMain:ShowTopMenu()
    self.tp = 1
	--self.selectIndex = 1
    self.tabList = {}
    self.selectList = { self.select1, self.select2, self.select3 }
	
	self.btns={}
	self.btns[1] = self.btn_lvup
	self.btns[2] = self.btn_jinjie
	self.btns[3] = self.btn_cultivate
	self.btns[4] = self.btn_blood
	self.btns[5] = self.btn_tupo
	self.btns[6] = self.btn_huashen

	
	self.btnPos={}
	for i =1, 6 do 
		self.btnPos[i] = self.btns[i].gameObject.transform.localPosition
		self.btns[i].gameObject:SetActive(false)
	end 

	self.jinhuaLV = 0
	-- --local linkData = Tool.readSuperLinkById(75)--charArgs
	local linkData = TableReader:TableRowByID("charArgs", "min_qualitylevel")
	if linkData ~= nil then
		self.jinhuaLV = linkData.value2
		--self.open_huashen = self.char.star_level >= linkData.value2
	end
	
	self:onUpdate(true, true)
	--self:updateBtnState()
end

return m

