local m = {}

function m:EnterLeague()
    if Player.Info.guildId == nil or Player.Info.guildId == "" then
        Tool.push("leagueModule", "Prefabs/moduleFabs/leagueModule/league_main_no_join")
    else
        --Tool.push("leagueModule", "Prefabs/moduleFabs/leagueModule/league_Info_Member_Page")
        -- ClientTool.LoadLevel("gonghui_map", function()
        -- LuaMain:createGongHuiBuildName()
        -- end)
        GuildDatas:downloadGuildBaseInfo(function(args)
            print("lzh print: onLeague 111111111111111111")

            --ClientTool.LoadLevel("gonghui_map", function()
                Tool.push("leagueModule", "Prefabs/moduleFabs/leagueModule/league_main_page", args)
                LuaMain:createGongHuiBuildName()
            --end)
        end)
    end
    --Tool.push("leagueModule", "Prefabs/moduleFabs/leagueModule/league_main_no_join")
    --Tool.push("leagueModule", "Prefabs/moduleFabs/leagueModule/league_Info_Member_Page")
    --Tool.push("leagueModule", "Prefabs/moduleFabs/leagueModule/league_main_page")
end

function m:LeaveLeague(func)
    LuaMain:destroyGongHuiBuildName()
    --ClientTool.LoadLevel("main_scene", function()
        if func ~= nil then
            func()
        end
    --end)
end

function m:setJoinLeagueListState(index, value)
    if self.joinLeagueListState == nil then
        self.joinLeagueListState = {}
    end
    self.joinLeagueListState[index] = value
end

function m:getJoinLeagueListState(index)
    if self.joinLeagueListState ~= nil then
        return self.joinLeagueListState[index]
    else
        return nil
    end
end

function m:clearJoinLeagueListState()
    self.joinLeagueListState = {}
end

function m:setMyGuildInfo(info, ext)
    self.myGuildInfo = info
    self.myGuildExt = ext
end

function m:getMyGuildInfo(...)
    return self.myGuildInfo
end

-- function m:setMyGuildExt(ext)
-- 	self.myGuildExt = ext
-- end

function m:getMyGuildExt(...)
    return self.myGuildExt
end

function m:getExp(curLv)
    local row = TableReader:TableRowByUnique("GuildCreate", "level", curLv .. "")
    if tonumber(row.nextLevelExperience) ~= nil then
        return tonumber(row.nextLevelExperience)
    end
    return 1
end

function m:getMyJob(masterId, viceMasterIds)
    if Player.playerId == masterId then
        return 1
    end
    local count = viceMasterIds.Count
    for i = 0, count do
        if Player.playerId == viceMasterIds[i] then
            return 2
        end
    end
    return 3
end

--------------------------------------------------
-- 下载公会的基本信息
function m:downloadGuildBaseInfo(onSucCallback)
    Api:getGuildBaseInfo(function(result)
        if tonumber(result.ret) == 0 then
            self:setMyGuildInfo(result.info, result.ext)
            local args = {}
            args.result = result
            --UIMrg:push("leagueModule","Prefabs/moduleFabs/leagueModule/league_Info_Member_Page", args)
            if onSucCallback ~= nil then
                onSucCallback(args)
            end
        else
            MessageMrg.show(TextMap.GetValue("Text1181"))
        end
    end, function(result)
        print("lzh print: getGuildBaseInfo 2222222222222222")
        --UIMrg:pop()
        print(result)
    end)
end

-- 拿到复本关卡数据
-- 获取公会复本一行数据
function m:getCopyDataByCopyid(copyId, chapterid)
    if chapterid == nil then
        chapterid = tonumber(GuildDatas:getMyGuildInfo().chapterProgressId)
    end
    local row = {}
    -- 取当前章节名
    local _curChapterId = chapterid
    TableReader:ForEachLuaTable("GuildCopy", function(index, item)
        local _chapterId = tonumber(item.chapterId)
        local _copyId = tonumber(item.copyId)
        if _chapterId == _curChapterId and copyId == _copyId then
            row = item
            return true
        end
        return false
    end)
    return row
end

-- 获取可挑战的次数
function m:GetChallengeTimes(...)
    -- print("88888888888888888888888")
    -- print(Player.Resource.guildFightCount)
    -- print("88888888888888888888888")
    local times = 0
    if Player.Resource.guildFightCount ~= nil then
        local temp = tonumber(Player.Resource.guildFightCount)
        if temp ~= nil then
            times = temp
        end
    end
    return times
end

-- 设置公会奖励的各种状态
function m:setGuildRewardStatus(status)
    self.myGuildRewardStatus = status
end

function m:setGuildRewardStatusBox(list)
    self.myGuildRewardStatusBox = list
end

function m:getGuildRewardStatusBox()
    return self.myGuildRewardStatusBox
end

-- 获取公会奖励的各种状态
function m:getGuildRewardStatus(...)
    return self.myGuildRewardStatus
end

-- 下载公会奖励的各种状态
function m:downGuildRewardStatus(onSucCallback)
    print("lzh print: downGuildRewardStatus 000000000000000")
    Api:memberStatus(function(result)
        print("lzh print: downGuildRewardStatus 11111111111111111111")
        print(result)
        if tonumber(result.ret) == 0 then
            self:setGuildRewardStatus(result)
            local args = {}
            args.result = result
            if onSucCallback ~= nil then
                onSucCallback(args)
            end
        else
            MessageMrg.show(TextMap.GetValue("Text1197"))
        end
    end, function(result)
        print("lzh print: downGuildRewardStatus 2222222222222222")
        --UIMrg:pop()
        print(result)
    end)
