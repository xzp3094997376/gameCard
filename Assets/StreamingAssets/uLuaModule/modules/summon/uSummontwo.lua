local Reward = require("uLuaModule/modules/summon/uSummonReward.lua")
local RewardTen = require("uLuaModule/modules/summon/uSummonRewardTen.lua")

local summontwo = {}

local summonModuleName = 'summon'
--local REFRESH_TIMER = "refreshTimer"
--local REFRESH_SP_TIMER = "refreshSpTimer"
local REFRESH_TIMER = 0
local REFRESH_SP_TIMER = 0
local REFRESH_SCROLL = 0

--字符
local NO_FREE = TextMap.GetValue("Text1425")
local FREE_TIMES = TextMap.GetValue("Text1426")
local FREE_THIS_TIME = TextMap.GetValue("Text1427")
local TXT_FREE = TextMap.GetValue("Text1428")

local imgZiSe = "zhaohuan/ZhanhuanText_1.png"
local imgChengSe = "zhaohuan/ZhaohuanText_2.png"

--[[
1   银币抽卡
6   银币十连抽
4   银币免费
2   金币抽卡
3   金币十连抽
5   金币免费
]]

local DrawId = {
    NorOneFree = 4,
    NorOne = 1,
    NorTen = 6,
    SpOneFree = 5,
    SpOne = 2,
    SpTen = 3
}


--每天总共免费次数
local FREE_TIMES_COUNT = 5
--钻石抽卡循环

local GOLD_DRAW_LOOP = 10
local GOLD_DRAW_LOOP_CHENG = 10

--金币抽卡循环

local MONEY_DRAW_LOOP = 10
local MONEY_DRAW_LOOP_CHENG = 10

--关闭
function summontwo:OnDestroy()
    --    UluaModuleFuncs.Instance.uTimer:removeSecondTime(REFRESH_TIMER)
    --    UluaModuleFuncs.Instance.uTimer:removeSecondTime(REFRESH_SP_TIMER)
    LuaTimer.Delete(REFRESH_SP_TIMER)
    LuaTimer.Delete(REFRESH_TIMER)
    LuaTimer.Delete(REFRESH_SCROLL)
    self.topMenu = LuaMain:ShowTopMenu(1, nil)
end

function summontwo:OnDisable()
    print ("OnDisable")
    LuaTimer.Delete(REFRESH_SP_TIMER)
    LuaTimer.Delete(REFRESH_TIMER)
    LuaTimer.Delete(REFRESH_SCROLL)
    self.topMenu = LuaMain:ShowTopMenu(1, nil)
end


--更新普通抽卡免费时间
function summontwo:updateNorTime()
    LuaTimer.Delete(REFRESH_TIMER)
    REFRESH_TIMER = LuaTimer.Add(0, 1000, function(id)
        if self.binding == nil then return false end
        if self.time > 0 then
            local time = Tool.FormatTime(self.time)
            time = string.gsub(TextMap.GetValue("LocalKey_759"),"{0}",time)
            self.labNorFreeTimes.text = time
            self.labNorCost.gameObject:SetActive(true)
            self.labNorFree.gameObject:SetActive(false)
            -- self.labNorFreeTimesExtend.text = time
        else
            --倒计时结束
            --        UluaModuleFuncs.Instance.uTimer:removeSecondTime(REFRESH_TIMER)
            local time = ""
            if self.norCurTime == 0 then
                --次数用完
                time = NO_FREE
                self.labNorCost.gameObject:SetActive(true)
                self.labNorFree.gameObject:SetActive(false)
                self.icon_money1.gameObject:SetActive(true)
                self.NorDrawOne = DrawId.NorOne --花钱单抽

                -- self.icon_money:SetActive(true)
                -- self.txt_price_money.text = self.cost_money
            else
                time = FREE_TIMES .. self.norCurTime .. "/" .. FREE_TIMES_COUNT
                self.labNorCost.gameObject:SetActive(false)
                self.labNorFree.gameObject:SetActive(true)
                self.icon_money1.gameObject:SetActive(false)
                self.NorDrawOne = DrawId.NorOneFree --免费抽卡
            end
            self.labNorFreeTimes.text = time
            -- self.labNorFreeTimesExtend.text = time

            --免费
            return false
        end
        local CdTime = Player.CdTime or {}
        self.time = ClientTool.GetNowTime(CdTime.moneyfree)
        return true
    end)
