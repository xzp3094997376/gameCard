--
-- Created by IntelliJ IDEA.
-- User: xiyou
-- Date: 2014/10/28
-- Time: 17:21
-- To change this template use File | Settings | File Templates.
-- 数据收集
local guide_scrite = require("uLuaModule/modules/guide/guide_scrite.lua")
-- local ffi = require 'ffi'

local dataEye = {}
local _map = {
    money = TextMap.GetValue("Text146"),
    gold = TextMap.GetValue("Text146"),
    honor = TextMap.GetValue("Text146"), --竞技场
    credit = TextMap.GetValue("Text146"), --虚夜宫
    donate = TextMap.GetValue("Text146"), --协会
    soul = TextMap.GetValue("Text146"),
    bp = TextMap.GetValue("Text146"),
    char = TextMap.GetValue("Text47"),
    charPiece = TextMap.GetValue("Text48"),
    equip = TextMap.GetValue("Text49"),
    equipPiece = TextMap.GetValue("Text147"),
    item = TextMap.GetValue("Text50"),
    reel = TextMap.GetValue("Text51"),
    reelPiece = TextMap.GetValue("Text52"),
    exp = TextMap.GetValue("Text146"),
    ghost = TextMap.GetValue("Text148"),
    ghostPiece = TextMap.GetValue("Text149")
}
function dataEye.resToCn(_type)
    if _map[_type] then return _map[_type] end
    return _type
end

------------------------------------------ 闯关--------------------------------------------------------------------------
function dataEye.fightChapter(type, battleid, team, result)
    local battle = result.battle3
    --    dataEye.levels(type, battleid, battle.win)

    if type == "commonChapter" then
        local row = TableReader:TableRowByID(type, battleid)
        if row == nil then return end
        local name = TextMap.GetValue("Text150") .. "-" .. row.name
        DataEyeTool.DcLevelsBegin(battleid, name)
        if battle.win then
            DataEyeTool.DcLevelsComplete(battleid .. "_" .. name)
            dataEye.levelsDrop(TextMap.GetValue("Text151"), name, result)
        else
            DataEyeTool.DcLevelsFail(battleid .. "_" .. name, TextMap.GetValue("Text152"))
        end

        dataEye.enterBattle(name, team)

    elseif type == "heroChapter" then
        local row = TableReader:TableRowByID(type, battleid)
        if row == nil then return end
        local name = TextMap.GetValue("Text153") .. "-" .. row.name
        DataEyeTool.DcLevelsBegin(10000 + battleid, name)
        if battle.win then
            DataEyeTool.DcLevelsComplete((10000 + battleid) .. "_" .. name)
            dataEye.levelsDrop(TextMap.GetValue("Text154"), name, result)
        else
            DataEyeTool.DcLevelsFail((10000 + battleid) .. "_" .. name, TextMap.GetValue("Text152"))
        end
        dataEye.enterBattle(name, team)
    end
end

--扫荡
function dataEye.sweepChapter(type, battleid, num, result)
    local map = {}
    if type == "commonChapter" then
        local row = TableReader:TableRowByID(type, battleid)
        if row == nil then return end
        local name = row._chapter.name .. "-" .. row.name
        map.type_id_num = name .. TextMap.GetValue("Text155") .. num .. TextMap.GetValue("Text156")
        DataEyeTool.onEvent(TextMap.GetValue("Text157"), map)
    elseif type == "heroChapter" then
        local row = TableReader:TableRowByID(type, battleid)
        if row == nil then return end
        local name = row.chapter_name .. "-" .. row.name
        map.type_id_num = name .. TextMap.GetValue("Text155") .. num .. TextMap.GetValue("Text156")
        DataEyeTool.onEvent(TextMap.GetValue("Text158"), map)
    end
end

--推图
function dataEye.levels(type, battleid, _win)
    local map = {}
    local win = "false"
    if _win then win = "true" end
    map.type_id_win = type .. "_" .. battleid .. "_" .. win

    DataEyeTool.onEvent(TextMap.GetValue("Text159"), map)
end

--上阵信息
function dataEye.enterBattle(name, team)
    local map = {}
    local key = name .. "_"
    table.foreach(team, function(i, v)
        if v ~= 0 and v ~= "0" then
            map.type_char = key .. TableReader:TableRowByID("char", Tool.getDictId(v) ).name
            DataEyeTool.onEvent(TextMap.GetValue("Text160"), map)
        end
    end)
end

--关卡掉落
function dataEye.levelsDrop(key, name, drop)
    local map = {}

    local list = RewardMrg.getList(drop)
    table.foreach(list, function(i, v)
        local name = v.cnName
        if not name then name = v.name end
        map.section_type_id_num = name .. "_" .. dataEye.resToCn(v:getType()) .. "_" .. name .. "_" .. v.rwCount
        DataEyeTool.onEvent(key .. TextMap.GetValue("Text161"), map)
    end)
end

-----------------------------------------------------------------------------------------------------------------------

------------------------------------------ 悬赏--------------------------------------------------------------------------
function dataEye.fightSpecialChapter(id, team, result)
    local battle = result.battle3

    local map = {}
    local win = "false"
    if battle.win then win = "true" end
    local tb = TableReader:TableRowByID("specialChapter", id)
    local name = tb.show_name .. TextMap.GetValue("Text162") .. tb.section .. ")_"
    map.id_win = name .. win
    local _id = ""
    if tb._chapter.type == "xuanshang" then
        _id = TextMap.GetValue("Text163")
    else
        _id = TextMap.GetValue("Text164")
    end
    DataEyeTool.onEvent(_id, map)

    if battle.win then
        dataEye.specialChapterDrop(_id, name, result)
    end
    dataEye.specialChapterEnterBattle(_id, name, team)
    result = nil
    team = nil
    id = nil
