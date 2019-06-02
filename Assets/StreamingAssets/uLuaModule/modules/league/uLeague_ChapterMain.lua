-- 公会章节页面
-- player.Resource.guildFightCount
-- 这个次数是帮会挑战次数

local m = {}
local closeFun = nil
local bShowChapter = true
function m:Start()
    print("lzh print:******** uLeague_ChapterMain.lua ** Start()")
    Tool.loadTopTitle(self.gameObject, TextMap.GetValue("LocalKey_656"))
    LuaMain:ShowTopMenu(6,nil,{[1]={ type="money"},[2]={ type="gold"}})
    self.lbl_times_tip.gameObject:SetActive(false)
    if my_timer ~= nil then
        LuaTimer.Delete(my_timer)
        my_timer = nil
    end
    self:getCopyList()
end

function m:stopCopyDataRefreshTimer()
    if my_timer ~= nil then
        LuaTimer.Delete(my_timer)
        my_timer = nil
    end
end

function m:startCopyDataRefreshTimer()
    if my_timer ~= nil then
        return
    end
    my_timer = LuaTimer.Add(5000, 5000, function(id)
        Api:getCopyList(function(result)
            if tonumber(result.ret) == 0 then
                if result.list.Count == 0 then
                    MessageMrg.show(TextMap.GetValue("Text1187"))
                    return
                end
                local count = result.list.Count
                local datas = {}
                for i = 0, count - 1 do
                    local t = {}
                    t.copyId = result.list[i].copyId
                    t.totalHp = result.list[i].totalHp
                    t.totalMaxHp = result.list[i].totalMaxHp
                    table.insert(datas, t)
                end
                local temp = {}
                temp.datas = datas
                temp.count = result.count
                temp.progress = result.progress
                temp.progressClose = result.progressClose
                temp.passRewardFlag = result.passRewardFlag
                self:update(temp)
            else
                MessageMrg.show(TextMap.GetValue("Text1188"))
            end
        end, function(result)
        end)
        return true
    end)
end

function m:onEnter()
    self:refreshChallengeTimes()
    ApiLoading:show(15, nil)
    self:getCopyList()
end

function m:getCopyList()
    -- 刷新页面数据
    print("getCopyList")
    Api:getCopyList(function(result)
        ApiLoading:hide()
        if tonumber(result.ret) == 0 then
            if result.list.Count == 0 then
                MessageMrg.show(TextMap.GetValue("Text1187"))
                return
            end
            local count = result.list.Count
            local datas = {}
            for i = 0, count - 1 do
                local t = {}
                t.copyId = result.list[i].copyId
                t.totalHp = result.list[i].totalHp
                t.totalMaxHp = result.list[i].totalMaxHp
                table.insert(datas, t)
            end
            local temp = {}
            temp.datas = datas
            temp.count = result.count
            temp.progress = result.progress
            temp.progressClose = result.progressClose
            temp.passRewardFlag = result.passRewardFlag
            self:update(temp)
        else
            MessageMrg.show(TextMap.GetValue("Text1188"))
        end
    end, function(result)
        ApiLoading:hide()
    end)
end

function m:OnEnable()
    if bShowChapter == false then
        self:startCopyDataRefreshTimer()
    end
end

function m:OnDisable()
    self:stopCopyDataRefreshTimer()
end

function m:onClose()
    print_t(closeFun)
    if closeFun ~= nil then
        closeFun()
        return
    end
    --UIMrg:pop()
end

function m:canOpenRewordBox(chapter)
    if chapter < self.chaperProgress and chapter > self.progressClose then
        return true
    end
    return false
end

function m:update(copyDatats)
    closeFun = nil
    self.copyDatas = copyDatats.datas
    self.challengeTimes = copyDatats.count
    self.chaperProgress = copyDatats.progress
    self.progressClose = copyDatats.progressClose
    self.passRewardFlag = copyDatats.passRewardFlag
    -- 2222
    self.chapterDatas = {} -- 章节的简单数据
    local _chpater = -1
    local _curChapterId = tonumber(self.chaperProgress)
    TableReader:ForEachLuaTable("GuildCopy", function(index, item)
        local _chapterId = tonumber(item.chapterId)
        if _chapterId ~= _chpater then
            _chpater = _chapterId
            local t = {}
            t.chapterId = tonumber(item.chapterId)
            --t.chapterName = item["$chapter"]
            t.chapterName = item["chapterName"]
            t.passType = nil -- 通过情况 1-已经通过 2-当前章节 3-还未开始章节
            if _chapterId < _curChapterId then
                t.passType = 1
            elseif _chapterId == _curChapterId then
                local lv = m:getChapterLockLv(_chpater)
                if GuildDatas:getMyGuildInfo().guildLevel >= lv then
                    t.passType = 2
                else
                    t.unlockLv = lv
                    t.passType = 4
                end
            else
                local lv = m:getChapterLockLv(_chpater)
                if GuildDatas:getMyGuildInfo().guildLevel >= lv then
                    t.passType = 3
                else
                    t.unlockLv = lv
                    t.passType = 4
                end
            end
            table.insert(self.chapterDatas, t)
        end
        return false
    end)
    if self.curChapterid == nil then
        self.curChapterid = self.chaperProgress
    end
    if bShowChapter == false then
        self:showChapterCopys(self.curChapterid)
        --return
    else
        self:showChapterList(self.chapterDatas)
    end
    -- 3333
    self:setCurChapterInfo_UI()
