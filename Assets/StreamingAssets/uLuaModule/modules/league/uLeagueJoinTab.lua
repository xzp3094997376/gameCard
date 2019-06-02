local m = {}

local curPage = 1
local leagueDataList = nil
local isCanAdd = false

function m:Start()
    curPage = 1
    leagueDataList = {}
    -- self.binding:CallManyFrame(function()
    -- 	self:getGuildList(curPage)
    --end,1)
end

function m:update(...)
    curPage = 1
    leagueDataList = {}
    self:getGuildList(curPage)
end

function m:AddNewPageUp()
    --[[print("0000000")
    if curPage <= 1 then
        return
    end
    leagueDataList = {}
    curPage = curPage - 1
    self:getGuildList(curPage)]]--
end

function m:AddNewPage(...)
    -- print("------------AddNewPage--------------------")
    -- print(curPage)
    -- print(isCanAdd)
    -- print("----------------AddNewPage----------------")
    --leagueDataList = {}
    if isCanAdd == false then return end
    curPage = curPage + 1
    self:getGuildList(curPage)
end

function m:getGuildList(_curPage)
    Api:getGuildList(_curPage, function(result)
        --print("lzh print: getGuildList 1111111111111111")
        if tonumber(result.ret) == 0 then
            print("lzh print : count " .. result.list.Count)
            if result.list.Count == 0 and #leagueDataList == 0 then
                self.svLeagueList:refresh(leagueDataList, self, true, 0)
                self.lbl_tips.text = "当前无协会，赶快去创建一个吧"
                return false
            end
            local lastCount = 0
            if leagueDataList ~= nil then
                lastCount = #leagueDataList
            end
            self.lbl_tips.text=""
            local count = result.list.Count
            for i = 0, count - 1 do
                local t = {}
                t.guildId = result.list[i].guildId
                t.guildName = result.list[i].guildName
                t.icon = result.list[i].icon
                t.guildLevel = result.list[i].guildLevel
                t.masterName = result.list[i].masterName
                t.playerAmount = result.list[i].playerAmount
                t.playerAmountLimit = result.list[i].playerAmountLimit
                t.announce = result.list[i].announce
                t.isApply = result.list[i].isApply
                t.joinLvLimit = result.list[i].joinLvLimit
                table.insert(leagueDataList, t)
                GuildDatas:setJoinLeagueListState(#leagueDataList, t.isApply)
            end
            self.svLeagueList:refresh(leagueDataList, self, true, lastCount - 1)
            --print("---------------- count = " .. count)
            if count < 5 then
                isCanAdd = false
            else
                isCanAdd = true
            end

            self.cd = result.cd
            if result.cd == 0 then
                self.obj_joincd.gameObject:SetActive(false)
            else
                Api:checkRes(function()
                    self.obj_joincd.gameObject:SetActive(true)
                    self:updateTime()
                end)
            end

        end
    end, function(result)
        print("lzh print: getGuildList")
    end)
end

function m:updateTime()
    if self.cd == nil then
        self.obj_joincd.gameObject:SetActive(false) 
        return
    end
    local targetTime = self.cd
    targetTime = math.ceil(targetTime)
    if my_timer ~= nil then
        LuaTimer.Delete(my_timer)
    end
    my_timer = LuaTimer.Add(0, 1000, function(id)
        if targetTime <= 0 then
            self.obj_joincd.gameObject:SetActive(false)
            return false
        end
        self.txt_joincd.text = TextMap.GetValue("Text1164") .. self:getFormatTime(targetTime).."[-]"
        targetTime = targetTime - 1
        return true
    end)
end

function m:getFormatTime(seconds)
    local str = ""
    local t = 0
    if seconds >= 3600 then
        t = math.floor(seconds / 3600)
        if t < 10 then
            str = str .. "0" .. t .. ":"
        else
            str = str .. t .. ":"
        end
        seconds = seconds % 3600
    else
        str = str .. "00:"
    end
    if seconds >= 60 then
        t = math.floor(seconds / 60)
        if t < 10 then
            str = str .. "0" .. t .. ":"
        else
            str = str .. t .. ":"
        end
        seconds = seconds % 60
    else
        str = str .. "00:"
    end
    t = math.floor(seconds)
    if t < 10 then
        str = str .. "0" .. t
    else
        str = str .. t
    end
    return str
end

function m:OnDestroy()
    print("lzh print:******** uLeagueItem_for_join.lua ** OnDestroy()")
    leagueDataList = nil
    GuildDatas:clearJoinLeagueListState()
end


return m