
-- 英雄升级
local m = {}

function m:update(lua)
	--print_t(lua)
    self.delegate = lua.delegate
    self:onUpdate(lua.char, true)
end

function m:playEquipOnEffect(go, equip)
    if go == nil then return end
    ClientTool.AlignToObject(self.efEquipOn.gameObject, go, 3)
    self.efEquipOn:ResetToBeginning()
    local desc = equip:getDescList()
    if self.__power and self.char.power - self.__power > 0 then
        table.insert(desc, TextMap.GetValue("Text_1_856") .. self.char.power - self.__power)
    end
    m:showOperateAlert(desc)
    --add by jixinpeng
    m:updateEquip()
end

function m:showOperateAlert(desc)
    self.binding:CallManyFrame(function()
        OperateAlert.getInstance:showToGameObject(desc, self.bottom)
    end)
end

function m:updateEquip()
    self.__power = self.char.power
    local char = self.char
    --判断是否突破到顶
    if not self.char:canPowerUp() then
        --self.binding:Hide("btn_powerUp")
    else
        --self.binding:Show("btn_powerUp")
        if self.curEquipCount == 6 then
            if self.tupoeffect == nil then
                --self.tupoeffect = Tool.LoadButtonEffect(self.btn_powerUp.gameObject)
            end
            self.tupoeffect:SetActive(true)

        else
            if self.tupoeffect ~= nil then
                self.tupoeffect:SetActive(false)
            end
        end
    end
    self.delegate:updateHeroInfo(self.char)
    self:updateDesc()
end

function m:updateDesc()
    local char = self.char
    --属性与描述
    --local list = char:getAttrDesc()
	
	local atr2_n, atr_s = GetAttrNew("PhyAtk", char.info.propertys)
	local pd2_n, pd_s = GetAttrNew("PhyDef", char.info.propertys)
	local life2_n, life_s = GetAttrNew("MaxHp", char.info.propertys)
	local md2_n, md_s = GetAttrNew("MagDef", char.info.propertys)
	
	self.txt_attr_left.text = atr_s --string.gsub(list[3], "\n", "")
	self.txt_attr_left2.text = md_s --string.gsub(list[7], "\n", "")
	self.txt_attr_right.text = pd_s--string.gsub(list[9], "\n", "")
	self.txt_attr_right2.text = life_s --string.gsub(list[1], "\n", "")

		
	self.txtName.text = char:getDisplayName()
	self.txtLv.text = TextMap.GetValue("Text_1_772") .. (char.lv)
	local exp1 = GetCharExp(char.lv, char.quality)
	local curExp = m:getCurrentExp(self.char.info.exp)
	self.txtExp.text =  TextMap.GetValue("Text_1_857") .. (curExp or 0) .. "/" .. (exp1 or 0)
    self.exp.value = (curExp or 0) / (exp1 or 0)


    self:updateExp()
	

	--local chars = Player.Chars:getLuaTable()
	--print_t(chars)
end

function m:updateAddDesc(propertys)
	--local list = self.char:getAttrDesc()
	local atr2_n = GetAttrNew("PhyAtk", propertys)
	local pd2_n = GetAttrNew("PhyDef", propertys)
	local life2_n = GetAttrNew("MaxHp", propertys)
	local md2_n = GetAttrNew("MagDef", propertys)
	
	local atr_n = GetAttrNew("PhyAtk", self.char.info.propertys)
	local pd_n = GetAttrNew("PhyDef", self.char.info.propertys)
	local life_n = GetAttrNew("MaxHp", self.char.info.propertys)
	local md_n = GetAttrNew("MagDef", self.char.info.propertys)
	
	self.txt_life.text = life2_n - life_n
	self.txt_atk.text = atr2_n - atr_n
	self.txt_de_ph.text = pd2_n - pd_n
	self.txt_de_mtk.text = md2_n - md_n
end