end

--更新钻石抽卡免费时间
function summontwo:updateSpTime()
    LuaTimer.Delete(REFRESH_SP_TIMER)
    REFRESH_SP_TIMER = LuaTimer.Add(0, 1000, function(id)
        if self.binding == nil then return false end
        if self.sp_time > 0 then
            local time = Tool.FormatTime(self.sp_time)
            time = string.gsub(TextMap.GetValue("LocalKey_759"),"{0}",time)
            self.labSpFreeTimes.text = time
            self.labSpCost.gameObject:SetActive(true)
            self.labSpFree.gameObject:SetActive(false)
            self.icon_gold1.gameObject:SetActive(true)
            -- self.labSpFreeTimesExtend.text = time
            -- self.icon_gold:SetActive(true)
            -- self.txt_price_gold.text = self.cost_gold
        else
            --倒计时结束
            --        UluaModuleFuncs.Instance.uTimer:removeSecondTime(REFRESH_SP_TIMER)

            self.labSpFreeTimes.text = FREE_THIS_TIME
            -- self.labSpFreeTimesExtend.text = FREE_THIS_TIME

            --免费
            self.labSpCost.gameObject:SetActive(false)
            self.labSpFree.gameObject:SetActive(true)
           
            self.icon_gold1.gameObject:SetActive(false)
            self.SpDrawOne = DrawId.SpOneFree --钻石免费单抽

            -- self.txt_price_gold.text = TXT_FREE
            -- self.icon_gold:SetActive(false)
            return false
        end
        local CdTime = Player.CdTime or {}

        self.sp_time = ClientTool.GetNowTime(CdTime.goldfree)
        return true
    end)
end

--开始普通抽卡倒计时
function summontwo:startNorTime(time)
    self.time = time or 0
    if self.time <= 0 and self.norCurTime > 0 then
        self.labNorCost.gameObject:SetActive(false)
        self.labNorFree.gameObject:SetActive(true)
        self.icon_money1.gameObject:SetActive(false)

        -- self.icon_money:SetActive(false)
        -- self.txt_price_money.text = TXT_FREE

        self.NorDrawOne = DrawId.NorOneFree --免费抽卡
        self:updateNorTime()
    else
        self.labNorCost.gameObject:SetActive(true)
        self.labNorFree.gameObject:SetActive(false)
        self.icon_money1.gameObject:SetActive(true)

        -- self.icon_money:SetActive(true)
        -- self.txt_price_money.text = self.cost_money

        --        UluaModuleFuncs.Instance.uTimer:removeSecondTime(REFRESH_TIMER)
        if self.norCurTime > 0 then
            self:updateNorTime() --定时器
        else
            self.time = 0
            self:updateNorTime()
        end

        self.NorDrawOne = DrawId.NorOne --花钱单抽
    end
end

--开始钻石抽卡倒计时
function summontwo:startSpTime(time)
    self.sp_time = time or 0
    if self.sp_time <= 0 then
        --        self.labSpCost:SetActive(false)
        --        self.labSpFree:SetActive(true)
        self.labSpFree.gameObject:SetActive(true)
        self.labSpCost.gameObject:SetActive(false)
        self.icon_gold1.gameObject:SetActive(false)
        self.SpDrawOne = DrawId.SpOneFree --钻石免费单抽
        self:updateSpTime()
    else
        --        self.labSpCost:SetActive(true)
        --        self.labSpFree:SetActive(false)
        self.labSpFree.gameObject:SetActive(false)
        self.labSpCost.gameObject:SetActive(true)
        self.icon_gold1.gameObject:SetActive(true)

        --        UluaModuleFuncs.Instance.uTimer:removeSecondTime(REFRESH_SP_TIMER)
        --        UluaModuleFuncs.Instance.uTimer:secondTime(REFRESH_SP_TIMER, 1, 0, self.updateSpTime, self) --定时器
        self:updateSpTime()
        self.SpDrawOne = DrawId.SpOne --钻石单抽
    end
