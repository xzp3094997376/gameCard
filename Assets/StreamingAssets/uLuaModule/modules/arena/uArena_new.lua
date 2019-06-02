local m = {}
local teamIndex = 0
local curTab = 1
local canClick = false
local timerId = 0

function m:getTeamPower()
    local t = Player.Team[teamIndex]
    local teams = t.chars
    local lingya = 0 --t.power
    if lingya == 0 then
        for i = 0, 5 do
            if teams.Count > i then
                if teams[i .. ""] ~= 0 and teams[i .. ""] ~= "0" then
                    local last_char = Char:new(teams[i .. ""])
                    lingya = lingya + last_char.power
                end
            end
        end
    end

    return lingya
end

function m:updateRes()
    if self.type.."" == "2" then
        self.txt_count.text = Player.Resource.Multi_honor
    else
        self.txt_count.text = Player.Resource.honor
    end
end

function m:onUpdate(ret)
    if curTab == 1 then
        m:updateJJC(ret)
    elseif curTab == 2 then
        m:updateShop()
    elseif curTab == 3 then
        m:updateRank()
    end
end

--布阵
function m:onFormation()
    LuaMain:showFormation(teamIndex)
    self._isRefresh = false
end

function m:onEnter()
	if not self.topMenu.gameObject.activeInHierarchy then 
		local typestr = "credit"
		if self.type.."" == "2" then 
			typestr = "Multi_credit"
		end 
		self.topMenu.gameObject:SetActive(true)
		self.topMenu:CallTargetFunction("onUpdate",true)
        self.topMenu = LuaMain:ShowTopMenu(6, nil, {[1]={type="vp"},[2]={type=typestr},[3]={type="money"},[4]={type="gold"}})
	end 
    if curTab == 2 then
        m:onUpdate()
        return
    end

    if self._onExit ~= true then return end
    self._onExit = false
    local ret = true
    if self._isRefresh == false then
        ret = self._isRefresh
        local power = m:getTeamPower()
        if self._oldPower ~= power then ret = true end
    end
    m:onUpdate(ret)
end

function m:onExit()
    self._onExit = true
    LuaTimer.Delete(timerId)
end

--记录
function m:onRecord(go)
    local type_name = "normal"
    if self.type.."" == "2" then
        type_name = "crossArena"
    end
    UIMrg:pushWindow("Prefabs/moduleFabs/arenaModule/arena_record",{type = type_name})
end

function m:setPlayer(data)
    self.arena_enemy_1:CallUpdate({ data = data, delegate = self })
end

function m:find(arg, pid)
    local find = 0
    local len = table.getn(arg)
    for i = 1, len do
        if arg[i].pid == pid then
            return i - 2
        end
    end
end

function m:checkPoint()
	local red = false
	TableReader:ForEachLuaTable("crossArenaTask", function(index, item)
        if item.task_type == "server_daily" or item.task_type == "server_weekly" then 
			if Player.crossArena.challengeReward[item.id] == item.id then 
				red = true
				return true
			end 
		end 
		return false
	end)
	return red
end 