function m:updateExp()
	if self.meterials ~= nil then 
		local exp = 0
		table.foreach(self.meterials, function(i, v)
			if v ~= "0" and v ~= 0 then
				local char = Char:new(v)
				if char.Table~=nil then 
					exp = exp + char.Table.exp + char.info.exp
				end 
			end
		end)
		self.total = exp
		local lv = m:getLvup(exp)
		if lv > self.max_char_lv then lv = self.max_char_lv end
		self.slider_shine.gameObject:SetActive(true)
		if lv > 0 then 
			m:setUpTextVis(true)
			Api:getCharProperty(self.char.id, lv , 0, 0, 0, function(result)
				m:updateAddDesc(result.propertys)
			end)
			self.txtLvAdd.text = "+" .. lv
		else 
			m:setUpTextVis(false)
			self.txt_life.text = ""
			self.txt_atk.text = ""
			self.txt_de_ph.text = ""
			self.txt_de_mtk.text = ""
			self.txtLvAdd.text = ""
			--self.slider_shine.gameObject:SetActive(false)
		end 
		
		if exp > 0 then 
			local vrExp = m:getCurrentExp(exp + self.char.info.exp)
			local nExp = GetCharExp(self.char.lv + lv, self.char.quality)
			self.txtExp.text =  TextMap.GetValue("Text_1_857") .. vrExp .. "/" .. nExp
			--self.exp.value = vrExp / nExp
			self.slider_shine.value = vrExp / nExp
		else 
			local exp1 = GetCharExp(self.char.lv, self.char.quality)
			local curExp = m:getCurrentExp(self.char.info.exp)
			self.txtExp.text =  TextMap.GetValue("Text_1_857") .. curExp .. "/" .. exp1
			self.exp.value = curExp / exp1
			self.slider_shine.gameObject:SetActive(false)
		end 
	end 
	
	m:updateLevelInfo()
end 

function m:setUpTextVis(isVisible)
	self.txt_life.gameObject:SetActive(isVisible)
	self.txt_atk.gameObject:SetActive(isVisible)
	self.txt_de_ph.gameObject:SetActive(isVisible)
	self.txt_de_mtk.gameObject:SetActive(isVisible)
	self.txtLvAdd.gameObject:SetActive(isVisible)
end 

function m:getCurrentExp(totalExp)
	local total = totalExp --self.char.info.exp
	local lv = self.char.lv
	local lvupExp = GetCharTotalExp(lv, self.char.quality)
	if lvupExp == nil then return nil end 
	local level = 0
	local exp = total - GetCharTotalExp(lv-1, self.char.quality)
	while total >= lvupExp and lvupExp ~= -1 do 
		--total = total - lvupExp
		level = level + 1
		exp = total - lvupExp
		if lv + level > Player.Info.level then 
			return exp
		end 
		lvupExp = GetCharTotalExp(lv + level, self.char.quality)
	end 
	return exp
end

function m:getVrCurrentExp(addExp)
	local total = self.char.info.exp + addExp
	local lv = self.char.lv
	local lvupExp = GetCharTotalExp(lv - 1, self.char.quality)
	if lvupExp == nil then return nil end 
	local level = 0
	local exp = total - lvupExp
	while total >= lvupExp and lvupExp ~= -1 do 
		--total = total - lvupExp
		level = level + 1
		exp = total - lvupExp
		if lv + level > Player.Info.level then 
			return exp
		end 
		lvupExp = GetCharTotalExp(lv + level, self.char.quality)
	end
	return exp
end 

function m:getLvup(addExp)
	local curExp = self.char.info.exp
	local total = curExp  + addExp
	local lv = self.char.lv
	if Player.Info.level <= self.char.lv then 
		return 0
	end
	local lvupExp = GetCharTotalExp(lv, self.char.quality)
	if lvupExp == nil then return nil end 
	self.slider_shine.value = total/lvupExp
	local level = 0
	while(total >= lvupExp and lvupExp ~= -1 ) do 
		level = level + 1
		if lv + level > Player.Info.level then 
			return level
		end 
		lvupExp = GetCharTotalExp(lv + level, self.char.quality)
	end 
	return level
end 

function m:updateLevelInfo()
    local char = self.char
    local info = char:expInfo()

    if self.max_char_lv > char.lv and info.value >= 1 then
        --if self.buttonEffect == nil then
        --    self.buttonEffect = Tool.LoadButtonEffect(self.btnLvUp.gameObject)
        --end
        --self.buttonEffect:SetActive(true)

    else
        --if self.buttonEffect ~= nil then
        --    self.buttonEffect:SetActive(false)
        --end
    end
	local tb = TableReader:TableRowByID("charArgs", "charLevelUp_consumeRate")
	local sn = Tool.getResIcon(tb.value)
	self.icon:setImage(sn, "ItemImage")
	local cost = 0 
	if tb.value == "money" then 
		cost = self.total * tonumber(tb.value2) 
	elseif tb.value == "item" then 
		cost = self.total * tonumber(tb.other) 
	end 
    self.txt_soul.text = cost
end

function m:onTooltip(name)
    if name == "dingwei" then
        return self.dw_text
    end