end

function m:onClick(go, btnName)
    if btnName == "btn_guize" then
        UIMrg:pushWindow("Prefabs/moduleFabs/leagueModule/league_rule", { 10 })
    elseif btnName == "btn_jiangli" then
        --MessageMrg.show("还没有做！")
        --UIMrg:pushWindow("Prefabs/moduleFabs/leagueModule/league_chapterReward",{})
        GuildDatas:downGuildRewardStatus(function(result)
            local datas = {}
            datas.chaperProgress = self.chaperProgress
            UIMrg:pushWindow("Prefabs/moduleFabs/leagueModule/league_chapterReward", datas)
        end)
    elseif btnName == "btn_zhanji" then
        --MessageMrg.show("没有相关服务端接口！")
        self:onVipRank()
    elseif btnName == "btn_addTimes" then
        self:onAddTimes()
    elseif btnName=="btnBack" then
        self:onClose()
    end
end

function m:getChapterLockLv(charpterid)
    local pic_word = ""
    TableReader:ForEachLuaTable("Guild_chapter_reward", function(index, item)
        if item.id == charpterid then
            lv = item.unlock[0].unlock_arg
            return true
        end
        return false
    end)
    return lv
end

function m:getChapterName(charpterid)
    local name = ""
    TableReader:ForEachLuaTable("Guild_chapter_reward", function(index, item)
        if item.id == charpterid then
            name = item.name
            return true
        end
        return false
    end)
    return name
end

-------------------------------------------------------------------------------------
function m:setCurChapterInfo_UI(...)
    if self.passRewardFlag == true then
        self.havejingli:SetActive(true)
    else
        self.havejingli:SetActive(false)
    end
    -- 取当前章节名
    --self.btn_guize.gameObject:SetActive(false)

    -- 取当前章节名
    self.name.text=m:getChapterName(self.curChapterid)
    -- 进度
    local hp = 0
    local maxHp = 0
    for k, v in pairs(self.copyDatas) do
        hp = hp + tonumber(v.totalHp)
        maxHp = maxHp + tonumber(v.totalMaxHp)
    end
    self.chapter_slider.value = (maxHp - hp) / maxHp

    --local precent = (hp/maxHp*100) - (hp/maxHp*100%1)
    local precent = math.floor((maxHp - hp) / maxHp * 100)
    self.labPieceCount.text = precent .. "%"
    if self.curChapterid < tonumber(self.chaperProgress) then
        self.chapter_slider.value = 1.0
        self.labPieceCount.text = "100%"
    end
    -- 重置倒计时
    self:resetCopyTime()
    -- 挑战次数
    self:refreshChallengeTimes()
    -- 挑战次数回复倒计时
end

function m:showChapterList(chapterDatas)
    self:stopCopyDataRefreshTimer()
    bShowChapter = true
    self.curChapterid = tonumber(self.chaperProgress)
    self:setCurChapterInfo_UI()
    self.page_chapterList.gameObject:SetActive(true)
    self.page_chapterCopy.gameObject:SetActive(false)
    local args = {}
    args.delegate = self
    args.curchapter = self.curChapterid
    args.chapterDatas = self.chapterDatas
    self.page_chapterList:CallUpdate(args)
end

function m:showChapterCopys(chapter)
    self:startCopyDataRefreshTimer()
    bShowChapter = false
    self.page_chapterList.gameObject:SetActive(false)
    self.page_chapterCopy.gameObject:SetActive(true)
    --self.btn_guize.gameObject:SetActive(true)

    local args = {}
    args.delegate = self
    args.copyDatas = self.copyDatas
    args.isPass = false
    args.chapterId = chapter
    if self.chaperProgress > chapter then
        args.isPass = true
    end
    self.page_chapterCopy:CallUpdate(args)
    closeFun = function(...)
        m:showChapterList(self.chapterDatas)
        closeFun = nil
    end
end

-- 进入某一章节
function m:OnClick_CurChapterItem_Callback(chaterId)
    self.curChapterid = chaterId
    self:setCurChapterInfo_UI()
    self:showChapterCopys(chaterId)
end

