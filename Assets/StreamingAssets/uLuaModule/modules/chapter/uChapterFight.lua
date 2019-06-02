local chapterFight = {}
local selectPanel = {}
local currentFightTimes = 0
ThisChapterMonsterNumber = 0
local isClick = false --点击按钮的唯一性
local isOverTimes = false
--关闭奖励显示
local lastSDQ = 0
local chapterObj = {}
local totaltimes = -1 --可挑战的次数-1
local isBossChapter = false

--关卡类型，关卡小节ID，关卡扫荡最大次数,本框最小章节ID，本框最大章节ID（普通关卡采用）
function chapterFight.Show(type, senceID, otherArge, star, full)
    local tempObj = {}
    tempObj.chapterType = type
    tempObj.senceID = senceID
    tempObj.otherArge = otherArge -- 其他参数   -1表示是超链接打开
	tempObj.star = star
	tempObj.full = full
    if UIMrg:GetRunningModuleName() == "chapterFight" then
        UIMrg:pushWindow("Prefabs/moduleFabs/chapterModule/chapterFight", tempObj) --"chapterFight"
    else
        UIMrg:pushWindow("Prefabs/moduleFabs/chapterModule/chapterFight", tempObj)
    end --如果当前最外层的模块等于你要打开的模块
    tempObj = nil
end

function chapterFight:update(table)
    self.table = table
    self._chapterType = table.chapterType
    self._senceID = table.senceID
	self.full = table.full
    self.go_taoren:SetActive(false)
    self.Sprite_hasGet.gameObject:SetActive(false)
    if self._chapterType == "commonChapter" then
        self.starPrefabs:setStar(Player.Chapter.status[self._senceID].star)
    elseif self._chapterType == "hardChapter" then
        self.starPrefabs:setStar(Player.HardChapter.status[self._senceID].star)
    elseif self._chapterType == "heroChapter" then
       --self.starPrefabs:setStar(Player.NBChapter.status[self._senceID].star)
       self.starPrefabs.gameObject:SetActive(false)
	elseif self._chapterType == "invadeChapter" then 
		self.starPrefabs.gameObject:SetActive(false)
		self.go_taoren:SetActive(true)
		self.fightTimes.gameObject:SetActive(false)
		self.btn_close.gameObject:SetActive(true)
		self.sectionName.gameObject.transform.localPosition = Vector3(self.sectionName.gameObject.transform.localPosition.x, 115, 0)
		chapterObj = TableReader:TableRowByUniqueKey(self._chapterType, self._senceID, table.otherArge)
	end
	if self._chapterType ~= "invadeChapter" then 
		chapterObj = TableReader:TableRowByID(self._chapterType, self._senceID) --拿到关卡数据
	end 
    self.power:SetActive(chapterObj.power ~= nil)
    if chapterObj.power ~= nil then 
        self.txt_power.text = chapterObj.power
    end 
	self.textureEasy:LoadByModelId(chapterObj.model, "idle", function() end, false, 2, 1)
    self._otherArge = table.otherArge
    if self._chapterType == "commonChapter" or self._chapterType == "heroChapter" or chapterObj.fight_times <= 0  then
        self.fightTimes.text = ""
        self.fightTimes.gameObject:SetActive(false)
    end
    self:setData()
	
	if self._chapterType == "commonChapter" then 
		if self.hintMsg == nil then
			if Player.Info.level >= 5 and Player.Info.level <= 15 then 
				self.hintMsg = ClientTool.load("Prefabs/moduleFabs/chapterModule/gui_chapter_hint", self.challengeBtn.gameObject)
				self.hintMsg.transform.localPosition = Vector3(-114, -5, 0)
				local panel = self.hintMsg:GetComponent(UIPanel)
				panel.depth = 20
			end 
		else
			if Player.Info.level >= 5 and Player.Info.level <= 15 then 
				self.hintMsg:SetActive(true)
			end
		end
	else 
		if self.hintMsg ~= nil then
			--if Player.Info.level >= 5 and Player.Info.level <= 15 then 
				self.hintMsg:SetActive(false)
			--end
		end 
	end 
