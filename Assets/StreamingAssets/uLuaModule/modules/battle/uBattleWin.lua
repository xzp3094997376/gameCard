local BattleWin = {}
local chapterFightPanel = require("uLuaModule/modules/chapter/uChapterFight.lua")
local leagueFightPanel = require("uLuaModule/modules/league/uLeague_Fight.lua")


function BattleWin:onClick(go, name)
    if self.canClickBtn == nil or self.canClickBtn == false then
        return
    end
    if name == "Button_peiyang2" then
        --Tool.push("hero_select_char", "Prefabs/moduleFabs/hero/hero_select_char")
        --uSuperLink.openModule(73)
        Tool.push("hero_select_char", "Prefabs/moduleFabs/hero/hero_select_char")
    elseif name == "Button_zhaohuan3" then
        uSuperLink.openModule(8)
    elseif name == "Button_zhenrong" then
        Tool.push("team", "Prefabs/moduleFabs/formationModule/formation/formation_main", { 0 })
    elseif name == "Button_guidao4" then
        uSuperLink.openModule(241)
    end
end

--退出战斗场景
function BattleWin:quit(go)
    if self.callbackData.mdouleName == "commonChapter" or self.callbackData.mdouleName == "hardChapter" or self.callbackData.mdouleName == "heroChapter" then
        ClientTool.DestoryScene()
        if self.callbackData["chapter_sl"] == -1 then
            Messenger.Broadcast('BattleWinClose')--新手引导的监听
            UIMrg:popToModule("chapter1", { self.callbackData["chapter_zj"], -1, self.callbackData.mdouleName })
            return
        end
        local lastChapter =Player.Chapter.lastChapter
        local lasttSection = Player.Chapter.lastSection
        if self.callbackData.mdouleName == "hardChapter"  then
            lastChapter =Player.HardChapter.lastChapter
            lasttSection = Player.HardChapter.lastSection
        elseif self.callbackData.mdouleName == "heroChapter" then
            lastChapter =Player.NBChapter.lastChapter
            lasttSection = Player.NBChapter.lastSection
        end
        local chapterData = TableReader:TableRowByUniqueKey("chapter", self.callbackData["chapter_zj"], self.callbackData.mdouleName)
        if (self.callbackData["chapter_xj"] + 1) > chapterData.totelSection and lasttSection == 1 and self.callbackData["chapter_zj"] + 1 == lastChapter then
            UIMrg:popWindow()
            if chapterData.cha_type=="commonChapter" then 
                Tool.ChapterDraw(self.callbackData["chapter_zj"],chapterData.show_name,function ()
                    Messenger.Broadcast('BattleWinClose')--新手引导的监听
                    Tool.replace("chapter1", "Prefabs/moduleFabs/chapterModule/chapterModule_new", { self.callbackData["chapter_zj"] + 1, -1, self.callbackData.mdouleName })
               end)
            else 
                Messenger.Broadcast('BattleWinClose')--新手引导的监听
                Tool.replace("chapter1", "Prefabs/moduleFabs/chapterModule/chapterModule_new", { self.callbackData["chapter_zj"] + 1, -1, self.callbackData.mdouleName })
            end 
        elseif self.callbackData["chapter_zj"] == lastChapter and (self.callbackData["chapter_xj"] + 1) == lasttSection then
            Messenger.Broadcast('BattleWinClose')--新手引导的监听
            Tool.replace("chapter1", "Prefabs/moduleFabs/chapterModule/chapterModule_new", { self.callbackData["chapter_zj"], -1, self.callbackData.mdouleName })
        else
            Messenger.Broadcast('BattleWinClose')--新手引导的监听
            Tool.replace("chapter1", "Prefabs/moduleFabs/chapterModule/chapterModule_new", { self.callbackData["chapter_zj"], self.callbackData["chapter_xj"], self.callbackData.mdouleName })
        end

    elseif self.callbackData.mdouleName == "xuyegong" then
        --ClientTool.LoadLevel("main_scene", function()
            Messenger.Broadcast('BattleWinClose')--新手引导的监听
			ClientTool.DestoryScene()
            UIMrg:pop()
            UIMrg:popWindow()
        --end)
    elseif self.callbackData.mdouleName == "leagueChapter" then
			ClientTool.DestoryScene()
        -- ClientTool.LoadLevel("main_scene", function()
        --     UIMrg:pop()
        -- end)
        ClientTool.LoadLevel("gonghui_map", function()
            Messenger.Broadcast('BattleWinClose')--新手引导的监听
            UIMrg:pop()
            LuaMain:createGongHuiBuildName()
        end)
    elseif self.callbackData.mdouleName == "leagueFriendFight" then
        ClientTool.LoadLevel("gonghui_map", function()
            Messenger.Broadcast('BattleWinClose')--新手引导的监听
            UIMrg:pop()
            LuaMain:createGongHuiBuildName()
        end)
    elseif self.callbackData.mdouleName =="shilian" then 
        Messenger.Broadcast('BattleWinClose')--新手引导的监听
            Events.Brocast('updateShiLian')
            ClientTool.DestoryScene()
            UIMrg:pop()
                    --宝物碎片掠夺后翻卡
    elseif self.callbackData.mdouleName == "indiana" then
        Messenger.Broadcast('BattleWinClose')--新手引导的监听
        if self.callbackData.pieceId ~= nil then
            Api:turnCardReward(self.callbackData.pieceId,function (result)
                 UIMrg:pop()
                local drop = result.drop
                local  showDrop = result.showDrop
                UIMrg:pushWindow("Prefabs/moduleFabs/indiana/indiana_battle_result",{drop = drop,showDrop = showDrop})
            end)
        else
            print("pieceId is nil ")
        end
	elseif self.callbackData.mdouleName == "qiancengta_jingying" then
		ClientTool.DestoryScene()
		UIMrg:pop()
    elseif self.callbackData.mdouleName == "qiancengta" or self.callbackData.mdouleName == "arena" or self.callbackData.mdouleName == "bzsc_pet" then
        Messenger.Broadcast('BattleWinClose')--新手引导的监听
        ClientTool.DestoryScene()
        UIMrg:pop()
        local linkData = Tool.readSuperLinkById(self.callbackData.returnId)
        if linkData ~= nil then
            uSuperLink.openModule(self.callbackData.returnId)
        end
    else
        Messenger.Broadcast('BattleWinClose')--新手引导的监听
		ClientTool.DestoryScene()
        --ClientTool.LoadLevel("main_scene", function()
            UIMrg:pop()
        --end)
    end
