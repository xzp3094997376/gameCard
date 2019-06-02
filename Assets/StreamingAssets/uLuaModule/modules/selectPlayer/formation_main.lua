--
-- 阵容

local m = {}
local tm

function m:update(arg)
    --    if arg == nil then arg = { 0 } end
    local team = 0
    if type(team) == "number" then
        self.teamIndex = 0
        self.teamTable = TableReader:TableRowByUnique("teamid", "teamid", self.teamIndex)
        self.temaType = self.teamTable.type
    else
        self.temaType = 0
        self.teamTable = TableReader:TableRowByUnique("teamid", "type", self.temaType)
        self.teamIndex = self.teamTable.teamid
    end
    if arg and arg[2] then
        self.curTab = arg[2]
    end
    self:onUpdate()
end
--[[
function m:updateState(...)
    if self.isShow == true then
        m:showFormation()
    end
    if self.curTab == 2 then
        m:showGuiDao(self.curIndex)
    end
end
]]--

function m:getTable()
    return self.teamTable
end

function m:onUpdate()
    self:playEff()
	self:refreshIcon()
    if self.curTab == 2 then
        self:selectIcon(self.curIndex)
    elseif self.curTab == 3 then
        m:ShowFetter()
    end
end

--获取上阵角色队列
function m:getTeam()
    local teams = Player.Team[self.teamIndex].chars
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

--获取鬼道列表队列
function m:getGuiDaoList()
    local teams = Player.Team[0].chars
    if teams == nil then
        print("getGuiDaoList -> the list is nil ")
    end
    local list = {}
    for i = 0, 5 do
        if teams.Count > i then
            list[i + 1] = teams[i]
        else
            list[i + 1] = 0
        end
    end
    return list
end

--获取小伙伴队列
function m:getXiaoHuoBanTeam(...)
    local teams = Player.Team[12].chars
    local list = {}
    for i = 0, 7 do
        if teams.Count > i then
            list[i + 1] = teams[i]
        else
            list[i + 1] = 0
        end
    end
    return list
end

function m:hasHeTi(teams, char, isCustom)
	if char == nil then return false end 
	local start = 0
	local eEnd = 5
	if isCustom ~= nil and isCustom == true then 
		start = 1
		eEnd = 6
	end 
	if self.hetiHeros == nil then 
		self.hetiHeros = {}
		TableReader:ForEachLuaTable("skilltie", function(k, v)
			if self.hetiHeros[v.heroid] == nil then 
				self.hetiHeros[v.heroid] = v.ties 
			end 
		end)
	end 
	
	if self.hetiHeros[char.dictid] ~= nil then 
		-- 如果有配置合体技， 查询是否有配合者
		local peiHeArr = self.hetiHeros[char.dictid]
		for i = start, eEnd do
			if teams[i] ~= 0 and teams[i] ~= "0" and teams[i] ~= char.id then
				local dictid = Tool.getDictId(teams[i])
				for i = 0, peiHeArr.Count - 1 do 
					-- 查询配合者
					if dictid == peiHeArr[i] then 
						return true
					end 
				end 
			end
		end
	else 
		-- 自己没有配置发动合体技， 查询是否需要配合
		for i = start, eEnd do
			if teams[i] ~= 0 and teams[i] ~= "0" and teams[i] ~= char.id then
				local dictid = Tool.getDictId(teams[i])
				if self.hetiHeros[dictid] ~= nil then 
					local arr = self.hetiHeros[dictid]
					-- 查询配合列表是否有自己
					for i = 0, arr.Count - 1 do 
						if char.dictid == arr[i] then 
							return true 
						end 
					end 
				end 
			end
		end
	end 
	
	return false
end 

