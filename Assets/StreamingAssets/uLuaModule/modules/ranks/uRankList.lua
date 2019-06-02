local rankList = {}
local tempObj = {}
local currentSelectType = 1 --1巅峰  2总体 3竞技场 4小资 5 土豪
local selfRank = 0
local selfPower = 0
local startType = "peak"
local awardObj = nil
local targetObj = nil
local rankingDesc = nil
local _now_rank = nil
local _target_rank = 1
local awards = {}
function rankList:Start(...)
    local info = Player.VSBattle
    --if self.type == 2 then --跨服竞技场
    --    tb_id = 11
    --    info = Player.crossArena
    --end
	_now_rank = info.now_rank
	local ishaveValue =  false
	TableReader:ForEachLuaTable("dailyPrize",
            function(index, item)
				awards[index] = item
                if item.rank_tag == _now_rank then
                    awardObj = TableReader:TableRowByUnique("dailyPrize", "rank_tag", item.rank_tag)
					rankingDesc = item.desc
					ishaveValue = true
				elseif item.rank_tag > _now_rank then
					if ishaveValue == false then
						awardObj = TableReader:TableRowByUnique("dailyPrize", "rank_tag", rankingDesc)
						ishaveValue = true
					end
                end
				if ishaveValue == false then
                    rankingDesc = item.rank_tag
                end
                return false
            end)
	targetObj = self:getAwardByRank(_target_rank)
	Events.AddListener("selectRankItem", funcs.handler(self, self.updateItemDes))
end

function rankList:updateItemDes(r)
	if currentSelectType == 3 then 
		_target_rank = r
		targetObj = self:getAwardByRank(r)
		print("排名: " .. r .. "   targetObj = ".. tostring(targetObj))
		self:updateDes()
	end
end

function rankList:getAwardByRank(r)
	if awards == nil then return end
	local t = nil 
	local ishaveValue = false
	for k,v in pairs(awards) do
		if v.rank_tag == r then 
			t = v
			break
		elseif v.rank_tag > r then 
			if ishaveValue == false then
				t = v
				ishaveValue = true
			end
		end
		if ishaveValue == false then
            t = v
        end
	end
	print("t = " .. tostring(t))
	return t
end

function rankList:update(startType)
    if startType[1] == "peak" then
        self.toggleTop.value = true
        self.toggleLevel.value = false
        self:getPeakRank("peak")
    elseif startType[1] == "level" then
        self.toggleTop.value = false
        self.toggleLevel.value = true
        self:getLevelRank("level")
    end
end

function rankList:destory()
    --    UluaModuleFuncs.Instance.uTimer:removeFrameTime("refreshArenaHang")
    UIMrg:pop()
end

function rankList:create(binding)
    self.binding = binding
    return self
end

--竞技场数据
function rankList:setArenaData(_type)
    Api:getRankList("normal",function(result)
        self.rank_myself.gameObject:SetActive(true)
        self.scrollView.gameObject:SetActive(true)
        if result.self then
            selfRank = result.self.rank
            selfPower = result.self.power
        else
            selfRank = 9999
            selfPower = 0
        end
        --     selfRank = Player.VSBattle.now_rank --当前自己的排名
        --获取防守队伍战力
        --    selfPower = Player.Team[0].power
        --       print("selfRank"..Player.VSBattle.now_rank)
        self:setMySelfData(_type)
        local count = result.rank_list.Count - 1
        for i = 0, count do
            local temp = {}
            temp.type = _type
            temp.pw = result.rank_list[i].power
            temp.powerTxt = self:setLingyaByType(_type)
            temp.power = math.floor(tonumber(result.rank_list[i].power))
            temp.level = result.rank_list[i].level
            temp.id = result.rank_list[i].id
            temp.rank = result.rank_list[i].rank
            temp.name = result.rank_list[i].name
            temp.head = result.rank_list[i].head
            if result.rank_list[i].vip == nil then
                result.rank_list[i].vip = 0
            end
            temp.vip = result.rank_list[i].vip
            table.insert(tempObj, temp)
            temp = nil
        end
        self.scrollView:refresh(tempObj, self, true, 0)
    end)
end

--其他排行榜数据
function rankList:setOtherData(_type)
    Api:getRank(_type, function(result)
        if result.top.Count ~= 0 then
            self.rank_myself.gameObject:SetActive(true)
            self.scrollView.gameObject:SetActive(true)
            selfRank = result.self.rank
            selfPower = result.self.power
            if result.self.power == nil then
                selfPower = 0
                --     selfPower = result.self.power
                -- -- elseif _type == "level" then
                -- --     selfPower =Player.Info.level
                -- -- else
                -- --     selfPower = result.self.power
            end
            self:setMySelfData(_type)
        else
            self.rank_myself.gameObject:SetActive(false)
            self.scrollView.gameObject:SetActive(false)
            MessageMrg.show(TextMap.GetValue("Text1363"))
            return false
        end
        local count = result.top.Count - 1
        for i = 0, count do
            local temp = {}
            temp.type = _type
            temp.pw = result.top[i].power
            temp.powerTxt = self:setLingyaByType(_type)
            if _type == "level" then
                temp.power = tonumber(result.top[i].level)
            else
                temp.power = math.floor(tonumber(result.top[i].power))
            end
            temp.level = result.top[i].level
            temp.id = result.top[i].id
            temp.rank = i + 1
            temp.name = result.top[i].name
            temp.head = result.top[i].head
            if result.top[i].vip == nil then
                result.top[i].vip = 0
            end
            temp.vip = result.top[i].vip
            table.insert(tempObj, temp)
            temp = nil
        end
        self.scrollView:refresh(tempObj, self, true, 0)
    end)