end

function BattleWin:createTips(data)
    local widget = self.Grid.transform.parent.parent
    local font = self.txt_exp.bitmapFont
    if self.tips == nil then
        local go = NGUITools.AddChild(widget.gameObject)
        go.name = "tips"
        go.transform.localPosition = Vector3(300, 158, 0)
        self.tips = go:AddComponent(UILabel)
        self.tips.bitmapFont = font
        self.tips.applyGradient = false
        self.tips.fontSize = 25
        self.tips.color = Color.white
		self.tips.effectStyle = UILabel.Effect.Outline8
        self.tips.overflowMethod = UILabel.Overflow.ResizeFreely
        local desc = TextMap.GetValue("Text478") .. data.dmg .. TextMap.GetValue("Text479") .. data.gongxun
        self.tips.text = desc
    end
end

--打完战斗初始化调用
-- go是战斗数据
function BattleWin:update(go, callbackData, isNewBie, callNext)
    MusicManager.stopAllMusic()
    MusicManager.playByID(38)
    if isNewBie then
        self.star_num = 3;
        self.callNext = callNext
        self.isNewBie = isNewBie
        self.battle_win_new:DelayShow(0.5, function() self:playEffectCallBack() end, function() self:checkStar() end);
        return
    end

    ----------------------------------------------
    if go and go.drop ~= nil then
        go.drop.donate = go.drop.contribution
        if callbackData.mdouleName == "leagueChapter" then
            --go.drop.exp = go.drop.experience
            self.txt_exp.text = go.drop.experience
        end
    end

    if go.daxuName ~= nil and go.daxuName ~= "" then
        self.DAXU_NAME = go.daxuName
    end
    ----------------------------------------------

    self.callbackData = callbackData
    self.rewardList = RewardMrg.getList(go)
    self.txt_exp.text = 0;
    self.txt_gold.text = 0;
    self.index = 0;
    self._list = {}
    self.lv.text = TextMap.GetValue("Text_1_189")..Player.Info.level
    self:setExpProgress(Player.Info)
    table.foreach(self.rewardList, function(i, v)
        local tp = v:getType()
        local val = v.rwCount
        if tp == "money" then
            self.txt_gold.text = val;
        elseif tp == "exp" then
            if callbackData.mdouleName ~= "leagueChapter" then
                self.txt_exp.text = val;
            end
        else

            local txd = false
            table.foreach(self._list, function(kl, vl)
                if vl:getType()  == "char" then
                    if v.dictid == vl.dictid then
                        txd = true
                        if  vl.rwCount == nil or  vl.rwCount  < 1 then
                             vl.rwCount = 1
                        end
                        vl.rwCount = vl.rwCount + 1
                    end
                else
                    if v.id == vl.id then
                        txd = true
                        if  vl.rwCount == nil or  vl.rwCount  < 1 then
                             vl.rwCount = 1
                        end
                        vl.rwCount = vl.rwCount + 1
                    end

                end
            end) 
            if txd == false then
                table.insert(self._list,v)
            end
        end
    end)
    self.rewardList = self._list
    local that = self
    if self.callbackData.mdouleName == 'commonChapter' or callbackData.mdouleName == 'hardChapter'  or callbackData.mdouleName == 'heroChapter' then
        local ScoreDefineID  = TableReader:TableRowByUniqueKey(self.callbackData.mdouleName, self.callbackData["chapter_zj"], self.callbackData["chapter_xj"]).ScoreDefineID
        local win_star = TableReader:TableRowByID("win_star", ScoreDefineID)
        if go.fightChapter:ContainsKey("score") then
          
            if go.fightChapter.score[0] ~= nil and go.fightChapter.score[0] == 1 then
                self.txt_star_1.text = "[ffff00]"..win_star.desc1
            else
                self.txt_star_1.text = win_star.desc1
            end
             if go.fightChapter.score[1] ~= nil and go.fightChapter.score[1] == 1 then
                 self.txt_star_2.text ="[ffff00]"..win_star.desc2
            else
                 self.txt_star_2.text = win_star.desc2
            end
             if go.fightChapter.score[2] ~= nil and go.fightChapter.score[2] == 1 then
                self.txt_star_3.text = "[ffff00]"..win_star.desc3
            else
                self.txt_star_3.text = win_star.desc3
            end
        else
            self.txt_star_1.text = win_star.desc1
            self.txt_star_2.text = win_star.desc2
            self.txt_star_3.text = win_star.desc3
        end
        self.txt_jinjichang:SetActive(false)
		self.txt_taorenBoss:SetActive(false)
		self.go_taoren:SetActive(false)
        -- if go.daxuName ~= nil then
        --     Events.Brocast("FindDaXu")
        --     if Player.DaXu.daXuId ~= nil then
        --         print("DAxuID-------------->："..Player.DaXu.daXuId)
        --         local row = TableReader:TableRowByID("daxueMaster", Player.DaXu.daXuId)
        --         if row ~= nil then 
        --             local color = TableReader:TableRowByID("daxuColor", row.star)
        --             if color ~= nil then
        --                 go.daxuName = color.color ..go.daxuName .. "[-]"
        --             end
        --         end

        --     end
        --     DialogMrg.ShowFindDaxu(TextMap.getText("FindDaXu", { go.daxuName }), function()
        --         uSuperLink.openModule(69, 2)
        --     end)
        -- end
    elseif self.callbackData.mdouleName == 'arena' then
        self.txt_jinjichang:SetActive(true)
		self.txt_taorenBoss:SetActive(false)
		self.go_taoren:SetActive(false)
        self.txt_star_1.gameObject:SetActive(false)
        self.txt_star_2.gameObject:SetActive(false)
        self.txt_star_3.gameObject:SetActive(false)

        self.txt_jinji_1.text = TextMap.GetValue("Text_1_190")..go["enemy"].nickname.."[-]!"
        self.txt_jinji_va1.text = go["rank"]..""
        local val = go["rank"] - go["change_ret"]
        self.txt_jinji_va2.text = val .. ""
	elseif self.callbackData.mdouleName == 'taoren_boss' then
		self.txt_jinjichang:SetActive(false)
		self.go_taoren:SetActive(false)
        self.txt_star_1.gameObject:SetActive(false)
        self.txt_star_2.gameObject:SetActive(false)
        self.txt_star_3.gameObject:SetActive(false)
		if tonumber(self.callbackData.battle.id) ~= 1 then 
			self.txt_taorenBoss:SetActive(true)
			local tb = TableReader:TableRowByID("taorenBoss_dropadd", tonumber(self.callbackData.battle.id))
			local msg = string.gsub(TextMap.GetValue("LocalKey_680"),"{0}",self.callbackData.battle.desc)
            msg=string.gsub(msg,"{1}",((tb.dropadd+1000)/1000))
            self.txt_taoren_boss.text =msg
		end 
	elseif self.callbackData.mdouleName == "invadeChapter" then
	    self.txt_jinjichang:SetActive(false)
		self.txt_taorenBoss:SetActive(false)
		self.go_taoren:SetActive(true)
        self.txt_star_1.gameObject:SetActive(false)
        self.txt_star_2.gameObject:SetActive(false)
        self.txt_star_3.gameObject:SetActive(false)
        self.txt_taoren.text = TextMap.GetValue("Text_1_191")..self.callbackData.full .. TextMap.GetValue("Text_1_192")
    else
		self.go_taoren:SetActive(false)
		self.txt_taorenBoss:SetActive(false)
        self.txt_jinjichang:SetActive(false)
        self.txt_star_1.gameObject:SetActive(false)
        self.txt_star_2.gameObject:SetActive(false)
        self.txt_star_3.gameObject:SetActive(false)
    end
    if callbackData.mdouleName == "qiancengta" then
        BattleWin:qiancengta()
    end
    BattleWin:playEffect(go, callbackData, isNewBie, callNext)
    self.binding:Hide("btn_replay")
