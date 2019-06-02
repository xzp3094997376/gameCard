--
-- Created by IntelliJ IDEA.
-- User: xiyou
-- Date: 2014/11/15
-- Time: 16:11
-- To change this template use File | Settings | File Templates.
-- 新手配置
local Reward = require("uLuaModule/modules/summon/uSummonReward.lua")
local guide_step = require("uLuaModule/modules/guide/guide_step.lua")
local guide_scrite = require("uLuaModule/modules/guide/guide_scrite.lua")
local GuideStop = {
    Start = 0,
    Round = 1,
    WinEnd = 2,
    LoseEnd = 3
}

local guideConfig = {}
--对话点击下一步
function guideConfig:CallNextStep()
    self:next()
end

--对话
function guideConfig:talk(isLeft, name, text, img, black)
    GuideManager.getInstance():ShowTalk(self, isLeft, name, text, img, black or false)
    GuideManager.getInstance():showNpc("")
end


--隐藏对话
function guideConfig:hideTalk()
    GuideManager.getInstance():HidePlot()
    GuideManager.getInstance():showNpc("")
end

function guideConfig:getGroupId()
    return self.group_id
end

function guideConfig:End()
    self.__end = true
    self.__stop = true
    if self.group_id ~= nil then
        self:setGroupId(self.group_id + 1)
    end
    self:hideTalk()
    GuideManager.getInstance():End()
    guideConfig.tempData = nil
end

function guideConfig:playGuideStep(id)
    if Player.guide[id] == 2 then
        self:End()
        return
    end
    self.__end = false
    self.__stop = false
    self._curRow = guide_scrite[id]
    local guide = GuideManager.getInstance("Prefabs/moduleFabs/guide/GuidePanel")
    guide:PlayStep(id)
end

--播放
function guideConfig:play(id)
    self.__stop = false
    self:setGroupId(id)
    self.isGuideStep = false
    if Player.guide[id] == 2 then
        self:End()
        return
    end
    self.__id = 1
    if self._curRow == nil then
        self._curRow = guide_scrite[id]
        if self._curRow == nil then
            self:End()
            return
        end
    else
        self.__end = false
        self:next()
    end
end

function guideConfig:playStep(row)
    local path = row[1]
    print(path)
    local _time = row[2] or 0.2
    local resetEvent = row[3] or 0
    local say = row.say or ""
    local pos = row.pos or "left"
    local isNetWork = row.api or false
    GuideManager.getInstance():PlayStepEditer("Prefabs/moduleFabs/guide/" .. path, _time, resetEvent, say, pos, isNetWork)
end

function guideConfig:readRow(row)
    if row == nil then return end
    self:hideTalk()
    self._guideSteps = guide_step[row[2]]
    self._guideStepsIndex = 0
    if self._guideSteps ~= nil then
        self:GuideNextStep()
    else
        self.isGuideStep = false
        self.__id = self.__id + 1
        self:next()
    end
end

--下一步新手
function guideConfig:GuideNextStep()
    self._guideStepsIndex = self._guideStepsIndex + 1
    local row = self._guideSteps[self._guideStepsIndex]
    self._guideStepRow = row
    if row ~= nil then
        self:playStep(row)
    else
        self.isGuideStep = false
        self.__id = self.__id + 1
        self:next()
    end
end

function guideConfig:onClick()
    if self._guideStepRow ~= nil and self._guideStepRow[3] == 1 then
        if (self._guideStepRow[4] == "draw") then
            local that = self
            if self._guideStepRow[5] == 8 then
                local chars = Player.Chars:getLuaTable()
                if chars["25"] ~= nil then
                    that._guideStepRow = nil
                    self:End()
                    return
                end
            end
            if self._guideStepRow[5] == 10 then
                local chars = Player.Chars:getLuaTable()
                if chars["52"] ~= nil then
                    that._guideStepRow = nil
                    self:End()
                    return
                end
            end
            Api:draw(self._guideStepRow[5], function(result)
                local lua = {
                    result = result,
                    cbAgin = function() end,
                    darw_id = 5,
                    cost_type = "gold",
                    cost = 280
                }
                UIMrg:CallRunnigModuleFunctionWithArgs("hideOrShowEffect", { false })
                Reward:show(lua)
                that:setGroupId(that.group_id + 1)
                that._guideStepRow = nil
                --                Api:setGuide(2, 2, function() end)
                --                that:next()
            end, function(ret)
                --                that:setGroupId(that.group_id + 1)
                if ret == 54 then
                    that._guideStepRow = nil
                    self:End()
                end
                return false
            end)
            return
            --        elseif self._guideStepRow[4] == "xiLianGuide" then
            --            local that = self
            --            UIMrg:CallRunnigModuleFunction("xiLianGuide", {
            --                onCallBack = function()
            --                --                that:setGroupId(that.group_id + 1)
            --                --                    that:next()
            --                    that._guideStepRow = nil
            --                end,
            --                onError = function()
            --                    that._guideStepRow = nil
            --                    return false
            --                end
            --            })
        end
    end