end

--试练悬赏掉落
function dataEye.specialChapterDrop(_id, id, drop)
    local map = {}
    local key = id
    local list = RewardMrg.getList(drop)
    table.foreach(list, function(i, v)
        map.specialChapter_type_id_num = key .. dataEye.resToCn(v:getType()) .. "_" .. v.name .. "_" .. v.rwCount
        DataEyeTool.onEvent(_id .. TextMap.GetValue("Text161"), map)
    end)
end

function dataEye.specialChapterEnterBattle(_id, id, team)
    local map = {}
    local key = id
    table.foreach(team, function(i, v)
        if v ~= 0 and v ~= "0" then
            map.specialChapterId_charId = key .. TableReader:TableRowByID("char", Tool.getDictId(v) ).name
            DataEyeTool.onEvent(_id .. TextMap.GetValue("Text165"), map)
        end
    end)
end

-----------------------------------------------------------------------------------------------------------------------



---------------------------------------------- 虚夜宫--------------------------------------------------------------------
-- 战斗
function dataEye.XuYeGongFight(id, team, result)
    local battle = result.battle3
    local map = {}
    local win = "false"
    if battle.win then win = "true" end
    local name = id .. "_"
    map.id_win = name .. win
    DataEyeTool.onEvent(TextMap.GetValue("Text166"), map)
    dataEye.XuYeGongEnterBattle(name, team)
    result = nil
    team = nil
    id = nil
end

--开宝箱
function dataEye.XuYeGongPrize(id, result)
    local map = {}
    local key = id
    local list = RewardMrg.getList(result)
    table.foreach(list, function(i, v)
        local name = v.cnName
        if not name then name = v.name end
        map.id_type_id_num = key .. dataEye.resToCn(v:getType()) .. "_" .. name .. "_" .. v.rwCount
        DataEyeTool.onEvent(TextMap.GetValue("Text167"), map)
    end)
end

function dataEye.XuYeGongEnterBattle(id, team)
    local map = {}
    local key = id
    table.foreach(team, function(i, v)
        if v ~= 0 and v ~= "0" then
            map.id_charId = key .. TableReader:TableRowByID("char", Tool.getDictId(v) ).name
            DataEyeTool.onEvent(TextMap.GetValue("Text168"), map)
        end
    end)
end

-----------------------------------------------------------------------------------------------------------------------



---------------------------------------------- 竞技场--------------------------------------------------------------------
function dataEye.challengePlayer(team, pid2, result)
    local map = {}
    map.playerLevel = Player.Info.level
    DataEyeTool.onEvent(TextMap.GetValue("Text169"), map)

    map = {}
    map.PlayerId = Player.playerId
    DataEyeTool.onEvent(TextMap.GetValue("Text170"), map)

    local list = RewardMrg.getList(result)
    table.foreach(list, function(i, v)
        local name = v.cnName
        if not name then name = v.name end
        map.type_id_num = dataEye.resToCn(v:getType()) .. "_" .. name .. "_" .. v.rwCount
        DataEyeTool.onEvent(TextMap.GetValue("Text171"), map)
    end)
    map = {}
    map.honor = Player.Resource.honor
    DataEyeTool.onEvent(TextMap.GetValue("Text172"), map)
end

-----------------------------------------------------------------------------------------------------------------------



---------------------------------------------- 抽卡--------------------------------------------------------------------
--[[
1	金币抽卡
2	钻石抽卡
3	钻石十连抽
4	金币免费
5	钻石免费
6	金币十连抽
7	新手第一次钻石十连抽
8	新手第一次抽卡
]]
local drawMap = {
    [1] = TextMap.GetValue("Text173"),
    [2] = TextMap.GetValue("Text174"),
    [3] = TextMap.GetValue("Text175"),
    [4] = TextMap.GetValue("Text176"),
    [5] = TextMap.GetValue("Text177"),
    [6] = TextMap.GetValue("Text178"),
    [7] = TextMap.GetValue("Text179"),
    [8] = TextMap.GetValue("Text180"),
    [10] = TextMap.GetValue("Text181")
}
function dataEye.draw(id, result)
    local map = {}
    map.type = drawMap[id]
    DataEyeTool.onEvent(TextMap.GetValue("Text182"), map)
    map = {}
    map.level_type = Player.Info.level .. "_" .. (drawMap[id] or id)
    DataEyeTool.onEvent(TextMap.GetValue("Text183"), map)
    if id == 3 then
        local drop = result
        local list = RewardMrg.getList(drop)
        table.foreach(list, function(i, v)
            map.drawId_type_id_num = drawMap[id] .. "_" .. v:getType() .. "_" .. v.id .. "_" .. v.rwCount
            DataEyeTool.onEvent(TextMap.GetValue("Text184"), map)
        end)
    end
end

-----------------------------------------------------------------------------------------------------------------------



---------------------------------------------- 使用道具------------------------------------------------------------------
function dataEye.useItem(type, key, num, result, id)
    local map = {}
    map.type_id_num = type .. "_" .. id .. "_" .. num
    DataEyeTool.onEvent(TextMap.GetValue("Text185"), map)