end

--设置经验进度
function BattleWin:setExpProgress(leader)
    local bag = Player.Resource
    local pre = 1
    local i = 0
    if leader.level > 1 then
        pre = TableReader:TableRowByUnique("charExp", "lv", leader.level - 1).exp[i]
    end
    local tb = TableReader:TableRowByUnique("charExp", "lv", leader.level)
    local exp_d = tb.exp_d[i]
    self.lvbar.value = (bag.exp - pre) / exp_d
end


--是否是千层塔
function BattleWin:qiancengta()
   
end

--播放胜利
function BattleWin:playEffect(go, callbackData, isNewBie, callNext)
    if go:ContainsKey("star") then
        self.star_num = go.star;
    else
        BattleWin:HideStars()
    end
    self:checkUpdate()
    self.battle_win_new:DelayShow(0.5, function() self:playEffectCallBack() end, function() self:checkStar() end);
end

--显示按钮和弹出奖励
function BattleWin:playEffectCallBack()
    Debug.Log("playEffectCallBack");
	self.itemsList = ClientTool.UpdateGrid("Prefabs/moduleFabs/chapterModule/ItemIcon", self.Grid, self._list)
	for i = 1, #self.itemsList do
        local comp = self.itemsList[i]
        comp:CallTargetFunction("play")
    end