--刷新
function m:refreshList(ret)
    canClick = false
    local power = m:getTeamPower()
    self._oldPower = power
    local times = self.player_info.max_fight - self.player_info.has_fight
    times = math.max(times, 0)
    local tp = "normal" --普通竞技场
	self.txt_cost.gameObject:SetActive(true)
	if self.player_info.rankLevel ~= nil then 
		self.img_show.spriteName = "kuafudengji_" .. self.player_info.rankLevel
	end 
    if self.type.."" == "2" then --跨服竞技场
        tp = "crossArena"
		local max = self.totelTimes
		self.txt_fight_time.text = times .. "/" .. max
		self.txt_cost.gameObject:SetActive(false)
        self.txt_honor.text = Player.Resource.Multi_honor
		m:updateVStimes()
    end
    DialogMrg.levelUp()
    Api:arenaChangeEnemy(tp,function(result)
		m:updateRedPoint()
		if self.type.."" == "2" then
			self.txt_jjc_name.text = ""
			Api:getRewardList(function (rl)
				if rl.ret == 0 then 
					self.rewardobj = rl
					local info, rank = m:getRewardByCrossArena()
					m:setRewardData(info, rank)
				end 
			end)
		else
			local info = self:getRewardBySelf()
			self:setRewardData(info)
		end
        local me = {
            info = {
                power = power,
                can_fight = 0,
                head = Player.Info.head,
                level = Player.Info.level,
                nickname = Player.Info.nickname,
                now_rank = self.player_info.now_rank,
                pid = Player.playerId,
                vip = Player.Info.vip,
				playerid = Tool.getDictId(Player.Info.playercharid),
            },
            rank = self.player_info.now_rank,
            pid = Player.playerId,
            tp = tp
        }
        local temp = {}
        local ret_arr = result.ret_arr
        local isMe = false
        for i = 0, ret_arr.Count - 1 do
            local it = ret_arr[i]
            it.tp =tp
            if it.pid == me.pid then 
				isMe = true	
			end
            if GuideMrg:isPlaying() then 
                if it.rank<=self.player_info.now_rank or it.pid == me.pid then 
                    table.insert(temp, it)
                end
            else 
                table.insert(temp, it)
            end 
        end
        if not isMe then
            table.insert(temp, me)
        end
        table.sort(temp, function(a, b)
            return a.rank < b.rank --按排名次数
        end)

        self.enemyData = temp
        self:updateJJC()
        temp[1].type = self.type
        self:setPlayer(temp[1])
        temp = nil
        --self.scrollView:refresh({}, self, false, 0)
		--self.scrollView.ItemCount = 0
		--self.scrollView:clearItems()
        self.binding:Hide("scrollView")
		self.txtRank.text = TextMap.GetValue("Text_1_167").. self.player_info.now_rank
		if self.player_info.now_rank > 1000 then 
			self.jianli:SetActive(false)
			self.jianliDes.gameObject:SetActive(true)
		else
			self.jianli:SetActive(true)
			self.jianliDes.gameObject:SetActive(false)
		end 
        self.binding:CallManyFrame(function()
            -- self.scrollView:refresh(self.enemyData, self, false, m:find(self.enemyData, me.pid))
            self.binding:Show("scrollView")
            self.scrollView:refresh(self.enemyData, self, false,0)
            self.binding:CallAfterTime(0.4, function()
                local _index = self:find(self.enemyData, me.pid)
                self.scrollView:goToIndex(_index)
                if GuideMrg:isPlaying() then 
                    Messenger.Broadcast('ArenaDragEnd')--新手引导的监听
                end
                end)
            self.scrollView.mScrollView:Scroll(0.01)
        end, 1)
        self.binding:CallManyFrame(function()
            canClick = true
        end, 10)
        self.swNum = result.swNum
        --if self.swNum ~= nil then
        --    self.txt_nowCount.text = self.swNum
        --end
		self.taget:CallUpdate({rank = m:getTargetRank(self.player_info.now_rank), delegate = self})
		self.normal:CallUpdate({rank = self.player_info.now_rank, delegate = self})
    end, function()
        canClick = true
        return false
    end)

end

--买挑战次数
function m:addFightTime(type)
	local tb = TableReader:TableRowByID("MultiVsArgs", "addtime_" .. (self.player_info.buy_time+1))
	if tb == nil then 
		MessageMrg.show(TextMap.GetValue("Text_1_168"))
		return 
	end 
	local vip = tb.consume[1].consume_arg
	
	if Player.Info.vip < vip then 
		MessageMrg.show(TextMap.GetValue("Text_1_169"))
		return 
	end 
	local cost = tb.consume[0].consume_arg
	--local canBuy = 
	DialogMrg.ShowDialog(string.gsub(TextMap.GetValue("Text1811") .. "\n", "{0}", TextMap.GetValue("Text_1_170") .. cost), function()
		Api:addFightTime(type, function(ret)
			m:updateJJC() --购买之后重新刷新基本数据
		end, function()
			return false
		end)
	end)
end

--2015.4.20日 修改竞技场可购买次数
--购买挑战次数
function m:onReset(go)
    if self.type.."" == "2" then
        --DialogMrg:BuyBpAOrSoul("kftzq", "", toolFun.handler(self, self.updateVStimes),toolFun.handler(self, self.updateVStimes))
		self:addFightTime("crossArena")
	end
end

--规则
function m:onHelp(go)
    UIMrg:pushWindow("Prefabs/moduleFabs/qiancengta/qiancengta_rule", {20,title = TextMap.GetValue("Text_1_171")})
end

function m:updateVStimes()
    self.txt_fight_time.text = (self.player_info.max_fight - self.player_info.has_fight) .. "/" .. self.totelTimes
end