end

-----------------------------------------------------------------------------------------------------------------------

---------------------------------------------- 商店购买------------------------------------------------------------------
--[[
1	黑市
2	浦原商店
3	公会商店
4	竞技场商店
5	虚夜宫
6	永久黑市
7	杂货
-- ]]

local shopMap = {
    [1] = TextMap.GetValue("Text186"),
    [2] = TextMap.GetValue("Text187"),
    [3] = TextMap.GetValue("Text188"),
    [4] = TextMap.GetValue("Text189"),
    [5] = TextMap.GetValue("Text166"),
    [6] = TextMap.GetValue("Text190"),
    [7] = TextMap.GetValue("Text191"),
    [8] = TextMap.GetValue("Text192"),
    [20] = TextMap.GetValue("Text193"),
    [21] = TextMap.GetValue("Text194"),
    [22] = TextMap.GetValue("Text195"),
    [30] = TextMap.GetValue("Text196"),
    [31] = TextMap.GetValue("Text1643"),
}

function dataEye.buyShop(shop_id, result)
    local key = shopMap[shop_id] or TextMap.GetValue("Text197")
    local list = RewardMrg.getList(result)
    table.foreach(list, function(i, v)
        local map = {}
        local name = v.cnName
        if not name then name = v.name end
        map.type_id_num = dataEye.resToCn(v:getType()) .. "_" .. name .. "_" .. v.rwCount
        DataEyeTool.onEvent(key .. TextMap.GetValue("Text198"), map)
    end)

    local item = list[1]
    local consume = RewardMrg.getConsume(result)[1]
    if item ~= nil and consume ~= nil then
        local _item_type = dataEye.resToCn(item:getType())
        local _type = TextMap[consume:getType()] or TextMap.GetValue("Text146")
        DataEyeTool.DcItemBuy(item.name, _item_type, item.rwCount, consume.rwCount, _type, key)
    end
end

function dataEye.refreshShop(shop_id)
    local key = shopMap[shop_id]
    local _shop = Player.Shop[shop_id]
    local map = {}
    map.costType_num = _shop.reset_type .. "_" .. _shop.reset_arg
    if key~=nil then 
        DataEyeTool.onEvent(TextMap.GetValue("Text199") .. key .. TextMap.GetValue("Text200"), map)
    end 
end

-----------------------------------------------------------------------------------------------------------------------

---------------------------------------------- 装备直买------------------------------------------------------------------
function dataEye.buyEquip(itemType, id, num, result)
    local map = {}
    map.type_id_num = itemType .. "_" .. id .. "_" .. num
    DataEyeTool.onEvent(TextMap.GetValue("Text201"), map)
    local list = RewardMrg.getList(result)[1]
    local consume = RewardMrg.getConsume(result)[1]
    if list ~= nil and consume ~= nil then
        local _item_type = dataEye.resToCn(list:getType())
        local _type = TextMap[consume:getType()] or TextMap.GetValue("Text146")
        DataEyeTool.DcItemBuy(list.name, _item_type, list.rwCount, consume.rwCount, _type, TextMap.GetValue("Text202"))
    end
end

----------------------------------------------------------------------------------------------------------------------

--------------------------------------------- 资源统计--------------------------------------------------------------------

