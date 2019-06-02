local RewardOne = require("uLuaModule/modules/activity/LuckyRoulette/RouleteeRewardOne.lua")
local RewardTen = require("uLuaModule/modules/activity/LuckyRoulette/RouleteeRewardTen.lua")

local m = {}

local item_list = {} --存储轮盘item列表
local ITEM_LENGTH = 10 --轮盘item的数量
local RADIUS = 100 --轮盘中心距离item的距离
local PER_ANGLE = 360 / ITEM_LENGTH --每个item相距的角度36

local cur_index = 1 --当前中奖的item的index,1-10
local last_index = 1 --上一次中奖的item的index,1-10

--可以配置的数据
local constant_angle = 360 * 6 --最少6圈
local rotate_time = 6 --旋转总时间

local REFRESH_TIMER = 0 
local base_num = 0

function m:Start(...)
    --同步服务器时间
    Api:checkRes(function(result)
    end)
    m:changeRoulette()
    local keyMap = self._keyMap
    table.foreach(keyMap, function(k, v)
        if self[k] then
            self[k].Url = UrlManager.GetImagesPath(v)
        end
    end)
    if self.curIcon == nil then
        local p = self.curScore.transform.parent

        self.curScore.transform.localPosition = Vector3(81, 0, 0)
        p:GetComponent(UILabel).text = TextMap.GetValue("Text453")
        self.curIcon = m:createSprite(p, Vector3(12, 1, 0))

        local p = self.costScoreOneTime.transform.parent
        self.costScoreOneTime.transform.localPosition = Vector3(81, 0, 0)

        p:GetComponent(UILabel).text = TextMap.GetValue("Text200")
        self.costIcon = m:createSprite(p, Vector3(12, 1, 0))
    end
    self:AddClick()
    self:InitItemPos()
    self.bgBox:SetActive(false)
end

function m:createSprite(p, pos)
    local sp = GameObject()
    sp.transform.parent = p
    sp.transform.localScale = Vector3.one
    sp.transform.localPosition = pos
    local spII = sp:AddComponent(UISpriteII)
    spII.depth = 9
    spII.width = 30
    spII.height = 30
    local custom = sp:AddComponent(CustomSprite)
    return custom
end

--刷新数据
function m:update(info)
    print("update==========")
    if info~=nil then 
        self.data = info.data
        self.delegate = info.delegate
        self.desc = self.data.desc
        self.point = self.data.point
        self.act_id = self.delegate.delegate.currentID
        self.status = self.data.status or 0
    end
    local _source_data = self.data._source_data
    local end_time = self.data.end_time
    --获取玩家积分
    local list = RewardMrg.getConsumeTable(_source_data.first_cost_sel)
    local it = list[1]
    if it == nil then
        print("没有配奖励")
        return
    end

    if it.count >= 100000 then
        it.count = math.floor(it.count /10000)..TextMap.GetValue("Text6")
    end
    local c = it.count
    if c == 0 then
        list = RewardMrg.getConsumeTable(_source_data.second_cost_sel)
        if #list > 0 then
            it = list[1]
            c = it.count
            if it.count >= 100000 then
                it.count = math.floor(it.count /10000)..TextMap.GetValue("Text6")
            end
            c = it.count
        end
    end
    self.curScore.text = c
    
    local img = it:getHeadSpriteName()
    local assets = packTool:getIconByName(img)

    self.curIcon:setImage(img, assets)
    self.costIcon:setImage(img, assets)

    self.costScoreOneTime.text = it.rwCount

    --每个奖励item
    for i, v in ipairs(item_list) do
        local item_bind = v
        local key = i .. ""
        local item = self.data.drop[i]
        if item then
            --传过去的就是drop里面的第1个道具
            item_bind:CallUpdate({ delegate = self, data = item[1], index = i })
        end
    end

    --积分奖励 add by jixinpeng
    local jifen_reward = self.data.dangwei
    if jifen_reward ~= nil then
        if self.jifen ~= nil then
            self.jifen:CallUpdate({reward = jifen_reward,delegate = self,point = self.point})
        end
    end

    --当前积分
    if self.point ~= nil then
        self.integralTimes.text = self.point
    end

    print("11111111111111111111111")
    if self.data.free_item ~= nil  and self.data.free_item ~= "" then --如果有道具,显示道具数量
        local temp = ""
        local item = self.data.free_item
        for k in string.gmatch(item, "(%a*)|") do
            temp = k
        end
        temp = temp.."|"
        local itemId = string.gsub(item, temp, "")
        print("itemId=============="..itemId)
        local havenum = Player.ItemBagIndex[itemId].count
        self.free.text = self.data.free_text
        print("self.data.free_text=============="..self.data.free_text)
        self.freeTimes.text = havenum
    else
        print("222222222222222222222")
        self.freeTimes.text = Player.Activity[self.act_id..""]['freeTimes'] or 0
    end
    if Player.Activity[self.act_id].drop~=nil  then 
        self.status=tonumber(Player.Activity[self.act_id].drop)
    end
    if self.status == 0 or self.status == 8 then --不可领
        self.sp_reward.spriteName = "icon_paihangjiangli"
        self.baoxiangqude:SetActive(false)
    elseif self.status == 1 then
        self.sp_reward.spriteName = "icon_lingqujiangli"
        self.baoxiangqude:SetActive(true)
    else
        self.sp_reward.spriteName = "icon_yilingqu"
        self.baoxiangqude:SetActive(false)
    end
    self.rewardList = self:getRewardList()
