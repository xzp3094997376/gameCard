-- 比武进程总界面
local m = {}

function m:Start(...)
    LuaMain:ShowTopMenu()
    local that = self
    Api:getFinalFlow(function (result)
        local data = json.decode(result:toString())
        local top_4 = data.top_4
        that:initData(top_4)
        that.period = data.period
        that.txt_count.text = data.period
    end)
end

function m:update(data)
    if data == nil then return end
    if data.delegate ~= nil then
        self.delegate = data.delegate
    else
        print("111111111aaa")
    end
end

--初始化数据
function m:initData(data)
    if data == nil then 
        self.txt_name_1.text = TextMap.GetValue("Text_1_188")
        self.txt_name_2.text = TextMap.GetValue("Text_1_188")
        self.txt_name_3.text = TextMap.GetValue("Text_1_188")
        self.txt_name_4.text = TextMap.GetValue("Text_1_188")
        return 
    end
    self.player_list = {}
    for k,v in pairs(data) do
        local temp = {}
        temp.player1 = v[1]
        temp.player2 = v[2]
        temp.result = v[3]
        table.insert(self.player_list,temp)
    end
    if self.player_list[1] ~= nil then
        local sid_1 = " [00ff00]["..self:getSid(self.player_list[1].player1.sid).."][-]"
        local sid_2 = " [00ff00]["..self:getSid(self.player_list[1].player2.sid).."][-]"
        local title_1 = self.player_list[1].player1.name..sid_1
        local title_2 = self.player_list[1].player2.name..sid_2

        local result = self.player_list[1].result
        if result == 1 then
            for i=1,3 do
                self["line_1_"..i].gameObject:SetActive(true)
                self["line_1_"..i].spriteName = "KFBW-JC-xian-liang"
            end
            for i=1,2 do
                self["line_2_"..i].gameObject:SetActive(true)
                self["line_2_"..i].spriteName = "KFBW-JC-xian01"
            end
            self["line_2_3"].gameObject:SetActive(false)
            title_2 = "[ffffff7d]"..title_2.."[-]"
        elseif result == 2 then 
            for i=1,2 do
                self["line_1_"..i].gameObject:SetActive(true)
                self["line_1_"..i].spriteName = "KFBW-JC-xian01"
            end
            self["line_1_3"].gameObject:SetActive(false)
            for i=1,3 do
                self["line_2_"..i].gameObject:SetActive(true)
                self["line_2_"..i].spriteName = "KFBW-JC-xian-liang"
            end
            title_1 = "[ffffff7d]"..title_1.."[-]"
        end
        self.txt_name_1.text = title_1
        self.txt_name_2.text = title_2
    else
        self.txt_name_1.text = TextMap.GetValue("Text_1_188")
        self.txt_name_2.text = TextMap.GetValue("Text_1_188")
    end
    if self.player_list[2] ~= nil then
        local sid_1 = " [00ff00]["..self:getSid(self.player_list[2].player1.sid).."][-]"
        local sid_2 = " [00ff00]["..self:getSid(self.player_list[2].player2.sid).."][-]"
        local title_1 =  self.player_list[2].player1.name..sid_1
        local title_2 =  self.player_list[2].player2.name..sid_2
        local result = self.player_list[2].result
        if result == 1 then 
            self.line_3_1.spriteName = "KFBW-JC-xian-liang"
            self.line_4_1.spriteName = "KFBW-JC-xian01"
            title_2 = "[ffffff7d]"..title_2.."[-]"
        elseif result == 2 then
            self.line_3_1.spriteName = "KFBW-JC-xian01"
            self.line_4_1.spriteName = "KFBW-JC-xian-liang"
            title_1 = "[ffffff7d]"..title_1.."[-]"
        end
        self.txt_name_3.text = title_1
        self.txt_name_4.text = title_2
    else
        self.txt_name_3.text = TextMap.GetValue("Text_1_188")
        self.txt_name_4.text = TextMap.GetValue("Text_1_188")
    end
end

function m:getRewardList(data)
    if data == nil then return end
    local tb = {}
    table.foreach(data,function (k,v)
            local list = {}
            list.rank = k
            list.li = v
            local temp = {}
            k = k.."-"
            for a in string.gmatch(k, "(%d*)-") do
                table.insert(temp, a)
            end
            list.index = tonumber(temp[#temp])
            table.insert(tb,list)
    end)
    table.sort(tb,function (a,b)
            return a.index < b.index
    end)
    return tb
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
    if name == "btn_left" then
        local that = self
        Api:getContestFlow("up",function (result)
            local data = json.decode(result:toString())
            local temp = {}
            temp.top32 = data.top32
            temp.topOther = data.topOther
            temp.halfWiner = data.halfWiner
            temp.delegate = that.delegate
            temp.type = "up"
            Tool.push("attack_progress", "Prefabs/moduleFabs/attack/attack_progress",temp)
        end)
    elseif name == "btn_right" then
        local that = self
        Api:getContestFlow("down",function (result)
            local data = json.decode(result:toString())
            local temp = {}
            temp.top32 = data.top32
            temp.topOther = data.topOther
            temp.halfWiner = data.halfWiner
            temp.delegate = that.delegate
            temp.type = "down"
            Tool.push("attack_progress", "Prefabs/moduleFabs/attack/attack_progress",temp)
        end)
    elseif name == "btn_rule" then
        UIMrg:pushWindow("Prefabs/moduleFabs/qiancengta/qiancengta_rule", {15,title = TextMap.GetValue("Text1780")})
    elseif name == "btn_reward" then
        Api:getRewardShow(function (result)
            local data = json.decode(result:toString())
            local list = data.showReward
            list = self:getRewardList(list)
            UIMrg:pushWindow("Prefabs/moduleFabs/activityModule/act_rank_reward_info", list)
        end)
        -- UIMrg:pushWindow("Prefabs/moduleFabs/activityModule/act_rank_reward_info", self.rewardList)
    elseif name == "btn_final" then --总决赛
        if self.player_list == nil or self.player_list[2].result == nil then  
            MessageMrg.show(TextMap.GetValue("Text1720"))
            return
        end
        if self.player_list[1].result == 1 or self.player_list[1].result == 2 then
            MessageMrg.show(TextMap.GetValue("Text1719"))
            return
        end
        if self.player_list[1].result ==nil and self.player_list[2].result ~= nil then
            UIMrg:pop()
        end
    elseif name == "btn_three" then --三四名决赛
        if self.player_list == nil then 
            MessageMrg.show(TextMap.GetValue("Text1720"))
            return 
        end
        if self.player_list[2].result == 1 or self.player_list[2].result == 2 then
            MessageMrg.show(TextMap.GetValue("Text1719"))
            return
        end
        if (self.player_list[2].result ~=1 or self.player_list[2].result ~=2) then
            UIMrg:pop()
        end
    end
end

return m