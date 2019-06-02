local m = {}
ThisChapterMonsterNumber = 0
--local isClick = false --点击按钮的唯一性
local chapterObj = {} -- 关卡数据

function m:onEnter()
    print("lzh print:******** uLeague_Fight.lua ** onEnter()")
end

function m:Start()
    print("lzh print:******** uLeague_Fight.lua ** Start()")

    self.saodangMulVIP = Tool.readSuperLinkById( 124).vipLevel --扫荡多次
    self.saodangDeVip = Tool.readSuperLinkById( 125).vipLevel --钻石扫荡
    LuaMain:ShowTopMenu(1, funcs.handler(m, self.onClose))
    -- -- 加新手引导
    -- if not GuideConfig:isPlaying() then
    -- 	local row = TableReader:TableRowByID("GMconfig", 11)
    -- 	if row and row.args2 > Player.Info.level then
    -- 	    	if self._hand == nil then
    -- 	        		self._hand = ClientTool.load("Prefabs/publicPrefabs/guide_hand_chapter", self.challengeBtn.gameObject)
    -- 	    	end
    -- 	    	Tool.SetActive(self._hand, true)
    -- 	end
    -- end
end

--关卡类型，关卡小节ID，关卡扫荡最大次数,本框最小章节ID，本框最大章节ID（普通关卡采用）
function m.Show(type, senceID, chapterid, otherArge)
    local tempObj = {}
    tempObj.chapterType = type
    tempObj.chapterid = chapterid
    tempObj.senceID = senceID
    tempObj.otherArge = otherArge -- 其他参数   -1表示是超链接打开
    if UIMrg:GetRunningModuleName() == "leagueFight" then
        Tool.replace("leagueFight", "Prefabs/moduleFabs/leagueModule/league_fight", tempObj)
    else
        UIMrg:pushWindow("Prefabs/moduleFabs/leagueModule/league_fight", tempObj)
    end
    tempObj = nil
end

function m:update(table)
    self.table = table
    self._chapterType = table.chapterType
    self._senceID = table.senceID
    self.chapterid = table.chapterid
    --chapterObj= TableReader:TableRowByID(self._chapterType, self._senceID) --拿到关卡数据
    chapterObj = GuildDatas:getCopyDataByCopyid(self._senceID, self.chapterid) --拿到关卡数据
    self._otherArge = table.otherArge
    --if  self._chapterType=="commonChapter" or self._chapterType=="heroChapter" then
    --	self.fightTimes.gameObject:SetActive(false)
    --end
    self:setData()
end

function m:setData()
    print("-------------------------------")
    --self:setCanFightTimes()
    -- 章节名称
    self.sectionName.text = chapterObj["name"]
    -- 章节描述
    self.sectionDes.text = chapterObj["desc"]
    --self.moneyLabel.text = chapterObj.money
    --self.expLabel.text = chapterObj.exp
    --self.soulLabel.text = chapterObj.soul
    -- 加载3d模型
    --self.textureModel:LoadByModelId(chapterObj.model, "stand", function() end, false, 0, chapterObj.big / 1000)
    -- print(chapterObj.model)
    self.textureModel:LoadByModelId(chapterObj.model, "stand", function() end)
    --生命值
    -- print(self.table.otherArge.totalHp)
    -- print(self.table.otherArge.totalMaxHp)
    self.txt_hp.text = self.table.otherArge.totalHp .. "/" .. self.table.otherArge.totalMaxHp
    self.slider_hp.value = self.table.otherArge.totalHp / self.table.otherArge.totalMaxHp
    --公会经验
    -- print(chapterObj)
    -- print(chapterObj.killer_drop)
    local drops = chapterObj.killer_drop
    local count = drops.Count
    for i = 0, count - 1 do
        if drops[i].type == "exp" then
            self.txt_leagueexp_num.text = "+" .. drops[i].arg
            break
        end
    end
    --帮贡数量
    --local min = 0
    --- local max = 0
    -- min,max = self:getDonateReward()
    -- chapterObj.min_donate
    self.txt_shuliang_num.text = chapterObj.min_donate .. "-" .. chapterObj.max_donate
    -- 提示
    local killer_drop = chapterObj.killer_drop
    local count2 = killer_drop.Count
    local dropItem={}
    for i = 0, count2 - 1 do
        if killer_drop[i].type == "donate" then
            self.txt_tips.text = TextMap.GetValue("Text1240") .. killer_drop[i].arg .. ")"
            dropItem=RewardMrg.getDropItem({type=killer_drop[i].type,arg=killer_drop[i].arg,args2=killer_drop[i].arg2})
            if self.itemAll==nil then 
                self.itemAll = ClientTool.loadAndGetLuaBindingFromPool("Prefabs/publicPrefabs/itemAll", self.img_banggong.gameObject)
            end 
            self.itemAll:CallUpdate({ "char", dropItem, self.img_banggong.width, self.img_banggong.height, true, nil,nil,nil,false})
        end
    end
end

function m:fightError()
    --isClick = false
end