end

--下一步
function guideConfig:next()

    if (self.__stop == true or self.__end == true) then return end

    GuideManager.getInstance():showNpc("")

    if self.isGuideStep == true then
        self:GuideNextStep()
        return
    end
    --    local row = guide_scrite[self.__id]
    --    self._curRow = row
    if self._curRow == nil then
        self:End()
        return
    end
    local row = self._curRow[self.__id]
    if row == nil then self.__id = 1 row = self._curRow[self.__id] end
    local type = row[1]
    self._type = type
    self.stopBattle = false
    if type == "talk" then
        self._guideStepRow = nil
        self:talk(row[2], row[3], row[4], row[5], row[6])
        self.__id = self.__id + 1
        self.isGuideStep = false
    elseif type == "group" then
        self.group_id = row[2]
        self.__id = row[3] or 1
        self._curRow = guide_scrite[self.group_id]
        self:next()
    elseif type == "open_group" then
        --    print("open_group")
        Api:setGuide(self.group_id, 2, function() end)

        self:setGroupId(row[2])
        self.__id = self.__id + 1
        self:next()
    elseif type == "guide" then
        self.isGuideStep = true
        self:readRow(row)
    elseif type == "battleStart" then
        self:stop()
        self.__id = self.__id + 1
    elseif type == "battleContinue" then
        self:hideTalk()
        GuideManager.resumeBattle()
        self.__id = self.__id + 1
        self:next()
        self:stop()
    elseif type == "battleEndWin" or type == "battleEndLose" then
        self:stop()
        self.__id = self.__id + 1
    elseif type == "end" then
        --        if Player.guide[self.group_id] == 1 then
        --            Api:setGuide(self.group_id, 2, function() end)
        --        end
        Api:setGuide(self.group_id, 2, function() end)
        self:End()
    elseif type == "jump" then
        if row[4] == "window" then
            UIMrg:pushWindow(row[3], row[5])
        elseif row[4] == "replace" then
            Tool.replace(row[2], row[3], row[5])
        else
            Tool.push(row[2], row[3], row[5])
        end
        self.__id = self.__id + 1
        self:next()
    elseif type == "stop" then
        self.__id = self.__id + 1
        self:hideTalk()
    elseif type == "gotoNext" then
        self:hideTalk()
        Events.AddListener("GuideGoToNext", funcs.handler(self, self.gotoNext))
    elseif type == "showNpc" then
        GuideManager.getInstance():showNpc(row[2])
        self.__id = self.__id + 1
        self:next()
    elseif type == "dataEye" then
        DataEye.setGuide(row[2])
        self.__id = self.__id + 1
        self:next()
    elseif type == "scene" then
        local that = self
        local num = row[3]
        ClientTool.beginLoadScene(row[2], function(scene)
            if scene then
                scene:RotateOne(function()
                    that:next()
                end, num)
            else
                that:next()
            end
            --            that:next()
        end)
        self.__id = self.__id + 1
        --        self:stop()
    end
end

function guideConfig:gotoNext()
    self.__id = self.__id + 1
    self:next()
    Events.RemoveListener('GuideGoToNext')
end

function guideConfig:getLastGroup()
    --    local group_id = PlayerPrefs.GetInt("group_id")
    local i = 0
    local group_id = Player.guide[i]
    local id = PlayerPrefs.GetInt(Player.playerId .. "_" .. 0)
    if group_id < id then
        group_id = id
    end
    group_id = self:checkGroup(group_id)
    print("last->" .. group_id)
    return group_id
end

function guideConfig:setGroupId(id)
    --    PlayerPrefs.SetInt("group_id",id)
    local _gid = Player.guide[0]
    local _id = PlayerPrefs.GetInt(Player.playerId .. "_" .. 0)
    --    print(_id)
    if _gid < _id then _gid = _id end
    self.group_id = id
    if Player.guide[id] == 0 then
        Api:setGuide(id, 1, function() end)
    end
    if _gid < id then
        Api:setGuide(0, id, function()
        end)
    end
end


