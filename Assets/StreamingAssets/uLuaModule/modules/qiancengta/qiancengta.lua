local lingwangta = {}
local selectSprite
local isHaveSelect = false
local selectID = 1
local itemBind = {}
local saodangLeftTime = 0
local tempModel
local totelNum = 0
local addOrSub = false --false为减去  true 为增加
local isHaveAward = false --是否还有奖励
local isHaveCanGetAward = false --是否有可领取奖励
local isOldData = -1
local vipResetData = {}
local sell_type = "honor"

--关闭界面
function lingwangta:OnDestroy()
    lingwangta = nil
    itemBind = nil
    selectSprite = nil
    UluaModuleFuncs.Instance.uTimer:removeSecondTime("qiancengtaTimes")
end

function lingwangta:Start()
    self.topMenu = LuaMain:ShowTopMenu(6, nil, {[1]={type="honor"},[2]={type="money"},[3]={type="gold"}})
	Tool.loadTopTitle(self.gameObject, TextMap.GetValue("Text_1_972"))
    lingwangta:setDatas()
end

-------------------------------------------------------------------------------------------------------------
-- 开始赋值
function lingwangta:setDatas()
    --lingwangta:updateTime()
    Api:checkRes(function()
        lingwangta:updateTime()
    end)
end

--第0部分：整体界面刷新
function lingwangta:updateTime()
    UluaModuleFuncs.Instance.uTimer:removeSecondTime("qiancengtaTimes")

    if totelNum == 0 then
        totelNum = TableReader:TableRowByID("tower_config", "totelFloors").args1 --拿到千层塔最大层数
    end
    self._currentTown = Player.qianCengTa.currentTower
    self._lastTown = Player.qianCengTa.lastTower
    if self._currentTown == 0 then
        self._currentTown = 1
    end
    if self._lastTown == 0 then
        self._lastTown = 1
    end
    if self._currentTown > totelNum then
        self._currentTown = totelNum
    end
    if self._lastTown > totelNum then
        self._lastTown = totelNum
    end
    Tool.qianchengta_currentSelect = self._currentTown
    lingwangta:setLeftData() --设置左边的数据

    lingwangta:showAwardBox() --设置宝箱的状态

    saodangLeftTime = Player.qianCengTa:getLong("sweepTime")
	--saodangLeftTime = ClientTool.GetNowTime(saodangLeftTime)
    if saodangLeftTime > 0 then
        self.daojishiLab.gameObject:SetActive(true)
        self.tiaozhanBtn.isEnabled = false
        self.saodangBtn.isEnabled = false
        self.chongzhiBtn.isEnabled = false
        saodangLeftTime = ClientTool.GetNowTime(saodangLeftTime)
		if saodangLeftTime > 0 then 
			UluaModuleFuncs.Instance.uTimer:secondTime("qiancengtaTimes", 1, 0, self.updateNorTime, self) --定时器
			self.add_chongzhi.gameObject:SetActive(false);
		else 
			self.daojishiLab.gameObject:SetActive(false)
			self.add_chongzhi.gameObject:SetActive(true);
			self.lbl_ke_chongzhi_times.text = TextMap.GetValue("Text1353") .. self:getKeChongzhiTimes()
		end 
    else
        self.daojishiLab.gameObject:SetActive(false)
        self.add_chongzhi.gameObject:SetActive(true);
        self.lbl_ke_chongzhi_times.text = TextMap.GetValue("Text1353") .. self:getKeChongzhiTimes()
    end
	
	self.ziyuanName.text =Tool.getResName(sell_type) .. ":"
    self.ziyuanNum.text =toolFun.moneyNumberShowOne(math.floor(tonumber(Tool.getCountByType(sell_type))))
    local iconName = Tool.getResIcon(sell_type)
    self.ziyuanIcon.Url=UrlManager.GetImagesPath("itemImage/" .. iconName .. ".png")
end

--第1部分：左边层级列表刷新
function lingwangta:setLeftData()
    local tempObj = {}
    for i = 1, totelNum do
        local temp = {}
        temp.index = (totelNum + 1) - i
        temp.callBack = self.callBackClick
        temp.lastSelect = self._currentTown
        temp.lastTown = self._lastTown
        table.insert(tempObj, temp)
        temp = nil
    end
    self.binding:CallAfterTime(0.1,
        function()
            self.scrollview:refresh(tempObj, self)
            local precent = totelNum - self._currentTown
            if precent <= 2 then
                precent = 0
            end
            self.scrollview:assignPage(precent)
            self.binding:CallAfterTime(0.02, function() self.scrollview:assignPage(precent) end)
            tempObj = nil
        end)