function m:onEnter()
    if self._onExit == true then
        self._onExit = false
        self:onUpdate()
		if self.guidao ~= nil then 
			self.guidao:CallTargetFunction("updateGhost")
			self.guidao:CallTargetFunction("updatePet")
		end 
    end
	LuaMain:ShowTopMenu()
	--if not self.topMenu.gameObject.activeInHierarchy then 
	--	self.topMenu.gameObject:SetActive(true)
	--	self.topMenu:CallTargetFunction("onUpdate",true)
	--end 
end

function m:onExit()
    self._onExit = true
    self.guidao:CallTargetFunction("exit")
end

--检查上阵角色是否已满
function m:isFull()
    return self.hasEnterCount >= self.max_slot
end

--检查上阵小伙伴是否已满
function m:CheckFull()
    return self.friend_count >= self.max_count
end

--获取上阵角色信息
function m:getTeamInfo()
    local teams = Player.Team[self.teamIndex].chars
    local lingya = 0
    local charList = {}
    local hasEnterCount = 0
    for i = 0, 5 do
        local char = {}
        char.index = i + 1
        if teams.Count > i then
            if teams[i .. ""] ~= 0 and teams[i .. ""] ~= "0" then --可以添加一个从服务器端传过来的死亡状态，如果死亡则不上阵
			local last_char = Char:new(teams[i .. ""])
            lingya = lingya + last_char.power
            char.char = last_char
            hasEnterCount = hasEnterCount + 1
            end
        end
        table.insert(charList, char)
    end
    self.hasEnterCount = hasEnterCount
    self.txt_power.text =string.gsub(TextMap.GetValue("Text72"),"{0}",lingya)
    return charList
end

--获取鬼道角色信息(布阵阵位)
function m:getGuiDaoInfo(type)
    local teams = nil
	if type == nil then teams = Player.Team[0].chars
	else teams = Player.Team[0].list end 
	
    local charList = {}
	self.guidaoTeam = {}
    for i = 0, 5 do
        local char = {}
        char.index = i + 1
        if teams.Count > i then
            if teams[i .. ""] ~= 0 and teams[i .. ""] ~= "0" then --可以添加一个从服务器端传过来的死亡状态，如果死亡则不上阵
            local last_char = Char:new(teams[i .. ""])
            char.char = last_char
            end
        end
		table.insert(self.guidaoTeam, teams[i .. ""])
        table.insert(charList, char)
    end
    return charList
end

--小伙伴 
function m:getXiaoHuoBan(...)
    local teams = Player.Team[12].chars
    local charList = {}
    local hasEnterCount = 0
    for i = 0, 7 do
        local char = {}
        char.index = i + 1
        if teams.Count > i then
            if teams[i .. ""] ~= 0 and teams[i .. ""] ~= "0" then --可以添加一个从服务器端传过来的死亡状态，如果死亡则不上阵
			local last_char = Char:new(teams[i .. ""])
            char.char = last_char
            hasEnterCount = hasEnterCount + 1
            end
        end
        table.insert(charList, char)
    end
    self.friend_count = hasEnterCount

    local lv = Player.Info.level
    local max_count = 0
    for i = 1, 8 do
        if lv >= self.levelList[i] then
            max_count = max_count + 1
        end
    end
    self.max_count = max_count

    --设置小伙伴小红点
    if self.max_count > self.friend_count then
        self.redPoint_for_friend:SetActive(true)
    else
        self.redPoint_for_friend:SetActive(false)
    end

    return charList
end

--加载模型
function m:loadTeamModel(team)
    table.foreach(team, function(i, v)
        local node = self["modelParent" .. i]
        if v ~= "0" and v ~= 0 then
            self.binding:LoadModel(v, node, "stand", function(t, ctl)
                ctl.transform.eulerAngles = Vector3(0, 0, 0)
            end)
        else
            ClientTool.HideAllChildren(node)
        end
    end)
end

function m:checkRedPoint(...)
    --for i = 1, 6 do
    --    self["formation_pos" .. i]:CallTargetFunction("checkRedPoint")
    --end
	m:checkHeroRedPoint()
