local arenaHangCell = {}
local pid = Player.playerId

function arenaHangCell:update(tableData, index, delegate)
    self.isClick = false
    self.data = tableData
    local info = tableData.info
    self.tp = tableData.tp
    self.player_info = Player.VSBattle
    self.myRank = Player.VSBattle.now_rank
    if self.tp == "crossArena" then
        self.player_info = Player.crossArena
    end
    self.callSelf = delegate
    --    self.arena_hangCell.name = tableData.rank
    self.txt_name.text = Char:getItemColorName(info.quality, info.nickname)
    self.txt_power.text = toolFun.moneyNumberShowOne(math.floor(tonumber(info.power)))
    self.txt_vip.text = info.vip
    self.sid = info.sid
    if self.sid ~= nil then
        self.txt_qu.text =string.gsub(TextMap.GetValue("LocalKey_684"),"{0}",self.sid)
    else
        self.txt_qu.text = ""
    end
    self.now_rank = info.rank
    self.btn_easyFight.gameObject:SetActive(false)

    if pid == tableData.pid then
        local char = Char:new(Player.Info.playercharid)
        char.star = char.star
        if self.__itemAll == nil then
            self.__itemAll = ClientTool.loadAndGetLuaBindingFromPool("Prefabs/publicPrefabs/itemAll", self.simpleImage.gameObject)
        end
        self.__itemAll:CallUpdate({ "char", char, self.simpleImage.width, self.simpleImage.height, nil, nil, true })
        self.txt_name.text = char:getItemColorName(char.star, info.nickname)
        self.__me = true
        self.me:SetActive(true)
		if self.tp == "crossArena" then 
			self.Label_tip:SetActive(false)
		else 
			self.Label_tip:SetActive(true)
		end 
		self.rank_bg.spriteName = "paimingdi_1"
        self.rank.text =TextMap.GetValue("Text101")
        self.btn_fight.gameObject:SetActive(false)
    else
        self:setHead(info.playerid, info.quality)
        self.__me = false
        self.me:SetActive(false)
        self.Label_tip:SetActive(false)
		self.rank_bg.spriteName = "paimingdi_2"
        self.rank.text =TextMap.GetValue("Text101")
        self.btn_fight.gameObject:SetActive(info.can_fight == 1)
    end
	
	if tableData.rank < 11 then
        self.binding:Show("rank_icon")
        self.rank_icon.spriteName = "paimingdi_3" --"rank" .. tableData.rank
        self.txt_hang.text = tableData.rank
		--self.rank_bg.spriteName = "paimingdi_3"
    else
        self.txt_hang.text = tableData.rank
        self.binding:Hide("rank_icon")
    end

    local easyTblNeedLv = TableReader:TableRowByID("vsArgs", "bianjie_vs_limitlv").arg
    local easyTblNeedVip = TableReader:TableRowByID("vsArgs", "bianjie_vs_vip").arg
    if Player.Info.level >= easyTblNeedLv or Player.Info.vip >= easyTblNeedVip then
        if tonumber(tableData.rank) > tonumber(self.myRank) then
			 if self.tp ~= "crossArena" then 
				self.btn_easyFight.gameObject:SetActive(true)
			 else 
				self.btn_easyFight.gameObject:SetActive(false)
			 end 
        end
    end
end

function arenaHangCell:setHead(dictid, star)
	local char = Char:new(nil, dictid)
	char.star = star
    if self.__itemAll == nil then
        self.__itemAll = ClientTool.loadAndGetLuaBindingFromPool("Prefabs/publicPrefabs/itemAll", self.simpleImage.gameObject)
    end
    self.__itemAll:CallUpdate({ "char", char, self.simpleImage.width, self.simpleImage.height, nil, nil, true })
end 

function arenaHangCell:refershVStime()
    Events.Brocast('vstime_refrash')
end