end

function m:find(name)
    local go = self.gameObject.transform:Find(name)
    if go then return go.gameObject end
    return nil
end

function m:resort(go)
    if go.gameObject.activeSelf then
        go.gameObject:SetActive(false)
        go.gameObject:SetActive(true)
    end
end

function m:updateBloodState()
    local hero_info = m:find("Container/hero_info")
    Tool.SetActive(hero_info, self.showEquip)
    Tool.SetActive(self._blood_bg, not self.showEquip)
end

function m:onUpdate(char, ret)
    self.btnOneKeyLvUp.gameObject:SetActive(false)
    self.char = char
	if self.char == nil then return end 
    if ret == nil then
        Events.Brocast('updateChar')
    end
    if self._blood then
        self._blood:CallTargetFunction("onUpdate", self.char)
    end
	self.slider_shine.gameObject:SetActive(false)

    if char.star < 4 then
        m:setImage(false)
    else
        m:setImage(open)
    end

    --self.binding:CallManyFrame(function()
    --    m:updateEquip()
    --end)
    self.binding:CallManyFrame(function()
        m:updateDesc()
    end)
    --self.txt_soulOneKey.text = 0
    self.binding:CallManyFrame(function()
        m:updateLevelInfo()
    end)
    if self.max_char_lv <= char.lv then
        self.btnOneKeyLvUp.isEnabled = false
        self.btnLvUp.isEnabled = false
		self.btnAdd.isEnabled = false
    else
        self.btnOneKeyLvUp.isEnabled = true
        self.btnLvUp.isEnabled = true
		self.btnAdd.isEnabled = true
    end
    local linkData = TableReader:TableRowByID("charArgs", "yjsj_renzhe")
    if Player.Info.level>=tonumber(linkData.value) or Player.Info.vip>=tonumber(linkData.value2) then 
    	self.btnOneKeyLvUp.gameObject:SetActive(true)
    	--self.btnOneKeyLvUp.transform.localPosition=Vector3(267,-11,0)
    	self.btnLvUp.gameObject:SetActive(false)
    	--self.btnLvUp.transform.localPosition=Vector3(432,-11,0)
    	self.btnAdd.gameObject:SetActive(true)
    	--self.btnAdd.transform.localPosition=Vector3(432,-11,0)
    else 
    	self.btnLvUp.gameObject:SetActive(false)
    	--self.btnLvUp.transform.localPosition=Vector3(432,-11,0)
    	self.btnAdd.gameObject:SetActive(true)
    	--self.btnAdd.transform.localPosition=Vector3(432,-11,0)
    	self.btnOneKeyLvUp.gameObject:SetActive(false)
    end 
	--for i = self.max_slot + 1, 10 do 
	--	self["btn_add_"..i].gameObject:SetActive(false)
	--	self["img_hero_"..i].gameObject:SetActive(false)
	--end 
	self:updateMeterials()
	self.oneKeyExp=0
	self.load = false
	self.binding:CallAfterTime(1, function()
		self:getAllOneKeyChar()
		self.load = true
	end)
end

function m:getAllOneKeyChar()
	local chars = Player.Chars:getLuaTable()
    local charsList = {}
    local allExp=0
    for k, v in pairs(chars) do
        local char = Char:new(k, v)
		-- 可吞卡升级  和  可自动添加 的， 自动添加进来
		if char.Table.can_lvup_yjtj_auto == 1 then		
			if self:onFilterAutoAdd(char) then
				allExp=allExp+char.Table.exp + char.info.exp
				table.insert(charsList, char)
			end
		end
    end
	table.sort(charsList, function(a, b)
		if a.Table.exp ~=b.Table.exp then return a.Table.exp>b.Table.exp end 
        return a.id < b.id
    end)
    self.onekeyChar=charsList
    self.oneKeyExp=allExp
end

function m:dropNumber(list, newList, power)
    local descIndex = {}
    local numList = {}
    for i = 0, list.Count - 1 do
        if list[i] ~= newList[i] then
            table.insert(descIndex, i)
            numList[i] = newList[i] - list[i]
        end
    end
    if power and power > 0 then
        table.insert(descIndex, TextMap.GetValue("Text_1_822") .. power)
    end
    local txtList = self.char:getAttrList(descIndex, numList, "+")
    m:showOperateAlert(txtList)
end

function m:updateTab()
    m:onUpdate(self.char)
end