end


-- 副本剩余宝箱的情况，50个，非0表示已经被人领取了
function m:downBoxListById(copySectionId, onSucCallback)
    print("lzh print: downBoxListByIds 000000000000000")
    Api:getBoxListById(copySectionId, function(result)
        print("lzh print: downBoxListByIds 11111111111111111111")
        print(result)
        if tonumber(result.ret) == 0 then
            self:setGuildRewardStatusBox(result.list)
            local args = {}
            args.result = result
            if onSucCallback ~= nil then
                onSucCallback(args)
            end
        else
            MessageMrg.show(TextMap.GetValue("Text1198"))
        end
    end, function(result)
        print("lzh print: downBoxListByIds 2222222222222222")
        --UIMrg:pop()
        print(result)
    end)
end

function m:ShowTipByReturnCode_zg(code)
    if code == 1001 then
        MessageMrg.show(TextMap.GetValue("Text1199"))
    elseif code == 1002 then
        MessageMrg.show(TextMap.GetValue("Text1200"))
    elseif code == 1003 then
        MessageMrg.show(TextMap.GetValue("Text1201"))
    elseif code == 1004 then
        MessageMrg.show(TextMap.GetValue("Text1202"))
    elseif code == 1005 then
        MessageMrg.show(TextMap.GetValue("Text1203"))
    elseif code == 1006 then
        MessageMrg.show(TextMap.GetValue("Text1204"))
    elseif code == 1007 then
        MessageMrg.show(TextMap.GetValue("Text1205"))
    elseif code == 1008 then
        MessageMrg.show(TextMap.GetValue("Text1206"))
    elseif code == 1009 then
        MessageMrg.show(TextMap.GetValue("Text1207"))
    elseif code == 1010 then
        MessageMrg.show(TextMap.GetValue("Text1208"))
    elseif code == 1011 then
        MessageMrg.show(TextMap.GetValue("Text1209"))
    elseif code == 1012 then
        MessageMrg.show(TextMap.GetValue("Text1208"))
    elseif code == 1013 then
        MessageMrg.show(TextMap.GetValue("Text1210"))
    elseif code == 1014 then
        MessageMrg.show(TextMap.GetValue("Text1211"))
    elseif code == 1020 then
        MessageMrg.show(TextMap.GetValue("Text1212"))
    elseif code == 1021 then
        MessageMrg.show(TextMap.GetValue("Text1213"))
    elseif code == 1031 then
        MessageMrg.show(TextMap.GetValue("Text1214"))
    elseif code == 1032 then
        MessageMrg.show(TextMap.GetValue("Text1215"))
    elseif code == 1033 then
        MessageMrg.show(TextMap.GetValue("Text1216"))
    elseif code == 1034 then
        MessageMrg.show(TextMap.GetValue("Text1217"))
    elseif code == 1035 then
        MessageMrg.show(TextMap.GetValue("Text1218"))
    elseif code == 1036 then
        MessageMrg.show(TextMap.GetValue("Text1219"))
    elseif code == 1037 then
        MessageMrg.show(TextMap.GetValue("Text1220"))
    elseif code == 1038 then
        MessageMrg.show(TextMap.GetValue("Text1221"))
    elseif code == 1039 then
        MessageMrg.show(TextMap.GetValue("Text1222"))
    elseif code == 1040 then
        MessageMrg.show(TextMap.GetValue("Text1223"))
    elseif code == 1041 then
        MessageMrg.show(TextMap.GetValue("Text1224"))
    elseif code == 1042 then
        MessageMrg.show(TextMap.GetValue("Text1225"))
    elseif code == 1050 then
        MessageMrg.show(TextMap.GetValue("Text1226"))
    elseif code == 1051 then
        MessageMrg.show(TextMap.GetValue("Text1227"))
    elseif code == 1071 then
        MessageMrg.show(TextMap.GetValue("Text1228"))
    else
        MessageMrg.show(code .. TextMap.GetValue("Text1229"))
    end
end

function m:ShowTipByReturnCode_dh(code)
    -- 200  //会员不存在
    -- 201  //公会副本进度不足
    -- 202  //公会参拜进度不足
    -- 203  //奖励已领取
    -- 204  //副本通关奖励未找到
    -- 205  //参拜奖励未找到
    -- 206  //宝箱已被人领取
    -- 207  //副本未找到
    if code == 200 then
        MessageMrg.show(TextMap.GetValue("Text1230"))
    elseif code == 201 then
        MessageMrg.show(TextMap.GetValue("Text1231"))
    elseif code == 202 then
        MessageMrg.show(TextMap.GetValue("Text1232"))
    elseif code == 203 then
        MessageMrg.show(TextMap.GetValue("Text1233"))
    elseif code == 204 then
        MessageMrg.show(TextMap.GetValue("Text1234"))
    elseif code == 205 then
        MessageMrg.show(TextMap.GetValue("Text1235"))
    elseif code == 206 then
        MessageMrg.show(TextMap.GetValue("Text1236"))
    elseif code == 207 then
        MessageMrg.show(TextMap.GetValue("Text1237"))
    else
        MessageMrg.show(code .. TextMap.GetValue("Text1229"))
    end
end

return m

--GuildDatas = require("uLuaModule/modules/league/uLeague_Datas") getBoxListById