end

--设置布阵列表是否可以拖拽
function m:canDrop(ret)
    for i = 1, 6 do
        self["formation_pos" .. i]:CallTargetFunction("isCanDrop", ret)
    end
end

--布阵
function m:showFormation(...)
    --self.formation:SetActive(true)
	LuaMain:showFormation(self.teamIndex)
    --m:canDrop(true)
    -- self.txt_drap.text = TextMap.getText("TXT_ZHENRONG_BUZHEN",{})
end

function m:findIndex(char)
    local ghostSlot = Player.ghostSlot
    -- local ghostSlot = Player.Team[0].chars
    for i = 0, 5 do
        local slot = ghostSlot[i]
        local id = slot.charid
        if tostring(id) == tostring(char.id) then
            return i
        end
    end
end

--鬼道
function m:showPet(index)
    local p = Player.Team[0].pet
	if p == nil or p == 0 then return end 
	local pet = Pet:new(p)
	
    if self.teamerOption ~= nil then
        self.teamerOption.gameObject:SetActive(false)
    end
	if self.guidao ~= nil then 
		self.guidao.gameObject:SetActive(false)
	end 
	
    if self.petUI == nil then
        self.binding:CallManyFrame(function() --加载鬼道界面
        local that = self
        self.petUI = ClientTool.loadAndGetLuaBinding("Prefabs/moduleFabs/formationModule/formation/formation_pet_info", self.con)
        -- self.guidao:CallUpdate({delegate = that })
        self.petUI.transform.localPosition = Vector3(0, 0, 0)
        self.petUI.gameObject:SetActive(true)
        self.petUI:CallUpdate({ delegate = self, pet = pet, index = self.ghostIndex })
        end, 2)
    else
        self.petUI.gameObject:SetActive(true)
        self.petUI:CallUpdate({ delegate = self, pet = pet, index = self.ghostIndex })
    end
end

--鬼道
function m:showGuiDao(index)
    self.curIndex = index
    self.teamInfo = self:getGuiDaoInfo(1)
    local team = self.teamInfo[index]
    local char = nil
    if team.char then char = team.char end
    if char == nil then
        char = { empty = true }
    end
    self.selectGuidaoChar = char
    self.ghostIndex = m:findIndex(char) or (index - 1)
    if self.teamerOption ~= nil then
        self.teamerOption.gameObject:SetActive(false)
    end
	if self.petUI ~= nil then 
		self.petUI.gameObject:SetActive(false)
	end 
	
    if self.guidao == nil then
        self.binding:CallManyFrame(function() --加载鬼道界面
        local that = self
        self.guidao = ClientTool.loadAndGetLuaBinding("Prefabs/moduleFabs/formationModule/formation/formation_guidao", self.con)
        -- self.guidao:CallUpdate({delegate = that })
        self.guidao.transform.localPosition = Vector3(0, 0, 0)
        self.guidao.gameObject:SetActive(true)
        self.guidao:CallUpdate({ delegate = self, char = char, index = self.ghostIndex })
        end, 2)
    else
        self.guidao.gameObject:SetActive(true)
        self.guidao:CallUpdate({ delegate = self, char = char, index = self.ghostIndex })
    end
    -- self.guidao.gameObject:SetActive(true)
    -- self.guidao:CallUpdate({delegate = self,char = char,index = self.ghostIndex})
    -- m:canDrop(false)
    -- self.txt_drap.text = TextMap.getText("TXT_ZHENRONG_GUIDAO",{})
end

--羁绊
function m:ShowFetter()
    self.guidao.gameObject:SetActive(false)
	if self.petUI then 
		self.petUI.gameObject:SetActive(false)
	end
    local that = self
    self.teamerOption:CallUpdate({ delegate = that })
    self.teamerOption.gameObject:SetActive(true)
    self.teamerOption:CallTargetFunction("resetTable")
end