--回调战斗函数
function m:fightIng(arr)
    if arr == nil then
        DialogMrg.ShowDialog(TextMap.GetValue("Text83")) -- 请先进行布阵
        return
    end
    self.teamId = 0

    -- Api:fightChapter(self._chapterType, self._senceID, arr, self.teamId, function(result)
    -- 	local fightData = {}
    -- 	fightData["battle"] = result
    -- 	if self._chapterType == "commonChapter" or self._chapterType == "hardChapter" then
    -- 		fightData["mdouleName"] = self._chapterType
    -- 		fightData["chapter_zj"] = chapterObj.chapter --当前章节
    -- 		fightData["chapter_xj"] = chapterObj.section -- 当前小节
    -- 		fightData["chapter_sl"] =self._otherArge --如果为-1 则是超链接打开
    -- 		if  self._chapterType=="commonChapter" and chapterObj.chapter==1 then
    -- 		    	fightData["isBoss"] = false
    -- 		else
    -- 		    	fightData["isBoss"] =chapterObj.boss ==1 or false
    -- 		end
    -- 		fightData["modulePrefabUrl"] = "Prefabs/moduleFabs/chapterModule/chapterModule"
    -- 		if GlobalVar.currentScene == "main_scene" and self._otherArge~=-1 then
    -- 		   	UIMrg:pop()
    -- 		end
    -- 	elseif self._chapterType == "heroChapter" then
    -- 	    	fightData["mdouleName"] = "heroChapter"
    -- 	    	fightData["heroChapterID"] = self._senceID
    -- 	    	fightData["modulePrefabUrl"] = "Prefabs/moduleFabs/chapterModule/chapterElite"
    -- 	end
    -- 	fightData["id"] = 0
    -- 	UluaModuleFuncs.Instance.uOtherFuns:callBackFight(fightData)
    -- 	fightData = nil
    -- end, function(ret)
    -- 	isClick = false
    -- 	if(tonumber(ret)==64) then
    -- 	    	Api:checkUpdate(function()
    -- 	        		UIMrg:pop()
    -- 	        		UIMrg:pop()
    -- 	        		LuaMain:openWithSound(6)
    -- 	    	end)
    -- 	end
    -- 	return false
    -- end)

    --Api:fightChapter(self._chapterType, self._senceID, arr, self.teamId, function(result)
    local curChapterId = self.chapterid
    print("(self.chapterid)")
    print(self.chapterid)
    -- print("-------------------------------")
    -- print(curChapterId)
    -- print(self._senceID)
    -- print("-------------------------------")
    Api:defiance(self._chapterType, curChapterId, self._senceID, arr, self.teamId, function(result)
        -- print("***********************")
        -- print(result)
        -- print("***********************")

        local fightData = {}
        fightData["battle"] = result
        fightData["mdouleName"] = self._chapterType
        fightData["copyId"] = self._senceID
        fightData["modulePrefabUrl"] = "Prefabs/moduleFabs/leagueModule/league_chapterMain"
        fightData["id"] = 0
        UluaModuleFuncs.Instance.uOtherFuns:callBackFight(fightData)
        fightData = nil

        LuaMain:destroyGongHuiBuildName()
    end, function(ret)
    end)
end

function m:onClick(go, name)
    --if isClick == true then return end
    if name == "challengeBtn" then
        --isClick = true
        --local chapterObj = TableReader:TableRowByID(self._chapterType, self._senceID)
        local chapterObj = GuildDatas:getCopyDataByCopyid(self._senceID, self.chapterid)
        -- 挑战
        self:fightIng(LuaMain:getTeamByIndex(0))
    elseif name == "buzhengBtn" then
        --布阵
        LuaMain:showFormation(0)
    elseif name == "btnClose" then 
        UIMrg:popWindow()
    end
end

function m:onEnter()
    --isClick = false
end

function m:onClose()
    if GlobalVar.currentScene ~= "main_scene" then
        -- if self._chapterType == "commonChapter" or  self._chapterType == "hardChapter" then
        --     local chapters = TableReader:TableRowByID( self._chapterType, self._senceID).chapter
        --     ClientTool.LoadLevel("main_scene", function()
        --         --UIMrg:popToModule("chapter1", { chapters, -1, self._chapterType})
        --         UIMrg:pop()
        --         UIMrg:popWindow()
        --         Tool.push("chapter1", "Prefabs/moduleFabs/chapterModule/chapterModule",{ chapters, -1, self._chapterType})
        --     end)
        -- elseif self._chapterType == "heroChapter" then
        --     ClientTool.LoadLevel("main_scene", function()
        --         UIMrg:pop()
        --     end)
        -- end
        UIMrg:pop()
    else
        UIMrg:pop()
    end
end

function m:create(binding)
    self.binding = binding
    return self
end

---------------------------
-- 贡献奖励
-- 同时返回一个最小值和最大值
function m:getDonateReward(...)
    local row = {}
    -- 取当前章节名
    local min = 900000000
    local max = 0
    print("(self.chapterid)")
    print(self.chapterid)
    local _curChapterId = tonumber(self.chapterid)
    TableReader:ForEachLuaTable("Guild_damage_reward", function(index, item)
        local _chapterId = tonumber(item.chapter)
        if _chapterId == _curChapterId then
            if item.donate_reward < min then
                min = item.donate_reward
            end
            if item.donate_reward > max then
                max = item.donate_reward
            end
        end
        return false
    end)
    return min, max
end

return m