local apiList = {
    logic_drawHandler_draw = TextMap.GetValue("Text203"),
    logic_drawHandler_useItem = TextMap.GetValue("Text204"),
    logic_drawHandler_sellItem = TextMap.GetValue("Text205"),
    logic_trainHandler_charLevelUp = TextMap.GetValue("Text206"),
    logic_trainHandler_charStarUp = TextMap.GetValue("Text207"),
    logic_trainHandler_charColorUp = TextMap.GetValue("Text208"),
    logic_equipHandler_wearEquip = TextMap.GetValue("Text209"),
    logic_equipHandler_equipUp = TextMap.GetValue("Text210"),
    logic_equipHandler_oneStepEquipUp = TextMap.GetValue("Text211"),
    logic_trainHandler_skillUp = TextMap.GetValue("Text212"),
    logic_equipHandler_combineFunc = TextMap.GetValue("Text213"),
    logic_chapterHandler_fightChapter = TextMap.GetValue("Text159"),
    logic_chapterHandler_sweepChapter = TextMap.GetValue("Text214"),
    logic_chapterHandler_resetChapter = TextMap.GetValue("Text215"),
    logic_xilianHandler_xilian = TextMap.GetValue("Text216"),
    logic_xilianHandler_changeLock = TextMap.GetValue("Text217"),
    logic_xilianHandler_replaceAttr = TextMap.GetValue("Text218"),
    logic_transformHandler_charTransUp = TextMap.GetValue("Text219"),
    logic_chapterHandler_fightSpecialChapter = TextMap.GetValue("Text220"),
    logic_chapterHandler_resetSpecialChapter = TextMap.GetValue("Text221"),
    logic_chapterHandler_resetSpecialChapterTicket = TextMap.GetValue("Text222"),
    logic_shopHandler_checkUpdateSpecialChapter = "",
    logic_shopHandler_buy = TextMap.GetValue("Text223"),
    logic_shopHandler_buyVipPackage = TextMap.GetValue("Text224"),
    logic_shopHandler_refresh = TextMap.GetValue("Text225"),
    logic_shopHandler_checkUpdate = "",
    logic_vsbattleHandler_refreshPlayer = TextMap.GetValue("Text226"),
    logic_vsbattleHandler_changeDefendTeam = "changeDefendTeam",
    logic_vsbattleHandler_challengePlayer = TextMap.GetValue("Text227"),
    logic_vsbattleHandler_clearCdTime = TextMap.GetValue("Text228"),
    logic_vsbattleHandler_addFightTime = TextMap.GetValue("Text229"),
    logic_vsbattleHandler_getOneRecord = TextMap.GetValue("Text230"),
    logic_vsbattleHandler_getRankList = TextMap.GetValue("Text231"),
    logic_vsbattleHandler_showDetailInfo = TextMap.GetValue("Text232"),
    logic_mailHandler_drawAllMails = TextMap.GetValue("Text233"),
    logic_mailHandler_drawMails = TextMap.GetValue("Text234"),
    logic_mailHandler_readMails = TextMap.GetValue("Text235"),
    logic_mailHandler_deleteMails = TextMap.GetValue("Text236"),
    logic_checkinHandler_checkin = TextMap.GetValue("Text237"),
    logic_buyresourceHandler_buyBp = TextMap.GetValue("Text238"),
    logic_buyresourceHandler_buyMoney = TextMap.GetValue("Text28"),
    logic_playerInfoHandler_changeName = TextMap.GetValue("Text239"),
    logic_playerInfoHandler_changeHeadImg = TextMap.GetValue("Text240"),
    logic_userHandler_randomName = "",
    logic_payHandler_getPayUrl = "",
    logic_payHandler_innerPay = "",
    logic_userHandler_createPlayer = TextMap.GetValue("Text241"),
    logic_userHandler_queryPidByUid = "",
    logic_userHandler_loadPlayer = "",
    logic_xuYeGongHandler_fightEnemy = TextMap.GetValue("Text242"),
    logic_xuYeGongHandler_getPrize = TextMap.GetValue("Text243"),
    logic_xuYeGongHandler_resetEnemy = TextMap.GetValue("Text244"),
    logic_taskHandler_submitTask = TextMap.GetValue("Text245"),
    logic_sessionHandler_checkUpdate = "",
    logic_systemHandler_getNoticeInfo = "",
    logic_buyresourceHandler_buySkillpoint = TextMap.GetValue("Text246"),
    logic_systemHandler_setGuide = "",
    logic_systemHandler_checkGiftCode = TextMap.GetValue("Text247"),
    logic_buyresourceHandler_buyEquip = TextMap.GetValue("Text248"),
    logic_buyresourceHandler_buyMoneyShop = TextMap.GetValue("Text249"),
    logic_qianCengTaHandler_fightTower = TextMap.GetValue("Text250"),
    logic_trainHandler_oneStepcharLevelUp = TextMap.GetValue("Text251"),
    logic_qianCengTaHandler_resetTower = TextMap.GetValue("Text252"),
    logic_qianCengTaHandler_fightTower = TextMap.GetValue("Text253"),
    logic_qianCengTaHandler_sweepTower = TextMap.GetValue("Text254"),
    logic_qianCengTaHandler_getTowerReward = TextMap.GetValue("Text255"),
    logic_qianCengTaHandler_bugTowerTimes = TextMap.GetValue("Text256"),
    logic_recoveryCardHandler_decompose = TextMap.GetValue("Text257"),
    logic_recoveryCardHandler_rebirth = TextMap.GetValue("Text258"),
    logic_activityHandler_buyInvestPlan = TextMap.GetValue("Text259"),
    logic_activityHandler_fillCheckIn = TextMap.GetValue("Text260"),
    logic_activityHandler_exchange = TextMap.GetValue("Text261"),
    logic_ghostHandler_ghostCombineByChar = TextMap.GetValue("Text262"),
    logic_ghostHandler_ghostLevelUp = TextMap.GetValue("Text263"),
    logic_ghostHandler_ghostAutoLevelUp = TextMap.GetValue("Text264"),
    logic_ghostHandler_ghostXilian = TextMap.GetValue("Text265"),
    logic_ghostHandler_ghostXilianTen = TextMap.GetValue("Text266"),
    logic_ghostHandler_ghostPowerUp = TextMap.GetValue("Text267"),
    logic_equipHandler_gd_equipOn = TextMap.GetValue("Text268"),
    logic_ghostHandler_ghostReturn = TextMap.GetValue("Text269"),
    logic_qianCengTaHandler_fightTower = TextMap.GetValue("Text270"),
    logic_qianCengTaHandler_resetTower = TextMap.GetValue("Text271"),
    logic_qianCengTaHandler_sweepTower = TextMap.GetValue("Text272"),
    logic_qianCengTaHandler_getTowerReward = TextMap.GetValue("Text273"),
    logic_qianCengTaHandler_bugTowerTimes = TextMap.GetValue("Text274"),
    logic_ghostHandler_ghostCombineByPiece = TextMap.GetValue("Text262"),
    logic_activityHandler_getActGift = TextMap.GetValue("Text275"),
    logic_shopHandler_buyPartly = TextMap.GetValue("Text276"),
    logic_chapterHandler_saveTeam = TextMap.GetValue("Text277"),
    logic_playerInfoHandler_checkRes = "",
    logic_activityHandler_getActivity = "",
    logic_agencyHandler_onFight = TextMap.GetValue("Text1644"),
    logic_agencyHandler_getReward = TextMap.GetValue("Text279"),
    logic_BloodlineHandler_BloodlineLvup = TextMap.GetValue("Text280"),
    logic_agencyHandler_startPatrol = TextMap.GetValue("Text281"),
    logic_daXuHandler_fightDaxu = TextMap.GetValue("Text282"),
    logic_daXuHandler_useTaoFaLing = TextMap.GetValue("Text283"),
    logic_daXuHandler_getGXReward = TextMap.GetValue("Text284"),
    logic_worldBossHandler_getReward = TextMap.GetValue("Text285"),
    logic_worldBossHandler_addBuff = TextMap.GetValue("Text286"),
    logic_worldBossHandler_clearCDTime = TextMap.GetValue("Text287"),
    logic_worldBossHandler_fightBoss = TextMap.GetValue("Text288"),
    logic_taskHandler_getPointReward = TextMap.GetValue("Text289"),
    logic_GuildHandler_sacrifice = TextMap.GetValue("Text290"),
    logic_GuildHandler_defiance = TextMap.GetValue("Text291"),
    logic_GuildHandler_useGuildFightItem = TextMap.GetValue("Text292"),
    logic_GuildHandler_sacrificeReward = TextMap.GetValue("Text293"),
    logic_GuildHandler_copyPassReward = TextMap.GetValue("Text294"),
    logic_GuildHandler_getBoxRewardById = TextMap.GetValue("Text295"),
    logic_GuildHandler_buyPkgShop = TextMap.GetValue("Text296"),
}

