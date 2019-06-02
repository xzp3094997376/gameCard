local m = {}

function m:Start()
    self:InitBoxDatas()
end

function m:update(data)
    self.data = data
    self.lbl_process.text = TextMap.GetValue("Text1311") .. self.data.sacrificeProgress
    self.lbl_workshipNums.text = TextMap.GetValue("Text1312") .. self.data.sacrificeAmount .. "/" .. GuildDatas:getMyGuildInfo().playerAmountLimit

    local row = TableReader:TableRowByUnique("GuildCreate", "level", GuildDatas:getMyGuildInfo().guildLevel .. "")
    self.totalPrcess = tonumber(row.sacrificeAmount)
    self.slider_progress.value = self.data.sacrificeProgress / self.totalPrcess

    self:InitBoxDatas()
    --0 还不能领奖 1可以领奖而未领  2 完成领奖
    for k, v in pairs(self.BoxDatas) do
        v.boxLabel.text = v.processValue
        if v.process <= self.slider_progress.value then
            if self:IsVisit(v.id) then
                v.state = 2
                v.boxSprite.enabled=false
                v.openBox.enabled=true
                v.boxBling.gameObject:SetActive(false)
            else
                v.state = 1
                v.boxSprite.enabled=true
                v.openBox.enabled=false
                v.boxBling.gameObject:SetActive(true)
            end
        else
            v.state = 0
            v.boxSprite.enabled=true
            v.openBox.enabled=false
            v.boxBling.gameObject:SetActive(false)
        end
        --self:setBoxPos(self.img_box1, v.process)
        local x = self.slider_progress_sprite.width * v.process
        v.boxBtn.gameObject.transform.localPosition = Vector3(x, 0, 0)
    end
end


function m:InitBoxDatas(...)
    if self.isInitBoxDatas == true then
        return
    end

    local row = TableReader:TableRowByUnique("GuildCreate", "level", GuildDatas:getMyGuildInfo().guildLevel .. "")
    self.totalPrcess = tonumber(row.sacrificeAmount)

    self.isInitBoxDatas = true
    self.BoxDatas = {}
    for i = 1, 4 do
        local data = {}
        data.id = i
        if i == 1 then
            data.boxSprite = self.img_box1
            data.boxLabel = self.txt_box1
            data.boxBtnName = "btn_box1"
            data.boxBtn = self.btn_box1
            data.boxBling = self.Sprite_bling_1
            data.openBox=self.img_box_open1
        elseif i == 2 then
            data.boxSprite = self.img_box2
            data.boxLabel = self.txt_box2
            data.boxBtnName = "btn_box2"
            data.boxBtn = self.btn_box2
            data.boxBling = self.Sprite_bling_2
            data.openBox=self.img_box_open2
        elseif i == 3 then
            data.boxSprite = self.img_box3
            data.boxLabel = self.txt_box3
            data.boxBtnName = "btn_box3"
            data.boxBtn = self.btn_box3
            data.boxBling = self.Sprite_bling_3
            data.openBox=self.img_box_open3
        elseif i == 4 then
            data.boxSprite = self.img_box4
            data.boxLabel = self.txt_box4
            data.boxBtnName = "btn_box4"
            data.boxBtn = self.btn_box4
            data.boxBling = self.Sprite_bling_4
            data.openBox=self.img_box_open4
        end
        data.row = self:getBoxDataFromTable(i)
        data.processValue = tonumber(data.row.cost_arg)
        data.process = data.processValue / self.totalPrcess
        table.insert(self.BoxDatas, data)
    end
end

function m:onClick(go, btnName)
    if btnName == "btn_box1" then
        self:onBox(1)
    elseif btnName == "btn_box2" then
        self:onBox(2)
    elseif btnName == "btn_box3" then
        self:onBox(3)
    elseif btnName == "btn_box4" then
        self:onBox(4)
    end
end

function m:onBox(id)
    local boxData
    for k, v in pairs(self.BoxDatas) do
        if v.id == id then
            boxData = v
        end
    end

    if boxData == nil or boxData.row == nil or boxData.row.drop == nil then
        MessageMrg.show(TextMap.GetValue("Text1313"))
        return
    end

    local datas = {}
    datas.title = TextMap.GetValue("Text1314")
    datas.lv = {id}
    datas.obj = boxData.row.drop
    --0 还不能领奖 1可以领奖而未领  2 完成领奖
    --datas.state = self._state		---------------------
    datas.state = boxData.state
    datas._go = self.binding.gameObject ---------------------
    datas.BtnSprite = boxData.boxSprite.gameObject --------------- 按钮本身
    datas.callFun = funcs.handler(self, self.onAfterGetReward) --领奖成功的一个回调
    UIMrg:pushWindow("Prefabs/moduleFabs/leagueModule/league_acceptRewardBox", datas)
    datas = nil
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

-- process 0-1
function m:setBoxPos(box, process)
    local x = self.slider_progress_sprite.width * process
    box.gameObject.transform.localPosition = Vector3(x, 0, 0)
end

-- 成功领奖后的一个回调
function m:onAfterGetReward(id)
    --MessageMrg.show("onAfterGetReward")
    GuildDatas:downGuildRewardStatus(function(args)
    end)
end

-- 是否已经参拜
function m:IsVisit(id)
    local count = self.data.visit.Count
    for i = 0, count do
        if id == self.data.visit[i] then
            return true
        end
    end
    return false
end

return m