--按钮事件
function m:onClick(go, name)
    if name == "btn_buzhen" then --布阵
		self:showFormation()
		--self.isShow = true
    elseif name == "btn_teamer" then --队友（羁绊）
		m:selectIcon(8)
	elseif name == "btnBack" then 
		UIMrg:pop()
    elseif name == "btn_close" then
        --self.formation:SetActive(false)
        --self.isShow = false
	elseif name == "btn_up" then 
		self.scroll:Scroll(-1)
	elseif name == "btn_down" then 
		self.scroll:Scroll(1)
    end
end


function m:getTeamType()
    return self.temaType
end

function m:findFormationIndex(char)
    local team = self:getTeam()
    for i = 1, 6 do
        if tonumber(char.id) == tonumber(team[i]) then
            return i
        end
    end

    for i = 1, 6 do
        if team[i] == 0 then
            return i
        end
    end
end

function m:checkHeroRedPoint()
	self.binding:CallManyFrame(function()
		for i = 1, 7 do
			self["icon_" .. i]:CallTargetFunction("checkRedPoint")
		end
	end, 2)
end 

function m:onCallBack(char, tp)
    if tp == "ghost" then --改成saveTeam接口(鬼道面板上阵角色)
        local index = self:findFormationIndex(self.selectGuidaoChar)
        local team = self:getTeam()
        if self.guidao_index ~= nil then
            local char = nil
            char = { empty = true }
            index = self:findFormationIndex(char)
            self.curIndex = self.team_count + 1
            self.guidao_index = self.team_count + 1
        end
        team[index] = char.id
        Api:saveTeam(team, m:getTeamType(), function(result)
            UIMrg:popWindow()
            if self.guidao_index ~= nil then
                self["icon_" .. self.guidao_index]:CallTargetFunction("setFlag", false)
                self.guidao_index = nil
            end
            m:onUpdate()
            end, function()
            return false
            end)
		--m:checkHeroRedPoint()
	elseif tp == "pet" then 
        Api:petOnTeam(char.id, function(result)
            UIMrg:popWindow()
            if self.guidao_index ~= nil then
                self["icon_" .. self.guidao_index]:CallTargetFunction("setFlag", false)
                self.guidao_index = nil
            end
            m:onUpdate()
            end, function()
            return false
            end)
    elseif tp == "formation" then
        local index = self.index
        local team = m:getTeam()
        team[index + 1] = char.id
        Api:saveTeam(team, m:getTeamType(), function(result)
            UIMrg:popWindow()
            --self.formation:SetActive(true)
            m:onUpdate()
        end, function()
            return false
        end)
    elseif tp == "teamer" then
        local index = self.index
        local team = m:getXiaoHuoBanTeam()
        if char==nil then 
            team[index + 1]=0
        else 
            team[index + 1] = char.id
        end
        Api:saveTeam(team, "audience", function(result)
            UIMrg:popWindow()
            m:onUpdate()
			print("guiyi!~~~~~~~~~~~" .. tostring(result))
        end, function()
            return false
        end)
        UIMrg:popWindow()
    elseif tp == "treasure" then
        self:playEff()
		m:checkHeroRedPoint()
    end
end

