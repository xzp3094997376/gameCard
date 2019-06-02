local m = {}


function m:updateTab(tab)
    self.tab = tab
    self.dps_rank:SetActive(tab == 1)
    self.sp_rank:SetActive(tab == 2)
    self.reward:SetActive(tab == 3)

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
        m:onDpsRank()
    elseif tab == 2 then
        m:onSpRank()
    elseif tab == 3 then
        m:onReward()
    end
end

function m:getNum(dps)
    if dps > 10000 then
        local str = string.format("%.1f", (dps / 10000))
        return "[00ff00]" .. str .. TextMap.GetValue("Text_1_2861")
    end
    return dps
end

function m:onDpsRank()
    Api:getBossRank(function(result)
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
                table.insert(list, obj)
            end
        end
        self.content:refresh(list, self, true, 0)
        if #list == 0 then
            self.header:SetActive(false)
            self.no_data:SetActive(true)
        else
            self.header:SetActive(true)
            self.no_data:SetActive(false)
        end
    end)
end

function m:onSpRank()
    if self.tp == 1 then
        --self.view:SetActive(false)
        self.txt_desc:SetActive(true)
        return
    end
    self.txt_desc:SetActive(false)
    --self.view:SetActive(true)

    if self.result then
        local data = self.result
        local list = {}

        local last = self.lastKill
        if last then
            self.last_hit:CallUpdate(last) --上次最后一击
        else
            local item = {}
            item.name = ""
            item.no = ""
            item.dps = ""
            self.last_hit:CallUpdate(item)
        end

        list = self.luckyList or {}
        if #list > 0 then
            self.sp_view:refresh(list, self, true, 0) --上次幸运玩家
        else
        self.txt_desc:SetActive(true)
        -- else
        --     local item = {}
        --     item.name = ""
        --     item.no = ""
        --     item.dps = ""
        --     list[1] = item
        --     ClientTool.UpdateMyTable("", self.Table, list, self) --上次幸运玩家
        end
    end
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

        TableReader:ForEachLuaTable("world_boss_rankPrize", function(index, item)
            local it = {}
            it.rank = m:getDisplayRank(item.rank_tag, item.desc)
            it.li = RewardMrg.getProbdropByTable(item.drop)

            table.insert(rewardList, it)
            return false
        end)

        self.rewardList = rewardList

        self.reward_view:refresh(rewardList, self, true, 0)
    end
end

function m:update(lua)
    self.tp = lua.tp
    self.lastKill = lua.lastKill or nil
    self.luckyList = lua.luckyList or nil

    m:updateTab(1)
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
    end
end

function m:Start()
end

return m