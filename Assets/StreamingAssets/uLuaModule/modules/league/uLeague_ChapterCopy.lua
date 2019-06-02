local leagueFightPanel = require("uLuaModule/modules/league/uLeague_Fight.lua")
local m = {}

function m:Start()
    print("lzh print:******** uLeague_ChapterCopy.lua ** Start()")
    self:getTresureStatus()
end

function m:OnEnable()
    print("lzh print:******** uLeague_ChapterCopy.lua ** OnEnable()")
    self:getTresureStatus()
end

function m:onEnter()
    print("lzh print:******** uLeague_ChapterCopy.lua ** onEnter()")
end

function m:update(args)
    self.delegate = args.delegate
    self.copyDatas = args.copyDatas
    self.isPass = args.isPass
    self.chapterId = args.chapterId
    if self.boxlist ~= nil then
         self:isShowEffect()
    end

    for k, v in pairs(self.copyDatas) do
        local _copyId = tonumber(v.copyId)
        local row = self:getRowByCopyid(_copyId)
        self["name" .. _copyId].text = row.name
        self["hero" .. _copyId]:LoadByModelId(row.model, "stand", function() end, false, 1, row.big / 1000)
        self["Slider" .. _copyId].value = tonumber(v.totalHp) / tonumber(v.totalMaxHp)
        if tonumber(v.totalHp) <=0 then 
            self["jisha" .. _copyId]:SetActive(true)
        else 
            self["jisha" .. _copyId]:SetActive(false)
        end 
    end
end

function m:onBtnCopy(copyId)
    -- Api:defiance(function(result)
    -- 	if tonumber(result.ret) == 0 then
    -- 		local args = {}
    -- 		UIMrg:push("leagueModule","Prefabs/moduleFabs/leagueModule/league_flight", args)
    -- 	else
    -- 		MessageMrg.show("挑战副本失败！")
    -- 	end
    -- end,function (result)
    -- 	print("lzh print: getGuildBaseInfo 2222222222222222")
    -- 	print(result)function m:Start()
    -- end)
    --UIMrg:push("leagueModule","Prefabs/moduleFabs/leagueModule/league_flight", args)
    if self.isPass == true then
        MessageMrg.show(TextMap.GetValue("Text1182"))
        return
    end

    for k, v in pairs(self.copyDatas) do
        if tonumber(v.copyId) == copyId then
            if tonumber(v.totalHp) <= 0 then
                MessageMrg.show(TextMap.GetValue("Text1182"))
                -- elseif GuildDatas:GetChallengeTimes()<=0 then
                -- 	MessageMrg.show("挑战次数不足!")
            else
                leagueFightPanel.Show("leagueChapter", copyId, self.chapterId, v) -- "leagueChapter" commonChapter
            end
        end
    end
end

--是否有可以领取的奖励，显示特效
function m:isShowEffect()
     for k, v in pairs(self.copyDatas) do
        if tonumber(v.totalHp) <= 0 or self.isPass == true then
            local _index = (self.chapterId - 1)*4 + tonumber(v.copyId)
            local count = self.boxlist.Count
            local _ishave = 1
            for i=0,count-1 do
                if self.boxlist[i] == _index then
                    _ishave = 0
                    break
                end
            end
            if _ishave == 1 then
                self.UI_Effect.gameObject:SetActive(true)
                return
            end
        end
    end
    self.UI_Effect.gameObject:SetActive(false)
end

function m:getTresureStatus()
    GuildDatas = require("uLuaModule/modules/league/uleague_Datas")
    GuildDatas:downGuildRewardStatus(function(args)
        self.boxlist = args.result.box
        --self:isShowEffect(args.result.box)
    end)
end

function m:onTreasure(...)
    local args = {}
    args.copyDatas = self.copyDatas
    args.isPass = self.isPass
    args.chapterId = self.chapterId
    UIMrg:push("leagueModule", "Prefabs/moduleFabs/leagueModule/league_treasure", args)
end

function m:onClick(go, btnName)
    print("====================")
    print(btnName)
    print("====================")
    if btnName == "btn_treasure" then
        self:onTreasure()
    elseif btnName == "btn_hero1" then
        self:onBtnCopy(1)
    elseif btnName == "btn_hero2" then
        self:onBtnCopy(2)
    elseif btnName == "btn_hero3" then
        self:onBtnCopy(3)
    elseif btnName == "btn_hero4" then
        self:onBtnCopy(4)
    end
end

-----------------------------------------------------
-- 获取公会复本一行数据
function m:getRowByCopyid(copyId)
    local row = {}
    TableReader:ForEachLuaTable("GuildCopy", function(index, item)
        local _chapterId = tonumber(item.chapterId)
        local _copyId = tonumber(item.copyId)
        if _chapterId == self.chapterId and copyId == _copyId then
            row = item
            return true
        end
        return false
    end)
    return row
end


return m