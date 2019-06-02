local Api = {}


function getV()
    if Player == nil then
        return 0
    else
        return Player.Version
    end
end

function empty(ret)
    if ret == -200 then
        LuaMain:Slogout()
        -- Network:disconnectAll()
        return true
    end
    return false
end




--聊天发送
function Api:send(scope,content,to,cb, err)
    Network:sendRequestWithLua(false, "logic", "chat.chatHandler.send", {scope=scope,content=content,to=to,v = getV() }, cb, err or empty)
end

--开宝箱
--参数1：draw表格的id值。
function Api:draw(_id, _cb, err)
    local cb = function(result)
        if _cb then _cb(result) end
        DataEye.draw(_id, result)
    end
    Network:sendRequestWithLua(false, "logic", "logic.drawHandler.draw", { id = _id, v = getV() }, cb, err or empty)
end

--阵营招募
function Api:campDraw(type,_id, _cb, err)
    local cb = function(result)
        if _cb then _cb(result) end
        DataEye.draw(_id, result)
    end
    Network:sendRequestWithLua(false, "logic", "logic.drawHandler.campDraw", { type = type, v = getV() }, cb, err or empty)
end

--查看阵营招募所处阵营
function Api:loadCamp(cb, err)
    Network:sendRequestWithLua(false, "logic", "logic.drawHandler.loadCamp", {v = getV() }, cb, err or empty)
end

--星运值兑换
function Api:exchangeCampReward(index, cb, err)
    Network:sendRequestWithLua(false, "logic", "logic.drawHandler.exchangeCampReward", {index = index, v = getV() }, cb, err or empty)
end

--忍灵点将
--参数1：draw表格的id值。
function Api:renlingDraw(_id, _cb, err)
    local cb = function(result)
        if _cb then _cb(result) end
        DataEye.draw(_id, result)
    end
    Network:sendRequestWithLua(false, "logic", "logic.renlingHandler.renlingDraw", { id = _id, v = getV() }, cb, err or empty)
end

--忍灵图鉴激活
--参数1：renling_group表格的id值。
function Api:tujianLevelUp(id, cb, err)
    Network:sendRequestWithLua(false, "logic", "logic.renlingHandler.tujianLevelUp", { id = id, v = getV() }, cb, err or empty)
end

--忍灵成就激活
--参数1：renling_chengjiu表格的id值。
function Api:activatedAchievement(id, cb, err)
    Network:sendRequestWithLua(false, "logic", "logic.renlingHandler.activatedAchievement", { id = id, v = getV() }, cb, err or empty)
end

--忍灵试练刷新
function Api:refChapter( cb, err)
    Network:sendRequestWithLua(false, "logic", "logic.renlingHandler.refChapter", {v = getV() }, cb, err or empty)
end

--忍灵试练战斗
function Api:fightRenlingChapter( cb, err)
    Network:sendRequestWithLua(false, "logic", "logic.renlingHandler.fightRenlingChapter", {v = getV() }, cb, err or empty)
end

--虚夜工更新
function Api:XuYeGongCheckInit(cb, err)
    Network:sendRequestWithLua(false, "logic", "logic.xuYeGongHandler.checkInit", { v = getV() }, cb, err or empty)
end

--忍灵分解
function Api:decomposeRenling(data, cb, err)
    Network:sendRequestWithLua(false, "logic", "logic.renlingHandler.decomposeRenling", { data = data, v = getV() }, cb, err or empty)
end

--使用道具
--参数1：背包类型，可选值:'equip', 'item', 'equipPiece', 'reel', 'reelPiece', 'charPiece'
--参数2：背包格子的唯一key
--参数3：使用数量，一般传1
function Api:useItem(type, key, num, _cb, id)
    local cb = function(result)
        if _cb then _cb(result) end
        DialogMrg.levelUp()
        DataEye.useItem(type, key, num, result, id)
    end
    Network:sendRequestWithLua(false, "logic", "logic.drawHandler.useItem", { type = type, key = key, num = num, v = getV() }, cb, err or empty)
end


--使用n选一道具
--参数1：背包类型，可选值:'equip', 'item', 'equipPiece', 'reel', 'reelPiece', 'charPiece'
--参数2：背包格子的唯一key
--参数3：使用数量，一般传1
--参数4：标示玩家所选的那个物品，从1开始
function Api:useItemSelect(type, key, num,index, _cb, id)
    local cb = function(result)
        if _cb then _cb(result) end
        DialogMrg.levelUp()
        DataEye.useItem(type, key, num,result, id)
    end
    Network:sendRequestWithLua(false, "logic", "logic.drawHandler.useItem", { type = type, key = key, num = num,index = index, v = getV() }, cb, err or empty)
end


--出售道具
--参数1：背包类型，可选值:'equip', 'item', 'equipPiece', 'reel', 'reelPiece', 'charPiece'
--参数2：背包格子的唯一key
--参数3：出售数量，一般传1
function Api:sellItem(type, key, num, cb)
    Network:sendRequestWithLua(false, "logic", "logic.drawHandler.sellItem", { type = type, key = key, num = num, v = getV() }, cb, err or empty)
end

--角色升级
--@charid 角色id
--@cb 升级成功回调
--@err 升级失败回调

--角色化神
function Api:charQualityUp(charid, cb, err)
    Network:sendRequestWithLua(false, "logic", "logic.trainHandler.charQualityUp", { charid = charid, v = getV() }, cb, err or empty)
end

function Api:charLevelUp(charid, charids, cb, err)
    Network:sendRequestWithLua(false, "logic", "logic.trainHandler.charLevelUp", { charid = charid, charids = charids, v = getV() }, cb, err or empty)
end

function Api:oneStepcharLevelUp(charid, cb, err)
    Network:sendRequestWithLua(false, "logic", "logic.trainHandler.oneStepcharLevelUp", { charid = charid, v = getV() }, cb, err or empty)
end

--角色进化
function Api:charStarUp(charid, cb, err)
    Network:sendRequestWithLua(false, "logic", "logic.trainHandler.charStarUp", { charid = charid, v = getV() }, cb, err or empty)
end

--角色进阶
function Api:charColorUp(charid, cb, err)
    Network:sendRequestWithLua(false, "logic", "logic.trainHandler.charColorUp", { charid = charid, v = getV() }, cb, err or empty)
end

--角色称号
function Api:charNinjiaLevelUP( cb, err)
    Network:sendRequestWithLua(false, "logic", "logic.trainHandler.charNinjiaLevelUP", {v = getV()}, cb, err or empty)
end

--穿时装
function Api:equipOnFashion(id, cb, err)
    Network:sendRequestWithLua(false, "logic", "logic.equipHandler.equipOnFashion", { id = id, v = getV() }, cb, err or empty)
end

--卸下时装
function Api:equipDownFashion(cb, err)
    Network:sendRequestWithLua(false, "logic", "logic.equipHandler.equipDownFashion", {v = getV() }, cb, err or empty)
end

--时装强化
function Api:powerUpFashion(id, cb, err)
    Network:sendRequestWithLua(false, "logic", "logic.equipHandler.powerUpFashion", { id = id, v = getV() }, cb, err or empty)
end

--时装重铸
function Api:rebuildFashion(id, cb, err)
    Network:sendRequestWithLua(false, "logic", "logic.equipHandler.rebuildFashion", { id = id, v = getV() }, cb, err or empty)
end

--时装重铸预览
function Api:reviewRebuildFashion(id, cb, err)
    Network:sendRequestWithLua(false, "logic", "logic.equipHandler.reviewRebuildFashion", { id = id, v = getV() }, cb, err or empty)
end


--穿装备
function Api:wearEquip(charid, pos, cb, err)
    Network:sendRequestWithLua(false, "logic", "logic.equipHandler.wearEquip", { charid = charid, pos = pos, v = getV() }, cb, err or empty)
end


--一键穿戴觉醒装备
function Api:OneKeyWearEquip(id, cb, err)
    Network:sendRequestWithLua(false, "logic", "logic.equipHandler.OneKeyWearEquip", { charid = id, v = getV() }, cb, err or empty)
end

--装备附魔
--角色id
--位置
--材料 "equip:bagKey:count|type:bagkey:count"
function Api:equipUp(charid, pos, material, cb, err)
    Network:sendRequestWithLua(false, "logic", "logic.equipHandler.equipUp", { charid = charid, pos = pos, material = material, v = getV() }, cb, err or empty)
end

--一键装备附魔
--角色id
--位置
function Api:oneStepEquipUp(charid, pos, cb, err)
    Network:sendRequestWithLua(false, "logic", "logic.equipHandler.oneStepEquipUp", { charid = charid, pos = pos, v = getV() }, cb, err or empty)
end

--技能加点
function Api:skillUp(charid, pos, cb, err)
    Network:sendRequestWithLua(false, "logic", "logic.trainHandler.skillUp", { charid = charid, skillpos = pos, v = getV() }, cb, err or empty)
end

--合成
function Api:combineFunc(type, id, cb, err)

    Network:sendRequestWithLua(false, "logic", "logic.equipHandler.combineFunc", { type = type, id = id,v = getV() }, cb, err or empty)  
end

--合成
function Api:combineFuncOneKey(type, id, num, cb, err)
    Network:sendRequestWithLua(false, "logic", "logic.equipHandler.combineFunc", { type = type, id = id, num =num, v = getV() }, cb, err or empty)   
end


function Api:checkTeam(team, teamId, cb)
    if not GuideConfig:isStop() then
        cb()
        return
    end
   
    cb()
end

--闯关
--type 区分普通，精英，协会副本
--battleid 关卡id(关卡commonChapter,heroChapter,unionChapter表id列的值)
--team 队伍中角色id数组
function Api:fightChapter(type, battleid, team, teamId, _cb, err)
    self:checkTeam(team, teamId, function()
        local cb = function(result)
            if _cb then _cb(result) end
            DataEye.fightChapter(type, battleid, team, result)
        end
        DialogMrg.updateBp()
        Network:sendRequestWithLua(false, "logic", "logic.chapterHandler.fightChapter", { type = type, battleid = battleid, team = team, v = getV() }, cb, err or empty)
    end)
end

--扫荡
--type 区分物品的类型
--battleid 关卡id(关卡commonChapter,heroChapter,unionChapter表id列的值)
--section 表id列的值)
function Api:sweepChapter(type, battleid, num, _cb, err)
    DialogMrg.updateBp()
    local befor = Player.Resource.bp
    local cb = function(result)
        if DialogMrg._levelData then
            local consume = RewardMrg.getConsume(result)
            for i = 1, #consume do
                if consume[i]:getType() == "bp" then
                    DialogMrg._levelData.bp = befor - consume[i].rwCount
                end
            end
        end
        if _cb then _cb(result) end
        DataEye.sweepChapter(type, battleid, num, result)
    end
    Network:sendRequestWithLua(false, "logic", "logic.chapterHandler.sweepChapter", { type = type, battleid = battleid, times = num, v = getV() }, cb, err or empty)
end



