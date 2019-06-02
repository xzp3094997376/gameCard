
local hero_info = {}
function hero_info:onTooltip(name)
    --if name == "dingwei" then
    --    return self.dw_text
    --end
end

function hero_info:update(char)
	local newChar = nil
	if char.id == Player.Info.playercharid then 
		newChar = Char:new(char.id)
	else 
		newChar = char
	end 

	self.jinhuaLV = 0
	--local linkData = Tool.readSuperLinkById(75)--charArgs
	local linkData = TableReader:TableRowByID("charArgs", "min_qualitylevel")
	if linkData ~= nil then
		self.jinhuaLV = linkData.value2
	end

    hero_info:setHero(newChar)
    self.char = newChar
    local lua = { type = "skill", nChar = self.char, char = char }
	self:onUpdate()
	self.skill:CallUpdate(lua)
	hero_info:setSoundState()
end

function hero_info:setSoundState()
	local soundInfo = TableReader:TableRowByID("avter", self.char.dictid)
	if soundInfo.jianjie_audio ~= nil and soundInfo.jianjie_audio ~= "" and soundInfo.jianjie_audio > 0 then
		self.soundId = soundInfo.jianjie_audio
		self.btn_sound.gameObject:SetActive(true)
	else
		self.btn_sound.gameObject:SetActive(false)
	end
end


function hero_info:SetTihuanAndXiexiaBtn(ret,lua)
    self.btn_tihuan.gameObject:SetActive(ret)
    self.btn_xiexia.gameObject:SetActive(ret)
    self.tihuanLua=lua
    self.delegate=lua.delegate
end

function hero_info:onEnter()
	self:onUpdate()
	local lua = { type = "skill", char = self.char }
	self.skill:CallUpdate(lua)
end 

function hero_info:onUpdate()
	self.char:updateInfo()
	
	if self.char.star < 2 then 
		self.btn_lvup.isEnabled = false
		self.btn_evolution.isEnabled = false
		self.btn_blood.isEnabled = false
		self.btn_wake.isEnabled = false
	else
		self.btn_lvup.isEnabled = true
		self.btn_evolution.isEnabled = true
		self.btn_blood.isEnabled = true
		self.btn_wake.isEnabled = true

		if self.char.id == Player.Info.playercharid then 
			self.btn_lvup.gameObject:SetActive(false) --.isEnabled = false
		else 
			self.btn_lvup.gameObject:SetActive(true) 
		end 
	end 
	self.btn_huashen.gameObject:SetActive(true)
	self.btn_huashen_gray.gameObject:SetActive(false)
	self.open_lv = self:checkLockNoMsg(227, true)
	self.open_jinjie = self:checkLockNoMsg(228, false)
	self.open_peiyang = self:checkLockNoMsg(230, false)
	self.open_juexing = self:checkLockNoMsg(229, false)
	self.open_xuemai = self:checkLockNoMsg(72, false)
	self.open_huashen = self:checkLockNoMsg(75, true)

	if self.char.star_level < self.jinhuaLV then
		self.open_huashen = false
	end

	if self.char.star >= 5 and self.open_huashen then
		self.btn_huashen.isEnabled = true
	else
		self.btn_huashen.isEnabled = false
	end

	local targetlvInfo = TableReader:TableRowByUniqueKey("qualitylevel", self.char.dictid, Player.Chars[self.char.id].qualitylvl + 1)
	if targetlvInfo == nil then
		self.btn_huashen.gameObject:SetActive(false)
		self.btn_huashen_gray.gameObject:SetActive(true)
	end

	self:updateDes()

	self:updateRedPoint()
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
end 

function hero_info:updateRedPoint()
	--更新红点提示
	local char = self.char
    self.redPoint_lv:SetActive(char:redPointForStrong() and self.open_lv) --升级突破
    self.redPoint_jinhua:SetActive(char:redPointForJinHua() and self.open_jinjie) --进化
    self.redPoint_peyang:SetActive(char:redPointForCultivate() and self.open_peiyang) --灵络
    self.redPoint_wake:SetActive(char:redPointForEquip() or char:redPointForJueXing() and self.open_juexing)
    self.redPoint_blood:SetActive(char:redPointForXueMai() and self.open_xuemai)
    self.redPoint_huashen:SetActive(char:redPointForHuaShen(char) and self.open_huashen)
end 

