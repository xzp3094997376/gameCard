local m = {}

function m:Start(...)
end

function m:setData(data)
    self.leagueIcon.spriteName = tostring(data.icon)
    self.leagueName.text = data.guildName
    self.mumberAmount.text = TextMap.GetValue("Text1157") .. data.playerAmount .. "/" .. data.playerAmountLimit .. "[-])"
    self.txt_lv.text =string.gsub(TextMap.GetValue("LocalKey_712"),"{0}",data.joinLvLimit)
    self.txt_description.text = data.announce
    self.lbl_level.text = tostring(data.guildLevel)
    local temp = GuildDatas:getJoinLeagueListState(self.index + 1)
    if data.isApply == false then
         if GuildDatas:getJoinLeagueListState(self.index + 1) ~= nil and GuildDatas:getJoinLeagueListState(self.index + 1) == true then
            self.btn_join.gameObject:SetActive(false)
            self.btn_join_has.gameObject:SetActive(true)
        else
            self.btn_join.gameObject:SetActive(true)
            self.btn_join_has.gameObject:SetActive(false)
        end
    else
        
        self.btn_join.gameObject:SetActive(false)
        self.btn_join_has.gameObject:SetActive(true)
    end
end

function m:update(data, index, delegate)
    self.data = data
    self.delegate = delegate
    self.index = index
    print("index"..index)

    self:setData(data)
end

-- 申请按钮
function m:onJoin(...)
    if self.data.joinLvLimit > Player.Info.level then
        MessageMrg.show(string.gsub(TextMap.GetValue("LocalKey_662"),"{0}",self.data.joinLvLimit))
        return
    end
    print("lzh print: self.data.guildId = " .. self.data.guildId)
    Api:applyJoin(self.data.guildId, function(result)
        -- -- 判断:玩家当前是否为无CD状态
        -- if isCD then
        -- 	MessageMrg.show("已经申请该协会,请等待申请通过!")
        -- end
        local retNum = tonumber(result.ret)
        if retNum == 0 then
            -- 判断:玩家是否满足协会设置申请条件 *Player.Info.level
            -- MessageMrg.show(TextMap.GetValue("Text1154"))
            -- 申请成功 -- 判定:协会是否开启入会验证
            --是:提交申请信息,申请按钮变为取消申请按钮
            -- 否:加入协会成功,直接进入协会地图界面

            -- elseif
            -- 2表示申请被直接通过
            if tonumber(result.type) == 2 then
                UIMrg:pop()
                --Tool.push("leagueModule", "Prefabs/moduleFabs/leagueModule/league_main_page")
                GuildDatas:downloadGuildBaseInfo(function(args)
                    ClientTool.LoadLevel("gonghui_map", function()
                        Tool.push("leagueModule", "Prefabs/moduleFabs/leagueModule/league_main_page", args)
                        LuaMain:createGongHuiBuildName()
                    end)
                end)
            else
                GuildDatas:setJoinLeagueListState(self.index + 1, true)
                self.btn_join.gameObject:SetActive(false)
                self.btn_join_has.gameObject:SetActive(true)
                MessageMrg.show(TextMap.GetValue("Text1160"))
            end
        elseif retNum == 1002 then
            MessageMrg.show(TextMap.GetValue("Text1161"))
        elseif retNum == 1003 then
            MessageMrg.show(TextMap.GetValue("Text1162"))
        else
            MessageMrg.show(TextMap.GetValue("Text1163") .. retNum)
        end
    end, function(...)
        print("lzh print: applyJoin 2222222222222222")
    end)
end

-- 取消申请按钮
function m:onJoinHas(...)
    Api:cancelApplyJoin(self.data.guildId, function(result)
        local retNum = tonumber(result.ret)
        if retNum == 0 then
            self.data.isApply = false
            GuildDatas:setJoinLeagueListState(self.index + 1, false)
            self:setData(self.data)
        else
            MessageMrg.show(TextMap.GetValue("Text1163") .. retNum)
        end
    end, function(...)
    end)
end

function m:onClick(go, name)
    if name == "btn_join" then
        self:onJoin()
    elseif name == "btn_join_has" then
        self:onJoinHas()
    end
end

return m