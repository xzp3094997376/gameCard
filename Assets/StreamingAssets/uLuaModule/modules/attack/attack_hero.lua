--
-- Created by IntelliJ IDEA.
-- User:jixinpeng
-- Date: 2015/12/4
-- Time: 17:23
-- To change this template use File | Settings | File Templates.
local m = {}

function m:update(data)
    self.data = data.data
    self.delegate = data.delegate
    if self.data == nil then 
        print("self.data is nil ")
        return 
    end
    local charId = self.data.charId
    if charId ~= nil then 
        self.hero:LoadByCharId(charId, "stand", function(ctl) 
        	self.ctl = ctl
        end)
    end
    if self.txt_lv_name ~= nil then
        self.txt_lv_name.text = "[00ff00]Lv"..self.data.level.."[-] "..self.data.nickname.." [00ff00]["..self:getSid(self.data.sid).."][-]"
    end
    self.txt_vip.text = self.data.vip
    self.txt_count.text = self.data.count or 0
end

--播放英雄动作
function m:changeHeroState()
    if self.ctl ~= nil then
        local ani = self.ctl.transform:GetComponent("Animation")
        if ani ~= nil then
            local flag = ani:IsPlaying("attack")
            if flag == true then
                return
            end
        end
        self.ctl:PlayAnimation("attack",false)
        self.binding:CallAfterTime(1.1,function ()
            self.ctl:PlayAnimation("stand",true)
        end)
    end
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

function m:setTalk(msg)
    if msg == nil then return self.talk_obj:SetActive(false)end
    self.talk_obj:SetActive(true)
    self.txt_talk.text = msg
    self.binding:CallAfterTime(2,function ()
        self.talk_obj:SetActive(false)
    end)
end

function m:onClick(go,name)
    if name == "btn_cheer" then
        if self.data.pid == nil then return end
        Api:addBuff(self.data.pid,function (result)
            local pid = result.pid
            local times = result.times
            self:setTimes(pid,times)
            self.txt_count.text = result.times
            self:playFont(result.magic)
        end)
    end
end

--刷洗助威次数
function m:setTimes(pid,times)
    if pid == nil or times == nil or self.delegate == nil then return end
    self.delegate:setTimes(pid,times)
end

--属性加成飘字
function m:playFont(magic)
    if magic == nil then return end
    local decs = {}
    local line = TableReader:TableRowByID("magics", magic.id)
    local text = line.format
    local temp = "+"..magic.add/10
    local t = string.gsub(text, "{0}", temp)
    t = TextMap.GetValue("Text_1_182")..t.."[00ff00]%[-]"
    table.insert(decs, t)
    -- self.binding:CallManyFrame(function()
    OperateAlert.getInstance:showToGameObject(decs, self.hero.gameObject)
    -- end)
    self:changeHeroState()
end

--显示英雄阵容
function m:clickHero()
    -- print("pid========"..self.data.pid)
    -- print("sid==========="..self.data.sid)
    local  that = self
    Api:getInfo(self.data.pid,self.data.sid.."",
        function(result)
            local tp = 2
            local temp = {}
            temp.data = result.showRet.defenceTeam
            temp.show = 1
            local datas = {}
            self.data.nickname = self.data.nickname
            datas["info"] = self.data
            datas.rank = self.data.rank
            temp.peopleVO = datas
            temp.pid = self.data.pid
            temp.tp = tp
            temp.sid = self:getSid(self.data.sid) 
            temp.rank = self.data.rank
            datas = nil
            UIMrg:pushWindow("Prefabs/moduleFabs/arenaModule/arena_enemy_info", temp)
            temp = nil
            result = nil
    end)
end

function m:Start()
    ClientTool.AddClick(self.hero, funcs.handler(self, self.clickHero))
end

return m