function hero_info:updateDes()
	    --属性与描述
    local list = self.char:getAttrDesc()
	self.txt_attr_left.text = list[1]
	self.txt_attr_left2.text = list[4]
	self.txt_attr_right.text = list[2]
	self.txt_attr_right2.text = list[5]

	--self.txtName.text = self.char:getDisplayName()
	self.img_type.spriteName = self.char:getDingWei()
	--local star = math.floor (self.char.stage / 10 )
	--local starLv = math.fmod(self.char.stage,10) - 1
	--if starLv < 0 then starLv = 0 end
	self.txtLv.text = TextMap.GetValue("Text_1_772") .. self.char.lv
	local level = Player.Chars[self.char.id].bloodline.level
	self.txt_blood.text = TextMap.GetValue("Text_1_831") .. level
	self.txt_wake.text = TextMap.GetValue("Text_1_832") .. self.char:getStageStar()

	local tb = TableReader:TableRowByUniqueKey("powerUp", self.char.Table.powUpId, self.char.stage)
	if tb == nil then 
		Debug.LogError(TextMap.GetValue("Text_1_833") .. (self.char.stage.."||"..self.char.dictid));
		self.txt_power_desc.text = ""
		return 
	end 
	local desc, list = self:getMagics(tb.magic)
	self.txt_hero_desc.text = self.char.Table.desc
	local left = ""
	local right = ""
	for i = 1, #list do 
		if i % 2 == 0 then right = right .. list[i] 
		else  left = left .. list[i] end 
		-- if i < 3 then left = left .. list[i] 
		-- else  right = right .. list[i] end 
	end 
	self.txt_power_desc.text = left
	self.txt_power_desc2.text = right
	local list = self:updatePowerSkill()
	self.awke_binding:CallUpdate({ type = "other", list = list })
	
	local fetterList = self:getAllFetter()
    self.fate:CallUpdate({ type = "other", list = fetterList })

	for i = 1, 8 do
		self["txt_huashen_desc"..i].gameObject:SetActive(false)
	end
	
	-- 化神 橙卡和红卡 有化神信息
	local info = TableReader:TableRowByUniqueKey("qualitylevel", self.char.dictid, 1)
	if (self.char.star == 5 or self.char.star == 6) and info ~= nil and self.open_huashen then 
		self.btn_huashen.isEnabled = true
		self.txt_huashen.text = TextMap.GetValue("Text_1_834") .. self.char:getHuaShenLevel(self.char.id, self.char.dictid, self.char.quality)
		local tb2 = TableReader:TableRowByUniqueKey("qualitylevel", self.char.dictid, self.char.info.qualitylvl)
		local list = self.char:showHuaSProList(self.char.id, self.char.dictid)

		for i = 1, 4 do
			self["txt_huashen_desc"..i].gameObject:SetActive(true)
		end
		self.txt_huashen_desc1.text = list[3]
		self.txt_huashen_desc2.text = list[0]
		self.txt_huashen_desc3.text = list[1]
		self.txt_huashen_desc4.text = list[2]
	else
		self.btn_huashen.isEnabled = false
		self.huashen.gameObject:SetActive(false)
		self.jinhua_tianfu:SetAnchor(self.awke_tianfu.gameObject, 
			1, -680, 11, -10)
		self.jinhua_tianfu.leftAnchor.relative = 0
		self.jinhua_tianfu.bottomAnchor.relative = 0
		self.jinhua_tianfu.rightAnchor.relative = 1
		self.jinhua_tianfu.topAnchor.relative = 0
	end
	local list = {}
	if self.char.quality == 5 and self.char.star == 6 then
		list = self:updateHuaShenSkill()
	else
		list = self:updateStarUpSkill()
	end
	self.jinhua_binding:CallUpdate({ type = "other", list = list })
end 


