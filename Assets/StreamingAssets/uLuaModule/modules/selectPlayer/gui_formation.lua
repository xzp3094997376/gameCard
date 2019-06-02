--
-- 阵容

local m = {}
local tm

function m:update(arg)
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
	
	self.teamIndex = arg.teamIndex or 0
    self:onUpdate()
end

function m:updateState(...)
    if self.isShow == true then
        m:showFormation()
    end
end

function m:getTable()
    return self.teamTable
end

function m:onUpdate()
    self.teamInfo = self:getTeamInfo()
    table.foreach(self.teamInfo, function(i, v)
        self["formation_pos" .. i]:CallUpdate({ data = v, index = i - 1, delegate = self })
        self["formation_pos" .. i].name = i .. ""
    end)

    self:showFormation()
	
	local p = Player.Team[0].pet
	if p ~= nil and p ~= 0 then 
	local pet = Pet:new(p)
		if pet then
		    if self.__itemAll == nil then
				self.__itemAll = ClientTool.loadAndGetLuaBindingFromPool("Prefabs/publicPrefabs/itemAll", self.petbg.gameObject)
			end
			self.__itemAll.gameObject:SetActive(true)
			self.__itemAll:CallUpdate({ "char", pet, 100, 100 })
		end
	end
	if Player.Info.level < 70 then 
		self.btn_replace.gameObject:SetActive(false)
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

function m:changeFormation(old, new)
    local team = {}
    --TODO 
    local tp = self:getTeamType()
    if self.curTab == 3 and self.isShow == false then
        -- Api:..
        team = m:getXiaoHuoBanTeam()
        local temp = team[old]
        team[old] = team[new]
        tp = "audience"
    else
        team = m:getTeam()
        local temp = team[old]
        team[old] = team[new]
        team[new] = temp
    end

    Api:saveTeam(team, tp, function(result)
        self:onUpdate()
    end, function()
        return false
    end)
end

function m:onExit()
    self._onExit = true
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
		if petid ~= nil and petid ~= 0 then 
			local dict = Tool.getPetDictId(petid)
			local dictTarget = Tool.getPetDictId(petId)
			if dict == dictTarget then 
				return true
			end 
		end
	end 
	
	return false
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
    --self.txt_power.text = TextMap.getText("TXT_TEAM_POWER", { lingya })
    return charList
end

function m:checkRedPoint(...)
    for i = 1, 6 do
        self["formation_pos" .. i]:CallTargetFunction("checkRedPoint")
    end
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
    m:canDrop(true)
end

--按钮事件
function m:onClick(go, name)
	if name == "btnClose" then 
		UIMrg:popWindow()
	elseif name == "btn_replace" then
	    local bind = UIMrg:pushWindow("Prefabs/moduleFabs/formationModule/formation/formation_select_char")
        bind:CallUpdate({ type = "pet", module = "ghost", delegate = self, index = 7 })
	end 
end

function m:onCallBack(char, tp)
	if tp == "formation" then
        local index = self.index
        local team = m:getTeam()
        team[index + 1] = char.id
        Api:saveTeam(team, m:getTeamType(), function(result)
            UIMrg:popWindow()
            self.formation:SetActive(true)
            m:onUpdate()
        end, function()
            return false
        end)
	elseif tp == "pet" then 
		 Api:petOnTeam(char.id, function(result)
			m:onUpdate()
         end, function()
         return false
         end)
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

function m:OnDestroy()
    Events.RemoveListener('select_formation_pos')
    Events.RemoveListener('show_hero')
end

function m:Start()
    self.max_slot = Player.Resource.max_slot
    -- self.max_friend_count = 8 --上阵小伙伴最大个数为8
    self.tp = "gui_formation"
    local that = self
    Events.RemoveListener('select_formation_pos')
    Events.AddListener("select_formation_pos", function(index, empty)
        if that.isShow == true then --显示未上阵的英雄列表
			if self.max_slot < 6 and empty == true and m:isFull() then
				local max_slot = self.max_slot + 1
				local lv = TableReader:TableRowByID("playerArgs", "slot" .. max_slot).value
				MessageMrg.show(string.gsub(TextMap.GetValue("Text111"),"{0}",lv))
				return
			end
        end
    end)
end

return m