end

function chapterFight:setCanFightTimes()
    self.challengeBtn.isEnabled = true
	if self._chapterType ~= "invadeChapter" then 
		self.hasFight.text = TextMap.GetValue("Text_1_203")
		self.fightTimes.gameObject:SetActive(true)
	else 
	    self.hasFight.text = TextMap.GetValue("Text_1_204")
	end
    self.firstWin:SetActive(false)
    self.LastHeroCGet:SetActive(false)

    self.times = chapterObj.fight_times - Player.Chapter.status[self._senceID].fight
    if self._chapterType == "hardChapter" then
        self.times = chapterObj.fight_times - Player.HardChapter.status[self._senceID].fight
    end
    if self._chapterType == "heroChapter" then
        self.times = chapterObj.fight_times - Player.NBChapter.status[self._senceID].fight
        local ss = TableReader:TableRowByID("heroChapter", self._senceID)
        if ss.section == 4 then 
            self.LastHeroCGet:SetActive(true) 
            print_t(chapterObj.firstdrop[1])
            self.Label.text=TableReader:TableRowByID("item", chapterObj.firstdrop[1].arg).name .. " x" .. chapterObj.firstdrop[1].arg2
        end
        if Player.NBChapter.status[self._senceID].star > 0 then
            self.Sprite_hasGet.gameObject:SetActive(true)
        end
        self.fightTimes.gameObject:SetActive(false)
        self.firstWin:SetActive(true)
        self.moneynum.text=chapterObj.firstdrop[0].arg
        if self.times <= 0 then
            self.hasFight.text = TextMap.GetValue("Text_1_205")
            self.challengeBtn.isEnabled = false
        end
    end
    if chapterObj.fight_times <= 0 then
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

    self.fightTimes.text = TextMap.GetValue("Text15") .. self.times .. "/" .. chapterObj.fight_times
end

function chapterFight:setData()
    chapterFight:setCanFightTimes()
    chapterFight:chapterRefreashData()
    self.sectionName.text = chapterObj["name"]
    self.txt_mes.text = chapterObj["desc"]
    self.moneyLabel.text = chapterObj.money
    if chapterObj.exp_type == nil or chapterObj.exp_type == "exp" then
        self.expLabel.text = chapterObj.exp 
    else
        self.expLabel.text = chapterObj.exp * Player.Info.level
    end
    self.soulLabel.text = chapterObj.soul
    self.energyNeed.text = TextMap.GetValue("Text497") .. chapterObj.consume[0].consume_arg
    self.tempItemData = {}
    self.dropTypeList = {}
    local dropCount = chapterObj.probdrop.Count - 1
   
    if dropCount > 3 then --因为界面上最多显示4个格子
    dropCount = 3
    end
    for i = 0, dropCount do
        --local itemobj = TableReader:TableRowByUnique(chapterObj.probdrop[i]["type"], "id", chapterObj.probdrop[i]["arg"])
        local vo = itemvo:new(chapterObj.probdrop[i]["type"], 1, chapterObj.probdrop[i]["arg"], 1, "1")
		if chapterObj.probdrop[i]["arg2"] ~= nil then 
			if chapterObj.probdrop[i]["arg2"].Count > 1 then 
				vo.minDrop = chapterObj.probdrop[i]["arg2"][0]
				vo.maxDrop = chapterObj.probdrop[i]["arg2"][1]
			else 
				vo.minDrop = chapterObj.probdrop[i]["arg2"][0]
			end 
		end 
        self.tempItemData[i + 1] = vo
        table.insert(self.dropTypeList, vo.itemType)
    end
    if self.tempItemData ~= nil then
        table.sort(self.tempItemData, function(a, b)
            return a.itemTrueColor > b.itemTrueColor
        end)
    end
    for j = 0, dropCount do
        local infobinding = ClientTool.loadAndGetLuaBinding("Prefabs/moduleFabs/chapterModule/chapterItemCell", self.itemTable.gameObject)
        infobinding:CallUpdate(self.tempItemData[j + 1])
        infobinding = nil
        vo = nil
    end
    --teamObj = nil
    self.itemTable.repositionNow = true