end

-- 第2部分：中间内容的刷新
function lingwangta:chapterRefreashData()
    if isOldData == selectID then
        return
    end
    isOldData = selectID
    self._data = TableReader:TableRowByID("towerChapter_config", selectID)
    self.sectionDes.text = self._data.desc
    if (tempModel ~= self._data.model) then
        self.model:LoadByModelId(self._data.model, "idle", function() end, false, 0, self._data.big / 1000)
        tempModel = self._data.model
    end
	local type1 = self._data.drop[0].type
	local type2 = self._data.drop[1].type

    local itemList = {}

	if type2 == "item" then 
		local item = uItem:new(self._data.drop[1].arg2)
		self.soul:setImage(item:getHead())
	else 
		self.soul:setImage(Tool.getResIcon(type2), "itemImage")
	end 
	
	self.money:setImage(Tool.getResIcon(type1), "itemImage")
    self.moneyLab.text = self._data.drop[0].arg
    self.soulLab.text = self._data.drop[1].arg
    self.zhanliLab.text = toolFun.moneyNumberShowOne(math.floor(tonumber(self._data.power)))
    self.indexLab.text = string.gsub(TextMap.GetValue("LocalKey_743"),"{0}",selectID)
    local dropCount = self._data.probdrop.Count - 1
    self.extraGet:SetActive(false)
    if dropCount == -1 then
        self.extraGet:SetActive(true)
    end
    --print_t(self._data.probdrop)
    for i = 0, dropCount do
        if i <= dropCount then
            local vo = {}
            local itemType = ""
            local itemNum
            -- if lingwangta:typeId(self._data.probdrop[i]["type"]) then
            --     local itemobj = TableReader:TableRowByID(self._data.probdrop[i]["type"], self._data.probdrop[i]["arg"])
            --     vo = itemvo:new(self._data.probdrop[i]["type"], 1, itemobj.id, 1, "1")
            --     itemobj = nil
            -- else
            --     vo = itemvo:new(self._data.probdrop[i]["type"], 1, self._data.probdrop[i]["arg"], 1, "1")
            -- end
            --vo = itemvo:new(self._data.probdrop[i]["type"], 1, 1, 1, "1")
            if self._data.probdrop[i]["arg2"].Count > 1 then
                itemNum = self._data.probdrop[i]["arg2"][0].."~"..self._data.probdrop[i]["arg2"][1]
            else
                itemNum = self._data.probdrop[i]["arg2"][0]
            end
            if Tool.typeId(self._data.probdrop[i]["type"]) then
                vo = itemvo:new(self._data.probdrop[i]["type"], 1, self._data.probdrop[i]["arg"])
            elseif self._data.probdrop[i]["type"] == "item" then
                vo = itemvo:new(self._data.probdrop[i]["type"], itemNum, self._data.probdrop[i]["arg"])
            end
			vo.isShowName = true
            if self._data.probdrop[i]["arg2"] ~= nil then 
                if self._data.probdrop[i]["arg2"].Count > 1 then 
                    vo.minDrop = self._data.probdrop[i]["arg2"][0]
                    vo.maxDrop = self._data.probdrop[i]["arg2"][1]
                else
                    vo.minDrop = self._data.probdrop[i]["arg2"][0]
                end
            end
            table.insert(itemList, vo)
            -- if itemBind[i] == nil then
            --     local infobinding = ClientTool.loadAndGetLuaBinding("Prefabs/moduleFabs/chapterModule/chapterItemCell", self.itemGrid.gameObject)--Prefabs/moduleFabs/qiancengta/ItemCell
            --     itemBind[i] = infobinding
            --     infobinding = nil
            -- end
            -- itemBind[i].gameObject:SetActive(true)
            -- itemBind[i]:CallUpdate(vo)
        else
            -- if itemBind[i] ~= nil then
            --     itemBind[i].gameObject:SetActive(false)
            -- end
        end
    end
    self.itemTable:refresh("Prefabs/moduleFabs/chapterModule/chapterItemCell", itemList)
    --self.itemGrid.repositionNow = true
    lingwangta:isSHowTiaozhan()
end