function m:updateJJC(ret)
	if self.type.."" == "2" then
		self.txt_fight_time.text = (self.player_info.max_fight - self.player_info.has_fight) .. "/" .. self.totelTimes
    end
	if ret then
        m:refreshList(ret)
        return
    end
end

--竞技场
function m:onJJC(go)
    curTab = 1
    self.txt_honor.text = Player.Resource.Multi_honor
	if self.type.."" == "2" then
		self.txt_fight_time.text = (self.player_info.max_fight - self.player_info.has_fight) .. "/" .. self.totelTimes
    end
	m:updateState()
    m:updateJJC()
end

function m:OnDestroy()
    LuaTimer.Delete(timerId)
    Events.RemoveListener('vsfight_callback')
    Events.RemoveListener("vstime_refrash")
    Events.RemoveListener("updateReward")
end

function m:setRefreshTime(tab, now)
    LuaTimer.Delete(timerId)
    if tab.hour - now.hour >= 1 and now.min >= 56 then
        timerId = LuaTimer.Add(10000, 30000, function(id)
            m:checkUpdate()
            return true
        end)
    end
end

function m:checkUpdate()
    Api:checkUpdateShop(function()
        m:updateShop()
    end)
end

function m:updateShop()
    LuaMain:showShop(4)
    curTab = 1
end

function m:updateState()
    self.toggle_jjc.value = curTab == 1
    self.toggle_rank.value = curTab == 3
    self.toggle_shop.value = curTab == 2
    self.tab_jjc:SetActive(curTab == 1 or curTab == 3)
    self.tab_rank:SetActive(curTab == 3)
end

function m:onShop(go)
	if self.type.."" == "2" then 
		LuaMain:showShop(16)
	else 
		LuaMain:showShop(4)
	end 
end

--添加次数
function m:onAdd()
    m:onReset()
end

function m:setRankTop(pid_list, sid_list, rank_list, rank)
    local that = self
    Api:showDetailInfoArr(pid_list, sid_list, rank_list, function(result)
        m:setRankTopData(result.showRet, rank, pid_list,sid_list)
    end)
end

function m:setRankTopData(list, rank, _idArr,sid_list)
    for i = 0, list.Count - 1 do
        self["arena_rank_" .. (i + 1)]:CallUpdate({ data = list[i], pid = _idArr[i + 1], now_rank = rank[i + 1], sid = sid_list[i+1], delegate = self })
    end
end

local initRank = false

--更新排行榜
function m:updateRank(ret)
    if ret then
        local tp = "normal"
        if self.type.."" == "2" then
            tp = "crossArena"
        end
        Api:getRankList(tp,function(result)
            local count = result.rank_list.Count - 1
            maxInt = count
            local list = {}
            local rankTop = {}
            local ranks = {}
            local pid_list = {}
            local sid_list = {}
            local rank_list = {}
            for i = 0, count do
                local data = result.rank_list[i]
				table.insert(list, data)
            end
            --m:setRankTop(pid_list, sid_list, rank_list, ranks)
            rankTop = nil
            self.View:refresh(list, self, true, 0)
        end)
    end
end

--排行榜
function m:onRank(go)
    curTab = 3
    m:updateState()
    if initRank == false then
        m:updateRank(true)
        initRank = true
	else 
		if self.type.."" == "2" then 
			m:updateRank(true)
		end 
    end
    if self._isRefreshRank == true then
        self._isRefreshRank = false
    end
end

--事件
function m:onClick(go, name)
    if not canClick then return end
    --    UluaModuleFuncs.Instance.uTimer:removeSecondTime("updateShop")
    LuaTimer.Delete(timerId)
	if name == "btn_record" then
        self:onRecord(go)
    elseif name == "btn_Refresh" then
        self:onRefresh(go)
    elseif name == "btn_jjc" then
        --m:onJJC(go)
		-- 改成了布阵
		self:onFormation()
    elseif name == "btn_rank" then
        self:onRank(go)
    elseif name == "btn_shop" then
        self:onShop(go)
    elseif name == "btn_add" then
        self:onAdd()
    elseif name == "btn_formation" then
	
	elseif name == "btn_rule" then 
		self:onHelp(go)
	elseif name == "btn_task_reward" then 
		UIMrg:pushWindow("Prefabs/moduleFabs/arenaModule/jingji_reward", {})
    elseif name == "btn_receive" then
        Api:getSwItem(function (reslut)
            --self.txt_nowCount.text = "0"
            self.txt_honor.text = Player.Resource.Multi_honor
            if reslut.drop ~= nil then
                local count = reslut.drop.Multi_honor
                if count.."" == "0" then return end
                MessageMrg.show(TextMap.GetValue("Text397")..count..TextMap.GetValue("Text470"))
            end
        end)
	elseif name == "btn_close_rank" then 
		self:onJJC()
	elseif name == "btnShopClose" then
	    curTab = 1
		self:updateState()	
    end