--[[
    公会币产出消耗
    征服币产出消耗
    固灵丸产出消耗
    荣誉币产出消耗
    金币产出分布
    金币消耗分布
    钻石消耗分布
]]

function dataEye.getActGift(id, gid, result)
    -- local map = {}
    -- map.act_id = id
    -- map.gift = id
    -- DataEyeTool.onEvent(TextMap.GetValue("Text275"), map)
end


function dataEye:res(api, jo)
    if apiList[api] == "" then return end
    local key = apiList[api] or api
    local list = RewardMrg.getList(jo)
    table.foreachi(list, function(i, v)
        local _type = v:getType()
        local name = v.name
        if _type == "money" then
            local map = { type_num = key .. "_" .. v.rwCount }
            DataEyeTool.onEvent(TextMap[_type] .. TextMap.GetValue("Text297"), map)
            name = v.cnName
            --虚拟币收集
            DataEyeTool.DCCoinGain(key, name, v.rwCount, Tool.getCountByType(_type))
        elseif _type == "gold" then
            local map = { type_num = key .. "_" .. v.rwCount }
            DataEyeTool.onEvent(TextMap[_type] .. TextMap.GetValue("Text297"), map)
            name = v.cnName
            DataEyeTool.DCCoinGain(key, name, v.rwCount, Tool.getCountByType(_type))
        elseif _type == "honor" then
            local map = { type_num = key .. "_" .. v.rwCount }
            DataEyeTool.onEvent(TextMap[_type] .. TextMap.GetValue("Text297"), map)
            name = v.cnName
            DataEyeTool.DCCoinGain(key, name, v.rwCount, Tool.getCountByType(_type))
        elseif _type == "credit" then
            local map = { type_num = key .. "_" .. v.rwCount }
            DataEyeTool.onEvent(TextMap[_type] .. TextMap.GetValue("Text297"), map)
            name = v.cnName
            DataEyeTool.DCCoinGain(key, name, v.rwCount, Tool.getCountByType(_type))
        elseif _type == "donate" then
            local map = { type_num = key .. "_" .. v.rwCount }
            DataEyeTool.onEvent(TextMap[_type] .. TextMap.GetValue("Text297"), map)
            name = v.cnName
            DataEyeTool.DCCoinGain(key, name, v.rwCount, Tool.getCountByType(_type))
        elseif _type == "soul" then
            local map = { type_num = key .. "_" .. v.rwCount }
            DataEyeTool.onEvent(TextMap[_type] .. TextMap.GetValue("Text297"), map)
            name = v.cnName
            DataEyeTool.DCCoinGain(key, name, v.rwCount, Tool.getCountByType(_type))
        elseif _type == "item" and v.name == TextMap.GetValue("Text104") then
            local map = { type_num = key .. "_" .. v.rwCount }
            DataEyeTool.onEvent(v.name .. TextMap.GetValue("Text297"), map)
            name = v.name
            --        elseif _type == "bp" then
            --            local map = { type_num = key .. "_" .. v.rwCount }
            --            DataEyeTool.onEvent(TextMap[_type] .. TextMap.GetValue("Text297"), map)
        end
        if api ~= logic_shopHandler_buy and api ~= "logic_buyresourceHandler_buyEquip" then
            DataEyeTool.DcItemGet(name, dataEye.resToCn(_type), v.rwCount, key)
            return
        end
    end)
    list = RewardMrg.getConsume(jo)

    table.foreachi(list, function(i, v)
        local _type = v:getType()
        local name = v.name
		local count = tonumber(v.rwCount)
        if _type == "money" then
            local map = { type_num = key .. "_" .. count }
            DataEyeTool.onEvent(TextMap[_type] .. TextMap.GetValue("Text200"), map)
            name = v.cnName
            DataEyeTool.DCCoinLost(key, name, count, Tool.getCountByType(_type))
        elseif _type == "gold" then
            local map = { type_num = key .. "_" .. count }
            DataEyeTool.onEvent(TextMap[_type] .. TextMap.GetValue("Text200"), map)
            name = v.cnName
            DataEyeTool.DCCoinLost(key, name, count, Tool.getCountByType(_type))
        elseif _type == "honor" then
            local map = { type_num = key .. "_" .. count }
            DataEyeTool.onEvent(TextMap[_type] .. TextMap.GetValue("Text200"), map)
            name = v.cnName
            DataEyeTool.DCCoinLost(key, name, count, Tool.getCountByType(_type))
        elseif _type == "credit" then
            local map = { type_num = key .. "_" .. count }
            DataEyeTool.onEvent(TextMap[_type] .. TextMap.GetValue("Text200"), map)
            name = v.cnName
            DataEyeTool.DCCoinLost(key, name, count, Tool.getCountByType(_type))
        elseif _type == "donate" then
            local map = { type_num = key .. "_" .. count }
            DataEyeTool.onEvent(TextMap[_type] .. TextMap.GetValue("Text200"), map)
            name = v.cnName
            DataEyeTool.DCCoinLost(key, name, count, Tool.getCountByType(_type))
        elseif _type == "bp" then
            local map = { type_num = key .. "_" .. count }
            DataEyeTool.onEvent(TextMap[_type] .. TextMap.GetValue("Text200"), map)
            name = v.cnName
            DataEyeTool.DCCoinLost(key, name, count, Tool.getCountByType(_type))
        elseif _type == "soul" then
            local map = { type_num = key .. "_" .. count }
            DataEyeTool.onEvent(TextMap[_type] .. TextMap.GetValue("Text200"), map)
            name = v.cnName
            DataEyeTool.DCCoinLost(key, name, count, Tool.getCountByType(_type))
        elseif _type == "item" and v.name == TextMap.GetValue("Text104") then
            local map = { type_num = key .. "_" .. count }
            DataEyeTool.onEvent(v.name .. TextMap.GetValue("Text200"), map)
            name = v.name
        end
        if api ~= logic_shopHandler_buy and api ~= "logic_buyresourceHandler_buyEquip" then
            local n = dataEye.resToCn(_type)
            if n then
                DataEyeTool.DcItemConsume(name, n, count, key)
            end
            return
        end
        --虚拟币收集
    end)
    dataEye.ctrl(key)