--  第3部分：宝箱状态的刷新
function lingwangta:showAwardBox()
    isHaveAward = false
    isHaveCanGetAward = false
    analogData = {}
    for i = 0, (totelNum + 1), 3 do
        if i % 3 == 0 then
            if lingwangta:GetAwardState(i) == 2 then
                isHaveCanGetAward = true
                isHaveAward = true
            end
            if lingwangta:GetAwardState(i) == 1 then
                isHaveAward = true
            end
        end
    end

    self.boxButton.gameObject:SetActive(true)

    self.UI_Vipbaoxiang:SetActive(false)
    
    if isHaveCanGetAward == true then
        self.UI_Vipbaoxiang:SetActive(true)
    end

    -- if isHaveAward == false then
    --     self.boxButton.gameObject:SetActive(false)
    --     return
    -- elseif isHaveCanGetAward == true then
    --     self.boxButton.gameObject:SetActive(true)
    --     self.UI_Vipbaoxiang:SetActive(true)
    --     self.boxSprite.gameObject:SetActive(true)
    -- end
end

--每一层宝箱可领取以及状态
function lingwangta:GetAwardState(index)
    local state = 0 --已经领取
    if index < Player.qianCengTa.lastTower and Player.qianCengTa.specialBox[index] == 0 then
        return state
    end
    state = 1 --未完成
    if Player.qianCengTa.specialBox[index] ~= 0 then
        state = 2 --可领取
    end
    return state
end

--点击切换
function lingwangta:callBackClick(id, sprite)
    if isHaveSelect == false then
        isHaveSelect = true
    end
    if selectSprite ~= nil then
        selectSprite:onRefeashSelecteState()
    end
    selectSprite = sprite
    selectSprite:onRefeashSelecteState()
    selectID = id
    lingwangta:chapterRefreashData()
end

--挑战按钮状态的刷新
function lingwangta:isSHowTiaozhan()
    if selectID ~= Player.qianCengTa.currentTower or saodangLeftTime > 0 then
        self.tiaozhanBtn.isEnabled = false
    else
        if Player.qianCengTa.isPassTower then
            self.tiaozhanBtn.isEnabled = false
        else
            self.tiaozhanBtn.isEnabled = true
        end
    end
end

--扫荡倒计时函数
function lingwangta:updateNorTime()
    -- saodangLeftTime = Player.qianCengTa.sweepTime
    saodangLeftTime = Player.qianCengTa:getLong("sweepTime")
    saodangLeftTime = ClientTool.GetNowTime(saodangLeftTime)
    if saodangLeftTime > 0 then
        local time = Tool.FormatTime(saodangLeftTime)
        time = TextMap.GetValue("Text1354") .. time .. "[-]"
        self.daojishiLab.text = time
        time = nil
    else
        Api:checkRes(function()
            --lingwangta:updateTime()
            saodangLeftTime = Player.qianCengTa:getLong("sweepTime")
            saodangLeftTime = ClientTool.GetNowTime(saodangLeftTime)
            if saodangLeftTime < 0 then
                saodangLeftTime = 0
                self.daojishiLab.gameObject:SetActive(false)
                self.add_chongzhi.gameObject:SetActive(true);
                self.lbl_ke_chongzhi_times.text = TextMap.GetValue("Text1353") .. self:getKeChongzhiTimes()
                self.tiaozhanBtn.isEnabled = true
                self.saodangBtn.isEnabled = true
                self.chongzhiBtn.isEnabled = true
                lingwangta:isSHowTiaozhan()
                MessageMrg.show(TextMap.GetValue("Text1355"))
                self.scrollview:assignPage(totelNum - self._currentTown)
				print("remove ......................................................")
                UluaModuleFuncs.Instance.uTimer:removeSecondTime("qiancengtaTimes")
                lingwangta:updateTime()
            else
                return
            end
        end)
    end
end

function lingwangta:typeId(_type)
    local typeAll = { "equip", "equipPiece", "item", "char", "charPiece", "reel", "reelPiece",--[["honor"]]}
    for i, j in pairs(typeAll) do
        if _type == j then
            return true
        end
    end
    return false
end

--赋值完毕
-------------------------------------------------------------------------------------------------------------

--挑战API
function lingwangta:challgeHandler()
    if selectID ~= Player.qianCengTa.currentTower then
        MessageMrg.show(TextMap.GetValue("Text1356"))
        return
    end

    TableReader:ForEachLuaTable("zhengzhanConfig", function(index, item)
        if item.name == TextMap.GetValue("Text_1_342") then
            self.returnId = item.droptype[0]
        end
        return false
    end)

    Api:QCTChallenge(selectID,
        function(result)
            local fightData = {}
            isHaveSelect = false
            fightData["battle"] = result
            fightData["mdouleName"] = "qiancengta"
            fightData["selectID"] = selectID
            fightData["returnId"] = self.returnId
            Events.Brocast("ToRoot")
            UIMrg:pushObject(GameObject())
            UluaModuleFuncs.Instance.uOtherFuns:callBackFight(fightData)
            fightData = nil
            self:showAwardBox()
            self.tiaozhanBtn.isEnabled = true --防止多次点击
        end,
        function(result)
            self.tiaozhanBtn.isEnabled = true
        end)
