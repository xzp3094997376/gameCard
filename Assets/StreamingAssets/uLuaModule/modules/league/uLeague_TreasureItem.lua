-- 0,表示boss还没有被干掉,不能领取 1,表示已经被别人领取,你不能领取 
-- 2,表示你自己已经领取，你不能再领取 3，表示你可以领取
local m = {}

function m:update(data)
    -- print("*************")
    -- print(data)
    -- print(data.boxList)
    -- print("*************")
    self.data = data
    self.status = self:getBoxRewardStatus()
    self:refreashUI()
end

function m:setData(...)
    self.status = self:getBoxRewardStatus()
    self:refreashUI()
end

function m:refreashUI(...)
    if self.status == 1 or self.status == 2 then
        self.img_divide.gameObject:SetActive(false)
        if self.itemAll == nil then
            self.itemAll = ClientTool.loadAndGetLuaBindingFromPool("Prefabs/publicPrefabs/itemAll", self.boxSprite.gameObject)
        end
        local drop = self.data.boxList[self.data.index].reward
        self.itemAll:CallUpdate({ "char", drop, self.boxSprite.width, self.boxSprite.height, true, nil})
    else
        self.img_divide.gameObject:SetActive(true)
    end
end

function m:onClick(go, btnName)
    if btnName == "itsBtn" then
        if self.status == 0 then
            MessageMrg.show(TextMap.GetValue("Text1297"))
        elseif self.status == 1 then
            --MessageMrg.show("这个宝箱已经被别人领取")
            local datas = {}
            datas.isOther = true
            -- print("---------------------------------")
            -- print(self.data.boxList[0])
            print(self.data.boxList[self.data.index])
            datas.drop = self.data.boxList[self.data.index].reward
            datas.name = self.data.boxList[self.data.index].name
            datas.delegate = self.delegate
            UIMrg:pushWindow("Prefabs/moduleFabs/leagueModule/league_TreasureRewardBox", datas)
        elseif self.status == 2 then
            MessageMrg.show(TextMap.GetValue("Text1298"))
        elseif self.status == 3 then
            self:onGetBoxReward()
        end

        --UIMrg:pushWindow("Prefabs/moduleFabs/leagueModule/league_TreasureRewardBox", {})
    end
end

-- 领取宝箱的奖励
function m:onGetBoxReward(...)
    local sectionId = self.data.delegate:getRowByCopyid(self.data.copyId).id
    print("--------------onGetBoxReward-----------------------")
    print(sectionId)
    Api:getBoxRewardById(sectionId, self.data.index, function(result)
        local ret = tonumber(result.ret)
        if ret == 0 then
            --MessageMrg.show(TextMap.GetValue("Text1168"))
            packTool:showMsg(result, nil, 1)
            self.data.delegate:refreashTreasureItems()
        else
            GuildDatas:ShowTipByReturnCode_dh(ret)
        end
    end, function()
    end)
end

function m:showRewardBox(isOther, drop)
    local ms = {}
    table.foreach(drop, function(i, v)
        local g = {}
        g.type = v:getType()
        g.icon = "resource_fantuan"
        g.text = v.rwCount
        g.goodsname = v.name
        table.insert(ms, g)
        g = nil
    end)

    OperateAlert.getInstance:showGetGoods(ms, UIMrg.top)
    --local data = {}
    --data.isOther = isOther
    --data.drop = drop
    --UIMrg:pushWindow("Prefabs/moduleFabs/leagueModule/league_TreasureRewardBox", data)
end

--初始化
function m:create(binding)
    self.binding = binding
    return self
end


---------------------------------------------------
-- 0,表示boss还没有被干掉,不能领取 1,表示已经被别人领取,你不能领取 
-- 2,表示你自己已经领取，你不能再领取 3，表示你可以领取
function m:getBoxRewardStatus(...)
    if self.data.isDead == false then
        return 0
    end

    local box = self.data.boxList[self.data.index]
    if box ~= nil and box ~= 0 then
        return 1
    end

    local box2 = GuildDatas:getGuildRewardStatusBox()
    local count = box2.Count
    local sectionId = self.data.delegate:getRowByCopyid(self.data.copyId).id
    for i = 0, count - 1 do
        if sectionId == box2[i] then
            return 2
        end
    end

    return 3
end



return m