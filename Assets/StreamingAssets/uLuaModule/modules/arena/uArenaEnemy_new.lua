local m = {}
local _firstLoad = true
function m:update(player)
    self.peopleVO = player.data
    self.tables = player.delegate
    m:setData()
end

local function getChar(list)
    if list == nil or list.Count == 0 then
        list = Player.Team[0].chars
    end
    for i = 0, list.Count - 1 do
        if list[i] ~= "" and list[i] ~= "0" and list[i] ~= 0 then
            return list[i]
        end
    end
    return 1
end

function m:setData()
    self.txt_lv_name.text = Char:getItemColorName(self.peopleVO["info"].quality , self.peopleVO["info"].nickname)
    self.txt_power.text = toolFun.moneyNumber(math.ceil(self.peopleVO["info"].power))
    local vip = self.peopleVO["info"].vip
    self.txt_vip.text = "VIP " .. vip
	self.txt_lv.text = "[00ff00]Lv" .. self.peopleVO["info"].level .. "[-] "

    if self.frist then
        self.frist = false
        self.binding:fadeIn(self.binding.gameObject, 0.2)
    end
    if self.peopleVO["info"].yulingid~=nil and self.peopleVO["info"].yulingid~=0 and 
        self.peopleVO["info"].yulingid~="0" and self.peopleVO["info"].yulingid~="" then
        local yulingM = Yuling:new(self.peopleVO["info"].yulingid)
        if yulingM.modelid~=nil then 
            self.yuling.gameObject:SetActive(true)
            self.yuling:LoadByModelId(yulingM.modelid, "idle", function() end, false, 100, 1)
        end 
    end 
	self.hero:LoadByModelId(self.peopleVO["info"].modelid, "idle", function() end, false, -1, 1)
end

function m:fightIng(arr)
    if arr == nil then
        DialogMrg.ShowDialog(TextMap.GetValue("Text83"))
        return
    end
    Api:challengePlayer(arr, self.peopleVO.pid, 5,
        function(result)
            local fightData = {}
            fightData["battle"] = result.change_rank
            fightData["drop"] = result.drop
            fightData["mdouleName"] = "arena"
            fightData["id"] = 5
            UIMrg:pushObject(GameObject())
            UluaModuleFuncs.Instance.uOtherFuns:callBackFight(fightData)
            fightData = nil
        end)
end

function m:refershVStime()
    Events.Brocast('vstime_refrash')
end

function m:onClick(go, name)
    if name == "btn_challenge" then
        local temp = Player.VSBattle.has_fight or 0
        if (Player.VSBattle.max_fight - temp) <= 0 then
            DialogMrg:BuyBpAOrSoul("tzq", "", funcs.handler(self, self.refershVStime),funcs.handler(self, self.refershVStime))
            return
        end
        m:fightIng(LuaMain:getTeamByIndex(0))
    end
end

function m:Start()
    self.frist = true
    ClientTool.AddClick(self.hero.gameObject, function()
        Api:showDetailInfo(self.peopleVO.pid,self.peopleVO.sid,self.peopleVO.rank,
            function(result)
                local temp = {}
                temp.data = result.showRet[0].defenceTeam
                temp.show = nil
                local data = self.peopleVO
                if data.info.can_fight == 0 then
                    temp.show = 1
                end
                local datas = {}
                datas["info"] = data.info
                datas.rank = data.rank
                temp.peopleVO = datas
                temp.pid = self.peopleVO.pid
                temp.sid = self.peopleVO["info"].sid
                temp.tp = self.peopleVO.type
                datas = nil
                UIMrg:pushWindow("Prefabs/moduleFabs/arenaModule/arena_enemy_info", temp)
                temp = nil
                result = nil
            end)
    end)
    self.binding:fadeOut(self.binding.gameObject, 0)
end

return m