--选中某个上阵英雄
function m:selectIcon(index)
	if index == 7 then 
		local lv = TableReader:TableRowByID("playerArgs", "pet_slot").value
		if Player.Info.level < lv then 
			MessageMrg.show(string.gsub(TextMap.GetValue("Text111"),"{0}",lv))
			return
		end 
	end 
    if index ~= 7 and index ~= 8 and index > self.max_slot then
        local lv = TableReader:TableRowByID("playerArgs", "slot" .. index).value
        MessageMrg.show(string.gsub(TextMap.GetValue("Text111"),"{0}",lv))
        return
    end
    if index < 7 then
        local isEmpty = self["icon_" .. index]:CallTargetFunction("getFlag")
        if isEmpty == true then --阵位无角色
            local allRole = self:getAllRole()
            if #allRole > 0 then --有角色可上阵
                local bind = UIMrg:pushWindow("Prefabs/moduleFabs/formationModule/formation/formation_select_char")
                bind:CallUpdate({ type = "char", module = "ghost", delegate = self, index = index })
                self.guidao_index = index
                return
            else --无角色可上阵
            -- if #charsList == 0 then
                DialogMrg.ShowDialog(TextMap.GetValue("Text1388"), function()
                    uSuperLink.openModule(1)
                end, function() end, TextMap.GetValue("Text1136"), "openModule")
                return
            end
        end
	elseif index == 7 then 
		local isEmpty = self["icon_" .. index]:CallTargetFunction("getFlag")
        
        if isEmpty == true then --阵位无角色
			local allPets = self:getAllPet()	
            if #allPets > 0 then --有角色可上阵
                local bind = UIMrg:pushWindow("Prefabs/moduleFabs/formationModule/formation/formation_select_char")
                bind:CallUpdate({ type = "pet", module = "ghost", delegate = self, index = index })
                self.guidao_index = index
                return
            else --无角色可上阵
            -- if #charsList == 0 then
                --DialogMrg.ShowDialog(TextMap.GetValue("Text1388"), function()
                --    uSuperLink.openModule(1)
                --end, function() end, TextMap.GetValue("Text1136"), "openModule")
				--MessageMrg.showMove("没有宠物可上阵！")
				UIMrg:pushWindow("Prefabs/publicPrefabs/gui_get_help", {type = "pet"})
                return
            end
        end
    end

    for i = 1, 7 do
        if self["icon_" .. i] ~= nil then
            if i == index then
                self["icon_" .. i]:CallTargetFunction("setSelectState", true)
                self.curTab = 2
                self.curIndex = i
				if i < 7 then 
					self:showGuiDao(i)
				else 
					m:showPet(7)
				end 
                -- local isEmpty = self["icon_"..i]:CallTargetFunction("getFlag")
            else
                self["icon_" .. i]:CallTargetFunction("setSelectState", false)
            end
        end
    end

    if index == 8 then
        self.select:SetActive(true)
        self.curTab = 3
        self:ShowFetter()
    else
        self.select:SetActive(false)
    end
end

function m:petIsOnTeam()
	local ret = false 
	if Player.Team[0].pet ~= nil and tostring(Player.Team[0].pet) ~= "0" then 
		ret = true 
	end 
	return ret
end 

--刷新鬼道列表
function m:refreshIcon()
    local teamInfo = m:getGuiDaoInfo(1)
    for i = 1, 7 do
        local that = self
		if i < 7 then 
			if self["icon_" .. i] ~= nil then
				local index = i
				local char = nil
				char = teamInfo[i]
				self["icon_" .. i]:CallUpdate({ type = "char", index = tonumber(i), delegate = that, data = char })
			end
		else
			local pet = {}
			pet.index = i
			if self["icon_" .. i] ~= nil then
				if Player.Team[0].pet ~= nil and tostring(Player.Team[0].pet) ~= "0" then 
					pet.char = Pet:new(Player.Team[0].pet)
				end
				self["icon_" .. i]:CallUpdate({ type = "pet", index = tonumber(i), delegate = that, data = pet })				
			end	
		end
    end
end

--获取某个角色已激活的羁绊id列表
function m:getFetter(id)
    if id == nil then return end
    local fetters = Player.Chars[id].tie:getLuaTable()
    local tb = {}
    table.foreach(fetters, function(i, v)
        if v ~= nil then
            table.insert(tb, v)
        end
    end)
    --local fetter = {}
    --table.foreach(tb, function(i, v)
    --    if v >= 100 then
    --        local skillid = Player.Chars[id].skill[v].skill_id
    --        if skillid ~= 0 or skillid ~= "0" then
    --            table.insert(fetter, skillid)
    --        end
    --    end
    --end)
    return tb