function hero_info:updatePowerSkill()
	-- 天赋技能
	local that = self
	local tb = nil 
	--local temp_desc = ""
	local list = {}
	for i = 0, self.char.modelTable._powerUp_skill.Count - 1 do 
		local skill = self.char.modelTable._powerUp_skill[i]
		local unlock = TableReader:TableRowByUniqueKey("unlock_skill", "powerUp_skill", i+1)
		local starStr = self.char:getStageStarByNum(unlock.unlock_arg, false)
		--local star = math.floor ( unlock.unlock_arg / 10 )
		--local starLv = math.fmod(unlock.unlock_arg,10) - 1
		local name = ""	
		local desc = ""
		if self.char.stage >= unlock.unlock_arg then
			name = "[ff0000]【" .. skill.show.."】[-] "
			desc = "[ff0000]" .. skill.desc_eff .. " " .. TextMap.GetValue("Text_1_835")..starStr..TextMap.GetValue("Text_1_836")
			--temp_desc = temp_desc .. .. 
		else
			name = "[ffc864]【" .. skill.show.."】[-]"
			desc = "[ffc864]".. skill.desc_eff .. " " .. TextMap.GetValue("Text_1_837")..starStr..TextMap.GetValue("Text_1_838")
			--temp_desc = temp_desc ..  [ffffff]".. skill.desc_eff .. " " .. "\n（突破至"..starStr.."激活）[-] \n\n"
		end 
		table.insert(list, {name = name, desc = desc})
	end 
	return list
	--self.txt_power_skill_des.text = temp_desc
	--self.awke_img_bg.height = self.txt_power_skill_des.height
end

function hero_info:updateStarUpSkill()
	-- 天赋技能
	local that = self
	local list = {}
	for i = 0, self.char.modelTable._starup_skill.Count - 1 do 
		local skill = self.char.modelTable._starup_skill[i]
		local unlock = TableReader:TableRowByUniqueKey("unlock_skill", "starup_skill", i+1)
		local name = ""	
		local desc = ""
		if self.char.star_level >= unlock.unlock_arg then 
			name = "[ff0000]【" .. skill.show.."】[-]"
			desc = "[ff0000]".. skill.desc_eff .. " " .. TextMap.GetValue("Text_1_839")..(unlock.unlock_arg)..TextMap.GetValue("Text_1_840")
		else
			name = "[ffc864]【" .. skill.show.."】[-]"
			desc = "[ffc864]".. skill.desc_eff .. " " .. TextMap.GetValue("Text_1_841")..(unlock.unlock_arg)..TextMap.GetValue("Text_1_842")
		end 
		table.insert(list, {name = name, desc = desc})
	end 
	--self.jinhua_tianfu.bottomAnchor:Set(0, -(self.txt_star_skill_desc.height + 50)) -- 偏移
	return list
end

function hero_info:updateHuaShenSkill()
	local list = {}
	local huaSInfo = TableReader:TableRowByUniqueKey("qualitylevel", self.char.dictid, Player.Chars[self.char.id].qualitylvl)
	if huaSInfo ~= nil then
		local hsSkillList = TableReader:TableRowByID("qualitylevelattrib", huaSInfo.skilllvlid)
		for i = 0, hsSkillList._starup_skill.Count - 1 do 
			local skill = hsSkillList._starup_skill[i]
			local unlock = TableReader:TableRowByUniqueKey("unlock_skill", "starup_skill", i+1)
			local name = ""
			local desc = ""
			if self.char.star_level >= unlock.unlock_arg then 
				name = "[ff0000]【" .. skill.name.."】[-]"
				desc = "[ff0000]".. skill.desc_eff .. " " .. TextMap.GetValue("Text_1_839")..(unlock.unlock_arg)..TextMap.GetValue("Text_1_840")
			else
				name = "[ffc864]【" .. skill.name.."】[-]"
				desc = "[ffc864]".. skill.desc_eff .. " " .. TextMap.GetValue("Text_1_841")..(unlock.unlock_arg)..TextMap.GetValue("Text_1_842")
			end 
			table.insert(list, {name = name, desc = desc})
		end
 	end
	return list
end

function hero_info:getMagics(magics)
    local txt = ""
    local len = magics.Count - 1
	local list = {}
    for i = 0, len do
        local row = magics[i]
        local magic_effect = row._magic_effect
        local magic_arg1 = row.magic_arg1
        -- local magic_arg2 = row.magic_arg2
        local desc = ""
        desc = string.gsub("[ffff96]" .. magic_effect.format .. "[-]", "{0}", "[ffffff]"..(magic_arg1 / magic_effect.denominator))
        if i < len then desc = desc .. "\n" end
        -- if math.floor(magic_arg1 / magic_effect.denominator) == 0 then desc =  "" end
        txt = txt .. desc
		list[i+1] = desc
    end
    return  txt, list
end


