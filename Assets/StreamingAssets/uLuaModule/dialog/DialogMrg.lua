--
-- Created by IntelliJ IDEA.
-- User: xiyou
-- Date: 2014/10/15
-- Time: 9:52
-- To change this template use File | Settings | File Templates.
-- 对话框
DialogMrg = {}
DialogMrg.isShow = false
--消息对话框
function DialogMrg.ShowDialog(msg, onOk, onCancel, titleName, _type, btnName, cancelBtnName)
    if DialogMrg.isShow == true then
        UIMrg:popMessage()
        DialogMrg.isShow = false
    end
    if msg == "" or msg == nil then return end
    DialogMrg.isShow = true
    UIMrg:pushMessage("Prefabs/moduleFabs/alertModule/dialog", {
        type = _type or "msg",
        msg = msg,
        btnName = btnName,
        cancelBtnName = cancelBtnName,
        title = titleName or TextMap.GetValue("Text70"),
        onOk = onOk or function() end,
        onCancel = onCancel or function() end
    })
end

function DialogMrg.HideDialog()
    -- if DialogMrg.isShow == true then
    --     MessageMrg.showMove("网络已重新连接")
    --     UIMrg:popMessage()
    --     DialogMrg.isShow = false
    -- end
end

function DialogMrg.ShowFindDaxu(msg, onOk, onClose)
    UIMrg:pushMessage("Prefabs/activityModule/encirclementModule/dialogFindDaxu", {
        msg = msg,
        onOk = onOk or function() end,
        onClose = onClose or function() end
    })
end

function DialogMrg.unLock(moduleId)
    local linkData = Tool.readSuperLinkById( moduleId)
    if linkData == nil then return end
    local msg = linkData.from .. TextMap.GetValue("Text352")
    UIMrg:pushMessage("Prefabs/moduleFabs/alertModule/dialog", {
        type = "openModule",
        msg = msg,
        onOk = function()
            uSuperLink.openModule(moduleId, 2)
        end
    })
end

--充值
function DialogMrg.chognzhi()
    Tool.push("activity", "Prefabs/moduleFabs/activityModule/activity_gradeGift",{"","recharge"})
end

function DialogMrg:BuyBpAOrSoul(_type, titleName, closeCallBack, refreashCallBack, userCallBack)
    UIMrg:pushWindow("Prefabs/moduleFabs/alertModule/GoldToSoulAndBP", { _type, titleName, closeCallBack, refreashCallBack, userCallBack })
end

--买体力
function DialogMrg.buyBp()
    local buyLimit = TableReader:TableRowByUnique("buyLimitTimes", "vip_level", Player.Info.vip).bp_limit_times
    if Player.Times['buybp'] >= buyLimit then
        DialogMrg.ShowDialog(TextMap.GetValue("Text353"), DialogMrg.chognzhi)
        return
    end
    UIMrg:pushWindow("Prefabs/moduleFabs/alertModule/purchase", {
        "bp"
    })
end

--更新上次升级体力..
function DialogMrg.updateBp()
    local lastChapter = Player.Chapter.lastChapter
    Tool.LastChapter = lastChapter
    if DialogMrg._levelData then
        DialogMrg._levelData.bp = Player.Resource.bp
    end
end

--队伍升级
function DialogMrg.levelUp(reset, push)
    local info = Player.Info

    if DialogMrg._levelData == nil or reset == true then
        local data = {}
        local res = Player.Resource
        data.lv = info.level
        data.max_bp = res.max_bp
        data.max_char_lv = res.max_char_lv
        data.bp = res.bp
        data.max_slot = Player.Resource.max_slot
		data.vp = res.vp
		data.max_vp = res.max_vp

        DialogMrg._levelData = data
        return false
    end
    DialogMrg._levelData.push = push
    if info.level > DialogMrg._levelData.lv then
        MusicManager.playByID(28) --升级的时候播放
        if info.level == 10 then
            print("到达10级，触发事件")
            mysdk:setEvent("event_1")
        end
        if info.level == 30 then
            print("到达30级，触发事件")
            mysdk:setEvent("event_2")
        end
        if push == nil or push == false then
            UIMrg:pushWindow("Prefabs/moduleFabs/userinfoModule/levelup_new", DialogMrg._levelData)
        else
            UIMrg:push("levelup","Prefabs/moduleFabs/userinfoModule/levelup_new", DialogMrg._levelData)
        end
        return true
    else
        DialogMrg._levelData.bp = Player.Resource.bp
    end
    return false
end

--点金手
function DialogMrg.buyMoney()
    UIMrg:pushWindow("Prefabs/moduleFabs/alertModule/GoldToMoney")
end

--买技能点
function DialogMrg.buySkillPoint(cb)
    local row = TableReader:TableRowByUnique("buyLimitTimes", "vip_level", Player.Info.vip)
    if row ~= nil then
        if row.skillpoint_limit_times == 0 then
            for i = Player.Info.vip + 1, 15 do
                local row = TableReader:TableRowByUnique("buyLimitTimes", "vip_level", i)
                if row.skillpoint_limit_times ~= 0 then
                    local desc = string.gsub(TextMap.VIP_LEVEL_OPEN, "{1}", TextMap.BUY_SKILL_POINT)
                    desc = string.gsub(desc, "{0}", i)
                    DialogMrg.ShowDialog(desc, function()
                        DialogMrg.chognzhi()
                    end)
                    return
                end
            end
        end
    end

    local sk_time = Player.Times.buyskillpoint

    row = TableReader:TableRowByUniqueKey("buySkillpoint", sk_time + 1, "buy_skillpoint")
    if row == nil then
        row = TableReader:TableRowByUniqueKey("buySkillpoint", sk_time, "buy_skillpoint")
    end

    if row then
        local consume = row.consume
        local i = 0

        local gold = consume[i].consume_arg
        local count = Player.Resource.max_skill_point
        local desc = TextMap.getText("BUY_SKILL_DESC", { count, gold, sk_time })
        DialogMrg.ShowDialog(desc, function()
            Api:buySkillPoint(function(reuslt)
                MessageMrg.show(TextMap.BUY_SUCC)
                if cb ~= nil then cb() end
            end)
        end)
    end
end


--碎片掉落
function DialogMrg.showPieceDrop(piece)
    UIMrg:pushWindow("Prefabs/moduleFabs/charModule/rolePiece", piece)
end

return DialogMrg