function guideConfig:checkGroup(id)
    --    local last = Player.Chapter.lastSection
    --    local lastChapter = Player.Chapter.lastChapter
    if Player.guide[id] == 2 then return id + 1 end
    --    guideConfig:checkGuide(id)

    --    if id == 1 and (lastChapter > 1 or last > 1) then
    --        return self:checkGroup(id + 1)
    --    end
    --
    --    if id == 2 then
    --        --        local chars = Player.Chars:getLuaTable()
    --        --        table.foreach(chars,print)
    --        if Player.guide[2] == 2 then
    --            return self:checkGroup(id + 3)
    --        end
    --    end
    --    if id == 3 and (lastChapter > 1 or last > 2) then
    --        return self:checkGroup(id + 1)
    --    end
    --    if id == 4 and (lastChapter > 1 or last > 3) then
    --        return self:checkGroup(id + 1)
    --    end
    return id
end

function guideConfig:isPlaying()
    return not self.__stop and not self.__end
end

function guideConfig:Playing()
    self.__stop = false
    self.__end = false
    Events.Brocast('hideHand')
end

function guideConfig:isStop()
    return self.__stop
end

function guideConfig:isEnd()
    return self.__end
end

function guideConfig:stop()
    self.__stop = true
end

function guideConfig:resumeGuide()
    self.__stop = false
end

function guideConfig:resume(stop, round)
    if self == nil then return false end
    if self._type == "battleStart" and stop == GuideStop.Start then
        self.__stop = false
        self:next()
        return true
    elseif stop == GuideStop.Round then

    elseif self._type == "battleEndWin" and stop == GuideStop.WinEnd then
        self.__stop = false
        --        print("battleEndWin")

        self:next()
        return false
    elseif self._type == "battleEndLose" and stop == GuideStop.LoseEnd then
        self.__stop = false
        self:next()
        return false
    elseif stop == GuideStop.WinEnd and round > 100 then
        self.__stop = false
        UIMrg:pop()
        self:play(1)
    elseif (self._type == "battleStart" or self._type == "battleContinue") and stop == GuideStop.WinEnd then
        if self._type == "battleStart" then
            self.__id = self.__id + 2
        elseif self._type == "battleContinue" then
            self.__id = self.__id + 1
        end
        self.__stop = false
        self:next()
    end

    return false
end

function guideConfig:hasGuide(group_id)
    local row = guide_scrite[group_id]
    if row == nil then return false end
    if row.dont_check == true then return false end
    return true
end

function guideConfig:checkGuide(id)
    local row = guide_scrite[id]
    if row == nil or row.arg == nil then return end
    local last = Player.Chapter.lastSection
    local lastChapter = Player.Chapter.lastChapter
    --    print("最后关卡:" .. last)
    --    print("最后章节:" .. lastChapter)
    local arg = row.arg
    if arg[1] == "section" then
    end
end

function guideConfig:checkSection(row)

    if row == nil or row.arg == nil then return end
    local arg = row.arg
    if arg[1] == "section" then
        local lastChapter = Player.Chapter.lastChapter
        local last = Player.Chapter.lastSection
        if lastChapter > arg[2] or (lastChapter == arg[2] and last > arg[3]) then
            guideConfig:init(self.group_id + 1)
            return true
        elseif lastChapter < arg[2] or ((lastChapter == arg[2] and last < arg[3])) then
            --            print("数据有错")
            guideConfig:End()
            self._curRow = nil
            Api:setGuide(0, 417, function() end)
            self.group_id = 417
        end
    elseif arg[1] == "task" then
        if Tool.checkRedPoint("task") == false then
            guideConfig:End()
            self._curRow = nil
        end
    end
    return false
end

function guideConfig:reset()
    self._curRow = nil
    self.__end = nil
    self.__stop = nil
end

--初始化
function guideConfig:init(group_id)
    self:setGroupId(group_id)
    self._curRow = guide_scrite[group_id]
    self.group_id = group_id
    if self._curRow and self._curRow.dont_check == true then
        Api:setGuide(group_id, 2, function()
        end)
        self:End()
        return true
    end

    return guideConfig:checkSection(self._curRow)
end

function guideConfig:Brocast(tp, char)
    if tp == "changeSkill" then
        if char.stage ~= Tool.GetCharArgs("unlock_trans_level") then return end
        Tool.checkLevelUnLock(tp)
        GuideConfig.tempData = char
    elseif tp == "charJinHua" then
        if char.star < 5 and char.lv >= 10 then
            guideConfig:playGuideStep(3200)
        end
    end
end

--guideConfig:End()
return guideConfig