end

function lingwangta:SendResetAPI_2(dlg)
    Api:resetByTicket(function(result)
        self.updateForBuyBpAOrSoul()
        if dlg ~= nil then
            if dlg.refreash ~= nil then
                dlg:refreash()
            end
            if dlg.showMoveDlg ~= nil then
                dlg:showMoveDlg()
            end
        end
    end)
end

--重置逻辑
function lingwangta:resetHandler()
    if Player.qianCengTa.currentTower == 1 then
        MessageMrg.show(TextMap.GetValue("Text1357"))
        self.chongzhiBtn.isEnabled = true
        return
    end
    local freeTime = TableReader:TableRowByID("tower_config", "freeResetTimes").args1 --每日可免费次数
    if Player.qianCengTa.resetTimes < freeTime then
        DialogMrg.ShowDialog(TextMap.GetValue("Text1358"),
            function()
                lingwangta:sendResetAPI()
            end,
            function()
                isHaveSelect = false
                self.chongzhiBtn.isEnabled = true --防止多次点击
            end)
        return
    end
    if self:getKeChongzhiTimes() > 0 then
        self:sendResetAPI()
        return
    end

    if vipResetData[1] == nil then
        TableReader:ForEachLuaTable("resetChapter",
            function(index, item)
                if item.type == 9 then --9表示为千层塔副本
					if Player.Info.vip >= item.vip then 
						vipResetData[item.reset_time] = item
					end
                end
                return false
            end)
    end
    if vipResetData[Player.qianCengTa.buyTimes + 1] ~= nil then
        if Player.Info.vip >= vipResetData[Player.qianCengTa.buyTimes + 1].consume[1].consume_arg then
            lingwangta:NeedChongzhi(string.gsub(TextMap.GetValue("LocalKey_801"),"{0}",vipResetData[Player.qianCengTa.buyTimes + 1].consume[0].consume_arg), false)
        else
            lingwangta:NeedChongzhi(TextMap.GetValue("Text_1_974"), true)
        end
    else
        self.chongzhiBtn.isEnabled = true
        MessageMrg.show(TextMap.GetValue("Text_1_975"))
    end
end

function lingwangta:BuyBpAOrSoul_Change()
    self:updateForBuyBpAOrSoul()
end

-- 获取可重置次数
function lingwangta:getKeChongzhiTimes()
    local freeTime = TableReader:TableRowByID("tower_config", "freeResetTimes").args1 --每日可免费次数
	local times = freeTime + Player.qianCengTa.buyTimes - Player.qianCengTa.resetTimes
	--local count = 0
    --TableReader:ForEachLuaTable("resetChapter",
    --    function(index, item)
    --        if item.type == 9 then --9表示为千层塔副本
	--			if Player.Info.vip >= item.vip then 
	--				count = count + 1
	--			end
    --        end
    --        return false
    --    end)
		
    if (times) > 0 and self._currentTown > 1 then
        self.redPoint.gameObject:SetActive(true)
        self.chongzhiBtn.isEnabled = true
    else
        self.redPoint.gameObject:SetActive(false)
        --self.chongzhiBtn.isEnabled = false
    end

    return times
end

function lingwangta:updateForBuyBpAOrSoul()
    local times = lingwangta:getKeChongzhiTimes()
    lingwangta.lbl_ke_chongzhi_times.text = TextMap.GetValue("Text1353") .. times
    lingwangta.chongzhiBtn.isEnabled = true
end

function lingwangta:NeedChongzhi(str, bol)
    self.chongzhiBtn.isEnabled = true
    DialogMrg.ShowDialog(str,
        function()
            if bol then
                DialogMrg.chognzhi()
            else
                lingwangta:sendBuyTimes()
            end
        end,
        function()
            self.chongzhiBtn.isEnabled = true
        end)
end

function lingwangta:sendBuyTimes()
	Api:QCTBuyTimes(function(result)
        lingwangta:setDatas()
        --self.chongzhiBtn.isEnabled = true --防止多次点击
    end,
        function(result)
           -- self.chongzhiBtn.isEnabled = true
        end)
end