-- 重置关卡
-- type 关卡的类型 可能的值：commonChapter,heroChapter,unionChapter
-- battleid  关卡的id 
function Api:resetChapter(type, battleid, cb, err)
    Network:sendRequestWithLua(false, "logic", "logic.chapterHandler.resetChapter", { type = type, battleid = battleid, v = getV() }, cb, err or empty)
end



--洗炼属性
function Api:xilian(charid, _type, cb, err)
    Network:sendRequestWithLua(false, "logic", "logic.xilianHandler.xilian", { charid = charid, type = _type, v = getV() }, cb, err or empty)
end

--洗炼属性
function Api:xilianGuide(charid, cb, err)
    Network:sendRequestWithLua(false, "logic", "logic.xilianHandler.xilian", { charid = charid, type = "xinshou", v = getV() }, cb, err or empty)
end

--改变洗炼属性的锁定状态
--lockpos: 0~3
function Api:changeLock(charid, lockpos, cb, err)
    Network:sendRequestWithLua(false, "logic", "logic.xilianHandler.changeLock", { charid = charid, lockpos = lockpos, v = getV() }, cb, err or empty)
end

--替换洗炼属性
function Api:replaceAttr(charid, cb, err)
    Network:sendRequestWithLua(false, "logic", "logic.xilianHandler.replaceAttr", { charid = charid, v = getV() }, cb, err or empty)
end

--开放一个洗炼槽位并初始一条属性
--function Api:openSlot(charid, slotid, cb, err)
--    Network:sendRequestWithLua(false, "logic", "logic.xilianHandler.openSlot", { charid = charid, slotid = slotid, v = getV() }, cb, err or empty)
--end

--变身养成(点灵络)
function Api:charTransUp(charid, transid, cb, err)
    Network:sendRequestWithLua(false, "logic", "logic.transformHandler.charTransUp", { charid = charid, transid = transid, v = getV() }, cb, err or empty)
end

-- 逃忍入侵
function Api:fightNinjaIntrusion(chapterID, section, cb, err)
    Network:sendRequestWithLua(false, "logic", "logic.ninjaIntrusionHandle.fightNinjaIntrusion", { chapterID = chapterID, section = section, v = getV() }, cb, err or empty)
end

-- 千层塔， 精英挑战
function Api:fightJingYing(towerId, cb, err)
    Network:sendRequestWithLua(false, "logic", "logic.qianCengTaHandler.fightJingYing", { towerId = towerId, v = getV() }, cb, err or empty)
end

--悬赏挑战。
--参数1. specialChapter表的id列的值
--参数2. 战斗的队伍
function Api:fightSpecialChapter(id, team, teamId, _cb, err)
    self:checkTeam(team, teamId, function()
        local cb = function(result)
            if _cb then _cb(result) end
            --数据收集
            DataEye.fightSpecialChapter(id, team, result)
        end
        DialogMrg.updateBp()
        Network:sendRequestWithLua(false, "logic", "logic.chapterHandler.fightSpecialChapter", { id = id, team = team, v = getV() }, cb, err or empty)
    end)
end

--悬赏挑战 重置
--参数1. 重置悬赏和挑战。
function Api:resetSpecialChapter(chapter, cb, err)
    Network:sendRequestWithLua(false, "logic", "logic.chapterHandler.resetSpecialChapter", { chapter = chapter, v = getV() }, cb, err or empty)
end

--悬赏挑战 用悬赏令和挑战令重置
--参数1. 重置悬赏和挑战。
function Api:resetSpecialChapterTicket(chapter, cb, err)
    Network:sendRequestWithLua(false, "logic", "logic.chapterHandler.resetSpecialChapterTicket", { chapter = chapter, v = getV() }, cb, err or empty)
end

--刷新一下悬赏和挑战的信息。例如开放。
--以后可能改进为服务器自动定时触发。主要原因是因为都是9点重置。如果服务器自己处理。有可能一瞬间压力太大。而如果是用户在当前页面时，自动刷新，则不会出现压力。
function Api:checkUpdateSpecialChapter(cb, err)
    Network:sendRequestWithLua(false, "logic", "logic.chapterHandler.checkUpdateSpecialChapter", { v = getV() }, cb, err or empty)
end

--VIP商店
function Api:getVipShop(cb, err)
    Network:sendRequestWithLua(false, "logic", "logic.vipShopHandler.getVipShop", { v = getV() }, cb, err or empty)
end

--VIP购买
function Api:buyVipShop(id, itemnum, cb, err)
    print("itemnum" .. itemnum)
    Network:sendRequestWithLua(false, "logic", "logic.vipShopHandler.buyVipShop", { v = getV(), item_id = id, num = itemnum }, cb, err or empty)
end


--商店购买
--参数1. 商店id，传入shop_reset_config表的id列的值
--参数2. 物品位置，从0开始。0 到 Player.Shop[shopid].count-1
function Api:buyShop(shopid, pos, _cb, err)
    local countdown = Player.Shop[shopid].countdown
    local times = Player.Shop[shopid].reset_times
    local cb = function(result)
        if _cb then _cb(result) end
        DataEye.buyShop(shopid, result)
    end
    Network:sendRequestWithLua(false, "logic", "logic.shopHandler.buy", { shop = shopid, countdown = countdown, times = times, position = pos, v = getV() }, cb, err or empty)
end

--购买杂货
function Api:buyPartly(shopid, pos, num, _cb, err)
    local countdown = Player.Shop[shopid].countdown
    local times = Player.Shop[shopid].reset_times
    local cb = function(result)
        if _cb then _cb(result) end
        DataEye.buyShop(shopid, result)
    end
    Network:sendRequestWithLua(false, "logic", "logic.shopHandler.buyPartly", { shop = shopid, times = times, position = pos, num = num, v = getV() }, cb, err or empty)
end


--VIP礼包购买
--参数1. 礼包id，vip礼包配置表的id列的值
function Api:buyVipPackage(id, _cb, err)
    local cb = function(result)
        if _cb then _cb(result) end
        DataEye.buyVipPackage(id, result)
    end
    Network:sendRequestWithLua(false, "logic", "logic.shopHandler.buyVipPackage", { id = id, v = getV() }, cb, err or empty)
end

--商店刷新
--参数1. 商店id，传入shop_reset_config表的id列的值
function Api:refreshShop(shopid, _cb, err)
    local countdown = Player.Shop[shopid].countdown
    local times = Player.Shop[shopid].reset_times
    local cb = function(result)
        if _cb then _cb(result) end
        DataEye.refreshShop(shopid)
    end
    Network:sendRequestWithLua(false, "logic", "logic.shopHandler.refresh", { shop = shopid, countdown = countdown, times = times, v = getV() }, cb, err or empty)
end

--商店信息刷新，例如countdown倒计时到点了。可以触发一下。
--以后可能改进为服务器自动定时触发。主要原因是因为都是9点重置。如果服务器自己处理。有可能一瞬间压力太大。而如果是用户在当前页面时，自动刷新，则不会出现压力。
function Api:checkUpdateShop(cb, err)
    Network:sendRequestWithLua(false, "logic", "logic.shopHandler.checkUpdate", { v = getV() }, cb, err or empty)
end

--竞技场换一批玩家
function Api:arenaChangeEnemy(type,cb, err)
    Network:sendRequestWithLua(false, "logic", "logic.vsbattleHandler.refreshPlayer", { type = type,v = getV() }, cb, err or empty)
end

--竞技场更换防御队伍阵型
function Api:changeDefendTeam(arr, cb, err)
    Network:sendRequestWithLua(false, "logic", "logic.vsbattleHandler.changeDefendTeam", { team = arr, v = getV() }, cb, empty)
end

--检测跨服竞技场是否开放
function Api:checkCross(cb, err)
    Network:sendRequestWithLua(false, "logic", "logic.vsbattleHandler.checkCross", { v = getV() }, cb, err or empty)
end

--竞技场挑战对手
--function Api:challengePlayer(team, pid2, cb, err)
--    Network:sendRequestWithLua(false, "logic", "logic.vsbattleHandler.challengePlayer", { team = team, pid2 = pid2, v = getV() }, cb, err or empty)
--end

--消除CD时间，cdtimeid为类型，因为很多地方有CD
function Api:clearCdTime(cdtimeid, cb, err)
    Network:sendRequestWithLua(false, "logic", "logic.vsbattleHandler.clearCdTime", { cdtimeid = cdtimeid, v = getV() }, cb, err or empty)
end

function Api:getChallengeReward(id, cb, err)
    Network:sendRequestWithLua(false, "logic", "logic.vsbattleHandler.getChallengeReward", { id = id, v = getV() }, cb, err or empty)
end


function Api:getRewardList(cb, err)
	Network:sendRequestWithLua(false, "logic", "logic.vsbattleHandler.getRewardList", {v = getV() }, cb, err or empty)
end

function Api:addFightTime(type, cb, err)
    Network:sendRequestWithLua(false, "logic", "logic.vsbattleHandler.addFightTime", { type = type, vstime = Player.crossArena.has_fight, v = getV() }, cb, err or empty)
end

function Api:challengePlayer_guide(team, pid2, teamId, sid, now_rank,guideid,_cb, err)
    self:checkTeam(team, teamId, function()
        local cb = function(result)
            if _cb then _cb(result) end
            DataEye.challengePlayer(team, pid2, result)
        end
        Network:sendRequestWithLua(false, "logic", "logic.vsbattleHandler.challengePlayer", { team = team, pid2 = pid2, sid = sid, rank = now_rank,guideid=guideid,v = getV() }, cb, err or empty)
    end)
end

--竞技场挑战对手
function Api:challengePlayer(team, pid2, teamId, sid, now_rank, _cb, err)
    self:checkTeam(team, teamId, function()
        local cb = function(result)
            if _cb then _cb(result) end
            DataEye.challengePlayer(team, pid2, result)
        end
        Network:sendRequestWithLua(false, "logic", "logic.vsbattleHandler.challengePlayer", { team = team, pid2 = pid2, sid = sid, rank = now_rank,v = getV() }, cb, err or empty)
    end)
end

--竞技场便捷挑战对手
function Api:fastChallenge(team, pid2, teamId, sid, now_rank, _cb, err)
    self:checkTeam(team, teamId, function()
        local cb = function(result)
            if _cb then _cb(result) end
            DataEye.challengePlayer(team, pid2, result)
        end
        Network:sendRequestWithLua(false, "logic", "logic.vsbattleHandler.fastChallenge", { team = team, pid2 = pid2, sid = sid, rank = now_rank,v = getV() }, cb, err or empty)
    end)
end

--竞技场查看挑战记录
function Api:getOneRecord(rid, cb, err)
    Network:sendRequestWithLua(false, "logic", "logic.vsbattleHandler.getOneRecord", { rid = rid, v = getV() }, cb, err or empty)
end

--读取某个战报内容
function Api:getVSRecord(type, rid, cb, err)
    Network:sendRequestWithLua(false, "logic", "logic.vsbattleHandler.getVSRecord", { type = type, rid = rid, v = getV() }, cb, err or empty)
end