end

function chapterFight:fightError()
    isClick = false
end

--回调战斗函数
function chapterFight:fightIng(arr)
    if arr == nil then
        DialogMrg.ShowDialog(TextMap.GetValue("Text83"))
        return
    end

    --2015 3.10 日 每打一个关卡都需要测试是否超过等级
    if self._chapterType == "commonChapter" then
        local chapterObj = TableReader:TableRowByID("commonChapter", self._senceID) --拿到关卡数据
        if chapterObj == nil then
            MessageMrg.show(TextMap.GetValue("Text498"))
            return
        end
        isBossChapter = false
        if isBossChapter == 1 then
            isBossChapter = true
        end
        local item = TableReader:TableRowByUniqueKey("chapter", chapterObj.chapter, self._chapterType)
        if item.unlock["0"].unlock_arg > Player.Info.level then --当前等级能开启的最大章节
        MessageMrg.show(TextMap.GetValue("Text499"))
        return
        end
    end

    self.teamId = 0
	if self._chapterType ~= "invadeChapter" then 
		self:fightChapter(chapterObj, arr)
	else 
		self:taoRenRuQing(chapterObj)
	end 
end

function chapterFight:fightChapter(chapterObj, arr)
	Api:fightChapter(self._chapterType, self._senceID, arr, self.teamId, function(result)
        UIMrg:popWindow()
        if result.daxuName then
            DAXU_NAME = result.daxuName
        else
            DAXU_NAME = nil
        end

        local fightData = {}
        fightData["battle"] = result
        if self._chapterType == "commonChapter" or self._chapterType == "hardChapter" or self._chapterType == "heroChapter" then
            fightData["mdouleName"] = self._chapterType
            fightData["chapter_zj"] = chapterObj.chapter --当前章节
            fightData["chapter_xj"] = chapterObj.section -- 当前小节
            fightData["chapter_sl"] = self._otherArge --如果为-1 则是超链接打开
            if self._chapterType == "commonChapter" and chapterObj.chapter == 1 then
                fightData["isBoss"] = false
            else
                fightData["isBoss"] = chapterObj.boss == 1 or false
            end
            fightData["modulePrefabUrl"] = "Prefabs/moduleFabs/chapterModule/chapterModule_new"
            if GlobalVar.currentScene == "main_scene" and self._otherArge ~= -1 then
                UIMrg:popWindow()
            end
        end
        fightData["id"] = 0
        UluaModuleFuncs.Instance.uOtherFuns:callBackFight(fightData)
        fightData = nil
    end, function(ret)
        isClick = false
        if (tonumber(ret) == 64) then
            Api:checkUpdate(function()
                UIMrg:popWindow()
                UIMrg:pop()
                LuaMain:openWithSound(6)
            end)
        end
        return false
    end)
end

function chapterFight:taoRenRuQing()
	Api:fightNinjaIntrusion(self._senceID, self._otherArge, function(result)
		UIMrg:popWindow()
        local fightData = {}
        fightData["battle"] = result
        fightData["mdouleName"] = self._chapterType
        fightData["chapter_zj"] = self._senceID --当前章节
        fightData["chapter_xj"] = self._otherArge -- 当前小节
        fightData["chapter_sl"] = self._otherArge --如果为-1 则是超链接打开
		fightData["full"] = self.full
        fightData["modulePrefabUrl"] = "Prefabs/moduleFabs/chapterModule/chapterModule_new"
        if GlobalVar.currentScene == "main_scene" and self._otherArge ~= -1 then
            UIMrg:popWindow()
        end
        fightData["id"] = 0
		UIMrg:pushObject(GameObject())
        UluaModuleFuncs.Instance.uOtherFuns:callBackFight(fightData)
        fightData = nil
	end, function(ret)
        isClick = false
        if (tonumber(ret) == 64) then
            Api:checkUpdate(function()
                UIMrg:popWindow()
                UIMrg:pop()
                LuaMain:openWithSound(6)
            end)
        end
        return false
    end)