function m:playEffect()
    self.effect:SetActive(false)

	self.juese_zishenshengji:SetActive(false)
	self.juese_zishenshengji:SetActive(true)
	
    self.effect:SetActive(true)
	--self.binding:CallAfterTime(2, function()
	--	self.effect:SetActive(false)
	--end)
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


function m:onLvUp(go)
    local that = self
    local list = self.char.info.propertys
    local power = self.char.power
	if self.meterials == nil or #self.meterials < 1 then 
		MessageMrg.show(TextMap.GetValue("Text_1_858"))
		return 
	end 
    self.btnAdd.isEnabled = false
    self.btnLvUp.isEnabled = false
    self.btnOneKeyLvUp.isEnabled = false
    Api:charLevelUp(self.char.id, self.meterials, function(result)
        Events.Brocast('showEffect')
        that:playEffect()
		that.binding:CallAfterTime(0.7, function()
			that.char:updateInfo()
			self.meterials = {}
			that:onUpdate(that.char)
			self.delegate:updateRedPoint()
			local newList = that.char.info.propertys
			MusicManager.playByID(28)
			m:dropNumber(list, newList, that.char.power - power)
			that.delegate:updateHeroInfo(that.char)
			that.delegate:updateColor()
			local ret = GuideMrg.Brocast("charJinHua", that.char)
			if not ret then
				GuideMrg.Brocast("charXilian", that.char)
			end
			self.btnAdd.isEnabled = true
			self.btnLvUp.isEnabled = true
			self.btnOneKeyLvUp.isEnabled = true
			that:setUpTextVis(false)
			self.juese_zishenshengji:SetActive(false)
			m:resetLvup()
		end) 
		--self.isAdd = false
    end, function(ret)
        self.btnAdd.isEnabled = true
		self.btnLvUp.isEnabled = true
		self.btnOneKeyLvUp.isEnabled = true
        return false
    end)
end

function m:onOneKeyLvUp(go)
	if self.load == false then return end 
	local exp1 = GetCharExp(self.char.lv, self.char.quality)
	local curExp = m:getCurrentExp(self.char.info.exp)
	if self.char.lv >=Player.Info.level then 
		MessageMrg.show(TextMap.GetValue("Text_1_859"))
	elseif self.oneKeyExp>=exp1-curExp then 
		UIMrg:pushWindow("Prefabs/moduleFabs/pet/gui_levelup_dialog", { pet = self.char, delegate = self } )
	else 
		MessageMrg.show(TextMap.GetValue("Text_1_860"))
	end 
end

local ImageCount = 0
function m:setImage(ret)
    if self.char.star < 4 then
		self.img_hero:LoadByModelId(self.char.modelid, "idle", function() end, false, -1, 1)
        --self.binding:ChangeColor("img_hero", Color.white)
        --self.txt_desc_for_power:SetActive(false)
        return
    end
    local show = self._isShowChangeImage
    if ret == true then
        show = not show
    end
    --local url = self.char:getImage(show)
	self.img_hero:LoadByModelId(self.char.modelid, "idle", function() end, false, -1, 1)
    --self.img_hero.Url = url
    --if self._isShowChangeImage == true and ret == false then
        --local a = 3 / 255
        --self.binding:ChangeColor("img_hero", Color(a, a, a))
        --self.txt_desc_for_power:SetActive(true)
    --else
        --self.binding:ChangeColor("img_hero", Color.white)
    --end
    ImageCount = ImageCount + 1
    if ImageCount >= 10 then
        ImageCount = 0
        ClientTool.release()
    end
end

function m:RotTo(go, btn, ret)
    btn.isEnabled = false
    local rotation = Quaternion.identity
    rotation.eulerAngles = Vector3(0, 80, 0)
    self.binding:RotTo(go, 0.2, rotation, function()
        m:setImage(ret)
        go.transform.rotation = Quaternion.Euler(Vector3(0, 90, 0))
        self.binding:CallManyFrame(function()
            self.binding:RotTo(go, 0.2, Quaternion.identity, function()
                btn.isEnabled = true
                go.transform.rotation = Quaternion.Euler(Vector3(0, 0, 0))
            end)
        end)
    end)
end

function m:goToJinHua(go)
    --跳到进化页面
    -- uSuperLink.open("powerUp", { 3, self.char }, 0, 2)
    self.delegate:switch(2)
end