function hero_info:setHero(char)
	--self.hero:LoadByModelId(char.modelid, "idle", function() end, false, 0, 1)
	self.currentHero:CallUpdate({char = char, delegate = self, isClick = false})
	self.txt_lv_name.text = char:getDisplayName()
    local tp = char:getType()
    local star = nil
    local piece = char

    if tp == "char" then
        star = char.star_level
        self.binding:Show("power_bg")
        self.binding:Hide("slider")
    else
        self.binding:Hide("power_bg")
        local info = piece:pieceInfo(star)
        self.slider.value = info.value
        self.binding:Show("slider")
        self.binding:Hide("btn_change")
    end
end

function hero_info:onClickChange()
    if self.btnType == 1 then
        local linkData = Tool.readSuperLinkById( 227)
        local unlockType = linkData.unlock[0].type --解锁条件
        if unlockType ~= nil then
            local level = linkData.unlock[0].arg
            if Player.Info.level < level or Player.Info.vip < linkData.vipLevel then
                MessageMrg.show(string.gsub(TextMap.TXT_OPEN_MODULE_BY_LEVEL, "{0}", level))
                return
            end
        end
        UIMrg:push("new_hero", "Prefabs/moduleFabs/hero/newHero", { char = self.char, tp = 1 })
        UIMrg:popWindow()
    elseif self.btnType == 2 then
        local linkData = Tool.readSuperLinkById( 14)
        local unlockType = linkData.unlock[0].type --解锁条件
        if unlockType ~= nil then
            local level = linkData.unlock[0].arg
            if Player.Info.level < level or Player.Info.vip < linkData.vipLevel then
                MessageMrg.show(string.gsub(TextMap.TXT_OPEN_MODULE_BY_LEVEL, "{0}", level))
                return
            end
        end
        UIMrg:push("new_hero", "Prefabs/moduleFabs/hero/newHero", { char = self.char, tp = 3 })
        UIMrg:popWindow()
    elseif self.btnType == 3 then
        local linkData = Tool.readSuperLinkById( 227)
        local unlockType = linkData.unlock[0].type --解锁条件
        if unlockType ~= nil then
            local level = linkData.unlock[0].arg
            if Player.Info.level < level or Player.Info.vip < linkData.vipLevel then
                MessageMrg.show(string.gsub(TextMap.TXT_OPEN_MODULE_BY_LEVEL, "{0}", level))
                return
            end
        end
        UIMrg:push("new_hero", "Prefabs/moduleFabs/hero/newHero", { char = self.char, tp = 1 })
        UIMrg:popWindow()
    elseif self.btnType == 4 then
        local moduleName = UIMrg:GetRunningModuleName()
        if moduleName == "formation" then
            UIMrg:popWindow()
            return
        end
        Tool.push("team", "Prefabs/moduleFabs/formationModule/formation/formation_main", { 0 })
        UIMrg:popWindow()
    elseif self.btnType == 5 then
        local linkData = TableReader:TableRowByID("bloodlineSetting", 4)
        if linkData.arg ~= nil then
            if Player.Info.level < linkData.arg then
                MessageMrg.show(string.gsub(TextMap.TXT_OPEN_MODULE_BY_LEVEL, "{0}", linkData.arg))
                return
            end
        end
        UIMrg:push("new_hero", "Prefabs/moduleFabs/hero/newHero", { char = self.char, tp = 6 })
        UIMrg:popWindow()
    end
end

function hero_info:Start()
	Tool.loadTopTitle(self.gameObject, TextMap.GetValue("Text_1_843"))
    ------------------------------------------------------------------- fix at 2015年5月6日 去掉星星------------------------------------------------------------------------------
    self.binding:Hide("star")
    self.binding:Hide("txt_lv")
    --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    self.btnType = 1
	--滑动
	self.dir = -1
	self.offsetX = 300
	self.isDrag = false
	self.currentHero = self.hero
	self.assistHero = self.hero2
	self.original = self.currentHero.gameObject.transform.localPosition
	self:resetHero()
	self:adjust()
end

function hero_info:adjust()
	self.con:SetActive(false)
	self.skill.gameObject:SetActive(false)
	self.fate.gameObject:SetActive(false)
	self.binding:CallManyFrame(function()
		self.con:SetActive(true)
	end)
	self.binding:CallManyFrame(function()
		self.skill.gameObject:SetActive(true)
	end, 2)	
	self.binding:CallManyFrame(function()
		self.fate.gameObject:SetActive(true)
	end, 3)		
end