end

function chapterFight:sureBuy()
    Api:resetChapter(self._chapterType, self._senceID, function()
        self.resetBtn.gameObject:SetActive(false)
        self.challengeBtn.gameObject:SetActive(true)
        chapterFight:setCanFightTimes()
        chapterFight:setLeftBtnText()
        isOverTimes = false
    end, nil)
end

--点击扫荡
--2014.12.26 新需求，直接取消单次扫荡
--2015.1.16 新需求，要回单次扫荡，取消10次扫荡
--2015.1.28 新需求，要可选扫荡次数
function chapterFight:saodangFun(goName)
    linkData = nil
    local chapterObj = TableReader:TableRowByID(self._chapterType, self._senceID) --有可能读取不到任何值
    if self._chapterType == "heroChapter" and chapterFight:getTotaltimes() <= 0 then
        MessageMrg.show(TextMap.GetValue("Text501"))
        chapterObj = nil
        return
    --elseif self._chapterType == "hardChapter" and (chapterObj.fight_times - Player.HardChapter.status[self._senceID].fight) <= 0 then
    --    MessageMrg.show(TextMap.GetValue("Text501"))
    --    chapterObj = nil
    --    return
    elseif chapterObj.consume[0].consume_arg > Player.Resource.bp then
        DialogMrg:BuyBpAOrSoul("bp", TextMap.GetValue("Text2"), nil)
        chapterObj = nil
        return
    end



---------- self.saodangState    1:体力满足直接扫荡  2：体力满足部分扫荡次数,扫荡的时候需处理  3：体力不足提示使用体力道具   4:fb次数为0重置副本

    -- local temp = {}
    -- temp._chapterType = self._chapterType
    -- temp._senceID = self._senceID
    -- temp._saodangMulVIP = self.saodangMulVIP
    -- temp._saodangDeVip = self.saodangDeVip
    -- temp._go = self.binding.gameObject
    -- temp._targert = self
    -- temp._needdp = chapterObj["consume"][0].consume_arg
    -- UIMrg:pushWindow("Prefabs/moduleFabs/chapterModule/saodang", temp)
    -- temp = nil





    local linkDatatwo = {}
    if self._chapterType == "commonChapter" then
        linkDatatwo = Tool.readSuperLinkById( 129)
    elseif self._chapterType == "hardChapter" then
        linkDatatwo = Tool.readSuperLinkById( 130)
    elseif self._chapterType == "heroChapter" then
        linkDatatwo = Tool.readSuperLinkById( 131)
    end
    if linkDatatwo ~= nil then
        local lockArg = linkDatatwo.unlock[0].arg   
        local lockArg2 = linkDatatwo.unlock[0].arg2 
		if lockArg2 == "" then lockArg2 = 0 end
        local lockType = linkDatatwo.unlock[0].type  
        local lockdes = linkDatatwo.from
		local msg = ""
        if lockType == "level" then
            if Player.Info.level < lockArg and Player.Info.vip < lockArg2 then
				msg=string.gsub(TextMap.GetValue("LocalKey_663"),"{0}",lockArg)
                msg=string.gsub(msg,"{1}",lockArg2)
                MessageMrg.show(msg)
                linkDatatwo = nil
                --UIMrg:popWindow()
                return
            end
        end
        if lockType == "vip" then
            if Player.Info.vip < lockArg then
                MessageMrg.show("VIP" .. lockArg .. "," .. lockdes)
                linkDatatwo = nil
                --UIMrg:popWindow()
                return
            end
        end
    end

    linkData = nil
    local saodangCount = 0
    if self.saodangState == 1 then
        saodangCount = self.times
    elseif self.saodangState == 2 then
        saodangCount = Player.Resource.bp / chapterObj["consume"][0].consume_arg
    elseif self.saodangState == 3 then
        DialogMrg:BuyBpAOrSoul("bp", TextMap.GetValue("Text2"), nil)
        chapterObj = nil
        return
    elseif self.saodangState == 4 then
        chapterFight:resetHeroChapter()
        return
    end

    if saodangCount > 10 then
        saodangCount = 10
    end
    local tmpsao = {}
    tmpsao.saodangCount = saodangCount
    tmpsao._chapterType = self._chapterType
    tmpsao._senceID = self._senceID
    tmpsao.delegate = self

    self.uSaodangList = UIMrg:pushWindow("Prefabs/moduleFabs/chapterModule/saodang_result", tmpsao)  
     --self.uSaodangList:CallUpdateWithArgs(tmpsao)