end


function m:changeRoulette()
    base_num=base_num+1
    if base_num>1 then 
        base_num=0
    end 
    if base_num==1 then
        self.roulette_base:SetActive(true)
        self.roulette_base1:SetActive(false)
    else 
        self.roulette_base:SetActive(false)
        self.roulette_base1:SetActive(true)
    end 
    self.binding:CallAfterTime(1,function ()
        m:changeRoulette()
    end)
end

--初始化各个item的位置和角度
function m:InitItemPos()
    for i = 1, ITEM_LENGTH do
        local itemGo = GameObject.Instantiate(self.itemModel)
        itemGo.transform.parent = self.items.transform
        itemGo.transform.localRotation = Quaternion.identity
        itemGo.transform.localScale = Vector3.one
        itemGo.name = "item" .. i

        local rad = PER_ANGLE / 180
        local pos_x = RADIUS * math.sin(rad * (i - 1) * math.pi)
        local pos_y = RADIUS * math.cos(rad * (i - 1) * math.pi)
        itemGo.transform.localPosition = Vector3(pos_x, pos_y, 0)
        itemGo.transform:Rotate(Vector3.back * PER_ANGLE * (i - 1))

        --获取item上的UluaBinding，保存到列表中
        local item_bind = itemGo:GetComponent(UluaBinding)
        table.insert(item_list, item_bind)
    end
    self.itemModel:SetActive(false)
end

--添加点击事件
function m:AddClick()
    ClientTool.AddClick(self.btn_start, self.btn_start_click)
    ClientTool.AddClick(self.btn_tenTimes, self.btn_tenTimes_click)
end

--抽奖十次按钮点击
function m:btn_tenTimes_click()
    m.bgBox:SetActive(true)
    Api:turnTableTen(m.delegate.delegate.currentID, function(result)
        local point = result.point
        local add_point = result.addPoint
        local resultTable = json.decode(result:toString())
        if resultTable.ret == 0 then
            local ids = resultTable.id
            m:showTenReward(ids)
            --播放音效
            MusicManager.playByID(54)
        else
            m.bgBox:SetActive(false)
        end
        if add_point ~= nil then
            m.binding:CallManyFrame(function()
                MessageMrg.show(TextMap.GetValue("Text457")..add_point)
                m.point=point
                m:update()
            end,130)
        end
    end, function(result)
        --error
        m.bgBox:SetActive(false)
        -- if result == 155 then	--155为活动积分不足
        -- 	DialogMrg.ShowDialog("活动积分不足，是否前往充值？", function()
        --           	DialogMrg.chognzhi()
        --       	end)
        -- 	return true 	--return true表示不用弹出提示
        -- end
        return false
    end)
end

--抽奖按钮点击
function m:btn_start_click()
    m.bgBox:SetActive(true)
    local that = self
    Api:turnTableOne(m.delegate.delegate.currentID, function(result)
        local point = result.point
        local add_point = result.addPoint
        local resultTable = json.decode(result:toString())
        if resultTable.ret == 0 then
            cur_index = resultTable.id[1]
            m:Rotate(0, rotate_time)
            --播放音效
            MusicManager.playByID(53)
        else
            m.bgBox:SetActive(false)
        end
        -- if point ~= nil then
        --     m.integralTimes.text = point
        -- end
        if add_point ~= nil then
            m.binding:CallManyFrame(function()
                --OperateAlert.getInstance:showToGameObject(ms, m.gameObject)
                MessageMrg.show(TextMap.GetValue("Text457")..add_point)
                --积分奖励 add by jixinpeng
                m.point=point
                m:update()
            end,200)
        end
    end, function(result)
        m.bgBox:SetActive(false)
        return false
    end)
