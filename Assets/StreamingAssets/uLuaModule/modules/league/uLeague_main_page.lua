-- 公会的主界面
local m = {}
local bEnable = true
function m:Start(...)
    -- 增加公会聊天频道
    ChatController.AddSociatyChannel()
    Tool.loadTopTitle(self.gameObject, TextMap.GetValue("Text548"))
    bEnable = true
    self.gonghuimapCollider = GameObject.Find("gonghui_map/scene/new_ZhuJieMian")
end

function m:onEnter()
    GuildDatas:downloadGuildBaseInfo(function(args)
        self:update(args)
    end)
    bEnable = true
end

function m:update(lua)
    self:InitBasicInfo(lua.result.info)
end

function m:InitBasicInfo(userdata)
    --self.img_logo.spriteName = tostring(userdata.icon)
    self.txt_guildLv.text = userdata.guildLevel
    --self.txt_member_num.text = userdata.playerAmount .. "/" .. userdata.playerAmountLimit
    self.txt_guildName.text = userdata.guildName
    --self.slider_exp.value = 0.5--要通过读表计算
    self.btn_levelreward.gameObject:SetActive(not Tool:isAllLeagueLevelRewardsOver())
    self:InitBoxDatas()
    self.slider_exp.value = userdata.experience / GuildDatas:getExp(userdata.guildLevel)
    --self.labPieceCount.text = "要通过读表计算"
    self.txt_exp.text = "[00ff00]" .. userdata.experience .. "[-]/" .. GuildDatas:getExp(userdata.guildLevel)
    self.txt_guild_gg.text = userdata.notice
    self.txt_gongxian.text = Player.Resource.donate
    local job = GuildDatas:getMyJob(userdata.masterId, userdata.viceMasterIds)
    if job == 1 or job == 2 then
        self.btn_editNotice.gameObject:SetActive(false)
    else
        self.btn_editNotice.gameObject:SetActive(false)
    end

end

function m:onClick(go, btnName)
    print(btnName)
    -- 公会信息
    if btnName == "btn_dating" then
        self:on_btn_guildInfo()
        -- 商店
    elseif btnName == "btn_shop" then
        self:on_btn_guildShop()
        -- 神像
    elseif btnName == "btn_caibai" then
        self:on_btn_ShenXiang()
        -- 副本
    elseif btnName == "btn_fuben" then
        self:on_btn_guildCopy()
        -- 规则
    elseif btnName == "btn_guildRule" then
        self:on_btn_guildRule()
        -- 公会排行
    elseif btnName == "btn_guildRank" then
        self:on_btn_guildRank()
        -- 公会等级奖励
    elseif btnName == "btn_levelreward" then
        self:on_btn_levelRewards()
        -- 参拜奖励
    elseif btnName == "btn_canbaireward" then
        self:on_btn_canbaiRewards()
        -- 修改公告
    elseif btnName == "btn_editNotice" then
        self:on_btn_guildNotice()
        -- close
    elseif btnName == "btn_colse" then
        GuildDatas:LeaveLeague(function(...)
            UIMrg:pop()
        end)
    elseif btnName == "btn_chat" then
        UIMrg:pushWindow("Prefabs/moduleFabs/chat/chat_dialog",{2}) 
    elseif btnName=="btn_renfabu" then 
        MessageMrg.show(TextMap.GetValue("Text_1_1085"))
    elseif btnName=="btn_jinengshu" then 
        MessageMrg.show(TextMap.GetValue("Text_1_1085"))
    elseif btnName=="btn_xueyuanhuoyue" then 
        MessageMrg.show(TextMap.GetValue("Text_1_1085"))
    elseif btnName=="btn_xiulianrenwu" then 
        MessageMrg.show(TextMap.GetValue("Text_1_1085"))
    elseif btnName=="btn_task" then 
        MessageMrg.show(TextMap.GetValue("Text_1_1085"))
    end
end

function m:OnEnable()
    bEnable = true
    if self.gonghuimapCollider ~= nil then
        self.gonghuimapCollider:SetActive(true)
    end
end

function m:OnDisable()
    bEnable = false
    if self.gonghuimapCollider ~= nil then
        self.gonghuimapCollider:SetActive(false)
    end
end

-- 公会信息
function m:on_btn_guildInfo(...)
    if bEnable == false then
        return
    end
    UIMrg:push("leagueModule", "Prefabs/moduleFabs/leagueModule/league_Info_Member_Page")
end

-- 进入商店
function m:on_btn_guildShop(...)
    if bEnable == false then
        return
    end
    if Player.Info.guildId == nil or Player.Info.guildId == "" then
        MessageMrg.show(TextMap.GetValue("Text1256"))
        return
    end
    local binding = Tool.push("shop_League", "Prefabs/moduleFabs/puYuanStoreModule/shop_League")
    binding:CallUpdate({ 5 })
end

-- 进入神像
function m:on_btn_ShenXiang(...)
    if bEnable == false then
        return
    end
    print("Player.Info.guildId")
    if Player.Info.guildId == nil or Player.Info.guildId == "" then
        MessageMrg.show(TextMap.GetValue("Text1256"))
        return
    end
    --local function fun(...)
        GuildDatas:downGuildRewardStatus(function(args)
            print("---------------------on_btn_ShenXiang------------------------")
            print(args.result.visit)
            print("---------------------on_btn_ShenXiang------------------------")
            local temp = {}
            temp.visit = args.result.visit
            UIMrg:push("leagueModule", "Prefabs/moduleFabs/leagueModule/league_worship", temp)
        end)
        --UIMrg:push("leagueModule","Prefabs/moduleFabs/leagueModule/league_worship", {})
    --end

    -- LuaMain:setInJibaiState(true)
    -- local mainPage = GameObject.Find("GameManager/Camera/mainUI/center/Module_league_main_page")
    -- if mainPage ~= nil then
    --     mainPage:SetActive(false)
    -- end
    -- --self.slider_exp.gameObject.transform.parent.parent.gameObject:SetActive(true)
    -- local target = GameObject.Find("gonghui_map/scene/mainscene/gonghui_cam")
    -- ClientTool.PlayAnimation(target, "MoveTo", fun, true)