--读取玩家战斗记录列表
function Api:getVSList(type, cb, err)
    Network:sendRequestWithLua(false, "logic", "logic.vsbattleHandler.getVSList", { type = type, v = getV() }, cb, err or empty)
end

--竞技场排行榜
function Api:getRankList(type, cb, err)
    Network:sendRequestWithLua(false, "logic", "logic.vsbattleHandler.getRankList", { type = type, v = getV() }, cb, err or empty)
end

-- 跨服竞技场领取货币
function Api:getSwItem(cb, err)
    Network:sendRequestWithLua(false, "logic", "logic.vsbattleHandler.getSwItem", { v = getV() }, cb, err or empty)
end

--获取1个玩家详细信息
function Api:showDetailInfo(pid, sid, rank, cb, err)
    Network:sendRequestWithLua(false, "logic", "logic.vsbattleHandler.showDetailInfo", { pid = { pid }, sid = {sid}, rank = {rank},  v = getV() }, cb, err or empty)
end

--获取N个玩家详细信息
function Api:showDetailInfoArr(pidArr, sidArr, rankArr, cb, err)
    Network:sendRequestWithLua(false, "logic", "logic.vsbattleHandler.showDetailInfo", { pid = pidArr, sid = sidArr, rank = rankArr, v = getV() }, cb, err or empty)
end

--一键领取所有带附件的邮件
function Api:drawAllMails(cb, err)
    Network:sendRequestWithLua(false, "logic", "logic.mailHandler.drawAllMails", { v = getV() }, cb, err or empty)
end

--领取一个或多个邮件的附件
--参数1. 邮件key的数组，如果只有一个key,理解为领取单个邮件的附件。
function Api:drawMails(keys, cb, err)
    Network:sendRequestWithLua(false, "logic", "logic.mailHandler.drawMails", { keys = keys, v = getV() }, cb, err or empty)
end

--把一个或多个邮件标记为已读
--参数1. 邮件key的数组，如果只有一个key,理解为领取单个邮件的附件。
function Api:readMails(keys, cb, err)
    Network:sendRequestWithLua(false, "logic", "logic.mailHandler.readMails", { keys = keys, v = getV() }, cb, err or empty)
end

--一键删除所有[带附件已领取]以及[不带附件已读]的邮件
function Api:deleteAllMails(cb, err)
    Network:sendRequestWithLua(false, "logic", "logic.mailHandler.deleteAllMails", { v = getV() }, cb, err or empty)
end

--删除一个或多个邮件，如果有附件的邮件是不能删除的。。应该可以端先判断是否带附件。
--参数1. 邮件key的数组，如果只有一个key,理解为领取单个邮件的附件。
function Api:deleteMails(keys, cb, err)
    Network:sendRequestWithLua(false, "logic", "logic.mailHandler.deleteMails", { keys = keys, v = getV() }, cb, err or empty)
end

--签到
function Api:checkin(cb, err)
    Network:sendRequestWithLua(false, "logic", "logic.checkinHandler.checkin", { times = Player.Checkin.times, v = getV() }, cb, err or empty)
end

--签到刷新
function Api:checkRefresh(cb, err)
    Network:sendRequestWithLua(false, "logic", "logic.checkinHandler.checkStatus", { v = getV() }, cb, err or empty)
end


--购买体力
function Api:buyBp(cb, err)
    Network:sendRequestWithLua(false, "logic", "logic.buyresourceHandler.buyBp", { times = Player.Times.buybp, v = getV() }, cb, err or empty)
end

--金币换购银币
function Api:buyMoney(cb, err)
    Network:sendRequestWithLua(false, "logic", "logic.buyresourceHandler.buyMoney", { times = Player.Times.buymoney, v = getV() }, cb, err or empty)
end

--换名字
function Api:changeName(str,isFirst, cb, err)
    Network:sendRequestWithLua(false, "logic", "logic.playerInfoHandler.changeName", { str = str, isFirst = isFirst, v = getV() }, cb, err or empty)
end

--换头像
function Api:changeHeadImg(headid, cb, err)
    Network:sendRequestWithLua(false, "logic", "logic.playerInfoHandler.changeHeadImg", { headid = headid, v = getV() }, cb, err or empty)
end

--随机名字
function Api:randomName(gender, cb, err)
    Network:sendRequestWithLua(false, "logic", "logic.userHandler.randomName", { gender = gender, v = getV() }, cb, err or empty)
end

--查询玩家是否在线
function Api:PlayerisOnline(pid, cb, err)
    Network:sendRequestWithLua(false, "logic", "logic.userHandler.isOnline", { pid = pid, v = getV() }, cb, err or empty)
end

--获得支付url
function Api:getPayUrl(platform, rtype, orderId, price,act_id,pay_lv, cb, err)
    if pay_lv~=nil then
        Network:sendRequestWithLua(false, "logic", "logic.payHandler.getPayUrl", { platform = platform, rtype = rtype, orderId = orderId, price = price,act_id=act_id,pay_lv=pay_lv, webpay = GlobalVar.dataEyeChannelID, v = getV() }, cb, err or empty)
    else  
        Network:sendRequestWithLua(false, "logic", "logic.payHandler.getPayUrl", { platform = platform, rtype = rtype, orderId = orderId, price = price,act_id=act_id, webpay = GlobalVar.dataEyeChannelID, v = getV() }, cb, err or empty)
    end
end

--获得七天支付url
function Api:getSevenDayPayUrl(platform, rtype, orderId, price, dayNs_id, taskid, cb, err)
    Network:sendRequestWithLua(false, "logic", "logic.payHandler.getPayUrl", { platform = platform, rtype = rtype, orderId = orderId, price = price, dayNs_id = dayNs_id, taskid = taskid, webpay = GlobalVar.dataEyeChannelID, v = getV() }, cb, err or empty)
end

--七日内部支付
function Api:innerSevendayPay(pid, price, rtype,orderId,dayNs_id, taskid, cb, err)
    Network:sendRequestWithLua(false, "logic", "logic.payHandler.innerPay", { pid = pid, price = price, rtype = rtype,orderId = orderId,dayNs_id = dayNs_id, taskid = taskid,v = getV() }, cb, err or empty)
end

--内部支付
function Api:innerPay(pid, price, rtype,orderId,act_id,pay_lv, cb, err)
    if pay_lv~=nil then 
        Network:sendRequestWithLua(false, "logic", "logic.payHandler.innerPay", { pid = pid, price = price, rtype = rtype,orderId = orderId,act_id=act_id,pay_lv=pay_lv,v = getV() }, cb, err or empty)
    else 
        Network:sendRequestWithLua(false, "logic", "logic.payHandler.innerPay", { pid = pid, price = price, rtype = rtype,orderId = orderId,act_id=act_id,v = getV() }, cb, err or empty)
    end 
end

-- 上传分享状态
function Api:updateActivityStatue(id,statue,cb,err)
    print("000000000000000000000000000000000000000000")
    print(id)
    print(statue)
    Network:sendRequestWithLua(false, "logic", "logic.activityHandler.updateStatus", { share_id = id, status = statue ,v = getV()  }, cb, err or empty)
end

--创建角色
function Api:createPlayer(name, uid, idx, id, cb, err)
    local _state = Application.internetReachability
    if _state == 2 then 
        network = "wifi"
    elseif _state == 1 then
        network = "other"
    end
    local info = {
        deviceUniqueIdentifier = deviceUniqueIdentifier or "null", --唯一的设备标识。
        deviceName = deviceName or "null", --用户指定的设备名称。
        deviceModel = deviceModel or "null", --设备型号。
        operatingSystem = operatingSystem or "null" ,--操作系统名称和版本。
        network = network,
        resolution = Screen.currentResolution.width .."x"..Screen.currentResolution.height
    }
    Network:sendRequestWithLua(false, "logic", "logic.userHandler.createPlayer", { version = SettingConfig.getVersion(), name = name, sex = 1, uid = uid, idx = idx, id = id, v = getV(),info = info }, cb, err or empty)
end

--账号
function Api:queryPidByUid(uid, cb, err)
    Network:sendRequestWithLua(false, "logic", "logic.userHandler.queryPidByUid", { uid = uid, v = getV() }, cb, err or empty)
end

--选择服务器
function Api:selectServer(server, skey, channelCode ,dataEyeAppID,cb, err)
	print("1:->"..server)
    print("2:->"..skey)
    print("3:->"..channelCode)
    print("4:->"..dataEyeAppID)
    print("5:->"..__Network.SERVER_IP);
    Network:sendRequestWithLua(false, "platform", "platform.platformHandler.selectServer", { unique = deviceUniqueIdentifier or "", server = server, skey = skey, ip = __Network.SERVER_IP,channelCode = channelCode ,dataEyeAppID = dataEyeAppID ,gameName = GlobalVar.gameName, v = getV() }, cb, err or empty)
end

--验证第三方登陆
function Api:checkLogin(uid, token, channelCode, subchannelid,channeluid, platform, username, customparams, productcode,and_uuid, ios_uuid,idfv, dataEyeAppID, cb, err)
    Network:sendRequestWithLua(false, "platform", "platform.platformHandler.checkLogin", { uid = uid, token = token, channelCode = channelCode, subchannelid = subchannelid, channeluid = channeluid, platform = platform, username = username, customparams = customparams, productcode = productcode,and_uuid = and_uuid, ios_uuid = ios_uuid, idfv = idfv, dataEyeAppID = dataEyeAppID,gameName = GlobalVar.gameName , v = getV(), version = versionNumber or 150000 }, cb, err or empty)
end

--加载已创建的玩家信息
function Api:loadPlayer(playerId, cb, err)
    Network:sendRequestWithLua(false, "logic", "logic.userHandler.loadPlayer", { pid = playerId, v = getV() }, cb, err or empty)
end

function Api:XuYeGongFight(id, team, _cb, err)
    -- self:checkTeam(team, function()

    DialogMrg.updateBp()
    local cb = function(result)
        if _cb then _cb(result) end
        DataEye.XuYeGongFight(id, team, result)
    end
    Network:sendRequestWithLua(false, "logic", "logic.xuYeGongHandler.fightEnemy", { id = id, team = team, v = getV() }, cb, err or empty)
    -- end)
end

--打开虚夜宫宝箱
function Api:XuYeGongPrize(id, _cb, err)
    local cb = function(result)
        if _cb then _cb(result) end
        DataEye.XuYeGongPrize(id, result)
    end
    Network:sendRequestWithLua(false, "logic", "logic.xuYeGongHandler.getPrize", { id = id, v = getV() }, cb, err or empty)
end

--重置虚夜宫
function Api:XuYeReset(cb)
    Network:sendRequestWithLua(false, "logic", "logic.xuYeGongHandler.resetEnemy", { v = getV() }, cb, err or empty)
end

--千层塔挑战
function Api:QCTChallenge(id, _cb, err)
    local cb = function(result)
        if _cb then _cb(result) end
        DataEye.QCTChallenge(id, result)
    end
    Network:sendRequestWithLua(false, "logic", "logic.qianCengTaHandler.fightTower", { towerId = id, v = getV() }, cb, err or empty)
