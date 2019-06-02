-- 公会宝藏页面
local m = {}
local curCopyBtnNo = 1

function m:Start()
    LuaMain:ShowTopMenu()
    Tool.loadTopTitle(self.gameObject, TextMap.GetValue("LocalKey_656"))
    curCopyBtnNo = 1
end

function m:update(args)
    self.copyDatas = args.copyDatas
    self.isPass = args.isPass
    self.chapterId = args.chapterId


    if self.isPass then
        self:InitCopyBtnsEx()
    else
        self:InitCopyBtns()
    end
    self:refreashTreasureItems()
    local targetTimeStr = TableReader:TableRowByID("GuildSetting", "resetCopyTime").args1

    if targetTimeStr == nil then
        targetTimeStr = "24h00m"
    end
    local hour = 0
    local min = 0
    local i = string.find(targetTimeStr, "h")
    if i ~= nil then
        hour = tonumber(string.sub(targetTimeStr, 1, i - 1))
    else
        i = 0
    end
    print("i" .. i)

    local j = string.find(targetTimeStr, "m")
    if j ~= nil then
        min = tonumber(string.sub(targetTimeStr, i + 1, j - 1))
    end
    if hour == 0 then
        self.txt_time.text = TextMap.GetValue("LocalKey_729")
    else
        if hour < 10 then
            hour = "0" .. hour
        end
        if min < 10 then
            local msg = string.gsub(TextMap.GetValue("LocalKey_730"),"{0}",hour)
            self.txt_time.text =string.gsub(msg,"{1}", min)
        else
            local msg = string.gsub(TextMap.GetValue("LocalKey_731"),"{0}",hour)
            self.txt_time.text =string.gsub(msg,"{1}", min)
        end
    end
end

function m:onClick(go, btnName)
    if btnName == "btn_preview" then
        local args = {}
        args.copyDatas = self.copyDatas
        args.chapterId = self.chapterId
        UIMrg:pushWindow("Prefabs/moduleFabs/leagueModule/league_treasurePreview", args)
    elseif btnName == "btn_copy1" then
        self:onBtnCopy(1)
    elseif btnName == "btn_copy2" then
        self:onBtnCopy(2)
    elseif btnName == "btn_copy3" then
        self:onBtnCopy(3)
    elseif btnName == "btn_copy4" then
        self:onBtnCopy(4)
    end
end

function m:InitCopyBtnsEx(...)
   for i = 1, 4 do
        local _copyId = i
        local row = m:getRowByCopyid(_copyId)
        local effect = -1
        if _copyId == curCopyBtnNo then
            effect = 0
        end
        if _copyId == 1 then
            self.txt_copyName1.text = row.name
            self.copy_slider1.value = 0
            self.lbl_CopyProcess_1.text = "0%"
            self.Model_1:LoadByModelId(row.model, "stand", function() end, false, effect, row.big / 1000 * 1.3)
            if effect == 0 then
                self.img_copy_select1:SetActive(true)
            else
                self.img_copy_select1:SetActive(false)
            end
        elseif _copyId == 2 then
            self.txt_copyName2.text = row.name
            self.copy_slider2.value = 0
            self.lbl_CopyProcess_2.text = "0%"
            self.Model_2:LoadByModelId(row.model, "stand", function() end, false, effect, row.big / 1000 * 1.3)
            if effect == 0 then
                self.img_copy_select2:SetActive(true)
            else
                self.img_copy_select2:SetActive(false)
            end
        elseif _copyId == 3 then
            self.txt_copyName3.text = row.name
            self.copy_slider3.value = 0
            self.lbl_CopyProcess_3.text = "0%"
            self.Model_3:LoadByModelId(row.model, "stand", function() end, false, effect, row.big / 1000 * 1.3)
            if effect == 0 then
                self.img_copy_select3:SetActive(true)
            else
                self.img_copy_select3:SetActive(false)
            end
        elseif _copyId == 4 then
            self.txt_copyName4.text = row.name
            self.copy_slider4.value = 0
            self.lbl_CopyProcess_4.text = "0%"
            self.Model_4:LoadByModelId(row.model, "stand", function() end, false, effect, row.big / 1000 * 1.3)
            if effect == 0 then
                self.img_copy_select4:SetActive(true)
            else
                self.img_copy_select4:SetActive(false)
            end
        end
    end
end

