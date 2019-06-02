-- 查找公会的tab页面
local m = {}

function m:Start()
    print("lzh print:******** uLeagueSearchTab.lua ** Start()")
end

-- function m:onEnter()
--     	print("lzh print:******** uLeagueSearchTab.lua ** onEnter()")
-- end

function m:onClick(go, btnName)
    if btnName == "btn_search" then
        self:onSearchBtn()
    end
end

function m:onSearchBtn()
    print("lzh print: 单击了查找按钮!")
    local nameOrId = self.textInput_unionname.value
    if nameOrId == nil or nameOrId == "" then
        MessageMrg.show(TextMap.GetValue("Text1165"))
        return
    end
    if #nameOrId > 30 then
        MessageMrg.show(TextMap.GetValue("Text1166"))
        return
    end

    local tempDataList = {}
    Api:searchGuildByNameOrId(nameOrId, function(result)
        if tonumber(result.ret) == 0 then
            print("lzh pritn: searchGuildByNameOrId() 11111111 ")
            if result.list.Count == 0 then
                self.svLeagueList:refresh(tempDataList, self, true, 0)
                self.lblMsg.gameObject:SetActive(true)
                self.lblMsg.text = TextMap.GetValue("Text1167")
                return false
            end
            self.lblMsg.gameObject:SetActive(false)
            local count = result.list.Count
            for i = 0, count - 1 do
                local t = {}
                t.guildId = result.list[i].guildId
                t.guildName = result.list[i].guildName
                t.icon = result.list[i].icon
                t.guildLevel = result.list[i].guildLevel
                t.masterName = result.list[i].masterName
                t.playerAmount = result.list[i].playerAmount
                t.playerAmountLimit = result.list[i].playerAmountLimit
                t.announce = result.list[i].announce
                t.isApply = result.list[i].isApply
                t.joinLvLimit = result.list[i].joinLvLimit
                table.insert(tempDataList, t)
                m = nil
            end
            self.svLeagueList:refresh(tempDataList, self, true, 0)
        end
    end, function(...)
        print("lzh pritn: searchGuildByNameOrId() 22222222222")
    end)
end


function m:onExit()
    print("lzh print:******** uLeagueSearchTab.lua ** onExit()")
end

function m:OnDestroy()
    print("lzh print:******** uLeagueSearchTab.lua ** OnDestroy()")
end

return m