end


--普通单抽
function summontwo:onNorSummon(go, bind)
    local that = self
    self:activeEvent(true)
    Api:draw(self.NorDrawOne, function(result)
        summontwo:checkFristDraw()
        self:hideOrShowEffect(false)
        local lua = {
            delegate = that,
            result = result,
            cbAgin = funcs.handler(that, that.onNorSummon),
            darw_id = that.NorDrawOne,
            cost_type = 'money',
            cost = that.cost_money,
            cost_icon =that.cost_money_icon,
            consume=self.consume_money
        }
        if bind then
            bind:update(lua)
        else
            Reward:show(lua)
        end
        self:activeEvent(false)
        that:update()
    end, function()
        that:activeEvent(false)
        return false
    end)
end

--普通十连抽
function summontwo:onNorSummonTen(go, bind)
    local that = self
    self:activeEvent(true)
    Api:draw(DrawId.NorTen, function(result)
        self:hideOrShowEffect(false)
        local lua = {
            delegate = that,
            result = result,
            cbAgin = funcs.handler(that, that.onNorSummonTen),
            darw_id = DrawId.NorTen,
            cost_type = 'money',
            cost = that.cost_money_ten,
            cost_icon =that.cost_money_icon,
            consume=self.consume_money
        }
        --        RewardTen:show(result, funcs.handler(that, that.onNorSummonTen), DrawId.NorTen,that.cost_money_ten)
        if bind then
            bind:update(lua)
        else
            RewardTen:show(lua)
        end
        --packTool:showMsg(result, nil, 1)
        self:activeEvent(false)
        that:update()
    end, function()
        that:activeEvent(false)
        return false
    end)
end

--钻石单抽
function summontwo:onSpSummon(go, bind)
    local that = self
    self:activeEvent(true)
    Api:draw(self.SpDrawOne, function(result)
        summontwo:checkFristDraw()
        self:hideOrShowEffect(false)
        --        Reward:show(result, funcs.handler(that, that.onSpSummon), that.SpDrawOne,that.cost_gold)
        local lua = {
            delegate = that,
            result = result,
            cbAgin = funcs.handler(that, that.onSpSummon),
            darw_id = that.SpDrawOne,
            cost_type = 'gold',
            cost = that.cost_gold,
            cost_icon =that.cost_gold_icon,
            consume=self.consume_gold
        }
        if bind then
            bind:update(lua)
        else
            Reward:show(lua)
        end
        self:activeEvent(false)
        that:update()
    end, function()
        that:activeEvent(false)
        return false
    end)
end

function summontwo:hideOrShowEffect(isShow)
    --    isShow = isShow or false
    --    if self.effect1 then
    --        self.effect1:SetActive(isShow);
    --    end
    --    if self.effect2 then
    --        self.effect2:SetActive(isShow);
    --    end
end

--钻石十连抽
function summontwo:onSpSummonTen(go, bind)
    local that = self
    self:activeEvent(true)
    Api:draw(DrawId.SpTen, function(result)
        self:hideOrShowEffect(false)
        --        RewardTen:show(result, funcs.handler(that, that.onSpSummonTen), DrawId.SpTen,that.cost_gold_ten)
        local lua = {
            delegate = that,
            result = result,
            cbAgin = funcs.handler(that, that.onSpSummonTen),
            darw_id = DrawId.SpTen,
            cost_type = 'gold',
            cost = that.cost_gold_ten,
            cost_icon =that.cost_gold_icon,
            consume=self.consume_gold
        }
        if bind then
            bind:update(lua)
        else
            RewardTen:show(lua)
        end
        self:activeEvent(false)
        that:update()
    end, function()
        that:activeEvent(false)
        return false
    end)
end

function summontwo:activeEvent(ret)
    if ret == false then
        local that = self
        self.binding:CallAfterTime(0.1, function()
            that.eventMake:SetActive(false)
        end)
    else
        self.eventMake:SetActive(true)
    end