--刷新英雄列表
function hero_info:findHeroList()
    local charsList = {} --所有英雄
    local chars = Player.Chars:getLuaTable()
    local list = {} --上阵英雄
    local friendList = {} --小伙伴
	local pChar = Char:new(Player.Info.playercharid)
	pChar.tab = self.tab
    for k, v in pairs(chars) do
        local char = Char:new(k, v)
        char.tab = self.tab
		if char.id ~= Player.Info.playercharid then 
			if char.teamIndex <= 6 then --上阵英雄
				table.insert(list, char)
			elseif self:checkFriend(char.id) == true then
				table.insert(friendList,char)
			else --未上阵英雄
				table.insert(charsList, char)
			end
		end 
    end
	
    -- 排列未上阵与不是小伙伴的角色
    table.sort(charsList, function(a, b)
        if a.star ~= b.star then return a.star > b.star end
        if a.lv ~= b.lv then
            return a.lv > b.lv
        end
        return a.id < b.id
    end)

    --排列上阵角色
    table.sort(list, function(a, b)
        if a.star ~= b.star then return a.star < b.star end
        if a.lv ~= b.lv then
            return a.lv < b.lv
        end
        return a.id > b.id
    end)

    --排列小伙伴
    table.sort(friendList,function (a,b)
        if a.star ~= b.star then return a.star < b.star end
        if a.lv ~= b.lv then
            return a.lv < b.lv
        end
        return a.id > b.id
    end)
    local len = #friendList
    if len > 0 then
        for i=1,#friendList do
            local v = friendList[i]
            table.insert(charsList, 1, v)
        end
    end

    for i = 1, #list do
        local v = list[i]
        table.insert(charsList, 1, v)
    end
	table.insert(charsList, 1, pChar)
	
    for i = 1,#charsList do
        local char = charsList[i]
		if char.id == self.char.id then 
			self.index = i
		end 
    end
	
	self.minIndex = 1
	self.maxIndex = #charsList
    self.allChars = charsList
end

--获取小伙伴队列
function hero_info:checkFriend(charId)
    local teams = Player.Team[12].chars
    local list = {}
    for i = 0, 7 do
        if teams[i]~= nil and teams[i] == charId then
            return true
        end
    end
    return false
end

function hero_info:onClick(go, name)
    if name == "btnBack" then
        UIMrg:pop()
    elseif name == "btn_change" then
        self:onClickChange()
	elseif name == "btn_lvup" then 
		local isopen = self:checkLock(227, true)
		if isopen then 
			UIMrg:push("new_hero", "Prefabs/moduleFabs/hero/newHero", { char = self.char, tp = 1 })
		end 
	elseif name == "btn_evolution" then 
		local isopen = self:checkLock(228, false)
		if isopen then 
			UIMrg:push("new_hero", "Prefabs/moduleFabs/hero/newHero", { char = self.char, tp = 3 })
		end
	elseif name == "btn_peiyang" then 
		local isopen = self:checkLock(230, false)
		if isopen then 
			UIMrg:push("new_hero", "Prefabs/moduleFabs/hero/newHero", { char = self.char, tp = 5 })
		end
	elseif name == "btn_wake" then 
		local isopen = self:checkLock(229, true)
		if isopen then 
			UIMrg:push("new_hero", "Prefabs/moduleFabs/hero/newHero", { char = self.char, tp = 2 })
		end 
	elseif name == "btn_blood" then 
		local isopen = self:checkLock(72, false)
		if isopen then 
			UIMrg:push("new_hero", "Prefabs/moduleFabs/hero/newHero", { char = self.char, tp = 4 })
		end
	elseif name == "btn_left" then 
		self:onLeft()
	elseif name == "btn_right" then 
		self:onRight()
    elseif name =="btn_tihuan" then 
        UIMrg:pop()
        local bind = UIMrg:pushWindow("Prefabs/moduleFabs/formationModule/formation/formation_select_char")
        bind:CallUpdate(self.tihuanLua)
    elseif name =="btn_xiexia" then  
        if self.tihuanLua.type == "single" then
            if self.tihuanLua.module=="teamer" then 
                self.delegate:onCallBack(nil, self.tihuanLua.module)
                UIMrg:pop()
            end
        end
    elseif name == "btn_huashen" then 
		local isopen = self:checkLock(75, false)
		if isopen then 
			UIMrg:push("hua_shen", "Prefabs/moduleFabs/hero/newHero", { char = self.char, tp = 6 })
		end
	elseif name == "btn_huashen_gray" then
		local isOpen = self:checkLock(75, true)--读表
		if isOpen then
			isOpen = hero_info:checkHuashenTop()
		end
	elseif name == "btn_sound" then
 		MusicManager.playByID(self.soundId)
	end
