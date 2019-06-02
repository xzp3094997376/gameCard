-- 比武结果界面
local m = {}

function m:Start(...)
    self.period = {}
    LuaMain:ShowTopMenu()
    local that = self
    Api:getHistoryTop3(function (result)
        local list = result.rankList
        that.period = result.period
        that:initData(list)
    end)
end

function m:update(data)
end

--初始化数据
function m:initData(data)
    if data == nil then return end
    self.list = {}
    for i=0,data.Count-1 do
        local temp = {}
        for j=0,data[i].Count-1 do
            local v = data[i][j]
            local player = {}
            player.name = v.name
            player.sid = self:getSid(tonumber(v.sid)) 
            table.insert(temp,player)
        end
        temp.index = self.period[i]
        table.insert(self.list,temp)
    end
    self.final_player = data[0][0]
    if self.final_player ~= nil then
        local defenceTeam = json.decode(self.final_player.defenceTeam:toString())
        local charId = self:getChar(defenceTeam)
        if charId ~= nil then 
            self.hero:LoadByCharId(charId, "stand", function(ctl) end)
        end
        self.txt_vip.text = self.final_player.vip
        self.txt_lv_name.text = self.final_player.name.." [00ff00]["..self:getSid(self.final_player.sid).."][-]"
    end
    self.txt_count.text = self.period[0] or 1
    self.scrollview:refresh(self.list, self, true)
end

--获取玩家模型id
function m:getChar(list)
    for k,v in pairs(list) do
        if v ~= "" and v ~= "null" and v ~= 0 and v ~= nil then
            return v
        end
    end
    return 1
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

function m:onClick(go, name)
    if name == "btn_video" then
        UIMrg:pushWindow("Prefabs/moduleFabs/attack/attack_record")
    elseif name == "btn_progress" then
        Tool.push("attack_progress_last", "Prefabs/moduleFabs/attack/attack_progress_last",{})
    elseif name == "btn_guess" then
        Tool.push("attack_guess", "Prefabs/moduleFabs/attack/attack_guess",{})
    elseif name == "btn_shop" then
        LuaMain:showShop(31)
    end
end

return m