end

function m:onRefresh(go)
    local that = self
    local SHOP_TYPE = self._type
    local _shop = Player.Shop[SHOP_TYPE]
    local free_reset_times = Player.Shop[SHOP_TYPE].free_reset_times --已免费次数
    desc = TextMap.getText("COST_TYPE", { _shop.reset_arg, TextMap[_shop.reset_type], _shop.reset_times })
    DialogMrg.ShowDialog(desc, function()
        Api:refreshShop(SHOP_TYPE, function()
            MusicManager.playByID(20)
            that:onUpdate()
        end)
    end)
end

function m:update(data)
    if data ~= nil then
        self.type = data[1]
    end 
	local typestr = "credit"
	if self.type.."" == "2" then 
		typestr = "Multi_credit"
	end 
    self.topMenu = LuaMain:ShowTopMenu(6, nil, {[1]={type="vp"},[2]={type=typestr},[3]={type="money"},[4]={type="gold"}})
	
    local temp = "honor"
    if self.type.."" == "2" then
		self.uluaTitle:CallTargetFunctionWithLuaTable("setTitle",TextMap.GetValue("Text_1_172"))
        temp = "Multi_honor"
        self._type = 30
        self.player_info = Player.crossArena
		--self.player_info = Player.VSBattle
        self.totelTimes = TableReader:TableRowByID("MultiVsArgs", "vstime" .. Player.Info.vip).arg
        self.go_kuafu:SetActive(true)
        --self.normal_obj.transform.localPosition = Vector3(-5, 215, 0)
        --self.txt_now_count:SetActive(true)
        --self.title_paihang:SetActive(false)
    else
		self.uluaTitle:CallTargetFunctionWithLuaTable("setTitle",TextMap.GetValue("Text_1_166"))
        self._type = 4
        self.player_info = Player.VSBattle
        --self.totelTimes = TableReader:TableRowByID("vsArgs", "vstime" .. Player.Info.vip).arg
        self.go_kuafu:SetActive(false)
        --self.normal_obj.transform.localPosition = Vector3(-5, 190, 0)
        --self.txt_now_count:SetActive(false)
        --self.title_paihang:SetActive(true)
    end
	--self.taget:CallUpdate({rank = m:getTargetRank(self.player_info.now_rank), delegate = self})
	--self.normal:CallUpdate({rank = self.player_info.now_rank, delegate = self})
	
    local name = Tool.getResIcon(temp)
    local assets = packTool:getIconByName(name)
	
    self.icon_1:setImage(name,assets)
    --self.icon_2:setImage(name,assets)
    m:refreshList()
end

function m:updateRedPoint()
	self.reward_eff:SetActive(self:checkPoint())
end

function m:getTargetRank(temp)
	local rank = nil
	local ishaveValue = false
	local rankingDesc = nil 
	local lastRank = 0
	TableReader:ForEachLuaTable("dailyPrize",
            function(index, item)
				if index == 0 and item.rank_tag == temp then 
					rank = item.rank_tag
				end 
                if item.rank_tag < temp then --self.player_info.now_rank then
					if tonumber(item.desc) ~= nil and tonumber(item.desc) == 0 then 
						rank = item.rank_tag
					else 
						rank = item.rank_tag - 1		
					end 
                end
                return false
    end)
	return rank
	--return awardObj
end 

function m:Start()
	self.uluaTitle = Tool.loadTopTitle(self.gameObject, "")
    --self.txt_count.text = "0"
    curTab = 1
    self.frist_shop = true
    self.toggle_jjc = self.btn_jjc:GetComponent(UIToggle)
    self.toggle_rank = self.btn_rank:GetComponent(UIToggle)
    self.toggle_shop = self.btn_shop:GetComponent(UIToggle)
    self.binding:CallManyFrame(function()
        self.toggle_jjc.enabled = false
        self.toggle_shop.enabled = false
        self.toggle_rank.enabled = false
    end, 3)
    
    self._isRefresh = false
    Events.AddListener("vsfight_callback", funcs.handler(self, function(target, ret)
        self._isRefresh = ret
    end))
    Events.AddListener("vstime_refrash", funcs.handler(self, function(target, ret)
        self.txt_fight_time.text = (self.player_info.max_fight - self.player_info.has_fight) .. "/" .. self.totelTimes
    end))
	Events.AddListener("updateReward",funcs.handler(self, self.updateRedPoint))
	
    self.kuafu_list = {}
    TableReader:ForEachLuaTable("MultiCumulativeHonor",function (k,v)
            table.insert(self.kuafu_list,v)
            return false
    end)