end

function hero_info:checkHuashenTop()
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

function hero_info:checkLockNoMsg(id, isCharLevel)
	local linkData = Tool.readSuperLinkById( id)
    local unlockType = linkData.unlock[0].type --解锁条件
    if unlockType ~= nil then
        local level = linkData.unlock[0].arg
		if isCharLevel then
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

function hero_info:checkLock(id, isCharLevel)
	local linkData = Tool.readSuperLinkById(id)
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


function hero_info:onLeft()
	if self.allChars == nil then 
		self:findHeroList()
	end  
	
	self.index = self.index - 1
	if self.index < self.minIndex then self.index = self.minIndex end 
	self:updateHero()
end 

function hero_info:onRight()
	if self.allChars == nil then 
		self:findHeroList()
	end
	
	self.index = self.index + 1
	if self.index > self.maxIndex then self.index = self.maxIndex end 
	self:updateHero()
end 

function hero_info:updateHero()
	self:update(self.allChars[self.index])
end 

--获取所有的羁绊
function hero_info:getAllFetter()
	local fetterList = {}
    local line = self.char.modelTable
	-- print(self.char.dictid)
	-- print_t(self.char.modelTable)
    if line ~= nil then
        if line.relationship == nil then
            print("line.relationship is nil ")
        end
		local that = self 
        for i = 0, line.relationship.Count - 1 do
            if line.relationship[i] ~= nil and line.relationship[i].."" ~= "" then
                local tb = TableReader:TableRowByID("relationship", line.relationship[i])
                local fetterName = tb.show_name
				local ft = ""
				local ftdesc = ""
				local ret = that:checkFetter(tb.id)
				if  ret == true then 
					ft = "[ff0000]【" .. fetterName .. "】[-]"
					ftdesc = "[ff0000]" .. tb.desc_eff  .. " [-]" 
				else 
					ft = "[ffc864]【" .. fetterName .. "】[-]"
					ftdesc = "[ffc864]" .. tb.desc_eff  .. " [-]" 
				end 
				table.insert(fetterList, {name = ft, desc = ftdesc})
            end
        end
	end
	return fetterList
end

function hero_info:checkFetter(id)
    local list = self:getFetter(self.char.id) -- 获取该角色已经激活的羁绊列表
	local ret = false
    for i = 1, #list do
		local item = list[i]
        local line = TableReader:TableRowByID("relationship", item)
        if line == nil then
            line = TableReader:TableRowByUnique("relationship", item)
        end
		if line.id == id then return true end 
    end
	return false
end 

--获取某个角色已激活的羁绊id列表
function hero_info:getFetter(id)
    if id == nil then return end
    local fetters = Player.Chars[id].tie:getLuaTable()
    local tb = {}
    table.foreach(fetters, function(i, v)
        if v ~= nil then
            table.insert(tb, v)
        end
    end)
    return tb
end

function hero_info:getTeam()
    local teams = Player.Team[0].chars
    local list = {}
    self.team_count = 0
    for i = 0, 5 do
        if teams.Count > i then
            list[i + 1] = teams[i]
            if teams[i] ~= 0 and teams[i] ~= "0" then
                self.team_count = self.team_count + 1
            end
        else
            list[i + 1] = 0
        end
    end
    return list
end

-- 滑动系列函数
-- 重置位置
function hero_info:resetHero()
	-- 排序
	self.currentHero.gameObject.transform.localPosition = self.original
	self.assistHero.gameObject.transform.localPosition = Vector3(
		self.currentHero.gameObject.transform.localPosition.x + self.offsetX,
		self.currentHero.gameObject.transform.localPosition.y, 0)
	self.currentHero.gameObject:GetComponent(BoxCollider).enabled = true
	self.assistHero.gameObject:GetComponent(BoxCollider).enabled = false
	self.dir = -1
	self.isDrag = false
end

function hero_info:updateAssistPos(dir)
	local offset = -self.offsetX
	if dir == 1 then 
		offset = self.offsetX 
	end 
	self.assistHero.gameObject.transform.localPosition = Vector3(
	self.currentHero.gameObject.transform.localPosition.x + offset,
	self.currentHero.gameObject.transform.localPosition.y, 0)
end