function lingwangta:sendResetAPI()
    Api:QCTReset(function(result)
        isHaveSelect = false
        lingwangta:setDatas()
        self.chongzhiBtn.isEnabled = true --防止多次点击
    end,
        function(result)
            self.chongzhiBtn.isEnabled = true
        end)
end

--扫荡逻辑
function lingwangta:QCTRweep()
    if Player.qianCengTa.currentTower == Player.qianCengTa.lastTower then
        MessageMrg.show(TextMap.GetValue("Text1359"))
        self.saodangBtn.isEnabled = true
        return
    end
    local linkData = Tool.readSuperLinkById( 132)
    if linkData ~= nil then
        local lockArg = linkData.unlock[0].arg
        local lockType = linkData.unlock[0].type
        local lockdes = linkData.from
        if lockType == "level" then
            if Player.Info.level < lockArg then
                local msg = string.gsub(TextMap.GetValue("LocalKey_664"),"{0}",lockArg)
                MessageMrg.show(string.gsub(msg,"{1}",lockdes))
                linkData = nil
                return
            end
        end
        if lockType == "vip" then
            if Player.Info.vip < lockArg then
                MessageMrg.show("VIP" .. lockArg .. "," .. lockdes)
                linkData = nil
                return
            end
        end
    end
    linkData = nil
    Api:QCTRweep(function(result)
        isHaveSelect = false
        self.saodangBtn.isEnabled = true --防止多次点击
        lingwangta:setDatas()
        if Player.Info.vip >= TableReader:TableRowByID("tower_config", "removeCD").args1 then
            MessageMrg.show(TextMap.GetValue("Text1355"))
        end
    end,
        function(result)
            self.saodangBtn.isEnabled = true
        end)
end

function lingwangta:getAward()
    UIMrg:pushWindow("Prefabs/moduleFabs/qiancengta/boxGet", self)
end

local isNeedFreash = true
function lingwangta:onEnter()
    if self._onExit ~= true then return end
    if isNeedFreash then
        self.binding:CallManyFrame(function()
            lingwangta:updateTime()
        end)
    end
    self._onExit = false
    self.topMenu = LuaMain:ShowTopMenu(6, nil, {[1]={type="honor"},[2]={type="money"},[3]={type="gold"}})
    self.ziyuanNum.text =toolFun.moneyNumberShowOne(math.floor(tonumber(Tool.getCountByType(sell_type))))
end

function lingwangta:onExit()
    self._onExit = true
end

function lingwangta:onClick(go, name)
    isNeedFreash = true
    if name == "ruleBtn" then
        UIMrg:pushWindow("Prefabs/moduleFabs/qiancengta/qiancengta_rule", { 5 })
    elseif name == "tiaozhanBtn" then
        if Tool:judgeBagCount(self._data.drop) == false  then return end
        self.tiaozhanBtn.isEnabled = false
        lingwangta:challgeHandler()
    elseif name == "shopBtn" then
        isNeedFreash = false
        LuaMain:showShop(5) --远征商店
    elseif name == "buzhenBtn" then
        isNeedFreash = false
        Tool.push("team", "Prefabs/moduleFabs/formationModule/formation/formation_main", { 0 })
    elseif name == "saodangBtn" then
        if Tool:judgeBagCount(self._data.drop) == false then return end
        lingwangta:QCTRweep()
    elseif name == "chongzhiBtn" then
        if self.saodangBtn.isEnabled == false then -- 正在扫荡倒计时,不到重置
        MessageMrg.show(TextMap.GetValue("Text1360"))
        else
            self.chongzhiBtn.isEnabled = false
            lingwangta:resetHandler()
        end
    elseif name == "boxButton" then
        lingwangta:getAward()
    elseif name == "btn_add_chongzhitimes" then
        DialogMrg:BuyBpAOrSoul("lwl", "", toolFun.handler(self, self.updateForBuyBpAOrSoul),
            toolFun.handler(self, self.BuyBpAOrSoul_Change),
            toolFun.handler(self, self.SendResetAPI_2))
	elseif name == "btnBack" then 
		UIMrg:pop()
    elseif name == "Btn_buzhen" then 
        LuaMain:showFormation(0)
	elseif name == "btn_jingying" then 
		UIMrg:pushWindow("Prefabs/moduleFabs/qiancengta/qiancengta_jingying", {})
    end
end

function lingwangta:update(tables)
    self:updateForBuyBpAOrSoul()
end

--初始化
function lingwangta:create(binding)
    self.binding = binding
    return self
end

return lingwangta
