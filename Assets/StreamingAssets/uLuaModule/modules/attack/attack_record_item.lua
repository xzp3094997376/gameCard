--比武记录
local m = {}

function m:update(data,index,delegate)
    self.player1 = data.player1
    self.player2 = data.player2
    self.player1Win = data.player1Win
    self.player2Win = data.player2Win
    self.group = tonumber(data.group)
    self.topNum = tonumber(data.topNum)
    self.version = data.version
    if self.player1~=nil and self.player2 ~= nil then
        self.img_1:setImage(self.player1.head, "headImage")
        self.img_2:setImage(self.player2.head, "headImage")
        self.txt_lv_1.text = self.player1.level or 0
        self.txt_lv_2.text = self.player2.level or 0
        self.txt_name_1.text = self.player1.name
        self.txt_name_2.text = self.player2.name
    end
    self.txt_count.text = self.player1Win..":"..self.player2Win
    self.count = self.player1Win + self.player2Win

    local title = ""
    if self.topNum == 2 then      --总决赛
        title = TextMap.GetValue("Text1708")
    elseif self.topNum == 3 then  --三四名决赛
        title = TextMap.GetValue("Text1709")
    elseif self.topNum == 4 then
        if self.group <= 1 then
            title = TextMap.GetValue("Text1710")
        else
            title = TextMap.GetValue("Text1711")
        end
    else
        if self.topNum/4 >= self.group then --上半区
            title = TextMap.GetValue("Text1693")..(self.topNum/2)..TextMap.GetValue("Text1694")..self.temp[self.group]
        else                                                  --下半区
            title = TextMap.GetValue("Text1696")..(self.topNum/2)..TextMap.GetValue("Text1694")..self.temp[self.group-self.topNum/4]
        end
    end
    self.txt_record_name.text = title

    for i = 1,3 do
        if i <= self.count then
            self["btn_"..i].isEnabled = true
        else
            self["btn_"..i].isEnabled = false
        end 
    end
end

--查看某场记录
function m:getOneRecord(index)
    if index == nil then return end
    Api:getOneRecord(self.player1.pid,self.player2.pid,index,self.version,function (result)
       local fightData = {}
        fightData["battle"] = result
        fightData["mdouleName"] = "attack"
        UIMrg:pushObject(GameObject())
        UluaModuleFuncs.Instance.uOtherFuns:callBackFight(fightData)
        fightData = nil
    end)
end

function m:onClick(go, name)
    if name == "btn_1" then
        if self.count >= 1 then
            self:getOneRecord(1)
        end
    elseif name == "btn_2" then
        if self.count >= 2 then
            self:getOneRecord(2)
        end
    elseif name == "btn_3" then
        if self.count >= 3 then
            self:getOneRecord(3)
        end
    elseif name == "btn_role_1" then
        self:showTeam(1)
    elseif name == "btn_role_2" then
        self:showTeam(2)
    end
end

--显示玩家阵容
function m:showTeam(index)
    if index == nil then return end
    local data = self["player"..index]
    local  that = self
    Api:getInfo(data.pid,data.sid.."",
        function(result)
            local tp = 2
            local temp = {}
            temp.data = result.showRet.defenceTeam
            temp.show = 1
            local datas = {}
            datas["info"] = data
            datas["info"].level = result.showRet.level
            datas["info"].power = result.showRet.power
            datas["info"].vip = result.showRet.vip
            datas["info"].rank = data.rank
            datas["info"].nickname = result.showRet.nickname
            datas.rank = data.rank
            temp.peopleVO = datas
            temp.pid = result.showRet.pid
            temp.tp = tp
            temp.sid = self:getSid(data.sid) 
            temp.rank = data.rank
            datas = nil
            UIMrg:pushWindow("Prefabs/moduleFabs/arenaModule/arena_enemy_info", temp)
            temp = nil
            result = nil
    end)
end

--获取sid
function m:getSid(sid)
    if sid == nil then return end
    local showId = nil
    if sid <=10 then
        showId = "u"..sid
    elseif sid > 400 then
        showId = "f"..(sid-400)
    else
        showId = "s"..(sid-10)
    end
    return showId
end

--初始化
function m:create(binding)
    self.binding = binding
    return self
end

function m:Start()
    self.temp = {"A","B","C","D","E","F","G","H"}
end

return m