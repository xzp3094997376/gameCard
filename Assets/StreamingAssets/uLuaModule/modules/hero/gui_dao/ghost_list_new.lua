--
-- Created by IntelliJ IDEA.
-- User: xiyou
-- Date: 2015/1/23
-- Time: 14:23
-- To change this template use File | Settings | File Templates.
-- 鬼道列表
local m = {}
local ghostTypeToNumber = {
    po = 1,
    hui = 2,
    fu = 3,
    jie = 4
}
local types = { "po", "hui", "fu", "jie" }

local CONST_QIANGHUA = 1
local CONST_JINGLIAN = 2
local CONST_DAMO = 3
local CONST_SHENGXING = 4

function m:update(lua)
    if lua then
        self.curSelectType = lua[1] or 1
		if lua[2] then 
			self.ghost = lua[2]
		end
        --if lua[2] then
        --    for i = 1, #self.curType do
        --        self.curType[i] = false
        --    end
        --    local tp = ghostTypeToNumber[lua[2]]
        --    self.curType[tp] = true
        --end
    end
    m:SetStarInfo()
    local gd = Player.Ghost:getLuaTable()
    --print(Player.Ghost:getCount())
    --if Player.Ghost:getCount() == 0 then
        --self.curSelectType = 2
        m:updateState()
        --m:refresh(false, nil, true)
    --end
	self:updateBtnState()
	m:onUpdate()
    m:judgeISCanShengxing(self.ghost)
    if Player.Ghost[self.ghost.key].star == self.equipMaxStar then
        self.btn_Shengxing_gray.gameObject:SetActive(true)
        self.btn_Shengxing_down.gameObject:SetActive(false)
    end
end

function m:judgeISCanShengxing(item)
    if item.key then
        local infoStar = Player.Ghost[item.key]
        local info 
        if infoStar.star then
            if infoStar.star == self.equipMaxStar then
                info = TableReader:TableRowByUniqueKey("ghostaddstar", item.id, infoStar.star)
            else
                info = TableReader:TableRowByUniqueKey("ghostaddstar", item.id, infoStar.star + 1)
            end
            if info ~= nil then
                self.btn_Shengxing_down.isEnabled = true
            else
                self.btn_Shengxing_down.isEnabled = false
            end
        end
    end
end

function m:onUpdate()
	local ghost = self.ghost
	--self.imgIcon:setImage(ghost:getHeadSpriteName(), packTool:getIconByName(ghost:getHeadSpriteName()))
    --self.imgFrame.spriteName = ghost:getFrameNormal()
    if self.curSelectType == CONST_QIANGHUA then
        --m:setInfo(ghost)
		self:onStrong(ghost)
    elseif self.curSelectType == CONST_JINGLIAN then
        --m:setHunLian()
		self:onJinHua(ghost)
	elseif self.curSelectType == CONST_DAMO then
		self:onXiLian(ghost)
    elseif self.curSelectType == CONST_SHENGXING then
        self:onShengXing(ghost)
    end
    m:setGdCount()
	local ret = self.ghost:redPointQianHua() or false
	self.redPoint_qianghua:SetActive(ret)
	local jlret =self.ghost:redPointJingLian() or false
	self.redPoint_jinglian:SetActive(jlret)

    if Player.Info.level < self.shengxingOpenLevel or Player.Ghost[ghost.key].star == 5 then
        self.btn_Shengxing_gray.gameObject:SetActive(true)
    else
        self.btn_Shengxing_gray.gameObject:SetActive(false)
    end
end

function m:updateQianHuaRed()
    local ret = self.ghost:redPointQianHua() or false
    self.redPoint_qianghua:SetActive(ret)
end

function m:updateJingLianRed()
    local jlret =self.ghost:redPointJingLian() or false
    self.redPoint_jinglian:SetActive(jlret)
end

function m:getAttrList(arg)
    local list = {}
    local len = arg.Count
    for i = 0, 3 do
        if i > len - 1 then
            list[i + 1] = 0
        else
            list[i + 1] = arg[i]
        end
    end
    return list
end