function m:onClick(go, name)
    if name == "btnOneKeyLvUp" then
        m:onOneKeyLvUp(go)
    elseif name == "btn_changeNormal" then
        self._isShowChangeImage = not self._isShowChangeImage
        m:RotTo(self.img_hero.gameObject, go, true)
    elseif name == "btn_changeImage" then
        self._isShowChangeImage = not self._isShowChangeImage
        m:RotTo(self.img_hero.gameObject, go, false)
    elseif name == "btn_starUp" then
        m:goToJinHua(go)
    elseif name == "btnLvUp" then
        m:onLvUp(go)
	elseif name == "btnAdd" then 
		m:onAutoAdd()
	end 
	m:onClick_add(go, name)
	m:onClick_close(go, name)
end

function m:onFilterAutoAdd(char)
	if char.id == self.char.id then return false end
	if char.id == Player.Info.playercharid then return false end 
	-- 紫色以上不添加
	--if char.star > 4 then return false end
	-- 觉醒过的
	if char.stage > 0 then return false end 
	-- 进阶过的
	if char.star_level > 0 then return false end 
	-- 上阵的不能添加
	if m:isExitTeam(char.id) then return false end 
	-- 小伙伴
	if m:checkFriend(char.id) then return false end 
	-- 巡逻的不能添加
	for i = 1, 6 do
        local it = Player.Agency[i]
        if tonumber(it.charId) == tonumber(char.id) then return false end
    end
	
	return true
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

function m:onAutoAdd()
	local autoData = {}
	local chars = Player.Chars:getLuaTable()
    local charsList = {}
    for k, v in pairs(chars) do
        local char = Char:new(k, v)
		-- 可吞卡升级  和  可自动添加 的， 自动添加进来
		if char.Table.can_lvup_yjtj_auto == 1 then		
			if self:onFilterAutoAdd(char) then
				table.insert(charsList, char)
			end
		end
    end
	table.sort(charsList, function(a, b)
        if a.star ~= b.star then return a.star < b.star end
        if a.lv ~= b.lv then return a.lv < b.lv end
        if a.power ~= b.power then return a.power < b.power end
        return a.id < b.id
    end)
	
	for i = 1, self.max_slot do 
		if charsList[i] ~= nil then 
			autoData[i] = charsList[i]
			if self.meterials == nil then self.meterials = {} end
			self.meterials[i] = charsList[i].id
		else
			break
		end 
	end
	if self.meterials == nil or #self.meterials < 1 then 
		MessageMrg.show(TextMap.GetValue("Text_1_861"))
		--self.isAdd = false
		return 
	end 
	self:updateMeterials()
	self:updateExp()
end

function m:onFilter(char)
	--条件1
	if char.id == Player.Info.playercharid then return false end 
	if char.id == self.char.id then return false end
	--if char.star > 5 then return false end
	-- 觉醒过的
	if char.stage > 0 then return false end 
	-- 进阶过的
	if char.star_level > 0 then return false end 
	-- 上阵的不能添加
	if m:isExitTeam(char.id) then return false end 
		-- 小伙伴
	if m:checkFriend(char.id) then return false end 
	for i = 1, 6 do
        local it = Player.Agency[i]
        if tonumber(it.charId) == tonumber(char.id) then return false end
    end
	-- 选过的， 不能再选
	--if self.meterials ~= nil then 
	--	for i = 1, table.getn(self.meterials) do 
	--		if self.meterials[i] == char.id then return false end
	--	end 
	--end 
	
	return true
end

function m:onClick_close(go, name)
	print("name = " .. name)
	if self.meterials == nil then return end 
	for i = 1, #self.meterials do 
		if name == "btn_close_" .. i then 
			-- 选择英雄
			table.remove(self.meterials,i) 
			self:updateMeterials()
			self:updateExp()
			break
		end
	end 
end 
--local meterials = {}
function m:onClick_add(go, name)
	if self.max_char_lv <= self.char.lv then
		MessageMrg.show(TextMap.GetValue("Text_1_862"))
		return 
	end 
	for i = 1, self.max_slot do 
		if name == "btn_add_" .. i then 
			-- 选择英雄
			local bind = UIMrg:pushWindow("Prefabs/moduleFabs/hero/gui_select_hero")
			bind:CallUpdate({ type = "char", module = "daili", delegate = self, char = self.char, selectList = self.meterials, max = self.max_slot })
			self.clickIndex = i
			break
		end
	end 
end

function m:resetLvup()
	self.meterials = nil 
	self:updateMeterials()
	--for i = 1, self.max_slot do
	--	self["btn_add_"..i].gameObject:SetActive(true)
	--	self["img_hero_"..i].gameObject:SetActive(false)
	--end 