function arenaHangCell:fightIng()
    local times = self.player_info.max_fight - self.player_info.has_fight
    if times <= 0 then
        if self.tp == "crossArena" then
			MessageMrg.showMove(TextMap.GetValue("Text_1_164"))
            --DialogMrg:BuyBpAOrSoul("kftzq", "", toolFun.handler(self, self.refershVStime))
            return
        else
			MessageMrg.showMove(TextMap.GetValue("Text_1_164"))
            --DialogMrg:BuyBpAOrSoul("tzq", "", funcs.handler(self, self.refershVStime))
            return
        end
    end
	
	-- 检查精力
	if Player.Resource.vp < 2 then 
        local cb = function()
            LuaMain:refreshTopMenu()
        end
		DialogMrg:BuyBpAOrSoul("vp", "", cb,cb)
		return 
	end 

    --阵型
    local arr = LuaMain:getTeamByIndex(0)
    if arr == nil then
        DialogMrg.ShowDialog(TextMap.GetValue("Text83"))
        return
    end

    TableReader:ForEachLuaTable("zhengzhanConfig", function(index, item)
        if item.name == TextMap.GetValue("Text_1_166") then
            self.returnId = item.droptype[0]
        end
        return false
    end)

    local sid = self.sid or 0
    local rank = self.now_rank or 0
    --挑战竞技场对手
    if not GuideMrg:isPlaying() then
        --不是新手引导时的挑战
        Api:challengePlayer(arr, self.data.pid, 5,sid,rank,
            function(result)
                local fightData = {}
                fightData["battle"] = result.change_rank
                Events.Brocast("vsfight_callback", result.change_rank.win)
                fightData["drop"] = result.drop
                fightData["mdouleName"] = "arena"
                fightData["id"] = 5
                fightData["returnId"] = self.returnId 
                Events.Brocast("ToRoot")
                UIMrg:pushObject(GameObject())
                UluaModuleFuncs.Instance.uOtherFuns:callBackFight(fightData)
                fightData = nil
                self.isClick = false
            end)
    else 
        --触发引导时的挑战，guideid为表monsterteam的id,表示实际和这个怪物组战斗
        local guideid = TableReader:TableRowByID("vsArgs","newbie_teamid").value
        guideid=tonumber(guideid)
        Api:challengePlayer_guide(arr, self.data.pid, 5,sid,rank,guideid,
            function(result)
                local fightData = {}
                fightData["battle"] = result.change_rank
                Events.Brocast("vsfight_callback", result.change_rank.win)
                fightData["drop"] = result.drop
                fightData["mdouleName"] = "arena"
                fightData["id"] = 5
                fightData["returnId"] = self.returnId 
                Events.Brocast("ToRoot")
                UIMrg:pushObject(GameObject())
                UluaModuleFuncs.Instance.uOtherFuns:callBackFight(fightData)
                fightData = nil
            end)
    end 
end

function arenaHangCell:onClick(go, name)
    if name == "arenaBtn" then
        if self.__me then return end
        Api:showDetailInfo(self.data.pid, self.sid, self.now_rank,
            function(result)
				if result.showRet == nil then return end 
				
                local tp = self.callSelf.type
                local temp = {}
                temp.data = result.showRet[0].defenceTeam
                temp.show = nil
                if self.data.info.can_fight == 0 then
                    temp.show = 1
                end
                local datas = {}
                self.data.nickname = self.data.info.nickname
                datas["info"] = self.data.info
                datas.rank = self.data.rank
                temp.peopleVO = datas
                temp.pid = self.data.pid
                temp.tp = tp
                temp.sid = self.sid
                temp.rank = self.now_rank
				temp.playercharid = result.showRet[0].playerid
                datas = nil
                UIMrg:pushWindow("Prefabs/moduleFabs/arenaModule/arena_enemy_info", temp)
                temp = nil
                result = nil
            end)
    elseif name == "btn_fight" then
        if self.isClick then return end
        self.isClick = true
        arenaHangCell:fightIng()
        self.binding:CallAfterTime(1.5, function()
            self.isClick = false
            end)
    elseif name == "btn_easyFight" then
        local infoList = {}

        local arr = LuaMain:getTeamByIndex(0)
        if arr == nil then
            DialogMrg.ShowDialog(TextMap.GetValue("Text83"))
            return
        end

        local sid = self.sid or 0
        local rank = self.now_rank or 0

        infoList.arr = arr
        infoList.pid = self.data.pid
        infoList.teamId = 5
        infoList.sid = sid
        infoList.rank = rank

        UIMrg:pushWindow("Prefabs/moduleFabs/arenaModule/ArenaEasyFight", infoList)
    end
end

--初始化
function arenaHangCell:create(binding)
    self.binding = binding
    return self
end

return arenaHangCell