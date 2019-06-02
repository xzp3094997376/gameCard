-- 比武主界面
local m = {}

function m:Start(...)
    LuaMain:ShowTopMenu()
    self.page = 1 --当前页面（默认为第一页）
    --读取对话
    self:readTalk()
    self.talk_index = 1 --对话index
    self.isStop = false --是否停止对话
end

function m:update( ... )
    self:getContestList()
    self.binding:CallAfterTime(2,function ()
        self:playTalk(1)
    end)
end

function m:getContestList()
    Api:getContestList(function (result)
        local data = result.playerList
        -- data = json.decode(data:toString())
        self.buffList = json.decode(result.buffList:toString())
        self.top = result.top
        self:initList(data)
    end)
end

--初始化玩家列表
function m:initList(data)
    if data == nil then return end
    local playerList = data
    self.max_count = 0
    self.player_list = {}
    for k=0,playerList.Count-1 do
        local player_1 = self:initData(playerList[k][0])
        local player_2 = self:initData(playerList[k][1])
        table.insert(self.player_list,player_1)
        table.insert(self.player_list,player_2)
        self.max_count = self.max_count + 2
    end

    --临时数据
    -- self.max_count = 4
    if self.max_count <= 4 then --决赛
        self.max_page = self.max_count/2
        self.two_obj:SetActive(true)
        self.four_obj:SetActive(false)
        self:refreshFinal()
    else                                   --非决赛 
        self.max_page = self.max_count/4  
        self.two_obj:SetActive(false)
        self.four_obj:SetActive(true)
        self:refreshByPage()
    end 
    
end

-- 根据页面刷新数据(四个英雄)
function m:refreshByPage()
    if self.page == nil then self.page = 1 end
    --刷新四个角色信息
    local k = 1
    for i = (self.page-1)*4+1,(self.page-1)*4+4 do
        if self.player_list[i] ~= nil then
            self["hero_"..k]:CallUpdate({data = self.player_list[i],delegate = self})
            k = k + 1
        end
    end

    --设置翻页按钮的显示与隐藏
    if self.page + 1 > self.max_page then --最后一页
        self.btn_right.gameObject:SetActive(false)
    else
        self.btn_right.gameObject:SetActive(true)
    end
    if self.page - 1 < 1 then --第一页
        self.btn_left.gameObject:SetActive(false)
    else
        self.btn_left.gameObject:SetActive(true)
    end
    local page = string.gsub(TextMap.GetValue("LocalKey_804"),"{0}",self.page)
    self.txt_page.text = string.gsub(page,"{1}",self.max_page)
    
    if self.page <= self.max_page/2 then --上半区
        self.sprite_zu_1.spriteName = "KFBW_"..(2*self.page-1)
        self.sprite_zu_2.spriteName = "KFBW_"..(2*self.page)
        local page = string.gsub(TextMap.GetValue("LocalKey_805"),"{0}",(self.max_count/2))
        self.txt_title.text = string.gsub(page,"{1}",(self.max_count/4))
    else
        self.sprite_zu_1.spriteName = "KFBW_"..(2*self.page-1-self.max_page)
        self.sprite_zu_2.spriteName = "KFBW_"..(2*self.page-self.max_page)
        local page = string.gsub(TextMap.GetValue("LocalKey_806"),"{0}",(self.max_count/2))
        self.txt_title.text = string.gsub(page,"{1}",(self.max_count/4))
    end
end

--刷新两个英雄界面
function m:refreshFinal()
    if self.page == nil then self.page = 1 end
    --刷新两个角色信息
    local k = 1
    for i = (self.page-1)*2+1,(self.page-1)*2+2 do
        if self.player_list[i] ~= nil then
            self["final_hero_"..k]:CallUpdate({data = self.player_list[i],delegate = self})
            k = k + 1
        end
    end

    self.txt_page.text = TextMap.GetValue("Text1704")..self.page.."/"..self.max_page
    --设置翻页按钮的显示与隐藏
    if self.page + 1 > self.max_page then --最后一页
        self.btn_right.gameObject:SetActive(false)
    else
        self.btn_right.gameObject:SetActive(true)
    end
    if self.page - 1 < 1 then --第一页
        self.btn_left.gameObject:SetActive(false)
    else
        self.btn_left.gameObject:SetActive(true)
    end
    if self.top == 2 then --总决赛
        self.txt_title.text = TextMap.GetValue("Text1708")
    elseif self.top == 3 then  --三四名决赛
        if self.page == 1 then
            self.txt_title.text = TextMap.GetValue("Text1709")
        else
            self.txt_title.text = TextMap.GetValue("Text1708")
        end
    elseif self.page == 1 then
        self.txt_title.text = TextMap.GetValue("Text1710")
    elseif self.page == 2 then
        self.txt_title.text = TextMap.GetValue("Text1711")
    end