end

--播放飘字效果
function m:playEff()
    local list = m:checkNewFetter()
    local decs = {}
    if list ~= {} and list ~= nil then
        table.foreach(list, function(i, v)
            local line = TableReader:TableRowByID("relationship", v.id)
            local text =string.gsub(TextMap.GetValue("LocalKey_749"),"{0}",v.name)
            text=string.gsub(text,"{1}",line.show_name)
            table.insert(decs, text)
        end)
		if #decs > 0 then 
			if self.binding.gameObject.activeInHierarchy then 
				self.binding:CallManyFrame(function()
					OperateAlert.getInstance:showToGameObject(decs, self.effObj)
				end)
			else 
				local that = self
				tm = LuaTimer.Add(0, 2000, function()
					that.binding:CallManyFrame(function()
						OperateAlert.getInstance:showToGameObject(decs, that.effObj)
						LuaTimer.Delete(tm)
						tm = 0
					end)
				end) 
			end 
		end
    end
	self.acheList = m:getAllFetter()
end

--返回新激活的羁绊列表
function m:checkNewFetter()
    local tb = {}
    local newList = m:getAllFetter() --self.acheList
    table.foreach(newList, function(i, v)
        if m:checkFetter(v) == false then
            table.insert(tb, v)
        end
    end)
    return tb
end

--检测该羁绊是否已经激活
function m:checkFetter(v)
    local id = v.id
    if id == nil then return end
    for i = 1, #self.acheList do
        if id == self.acheList[i].id then
            if v.name == self.acheList[i].name then
                return true
            end
        end
    end
    
    return false
end

function m:getAllPet()
	local ids = {}
    if self:petIsOnTeam() == true then
        ids[Player.Team[0].pet .. ""] = true
    end

    local function isShow(id)
        if ids[id .. ""] then
            return false
        end
        return true
    end

    local pets = Player.Pets:getLuaTable()
    local petsList = {}
    for k, v in pairs(pets) do
        local pet = Pet:new(k, v)
        if isShow(pet.id) then
           table.insert(petsList, pet)
        end
    end
    return petsList
end

function m:getAllRole()
    local ids = {}
    if self.getTeam then
        local team = self:getTeam()
        for i = 1, #team do
            local id = tonumber(team[i])
            if id ~= nil and id > 0 then
                ids[id .. ""] = true
            end
        end
    end
    if self.getXiaoHuoBanTeam then
        local team = self:getXiaoHuoBanTeam()
        for i = 1, #team do
            local id = tonumber(team[i])
            if id ~= nil and id > 0 then
                ids[id .. ""] = true
            end
        end
    end

    local function isShow(id)
        if ids[id .. ""] then
            return false
        end
        return true
    end

    local chars = Player.Chars:getLuaTable()
    local charsList = {}
    for k, v in pairs(chars) do
        local char = Char:new(k, v)
        if isShow(char.id) then
            if self.onFilter then
                if self:onFilter(char) then
                    table.insert(charsList, char)
                end
            else
                table.insert(charsList, char)
            end
        end
    end
    return charsList
end


function m:onFilter(char)
	if char.id == Player.Info.playercharid then return false end 
	return true
end 

function m:onFilterPet(pet)
	if m:petIsOnTeam(pet.id) == true then return false end 
	return true
end 

function m:petIsOnTeam(petId)
	if Player.Team[0].pet ~= nil and Player.Team[0].pet == petId then  
		return true
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