function m:setInfo(ghost)
    if ghost == nil then
        --self.binding:Hide("info")
        --self.binding:Hide("hun_lian")
        return
    end
    --self.binding:Show("info")
    --self.binding:Hide("hun_lian")
    local descLeft = ""
    local list = ghost:getDesc(m:getAttrList(ghost.info.xilian))
    table.foreachi(list, function(i, v)
        descLeft = descLeft .. v .. "\n"
    end)
    --self.txt_attr.text = string.sub(descLeft, 1, -2)
    list = ghost:getPowerUpList()
    local str = ""
    local right = ""
    table.foreach(list, function(i, v)
        if v.power > ghost.power then
            --未激活
            str = str .. v.name .. "\n"
            right = right ..string.gsub(TextMap.GetValue("LocalKey_706"),"{0}",v.power)
        else
            str = str .. v.name .. "\n"
            right = right .. TextMap.GetValue("Text1112")
        end
    end)

    --self.txt_attr_power.text = string.sub(str, 1, -2)
    --self.txt_attr_power_right.text = string.sub(right, 1, -2)
    --if ghost.hasWear == 1 then
    --    self.binding:Show("btdown")
    --    self.binding:Hide("btn_wear")
    --else
    --    self.binding:Hide("btdown")
    --    self.binding:Show("btn_wear")
    --end
end


function m:setHunLian()
    --self.binding:Hide("info")
    --self.binding:Show("hun_lian")
    if self.ghost == nil then return end
    local ghost = self.ghost
    self.hun_lian:CallUpdateWithArgs(self, ghost)
end

local function isUsed(list, key)
    return list[key .. ""] ~= nil
end

function sortGhost(list)
    return table.sort(list, function(a, b)
        if a.hasWear ~= nil and b.hasWear ~= nil and a.hasWear ~= b.hasWear then
            return a.hasWear > b.hasWear
        elseif a.cost_full ~= nil and b.cost_full ~= nil and a.cost_full ~= b.cost_full then
            return a.cost_full > b.cost_full
        elseif a.star ~= b.star then
            return a.star > b.star
        elseif a.lv ~= b.lv then
            return a.lv > b.lv
        elseif a.power ~= b.power then
            return a.power > b.power
        elseif a.id ~= b.id then
            return a.id > b.id
        end
    end, function(a, b)
    end)
end

function m:getHasUseGhost()
    local ghostSlot = Player.ghostSlot
    local list = {}
    for i = 0, 5 do
        local slot = ghostSlot[i]
        local postion = slot.postion
        local len = postion.Count
        for j = 0, len - 1 do
            local pos = postion[j]
            if pos ~= nil and pos ~= "" and pos ~= 0 then
                list[pos .. ""] = slot.charid
            end
        end
    end
    return list
end

function m:checkCost(ghost)
    return ghost:isKeHeCheng()
end

function m:getHunLianList()
    if self._tables == nil then
        local po = {}
        local hui = {}
        local fu = {}
        local jie = {}
        TableReader:ForEachLuaTable("ghost", function(index, it)
            local kind = it.kind
            local item = Ghost:new(it.id)
            if kind == "po" then
                table.insert(po, item)
            elseif kind == "hui" then
                table.insert(hui, item)
            elseif kind == "fu" then
                table.insert(fu, item)
            elseif kind == "jie" then
                table.insert(jie, item)
            end
            return false
        end)
        self._tables = { po, hui, fu, jie }
    end

    for i = 1, #self._tables do
        local it = self._tables[i]
        for j = 1, #it do
            if m:checkCost(it[j]) then
                it[j].cost_full = 1
            else
                it[j].cost_full = 0
            end
        end
    end

    return self._tables
end

function m:getGhostListByType(ghostList)
    local list = {}
    for i = 1, #ghostList do
        if self.curType[i] == true then
            local li = ghostList[i]
            for j = 1, #li do
                table.insert(list, li[j])
            end
        end
    end
    return list
end

function m:getHunLianListByType(hunLian)
    local list = {}
    for i = 1, #hunLian do
        if self.curType[i] == true then
            local li = hunLian[i]
            for j = 1, #li do
                local it = li[j]
                if it.star < 5 then
                    table.insert(list, it)
                else
                    if Player.GhostPieceBagIndex[it.id].count > 0 then
                        table.insert(list, it)
                    end
                end
            end
        end
    end
    return list
end

function m:getIndexById(list, id)
	if id ~= nil then 
		for i = 1, #list do
			if list[i].key == id then 
				return i - 1
			end
		end
	end
	return -1
end