end

function rankList:setMySelfData(_type)
	if selfPower == nil then 
		selfPower = 0
	end 
    local data = {}
    data.rank = selfRank
    data.powerTxt = self:setLingyaByType(_type)

    data.power = selfPower
    self.rank_myself:CallUpdate(data)
    data = nil
	self.txtCenterFight.text = selfPower..""
    -- body
end

--通过设置不同排行榜类型显示不同信息
function rankList:setLingyaByType(_type)
    local des = ""

    if _type == "peak" then --巅峰竞技场
    des = TextMap.GetValue("Text1364")
    elseif _type == "total" then --总体
    des = TextMap.GetValue("Text1365")
    elseif _type == "arena" then --竞技场
    des = TextMap.GetValue("Text1366")
    elseif _type == "level" then --番队等级
    des = TextMap.GetValue("Text1367")
    -- elseif _type == "money" then --小资
    --     _p = "拥有金币量：" .. power
    -- elseif _type == "goldCost" then --土豪
    --     _p = "已消耗钻石总量：" .. power
    end
    --  self.lingyaDes.text = des
    return des
end

--获取竞技场列表
function rankList:getArenaRank(_type)
	currentSelectType = 3
    tempObj = {}
    self.des.text = TextMap.GetValue("Text1368")
    self:setArenaData(_type)
	self:updateDes()
end

--获取巅峰对决
function rankList:getPeakRank(_type)
	currentSelectType = 1
    tempObj = {}
    self.des.text = TextMap.GetValue("Text1369")
    self:setOtherData(_type)
	self:updateDes()
end

--总体战力
function rankList:getTotalRank(_type)
    tempObj = {}
    self.des.text = TextMap.GetValue("Text1370")
    self:setOtherData(_type)
end

--小资排行榜
function rankList:getMoneyRank(_type)
    tempObj = {}
    self.des.text = TextMap.GetValue("LocalKey_745")
    self:setOtherData(_type)
end

--土豪排行榜
function rankList:getGoldRank(_type)
    toolFun.tableClear(tempObj)
    tempObj = {}
    self.des.text = TextMap.GetValue("LocalKey_745")
    self:setOtherData(_type)
end

--番队等级排行榜
function rankList:getLevelRank(_type)
	currentSelectType = 2
    toolFun.tableClear(tempObj)
    tempObj = {}
    self.des.text = TextMap.GetValue("LocalKey_745") 
    self:setOtherData(_type)
	self:updateDes()
end

function rankList:enterLevelRank()
    self.toggleLevel.value = true
    self:getLevelRank("level")
    -- body
end

function rankList:onClick(go, name)
	print("click_   " .. name)
    if name == "btArena" then
        self:getArenaRank("arena")
    elseif name == "btPeak" then
        self:getPeakRank("peak")
    elseif name == "btTotal" then
        self:getTotalRank("total")
    elseif name == "btMoney" then
        self:getMoneyRank("money")
    elseif name == "btGold" then
        self:getGoldRank("goldCost")
    elseif name == "btLevel" then
        self:getLevelRank("level")
    elseif name == "btClose" then
        --self:destory()
	elseif name == "btnClose" then 
		Events.RemoveListener('selectRankItem')
		UIMrg:popWindow()		
    end
end

function rankList:updateDes()
	if currentSelectType == 3 then 
		self.center:SetActive(false)
		self.bgright.Url = UrlManager.GetImagesPath("arena_v2/arena_gird_bg3.png")
		if awardObj ~= nil then 
			self.up:SetActive(true)
			self.txt_up_Rank.text = _now_rank .. ""
			self.txt_up_coin.text = awardObj.drop[0].arg
			self.txt_up_diamond.text = awardObj.drop[1].arg
			self.txt_up_honorCoin.text = awardObj.drop[2].arg
		else
			self.up:SetActive(false)
		end 
		if targetObj ~= nil then 
			self.down:SetActive(true)
			self.txt_down_Rank.text = _target_rank .. ""
			self.txt_coin.text = targetObj.drop[0].arg
			self.txt_diamond.text = targetObj.drop[1].arg
			self.txt_honorCoin.text = targetObj.drop[2].arg
		else
			self.down:SetActive(false)
		end 
	else 
		self.up:SetActive(false)
		self.down:SetActive(false)
		self.center:SetActive(true)
		self.txtCenterRank.text = _now_rank..""
		self.txtCenterFight.text = selfPower..""
		self.bgright.Url = UrlManager.GetImagesPath("arena_v2/arena_gird_bg2.png")
	end
end

return rankList