end

----------------------------------------------------------------------------------------------------------------------

--------------------------------------------- vip系统--------------------------------------------------------------------
function dataEye.vipLevel(vip, lv)
    local map = {}
    map.level_vip = lv .. "_" .. vip
    DataEyeTool.onEvent(TextMap.GetValue("Text298"), map)
end

function dataEye.buyVipPackage(id)
    local map = {
        id = id
    }
    DataEyeTool.onEvent(TextMap.GetValue("Text299"), map)
end

----------------------------------------------------------------------------------------------------------------------

--------------------------------------------- 成就系统.日常任务--------------------------------------------------------------------
function dataEye.submitTask(id, result)
    local map = {}
    local row = TableReader:TableRowByID("allTasks", id)
    if row == nil then return end
    local key = ""
    local name = row.show_name
    map.name = name
    if row.task_type == "daily" then
        --日常
        key = TextMap.GetValue("Text300")
    else
        --成就
        key = TextMap.GetValue("Text301")
    end

    DataEyeTool.onEvent(TextMap.GetValue("Text302") .. key, map)
    map = {}
    local list = RewardMrg.getList(result)
    table.foreach(list, function(i, v)
        map.taskId_type_id_num = name .. "_" .. dataEye.resToCn(v:getType()) .. "_" .. v.name .. "_" .. v.rwCount
        DataEyeTool.onEvent(key .. TextMap.GetValue("Text297"), map)
    end)
end


----------------------------------------------------------------------------------------------------------------------

--------------------------------------------- 活动系统--------------------------------------------------------------------

----------------------------------------------------------------------------------------------------------------------

--------------------------------------------- 新手流程--------------------------------------------------------------------
function dataEye.setGuide(id, value)
    local map = {}
    map.id = id
    -- DataEyeTool.onEvent("6月1-新手步骤:" .. id, map)
end
local time = 0

local function get(url,cb)
    ffi.cdef[[
        void *curl_easy_init();
        int curl_easy_setopt(void *curl, int option, ...);
        int curl_easy_perform(void *curl);
        void curl_easy_cleanup(void *curl);
        char *curl_easy_strerror(int code);
    ]]

    local libcurl = ffi.load('libcurl')   

    fptr = ffi.cast("size_t (*)(char *, size_t, size_t, void *)", cb)

    local curl = libcurl.curl_easy_init()
    local CURLOPT_URL = 10002 -- 参考 curl/curl.h 中定义
    local CURLOPT_WRITEFUNCTION = 20011
    if curl then
        libcurl.curl_easy_setopt(curl, CURLOPT_URL, url)
        libcurl.curl_easy_setopt(curl, CURLOPT_WRITEFUNCTION, fptr)
        res = libcurl.curl_easy_perform(curl)
        if res ~= 0 then
            print(ffi.string(libcurl.curl_easy_strerror(res)))
        end
        libcurl.curl_easy_cleanup(curl)
    end
end

function decodeURI(s)
    s = string.gsub(s, '%%(%x%x)', function(h) return string.char(tonumber(h, 16)) end)
    return s
