local m = {}
local campStr = {TextMap.GetValue("Text_1_2926"), TextMap.GetValue("Text_1_2927"), TextMap.GetValue("Text_1_2928")}
function m:updateTab(tab)
    if tab < 0 then tab = 1 end 
    self.tab = tab
    if tab == 1 then
        self.btn_dps.gameObject:SetActive(true)
        self.btn_dps_g.gameObject:SetActive(false)
        self.btn_sp.gameObject:SetActive(false)
        self.btn_sp_g.gameObject:SetActive(true)
        self.btn_rew.gameObject:SetActive(false)
        self.btn_rew_g.gameObject:SetActive(true)
    elseif tab == 2 then
        self.btn_dps.gameObject:SetActive(false)
        self.btn_dps_g.gameObject:SetActive(true)
        self.btn_sp.gameObject:SetActive(true)
        self.btn_sp_g.gameObject:SetActive(false)
        self.btn_rew.gameObject:SetActive(false)
        self.btn_rew_g.gameObject:SetActive(true)
    elseif tab == 3 then
        self.btn_dps.gameObject:SetActive(false)
        self.btn_dps_g.gameObject:SetActive(true)
        self.btn_sp.gameObject:SetActive(false)
        self.btn_sp_g.gameObject:SetActive(true)
        self.btn_rew.gameObject:SetActive(true)
        self.btn_rew_g.gameObject:SetActive(false)
    end

    if tab == 1 then
        m:onRank(self.tp == 1 and "sgongxun" or "sdmg", 1)
    elseif tab == 2 then
        m:onRank(self.tp == 1 and "egongxun" or "edmg", 2)
    elseif tab == 3 then
        m:onRank(self.tp == 1 and "ygongxun" or "ydmg", 3)
    end
end

function m:getNum(dps)
    if dps > 10000 then
        local str = string.format("%.1f", (dps / 10000))
        return "[00ff00]" .. str .. TextMap.GetValue("Text_1_2931")
    end
    return dps
end

function m:onRank(type, camp)
    Api:getTaoRenBossRank(type, camp,  function(result)
        self.result = result
        local rankList = result.rankList
        local list = {}
        if rankList then
            for i = 0, rankList.Count - 1 do
                local it = rankList[i]
                local obj = {}
                obj.no = i + 1 
                obj.name = it.name
                obj.dps = m:getNum(it.dmg)
                obj.index = i + 1 
				 obj.dictid = it.dictid
				 obj.gongxun = it.gongxun
				 obj.power = it.power
				 obj.star = it.quality
				 obj.tp = self.tp
				 if obj.name == Player.Info.nickname then 
					me = obj
				 end 
                table.insert(list, obj)
            end
        end
		 self.rank = result.rank
		 if result.rank < 9999 then 
            self.txt_me_rank_reward.text = result.rank
			self.txt_me_rank.text = result.rank .. "（" .. campStr[Player.TaoRenBoss.camp] .. "）"
		 else 
			self.txt_me_rank.text = TextMap.GetValue("Text_1_2932")
            self.txt_me_rank_reward.text = TextMap.GetValue("Text_1_2932")
		 end 
		 
        self.content:refresh(list, self, true, 0)
        if #list == 0 then
            self.no_data:SetActive(true)
        else
            self.no_data:SetActive(false)
        end
    end)
end

function m:getDisplayRank(tag, desc)
    if desc ~= nil and desc ~= "" and desc ~= 0 then
        return tag .. desc
    end
    return tag
end

function m:onReward()
    if self.rewardList == nil then
        local rewardList = {}
		 local meReward = nil
		 local tbName = self.tp == 1 and "taorenBossRank_exploit" or "taorenBossRank_dmg"
        TableReader:ForEachLuaTable(tbName, function(index, item)
            local it = {}
            it.rank = m:getDisplayRank(item.rank_tag, item.desc)
            it.li = RewardMrg.getProbdropByTable(item.drop)
			 if self.rank ~= nil then 
				if self.rank == it.rank then 
					meReward = item
				end 
			 end 
            table.insert(rewardList, it)
            return false
        end)
		if meReward ~= nil then 
			self.grid.gameObject:SetActive(true)
			ClientTool.UpdateGrid("Prefabs/moduleFabs/activityModule/itemActivity", self.grid, meReward.li)
		else 
			self.grid.gameObject:SetActive(false)
		end 
        self.rewardList = rewardList

        self.reward_view:refresh(rewardList, self, true, 0)
    end
end

-- tp 1 功绩排行 2 伤害排行
function m:update(lua)
    self.tp = lua.tp
	
	local value = 0
	if self.tp == 1 then 
		value = Player.TaoRenBoss.gongxun
		self.txt_type.text = TextMap.GetValue("Text_1_2933")
		self.txt_title.text = TextMap.GetValue("Text_1_2934")
	elseif self.tp == 2 then 
		value = Player.TaoRenBoss.maxDmg
		self.txt_type.text = TextMap.GetValue("Text_1_2935")
		self.txt_title.text = TextMap.GetValue("Text_1_2936")
	end 
	self.txt_me_gongji.text = value
    m:updateTab(Player.TaoRenBoss.camp)
end

function m:onClick(go, name)
    if name == "btn_close" then
        UIMrg:popWindow()
    elseif name == "btn_dps" or name == "btn_dps_g" then
        m:updateTab(1)
    elseif name == "btn_sp" or name == "btn_sp_g" then
        m:updateTab(2)
    elseif name == "btn_rew" or name == "btn_rew_g" then
        m:updateTab(3)
	elseif name == "btn_rank" then 
		self.titleType = 1
		m:updateTitle()
	elseif name == "btn_reward" then 
		self.titleType = 2
		m:updateTitle()
		m:onReward()
    end
end

function m:updateTitle()
	self.dps_rank:SetActive(self.titleType == 1)
    self.reward:SetActive(self.titleType == 2)
	
	if self.titleType == 1 then 
		self.rank_img_di:SetActive(false)
		self.rank_img_di_sel:SetActive(true)
		self.reward_img_di:SetActive(true)
		self.reward_img_di_sel:SetActive(false)
	elseif self.titleType == 2 then 
		self.rank_img_di:SetActive(true)
		self.rank_img_di_sel:SetActive(false)
		self.reward_img_di:SetActive(false)
		self.reward_img_di_sel:SetActive(true)
	end 
end 

function m:Start()
	self.titleType = 1
	m:updateTitle()
end

return m