--获取最新的激活羁绊列表
function m:getAllFetter()
    local team = m:getTeam()
    local fetterList = {}
    for k = 1, 6 do
        if team[k] ~= nil then
			local fetters = Player.Chars[team[k]].tie:getLuaTable()
			local tb = {}
			table.foreach(fetters, function(i, v)
				if v ~= nil then
					table.insert(tb, v)
				end
			end)
            table.foreach(tb, function(i, v)
                local obj = {}
                obj.id = v
                local line = TableReader:TableRowByID("char", Tool.getDictId(team[k]))
				if team[k] == Player.Info.playercharid then 
                obj.name = Player.Info.nickname
				else 
					obj.name = line.show_name
				end 
                table.insert(fetterList, obj)
            end)
        end
    end
    return fetterList
end

function m:OnDestroy()

end

function m:create(binding)
    self.binding = binding
	self.curTab = 2
    self.curIndex = 1
    self.index = 0
    --self.isShow = false
    self.teamIndex = 0
	self.friend_count = 0
	self.acheList = self:getAllFetter()
	
	if self.levelList == nil then 
		self.levelList = {}
		TableReader:ForEachLuaTable("relationship_config", function(index, item) --等级限制列表
		self.levelList[index + 1] = item.arg2
		return false
		end)
	end 
	if self.teamerOption == nil then 
		self.teamerOption = ClientTool.loadAndGetLuaBinding("Prefabs/moduleFabs/formationModule/formation/teamerOption", self.container)
	end
    return self
end

function m:Start()
	Tool.loadTopTitle(self.gameObject, TextMap.GetValue("Text_1_1066"), function()
		UIMrg:pop()
		Events.RemoveListener('select_formation_pos2')
        Tool.updateActivityOpen()
		--Events.RemoveListener('show_hero')
		collectgarbage("collect")
	end)

    self.max_slot = Player.Resource.max_slot
    -- self.max_friend_count = 8 --上阵小伙伴最大个数为8

    --self.formation:SetActive(false)
    if self.max_slot > 6 then self.max_slot = 6 end
	LuaMain:ShowTopMenu()
	--if self.topMenu == nil then 
	--	self.topMenu = LuaMain:ShowTopMenu()
	--else
	--	if not self.topMenu.gameObject.activeInHierarchy then 
	--		self.topMenu.gameObject:SetActive(true)
	--	end 
	--end 
   
    local that = self
    Events.RemoveListener('select_formation_pos2')
    Events.AddListener("select_formation_pos2", function(index, empty)
        if that.isShow == true then --显示未上阵的英雄列表
        if self.max_slot < 6 and empty == true and m:isFull() then
            local max_slot = self.max_slot + 1
            local lv = TableReader:TableRowByID("playerArgs", "slot" .. max_slot).value
            MessageMrg.show(string.gsub(TextMap.GetValue("Text111"),"{0}",lv))
            return
        end

        --self.formation:SetActive(false)
        local bind = UIMrg:pushWindow("Prefabs/moduleFabs/formationModule/formation/formation_select_char")
        bind:CallUpdate({ type = "single", module = "formation", delegate = that, index = index + 1 })
        that.index = index
        -- local info = m:getTeam()
        -- bind:CallUpdate({ teams = info, team_type = m:getTeamType(), index = index, tb = m:getTable() })
        -- m:onExit()
        elseif that.curTab == 2 then
            self.curIndex = index + 1
            m:showGuiDao(index + 1)
        elseif that.curTab == 3 then --显示未上阵的小伙伴列表
        if self.max_count < 8 and empty == true and m:CheckFull() then
            return
        end
        local infos = self:getXiaoHuoBan()
        if infos[index+1].char then 
            local bind = Tool.push("heroInfo", "Prefabs/moduleFabs/hero/hero_info", infos[index+1].char)
            bind:CallTargetFunction("SetTihuanAndXiexiaBtn",true,{type = "single", module = "teamer", delegate = that, index = self.index + 1})
            that.index = index
        else 
            local bind = UIMrg:pushWindow("Prefabs/moduleFabs/formationModule/formation/formation_select_char")
            bind:CallUpdate({ type = "single", module = "teamer", delegate = that, index = self.index + 1 })
            that.index = index
        end

        -- m:onExit()
        end
    end)

    --Events.AddListener("show_hero", function()
        -- self.formation_camera:SetActive(true)
    --end)

    self.binding:CallManyFrame(function() --加载小伙伴界面
		local that = self
		self.teamerOption.transform.localPosition = Vector3(0, 0, 0)
		if self.curTab ~= 3 then 
			self.teamerOption.gameObject:SetActive(false)
		else	
			self.teamerOption:CallUpdate({ delegate = that })
		end 
	end, 5)