end

function encodeURI(s)
    s = string.gsub(s, "([^%w%.%- ])", function(c) return string.format("%%%02X", string.byte(c)) end)
    return string.gsub(s, " ", "+")
end

function dataEye.logSaveToServer(log,ret)
    --if ClientTool.Platform == "pc" then 
    --    return
    --end
	if ClientTool.Platform ~= "" then 
        return
    end
    local url = 'http://182.254.132.91/admin/log/collect.do?data='
    if not ret then
        local gameId = "1"
        if "EA7D0701220EF0E4ACA26BC41B7C2AF9" ~= GlobalVar.dataEyeAppID then 
            gameId = "3"
        end
        table.insert(log,1,{"1001","1","0",gameId})
    end
    local str = json.encode(log)
    str = encodeURI(str)
    url = url..str
    local c=coroutine.create(function()
        local www = WWW(url)
        Yield(www)
        if Slua.IsNull(www.error) then 
            -- local data = json.decode(www.text)
             time = 0
        else
             if time < 3 then
                    time = time + 1
                    dataEye.logSaveToServer(log,true)
            end
        end
    end)
    coroutine.resume(c)
    -- local function log_cb(ptr, size, nmemb, stream)
    --         print("Data callback!\n") -- not even called once
    --         local bytes = size*nmemb
    --         local buf = ffi.new('char[?]', bytes+1)
    --         ffi.copy(buf, ptr, bytes)
    --         buf[bytes] = 0
    --         data = ffi.string(buf)
    --         print(data)
    --         data = json.decode(data)
    --         if data.code == 1 then 
    --              time = 0
    --         else
    --              if time < 3 then
    --                     time = time + 1
    --                     dataEye.logSaveToServer(log,true)
    --              end
    --         end
    --         return bytes
    -- end
    -- get(url,log_cb)
end

function dataEye.logGuide(log)
    local map = {}
    local str = json.encode(log)
    map.log = str
    DataEyeTool.onEvent(TextMap.GetValue("Text303"), map)

    dataEye.logSaveToServer(log)
end

----------------------------------------------------------------------------------------------------------------------


---------------------------------------------------------------------- 充值--------------------------------------------------------------
function dataEye.pay(total, unitName, count, orderId)
    --    local orderId = ""
    --    DataEyeTool.paymentSuccess(orderId,total/100,"RMB","凌镜支付")
    --    local map = {}
    --    map.type_count_cost = unitName .. "_" .. count.."件_" .. (total/100) .. "元"
    --    DataEyeTool.onEvent("充值成功", map)
end

function dataEye.payFail(total, unitName, count)
    -- local map = {}
    -- map.type_count_cost = unitName.."_"..count.."件_"..total/100.."元"
    -- DataEyeTool.onEvent("充值失败", map)
end

------------------------------------------------------------------------------------- 登陆---------------------------------------------------------------------------------------------------------
function dataEye.login(uid)
    local map = {}
    map.uid = uid
    DataEyeTool.onEvent(TextMap.GetValue("Text304"), map)
end

function dataEye.selectServer(uid, server)
    local map = {}
    map.uid = uid
    map.server = server
    DataEyeTool.onEvent(TextMap.GetValue("Text305"), map)
end

-------------------------------------------------- 千层塔-----------------------------------------------------------------
function dataEye.QCTChallenge(id, result)
    local battle = result.battle3
    local map = {}
    local win = "false"
    if battle.win then win = "true" end

    local name = TextMap.GetValue("Text306") .. id .. TextMap.GetValue("Text307")
    map.id_win = name .. win

    DataEyeTool.onEvent(TextMap.GetValue("Text308"), map)
    result = nil
    id = nil
end

------------------------------------------------- 鬼道-------------------------------------------------------------------
-- 鬼道-强化
function dataEye.ghostLevelUp(key, result)
    local info = Player.Ghost[key]
    if info.id ~= 0 then
        local row = TableReader:TableRowByID("ghost", info.id)
        local name = ""
        if row then
            name = row.name
        end
        local map = {}
        map.name_level = name .. "_" .. info.level
        DataEyeTool.onEvent(TextMap.GetValue("Text309"), map)
    end
end

--鬼道-进阶
function dataEye.ghostPowerUp(key, result)
    local info = Player.Ghost[key]
    if info.id ~= 0 then
        local row = TableReader:TableRowByID("ghost", info.id)
        local name = ""
        if row then
            name = row.name
        end
        local map = {}
        map.name_power = name .. "_" .. info.power
        DataEyeTool.onEvent(TextMap.GetValue("Text310"), map)
    end
end

--鬼道-修炼
function dataEye.ghostXilian(key, tp, result)
    local info = Player.Ghost[key]
    if info.id ~= 0 then
        local row = TableReader:TableRowByID("ghost", info.id)
        local name = ""
        if row then
            name = row.name
        end
        local Type = {
            common = TextMap.GetValue("Text311"),
            expert = TextMap.GetValue("Text312"),
            master = TextMap.GetValue("Text313")
        }
        local map = {}
        map.name_type = name .. "_" .. Type[tp]
        DataEyeTool.onEvent(TextMap.GetValue("Text314"), map)
    end
end