end

function chapterFight:onClick(go, name)
    if isClick == true then
        return
    end
    if name == "challengeBtn" then
        if Tool:judgeBagCount(self.dropTypeList, 4, true) == false then return end
        isClick = true
        --local chapterObj = TableReader:TableRowByID(self._chapterType, self._senceID)
        --if self._chapterType == "heroChapter" and Player.NBChapter.status[self._senceID].fight == 0 then
        if self._chapterType == "heroChapter" and chapterFight:getTotaltimes() <= 0 and (chapterObj.fight_times - Player.NBChapter.status[self._senceID].fight) == 0 then
            MessageMrg.show(TextMap.GetValue("Text501"))
            isClick = false
            --chapterObj = nil
            --chapterFight:resetHeroChapter()
            return

        elseif self._chapterType == "hardChapter" and (chapterObj.fight_times - Player.HardChapter.status[self._senceID].fight) < 0 then
            MessageMrg.show(TextMap.GetValue("Text501"))
            isClick = false
            chapterObj = nil
            return

        elseif chapterObj.consume[0].consume_arg > Player.Resource.bp then
            DialogMrg:BuyBpAOrSoul("bp", TextMap.GetValue("Text2"), nil)
            isClick = false
            return
        else
            chapterFight:fightIng(LuaMain:getTeamByIndex(0))
        end
    elseif name == "saodang" then
        if Tool:judgeBagCount(self.dropTypeList, 4, true) == false  then return end
        self:saodangFun()
    elseif name == "resetBtn" then
		-- 重置已经放在左边按钮功能里
        --chapterFight:resetHeroChapter()
	elseif name == "btnClose" then
		UIMrg:popWindow()
	elseif name == "btn_close" then 
		UIMrg:popWindow()
	elseif name == "btn_formation" then
		LuaMain:showFormation(0)
    end
end

function chapterFight:closeWindow()
    UIMrg:popWindow()
end

function chapterFight:resetHeroChapter()
    if self._chapterType == "commonChapter" or self._chapterType == "hardChapter" then
        local resetTime = Player.Chapter.status[self._senceID].reset
        if self._chapterType == "hardChapter" then
            resetTime = Player.HardChapter.status[self._senceID].reset
        end
        

        local nextTime = resetTime + 1
        local objRow = TableReader:TableRowByUniqueKey("resetChapter", nextTime, self._chapterType)
        if objRow == nil then
            MessageMrg.show(TextMap.GetValue("Text505"))
            return
        end
        if Player.Info.vip >= objRow.consume[1].consume_arg then
            local msg = string.gsub(TextMap.GetValue("LocalKey_668"),"{0}",nextTime)
            msg=string.gsub(msg,"{1}",objRow.consume[0].consume_arg)
            DialogMrg.ShowDialog(msg, funcs.handler(self, self.sureBuy))
        else
            DialogMrg.ShowDialog(TextMap.GetValue("Text506"), function() DialogMrg.chognzhi() end)
        end
    end
end

