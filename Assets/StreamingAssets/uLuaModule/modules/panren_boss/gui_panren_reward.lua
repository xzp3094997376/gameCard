local m = {}

function m:Start()
	self.type = 1
	self.rewardList = {}
	self.killList = {}
	--local tasks = Player.crossArena.challengeReward:getLuaTable()
    TableReader:ForEachLuaTable("taorenBossReward_exploit", function(index, item)
		local li = RewardMrg.getProbdropByTable(item.drop)
		local it = {}
		it.row = item
		it.type = "gongji"
        local _item = li[1]
        it.item = _item
        it.name = _item.name
        it.need = item.need
        it.desc = item.desc
        it.id = item.id
		table.insert(self.rewardList, it)
		return false
	end)
	
	TableReader:ForEachLuaTable("taorenBossReward_Kill", function(index, item)
		local li = RewardMrg.getProbdropByTable(item.drop)
		local it = {}
		it.row = item
		it.type = "jisha"
        local _item = li[1]
        it.item = _item
        it.name = _item.name
        it.need = item.boss_lv
        it.decs = item.decs
        it.id = item.id
		table.insert(self.killList, it)
		return false
	end)
	Api:checkTaoRenBoss(function(result)
        self.bossLv = result.lv
		self.bossHp = result.hp
		self:refresh()
    end, function(ret)
        return true
    end)
	Events.AddListener("updateReward",funcs.handler(self, self.updateRfresh))
end

function m:updateRfresh()
	m:refresh()
end

function m:refresh()
	if self.type == 1 then 
		self.cb_gongji.gameObject:SetActive(false)
		self.cb_gongji_g.gameObject:SetActive(true)
		self.cb_jisha.gameObject:SetActive(false)
		self.cb_jisha_g.gameObject:SetActive(true)
	else 
		self.cb_gongji.gameObject:SetActive(true)
		self.cb_gongji_g.gameObject:SetActive(false)
		self.cb_jisha.gameObject:SetActive(true)
		self.cb_jisha_g.gameObject:SetActive(false)	
	end 
	local list = self:getTaskByType()
    self.binding:CallManyFrame(function()
        self.content:refresh(list, self, true, 0)
    end, 2)
end

function m:getTaskByType()
	local list = {}
	local pReward = nil 
	if self.type == 1 then 
		list = self.rewardList 
		pReward = Player.TaoRenBoss.gongxunReward
	elseif self.type == 2 then 
		list = self.killList 
		pReward = Player.TaoRenBoss.levelReward
	end
	local canList = {}
	for i = 1, #list do 
		if pReward[list[i].id] == list[i].id then 
			list[i].state = 1
		else 
			list[i].state = 0
		end 
	end 
	table.sort(list, function(a, b)
		if a.state == b.state then 
			if self.type == 1 then 
				return a.id > b.id
			else 
				return a.need < b.need
			end 
		else 
			if self.type == 1 then 
				return pReward[a.id] > pReward[b.id]	
			else
				return pReward[a.id] < pReward[b.id]	
			end
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

function m:onReward()
	local type = "GX"
	if self.type == 2 then type = "LV" end 
    Api:getAllLvReward(type, function(result)
        self:refresh()
        packTool:showMsg(result, nil, 0)
    end)
end 

function m:onClick(go, name)
	if name == "btn_close" then 
		UIMrg:popWindow()
	elseif name == "cb_gongji" or name == "cb_gongji_g" then 
		self.type = 2 
		self:refresh()
	elseif name == "cb_jisha" or name == "cb_jisha_g" then 
		self.type = 1
		self:refresh()
	elseif name == "btn_onekey" then 
		self:onReward()
	end 
end

function m:OnDestroy()
    Events.RemoveListener("updateReward")
end

return m