function dataEye.ghostReturn(args, result)
    for i = 1, #args do
        local key = args[1]
        local info = Player.Ghost[key]
        if info.id ~= 0 then
            local row = TableReader:TableRowByID("ghost", info.id)
            local name = ""
            if row then
                name = row.name
            end
            local map = {}
            map.name_num = name .. "_" .. 1
            DataEyeTool.onEvent(TextMap.GetValue("Text315"), map)
        end
    end
end



------------------------------------------------------------------------------------------------------------------------

local moduleName = {
    shop_xuyegong = TextMap.GetValue("Text316"),
    shop_xiehui = TextMap.GetValue("Text188"),
    shop_jingjichang = TextMap.GetValue("Text189"),
    jingyingguanqia1 = TextMap.GetValue("Text154"),
    chapter1 = TextMap.GetValue("Text151"),
    chouka = TextMap.GetValue("Text317"),
    tiaozhan = TextMap.GetValue("Text164"),
    xuanshang = TextMap.GetValue("Text163"),
    jingjichang = TextMap.GetValue("Text318"),
    qianghua = TextMap.GetValue("Text210"),
    jineng = TextMap.GetValue("Text319"),
    chapter = TextMap.GetValue("Text151"),
    mail = TextMap.GetValue("Text320"),
    jingyingguanqia = TextMap.GetValue("Text154"),
    rank = TextMap.GetValue("Text321"),
    shop_puyuan = TextMap.GetValue("Text197"),
    charge = TextMap.GetValue("Text322"),
    qiancengta = TextMap.GetValue("Text323"),
    hero = TextMap.GetValue("Text324"),
    powerUp = TextMap.GetValue("Text94"),
    linluo = TextMap.GetValue("Text325"),
    xilian = TextMap.GetValue("Text216"),
    tujian = TextMap.GetValue("Text326"),
    heidian = TextMap.GetValue("Text187"),
    sishenzhilu = TextMap.GetValue("Text327"),
    dailyTask = TextMap.GetValue("Text328"),
    guidaohecheng = TextMap.GetValue("Text329"),
    guidaoqianghua = TextMap.GetValue("Text263"),
    guidaoxilian = TextMap.GetValue("Text265"),
    guidaojinhua = TextMap.GetValue("Text267"),
    guidao = TextMap.GetValue("Text148"),
    lunhui = TextMap.GetValue("Text330"),
    team = TextMap.GetValue("Text331"),
    shop_common = TextMap.GetValue("Text197"),
    chat = TextMap.GetValue("Text332"),
    purchase = TextMap.GetValue("Text68"),
    purchase = TextMap.GetValue("Text68"),
    chapterFight = TextMap.GetValue("Text333"),
    ghost_info = TextMap.GetValue("Text334"),
    treasure_info = TextMap.GetValue("Text1645"),
    HunLian = TextMap.GetValue("Text335"),
    questModule = TextMap.GetValue("Text336"),
    PACK = TextMap.GetValue("Text337"),
    activity = TextMap.GetValue("Text338"),
    recycle = TextMap.GetValue("Text330"),
    select_list = TextMap.GetValue("Text339"),
    main_menu = TextMap.GetValue("Text340"),
    SelectServer = TextMap.GetValue("Text341"),
    login = TextMap.GetValue("Text342"),
    ghost = TextMap.GetValue("Text343")

}


function dataEye.ctrl(api)
    local map = {}
    map.lv_ctrl = Player.Info.level .. "_" .. api
    DataEyeTool.onEvent(TextMap.GetValue("Text344"), map)
end

--打开模块
function dataEye.OpenModule(name)
    local map = {}
    map.lv_name = Player.Info.level .. "_" .. (moduleName[name] or name)
    DataEyeTool.onEvent(TextMap.GetValue("Text345"), map)
end

function dataEye.pushAct(a)
    local map = {}
    map.name = p
    DataEyeTool.onEvent(TextMap.GetValue("Text346"), map)
end

------------------------------------------------------------------------------------------------------ 公会相关---------------------------------------------------------------------------------------------------------------------------------------
function dataEye.defiance(tp, chapter, section, team, reseult)
    section = tonumber(section)
    local battle = result.battle3
    local row = TableReader:TableRowByID("GuildCopy", section)
    if row == nil then return end
    local name = TextMap.GetValue("Text347") .. row.chapter_name .. "-" .. row.name
    DataEyeTool.DcLevelsBegin(20000 + section, name)
    if battle.win then
        DataEyeTool.DcLevelsComplete((20000 + section) .. "_" .. name)
        dataEye.levelsDrop(TextMap.GetValue("Text348"), name, result)
    else
        DataEyeTool.DcLevelsFail((20000 + section) .. "_" .. name, TextMap.GetValue("Text152"))
    end
end

function dataEye:worship(tp, result)
    local row = TableReader:TableRowByID("GuildSacrifice", tp)
    if row == nil then return end
    local map = {}
    map.type = row.name
    DataEyeTool.onEvent(TextMap.GetValue("Text290"), map)
end

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

------------------------------------------------------------------------------------------------------ 羁绊-------------------------------------------------------------------------------------------------------------------------------------------
-- 小伙伴
function dataEye.saveTeam(team, tp)
    local map = {}
    local key = ""
    table.foreach(team, function(i, v)
        if v ~= 0 and v ~= "0" then
            map.char = key .. TableReader:TableRowByID("char", Tool.getDictId(v) ).name
            DataEyeTool.onEvent(TextMap.GetValue("Text349"), map)
        end
    end)
end

return dataEye