-- 打开会员战绩榜
function m:onVipRank(...)
    Api:getGuildHurtRankList(function(result)
        if tonumber(result.ret) == 0 then
            local datas = {}
            datas.pos = result.info.pos
            datas.hurt = result.info.hurt
            datas.amount = result.info.amount
            local count = result.list.Count
            local list = {}
            for i = 0, count - 1 do
                local t = {}
                t.icon = result.list[i].icon
                t.playerId = result.list[i].playerId
                t.nickname = result.list[i].nickname
                t.level = result.list[i].level
                t.vipLevel = result.list[i].vipLevel
                t.hurt = result.list[i].hurt
                t.amount = result.list[i].amount
                table.insert(list, t)
            end
            datas.list = list
            UIMrg:pushWindow("Prefabs/moduleFabs/leagueModule/league_vipRank", datas)
        else
            MessageMrg.show(TextMap.GetValue("Text1189"))
        end
    end, function(result)
    end)
    --UIMrg:pushWindow("Prefabs/moduleFabs/leagueModule/league_vipRank",{})
end

function m:onAddTimes(...)
    -- Api:buyGuildFightCount(function(result)
    -- 	if tonumber(result.ret) == 0 then

    -- 	else
    -- 		MessageMrg.show("获取会员战绩榜失败！")
    -- 	end
    -- end,function (result)
    -- 	print("lzh print: buyGuildFightCount 2222222222222222")
    -- 	print(result)
    -- end)
    --MessageMrg.show("还没有做！")
    --DialogMrg:BuyBpAOrSoul("leagueCopyQ","",toolFun.handler(self, self.updateVStimes))

    DialogMrg:BuyBpAOrSoul("leagueCopyQ", "", toolFun.handler(self, self.onColse_BuyBpAOrSoul),
        toolFun.handler(self, self.onRefreash_BuyBpAOrSoul),
        toolFun.handler(self, self.onUse_BuyBpAOrSoul))
end

function m:refreshChallengeTimes(...)
    if m.challengeTimes ~= nil then
        m.lbl_times.text = TextMap.GetValue("Text1190") .. m.challengeTimes
    end
    m.lbl_times_tip.gameObject:SetActive(false)
    -- 挑战次数回复倒计时
    local maxChallengTimes = TableReader:TableRowByID("GuildSetting", "guildFightCountMax").args1
    if maxChallengTimes == nil then
        maxChallengTimes = 5
    end
    if m.challengeTimes < maxChallengTimes then
        local tervalTimeStr = TableReader:TableRowByID("GuildSetting", "guild_fight_count_inc_interval").args1 --间隔时间（小时）
        local tervalTime = tonumber(string.sub(tervalTimeStr, 1, 1))
        if tervalTime == 0 then
            return
        end
        local remainingTime = Player.CdTime.guildFightCount
        if remainingTime~= nil and remainingTime <= 0 then
            return
        end
        m.lbl_times_tip.gameObject:SetActive(true)
        local remainingTime = ClientTool.GetNowTime(remainingTime)
        LzhHelper = require("uLuaModule/helper/LzhHelper")
        local hms = LzhHelper:GetHMS(remainingTime)
        local msg = string.gsub(TextMap.GetValue("LocalKey_717"),"{0}",tervalTime)
        msg = string.gsub(msg,"{1}",hms.hour)
        m.lbl_times_tip.text =string.gsub(msg,"{2}",hms.minute)
    end
end

function m:onColse_BuyBpAOrSoul(...)
    m:refreshChallengeTimes()
end

function m:onRefreash_BuyBpAOrSoul(...)
    m:refreshChallengeTimes()
end

function m:onUse_BuyBpAOrSoul(dlg, itemCount)
    Api:useGuildFightItem(itemCount, function(result)
        m.refreshChallengeTimes()
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

function m:resetCopyTime(...)
    -- 读表
    local targetTimeStr = TableReader:TableRowByID("GuildSetting", "resetCopyTime").args1
    if targetTimeStr == nil then
        targetTimeStr = "24h00m"
    end
    local hour = 0
    local min = 0
    local i = string.find(targetTimeStr, "h")
    if i ~= nil then
        hour = tonumber(string.sub(targetTimeStr, 1, i - 1))
    else
        i = 0
    end
    print("i" .. i)
    local j = string.find(targetTimeStr, "m")
    if j ~= nil then
        min = tonumber(string.sub(targetTimeStr, i + 1, j - 1))
    end
    if hour == 0 then
        self.lbl_daojishi.text = TextMap.GetValue("Text1195")
        return
    end
    if hour < 10 then
        hour = "0" .. hour
    end
    if min < 10 then
        self.lbl_daojishi.text = hour .. ":0" .. min
    else
        self.lbl_daojishi.text = hour .. ":" .. min
    end
end

function m:OnDestroy()
    if my_timer ~= nil then
        LuaTimer.Delete(my_timer)
    end
    if my_timer2 ~= nil then
        LuaTimer.Delete(my_timer2)
    end
end

return m