function hero_info:updateAssistData(dir)
	local char = self:getTeamCharById(self.char.id, dir)
	if char ~= nil then 
		self.assistHero:CallUpdate({char = char, delegate = self, isClick = false})
		self.assistHero.gameObject:SetActive(true)
		self.canReplace = true
		self.assistChar = char
	else
		self.canReplace = false
		self.assistHero.gameObject:SetActive(false)
	end
end

function hero_info:backOriginal()
	local tween = self.currentHero.gameObject:GetComponent(TweenPosition)
	if tween ~= nil then 
		tween.from = self.currentHero.gameObject.transform.localPosition
		tween.to = self.original
		tween.duration = 0.1
		tween.enabled = true
		tween:ResetToBeginning()
		self.binding:CallAfterTime(tween.duration, function()
			if self.isReplace == true then 
				if self.assistChar ~= nil then 
					self:update(self.assistChar)
				end 
			end 
			self:resetHero()
		end)
	end 

end

function hero_info:getTeamCharById(id, dir)
    local teams = Player.Team[0].chars
	local count = 0
    for i = 0, 5 do
        if teams.Count > i then
            if teams[i .. ""] ~= 0 and teams[i .. ""] ~= "0" and teams[i..""] == id then --可以添加一个从服务器端传过来的死亡状态，如果死亡则不上阵
				-- 找到，使用方向找到身边的
				local char = nil 
				if dir == 1 then 
					if (i - 1) >= 0 and (i - 1) < teams.Count and teams[(i-1) .. ""] ~= 0 and teams[(i-1) .. ""] ~= "0" then 
						char = Char:new(teams[(i-1)..""])
						print("左边： " .. teams[(i-1)])
						return char
					end 
				elseif dir == 2 then 
					if   (i + 1) >= 0 and (i + 1) < teams.Count  and teams[(i+1) .. ""] ~= 0 and teams[(i+1) .. ""] ~= "0" then 
						char = Char:new(teams[(i+1)..""])
						print("右边： " .. teams[(i+1)])	
						return char
					end 
				end 
            end
        end
    end
	return nil
end

function hero_info:showAssist(dir)
	-- 向右
	self:updateAssistPos(dir)
	self:updateAssistData(dir)
end

-- 手指松开隐藏
function hero_info:onCallbackPress(ret)
	print("press: " .. tostring(ret))
	if ret == false then
		-- 切换当前卡片
		self:replaceCurrent()
		-- 缓动回到原位
		self:backOriginal()
		if self.assistHero ~= nil then 
			self.assistHero.gameObject:SetActive(false)
		end 
	else
	
	end 
end 

function hero_info:replaceCurrent()
	if self.canReplace and self.canReplace == true then
		self.isReplace = false
		local now = self.currentHero.gameObject.transform.localPosition.x
		local last = self.original.x
		local dis = math.abs(now - last)
		if dis > self.offsetX / 2 then 
			if self.assistChar ~= nil then 
				local temp = self.currentHero
				self.currentHero = self.assistHero
				self.assistHero = temp
				self.isReplace = true
			end
		end 
	end
end

function hero_info:onDragStart()
	if self.isDrag ~= true then 
		if self.dir ~= -1 then 
			self.isDrag = true
			self:showAssist(self.dir)
		end
	end 
end 

-- 获取方向
function hero_info:onCallBackDir(dir)
	if self.isDrag == true then return end 
	if dir ~= -1 then 
		print("新的方向："..dir)
		self.dir = dir
	end
end
-- 1 向左， 2向右

function hero_info:herosMove(delta)
	if delta.x > 0.5 then
		if self.isDrag == false then 
			self:onDragStart()
			self:onCallBackDir(2)
		end
	elseif(delta.x < -0.5) then
		if self.isDrag == false then 
			self:onDragStart()
			self:onCallBackDir(1)
		end
	end
	local value = math.abs(delta.x)
	if value > 0.5 then 
		self:move(delta)
	end
end

function hero_info:move(delta)
	-- 移动
	self.currentHero.gameObject.transform.localPosition = Vector3(
		self.currentHero.gameObject.transform.localPosition.x + delta.x,
		self.currentHero.gameObject.transform.localPosition.y,0)
	self.assistHero.gameObject.transform.localPosition = Vector3(
		self.assistHero.gameObject.transform.localPosition.x + delta.x,
		self.currentHero.gameObject.transform.localPosition.y,0)
end

return hero_info
