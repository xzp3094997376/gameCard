-- 鬼道装备
local m = {}

function m:update(data)
    self.binding:Hide("txt_unlock_lv")
    self.data = data
	self.delegate = data.delegate
	m:onUpdate()
end

function m:onUpdate()
	local data = self.data
    self.charIndex = data.charIndex
    self.equipIndex = data.equipIndex --装备位置
    self.char = data.char
    if self.List_start ~= nil then
        self.List_start.gameObject:SetActive(false)
    end
    if self.data.empty == true then
        m:reset(data)
        --m:showEffect(true)
		self.add:SetActive(true)
		local ret = false 
		if self.data.kind ~= "pet" and self.data.kind ~="yuling" then
			if  self.data.subtype == "treasure" then
				ret = Tool.checkRedTreasureKind(data.kind)
			else 
				ret = Tool.checkRedGhostKind(self.equipIndex)
			end 
		elseif self.data.kind == "pet" then 
			ret = Tool.checkRedPetKind(self.charIndex)
        elseif self.data.kind == "yuling" then 
            ret = Tool.checkRedYulingKind(self.charIndex)
		end
		self.red_point:SetActive(ret or false)
    else
        --m:showEffect(false)
        self.binding:Show("frame")
        self.frame.spriteName = data:getFrameBG()
        self.kuang.spriteName = data:getFrame()
        m:setIcon(data, self.icon)
		--if self._Item == nil then
		--	self._Item = ClientTool.loadAndGetLuaBindingFromPool("Prefabs/publicPrefabs/itemAll", self.frame.gameObject)
		--end
		--self._Item:CallUpdate({ "char", self.ghost, self.frame.width, self.frame.height })
        self.binding:Hide("labState")
		self.lvbg.gameObject:SetActive(true)
        self.lv.text = "lv" .. data.lv
		self.lvbg.spriteName = m:getlvBgSprite(data.star)
        self.name.text = data:getDisplayColorName()
        self.kind = data.kind
        Tool.SetActive(self.power, data.power > 0)
        self.power.text = data.power > 0 and "+" .. data.power or ""
		self.add:SetActive(false)
		local ret = false 
		if self.data.kind ~= "pet" and self.data.kind~="yuling" then
			if  self.data.subtype == "treasure" then
				ret = Tool.checkRedTreasureStar(data.star, data.kind) or data:redPointQianHua()
			else 
				ret = Tool.checkRedGhostStar(data.star, data.kind) or data:redPointQianHua()
			end 
			self.red_point:SetActive(ret or false)
		elseif self.data.kind=="yuling" then 
            ret=m:getCanChangeYuling()
            self.red_point:SetActive(ret or false)
        else 
			self.red_point:SetActive(false)
		end
    end
    if data.char and data.char.empty == true then
        m:setLock(true)
        self.binding:Hide("frame")
        self.txt_unlock_lv.text = ""
        self.power.text = ""
        --m:showEffect(false)
    else
        self.isLock = false
        m:setLock()
    end
end

function m:getCanChangeYuling()
    local yilings =Player.yuling:getLuaTable()
    for k,v in pairs(yilings) do
        if v.huyou<=0 and v.quality>self.data.star and self.data.id ~= k then 
            return true
        end 
    end
    return false
end

function m:getlvBgSprite(star)
	local colors = {"dengji_baise", "dengji_lvse", "dengji_lanse", "dengji_zise", "dengji_chengse", "dengji_hongse"}
	return colors[star]
end

--[[
function m:showEffect(ret)
    if ret == true then
        if self.data.subtype == nil then
            ret = Tool.checkRedGhostKind(self.equipIndex)
        elseif  self.data.subtype == "treasure" then
            ret = Tool.checkRedTreasureKind(self.kind)
        end

        --if self.effNode == nil and ret then
        --    self.effNode = ClientTool.load("Effect/Prefab/ui_gongji_icon_blue", self.gameObject)
        --end
        --Tool.SetActive(self.effNode, ret)
    else
        --Tool.SetActive(self.effNode, false)
    end
end
]]--

function m:setIcon(item, icon)
    local name = item:getHeadSpriteName()
    local atlasName = packTool:getIconByName(name)
    icon:setImage(name, atlasName)
    if self.data.kind ~= "pet" then
        if self.List_start ~= nil then
            local starNum = Player.Ghost[item.key].star
            if starNum ~= nil and starNum > 0 then
                self.List_start.gameObject:SetActive(true)
                m:ShowStar(starNum)
            else
                self.List_start.gameObject:SetActive(false)
            end
        end
    end
end