function m:selectModeEffect(pre, cur)
    local row = m:getRowByCopyid(pre)
    if pre == 1 then
        self.Model_1:LoadByModelId(row.model, "stand", function() end, false, -1, row.big / 1000 * 1.3)
        self.img_copy_select1:SetActive(false)
    elseif pre == 2 then
        self.Model_2:LoadByModelId(row.model, "stand", function() end, false, -1, row.big / 1000 * 1.3)
        self.img_copy_select2:SetActive(false)
    elseif pre == 3 then
        self.Model_3:LoadByModelId(row.model, "stand", function() end, false, -1, row.big / 1000 * 1.3)
        self.img_copy_select3:SetActive(false)
    elseif pre == 4 then
        self.Model_4:LoadByModelId(row.model, "stand", function() end, false, -1, row.big / 1000 * 1.3)
        self.img_copy_select4:SetActive(false)
    end
    row = m:getRowByCopyid(cur)
    if cur == 1 then
        self.Model_1:LoadByModelId(row.model, "stand", function() end, false, 0, row.big / 1000 * 1.3)
        self.img_copy_select1:SetActive(true)
    elseif cur == 2 then
        self.Model_2:LoadByModelId(row.model, "stand", function() end, false, 0, row.big / 1000 * 1.3)
        self.img_copy_select2:SetActive(true)
    elseif cur == 3 then
        self.Model_3:LoadByModelId(row.model, "stand", function() end, false, 0, row.big / 1000 * 1.3)
        self.img_copy_select3:SetActive(true)
    elseif cur == 4 then
        self.Model_4:LoadByModelId(row.model, "stand", function() end, false, 0, row.big / 1000 * 1.3)
        self.img_copy_select4:SetActive(true)
    end
end


-- 单个BOSS奖励是否已经领取完
function m:_refreashRewardItems(boxList)

    for i=1,4 do
        self:SetRewardSpStatus(i,false)
    end
    self.boxList = boxList
    local count = boxList.Count
    for i=0,count-1 do
        if (self.chapterId)*4 > (self.boxList[i]-1) and (self.chapterId - 1)*4 <= (self.boxList[i]-1) then  
            self:SetRewardSpStatus((self.boxList[i]-1)%4+1,true)
        end
    end
end

function m:SetRewardSpStatus(_copyId,_isShow)
     if _copyId == 1 then
            self.sp_get_1.gameObject:SetActive(_isShow)
        elseif _copyId == 2 then
            self.sp_get_2.gameObject:SetActive(_isShow)
        elseif _copyId == 3 then
            self.sp_get_3.gameObject:SetActive(_isShow)
        elseif _copyId == 4 then
            self.sp_get_4.gameObject:SetActive(_isShow)
        end

end 

function m:setTresureStatus()
    GuildDatas:downGuildRewardStatus(function(args)
        print("here...."..self.chapterId)
        print(args.result.box)
        self:_refreashRewardItems(args.result.box)
    end)
end
-- 初始化四个复本按钮信息
function m:InitCopyBtns(...)
    self:setTresureStatus()
    for k, v in pairs(self.copyDatas) do
        local _copyId = tonumber(v.copyId)
        local row = m:getRowByCopyid(_copyId)
        local effect = -1
        if _copyId == curCopyBtnNo then
            effect = 0
        end


        if _copyId == 1 then
            self.txt_copyName1.text = row.name
            self.copy_slider1.value = tonumber(v.totalHp) / tonumber(v.totalMaxHp)
            local temp = self.copy_slider1.value * 100
            self.lbl_CopyProcess_1.text = math.floor(temp) .. "%"
            self.Model_1:LoadByModelId(row.model, "stand", function() end, false, effect, row.big / 1000 * 1.3)
            --self.sp_get_1.gameObject:SetActive(self:IsAllRewardsHasGet(_copyId))
            if effect == 0 then
                self.img_copy_select1:SetActive(true)
            else
                self.img_copy_select1:SetActive(false)
            end
        elseif _copyId == 2 then
            self.txt_copyName2.text = row.name
            self.copy_slider2.value = tonumber(v.totalHp) / tonumber(v.totalMaxHp)
            local temp = self.copy_slider2.value * 100
            self.lbl_CopyProcess_2.text = math.floor(temp) .. "%"
            self.Model_2:LoadByModelId(row.model, "stand", function() end, false, effect, row.big / 1000 * 1.3)
            --self.sp_get_2.gameObject:SetActive(self:IsAllRewardsHasGet(_copyId))
            if effect == 0 then
                self.img_copy_select2:SetActive(true)
            else
                self.img_copy_select2:SetActive(false)
            end
        elseif _copyId == 3 then
            self.txt_copyName3.text = row.name
            self.copy_slider3.value = tonumber(v.totalHp) / tonumber(v.totalMaxHp)
            local temp = self.copy_slider3.value * 100
            self.lbl_CopyProcess_3.text = math.floor(temp) .. "%"
            self.Model_3:LoadByModelId(row.model, "stand", function() end, false, effect, row.big / 1000 * 1.3)
            --self.sp_get_3.gameObject:SetActive(self:IsAllRewardsHasGet(_copyId))
            if effect == 0 then
                self.img_copy_select3:SetActive(true)
            else
                self.img_copy_select3:SetActive(false)
            end
        elseif _copyId == 4 then
            self.txt_copyName4.text = row.name
            self.copy_slider4.value = tonumber(v.totalHp) / tonumber(v.totalMaxHp)
            local temp = self.copy_slider4.value * 100
            self.lbl_CopyProcess_4.text = math.floor(temp) .. "%"
            self.Model_4:LoadByModelId(row.model, "stand", function() end, false, effect, row.big / 1000 * 1.3)
            --self.sp_get_4.gameObject:SetActive(self:IsAllRewardsHasGet(_copyId))
            if effect == 0 then
                self.img_copy_select4:SetActive(true)
            else
                self.img_copy_select4:SetActive(false)
            end
        end
    end
