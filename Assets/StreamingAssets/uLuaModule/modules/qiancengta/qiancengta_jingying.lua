local m = {}
local selectPanel = {}
local currentFightTimes = 0
local isClick = false --点击按钮的唯一性
local isOverTimes = false
local chapterObj = {}
local totaltimes = -1 --可挑战的次数-1

function m:onUpdate()
	--self.index = 0
	local list = m:getList()
	-- 补差
	local index = self.index
	index = index - self.index / 10
	self.scrollView:refresh(list, self, false, index)
	m:selectItem(list[self.index+1], self.index)
end

function m:update(table)

	m:onUpdate()
end

function m:selectItem(item, index)
	if item == nil then return end 
    self.item = item
	self.power:SetActive(item.power ~= nil)
    if item.power ~= nil then 
        self.txt_power.text = item.power
    end 

	self.textureEasy:LoadByModelId(item.model, "idle", function() end, false, 2, 1)
    self:setData()
	self.index = item.index
end

function m:isInFirstWin(id)
	for i = 0, Player.qianCengTa.JYFirstWin.Count - 1 do 
		if id == Player.qianCengTa.JYFirstWin[i] then 
			return true
		end 
	end 
	return false
end 

function m:getList()
    local list = {}
	local isTowerCanFight = false
	local isCanFight = false
	local lastChapter = Player.qianCengTa.lastTower
	local canfightCount = 0
    TableReader:ForEachLuaTable("towerChapter_jingying",
        function(index, item)
            if item ~= nil then 
				item.index = index
                table.insert(list, item)
            end
			item.isCanFight = false
			item.unlockMsg = ""
			for i = 0, item.unlock.Count - 1 do 
				local cell = item.unlock[i]
			    if cell.unlock_condition == "towerChapter" then
					item.unlockMsg = TextMap.GetValue("Text_1_976")..cell.unlock_arg..TextMap.GetValue("Text_1_977")
					if lastChapter > cell.unlock_arg then
						isTowerCanFight = true
						if item.unlock.Count < 2 then 
							isCanFight = true
							item.isCanFight = true
							self.index = index
							if item.unlock.Count < 2 then 
								canfightCount = canfightCount + 1
							end 
						end 
					else 
						isTowerCanFight = false
					end
				elseif cell.unlock_condition == "towerChapter_jingying" then 
					item.unlockMsg = item.unlockMsg.. TextMap.GetValue("Text_1_978")..cell.unlock_arg..TextMap.GetValue("Text_1_979")
					if m:isInFirstWin(cell.unlock_arg) == true then 
						isCanFight = isTowerCanFight
						item.isCanFight = isCanFight
						if isCanFight == true then 
							canfightCount = canfightCount + 1
							self.index = index 
						end 
					end 
				end
			end 
            return false
        end)
	if canfightCount <= 0 then 
		MessageMrg.show(TextMap.GetValue("Text_1_980"))
		UIMrg:popWindow()
	end 
    return list
end

function m:setCanFightTimes()
    self.fightTimes.gameObject:SetActive(true)
    --self.firstWin:SetActive(false)
    self.hasFight.text = TextMap.GetValue("Text_1_203")
	local max_time = TableReader:TableRowByID("tower_config", "jingying_times").args1
    self.times = (max_time + Player.qianCengTa.JYBuyTimes) - Player.qianCengTa.JYFightTimes
    if max_time <= 0 then
        self.fightTimes.gameObject:SetActive(false)
        self:setData()
        return
    end
    if self.times <= 0 then
        isOverTimes = true
        fight_times = false
        self.times = 0
        self.timestxt = "[ff0000]" .. self.times .. "[-]"
    else
        self.timestxt = "[00ff00]" .. self.times .. "[-]"
    end

    self.fightTimes.text = "[ffff96]"..TextMap.GetValue("Text15").."[-]".. self.times .. "/" .. max_time
end

