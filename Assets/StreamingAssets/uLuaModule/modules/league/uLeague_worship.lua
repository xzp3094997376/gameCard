-- 膜拜页面
local m = {}

-- function m:Start()
-- end

function m:update(data)
    Tool.loadTopTitle(self.gameObject, TextMap.GetValue("Text290"))
    LuaMain:ShowTopMenu(6,nil,{[1]={ type="money"},[2]={ type="gold"}})
    self.data = data
    self:setBasicInfo()
    self:setWorshipItems()
    self:setWorkship_Process()
end

function m:onEnter()
    GuildDatas:downGuildRewardStatus(function(args)
        print("---------------------on_btn_ShenXiang------------------------")
        print(args.result.visit)
        print("---------------------on_btn_ShenXiang------------------------")
        local temp = {}
        temp.visit = args.result.visit
        self:update(temp)
    end)
end

function m:onClick(go, btnName)
    if btnName == "btn_close" then
        -- UIMrg:pop()
    end
end

function m:setBasicInfo()
    self.basicInfo = GuildDatas:getMyGuildInfo()
    if self.basicInfo.experience >= GuildDatas:getExp(self.basicInfo.guildLevel) then
        GuildDatas:downloadGuildBaseInfo(function(args)
            self:setBasicInfo()
            self:setWorshipItems()
            self:setWorkship_Process()
        end)
    end
    self.img_icon.spriteName = tostring(self.basicInfo.icon)
    self.txt_mingzi.text = self.basicInfo.guildName
    --self.slider_exp.value = 0.5--要通过读表计算
    self.slider_exp.value = self.basicInfo.experience / GuildDatas:getExp(self.basicInfo.guildLevel)
    --self.labPieceCount_exp.text = "要通过读表计算"
    self.labPieceCount_exp.text = "[00ff00]" .. self.basicInfo.experience .. "[-]/" .. GuildDatas:getExp(self.basicInfo.guildLevel)
    --self.txt_gongxian.text = "缺少数据"
    self.txt_gongxian.text = Player.Resource.donate
    self.txt_membernum.text = self.basicInfo.playerAmount .. "/" .. self.basicInfo.playerAmountLimit
    self.txt_guildLv.text = self.basicInfo.guildLevel
    --print(GuildDatas:getMyGuildExt().contribution)
end

function m:setWorshipItems()
    local args1 = {}
    args1.typeId = 1
    args1.delegate = self
    self.worship1:CallUpdate(args1)

    local args2 = {}
    args2.typeId = 2
    args2.delegate = self
    self.worship2:CallUpdate(args2)

    local args3 = {}
    args3.typeId = 3
    args3.delegate = self
    self.worship3:CallUpdate(args3)
end

function m:setWorkship_Process()
    local args = {}
    args.delegate = self
    args.sacrificeProgress = self.basicInfo.sacrificeProgress
    args.sacrificeAmount = self.basicInfo.sacrificeAmount
    args.playerAmount = self.basicInfo.playerAmount
    args.visit = self.data.visit
    print("-----------setWorkship_Process------------")
    print(self.data.visit)
    print("-----------setWorkship_Process------------")
    self.workship_progress:CallUpdate(args)
end

return m