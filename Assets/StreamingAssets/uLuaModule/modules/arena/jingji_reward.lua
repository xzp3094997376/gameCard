local m = {}

function m:Start()
	self.type = 1
	--m:refresh()
	self.weeklist = {}
	self.dailylist = {}
	--local tasks = Player.crossArena.challengeReward:getLuaTable()
    TableReader:ForEachLuaTable("crossArenaTask", function(index, item)
		local li = RewardMrg.getProbdropByTable(item.drop)
		local it = {}
		it.row = item
        local _item = li[1]
        it.item = _item
        it.name = _item.name
        it.need = item.need
        it.decs = item.decs
        it.id = item.id
        if item.task_type == "server_daily" then 
			table.insert(self.dailylist, it)
		elseif item.task_type == "server_weekly" then 
			table.insert(self.weeklist, it)
		end 
        m = nil
		return false
	end)
	
	self:refresh()
end

function m:refresh()
	self.txt_num.text = TextMap.GetValue("Text_1_160") .. (Player.crossArena.max_fight - Player.crossArena.has_fight)
	if self.type == 1 then 
		self.cb_week.gameObject:SetActive(false)
		self.cb_week_g.gameObject:SetActive(true)
		self.cb_dialy.gameObject:SetActive(false)
		self.cb_dialy_g.gameObject:SetActive(true)
	else 
		self.cb_week.gameObject:SetActive(true)
		self.cb_week_g.gameObject:SetActive(false)
		self.cb_dialy.gameObject:SetActive(true)
		self.cb_dialy_g.gameObject:SetActive(false)	
	end 
	local list = self:getTaskByType()
    self.binding:CallManyFrame(function()
        self.content:refresh(list, self, true, 0)
    end, 2)
end

function m:getTaskByType()
	local list = {}
	if self.type == 1 then 
		list = self.dailylist 
	elseif self.type == 2 then 
		list = self.weeklist 
	end
	local canList = {}
	for i = 1, #list do 
		if Player.crossArena.challengeReward[list[i].id] == list[i].id then 
			list[i].state = 1
		else 
			list[i].state = 0
		end 
	end 
	table.sort(list, function(a, b)
		if a.state == b.state then 
			return a.id < b.id
		else 
			return a.state > b.state --Player.crossArena.challengeReward[a.id] > Player.crossArena.challengeReward[b.id]	
		end
	end)
	return list
end

function m:getDrop(info)
    -- body
    --从服务器获取奖励的物品
    local drop = info.drop:getLuaTable()
    local _list = {}
    for i, v in pairs(drop) do
        if self:isUsedType(v.type) then
            local m = {}
            m.type = v.type
            m.arg = v.arg
            m.arg2 = v.arg2
            table.insert(_list, m)
            m = nil
        end
    end
    return _list
end

function m:isUsedType(_type)
    local typeAll = { "equip", "equipPiece", "item", "char", "charPiece", "reel", "reelPiece", "money", "gold", "bp", "shouhun", "shenhun", "soul", "popularity", "credit", "honor", "donate", "exp", "hunyu", "ghost", "ghostPiece" }
    for i, j in pairs(typeAll) do
        if _type == j then
            return true
        end
    end
    return false
end

function m:onClick(go, name)
	if name == "btn_close" then 
		UIMrg:popWindow()
	elseif name == "cb_week" or name == "cb_week_g" then 
		self.type = 2 
		self:refresh()
	elseif name == "cb_dialy" or name == "cb_dialy_g" then 
		self.type = 1
		self:refresh()
	end 
end

return m