end

function m:Rotate(angle, time)
    local delta_index = cur_index - last_index
    if delta_index > 0 then delta_index = ITEM_LENGTH - delta_index end
    if delta_index < 0 then delta_index = -delta_index end

    angle = constant_angle + PER_ANGLE * delta_index
    local tr = self.roulette.gameObject:GetComponent(TweenRotation)
    local src_z = self.roulette.gameObject.transform.localEulerAngles.z
    local dest_z = 0
    dest_z = -(angle + (360 - src_z))

    tr.to = Vector3(0, 0, dest_z)
    tr.duration = time
    tr:ResetToBeginning();
    tr.enabled = true;

    LuaTimer.Add(time * 1000, function()
        --旋转结束
        last_index = cur_index
        self:showOneReward()
    end)
end

--十连抽后面旋转
function m:TenRewardRotate(angle, time)
    local tr = self.roulette.gameObject:GetComponent(TweenRotation)
    local src_z = self.roulette.gameObject.transform.localEulerAngles.z
    local dest_z = 0
    dest_z = -(angle + (360 - src_z))

    tr.to = Vector3(0, 0, dest_z)
    tr.duration = time
    tr:ResetToBeginning();
    tr.enabled = true;
end

--显示抽取1次奖励
function m:showOneReward()
    LuaTimer.Add(500, function()
        --可以点击了
        m.bgBox:SetActive(false)

        --播放特效
        local id = cur_index
        local reward = self.data.drop[id][1] or {}
        RewardOne:show({ delegate = self, data = reward })
    end)
end

--显示抽取10次奖励
function m:showTenReward(ids)
    self:TenRewardRotate(3 * 360, 4.5)

    LuaTimer.Add(800, function()
        m.bgBox:SetActive(false)

        local reward_list = {}
        for i = 1, #ids do
            if i > ITEM_LENGTH then break end

            local id = ids[i]
            local reward = self.data.drop[id][1] or {}
            table.insert(reward_list, reward)
        end

        RewardTen:show({ delegate = self, list = reward_list })
    end)
end

function m:getRewardList()
    local tb = {}
    table.foreach(self.data.pointRank,function (k,v)
            local list = {}
            list.rank = k
            list.li = v
            local temp = {}
            k = k.."-"
            for a in string.gmatch(k, "(%d*)-") do
                table.insert(temp, a)
            end
            list.index = tonumber(temp[#temp])
            table.insert(tb,list)
    end)
    table.sort(tb,function (a,b)
            return a.index < b.index
    end)
    return tb
end


function m:onClick(go, name)
    if name == "btn_rule" then
        UIMrg:pushWindow("Prefabs/moduleFabs/qiancengta/qiancengta_rule", {10000,title = TextMap.GetValue("Text458"),rule = self.desc})
    elseif name == "btn_reward" then
        if self.status == 0 or self.status == 8 then --不可领时弹出排行
            UIMrg:pushWindow("Prefabs/moduleFabs/activityModule/act_rank_reward_info", self.rewardList)
        elseif self.status == 1 then --可领的时候直接领取
            Api:getActGift(self.act_id,nil,function (result)
               packTool:showMsg(result, nil, 1)
               self.status = 2
               self.baoxiangqude:SetActive(false)
               self.sp_reward.spriteName = "icon_yilingqu"
            end)
        end
    elseif name == "btn_jifen" then
        local that = self
        print("self.act_id=========="..self.act_id)
        Api:getTurnTableRank(self.act_id,function (result)
            local min = 0
            if that.rewardList ~= nil then
                min = that.rewardList[#that.rewardList].index
            end
            local list = {}
            local i = 0
            while result.ranklist[i] ~= nil do
                result.ranklist[i].index = i+1
                result.ranklist[i].min = min
                table.insert(list,result.ranklist[i])
                i = i + 1
            end
            print("list.count==============="..#list)
           UIMrg:pushWindow("Prefabs/moduleFabs/activityModule/act_turnTable_rankList", { list = list, me = result.self})
        end)
    end
end

return m