end

-- 进入副本章节列表
function m:on_btn_guildCopy(...)
    if bEnable == false then
        return
    end
   
    UIMrg:push("leagueModule", "Prefabs/moduleFabs/leagueModule/league_chapterMain")

    --UIMrg:push("leagueModule","Prefabs/moduleFabs/leagueModule/league_chapterMain", {})
end

-- 公会规则
function m:on_btn_guildRule(...)
    UIMrg:pushWindow("Prefabs/moduleFabs/leagueModule/league_rule", { 9 })
end

-- 公会排行
function m:on_btn_guildRank(...)
    Api:getGuildRankList(function(result)
        if tonumber(result.ret) == 0 then
            local datas = {}
            datas.pos = result.pos
            local count = result.list.Count
            local list = {}
            for i = 0, count - 1 do
                local t = {}
                t.icon = result.list[i].icon
                t.guildId = result.list[i].guildId
                t.guildName = result.list[i].guildName
                t.guildLevel = result.list[i].guildLevel
                t.masterNickname = result.list[i].masterNickname
                t.playerAmount = result.list[i].playerAmount
                t.playerAmountLimit = result.list[i].playerAmountLimit
                t.announce = result.list[i].announce
                table.insert(list, t)
            end
            datas.list = list
            UIMrg:pushWindow("Prefabs/moduleFabs/leagueModule/league_rank", datas)
        else
            MessageMrg.show(TextMap.GetValue("Text1188"))
        end
    end, function(result)
        print("lzh print: getGuildRankList 2222222222222222")
        print(result)
    end)
end

function m:on_btn_levelRewards()
    UIMrg:pushWindow("Prefabs/moduleFabs/leagueModule/league_level_rewards", {})
end

function m:on_btn_canbaiRewards()
    print("#self.canbai_Drops..."..#self.canbai_Drops)
    if #self.canbai_Drops == 0 then return end
    local _lvG = {}
    local _dropG = {}
    for k,v in pairs(self.canbai_Drops) do
        table.insert(_lvG,v.id)
        local count = v.row.drop.Count - 1
        for i=0, count  do
            table.insert(_dropG,v.row.drop[i])
        end        
    end

    local datas = {}
    datas.title = TextMap.GetValue("Text1654")
    datas.lv = _lvG
    datas.obj = _dropG
    datas.state = 1
    datas._go = self.binding.gameObject
    datas.callFun = funcs.handler(self, self.onAfterGetReward) --领奖成功的一个回调
    UIMrg:pushWindow("Prefabs/moduleFabs/leagueModule/league_acceptRewardBox", datas)
end

function m:onAfterGetReward()
    self:InitBoxDatas()
end


function m:InitBoxDatas()
    local someData = {}
    local guildInfo = GuildDatas:getMyGuildInfo()
    local sacrificeProgress = guildInfo.sacrificeProgress
    GuildDatas:downGuildRewardStatus(function(args)
            someData = args.result
            
            local row = TableReader:TableRowByUnique("GuildCreate", "level", guildInfo.guildLevel .. "")
            local totalPrcess = tonumber(row.sacrificeAmount)
            local cur_exp = sacrificeProgress / totalPrcess
            self.canbai_Drops = {}
            for i = 1, 4 do
                local data = {}
                data.id = i
                data.row = self:getBoxDataFromTable(i)
                data.process = tonumber(data.row.cost_arg) / totalPrcess
                print("data.process="..data.process.."....cur_exp....="..cur_exp)
                --print(someData)
                if data.process <= cur_exp then
                    if not self:IsVisit(i,someData.visit) then
                        table.insert(self.canbai_Drops, data)
                    end
                end 
                --table.insert(self.canbai_Drops, data)
            end
        self.btn_canbaireward.gameObject:SetActive(#self.canbai_Drops > 0)
    end)
end

function m:IsVisit(id,data)
    if data == nil then return false end
    print("......data.Count"..data.Count)
    local count = data.Count
    for i = 0, count -1 do
        if id == data[i] then
            return true
        end
    end
    return false
end


function m:getBoxDataFromTable(boxId)
    local leagueInfo = GuildDatas:getMyGuildInfo()
    local leagueLevel = tonumber(leagueInfo.guildLevel)
    local row = {}
    TableReader:ForEachLuaTable("league_workship_score", function(index, item)
        if tonumber(item.league_lvl) == leagueLevel and boxId == tonumber(item.reward_lvl) then
            row = item
            return true
        end
        return false
    end)
    return row
end





-- 编辑公会公告
function m:on_btn_guildNotice(...)
    local args = {}
    args.type = 3
    args.title = TextMap.GetValue("Text1253")
    args.content = self.txt_guild_gg.text
    args.sucCallback = function(newContent)
        self.txt_guild_gg.text = newContent
    end
    UIMrg:pushMessage("Prefabs/moduleFabs/leagueModule/league_Edit_NoticeandAnnounce_Dlg", args)
end



return m