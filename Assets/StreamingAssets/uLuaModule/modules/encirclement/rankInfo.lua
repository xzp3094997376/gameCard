local m = {}
local rankRangeList = {}

function m:update()
    --self.btn_gx:GetComponent(UIToggle).value = true
    --首先先获取奖励
    m:getReward(function()
        m:onGx()
    end)
end

--type = 'gongxun' || 'dmg' 

function m:getList(result, tp)
    local list = {}
    local rankList = result.rankList
    for i = 0, rankList.Count - 1 do
        local it = rankList[i]
        local item = {}
        item.name = it.name
        item.level = it.level
        item.vip = it.vip
        item.power = it.power
        item.pid = it.pid
		item.dictid = it.dictid
		item.quality = it.quality
        if tp == "gongxun" then
            item.gongxun = it.gongxun
        end
        if tp == "dmg" then
            item.dmg = it.dmg
        end
        item.t = it.t
        item.type = it.type
        item.img = it.head or "default"
        item.rank = i + 1
        list[i + 1] = item
    end
    return list
end



function m:getGxRank(tp)
    local that = self
    if tp == "gongxun" and self._rankInited then
        local list = self.rankList
        self.content:refresh(list, self, true, 0)
        that.txt_targetRank.text = "[ffff96]"..TextMap.GetValue("Text819").."[-]" .. that.gongxunTartetRank
        that.txt_rankReward.text = "[ffff96]"..TextMap.GetValue("Text820").."[-]" .. that.gongxunRankReward
        that.txt_myrank.text = self.gongxun_rank
        return
    elseif tp == "dmg" and self._dpsRankInited == true then
        local list = self.dpsRankList
        self.content:refresh(list, self, true, 0)
        that.txt_targetRank.text = "[ffff96]"..TextMap.GetValue("Text819").."[-]" .. that.dmgTartetRank
        that.txt_rankReward.text = "[ffff96]"..TextMap.GetValue("Text820").."[-]" .. that.dmgTankReward
        that.txt_myrank.text = self.dmg_rank
        return
    end
    Api:getGxRank(tp, 1, 200, function(result)
        local rank = tonumber(result.rank) or 999
        local rankNum = rank
        local list = m:getList(result, tp)
        if rank > 200 then
            rank = TextMap.GetValue("Text128")
        else
            rank =string.gsub(TextMap.GetValue("Text127"),"{0}",rank)
        end

        that.txt_myrank.text = rank

        if tp == "gongxun" then
            self._rankInited = true
            self.rankList = list
            that.gongxunTartetRank = self:getTargetRank(rankNum)
            that.gongxunRankReward = self:getRankReward(rankNum, tp)
            that.txt_targetRank.text = "[ffff96]"..TextMap.GetValue("Text819").."[-]" .. that.gongxunTartetRank
            that.txt_rankReward.text = "[ffff96]"..TextMap.GetValue("Text820").."[-]" .. that.gongxunRankReward
            self.gongxun_rank = rank
        elseif tp == "dmg" then
            self._dpsRankInited = true
            self.dpsRankList = list
            that.dmgTartetRank = self:getTargetRank(rankNum)
            that.dmgTankReward = self:getRankReward(rankNum, tp)
            that.txt_targetRank.text =  "[ffff96]"..TextMap.GetValue("Text819").."[-]" .. that.dmgTartetRank
            that.txt_rankReward.text =  "[ffff96]"..TextMap.GetValue("Text820").."[-]" .. that.dmgTankReward
            self.dmg_rank = rank
        end

        self.content:refresh(list, that, true, 0)
    end, function(ret)
        if ret ~= 0 then
            DialogMrg.ShowDialog(TextMap.GetValue("Text821"), function()
                m:getGxRank(tp)
            end, function()
                m:onClick()
            end)
        end
        return true
    end)
end

--获取目标排名
function m:getTargetRank(rank)
    if rank == 1 then return 1 end
    local lastRank = rankRangeList[1]

    for i, v in ipairs(rankRangeList) do
        if rank >= lastRank and rank <= v - 1 then
            return lastRank - 1
        end
        lastRank = v
    end

    if rank == 200 then return lastRank - 1 end
    return 200
end