function m:refresh(ret, check, isGotoIndex)
    if self.curSelectType == 1 then
        local ghostList = self.ghostList
        if ghostList == nil then
            ghostList = m:showGhostList()
            self.ghostList = ghostList
        end
        local list = m:getGhostListByType(ghostList)
        sortGhost(list)
		local index = self:getIndexById(list, self.id)
		if index ~= -1 then self.selectIndex = index end
        if check then
            if #list == 0 then return true end
        end
		if isGotoIndex == true then 
			self.hero_list_bg:refresh(list, self, ret or false, self.selectIndex)
		else
			self.hero_list_bg:refresh(list, self, ret or false)
		end
        m:onUpdate(list[self.selectIndex + 1])
        --self.binding:CallManyFrame(function()
        --    self.red_point:SetActive(Tool.checkRedPoint("guidao_hecheng"))
        --end, 10)
    else
        --self.red_point:SetActive(false)
        local hunlianList = self.hunlianList
        if self.hunlianList == nil then
            hunlianList = m:getHunLianList()
            self.hunlianList = hunlianList
        end
        local list = m:getHunLianListByType(hunlianList)
        sortGhost(list)
        if hero_list_bg ~= nil then
            if isGotoIndex == true then 
                self.hero_list_bg:refresh(list, self, true, self.selectIndex)
            else 
                self.hero_list_bg:refresh(list, self, true)
            end 
        end
        m:onUpdate(list[self.selectIndex + 1])
    end
    --self.node_guidao:SetActive(self.curSelectType == 1)
    --self.node_formation:SetActive(self.curSelectType == 2)
end

function m:onEnter()
    if self._exit == true then
        --LuaMain:showTopMenu(1)
        m:refresh(true)
        self._exit = false
    end
end



function m:onExit()
    self._exit = true
end

function m:getCharInTeam(id)
    local teams = Player.Team[0].chars
    for i = 0, 5 do
        if teams.Count > i then
            if tonumber(teams[i]) == tonumber(id) then return i end
        end
    end
    return 0
end

function m:findHeroIndex(key)
    local ghostSlot = Player.ghostSlot
    for i = 0, 5 do
        local slot = ghostSlot[i]
        local id = slot.charid
        local postion = slot.postion
        local len = postion.Count
        for j = 0, len - 1 do
            local pos = postion[j]
            if pos == key then
                return m:getCharInTeam(id)
            end
        end
    end
end

function m:findGhostPos(ghost)
    local key = ghost.key
    local ghostSlot = Player.ghostSlot
    for i = 0, 5 do
        local slot = ghostSlot[i]
        local postion = slot.postion
        local len = postion.Count
        for j = 0, len - 1 do
            local pos = postion[j]
            if tonumber(pos) == tonumber(key) then
                return i
            end
        end
    end
end

function m:findEquipIndex(ghost)
    local kind = ghost.kind
    return ghostTypeToNumber[kind] - 1
end

--卸下
function m:onDown()
    local data = self.ghost
    if data.hasWear == 0 then return end
    local equipKey, pos, ePos = data.key, m:findGhostPos(data), m:findEquipIndex(data)
    local that = self
    Api:gd_equipDown(equipKey, pos, ePos, function(result)
        Tool.resetUnUseGhost()
        data.hasWear = nil
        that.binding:Hide("btdown")
        that.binding:Show("btn_wear")
        Events.Brocast('updateChar', data)
    end)
end

function m:onPeiYang()
    local data = self.ghost
    Tool.push("ghost_info", "Prefabs/moduleFabs/guidao/guidaoInfo", { charIndex = m:getCharInTeam(data.key), equipIndex = m:findEquipIndex(data), data = data })
end

function m:onChange()
    self.selectIndex = 0
    if self.curSelectType == 1 then
        self.curSelectType = 2
        local m = UIMrg:GetRunningModule()
        if m then
            --m:showTopMenu({ title = "guidao_hunlian" })
        end
    elseif self.curSelectType == 2 then
        self.curSelectType = 1
        local m = UIMrg:GetRunningModule()
        if m then
            --m:showTopMenu({ title = "guidao" })
        end
    end
    local ret = m:refresh(true, true)
    if ret == true then
        self.curType = { true, true, true, true }
        m:updateState()
        m:refresh(true)
    end
end

function m:updateState()
    --self.selected_po:SetActive(self.curType[1])
    --self.selected_hui:SetActive(self.curType[2])
    --self.selected_fu:SetActive(self.curType[3])
    --self.selected_jie:SetActive(self.curType[4])
end