end

--千层塔重置
function Api:QCTReset(cb, err)
    Network:sendRequestWithLua(false, "logic", "logic.qianCengTaHandler.resetTower", { v = getV() }, cb, err or empty)
end

--千层塔扫荡
function Api:QCTRweep(cb, err)
    Network:sendRequestWithLua(false, "logic", "logic.qianCengTaHandler.sweepTower", { v = getV() }, cb, err or empty)
end

--千层塔领取宝箱
function Api:QCTGetAward(id, cb, err)
    Network:sendRequestWithLua(false, "logic", "logic.qianCengTaHandler.getTowerReward", { towerId = id, v = getV() }, cb, err or empty)
end

--千层塔购买次数
function Api:QCTBuyTimes(cb, err)
    Network:sendRequestWithLua(false, "logic", "logic.qianCengTaHandler.bugTowerTimes", { v = getV() }, cb, err or empty)
end


-- 关卡宝箱
function Api:getChapterBox(type, id, cb, err)
    Network:sendRequestWithLua(false, "logic", "logic.chapterHandler.getChapterBox", { type = type, id = id, v = getV() }, cb, err or empty)
end

function Api:submitTask(id, _cb, err)
    local cb = function(result)
        if _cb then _cb(result) end
        DataEye.submitTask(id, result)
    end
    Network:sendRequestWithLua(false, "logic", "logic.taskHandler.submitTask", { id = id, v = getV() }, cb, err or empty)
end

function Api:checkUpdate(cb, err)
    err = err or function(ret)
        if ret == -200 then
            LuaMain:Slogout()
            -- Network:disconnectAll()
        end
        return true
    end
    Network:sendRequestWithLua(true, "logic", "logic.sessionHandler.checkUpdate", { v = getV(), version = versionNumber }, cb, err or empty)
end

--获得公告文本。，cb ({ret:0,info:''})
function Api:getNoticeInfo(cb, err)
    Network:sendRequestWithLua(true, "logic", "logic.systemHandler.getNoticeInfo", { v = getV() }, cb, err or empty)
end

--购买金币
function Api:buyShopMoney(id, times, cb, err)
    Network:sendRequestWithLua(false, "logic", "logic.buyresourceHandler.buyMoneyShop", { id = id, times = times, v = getV() }, cb, err or empty)
end

--买技能点
function Api:buySkillPoint(cb, err)
    Network:sendRequestWithLua(false, "logic", "logic.buyresourceHandler.buySkillpoint", { times = Player.Times.buyskillpoint, v = getV() }, cb, err or empty)
end

local tryTimeMap = {}
--设置新手标签，只能大数覆盖小数
function Api:setGuide(id, value, _cb, err)
    local cb = function(result)
        tryTimeMap[id] = 0
        if _cb then _cb(result) end
    end
    local err = function(ret)
        if tryTimeMap[id] == nil then
            tryTimeMap[id] = 0
        end
        if tryTimeMap[id] < 5 then
            Api:setGuide(id, value, _cb, err)
        end
        tryTimeMap[id] = tryTimeMap[id] + 1
        return true
    end
    if id == 0 then
        PlayerPrefs.SetInt(Player.playerId .. "_" .. 0, value)
    end
    Network:sendRequestWithLua(true, "logic", "logic.systemHandler.setGuide", { id = id, value = value, v = getV() }, cb, err or empty)
end

--兑换码兑换
function Api:CDKEy(gift_code, cb, err)
    Network:sendRequestWithLua(false, "logic", "logic.systemHandler.checkGiftCode", { gift_code = gift_code, v = getV() }, cb, err or empty)
end

--直接购买装备
function Api:buyEquip(itemType, id, num, _cb, err)
    local cb = function(result)
        if _cb then _cb(result) end
        DataEye.buyEquip(itemType, id, num, result)
    end
    Network:sendRequestWithLua(false, "logic", "logic.buyresourceHandler.buyEquip", { itemType = itemType, id = id, num = num, v = getV() }, cb, err or empty)
end

--不同类型的排行榜
function Api:getRank(rankType, cb, err)
    Network:sendRequestWithLua(false, "logic", "logic.rankHandler.getRank", { rankType = rankType, v = getV() }, cb, err or empty)
end

--获取巅峰排行榜的玩家信息
function Api:getPeakRankTeam(rank, cb, err)
    Network:sendRequestWithLua(false, "logic", "logic.rankHandler.getPeakRankTeam", { rank = rank, v = getV() }, cb, err or empty)
end


--获取删档活动列表
function Api:getActivity(id, act_type,cb, err)
    Network:sendRequestWithLua(true, "logic", "logic.activityHandler.getActivity", { act_id = id, act_type = act_type ,v = getV()  }, cb, err or empty)
end

--签到补签
function Api:fillLogin30CheckIn(id, _day, cb, err)
    Network:sendRequestWithLua(false, "logic", "logic.activityHandler.fillLogin30CheckIn", { act_id = id, day = _day, v = getV() }, cb, err or empty)
end

--招财
function Api:fortune(id, cb, err)
    Network:sendRequestWithLua(false, "logic", "logic.activityHandler.fortune", { act_id = id, v = getV() }, cb, err or empty)
end

--活动购买VIP礼包
function Api:buyVipGift(id,gid,num,cb, err)
    Network:sendRequestWithLua(false, "logic", "logic.activityHandler.buyVipGift", { act_id = id,idx=gid,num=num,v = getV() }, cb, err or empty)
end

--获取某个具体的活动信息
function Api:getActGift(id, gid, _cb, err)
    cb = function(result)
        if _cb then
            _cb(result)
        end
        DataEye.getActGift(id, gid, result)
    end
    Network:sendRequestWithLua(false, "logic", "logic.activityHandler.getActGift", { act_id = id, gift = gid, v = getV() }, cb, err or empty)
end

--排名活动获取档位奖励
function Api:getDangweiReward (act_id, dw_id, cb, err)
    Network:sendRequestWithLua(false, "logic", "logic.activityHandler.getDangweiReward", { act_id = act_id, id = dw_id, v = getV() }, cb, err or empty)
end

--排名活动请求实时排名数据更新
function Api:getTopRank(act_id, rank_count, cb, err)
    Network:sendRequestWithLua(true, "logic", "logic.activityHandler.getTopRank", { act_id = act_id, rank_count = rank_count, v = getV() }, cb, err or empty)
end

--布阵
function Api:saveTeam(team, type, _cb, err)
    local cb = function(result)
        if _cb then _cb(result) end
        if "audience" == type then
            DataEye.saveTeam(team, type)
        end
    end
    Network:sendRequestWithLua(false, "logic", "logic.chapterHandler.saveTeam", { team = team, type = type, v = getV() }, cb, err or empty)
end


--英雄分解
function Api:decompose(idArr, cb, err)
    Network:sendRequestWithLua(false, "logic", "logic.recoveryCardHandler.decompose", { idArr = idArr, v = getV() }, cb, err or empty)
end

--英雄重生
function Api:rebirth(charid, cb, err)
    Network:sendRequestWithLua(false, "logic", "logic.recoveryCardHandler.rebirth", { charid = charid, v = getV() }, cb, err or empty)
end

--获取对应英雄重生获取的物品（以前的）
function Api:showDrop(charid, cb, err)
    Network:sendRequestWithLua(false, "logic", "logic.recoveryCardHandler.showDrop", { charid = charid, v = getV() }, cb, err or empty)
end

--获取对应英雄分解获取的物品
function Api:decomposeShowDrop(idArr, cb, err)
    Network:sendRequestWithLua(false, "logic", "logic.recoveryCardHandler.decomposeShowDrop", { idArr = idArr, v = getV() }, cb, err or empty)
end

--获取对应英雄重生获取的物品
function Api:rebirthShowDrop(charid, cb, err)
    Network:sendRequestWithLua(false, "logic", "logic.recoveryCardHandler.rebirthShowDrop", { charid = charid, v = getV() }, cb, err or empty)
end

--宠物分解
function Api:decomposePet(petid, cb, err)
    Network:sendRequestWithLua(false, "logic", "logic.petHandler.decompose", { petid = petid, v = getV() }, cb, err or empty)
end

--宠物重生
function Api:petBirth(petid, cb, err)
    Network:sendRequestWithLua(false, "logic", "logic.petHandler.petBirth", { petid = petid, v = getV() }, cb, err or empty)
end

--获取对应宠物分解获取的物品
function Api:decomposeShowDropPet(petid, cb, err)
    Network:sendRequestWithLua(false, "logic", "logic.petHandler.decomposeShowDrop", { petid = petid, v = getV() }, cb, err or empty)
end

--获取对应宠物重生获取的物品
function Api:petBirthShowDrop(petid, cb, err)
    Network:sendRequestWithLua(false, "logic", "logic.petHandler.petBirthShowDrop", { petid = petid, v = getV() }, cb, err or empty)
end

--基金计划购买
function Api:buyInvestPlan(cb, err)
    -- body
    Network:sendRequestWithLua(false, "logic", "logic.activityHandler.buyInvestPlan", { v = getV() }, cb, err or empty)
end

function Api:fillCheckIn(act_id, day, cb, err)
    Network:sendRequestWithLua(false, "logic", "logic.activityHandler.fillCheckIn", { act_id = act_id, day = day, v = getV() }, cb, err or empty)
end

--限时兑换
function Api:exchange(act_id, idx,num,idArr,cb, err)
    if idArr==nil then 
        Network:sendRequestWithLua(false, "logic", "logic.activityHandler.exchange", { act_id = act_id, idx = idx,num=num,v = getV() }, cb, err or empty)
    else 
        Network:sendRequestWithLua(false, "logic", "logic.activityHandler.exchange", { act_id = act_id, idx = idx,num=num,idArr=idArr,v = getV() }, cb, err or empty)
    end 
end

--鬼道魂炼
function Api:ghostCombineByChar(id, char_arr, cb, err)
    Network:sendRequestWithLua(false, "logic", "logic.ghostHandler.ghostCombineByChar", { id = id, char_arr = char_arr, v = getV() }, cb, err or empty)
end

--鬼道魂炼
function Api:ghostCombineByPiece(piece_id, cb, err)
    Network:sendRequestWithLua(false, "logic", "logic.ghostHandler.ghostCombineByPiece", { piece_id = piece_id, v = getV() }, cb, err or empty)
end

--装备升星
function Api:ZhuangBeiStarUp(id, type, auto, cb, err)
    Network:sendRequestWithLua(false, "logic", "logic.ghostHandler.ghostStarUp", { key = id, type = type, auto = auto, v = getV() }, cb, err or empty)
end




--鬼道强化
function Api:ghostLevelUp(ghost_key, _cb, err)
    local cb = function(result)
        if _cb then _cb(result) end
        DataEye.ghostLevelUp(ghost_key, result)
    end
    Network:sendRequestWithLua(false, "logic", "logic.ghostHandler.ghostLevelUp", { key = ghost_key, v = getV() }, cb, err or empty)
end