end

--弹出多少星星
function BattleWin:checkStar()
    if self.star_num == 1 then
        self.battle_win_new:SetViews("no", false);
        self.battle_win_new:SetViews("1s", true)
        self.battle_win_new:SetViews("2s", false)
        self.battle_win_new:SetViews("3s", false)
    elseif self.star_num == 2 then
        self.battle_win_new:SetViews("no", false);
        self.battle_win_new:SetViews("2s", true);
        self.battle_win_new:SetViews("1s", false);
        self.battle_win_new:SetViews("3s", false);
    elseif self.star_num == 3 then
        self.battle_win_new:SetViews("no", false);
        self.battle_win_new:SetViews("1s", false);
        self.battle_win_new:SetViews("2s", false);
        self.battle_win_new:SetViews("3s", true);
    else
        self.battle_win_new:SetViews("no", true);
        self.battle_win_new:SetViews("1s", false);
        self.battle_win_new:SetViews("2s", false);
        self.battle_win_new:SetViews("3s", false);
    end
end

--不显示星星
function BattleWin:HideStars()
    self.stars1.gameObject:SetActive(false);
    self.stars2.gameObject:SetActive(false);
    self.stars3.gameObject:SetActive(false);
end

function BattleWin:showReplay(...)
    if self.callbackData.mdouleName == "encirclement" then
        if (Player.DaXu.share == nil or Player.DaXu.share == 0) and self.callbackData.pid == Player.playerId then
            DialogMrg.ShowFindDaxu(TextMap.GetValue("Text139"), function()
                Api:share(function(result)
                    MessageMrg.show(TextMap.GetValue("Text480"))
                end)
            end)
        end
    end