function chapterFight:updateForBuyBpAOrSoul()
end
--self.txt_rank.fontSize = 32
--关卡刷新 
function chapterFight:setLeftBtnText()
    --  self.saodangState    1:体力满足直接扫荡  2：体力满足部分扫荡次数,扫荡的时候需处理  3：体力不足提示使用体力道具   4:fb次数为0重置副本
	if self.times > 0 then
        self.saodangbtn_txt.fontSize = 30
        local needbp = chapterObj["consume"][0].consume_arg   --关卡所需体力
        local playerbp = Player.Resource.bp                   --玩家体力
        local saodangtime = 10
        if math.floor(self.times) < saodangtime then
            saodangtime = math.floor(self.times)
        end
        if playerbp >= saodangtime * needbp  then
            self.saodangbtn_txt.text = string.gsub(TextMap.GetValue("LocalKey_782"),"{0}",saodangtime)
            self.saodangState = 1
        elseif  playerbp / needbp == 0 then
            self.saodangbtn_txt.text =string.gsub(TextMap.GetValue("LocalKey_782"),"{0}",saodangtime)
        else
            self.saodangbtn_txt.text =string.gsub(TextMap.GetValue("LocalKey_782"),"{0}",math.floor(playerbp / needbp))
            self.saodangState = 2
        end      
    else
        self.saodangbtn_txt.fontSize = 36
        self.saodangbtn_txt.text = TextMap.GetValue("Text_1_208")
		self.saodangcontent.gameObject:SetActive(true)
        self.saodangState = 4
    end
end
function chapterFight:chapterRefreashData()
    self.resetBtn.gameObject:SetActive(false)
    self.saodangcontent.gameObject:SetActive(false)
    if self._chapterType == "commonChapter" then
        if Player.Chapter.status[self._senceID].star == 3 then
            self.saodangcontent.gameObject:SetActive(true)
        end
		self:setLeftBtnText()
    elseif self._chapterType == "hardChapter" then
        if Player.HardChapter.status[self._senceID].star == 3 then
            self.saodangcontent.gameObject:SetActive(true)
        end
		self:setLeftBtnText()
        if Player.HardChapter.status[self._senceID].fight >= chapterObj.fight_times then
            --self.resetBtn.gameObject:SetActive(true)
			self.saodangcontent.gameObject:SetActive(true)
            self.challengeBtn.gameObject:SetActive(false)
        end
	elseif self._chapterType == "invadeChapter" then 

    end
    self.saodangNeed.text = TextMap.GetValue("Text507") .. Player.ItemBagIndex[26].count
end

function chapterFight:onEnter()
    isClick = false
    chapterFight:setCanFightTimes()
    chapterFight:chapterRefreashData()
end

function chapterFight:onClose()
    if GlobalVar.currentScene ~= "main_scene" then
        if self._chapterType == "commonChapter" or self._chapterType == "hardChapter" or  self._chapterType == "heroChapter"  then
            local chapters = TableReader:TableRowByID(self._chapterType, self._senceID).chapter
            UIMrg:popWindow()
        end
    else
        UIMrg:pop()
    end
end

function chapterFight:Start()
    self.saodangMulVIP = Tool.readSuperLinkById( 124).vipLevel --扫荡多次47408
    self.saodangDeVip = Tool.readSuperLinkById( 125).vipLevel --钻石扫荡
    if not GuideMrg.hasStep() then
        local row = TableReader:TableRowByID("GMconfig", 11)
		if Player.Info.level < 5 or Player.Info.level > 15 then 
			if row and row.args2 > Player.Info.level then
				if self._hand == nil then
					self._hand = ClientTool.load("Prefabs/publicPrefabs/guide_hand_chapter", self.challengeBtn.gameObject)
				end
				Tool.SetActive(self._hand, true)
			end
		end 
    end
end

function chapterFight:create(binding)
    self.binding = binding
    return self
end

-- 获取可挑战的次数
function chapterFight:getTotaltimes()
    if totaltimes == -1 then
        local row = TableReader:TableRowByID("heroChapter_config", "max_time")
        if row.args1 ~= nil and tonumber(row.args1) ~= nil then
            totaltimes = row.args1
        else
            totaltimes = 0
        end
    end
    local lefttimes = totaltimes + Player.NBChapter.resettimes - Player.NBChapter.totaltimes
    return lefttimes;
end

return chapterFight