--鬼道自动强化
function Api:ghostAutoLevelUp(ghost_key, cb, err)
    Network:sendRequestWithLua(false, "logic", "logic.ghostHandler.ghostAutoLevelUp", { key = ghost_key, v = getV() }, cb, err or empty)
end

--鬼道一键强化
function Api:ghostOneKeyUp(ghost_index, cb, err)
    Network:sendRequestWithLua(false, "logic", "logic.ghostHandler.ghostOneKeyUp", { key = ghost_index, v = getV() }, cb, err or empty)
end

--鬼道进化
function Api:ghostPowerUp(ghost_key, _cb, err)
    local cb = function(result)
        if _cb then _cb(result) end
        DataEye.ghostPowerUp(ghost_key, reuslt)
    end
    Network:sendRequestWithLua(false, "logic", "logic.ghostHandler.ghostPowerUp", { key = ghost_key, v = getV() }, cb, err or empty)
end

--鬼道洗练
function Api:ghostXilian(ghost_key, type,_times, _cb, err)
    local cb = function(result)
        if _cb then _cb(result) end
        DataEye.ghostXilian(ghost_key, type, reuslt)
    end
    Network:sendRequestWithLua(false, "logic", "logic.ghostHandler.ghostXilian", { key = ghost_key, type = type, times = _times , v = getV() }, cb, err or empty)
end

--鬼道洗练10
function Api:ghostXilianTen(ghost_key, type, cb, err)
    Network:sendRequestWithLua(false, "logic", "logic.ghostHandler.ghostXilianTen", { key = ghost_key, type = type, v = getV() }, cb, err or empty)
end

--鬼道洗练-属性替换
function Api:ghostXilianReplaceAttr(ghost_key, cb, err)
    Network:sendRequestWithLua(false, "logic", "logic.ghostHandler.ghostXilianReplaceAttr", { key = ghost_key, v = getV() }, cb, err or empty)
end

--鬼道放弃
function Api:ghostXilianGiveUp(ghost_key, cb, err)
    Network:sendRequestWithLua(false, "logic", "logic.ghostHandler.ghostXilianGiveUp", { key = ghost_key, v = getV() }, cb, err or empty)
end

--鬼道之上阵角色
function Api:gd_charOn(charid, pos, cb, err)
    Network:sendRequestWithLua(false, "logic", "logic.equipHandler.gd_charOn", { charid = charid, pos = pos, v = getV() }, cb, err or empty)
end

--鬼道之穿装备
function Api:gd_equipOn(equipKey, pos, ePos, cb, err)
    Network:sendRequestWithLua(false, "logic", "logic.equipHandler.gd_equipOn", { equipKey = equipKey, pos = tonumber(pos), ePos = tonumber(ePos), v = getV() }, cb, err or empty)
end

--鬼道之一键穿装备
function Api:gd_equipOn_ones(pos, data, cb, err)
    Network:sendRequestWithLua(false, "logic", "logic.equipHandler.gd_equipOn_ones", { pos = tonumber(pos), data = data, v = getV() }, cb, err or empty)
end

--鬼道之卸装备
function Api:gd_equipDown(equipKey, pos, ePos, cb, err)
    Network:sendRequestWithLua(false, "logic", "logic.equipHandler.gd_equipDown", { equipKey = equipKey, pos = tonumber(pos), ePos = tonumber(ePos), v = getV() }, cb, err or empty)
end

--宝物穿戴
function Api:treasureOn(charid, pos, treKey, cb, err)
    Network:sendRequestWithLua(false, "logic", "logic.treasureHandler.treasureOn", { charid = charid, pos = tonumber(pos), treKey = tonumber(treKey), v = getV() }, cb, err or empty)
end
--宝物卸下
function Api:treasureDown(charid, pos , cb, err)
    Network:sendRequestWithLua(false, "logic", "logic.treasureHandler.treasureDown", { charid = charid, pos = tonumber(pos), v = getV() }, cb, err or empty)
end
--宝物强化
function Api:treasureLevelUp(treKey, keyArr , cb, err)
    Network:sendRequestWithLua(false, "logic", "logic.treasureHandler.treasureLevelUp", { treKey = treKey, keyArr = keyArr, v = getV() }, cb, err or empty)
end

--宝物一鍵强化
function Api:oneKeyLevelUp(treKey, keyArr ,lv, cb, err)
    Network:sendRequestWithLua(false, "logic", "logic.treasureHandler.oneKeyLevelUp", { treKey = treKey, keyArr = keyArr, lv=lv, v = getV() }, cb, err or empty)
end

--宝物精炼
function Api:treasurePowerUp(treKey , cb, err)
    Network:sendRequestWithLua(false, "logic", "logic.treasureHandler.treasurePowerUp", { treKey = tonumber(treKey), v = getV() }, cb, err or empty)
end
--宝物锻造
function Api:treasureCast(treKey , cb, err)
    Network:sendRequestWithLua(false, "logic", "logic.treasureHandler.treasureCast", { treKey = tonumber(treKey), v = getV() }, cb, err or empty)
end
--宝物重生
function Api:treasureBirth(treKey , cb, err)
    Network:sendRequestWithLua(false, "logic", "logic.treasureHandler.treasureBirth", { treKey = tonumber(treKey), v = getV() }, cb, err or empty)
end

--宝物重生返回材料预览
function Api:birthDrop(treKey , cb, err)
    Network:sendRequestWithLua(false, "logic", "logic.treasureHandler.birthDrop", { treKey = tonumber(treKey), v = getV() }, cb, err or empty)
end

--宝物熔炼
function Api:treasureSmelt(treKeyArr,pieceId,cb,err)
   Network:sendRequestWithLua(false, "logic", "logic.treasureHandler.treasureSmelt", { treKeyArr = {treKeyArr}, pieceId = pieceId, v = getV() }, cb, err or empty)
end

--拉取掠夺列表
function Api:getRobList(pieceId,cb,err)
    Network:sendRequestWithLua(false, "logic", "logic.treasureHandler.getRobList", {pieceId = pieceId, v = getV() }, cb, err or empty)
end

--宝物碎片掠夺一次
function Api:treasureRob(enemyId,pieceId,cb,err)
    Network:sendRequestWithLua(false, "logic", "logic.treasureHandler.treasureRob", {enemyId = enemyId, pieceId = pieceId, v = getV() }, cb, err or empty)
end

function Api:treasureRob_guide(enemyId,pieceId,guideid,cb,err)
    Network:sendRequestWithLua(false, "logic", "logic.treasureHandler.treasureRob", {enemyId = enemyId, pieceId = pieceId, guideid=guideid, v = getV() }, cb, err or empty)
end

--宝物碎片掠夺后翻卡
function Api:turnCardReward(pieceId,cb,err)
    Network:sendRequestWithLua(false, "logic", "logic.treasureHandler.turnCardReward", {pieceId = pieceId, v = getV() }, cb, err or empty)
end

--宝物碎片一键掠夺
function Api:oneStepRob(pieceIds,isUse,cb,err)
    Network:sendRequestWithLua(false, "logic", "logic.treasureHandler.oneStepRob", {pieceIds = pieceIds, isUse = isUse, v = getV() }, cb, err or empty)
end

--宝物碎片掠夺n次
function Api:robNtime(enemyId,pieceId,robtime,cb,err)
    Network:sendRequestWithLua(false, "logic", "logic.treasureHandler.robNtime", {enemyId = enemyId, pieceId = pieceId, robtime = robtime, v = getV() }, cb, err or empty)
end

function Api:checkRes(_cb, err)
    local cb = function(result)
        if result:ContainsKey("t") then
            Network:onUpdateServerTime("logic", result.t, 100)
        end
        if _cb then _cb(result) end
    end
    Network:sendRequestWithLua(true, "logic", "logic.playerInfoHandler.checkRes", { v = getV() }, cb, err or empty)
end

--鬼道之分解
function Api:ghostReturn(equipArr, _cb, err)
    local cb = function(result)
        if _cb then _cb(result) end
        DataEye.ghostReturn(equipArr, result)
    end
    Network:sendRequestWithLua(false, "logic", "logic.ghostHandler.ghostReturn", { idArr = equipArr, v = getV() }, cb, err or empty)
end

--获取对应装备分解获取的物品
function Api:ghostReturnShowDrop(idArr, cb, err)
    Network:sendRequestWithLua(false, "logic", "logic.ghostHandler.ghostReturnShowDrop", { idArr = idArr, v = getV() }, cb, err or empty)
end

--鬼道重生
function Api:ghostBirth(ghost_key, cb,err)
    Network:sendRequestWithLua(false, "logic", "logic.ghostHandler.ghostBirth", { ghost_key = ghost_key, v = getV() }, cb, err or empty)
end

--获取对应装备重生获取的物品
function Api:ghostBirthShowDrop(ghost_key, cb, err)
    Network:sendRequestWithLua(false, "logic", "logic.ghostHandler.ghostBirthShowDrop", { ghost_key = ghost_key, v = getV() }, cb, err or empty)
end


--购买成长基金前检查
function Api:checkInvest(act_id, cb, err)
    Network:sendRequestWithLua(false, "logic", "logic.activityHandler.checkInvest", { act_id = act_id, v = getV() }, cb, err or empty)
end

--检查新邮箱
function Api:checkNewMails(cb, err)
    Network:sendRequestWithLua(false, "logic", "logic.mailHandler.checkNewMails", { v = getV() }, cb, err or empty)
    -- body
end

function Api:resetByTicket(cb, err)
    Network:sendRequestWithLua(false, "logic", "logic.qianCengTaHandler.resetByTicket", { v = getV() }, cb, err or empty)
end

--抽奖一次
function Api:turnTableOne(act_id, cb, err)
    Network:sendRequestWithLua(false, "logic", "logic.activityHandler.turnTableOne", { act_id = act_id, v = getV() }, cb, err or empty)
end

--抽奖十次
function Api:turnTableTen(act_id, cb, err)
    Network:sendRequestWithLua(false, "logic", "logic.activityHandler.turnTableTen", { act_id = act_id, v = getV() }, cb, err or empty)
end

--转盘积分领取奖励
function Api:getTurnTableReward(act_id,id,cb,err)
    Network:sendRequestWithLua(false, "logic", "logic.activityHandler.getTurnTableReward", { act_id = act_id,id = id,v = getV()}, cb, err or empty)
end

--大转盘积分排行
function Api:getTurnTableRank(act_id,cb,err)
    Network:sendRequestWithLua(false, "logic", "logic.activityHandler.getTurnTableRank", { act_id = act_id,v = getV()}, cb, err or empty)
end


--好友系统
--社区好友，黑名单，申请列表
function Api:getSocialList(type, cb, err)
    Network:sendRequestWithLua(false, "logic", "logic.socialHandler.getSocialList", { type = type, v = getV() }, cb, err or empty)
end

--玩家查询
function Api:queryPlayer(name, cb, err)
    Network:sendRequestWithLua(false, "logic", "logic.socialHandler.queryPlayer", { name = name, v = getV() }, cb, err or empty)
end

