--公会成员列表页面
local m = {}

function m:Start()
    -- self.memberDataList={}
    -- self.binding:CallManyFrame(function()
    --        		self:getGuildMemberList()
    --    		end,1)
    self:HideRenmingBtns()
end

function m:update(args)
    local result = args.result
    if result.list.Count == 0 then
        self.svMemberList:refresh(self.memberDataList, true, 0)
    end
    local count = result.list.Count
    self.memberDataList = {}
    for i = 0, count - 1 do
        -- print("******************************")
        -- print(result.list[i])
        -- print("******************************")
        local t = {}
        t.playerId = result.list[i].playerId
        t.nickname = result.list[i].nickname
        t.level = result.list[i].level
        t.vipLevel = result.list[i].vipLevel
        t.fight = result.list[i].fight
        t.contribution = result.list[i].contribution
        t.contributionAmout = result.list[i].contributionAmout
        t.offlineTime = result.list[i].offlineTime
        t.job = result.list[i].job
        t.icon = result.list[i].icon
        table.insert(self.memberDataList, t)
    end
    table.sort(self.memberDataList, function(a, b)
        if a.job ~= b.job then
            return a.job < b.job --按排名次数
        elseif a.playerId == Player.playerId then
            return true
        elseif b.playerId == Player.playerId then
            return false
        elseif a.offlineTime == 0 then
            if b.offlineTime == 0 then
                if a.level ~= b.level then
                    return a.level > b.level
                elseif a.fight ~= b.fight then
                    return a.fight > b.fight --按排名次数
                else
                    return false
                end
            end
            return true
        elseif b.offlineTime == 0 then
            return false
        else
            if a.level ~= b.level then
                return a.level > b.level
            elseif a.fight ~= b.fight then
                return a.fight > b.fight --按排名次数
            else
               if a.offlineTime > b.offlineTime then
                    return true
                else
                    return false
                end
            end
        end
    end)
    --self.svMemberList:refresh(self.memberDataList, self, true, 0)
    self.svMemberList:refresh(self.memberDataList, self, false)
end

function m:getMyJob()
    for i = 1, #self.memberDataList do
        if self.memberDataList[i].playerId == Player.playerId then
            return self.memberDataList[i].job
        end
    end
    return 3
end

-- function m:refeshList( ... )
-- 	self.svMemberList:refresh(self.memberDataList, self, true, 0)
-- end

function m:ShowRenmingBtns(memberData)
    self.btns_renming:SetActive(true)
    -- self.renmingCallback=renmingCallback
    -- self.moveMonsterJobCallback=moveMonsterJobCallback
    self.memberData = memberData
end

function m:HideRenmingBtns(...)
    self.btns_renming:SetActive(false)
    self.memberData = nil
end

function m:onClick(go, btnName)
    if btnName == "Sprite_mark" then
        self:HideRenmingBtns()
    elseif btnName == "btn_renming" then
        -- 任命副会长
        if self.memberData ~= nil then
            self.onRenmingJob()
        end
    elseif btnName == "btn_move" then
        -- 移交会长
        if self.memberData ~= nil then
            self.onMoveMonsterJob()
        end
    end
end

-- 任命副会长
function m:onRenmingJob()
    print("1111111111111111111111")
    local function api(...)
        Api:appointJob(m.memberData.playerId, function(result)
            print("lzh print: appointJob 1111111111111111")
            print(result.ret)
            if tonumber(result.ret) == 0 then
                MessageMrg.show(TextMap.GetValue("Text1279"))
                m:HideRenmingBtns()
                m:refreashList()
            else
                GuildDatas:ShowTipByReturnCode_zg(tonumber(result.ret))
            end
        end, function(...)
            print("lzh print: appointJob 2222222222222222")
            print(result)
        end)
    end

    UIMrg:pushMessage("Prefabs/moduleFabs/alertModule/dialog", {
        type = "tips",
        msg = string.gsub(TextMap.GetValue("LocalKey_723"),"{0}",m.memberData.nickname),
        btnName = TextMap.GetValue("Text1265"),
        title = TextMap.GetValue("Text70"),
        onOk = api or function() end,
        onCancel = function() end
    })
end

-- 移交会长
function m:onMoveMonsterJob()
    print("22222222222222222222")
    local function api(...)
        Api:appointMasterJob(m.memberData.playerId, function(result)
            print("lzh print: appointMasterJob 1111111111111111")
            print(result.ret)
            if tonumber(result.ret) == 0 then
                MessageMrg.show(TextMap.GetValue("Text1281"))
                m:HideRenmingBtns()
                m:refreashList()
            else
                GuildDatas:ShowTipByReturnCode_zg(tonumber(result.ret))
            end
        end, function(...)
            print("lzh print: appointMasterJob 2222222222222222")
            print(result)
        end)
    end

    UIMrg:pushMessage("Prefabs/moduleFabs/alertModule/dialog", {
        type = "tips",
        msg = string.gsub(TextMap.GetValue("LocalKey_725"),"{0}",m.memberData.nickname),
        btnName = TextMap.GetValue("Text1283"),
        title = TextMap.GetValue("Text70"),
        onOk = api or function() end,
        onCancel = function() end
    })
end

function m:refreashList(...)
    -- 获取公会消息列表
    Api:getGuildMemberList(function(result)
        if tonumber(result.ret) == 0 then
            local args = {}
            args.result = result
            self:update(args)
        else
            GuildDatas:ShowTipByReturnCode_zg(tonumber(result.ret))
            --MessageMrg.show("获取公会成员列表失败！")
        end
    end, function(result)
        print("lzh print: getGuildBaseInfo 2222222222222222")
        --UIMrg:pop()
        print(result)
    end)
end

return m