function m:setData()
    m:setCanFightTimes()
    self.sectionName.text = self.item.name
    local img = Tool.getResIcon(self.item.firstWindrop[0].type)
	self.img_win:setImage(img, "itemImage")
	self.txt_firstwin.text = TextMap.GetValue("Text_1_981") .. self.item.firstWindrop[0].arg
	self.Sprite_firstWin.gameObject:SetActive(m:isInFirstWin(self.item.id))
	self.tempItemData = {}
    local dropCount = self.item.probdrop.Count - 1
   
    if dropCount > 3 then --因为界面上最多显示4个格子
		dropCount = 3
    end
    for i = 0, dropCount do
    	local num = 1
    	local vo 
    	if self.item.probdrop[i]["arg2"].Count > 1 then
			num = self.item.probdrop[i]["arg2"][0].."~"..self.item.probdrop[i]["arg2"][1]
		elseif self.item.probdrop[i]["arg2"][0] ~= nil then
			num = self.item.probdrop[i]["arg2"][0]
    	end
    	if self.item.probdrop[i]["type"] == "item" then
			vo = itemvo:new(self.item.probdrop[i]["type"], num, self.item.probdrop[i]["arg"])
		else
			vo = itemvo:new(self.item.probdrop[i]["type"], 1, self.item.probdrop[i]["arg"], 1, "1")
    	end
        vo.isShowName = true
		self.tempItemData[i + 1] = vo
    end
    if self.tempItemData ~= nil then
        table.sort(self.tempItemData, function(a, b)
            return a.itemTrueColor > b.itemTrueColor
        end)
    end
    for j = 0, dropCount do
		if self.rewardObjs[j+1] == nil then 
			self.rewardObjs[j+1] = ClientTool.loadAndGetLuaBinding("Prefabs/moduleFabs/chapterModule/chapterItemCell", self.itemTable.gameObject)
        end
		self.rewardObjs[j+1]:CallUpdate(self.tempItemData[j + 1])
        vo = nil
    end
    --teamObj = nil
    self.itemTable.repositionNow = true
end

function m:fightError()
    isClick = false
end

--回调战斗函数
function m:fightIng(arr)
    if arr == nil then
        DialogMrg.ShowDialog(TextMap.GetValue("Text83"))
        return
    end

    self.teamId = 0
    Api:fightJingYing(self.item.id, function(result)
        local fightData = {}
        fightData["battle"] = result
        fightData["mdouleName"] = "qiancengta_jingying"
        fightData["chapter_zj"] = self.item.id --当前章节
        --fightData["chapter_sl"] = self._otherArge --如果为-1 则是超链接打开
        fightData["id"] = 0
		UIMrg:pushObject(GameObject())
        UluaModuleFuncs.Instance.uOtherFuns:callBackFight(fightData)
        fightData = nil
    end, function(ret)
        isClick = false
        return false
    end)
end

function m:onClick(go, name)
    if isClick == true then
        return
    end
    if name == "challengeBtn" then
        isClick = true
        --if self._chapterType == "heroChapter" and Player.NBChapter.status[self._senceID].fight == 0 then
        if m:getTotaltimes() <= 0 then
            MessageMrg.show(TextMap.GetValue("Text501"))
            isClick = false
            --chapterObj = nil
            --m:resetHeroChapter()
            return
        else
            m:fightIng(LuaMain:getTeamByIndex(0))
        end
	elseif name == "btn_add" then 
		m:addNum()
	elseif name == "btnClose" then
		UIMrg:popWindow()
	elseif name == "btn_formation" then
		LuaMain:showFormation(0)
    end
end

function m:onEnter()
	isClick = false
	self:onUpdate()
end 

function m:addNum()
	local buyNum = Player.qianCengTa.JYBuyTimes + 1
	local max_buy = 0
	local tb = TableReader:TableRowByUniqueKey("resetChapter", buyNum, "towerChapter_jingying")
	TableReader:ForEachLuaTable("resetChapter", function(k, v)
		if v.type == "towerChapter_jingying" then 
			if v.vip <= Player.Info.vip then 
				max_buy = max_buy + 1
			end 
		end 
        return false
	end)
	local canBuy = max_buy - Player.qianCengTa.JYBuyTimes
	if canBuy < 1 then 
		MessageMrg.show(TextMap.GetValue("Text_1_168"))
		return 
	end 

	DialogMrg.ShowDialog(string.gsub(TextMap.GetValue("Text1811") .. TextMap.GetValue("Text_1_982")..(canBuy), "{0}", TextMap.GetValue("Text_1_170") .. tb.consume[0].consume_arg), function()
		Api:buyJYTimes(function(ret)
			if ret.ret == 0 then 
				m:onUpdate()
			end 
		end, function()
			return false
		end)
	end)
end

function m:onClose()
    UIMrg:popWindow()
end

function m:Start()
	self.rewardObjs = {}
	self.index = 0
end

function m:create(binding)
    self.binding = binding
    return self
end

-- 获取可挑战的次数
function m:getTotaltimes()
    local row = TableReader:TableRowByID("tower_config", "jingying_times")
	local max_time = row.args1
    local lefttimes = (max_time + Player.qianCengTa.JYBuyTimes) - Player.qianCengTa.JYFightTimes
    return lefttimes
end

return m