end

function summontwo:onUpdate()
    self:update()
end

function summontwo:onClick(go, name)
    print(name)
    if name == "btnNorSummon" then
        if Tool:judgeBagCount(self.dropTypeList) == false then return end
        self:onNorSummon(go)
    elseif name == "btnNorSummonTen" then
        if Tool:judgeBagCount(self.dropTypeList) == false then return end
        self:onNorSummonTen(go)
    elseif name == "btnSpSummon" then
        if not GuideMrg:isPlaying() then
            if Tool:judgeBagCount(self.dropTypeList) == false then return end
            self:onSpSummon(go)
        end
    elseif name == "btnSpSummonTen" then
        if Tool:judgeBagCount(self.dropTypeList) == false then return end
        self:onSpSummonTen(go)
    elseif name == "btnBack" then
        Events.Brocast('update_summon_date')
        UIMrg:pop()
    end
end

--初始化
function summontwo:create(binding)
    self.binding = binding
    self.gameObject = self.binding.gameObject
    return self
end

function summontwo:onEnter()
    print("update__onEnter")
    self:hideOrShowEffect(true)
    self:update()
end

function summontwo:OnEnable()
    print("OnEnable")
    self:hideOrShowEffect(true)
    self:update()
end

local isStart = true
local currt_pos = 0
local target_pos = 0
local fangxiang ="Left"
function summontwo:Scorllupdate()
    --local chars = Player.Chars:getLuaTable()
    local chars = {}
    local charsList = {}
    local hasChar = {}
    local index = 1

     TableReader:ForEachLuaTable("drawShow", function(index, item)
        if self._choukaType == "renzhe" then
            if item.type==1 then
                table.insert(chars, item)
            end
        elseif self._choukaType == "shenren" then
            if item.type==2 then
                table.insert(chars, item)
            end
        elseif self._choukaType == "zhenying" then
            if item.type==2 then
                table.insert(chars, item)
            end 
        end
        return false
    end)

    for k, v in pairs(chars) do
        local cell = v.showchar[0]
        local char = RewardMrg.getDropItem({type=cell.type,arg=cell.showchar,arg1=1})
        char.des=v.desc
        charsList[index] = char
        hasChar[char.id] = true
        index = index + 1
    end
    
    for i=1, index-1 do
        local randNum = math.random(1, index-2)
        charsList[i],charsList[randNum]=charsList[randNum],charsList[i]
    end

    local list = charsList
    local count = index-1
    
    for i=1,20 do
        for m =1,count do
            table.insert(charsList, list[m])
            index = index + 1
        end
    end
    self.scrollView.gameObject:SetActive(true)
    self.view.gameObject:SetActive(true)
    self.scrollView:refresh(charsList, self, false,0)
    currt_pos = self.trans.transform.localPosition.x
    target_pos = currt_pos-(index-2)*500
    fangxiang ="Left"
    isStart=false
    --[[LuaTimer.Delete(REFRESH_SCROLL)
        REFRESH_SCROLL = LuaTimer.Add(0,1, function(id)
            if fangxiang =="Left" then
                self.view:MoveRelative (Vector3(-1,0,0))
                if self.trans.transform.localPosition.x<=target_pos then
                    fangxiang ="Right" 
                end
            elseif fangxiang =="Right" then
                self.view:MoveRelative (Vector3(1,0,0))
                if self.trans.transform.localPosition.x>=currt_pos then
                    fangxiang ="Left" 
                end
            end
        end)]]

end