end

--[[
function m:Start()
	Tool.loadTopTitle(self.gameObject, TextMap.GetValue("Text_1_1066"))
    self.curTab = 2
    self.curIndex = 1
    self.index = 0
    --self.isShow = false
    self.teamIndex = 0
    self.max_slot = Player.Resource.max_slot
    -- self.max_friend_count = 8 --上阵小伙伴最大个数为8
    self.friend_count = 0
    --self.formation:SetActive(false)
    if self.max_slot > 6 then self.max_slot = 6 end
    self.topMenu = LuaMain:ShowTopMenu()
    self.acheList = self:getAllFetter()
   
    local that = self
    Events.RemoveListener('select_formation_pos2')
    Events.AddListener("select_formation_pos2", function(index, empty)
        if that.isShow == true then --显示未上阵的英雄列表
        if self.max_slot < 6 and empty == true and m:isFull() then
            local max_slot = self.max_slot + 1
            local lv = TableReader:TableRowByID("playerArgs", "slot" .. max_slot).value
            MessageMrg.show(TextMap.getText("TXT_UNLOCK_FORMATION", { lv }))
            return
        end

        --self.formation:SetActive(false)
        local bind = UIMrg:pushWindow("Prefabs/moduleFabs/formationModule/formation/formation_select_char")
        bind:CallUpdate({ type = "single", module = "formation", delegate = that, index = index + 1 })
        that.index = index
        -- local info = m:getTeam()
        -- bind:CallUpdate({ teams = info, team_type = m:getTeamType(), index = index, tb = m:getTable() })
        -- m:onExit()
        elseif that.curTab == 2 then
            self.curIndex = index + 1
            m:showGuiDao(index + 1)
        elseif that.curTab == 3 then --显示未上阵的小伙伴列表
        if self.max_count < 8 and empty == true and m:CheckFull() then
            return
        end
        local infos = self:getXiaoHuoBan()
        if infos[index+1].char then 
            local bind = Tool.push("heroInfo", "Prefabs/moduleFabs/hero/hero_info", infos[index+1].char)
            bind:CallTargetFunction("SetTihuanAndXiexiaBtn",true,{type = "single", module = "teamer", delegate = that, index = self.index + 1})
            that.index = index
        else 
            local bind = UIMrg:pushWindow("Prefabs/moduleFabs/formationModule/formation/formation_select_char")
            bind:CallUpdate({ type = "single", module = "teamer", delegate = that, index = self.index + 1 })
            that.index = index
        end

        -- m:onExit()
        end
    end)

    Events.AddListener("show_hero", function()
        -- self.formation_camera:SetActive(true)
    end)

    self.binding:CallManyFrame(function() --加载小伙伴界面
    local that = self
    if self.teamerOption == nil then 
		self.teamerOption = ClientTool.loadAndGetLuaBinding("Prefabs/moduleFabs/formationModule/formation/teamerOption", self.container)
    end
	self.teamerOption:CallUpdate({ delegate = that })
    self.teamerOption.transform.localPosition = Vector3(0, 0, 0)
    self.teamerOption.gameObject:SetActive(false)
    end, 5)
	if self.levelList == nil then 
		self.levelList = {}
		TableReader:ForEachLuaTable("relationship_config", function(index, item) --等级限制列表
		self.levelList[index + 1] = item.arg2
		return false
		end)
	end 

    self:getXiaoHuoBan()
end
]]--

return m