function m:updateBtnState()
	if self.curSelectType == CONST_QIANGHUA then 
		self.imgQianghuaUp:SetActive(true)
		self.imgJinglianUp:SetActive(false)
		self.imgDamoUp:SetActive(false)
        self.imgShengxingUp:SetActive(false)
        --self.btn_Shengxing_gray.gameObject:SetActive(false)
        self.btn_Shengxing_down.gameObject:SetActive(true)
	elseif self.curSelectType == CONST_JINGLIAN then
		self.imgQianghuaUp:SetActive(false)
		self.imgJinglianUp:SetActive(true)
		self.imgDamoUp:SetActive(false)
        self.imgShengxingUp:SetActive(false)
        --self.btn_Shengxing_gray.gameObject:SetActive(false)
        self.btn_Shengxing_down.gameObject:SetActive(true)
	elseif self.curSelectType == CONST_DAMO then
		self.imgQianghuaUp:SetActive(false)
		self.imgJinglianUp:SetActive(false)
		self.imgDamoUp:SetActive(true)
        self.imgShengxingUp:SetActive(false)
        --self.btn_Shengxing_gray.gameObject:SetActive(false)
        self.btn_Shengxing_down.gameObject:SetActive(true)
    elseif self.curSelectType == CONST_SHENGXING then
    --升星
        self.imgQianghuaUp:SetActive(false)
        self.imgJinglianUp:SetActive(false)
        self.imgDamoUp:SetActive(false)
        self.imgShengxingUp.gameObject:SetActive(true)
        self.btn_Shengxing_gray.gameObject:SetActive(false)
        self.btn_Shengxing_down.gameObject:SetActive(false)
	end
end

function m:setGdCount()
    -- self.txt_gd_count.text = Player.Ghost:getCount()
    -- self.txt_gd_count_2.text = Player.Ghost:getCount()
end

function m:isOne(tp)
    local count = 0
    for i = 1, #self.curType do
        if self.curType[i] == true then
            count = count + 1
        end
    end
    return count == 1 and self.curType[tp] == true
end

function m:updateType(tp)
    if m:isOne(tp) then
        return
    end
    self.selectIndex = 0
    self.curType[tp] = not self.curType[tp]
    m:updateState()
    local ret = m:refresh(true, true)
    if ret == true then
        local txt = ""
        local len = #self.curType
        local obj = {}
        for i = 1, len do
            if self.curType[i] == true then
                table.insert(obj, TextMap.getText(types[i], {}))
            end
        end
        len = #obj
        for i = 1, len do
            if i < len then
                txt = txt .. obj[i] .. "、"
            else
                txt = txt .. obj[i]
            end
        end
        local desc = string.gsub(TextMap.GetValue("Text113"),"{0}",Tool.green .. txt .. "[-]")
        local that = self
        DialogMrg.ShowDialog(desc, function()
            that.curSelectType = 2
            m:refresh(true)
        end, function()
            that.curType[tp] = not self.curType[tp]
            m:updateState()
        end)
    end
end

function m:SetStarInfo()
    self.equipMaxStar = 0
    for i = 1, 5 do
        if TableReader:TableRowByUniqueKey("ghostaddstar", self.ghost.id, i) ~= nil then
            self.equipMaxStar = i
        end
    end
end

function m:judgeBtnStateSx()
    if Player.Ghost[self.ghost.key].star == self.equipMaxStar then
        self.btn_Shengxing_gray.gameObject:SetActive(true)
        self.btn_Shengxing_down.gameObject:SetActive(false)
    end
end

function m:onClick(go, name)
	if self._lock == true then return end
	if name == "btn_qianghua_down" then 
		self.curSelectType = CONST_QIANGHUA
		self:updateBtnState()
		self:onStrong(self.ghost)
        self:judgeBtnStateSx()
	elseif name == "btn_jinglian_down" then 
		self.curSelectType = CONST_JINGLIAN
		self:updateBtnState()
		self:onJinHua(self.ghost)
        self:judgeBtnStateSx()
	elseif name == "btn_damo_down" then 
		self.curSelectType = CONST_DAMO
		self:updateBtnState()
		self:onXiLian(self.ghost)
    elseif name == "btn_Shengxing_down" or name == "btn_Shengxing_gray" then
        if self.ghost.star < 5 then
            MessageMrg.show(TextMap.GetValue("Text_1_915"))
            return
        end

        if Player.Info.level < self.shengxingOpenLevel then
            MessageMrg.show(TextMap.GetValue("Text_1_912") .. self.shengxingOpenLevel .. TextMap.GetValue("Text_1_817"))
            return
        end
        
        if Player.Ghost[self.ghost.key].star == self.equipMaxStar then
            MessageMrg.show(TextMap.GetValue("Text_1_916"))
            return
        end
        self.curSelectType = CONST_SHENGXING
        self:updateBtnState()
        self:onShengXing(self.ghost)
	elseif name == "btnBack" then 
		UIMrg:pop()
	end
end