--好友申请
function Api:requestFriend(pid, cb, err)
    Network:sendRequestWithLua(false, "logic", "logic.socialHandler.requestFriend", { pid = pid, v = getV() }, cb, err or empty)
end

--推荐好友
function Api:randomPlayer(cb, err)
    Network:sendRequestWithLua(false, "logic", "logic.socialHandler.randomPlayer", { v = getV() }, cb, err or empty)
end

--同意好友申请
function Api:acceptRequest(pid, cb, err)
    Network:sendRequestWithLua(false, "logic", "logic.socialHandler.acceptRequest", { pid = pid, v = getV() }, cb, err or empty)
end

--忽略好友申请
function Api:ignoreRequest(pid, cb, err)
    Network:sendRequestWithLua(false, "logic", "logic.socialHandler.ignoreRequest", { pid = pid, v = getV() }, cb, err or empty)
end

--删除好友
function Api:removeFriend(pid, cb, err)
    Network:sendRequestWithLua(false, "logic", "logic.socialHandler.removeFriend", { pid = pid, v = getV() }, cb, err or empty)
end

--拉黑
function Api:pullBlack(pid, cb, err)
    Network:sendRequestWithLua(false, "logic", "logic.socialHandler.pullBlack", { pid = pid, v = getV() }, cb, err or empty)
end

--移除黑名单
function Api:removeBlack(pid, cb, err)
    Network:sendRequestWithLua(false, "logic", "logic.socialHandler.removeBlack", { pid = pid, v = getV() }, cb, err or empty)
end

--赠送体力
function Api:sendBp(pid, cb, err)
    Network:sendRequestWithLua(false, "logic", "logic.socialHandler.sendBp", { pid = pid, v = getV() }, cb, err or empty)
end

--一键赠送
function Api:autoSendBp(cb, err)
    Network:sendRequestWithLua(false, "logic", "logic.socialHandler.autoSendBp", { v = getV() }, cb, err or empty)
end

--领取体力
function Api:acceptBp(pid, cb, err)
    Network:sendRequestWithLua(false, "logic", "logic.socialHandler.acceptBp", { pid = pid, v = getV() }, cb, err or empty)
end

--一键领取
function Api:autoAcceptBp(cb, err)
    Network:sendRequestWithLua(false, "logic", "logic.socialHandler.autoAcceptBp", { v = getV() }, cb, err or empty)
end

--获取好友阵容
function Api:getFriendTeam(pid, cb, err)
    Network:sendRequestWithLua(false, "logic", "logic.socialHandler.getFriendTeam", { pid = pid, v = getV() }, cb, err or empty)
end

--好友切磋
function Api:challenge(pid, cb, err)
    Network:sendRequestWithLua(false, "logic", "logic.socialHandler.challenge", { pid = pid, v = getV() }, cb, err or empty)
end

-- ================> 公会相关 begin <================
-- 创建公会
function Api:createGuildInfo(guildName, iconNumber, cost, cb, err)
    Network:sendRequestWithLua(false, "logic", "logic.GuildHandler.createGuildInfo",
        { guildName = guildName, icon = iconNumber, cost = cost, v = getV() }, cb, err or empty)
end

-- 申请加入公会
function Api:applyJoin(guildId, cb, err)
    Network:sendRequestWithLua(false, "logic", "logic.GuildHandler.applyJoin",
        { guildId = guildId, v = getV() }, cb, err or empty)
end

-- 取消申请加入公会
function Api:cancelApplyJoin(guildId, cb, err)
    Network:sendRequestWithLua(false, "logic", "logic.GuildHandler.cancelApplyJoin",
        { guildId = guildId, v = getV() }, cb, err or empty)
end

-- 得到当前的帮会列表
function Api:getGuildList(page, cb, err)
    Network:sendRequestWithLua(false, "logic", "logic.GuildHandler.getGuildList",
        { page = page, v = getV() }, cb, err or empty)
end

-- 查找帮会列表  搜索帮派  
function Api:searchGuildByNameOrId(nameOrId, cb, err)
    Network:sendRequestWithLua(false, "logic", "logic.GuildHandler.searchGuildByNameOrId",
        { nameOrId = nameOrId, v = getV() }, cb, err or empty)
end

-- 得到当前的申请加入帮会列表
function Api:getGuildApplyList(cb, err)
    Network:sendRequestWithLua(false, "logic", "logic.GuildHandler.getGuildApplyList",
        { v = getV() }, cb, err or empty)
end

-- 同意或拒绝加入帮会
function Api:agreeJoin(isOk, applyId, cb, err)
    Network:sendRequestWithLua(false, "logic", "logic.GuildHandler.agreeJoin",
        { isOk = isOk, applyId = applyId, v = getV() }, cb, err or empty)
end

-- 得到当前帮会消息列表
function Api:getGuildMessageList(cb, err)
    Network:sendRequestWithLua(false, "logic", "logic.GuildHandler.getGuildMessageList",
        { v = getV() }, cb, err or empty)
end

-- 帮会踢人 x
function Api:kickMember(playerId, cb, err)
    Network:sendRequestWithLua(false, "logic", "logic.GuildHandler.kickMember",
        { playerId = playerId, v = getV() }, cb, err or empty)
end

-- 帮会解除职务 x
function Api:fireJob(playerId, cb, err)
    Network:sendRequestWithLua(false, "logic", "logic.GuildHandler.fireJob",
        { playerId = playerId, v = getV() }, cb, err or empty)
end

-- 帮会移交职务 x
function Api:appointJob(playerId, cb, err)
    Network:sendRequestWithLua(false, "logic", "logic.GuildHandler.appointJob",
        { playerId = playerId, v = getV() }, cb, err or empty)
end

-- 帮会移交会长职务 x
function Api:appointMasterJob(playerId, cb, err)
    Network:sendRequestWithLua(false, "logic", "logic.GuildHandler.appointMasterJob",
        { playerId = playerId, v = getV() }, cb, err or empty)
end

-- 解散帮派
-- isCancel=true解散、isCancel=false取消解散
function Api:dissolutionGuildInfo(isCancel, cb, err)
    Network:sendRequestWithLua(false, "logic", "logic.GuildHandler.dissolutionGuildInfo",
        { isCancel = isCancel, v = getV() }, cb, err or empty)
end

-- 退出帮派
function Api:exitGuild(cb, err)
    Network:sendRequestWithLua(false, "logic", "logic.GuildHandler.exit",
        { v = getV() }, cb, err or empty)
end

-- 弹劾会长
function Api:impeach(cb, err)
    Network:sendRequestWithLua(false, "logic", "logic.GuildHandler.impeach",
        { v = getV() }, cb, err or empty)
end

-- 修改帮会信息
-- type｛123｝: 1-修改图标, 2-悠announce 3-修改notice。
function Api:changeGuildInfo(type, val, cb, err)
    Network:sendRequestWithLua(false, "logic", "logic.GuildHandler.changeGuildInfo",
        { type = type, val = val, v = getV() }, cb, err or empty)
end

-- 得到帮会信息
function Api:getGuildBaseInfo(cb, err)
    Network:sendRequestWithLua(false, "logic", "logic.GuildHandler.getGuildBaseInfo",
        { v = getV() }, cb, err or empty)
end

-- 得到公会成员列表
function Api:getGuildMemberList(cb, err)
    Network:sendRequestWithLua(false, "logic", "logic.GuildHandler.getGuildMemberList",
        { v = getV() }, cb, err or empty)
end

-- 得到帮派副本列表
function Api:getCopyList(cb, err)
    Network:sendRequestWithLua(false, "logic", "logic.GuildHandler.getCopyList",
        { v = getV() }, cb, err or empty)
end

-- -- 挑战副本
-- function Api:defiance(copyId, cb, err )
--            Network:sendRequestWithLua(false, "logic", "logic.GuildHandler.defiance",
--                 {copyId=copyId, v = getV() }, cb, err or empty)
-- end

--公会挑战
--type 区分普通，精英，协会副本 commonChapter,heroChapter,unionChapter
--copyId 复本id
--team 队伍中角色id数组
function Api:defiance(type, chapterId, copyId, team, teamId, _cb, err)
    self:checkTeam(team, teamId, function()
        local cb = function(result)
            if _cb then _cb(result) end
            DataEye.defiance(type, chapterId, copyId, team, result)
        end
        DialogMrg.updateBp()
        Network:sendRequestWithLua(false, "logic", "logic.GuildHandler.defiance", { chapterId = chapterId, copyId = copyId, team = team, v = getV() }, cb, err or empty)
    end)
end

-- 设置申请条件
function Api:setApplyCondition(isCondition, level, cb, err)
    Network:sendRequestWithLua(false, "logic", "logic.GuildHandler.setApplyCondition",
        { isCondition = isCondition, level = level, v = getV() }, cb, err or empty)
end

-- 得到帮派排行列表
function Api:getGuildRankList(cb, err)
    Network:sendRequestWithLua(false, "logic", "logic.GuildHandler.getGuildRankList",
        { v = getV() }, cb, err or empty)
end

-- 得到帮派会员战绩排行
function Api:getGuildHurtRankList(cb, err)
    Network:sendRequestWithLua(false, "logic", "logic.GuildHandler.getGuildHurtRankList",
        { v = getV() }, cb, err or empty)
end

-- 膜拜
function Api:worship(typeId, _cb, err)
    local cb = function(result)
        if _cb then _cb(result) end
        DataEye.worship(typeId, result)
    end
    Network:sendRequestWithLua(false, "logic", "logic.GuildHandler.sacrifice",
        { typeId = typeId, v = getV() }, cb, err or empty)
end

-- --购买-公会战斗次数
-- function Api:buyGuildFightCount(cb, err)
--     Network:sendRequestWithLua(false, "logic", "logic.buyresourceHandler.buyGuildFightCount", { times = Player.Times.buyGuildFightCount, v = getV() }, cb, err or empty)
-- end

--使用-公会战斗次数
function Api:useGuildFightItem(itemCount, cb, err)
    Network:sendRequestWithLua(false, "logic", "logic.GuildHandler.useGuildFightItem",
        { itemCount = itemCount, v = getV() }, cb, err or empty)
end

-- 1.领取的参拜奖励
-- 参数一个 lv 接收领取的参拜等级
-- { ret: 0, drop: { item: { '27': 100, '56': 100 } } }
--[[msg: {
        lv: 1 // 参拜等级
    }]]
function Api:sacrificeReward(lv, cb, err)
    Network:sendRequestWithLua(false, "logic", "logic.GuildHandler.sacrificeReward",
        { lv = lv, v = getV() }, cb, err or empty)
end

-- 2.领取副本通关奖励（一章的四个Boss都打完之后领取）
--[[msg: {
        chapter: 1 // 第几章的奖励
    }]]
function Api:copyPassReward(chapter, cb, err)
    Network:sendRequestWithLua(false, "logic", "logic.GuildHandler.copyPassReward",
        { chapter = chapter, v = getV() }, cb, err or empty)
end

-- 3.获取某个 Boss 死后的宝箱
--    剩余宝箱的情况，50个，非0表示已经被人领取了
--[[msg: {
        copyId: 1 // 第几个 Boss 的宝箱
    }]]