function summontwo:update(data)

    if data ~= nil then
        print (data._choukaType)
        self._choukaType = data._choukaType
        if self._choukaType == "renzhe" then
            self.BlockFirst:SetActive(true)
            self.BlockSecond:SetActive(false)
        elseif self._choukaType == "shenren" then
            self.BlockFirst:SetActive(false)
            self.BlockSecond:SetActive(true)
        end
        self:Scorllupdate()
    end

    self.dropTypeList = {"char"}
    
    self:myStart()
    local times = Player.Times or {}
    self.norCurTime = times.moneytime or 0; --免费次数


    local CdTime = Player.CdTime or {}
    local nTime = ClientTool.GetNowTime(CdTime.moneyfree)
    local sTime = ClientTool.GetNowTime(CdTime.goldfree)
    self:startNorTime(nTime)
    self:startSpTime(sTime)

    local i = 0
    local consume=TableReader:TableRowByID("draw", DrawId.NorOne).consume[i]
    self.consume_money=consume
    if consume.consume_type=="gold" or consume.consume_type=="money" then 
        local ziyuan=Tool.getCountByType(consume.consume_type)
        local ziyuanTxt=toolFun.moneyNumberShowOne(math.floor(tonumber(ziyuan)))
        if self.cost_money<=ziyuan then 
            self.labNorCost.text ="[ffffff]" .. ziyuanTxt .. "/" .. self.cost_money .."[-]"
        else 
            self.labNorCost.text ="[ff0000]" .. ziyuanTxt .. "/" .. self.cost_money .."[-]"
        end
        if self.cost_money_ten<=ziyuan then 
            self.labNorCostTen.text ="[ffffff]" .. ziyuanTxt .. "/" .. self.cost_money_ten .."[-]"
        else 
            self.labNorCostTen.text ="[ff0000]" .. ziyuanTxt .. "/" .. self.cost_money_ten .."[-]"
        end
    elseif consume.consume_type=="item" then 
        local ziyuan=Player.ItemBagIndex[consume.consume_arg].count
        if self.cost_money<=ziyuan then 
            self.labNorCost.text ="[ffffff]" .. ziyuan .. "/" .. self.cost_money .."[-]"
        else 
            self.labNorCost.text ="[ff0000]" .. ziyuan .. "/" .. self.cost_money .."[-]"
        end
        if self.cost_money_ten<=ziyuan then 
            self.labNorCostTen.text ="[ffffff]" .. ziyuan .. "/" .. self.cost_money_ten .."[-]"
        else 
            self.labNorCostTen.text ="[ff0000]" .. ziyuan .. "/" .. self.cost_money_ten .."[-]"
        end
    end

    local consume1=TableReader:TableRowByID("draw", DrawId.SpOne).consume[i]
    self.consume_gold=consume1
    if consume1.consume_type=="gold" or consume1.consume_type=="money" then 
        local ziyuan=Tool.getCountByType(consume1.consume_type)
        local ziyuanTxt=toolFun.moneyNumberShowOne(math.floor(tonumber(ziyuan)))
        if self.cost_gold<=ziyuan then 
            self.labSpCost.text ="[ffff96]" .. ziyuanTxt .. "/" .. self.cost_gold .."[-]"
        else 
            self.labSpCost.text ="[ff0000]" .. ziyuanTxt .. "/" .. self.cost_gold .."[-]"
        end
        if self.cost_gold_ten<=ziyuan then 
            self.labSpCostTen.text ="[ffff96]" .. ziyuanTxt .. "/" .. self.cost_gold_ten .."[-]"
        else 
            self.labSpCostTen.text ="[ff0000]" .. ziyuanTxt .. "/" .. self.cost_gold_ten .."[-]"
        end
    elseif consume1.consume_type=="item" then 
        local ziyuan=Player.ItemBagIndex[consume1.consume_arg].count
        if self.cost_gold<=ziyuan then 
            self.labSpCost.text ="[ffff96]" .. ziyuan .. "/" .. self.cost_gold .."[-]"
        else 
            self.labSpCost.text ="[ff0000]" .. ziyuan .. "/" .. self.cost_gold .."[-]"
        end
        if self.cost_gold_ten<=ziyuan then 
            self.labSpCostTen.text ="[ffff96]" .. ziyuan .. "/" .. self.cost_gold_ten .."[-]"
        else 
            self.labSpCostTen.text ="[ff0000]" .. ziyuan .. "/" .. self.cost_gold_ten .."[-]"
        end
    end

    --按钮上字的显示
   -- self.labNorCost.text = self.cost_money
    --self.labNorCostTen.text = self.cost_money_ten

    --self.labSpCost.text = self.cost_gold
   -- self.labSpCostTen.text = self.cost_gold_ten
    --抽多少次必得xx
    if self._choukaType == "renzhe" then
        local count = Player.Times.totalMdraw  + 1
        local num = count % MONEY_DRAW_LOOP
        if num == MONEY_DRAW_LOOP_CHENG then
         --必得橙卡
            self.msg.text = TextMap.GetValue("Text_1_2791")
        elseif num == 0 and count > 0 then
            self.msg.text = TextMap.GetValue("Text_1_2792")
        else
          --多少次后得橙卡
            if num == 0 then num = 1 end
            self.msg.text = TextMap.GetValue("Text_1_2793") .. GOLD_DRAW_LOOP_CHENG - num .. TextMap.GetValue("Text_1_2794")
        end
    else 
        local count = Player.Times.totalGdraw + 1
        local num = count % GOLD_DRAW_LOOP
        if num == GOLD_DRAW_LOOP_CHENG then
            --必得橙卡
            self.msg.text = TextMap.GetValue("Text_1_2795")
        elseif num == 0 and count > 0 then
            self.msg.text = TextMap.GetValue("Text_1_2797")
        else
           --多少次后得橙卡
           if num == 0 then num = 1 end
           self.msg.text = TextMap.GetValue("Text_1_2793") .. GOLD_DRAW_LOOP_CHENG - num .. TextMap.GetValue("Text_1_2796")
        end
    end
    self:activeEvent(false)
    self.topMenu = LuaMain:ShowTopMenu(4, nil)
