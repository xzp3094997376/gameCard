local m = {}
local _firstLoad = true
function m:update(player)
    self.peopleVO = player.data
    self.pid = player.pid
    self.sid = player.sid
    self.now_rank = player.now_rank
    self.tables = player.delegate
    m:setData()
end

local function getChar(list)
    for i = 0, list.Count - 1 do
        if list[i] ~= "" and list[i] ~= "null" and list[i] ~= 0 and list[i] ~= nil then
            return list[i].id
        end
    end
    return 1
end

function m:setData()
    self.txt_rank.text = self.now_rank
    local info = self.peopleVO
    self.txt_lv_name.text = "[00ff00]Lv" .. info.level .. "[-] " .. info.nickname
    self.txt_power.text = math.ceil(info.power)
    local vip = info.vip
    self.txt_vip.text = "" .. vip

    if self.frist then
        self.frist = false
        self.binding:fadeIn(self.binding.gameObject, 0.2)
    end

    local defenceTeam = self.peopleVO["defenceTeam"]
    local model = getChar(defenceTeam)
    local hero = self.hero
    self.hero:LoadByCharId(model, "stand", function(ctl)
        if _firstLoad == true then
            local go = ClientTool.load("Effect/Prefab/xuanRenDiZuo")
            hero:showBottom(go)
            go.transform.localPosition = Vector3(0, 0, 0)
            local s = go.transform.localScale
            go.transform.localScale = Vector3(s.x * 1.2, s.y * 1.2, s.z * 1.2)
            _firstLoad = false
        end
    end, false, 0)
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
        local temp = {}
        temp.data = self.peopleVO["defenceTeam"]
        temp.show = false
        local datas = {}
        datas["info"] = self.peopleVO
        datas.rank = self.now_rank
        temp.peopleVO = datas
        temp.pid = self.pid
        temp.sid = self.sid
        temp.tp = self.tables.type
        datas = nil
        UIMrg:pushWindow("Prefabs/moduleFabs/arenaModule/arena_enemy_info", temp)
        temp = nil
    end)
    self.binding:fadeOut(self.binding.gameObject, 0)
end

return m