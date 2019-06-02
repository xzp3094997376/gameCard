-- 宝藏预览页面
local m = {}
local curTabNo = 1

function m:Start()
    curTabNo = 1
end

function m:update(args)
    self.copyDatas = args.copyDatas
    self.chapterId = args.chapterId
    m:updateDate(1)
    self:InitCopyBtns()
    self:refreashTreasureItems()
end

function m:onClick(go, btnName)
    if btnName == "btn_close" then
        UIMrg:popWindow()
    elseif btnName == "btn_1" then
        self:onBtnCopy(1)
    elseif btnName == "btn_2" then
        self:onBtnCopy(2)
    elseif btnName == "btn_3" then
        self:onBtnCopy(3)
    elseif btnName == "btn_4" then
        self:onBtnCopy(4)
    end
    --MessageMrg.show(btnName)
end

function m:onBtnCopy(copyId)
    if curTabNo == copyId then return end
    curTabNo = copyId
    m:updateDate(copyId)
    self:refreashTreasureItems()
end

function m:updateDate(num)
    for i=1,4 do
        if i==num then 
            self["check" .. i]:SetActive(true)
        else 
            self["check" .. i]:SetActive(false)
        end 
    end
end

-- 初始化四个复本按钮信息
function m:InitCopyBtns(...)
    for k, v in pairs(self.copyDatas) do
        local _copyId = tonumber(v.copyId)
        local row = GuildDatas:getCopyDataByCopyid(_copyId, self.chapterId)
        if _copyId == 1 then
            self.lbl_1.text = row.name
            self.lbl_check1.text = row.name
        elseif _copyId == 2 then
            self.lbl_2.text = row.name
            self.lbl_check2.text = row.name
        elseif _copyId == 3 then
            self.lbl_3.text = row.name
            self.lbl_check3.text = row.name
        elseif _copyId == 4 then
            self.lbl_4.text = row.name
            self.lbl_check4.text = row.name
        end
    end
end

function m:refreashTreasureItems(...)
    local sectionId = GuildDatas:getCopyDataByCopyid(curTabNo, self.chapterId).id
    GuildDatas:downBoxListById(sectionId, function(args)
        print("xxxxxxxxxxxxxxx")
        print(args)
        self:_refreashTreasureItems(args.result.list)
    end)

    --self:_refreashTreasureItems()
end

function m:_refreashTreasureItems(boxList)
    -- 读取掉落包
    local dropPage = nil
    local _curChapterId = tonumber(self.chapterId)
    TableReader:ForEachLuaTable("Guild_chest_reward", function(index, item)
        local _chapterId = tonumber(item.chapter)
        local _copyId = tonumber(item.section)
        if _chapterId == _curChapterId and curTabNo == _copyId then
            dropPage = item
            return true
        end
        return false
    end)
    print("----------------lzh---------------refreashTreasureItems-------")
    print(dropPage.drop.Count)
    if dropPage == nil or dropPage.drop == nil or dropPage.drop.Count == 0 then
        MessageMrg.show(TextMap.GetValue("Text1296"))
        return
    end
    -- 加工成自己要的数据
    local dropPageDatas = {}
    local pageCount = dropPage.drop.Count
    for i = 0, pageCount - 1 do
        local times = tonumber(dropPage.drop[i].times[0])
        local temp = {}
        temp.tableName = dropPage.drop[i].arg
        temp.tableId = dropPage.drop[i].arg2
        temp.bagTotalNums = times
        temp.bagCurNums = 0 --掉落包中的当前数量
        temp.boxList = boxList
        temp.copyId = curTabNo
        temp.index = i
        table.insert(dropPageDatas, temp)
        print(temp.tableName)
    end
    -- 刷新列表
    self.mygrid:refresh("Prefabs/moduleFabs/leagueModule/league_treasurePreviewItem", dropPageDatas, self, #dropPageDatas)
end

return m