end 

function m:updateMeterials()
	if self.meterials ~= nil and #self.meterials > 0 then 
		self.btnLvUp.gameObject:SetActive(true)
		self.btnAdd.gameObject:SetActive(false)
	else 
		self.btnLvUp.gameObject:SetActive(false)
		self.btnAdd.gameObject:SetActive(true)
	end 
	for i = 1, self.max_slot do
		if self.meterials ~= nil and self.meterials[i] ~= nil then 
			local data = self.meterials[i]
			local char = Char:new(data)
			self["btn_add_"..i].gameObject:SetActive(false)
			self["img_hero_"..i]:LoadByModelId(Tool.getDictId(data), "idle", function() end, true, -1, 1, 255, 2)
			self["img_hero_"..i].gameObject:SetActive(true)
			self["btn_close_"..i].gameObject:SetActive(true)
			self["txt_name_"..i].text = char:getDisplayName()
		else 
			self["btn_add_"..i].gameObject:SetActive(true)
			self["img_hero_"..i].gameObject:SetActive(false)
			self["btn_close_"..i].gameObject:SetActive(false)
			self["txt_name_"..i].text = ""
		end 
	end
end 

function m:reLocation()
	if self.max_slot <= 5 then 
		for i = 1, self.max_slot do 
			self["bottom_"..i].transform.localPosition = self["pos"..i].transform.localPosition - Vector3(0, 35, 0)
			self["img_hero_"..i].transform.parent.localPosition = self["pos"..i].transform.localPosition
			if i < 3 then 
				m:alignClose(self["btn_close_"..i].gameObject, 1)
			else 
				m:alignClose(self["btn_close_"..i].gameObject, 2)
			end 
		end 
	end 
	for i = self.max_slot + 1, 10 do 
		self["img_hero_"..i].transform.parent.gameObject:SetActive(false)
		self["bottom_"..i]:SetActive(false)
	end 
end

function m:alignClose(go, align)
	local pos = go.transform.localPosition
	if align == 1 then 
		go.transform.localPosition = Vector3(-math.abs(pos.x), pos.y, 0)
	elseif align == 2 then 
		go.transform.localPosition = Vector3(math.abs(pos.x), pos.y, 0)
	elseif align == 3 then 
		go.transform.localPosition = Vector3(0, pos.y, 0)
	end 
end 

function m:onCallBackSelect(chars, tp)
	print("call back selectCostList")
	--if self.meterials == nil then self.meterials = {} end 
	
	self.meterials = {}
	local index = 0
	for i, v in pairs(chars) do
		index = index + 1
		if index > self.max_slot then return end 
		if self.meterials[index] == nil and v ~= nil then 
			self.meterials[index] = v.id
		end 
	end 
	self:updateMeterials()
	for i = 1, self.max_slot do
		if self.meterials[i] == nil then 
			self["txt_name_"..i].text = ""
		end 
	end 
	self:updateExp()
end 

function m:onCallBack(chars, tp)
	if chars == nil then 
		print("回调出错: " .. tostring(tp))
		return
	end 
	local that = self
	for i, v in pairs(chars) do
		if v.Table.can_lvup_yjtj_auto ~= 1 and v.star >= 4 then 
			DialogMrg.ShowDialog(TextMap.GetValue("Text_1_863"), function()
				that:onCallBackSelect(chars)
				UIMrg:popWindow()
				return
			end)
		end 
	end
	m:onCallBackSelect(chars, tp)
end

function m:onSelectLvOk()

end 

function m:onSelectLvCannel()

end 

function m:hideEffect()
end

function m:OnEnable()
    self:onUpdate(self.char)
end

function m:Start()
	if Player.Info.level < 50 then self.max_slot = 5
	else self.max_slot =  10 end
	local char = Char:new(Player.Info.playercharid)
	self.max_char_lv = char.lv
	--self.isAdd = false
	self.v_lv = 0
	
	self.total = 0
    self.showEquip = true
	m:setUpTextVis(false)
	
	m:reLocation()
end

function m:onClose()
    -- if self.showEquip then 
    --     UIMrg:pop()
    -- else
    --     DialogMrg.ShowDialog(TextMap.getText("TXT_CLOSE_BLOOD").."\n\n"..TextMap.getText("TXT_CLOSE_BLOOD_TIP"),function()
    --     end,function()
    --         UIMrg:pop()
    --     end,nil,nil,"继续升级","先行离开")
    -- end
    UIMrg:pop()
end

return m