end

function summontwo:checkFristDraw()
    local times = Player.Times
    local labSp = self.btnSpSummon:GetComponentInChildren(UILabel)
    local labNor = self.btnNorSummon:GetComponentInChildren(UILabel)

    --if times.firstgold ~= 1 then
    --    labSp.text = "必得橙卡"
    --else
        labSp.text = TextMap.GetValue("Text1430")
    --end

    --if times.firstmoney ~= 1 then
    --    labNor.text = TextMap.GetValue("Text1429")
    --else
        labNor.text = TextMap.GetValue("Text1430")
    --end
end

function summontwo:addTexture(p, name, w, h, img, depth, pos)
    local go = NGUITools.AddChild(p.gameObject)
    go.name = name
    local tx = go:AddComponent(UITexture)
    tx.depth = depth or 5
    tx.width = w
    tx.height = h
    go.transform.localPosition = pos
    local simple = go:AddComponent(SimpleImage)
    simple.Url = img
    return simple
end

function summontwo:createLab(p, name, depth, pos)
    local go = NGUITools.AddChild(p.gameObject)
    go.name = name
    go.transform.localPosition = pos
    local lab = go:AddComponent(UILabel)
    lab.depth = depth or 5
    lab.fontSize = 12
    local font = ClientTool.Pureload("AllAtlas/fontAltlas/vip_font")
    font = font:GetComponent(UIFont)
    lab.bitmapFont = font
    lab.text = 10
    return lab
end

function summontwo:fixedImage()
    local node = self.gameObject.transform:Find("BlockSecond/sp_title/Texture")
    Tool.SetActive(node, false)
    local p1 = node.parent
    --self.img_color = summontwo:addTexture(p1, "Texture", 419, 164, imgZiSe, 11, Vector3(0, -90, 0))
    --self.gold_draw_now = summontwo:addTexture(p1, "gold_draw_now", 174, 58, UrlManager.GetImagesPath("zhaohuan/zhaoHuan_now.png"), 9, Vector3(-95, -70, 0))
    --self.gold_draw_times = summontwo:addTexture(p1, "gold_draw_times", 174, 58, UrlManager.GetImagesPath("zhaohuan/zhaoHuan_times.png"), 10, Vector3(-95, -70, 0))

    --self.lab_drawTimes = summontwo:createLab(p1, "lab_drawTimes", 12, Vector3(-95, -62, 0))
end

