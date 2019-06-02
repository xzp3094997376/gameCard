local BattleLose = {}
local chapterFightPanel = require("uLuaModule/modules/chapter/uChapterFight.lua")
local leagueFightPanel = require("uLuaModule/modules/league/uLeague_Fight.lua")

function BattleLose:Start()
    GameManager.showFrame(self.gameObject)
		UIEventListener.Get(self.black).onClick = function(go)
		self:quit(nil)
	end
end

function BattleLose:onClick(go, name)
    if name == "btn_playback" then
        if self.callbackData then
            self.callbackData["is_replay"] = true
        end
        ClientTool.LoadLevel(UluaModuleFuncs.Instance.uOtherFuns.m_SceneName, function()
        end)
    elseif name == "Button_peiyang" then
        --Tool.push("hero_select_char", "Prefabs/moduleFabs/hero/hero_select_char")
        --uSuperLink.openModule(73)
        Tool.push("hero_select_char", "Prefabs/moduleFabs/hero/hero_select_char")
    elseif name == "Button_zhaohuan" then
        uSuperLink.openModule(1)
    elseif name == "Button_zhenrong" then
        Tool.push("team", "Prefabs/moduleFabs/formationModule/formation/formation_main", { 0 })
    elseif name == "Button_guidao" then
        uSuperLink.openModule(241)
    elseif name == "Button_shengji" then
        uSuperLink.openModule(14)
    elseif name == "Button_xilian" then
        uSuperLink.openModule(229)
    elseif name == "Button_Close" then
        self:quit(go)
    end
end

--退出主场景
function BattleLose:quit(go)
    if self.callbackData.mdouleName == "commonChapter" or self.callbackData.mdouleName == "hardChapter" or self.callbackData.mdouleName == "heroChapter" then
		ClientTool.DestoryScene()
        if self.callbackData["chapter_sl"] == -1 then
            UIMrg:popToModule("chapter1", { self.callbackData["chapter_zj"], -1, self.callbackData.mdouleName})
            return
        end
        UIMrg:pop()
        UIMrg:popWindow()
        Tool.push("chapter1", "Prefabs/moduleFabs/chapterModule/chapterModule_new", { self.callbackData["chapter_zj"], -1, self.callbackData.mdouleName })
    elseif self.callbackData.mdouleName == "leagueChapter" then
        ClientTool.LoadLevel("gonghui_map", function()
            UIMrg:pop()
            LuaMain:createGongHuiBuildName()
        end)
    elseif self.callbackData.mdouleName == "leagueFriendFight" then
        ClientTool.LoadLevel("gonghui_map", function()
            UIMrg:pop()
            LuaMain:createGongHuiBuildName()
        end)
    elseif self.callbackData.mdouleName == "qiancengta" or self.callbackData.mdouleName == "arena" or self.callbackData.mdouleName == "bzsc_pet" then
        Messenger.Broadcast('BattleWinClose')--新手引导的监听
        ClientTool.DestoryScene()
        UIMrg:pop()
        local linkData = Tool.readSuperLinkById(self.callbackData.returnId)
        if linkData ~= nil then
            uSuperLink.openModule(self.callbackData.returnId)
        end
    else
		ClientTool.DestoryScene()
        UIMrg:pop()
        Messenger.Broadcast("BattleWinClose")--战斗结束的监听
    end
end

function BattleLose:update(go, callbackData)
    MusicManager.stopAllMusic()
    MusicManager.playByID(39)
    self.callbackData = callbackData
    self.id = callbackData.id
   
    print("self.callbackData.mdouleName"..self.callbackData.mdouleName)
    if self.callbackData.mdouleName == 'arena' then
        self.btns.transform.localPosition = Vector3(-74, 109, 0)
        self.items.transform.localPosition = Vector3(0, 102, 0)
        self.jinji:SetActive(true)
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
                table.insert(self._list, v)
            end
        end)
        self.rewardList = self._list
        self:playEffectCallBack()
    else
        self.btns.transform.localPosition = Vector3(-74, -53, 0)
        self.items.transform.localPosition = Vector3(0, -20, 0)
    end
    Api:checkUpdate(function(res)
      
    end)
end
--设置经验进度
function BattleLose:setExpProgress(leader)
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
function BattleLose:playEffectCallBack()
    Debug.Log("playEffectCallBack");
    self.itemsList = ClientTool.UpdateGrid("Prefabs/moduleFabs/chapterModule/ItemIcon", self.Grid, self._list)
    for i = 1, #self.itemsList do
        local comp = self.itemsList[i]
        comp:CallTargetFunction("play")
    end
end

return BattleLose