function Api:getBoxListById(copySectionId, cb, err)
    Network:sendRequestWithLua(false, "logic", "logic.GuildHandler.getBoxListById",
        { copyId = copySectionId, v = getV() }, cb, err or empty)
end

-- 4.打开 Boss 的宝箱
--[[msg: {
        copyId: 1, // 第几个 Boss 的宝箱
        index: 49, // 宝箱中的第几个物品
    }]]
function Api:getBoxRewardById(copyId, index, cb, err)
    Network:sendRequestWithLua(false, "logic", "logic.GuildHandler.getBoxRewardById",
        { copyId = copyId, index = index, v = getV() }, cb, err or empty)
end

-- 5.获取公会各种状态，不用传参
--[[返回值主要有
    {
        ret:0
        visit: [1,2,3],       // 已经领取过奖励的参拜等级
        chapter: [1,2,3], // 已经领取过奖励的副本章节 
        box: [1,2,3,4,5,6], // 已经领取过奖励的Boss关卡id
        boxList:[]
    }]]
function Api:memberStatus(cb, err)
    Network:sendRequestWithLua(false, "logic", "logic.GuildHandler.memberStatus",
        { lv = lv, v = getV() }, cb, err or empty)
end


--pid: 道具商店是1，限时商店是2
function Api:getShopList(id, cb, err)
    Network:sendRequestWithLua(false, "logic", "logic.GuildHandler.getShopList", { shopid = id }, cb, err or empty)
end

function Api:buyGuildShop(sid, stype, sitemid, snum, cb, err)
    Network:sendRequestWithLua(false, "logic", "logic.GuildHandler.buyGuildShop", { shopid = sid, type = stype, id = sitemid, num = snum }, cb, err or empty)
end

function Api:buyPkgShop(sid, snum, cb, err)
    Network:sendRequestWithLua(false, "logic", "logic.GuildHandler.buyPkgShop", { id = sid, num = snum }, cb, err or empty)
end

--公会改名
function Api:reNameGuild(name, cb, err)
    Network:sendRequestWithLua(false, "logic", "logic.GuildHandler.changeGuildName", { name = name }, cb, err or empty)
end
-- ================> 公会相关 end <================






--挑战代理死神
function Api:onFight(areaId, cb, err)
    Network:sendRequestWithLua(false, "logic", "logic.agencyHandler.onFight", { areaId = areaId, v = getV() }, cb, err or empty)
end

--开始巡逻
function Api:startPatrol(charId, areaId, timeId, modelId, cb, err)
    Network:sendRequestWithLua(false, "logic", "logic.agencyHandler.startPatrol", { charId = charId, areaId = areaId, timeId = timeId, modelId = modelId, v = getV() }, cb, err or empty)
end

--检查巡逻
function Api:checkPatrol(areaId, _cb, err)
    local cb = function(result)
        if result:ContainsKey("t") then
            Network:onUpdateServerTime("logic", result.t, 100)
        end
        if _cb then _cb(result) end
    end
    Network:sendRequestWithLua(false, "logic", "logic.agencyHandler.checkPatrol", { areaId = areaId, v = getV() }, cb, err or empty)
end

--领奖
function Api:getReward(areaId, cb, err)
    Network:sendRequestWithLua(false, "logic", "logic.agencyHandler.getReward", { areaId = areaId, v = getV() }, cb, err or empty)
end

--领取所有奖励
function Api:getAllReward(cb,err)
    Network:sendRequestWithLua(false, "logic", "logic.agencyHandler.getAllReward",{v = getV()},cb,err or empty)
end

--血脉
function Api:BloodlineLvup(charId, cb, err)
    Network:sendRequestWithLua(false, "logic", "logic.BloodlineHandler.BloodlineLvup", { charId = charId, v = getV() }, cb, err or empty)
end


function Api:fightDaxu(pid, type, cb, err)
    Network:sendRequestWithLua(false, "logic", "logic.daXuHandler.fightDaxu", { pid = pid, type = type, v = getV() }, cb, err or empty)
end

function Api:getAllGXReward(cb,err)
    Network:sendRequestWithLua(false, "logic", "logic.daXuHandler.getAllGXReward", { v = getV()}, cb, err or empty)
end


function Api:checkDaxu(cb, err)
    Network:sendRequestWithLua(false, "logic", "logic.daXuHandler.checkDaxu", { v = getV() }, cb, err or empty)
end

--分享大虚
function Api:share(cb, err)
    Network:sendRequestWithLua(false, "logic", "logic.daXuHandler.share", { v = getV() }, cb, err or empty)
end

function Api:getGXReward(id, cb, err)
    Network:sendRequestWithLua(false, "logic", "logic.daXuHandler.getGXReward", { id = id, v = getV() }, cb, err or empty)
end

function Api:useTaoFaLing(cb, err)
    Network:sendRequestWithLua(false, "logic", "logic.daXuHandler.useTaoFaLing", { v = getV() }, cb, err or empty)
end

--type = 'gongxun' || 'dmg' 
function Api:getGxRank(tp, min, max, cb, err)
    Network:sendRequestWithLua(false, "logic", "logic.daXuHandler.getRank", { type = tp, min = min, max = max, v = getV() }, cb, err or empty)
end

function Api:showGxDetailInfo(pid, cb, err)
    Network:sendRequestWithLua(false, "logic", "logic.daXuHandler.showDetailInfo", { pid = pid, v = getV() }, cb, err or empty)
end

--许愿请求
function Api:WishingReq(act_id,_type,times, cb, err)
    Network:sendRequestWithLua(false, "logic", "logic.activityHandler.wishing", { act_id = act_id, type = _type,times = times, v = getV() }, cb, err or empty)
end
--许愿币合成
function Api:WishingCoinCompound(act_id,num , cb, err)
    Network:sendRequestWithLua(false, "logic", "logic.activityHandler.wishingCompound", { act_id = act_id, num = num , v = getV() }, cb, err or empty)
end


function Api:getPointReward(id, cb, err)
    Network:sendRequestWithLua(false, "logic", "logic.taskHandler.getPointReward", { id = id, v = getV() }, cb, err or empty)
end

function Api:getBattlefieldReport(cb, err)
	Network:sendRequestWithLua(false, "logic", "logic.taorenBossHandler.getBattlefieldReport", { v = getV() }, cb, err or empty)
end

function Api:getLvReward(type, id, cb, err)
	Network:sendRequestWithLua(false, "logic", "logic.taorenBossHandler.getReward", {type = type, id = id, v = getV() }, cb, err or empty)
end 

function Api:getAllLvReward(type, cb, err)
	Network:sendRequestWithLua(false, "logic", "logic.taorenBossHandler.getAllReward", {type = type, v = getV() }, cb, err or empty)
end

function Api:addFightTimeByTaoRen(cb, err)
	Network:sendRequestWithLua(false, "logic", "logic.taorenBossHandler.addFightTime", {v = getV() }, cb, err or empty)
end 


--逃忍boss信息
function Api:checkTaoRenBoss(cb, err)
    Network:sendRequestWithLua(false, "logic", "logic.taorenBossHandler.checkTaoRenBoss", { v = getV() }, cb, err or empty)
end

--挑战逃忍boss
function Api:fightTaoRenBoss(cb, err)
    Network:sendRequestWithLua(false, "logic", "logic.taorenBossHandler.fightTaoRenBoss", { v = getV() }, cb, err or empty)
end

--排行
function Api:getTaoRenBossRank(type, camp, cb, err)
    Network:sendRequestWithLua(false, "logic", "logic.taorenBossHandler.getRank", {type = type, camp = camp, v = getV() }, cb, err or empty)
end

--购买次数
function Api:taoRenUseTaoFaLing(cb, err)
    Network:sendRequestWithLua(false, "logic", "logic.taorenBossHandler.useTaoFaLing", { v = getV() }, cb, err or empty)
end

--选择阵营
function Api:chooseCamp(id, cb, err)
    Network:sendRequestWithLua(false, "logic", "logic.taorenBossHandler.chooseCamp", { campId = id, v = getV() }, cb, err or empty)
end

--世界boss信息
function Api:checkBoss(cb, err)
    Network:sendRequestWithLua(false, "logic", "logic.worldBossHandler.checkBoss", { v = getV() }, cb, err or empty)
end

--挑战世界boss
function Api:fightBoss(cb, err)
    Network:sendRequestWithLua(false, "logic", "logic.worldBossHandler.fightBoss", { v = getV() }, cb, err or empty)
end

function Api:clearBossCDTime(cb, err)
    Network:sendRequestWithLua(false, "logic", "logic.worldBossHandler.clearCDTime", { v = getV() }, cb, err or empty)
end

function Api:addWorldBuff(tp, cb, err)
    Network:sendRequestWithLua(false, "logic", "logic.worldBossHandler.addBuff", { type = tp, v = getV() }, cb, err or empty)
end

function Api:getBossReward(id, cb, err)
    Network:sendRequestWithLua(false, "logic", "logic.worldBossHandler.getReward", { id = id, v = getV() }, cb, err or empty)
end

function Api:getBossRank(cb, err)
    Network:sendRequestWithLua(false, "logic", "logic.worldBossHandler.getRank", { id = id, v = getV() }, cb, err or empty)
end


function Api:collectDeviceInfo(info, cb)
    local err = function(ret)
        return true
    end
    Network:sendRequestWithLua(false, "logic", "logic.sessionHandler.collectDeviceInfo", { version = SettingConfig.getVersion(), info = info, v = getV() }, cb, err or empty)
end

--app store pay
function Api:verfyIOSPay(dataobj,callBackInfo, cb, err)
    Network:sendRequestWithLua(false, "logic", "logic.payHandler.verfyIOSPay", {data = dataobj,callBackInfo=callBackInfo,v = getV() }, cb, err or empty)
end

function Api:verifyGooglePlay(inapp_purchase_data,inapp_data_signature,callBackInfo, cb, err)
    Network:sendRequestWithLua(false, "logic", "logic.payHandler.verifyGooglePlay", {inapp_purchase_data = inapp_purchase_data,inapp_data_signature=inapp_data_signature,callBackInfo=callBackInfo,v = getV() }, cb, err or empty)
end

--比武拉取列表
function Api:getContestList(cb,err)
    Network:sendRequestWithLua(false, "logic", "logic.crossContestHandler.getContestList", {v = getV() }, cb, err or empty)
end

--比武增加buff
function Api:addBuff(pid,cb,err)
    Network:sendRequestWithLua(false, "logic", "logic.crossContestHandler.addBuff", {pid = pid, v = getV() }, cb, err or empty)
end

--拉取比武记录列表
function Api:getRecordList(cb,err)
    Network:sendRequestWithLua(false, "logic", "logic.crossContestHandler.getRecordList", {v = getV() }, cb, err or empty)
end

--看比武某一场记录
function Api:getOneRecord(pid1,pid2,nth,version,cb,err)
    Network:sendRequestWithLua(false, "logic", "logic.crossContestHandler.getOneRecord", {pid1 = pid1, pid2 = pid2, nth = nth, version = version, v = getV() }, cb, err or empty)