function summontwo:myStart()
    imgZiSe = UrlManager.GetImagesPath(imgZiSe)
    imgChengSe = UrlManager.GetImagesPath(imgChengSe)
    summontwo:fixedImage()
    self.labNorFreeTimes.text = ""
    self.labSpFreeTimes.text = ""
    self.time = 0
    LuaMain:ShowTopMenu()
    local i = 0
    local consume=TableReader:TableRowByID("draw", DrawId.NorOne).consume[i]
    if consume.consume_type=="gold" or consume.consume_type=="money" then 
        self.cost_money = TableReader:TableRowByID("draw", DrawId.NorOne).consume[i].consume_arg
        self.cost_money_ten = TableReader:TableRowByID("draw", DrawId.NorTen).consume[i].consume_arg
        local iconName = Tool.getResIcon(consume.consume_type)
        self.icon_money1.Url=UrlManager.GetImagesPath("itemImage/" .. iconName.. ".png")
        self.icon_money2.Url=UrlManager.GetImagesPath("itemImage/" .. iconName.. ".png")
        self.cost_money_icon=iconName
    elseif consume.consume_type=="item" then 
        self.cost_money = TableReader:TableRowByID("draw", DrawId.NorOne).consume[i].consume_arg2
        self.cost_money_ten = TableReader:TableRowByID("draw", DrawId.NorTen).consume[i].consume_arg2
        local item = TableReader:TableRowByID("item", consume.consume_arg)
        self.icon_money1.Url=UrlManager.GetImagesPath("itemImage/" .. item.iconid.. ".png")
        self.icon_money2.Url=UrlManager.GetImagesPath("itemImage/" .. item.iconid.. ".png")
        self.cost_money_icon=item.iconid
    end

    local consume1=TableReader:TableRowByID("draw", DrawId.SpOne).consume[i]
    if consume1.consume_type=="gold" or consume1.consume_type=="money" then 
        self.cost_gold = TableReader:TableRowByID("draw", DrawId.SpOne).consume[i].consume_arg
        self.cost_gold_ten = TableReader:TableRowByID("draw", DrawId.SpTen).consume[i].consume_arg
        local iconName1 = Tool.getResIcon(consume1.consume_type)
        self.icon_gold1.Url=UrlManager.GetImagesPath("itemImage/" .. iconName1.. ".png")
        self.icon_gold2.Url=UrlManager.GetImagesPath("itemImage/" .. iconName1.. ".png")
        self.cost_gold_icon=iconName1
    elseif consume1.consume_type=="item" then 
        self.cost_gold = TableReader:TableRowByID("draw", DrawId.SpOne).consume[i].consume_arg2
        self.cost_gold_ten = TableReader:TableRowByID("draw", DrawId.SpTen).consume[i].consume_arg2
        local item1 = TableReader:TableRowByID("item", consume1.consume_arg)
        self.icon_gold1.Url=UrlManager.GetImagesPath("itemImage/" .. item1.iconid.. ".png")
        self.icon_gold2.Url=UrlManager.GetImagesPath("itemImage/" .. item1.iconid .. ".png")
        self.cost_gold_icon=item1.iconid
    end

    
    local row = TableReader:TableRowByID("drawSetting", 7)
    if row then
        FREE_TIMES_COUNT = row.arg2
    end
    row = TableReader:TableRowByID("drawSetting", 2)
    if row then
        GOLD_DRAW_LOOP = row.arg1
    end

    row = TableReader:TableRowByID("drawSetting", 4)
    if row then
        GOLD_DRAW_LOOP_CHENG = row.arg1
    end
     row = TableReader:TableRowByID("drawSetting", 1)
    if row then
        MONEY_DRAW_LOOP = row.arg1
    end

    row = TableReader:TableRowByID("drawSetting", 9)
    if row then
        MONEY_DRAW_LOOP_CHENG = row.arg1
    end
    --Api:checkRes(function(result)
    --    summontwo:update()
    --end, function(ret) return true end)
    if not GuideMrg:isPlaying() then
        summontwo:checkFristDraw()
    end
end

return summontwo