function m:ShowStar(count)
    local list = {}
    for i = 1, 5 do
        list[i] = self["Star"..i]
        list[i].gameObject:SetActive(false)
    end

    if count > 0 and #list > 0 then
        for i = 1, count do
            list[i].gameObject:SetActive(true)
        end
    end
    self.List_start_grid.repositionNow = true
end

function m:reset(data)
    self.binding:Hide("txt_unlock_lv")
    self.binding:Hide("frame")
    self.star = data.star
    local tp = data.name
    self.kind = data.kind
    --self.labState.text = tp or ""
    --self.binding:Show("labState")
    --self.addEquip.spriteName = "guidao_add1"
    --    self.frame.spriteName = "guidao1"
    --self.lv.text = ""
	self.lvbg.gameObject:SetActive(false)
    self.name.text = ""
    self.power.text = ""
    m:setLock()
end

function m:onClick(go, name)
    if self.isLock == true then return end
    if self.data == nil then return end
    if self.data.empty == true then
		if self.data.kind ~= "pet" and self.data.kind ~= "yuling" then 
			if self.data and self.data.subtype == nil then
				UIMrg:pushWindow("Prefabs/moduleFabs/guidao/guidao_select_charpiece", { kind = self.kind, type = "ghost" })
			elseif self.data.subtype == "treasure" then
                UIMrg:pushWindow("Prefabs/moduleFabs/guidao/guidao_select_charpiece", { kind = self.kind, type = "treasure",charid = self.char.id,pos = self.equipIndex})
			end
		elseif self.data.kind == "pet" then 
			local bind = UIMrg:pushWindow("Prefabs/moduleFabs/formationModule/formation/formation_select_char")
            bind:CallUpdate({ type = "pet_huyou", module = "ghost", delegate = self.delegate, index = 1 })
        elseif self.data.kind == "yuling" then 
            local bind = UIMrg:pushWindow("Prefabs/moduleFabs/formationModule/formation/formation_select_char")
            bind:CallUpdate({ type = "yuling", module = "ghost", delegate = self.delegate, index = 1 })
		end
    else
		if self.data.kind ~= "pet" and self.data.kind ~= "yuling" then 
			if self.data.subtype == nil then 
				Tool.push("equip_info", "Prefabs/moduleFabs/equipModule/equip_info", {type = 2, ghost = self.data})
			elseif self.data.subtype == "treasure" then
				local temp = {}
				temp.obj = self.data
				temp.type = 2
				Tool.push("treasure_info", "Prefabs/moduleFabs/TreasureModule/treasure_tips", temp)
			end
		elseif self.data.kind == "yuling" then 
            Tool.push("yuling","Prefabs/moduleFabs/yuling/yuling_info", {pet = self.data, delegate = self.delegate,isShow=true})
        else 
			UIMrg:pushWindow("Prefabs/moduleFabs/formationModule/formation/formation_pet", {pet = self.data, delegate = self.delegate})
		end
    end
end

function m:checkHaveEquip(kind)
        --local has = lua.ghost or {}
        --local key = has.key or ""
        --local ghost = Player.Ghost:getLuaTable() or {}
        --local hasUse = Tool.getHasUseGhost()
        --table.foreach(ghost, function(i, v)
        --    local gh = Ghost:new(v.id, i)
        --    if gh.kind == kind then
        --        if not isUsed(hasUse, i) then
        --            table.insert(list, gh)
        --        end
        --    end
        --end)
        --table.sort(list, function(a, b)
        --    if a.star ~= b.star then return a.star > b.star end
        --    if a.power ~= b.power then return a.power > b.power end
        --    if a.lv ~= b.lv then return a.lv > b.lv end
        --    return false
        --end)
        --if #list == 0 then
end 

function m:setLock(ret)
    local lv = 0
	if self.data.kind ~= "pet" and self.data.kind ~= "yuling" then 
		if self.data.subtype == nil then
			lv = Tool.getUnlockLevel(241)
		elseif self.data.subtype == "treasure" then
			lv = Tool.getUnlockLevel(804)
		end
	elseif self.data.kind == "pet"  then 
		lv = Tool.getUnlockLevel(150)
    elseif self.data.kind == "yuling"  then 
        lv = Tool.getUnlockLevel(27)
	end 
	
    if lv > Player.Info.level or ret then
        self.isLock = true
        self.binding:Show("txt_unlock_lv")
        self.binding:Hide("labState")
		self.lv.gameObject:SetActive(false)
        self.txt_unlock_lv.text = TextMap.getText("TXT_UNLOCK_GUIDAO", { lv })
		self.add:SetActive(false)
		self.red_point:SetActive(false)
	else 
		self.lv.gameObject:SetActive(true)
    end
end

return m