end

--查看上半区或下半区进度(half为类型up或者down)
function Api:getContestFlow(half,cb,err)
    Network:sendRequestWithLua(false, "logic", "logic.crossContestHandler.getContestFlow", {half = half, v = getV() }, cb, err or empty)
end

--查看进度概况
function Api:getFinalFlow(cb,err)
    Network:sendRequestWithLua(false, "logic", "logic.crossContestHandler.getFinalFlow", {v = getV() }, cb, err or empty)
end

-- 获取比武排名奖励预览
function Api:getRewardShow(cb,err)
    Network:sendRequestWithLua(false, "logic", "logic.crossContestHandler.getRewardShow", {v = getV() }, cb, err or empty)
end

--跨服比武活动开启判断
function Api:checkContest(cb,err)
    Network:sendRequestWithLua(false, "logic", "logic.crossContestHandler.checkContest", {v = getV() }, cb, err or empty)
end

--跨服比武结果
function Api:getHistoryTop3(cb,err)
    Network:sendRequestWithLua(false, "logic", "logic.crossContestHandler.getHistoryTop3", {v = getV() }, cb, err or empty)
end

--跨服比武竞猜答题
function Api:answerQuestion(topNum,nth,index,count,cb,err)
    Network:sendRequestWithLua(false, "logic", "logic.crossContestHandler.answerQuestion", {topNum = topNum, nth = nth, index = index, count = count, v = getV() }, cb, err or empty)
end

--跨服比武获取题目
function Api:getQuestion(cb,err)
    Network:sendRequestWithLua(false, "logic", "logic.crossContestHandler.getQuestion", {v = getV() }, cb, err or empty)
end

--获取竞猜题目奖励预览
function Api:getGuessRewardShow(cb,err)
    Network:sendRequestWithLua(false, "logic", "logic.crossContestHandler.getGuessRewardShow", {v = getV() }, cb, err or empty)
end

--获取上届比武前三名
function Api:getLastTop3(cb,err)
    Network:sendRequestWithLua(false, "logic", "logic.crossContestHandler.getLastTop3", {v = getV() }, cb, err or empty)
end

--挑战上届比武前三名
function Api:fightTop3(nTop,cb,err)
    Network:sendRequestWithLua(false, "logic", "logic.crossContestHandler.fightTop3", {nTop = nTop, v = getV() }, cb, err or empty)
end

--竞猜题奖励领取
function Api:getGuessReward(type,topNum,nth,cb,err)
     Network:sendRequestWithLua(false, "logic", "logic.crossContestHandler.getGuessReward", {type = type, topNum = topNum, nth = nth, v = getV() }, cb, err or empty)
end

--查看玩家阵容
function Api:getInfo(pid,sid,cb,err)
    Network:sendRequestWithLua(false, "logic", "logic.crossContestHandler.getInfo", {pid = pid,sid = sid, v = getV() }, cb, err or empty)
end

-- 出售卡片
function Api:sellOneCard(ids,cb,err)
    Network:sendRequestWithLua(false, "logic", "logic.trainHandler.sellOneCard", {keys = ids, v = getV() }, cb, err or empty)
end

function Api:sellEquip(type, key, cb, err)
	Network:sendRequestWithLua(false, "logic", "logic.drawHandler.sellEquip", {type = type, key = key, v = getV() }, cb, err or empty)
end 

-- 忍者培养
function Api:charXilian(id, type, times, cb, err)
    Network:sendRequestWithLua(false, "logic", "logic.trainHandler.charXilian", {charid = id, type = type, times = times, v = getV() }, cb, err or empty)
end

-- 替换
function Api:charXilianReplaceAttr(charid, cb, err)
	Network:sendRequestWithLua(false, "logic", "logic.trainHandler.charXilianReplaceAttr", {charid = charid, v = getV() }, cb, err or empty)
end 

-- 取消
function Api:charXilianGiveUp(charid, cb, err)
	Network:sendRequestWithLua(false, "logic", "logic.trainHandler.charXilianGiveUp", {charid = charid, v = getV() }, cb, err or empty)
end 

-- 计算属性
function Api:getCharProperty(charid, lvl, stage, star, bloodlvl, cb, err)
	Network:sendRequestWithLua(false, "logic", "logic.trainHandler.getCharProperty", {charid = charid, lvl = lvl, star = star, stage = stage, bloodlvl = bloodlvl, v = getV() }, cb, err or empty)
end

-- 御灵每日奖励
function Api:receiveDayReward(id, cb, err)
    Network:sendRequestWithLua(false, "logic", "logic.yulingHandler.receiveDayReward", {id = id, v = getV() }, cb, err or empty)
end

-- 御灵终身奖励
function Api:receiveLifetimeReward(id,cb, err)
    Network:sendRequestWithLua(false, "logic", "logic.yulingHandler.receiveLifetimeReward", {id = id, v = getV() }, cb, err or empty)
end

-- 御灵术提升
function Api:yulingshuUp(level,magic_effect, cb, err)
    Network:sendRequestWithLua(false, "logic", "logic.yulingHandler.yulingshuUp", {level = level, magic_effect=magic_effect, v = getV() }, cb, err or empty)
end

-- 御灵上阵
function Api:yulingHuyou(yulingid, position, cb, err)
    Network:sendRequestWithLua(false, "logic", "logic.yulingHandler.yulingHuyou", {yulingid = yulingid, position=position, v = getV() }, cb, err or empty)
end

-- 御灵下阵
function Api:yulingHuyouUnload(position, cb, err)
    Network:sendRequestWithLua(false, "logic", "logic.yulingHandler.yulingHuyouUnload", {position = position,v = getV() }, cb, err or empty)
end

-- 计算御灵属性
function Api:getyulingProperty(yulingid, lvl, star, cb, err)
    Network:sendRequestWithLua(false, "logic", "logic.yulingHandler.getyulingProperty", {yulingid = yulingid, lvl = lvl, star = star, v = getV() }, cb, err or empty)
end

-- 御灵升星
function Api:yulingStarUp(yulingid, cb, err)
    Network:sendRequestWithLua(false, "logic", "logic.yulingHandler.yulingStarUp", {yulingid = yulingid, v = getV() }, cb, err or empty)
end

-- 御灵升级
function Api:yulingLevelUp(yulingid, idArr, upLevel, cb, err)
    Network:sendRequestWithLua(false, "logic", "logic.yulingHandler.yulingLevelUp", {yulingid = yulingid, idArr = idArr, upLevel = upLevel, v = getV() }, cb, err or empty)
end

--御灵召唤
--参数1：draw表格的id值。
function Api:yulingDraw(_id, _cb, err)
    local cb = function(result)
        if _cb then _cb(result) end
        DataEye.draw(_id, result)
    end
    Network:sendRequestWithLua(false, "logic", "logic.yulingHandler.yulingDraw", { id = _id, v = getV() }, cb, err or empty)
end

-- 计算宠物属性
function Api:getPetProperty(petid, lvl, shenlian, star, cb, err)
	Network:sendRequestWithLua(false, "logic", "logic.petHandler.getPetProperty", {petid = petid, lvl = lvl, star = star, shenlian = shenlian, v = getV() }, cb, err or empty)
end

-- 宠物升级
function Api:petLevelUp(petid, idArr, exp, cb, err)
	Network:sendRequestWithLua(false, "logic", "logic.petHandler.petLevelUp", {petid = petid, idArr = idArr, exp = exp, v = getV() }, cb, err or empty)
end

-- 宠物上阵
function Api:petOnTeam(petid, cb, err)
	Network:sendRequestWithLua(false, "logic", "logic.petHandler.petOnTeam", {petid = petid, v = getV() }, cb, err or empty)
end

-- 宠物下阵
function Api:petOffTeam(cb, err)
	Network:sendRequestWithLua(false, "logic", "logic.petHandler.petOffTeam", {v = getV() }, cb, err or empty)
end

-- 宠物神炼
function Api:shenlianUp(petid, idArr, upLevel, cb, err)
	Network:sendRequestWithLua(false, "logic", "logic.petHandler.shenlianUp", {petid = petid, idArr = idArr, upLevel = upLevel, v = getV() }, cb, err or empty)
end

-- 宠物升星
function Api:petStarUp(petid, cb, err)
	Network:sendRequestWithLua(false, "logic", "logic.petHandler.petStarUp", {petid = petid, v = getV() }, cb, err or empty)
end

-- 宠物护佑
function Api:petHuyou(petid, position, cb, err)
	Network:sendRequestWithLua(false, "logic", "logic.petHandler.petHuyou", {petid = petid, position = position, v = getV() }, cb, err or empty)
end

-- 宠物护佑， 卸下
function Api:petHuyouUnload(position, cb, err)
	Network:sendRequestWithLua(false, "logic", "logic.petHandler.petHuyouUnload", {position = position, v = getV() }, cb, err or empty)
end 

--宠物关卡--重置
function Api:resetPetChapter(cb, err)
    Network:sendRequestWithLua(false, "logic", "logic.petChapterHandler.resetChapter", {v = getV() }, cb, err or empty)
end

--宠物关卡--挑战某个点上的敌人
function Api:fightEnemy(index, cb, err)
    Network:sendRequestWithLua(false, "logic", "logic.petChapterHandler.fightEnemy", {pos = index, v = getV() }, cb, err or empty)
end

--宠物关卡--下一关
function Api:nextChapter(cb, err)
    Network:sendRequestWithLua(false, "logic", "logic.petChapterHandler.nextChapter", {v = getV() }, cb, err or empty)
end

--宠物关卡--领取奖励
function Api:getPrize(cb, err)
    Network:sendRequestWithLua(false, "logic", "logic.petChapterHandler.getPrize", {v = getV() }, cb, err or empty)
end

--宠物关卡--请求数据
function Api:InitPetChapterData(cb, err)
    Network:sendRequestWithLua(false, "logic", "logic.petChapterHandler.checkInit", {v = getV() }, cb, err or empty)
end

-- 购买精英挑战次数
function Api:buyJYTimes(cb, err)
	Network:sendRequestWithLua(false, "logic", "logic.qianCengTaHandler.buyJYTimes", {v = getV() }, cb, err or empty)
end

-- 忍转身
function Api:charChange(isChange, idArr, dictid, isUseItem, cb, err)
	Network:sendRequestWithLua(false, "logic", "logic.charChangeHandler.charChange", {isChange = isChange, idArr = idArr, dictid = dictid, isUseItem = isUseItem, v = getV()}, cb, err or empty)
end

function Api:subDay7(taskId, cb, err)
    Network:sendRequestWithLua(false, "logic", "logic.day7sHandler.submitTask", {v = getV(), id = taskId}, cb, err or empty)
end

function Api:subDay14(type, taskId, times, cb, err)
    Network:sendRequestWithLua(false, "logic", "logic.dayNsHandler.submitTask", {v = getV(), dayNs_id = type, taskid = taskId, times = times}, cb, err or empty)
end

return Api