-- 申请公会列表页面
local m = {}

function m:Start()
    self.dataList = {}
    self.lbl_tip.gameObject:SetActive(true)
    LuaMain:ShowTopMenu()
    Tool.loadTopTitle(self.gameObject, TextMap.GetValue("LocalKey_425"))
    self.binding:CallManyFrame(function()
        self:getApplyList()
    end, 1)
end

function m:getApplyList(...)
    print("RRRRRRRRRRRRRRRRR")
    -- 获取申请加入公会的人员列表
    Api:getGuildApplyList(function(result)
        if tonumber(result.ret) == 0 then
            if result.list.Count == 0 then
                self.svLeagueList:refresh(self.dataList, self, true, 0)
                self.lbl_tip.gameObject:SetActive(true)
                --self.lbl_tip.text = "最近没有人申请你的协会..."
                return
            end
            self.lbl_tip.gameObject:SetActive(false)
            local count = result.list.Count
            self.memberDataList = {}
            for i = 0, count - 1 do
                local t = {}
                t.playerId = result.list[i].playerId
                t.nickname = result.list[i].nickname
                t.level = result.list[i].level
                t.fight = result.list[i].fight
                t.icon = result.list[i].icon
                t.createTime = result.list[i].createTime
                table.insert(self.memberDataList, t)
            end
            self.svLeagueList:refresh(self.memberDataList, self, true, 0)
        else
            MessageMrg.show(TextMap.GetValue("Text1181"))
        end
    end, function(result)
        print("lzh print: getGuildBaseInfo 2222222222222222")
    end)
end

function m:onClick(go, btnName)
    if btnName == "btn_setting" then
        print("lzh print:1111111111111")
        --self.league_Validation.gameObject:SetActive(true)
        UIMrg:pushMessage("Prefabs/moduleFabs/leagueModule/league_Validation", {})
    end
end



return m