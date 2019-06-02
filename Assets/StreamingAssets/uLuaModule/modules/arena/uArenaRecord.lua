local arenaRecord = {}
local peopleData = {}
local pidArr = {}
local isReturnInfos = false

function arenaRecord:destory()
    pidArr = nil
    isReturnInfos = false
    peopleData = nil
    UIMrg:popWindow()
end

--[[function arenaRecord:update(tableData)
    for i = 1, 10 do
        if Player.VSBattle.record:existsKey('' .. (i - 1)) then
            local people = {}
            people.index = i
            people.rank_num = Player.VSBattle.record[i - 1].rank_num
            people.enemyId = Player.VSBattle.record[i - 1].enemyId
            people.win = Player.VSBattle.record[i - 1].win
            people.vsId = Player.VSBattle.record[i - 1].vsId
            people.timechok = Player.VSBattle.record[i - 1].timechok
            peopleData[i] = people
            pidArr[i] = Player.VSBattle.record[i - 1].enemyId
            people = nil
        end
    end

    Api:showDetailInfoArr(pidArr,
        function(result)
            local count = result.showRet.Count
            if count > 0 then
                for i = 1, count do
                    peopleData[i].Info = result.showRet[i - 1]
                end
            end
            table.sort(peopleData, function(a, b)
                return a.timechok > b.timechok
            end)

            for i = 1, 10 do
                if peopleData[i] ~= nil then
                    local binding = ClientTool.loadAndGetLuaBinding("Prefabs/moduleFabs/arenaModule/fight_recordCell", self.Content.gameObject)
                    binding.gameObject.name = i
                    binding:CallUpdate(peopleData[i])
                    binding = nil
                    self.Content.repositionNow = true
                end
            end
        end)
end]]

function arenaRecord:onClick(go, name)
    if name == "btn_close" then
        self:destory()
    end
end


function arenaRecord:getVSList(result)
    local list = result.list
    if list.Count == 0 then
        self.un_record:SetActive(true)
        return
    end
    self.un_record:SetActive(false)
    --[{"enemy":{"pid":"BjkOR","nickname":"高槻弥生","head":"banmuyijiao","level":12,"vip":0},"t":1425266704063,"win":true,"rank_num":130}
    for i = 0, list.Count - 1 do
        local item = list[i]
        local people = {}
        people.index = i + 1
        people.rank_num = item.rank_num
        people.enemyId = item.enemy.pid
        people.win = item.win
        people.vsId = i
        people.timechok = item.t
        people.Info = item.enemy
        people.type = self.type
        peopleData[i + 1] = people
        people = nil
    end
    table.sort(peopleData, function(a, b)
        return a.timechok > b.timechok
    end)
    self.view:refresh(peopleData, self, true, 0)
end

function arenaRecord:update(data)
    if data ~= nil then
        self.type = data.type
        Api:getVSList(self.type,funcs.handler(self, self.getVSList))
    end
end

function arenaRecord:Start(...)
    ClientTool.AddClick(self.bg, function()
        UIMrg:popWindow()
    end)
    self.un_record:SetActive(false)
end

return arenaRecord