end

function BattleWin:checkUpdate()
    local that = self
    self.canClickBtn = false
    self.binding:CallAfterTime(1, function()
        self.canClickBtn = true
    end)

   
    if self.callbackData.mdouleName == "encirclement" then
        --围剿大虚
        BattleWin:createTips(self.callbackData)
    end


    Api:checkUpdate(function(res)
        that.needLevelup = true
        --that.binding:CallAfterTime(0.1, function()
        --    BattleWin:showReplay()
        --end)
        --if DAXU_NAME then
        --    DialogMrg.ShowFindDaxu(TextMap.getText("FindDaXu", { DAXU_NAME }), function()
        --        uSuperLink.openModule(69, 2)
        --    end)
        --    DAXU_NAME = nil
        --end

        if self.DAXU_NAME ~= nil and self.DAXU_NAME ~= "" then
            Events.Brocast("FindDaXu")
            if Player.DaXu.daXuId ~= nil then
                local row = TableReader:TableRowByID("daxueMaster", Player.DaXu.daXuId)
                if row ~= nil then 
                    local color = TableReader:TableRowByID("daxuColor", row.star)
                    if color ~= nil then
                        self.DAXU_NAME = color.color ..self.DAXU_NAME .. "[-]"
                    end
                end

            end
            DialogMrg.ShowFindDaxu(string.gsub(TextMap.GetValue("Text119"),"{0}",self.DAXU_NAME), function()
                uSuperLink.openModule(69, 2)
            end)
        end
        Tool.LastChapter = lastChapter
    end, function(ret)
        if ret == -200 then
            LuaMain:Slogout()
            return true
        end
        if self.callbackData.mdouleName ~= "leagueChapter" then
            DialogMrg.ShowDialog(TextMap.GetValue("Text481"), function(...)
                BattleWin:checkUpdate()
            end, function(...)
            end)
        else
        end
        return true
    end)
    self.binding:CallAfterTime(0.5, function()
        BattleWin:showReplay()
    end)
end

function BattleWin:Start()
    GameManager.showFrame(self.gameObject)
	UIEventListener.Get(self.black).onClick = function(go)
        if self.canClickBtn ~= nil and self.canClickBtn then
            self:quit(nil)
        end
	end
end

return BattleWin