end

function m:getRewardByCrossArena()
	if self.rewardobj == nil then return nil end 
	local tb = json.decode(tostring(self.rewardobj.Rewards)) 
	if tb.name ~= nil then 
		self.txt_jjc_name.text = tb.name
	else
		self.txt_jjc_name.text = ""
	end 
	local lvTb = {}
	for i, j in pairs(tb) do
		local lv = tonumber(i)
		if lv ~= nil then 
			table.insert(lvTb, {rank = lv + 1, drop = j.drop})
		end 
	end
	table.sort(lvTb, function(a, b)
		return a.rank < b.rank
	end)
	for i = 1, #lvTb do 
		if self.player_info.now_rank <= lvTb[i].rank then 
			return lvTb[i].drop
		end 
	end
	return nil, lvTb[#lvTb].rank
end

function m:getRewardBySelf()
	local awardObj = nil
	local ishaveValue = false
	local rankingDesc = nil 
	TableReader:ForEachLuaTable("dailyPrize",
            function(index, item)
                if item.rank_tag == self.player_info.now_rank then
                    awardObj = TableReader:TableRowByUnique("dailyPrize", "rank_tag", item.rank_tag)
                    rankingDesc = item.desc
                    ishaveValue = true
                elseif item.rank_tag > self.player_info.now_rank then
                    if ishaveValue == false then
                        awardObj = TableReader:TableRowByUnique("dailyPrize", "rank_tag", rankingDesc)
                        rankingDesc = awardObj.rank_tag .. awardObj.desc
                        ishaveValue = true
                    end
                end
                if ishaveValue == false then
                    rankingDesc = item.rank_tag
                end
                return false
            end)
	if ishaveValue == false then 
		awardObj = TableReader:TableRowByUnique("dailyPrize", "rank_tag", rankingDesc)
	end 
	local drop = {}
	for i = 0, awardObj.drop.Count do 
		table.insert(drop, awardObj.drop[i])
	end 
	return drop
end

function m:setRewardData(awardObj, rank)
   if awardObj == nil then
		if rank ~= nil then 
			self.jianliDes.text = TextMap.GetValue("Text_1_173")..(rank-1)..TextMap.GetValue("Text_1_174")
			self.jianliDes.gameObject:SetActive(true)
		end 
		self.txt_honorCoin.text = ""
        self.txt_coin.text = ""
        self.txt_diamond.text = ""
    else
		self.jianliDes.gameObject:SetActive(false)
		local texts = nil
		local images = nil
		if self.type.."" == "2"  then
			texts = {self.txt_honorCoin, self.txt_coin, self.txt_diamond }
			images = {self.img_honorCoin_cost, self.img_coin_cost, self.img_diamond_cost}
		else 
			texts = {self.txt_diamond, self.txt_coin, self.txt_honorCoin}
			images = {self.img_diamond_cost, self.img_coin_cost, self.img_honorCoin_cost}		
		end 
        local drop = awardObj
        if #drop == 0 then
			for i = 1, #texts do 
				texts[i].text = 0
			end 
        else
			for i = 1, #drop do 
				local item 
				if texts[i] ~= nil then 
					texts[i].text = toolFun.moneyNumberShowOne(tonumber(drop[i].arg2))
				end
				if drop[i].type == "treasure" then
					item = Treasure:new(drop[i].arg)
				elseif drop[i].type == "item" then 
					item = uItem:new(drop[i].arg)
				else 
					images[i]:setImage(Tool.getResIcon(drop[i].type), "itemImage")
					texts[i].text = toolFun.moneyNumberShowOne(tonumber(drop[i].arg))
				end 
				if item ~= nil then 
					if images[i] ~= nil then 
						images[i]:setImage(item:getHead())
					end
				end 
			end 
        end
		texts = nil
		images = nil
    end
    UluaModuleFuncs.Instance.uTimer:removeFrameTime("sureArenaDesc")
end

return m