function m:setLock(ret)
    self._lock = ret
end

--升星
function m:onShengXing(item)
    self.binding:Hide("strong")
    self.binding:Hide("xilian")
    self.binding:Hide("jinhua")
    self.binding:Show("shengxing")
    self.shengxing:CallUpdate({ charIndex = m:getCharInTeam(item.key), equipIndex = m:findEquipIndex(item), data = item, delegate = self })
end

function m:onStrong(item)
    -- if Player.Info.level < self.strongOpenLevel then
    --     MessageMrg.show("战队等级达到" .. self.strongOpenLevel .. TextMap.GetValue("Text_1_817"))
    --     return
    -- end
    --self.curSelectType = 2
    --m:setCheckState()
    --self.view:SetActive(false)
    self.binding:Show("strong")
    --self.binding:Hide("info")
    self.binding:Hide("xilian")
    self.binding:Hide("jinhua")
    self.binding:Hide("shengxing")
    self.strong:CallUpdate({ charIndex = m:getCharInTeam(item.key), equipIndex = m:findEquipIndex(item), data = item, delegate = self })
end


function m:onXiLian(item)
    -- if Player.Info.level < self.xilianOpenLevel then
    --     MessageMrg.show("战队等级达到" .. self.xilianOpenLevel .. TextMap.GetValue("Text_1_817"))
    --     return
    -- end
    --self.curSelectType = 3
    --m:setCheckState()
    --self.view:SetActive(false)
    self.binding:Show("xilian")
    self.binding:Hide("jinhua")
    --self.binding:Hide("info")
    self.binding:Hide("strong")
    self.binding:Hide("shengxing")

    self.xilian:CallUpdate({ charIndex = m:getCharInTeam(item.key), equipIndex = m:findEquipIndex(item), data = item, delegate = self })
end

function m:onJinHua(item)
    -- if Player.Info.level < self.powerUpOpenLevel then
    --     MessageMrg.show("战队等级达到" .. self.powerUpOpenLevel .. TextMap.GetValue("Text_1_817"))
    --     return
    -- end

    --self.curSelectType = 4
    --m:setCheckState()
    --self.view:SetActive(true)
    self.binding:Hide("xilian")
    self.binding:Show("jinhua")
    --self.binding:Hide("info")
    self.binding:Hide("strong")
    self.binding:Hide("shengxing")
    
    self.binding:CallManyFrame(function()
        --m:updateMainAttr()
    end, 1)
    self.jinhua:CallUpdate({ charIndex = m:getCharInTeam(item.key), equipIndex = m:findEquipIndex(item), data = item, delegate = self })
end

function m:OnDestroy()
    Events.RemoveListener('selectedGhost')
end

function m:selectedGhost(ghost)
    --装备鬼道
    local data = self.ghost
    local pos = m:findGhostPos(self.ghost)
    local index = m:findEquipIndex(ghost)
    local that = self
    Api:gd_equipOn(ghost.key, pos, index, function(result)
        MusicManager.playByID(50)
        Tool.resetUnUseGhost()
        that.ghostList = nil
        -- Events.Brocast('updateChar')
        m:refresh(true)
        Events.Brocast('updateLeft', that.ghost, true)
        m:onExit()
        UIMrg:popWindow()
    end, function(ret)
        return false
    end)
end

function m:Start()
    Tool.loadTopTitle(self.gameObject, TextMap.GetValue("Text_1_329"))
    LuaMain:ShowTopMenu(1)
    self.curType = { true, true, true, true }
    self.curSelectType = CONST_QIANGHUA
	m:setLock(false)
	-- local row = Tool.readSuperLinkById(238)
 --    local unlock = row.unlock[0]
 --    if unlock == nil then return end
 --    self.xilianOpenLevel = unlock.arg
    row = Tool.readSuperLinkById(239)
    local unlock = row.unlock[0]
    if unlock == nil then return end
    self.powerUpOpenLevel = unlock.arg

    row = Tool.readSuperLinkById( 237)
    local unlock = row.unlock[0]
    if unlock == nil then return end
    self.strongOpenLevel = unlock.arg

    row = Tool.readSuperLinkById( 242)
    local unlock = row.unlock[0]
    if unlock == nil then return end
    self.shengxingOpenLevel = unlock.arg
	
    self.selectIndex = 0
    self.max_slot = Player.Resource.max_slot
    if self.max_slot > 6 then self.max_slot = 6 end
    Events.AddListener("selectedGhost", funcs.handler(self, m.selectedGhost))
    --m:updateState()
    --m:refresh()
end

return m