end

--根据pid刷新页面
function m:refreshByPid(pid)
    if pid == nil then return end 
    local target_index = nil
    for i = 1,#self.player_list do
        if pid == self.player_list[i].pid then
            target_index = i
        end
    end

    if target_index == nil then target_index = 1 end
    self.page = 1
    if #self.player_list == 4 then
        if target_index <=2 then
            self.page = 1
        else
            self.page = 2
        end
        self:refreshFinal()
    elseif #self.player_list > 4 then
        if target_index <= 4 then
            self.page = 1
        else
            local temp = 0
            if target_index%4 ~= 0 then
                temp = 1
            end
            self.page = math.floor(target_index/4)+temp
        end
        self:refreshByPage()
    end
end

--初始化每个玩家数据
function m:initData(player)
    if player == nil then return {} end
    local p = json.decode(player:toString())
    local temp = {}
    temp.pid = p.pid
    temp.nickname = p.nickname
    temp.head = p.head
    temp.level = p.level
    temp.defenceTeam = p.defenceTeam
    temp.charId = self:getChar(p.defenceTeam)
    temp.power = p.power
    temp.sid = tonumber(p.sid)
    temp.vip = p.vip
    temp.count = self.buffList[p.pid]
    temp.rank = p.rank
    return temp
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

--读取对话内容
function m:readTalk()
    self.all_talk = {}
    TableReader:ForEachLuaTable("dialogue", function(index, item) 
        self.all_talk[index + 1] = item.desc
        return false
    end)
    self.talk_count = #self.all_talk
end

--按配表顺序获取一句对话
function m:randomTalk()
    if self.talk_index > self.talk_count then self.talk_index = 1 end
    return self.all_talk[self.talk_index]
end

--播放对话
function m:playTalk(index)
    if self.isStop == true then return end
    if  self.max_count >4 then
        if index == nil or index > 4 then index = 1 end
        local msg = self:randomTalk()
        self.talk_index = self.talk_index + 1
        self["hero_"..index]:CallTargetFunction("setTalk",msg)
        self.binding:CallAfterTime(4,function ()
            self:playTalk(index+1)
        end)
    else
        if index == nil or index > 2 then index = 1 end
        local msg = self:randomTalk()
        self.talk_index = self.talk_index + 1
        self["final_hero_"..index]:CallTargetFunction("setTalk",msg)
        self.binding:CallAfterTime(4,function ()
            self:playTalk(index+1)
        end)
    end
end

-- 重新播放对话
function m:playTalkAgain()
    if self.max_count >4 then
        for i=1,4 do
            self["hero_"..i]:CallTargetFunction("setTalk")
        end
    else
        for i=1,2 do
            self["final_hero_"..i]:CallTargetFunction("setTalk")
        end
    end
    self.isStop = false
    self:playTalk(1)
end

--设置助威次数
function m:setTimes(pid,times)
    self.buffList[pid] = times
    for i=1,#self.player_list do
        if self.player_list[i].pid == pid then
           self.player_list[i].count = times
        end
    end
end

function m:OnEnable()
    self:playTalkAgain()
end

function m:onClick(go, name)
    if name == "btn_right" then --下一页
        self.page = self.page + 1
        if self.max_count >4 then
            self:refreshByPage()
        else
            self:refreshFinal()
        end
    elseif name == "btn_left" then --上一页
        self.page = self.page - 1 
        if self.max_count >4 then
            self:refreshByPage()
        else
            self:refreshFinal()
        end
    elseif name == "btn_shop" then --比武商店
        self.isStop = true
        LuaMain:showShop(31)
    elseif name == "btn_progress" then
        self.isStop = true
        Tool.push("attack_progress_last", "Prefabs/moduleFabs/attack/attack_progress_last",{delegate = self})
    elseif name == "btn_video" then
        UIMrg:pushWindow("Prefabs/moduleFabs/attack/attack_record")
    elseif name == "btn_guess" then
        self.isStop = true
        Tool.push("attack_guess", "Prefabs/moduleFabs/attack/attack_guess",{})
    elseif name == "btn_rule" then
        UIMrg:pushWindow("Prefabs/moduleFabs/qiancengta/qiancengta_rule", {14,title = TextMap.GetValue("Text1712")})
    end
end

return m