--获取排名奖励
function m:getRankReward(rank, type)
    local reward = TextMap.GetValue("Text822")
    local rewardList = self._rewardList
    local lastRank = rankRangeList[1]

    if rank == 1 then
        if type == "gongxun" then
            reward = rewardList[1].gongxun
        elseif type == "dmg" then
            reward = rewardList[1].dps
        end
        return reward
    end

    for i, v in ipairs(rankRangeList) do
        if rank >= lastRank and rank < v then
            if type == "gongxun" then
                reward = rewardList[i - 1].gongxun
            elseif type == "dmg" then
                reward = rewardList[i - 1].dps
            end
            return reward
        end
        lastRank = v
    end

    if rank == 200 then
        if type == "gongxun" then
            reward = rewardList[#rankRangeList].gongxun
        elseif type == "dmg" then
            reward = rewardList[#rankRangeList].dps
        end
    end

    return reward
end

function m:onGx()
    self.reward:SetActive(false)
    self.rank:SetActive(true)
    m:getGxRank("gongxun")
end

function m:onDps()
    self.reward:SetActive(false)
    self.rank:SetActive(true)
    m:getGxRank("dmg")
end

function m:getReward(callBack)
    local dmpList = {}
    local gongxunList = {}
    local _list = {}
    TableReader:ForEachLuaTable("daxuDailydmgRank", function(index, item)
        dmpList[index + 1] = item
        return false
    end)

    TableReader:ForEachLuaTable("daxuDailyGongxunRank", function(index, item)
        gongxunList[index + 1] = item
        return false
    end)

    for i = 1, #dmpList do
        local d = dmpList[i]
        local list = RewardMrg.getProbdropByTable(d.drop)
        local it = list[1]
        local name = "[FFFF96FF]"..it.name.."[-]" .. "x" .. it.rwCount
        local rank = d.rank_tag
        --排名信息加入到rankRangeList中
        table.insert(rankRangeList, rank)
        if d.desc ~= 0 then
            rank = rank .. d.desc
        end
        local item = {}
        local str = "[FFFF96]" .. TextMap.GetValue("Text402") .. "[-]"
        item.rank =string.gsub(str, "{0}", "[-]" .. rank .. "[FFFF96]")
        item.dps = name

        d = gongxunList[i]
        list = RewardMrg.getProbdropByTable(d.drop)
        it = list[1]
        name = "[FFFF96FF]"..it.name.."[-]" .. "x" .. it.rwCount
        item.gongxun = name

        item.index = i

        table.insert(_list, item)
    end

    self._rewardList = _list
    if callBack then callBack() end
end

function m:onReward()
    self.reward:SetActive(true)
    self.rank:SetActive(false)
    self.rewardView:refresh(self._rewardList, self, true, 0)
end

function m:onClose()
    self.gameObject:SetActive(false)
    self._rankInited = false
    self._dpsRankInited = false
    self.rankList = nil
    self.dpsRankList = nil
end

function m:onClick(go, name)
    if name == "btn_close" then
        m:onClose()
    elseif name == "btn_ph" or name == "btn_ph_g" then
        m:onGx()
		self.tp = 1
    elseif name == "btn_dps" or name == "btn_dps_g" then
        m:onDps()
		self.tp = 2
    elseif name == "btn_rew" or name == "btn_rew_g" then
        m:onReward()
		self.tp = 3
    end
	m:updateBtnStatus()
end

function m:updateBtnStatus()
	if self.tp == 1 then 
		-- self.btn_gx.isEnabled = false 
		-- self.btn_dps.isEnabled = true 
		-- self.btn_reward.isEnabled = true 
        self.btn_ph.gameObject:SetActive(true)
        self.btn_ph_g.gameObject:SetActive(false)
        self.btn_dps.gameObject:SetActive(false)
        self.btn_dps_g.gameObject:SetActive(true)
        self.btn_rew.gameObject:SetActive(false)
        self.btn_rew_g.gameObject:SetActive(true)
	elseif self.tp == 2 then 
		-- self.btn_gx.isEnabled = true 
		-- self.btn_dps.isEnabled = false 
		-- self.btn_reward.isEnabled = true 
        self.btn_dps.gameObject:SetActive(true)
        self.btn_dps_g.gameObject:SetActive(false)
        self.btn_ph.gameObject:SetActive(false)
        self.btn_ph_g.gameObject:SetActive(true)
        self.btn_rew.gameObject:SetActive(false)	
        self.btn_rew_g.gameObject:SetActive(true)
	elseif self.tp == 3 then 
		-- self.btn_gx.isEnabled = true 
		-- self.btn_dps.isEnabled = true 
		-- self.btn_reward.isEnabled = false 	
        self.btn_dps.gameObject:SetActive(false)
        self.btn_dps_g.gameObject:SetActive(true)
        self.btn_ph.gameObject:SetActive(false)
        self.btn_ph_g.gameObject:SetActive(true)
        self.btn_rew.gameObject:SetActive(true)    
        self.btn_rew_g.gameObject:SetActive(false)
	end 
end 

function m:Start()
	self.tp = 1
	m:updateBtnStatus()
end

return m