end

function m:refreashTreasureItems(...)
    print("..........go........")
    self:setTresureStatus()
    local sectionId = m:getRowByCopyid(curCopyBtnNo).id
    GuildDatas:downBoxListById(sectionId, function(args)
        self.boxList = args.result.list
        self:_refreashTreasureItems(args.result.list)
        self:showTheBoxlistinfo(args.result.list)
    end)

    --self:_refreashTreasureItems()
end

--显示单个BOSS已经领取了多少个箱子
function m:showTheBoxlistinfo(boxList)
    if boxList == nil then
        self.txt_boxinfo.text = ""
    else
        local boxcount = boxList.Count
        local boxgetcount = 0
        for i=0,boxcount-1 do
            if boxList[i] ~= 0 then
                boxgetcount = boxgetcount+1
            end
        end
        self.txt_boxinfo.text = TextMap.GetValue("Text1295")..boxgetcount.."/"..boxcount.."[-]"
    end
end


function m:_refreashTreasureItems(boxList)
    -- 读取掉落包
    local dropPage
    local _curChapterId = tonumber(GuildDatas:getMyGuildInfo().chapterProgressId)
    TableReader:ForEachLuaTable("Guild_chest_reward", function(index, item)
        local _chapterId = tonumber(item.chapter)
        local _copyId = tonumber(item.section)
        if _chapterId == _curChapterId and curCopyBtnNo == _copyId then
            dropPage = item
            return true
        end
        return false
    end)
    --print("----------------lzh---------------refreashTreasureItems-------")
    -- print(dropPage.drop.Count)
    if dropPage == nil or dropPage.drop == nil or dropPage.drop.Count == 0 then
        MessageMrg.show(TextMap.GetValue("Text1296"))
        return
    end
    -- 加工成自己要的数据
    local dropPageDatas = {}
    local pageCount = dropPage.drop.Count
    local index = 0
    for i = 0, pageCount - 1 do
        local times = dropPage.drop[i].times[0]
        for t = 1, times do
            local temp = {}
            temp.index = index
            temp.tableName = dropPage.drop[i].arg
            temp.tableId = dropPage.drop[i].arg2
            temp.boxList = boxList
            temp.isDead = self:IsBossDead(curCopyBtnNo)
            temp.copyId = curCopyBtnNo
            temp.delegate = self
            table.insert(dropPageDatas, temp)
            --print(temp.tableName)
            index = index + 1
        end
    end
    -- 刷新列表
    self.mygrid:refresh("Prefabs/moduleFabs/leagueModule/league_treasureItem", dropPageDatas, self, #dropPageDatas)
end

function m:onBtnCopy(copyId)
    if curCopyBtnNo == copyId then return end
    self:selectModeEffect(curCopyBtnNo, copyId)
    curCopyBtnNo = copyId
    self:refreashTreasureItems()
end

function m:IsBossDead(copyId)
    if self.isPass then
        return true
    end
    for k, v in pairs(self.copyDatas) do
        local _copyId = tonumber(v.copyId)
        if copyId == _copyId and v.totalHp <= 0 then
            return true
        end
    end
    return false
end

-- 领奖完成时，刷新ui
function m:onGetReward(...)
    -- body
    self:refreashTreasureItems()
end

-----------------------------------------------------
-- 获取公会复本一行数据
function m:getRowByCopyid(copyId)
    local row = {}
    TableReader:ForEachLuaTable("GuildCopy", function(index, item)
        local _chapterId = tonumber(item.chapterId)
        local _copyId = tonumber(item.copyId)
        if _chapterId == self.chapterId and copyId == _copyId then
            row = item
            return true
        end
        return false
    end)
    return row
end

return m