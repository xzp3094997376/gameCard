
local summon = {}

local REFRESH_TIMER = 0
local REFRESH_SP_TIMER = 0

--每天总共免费次数
local FREE_TIMES_COUNT = 5

--字符
local NO_FREE = TextMap.GetValue("Text1425")
local FREE_TIMES = TextMap.GetValue("Text1426")
local FREE_THIS_TIME = TextMap.GetValue("Text1427")
local TXT_FREE = TextMap.GetValue("Text1428")

local DrawId = {
    NorOneFree = 4,
    NorOne = 1,
    NorTen = 6,
    SpOneFree = 5,
    SpOne = 2,
    SpTen = 3,
    ZhenyingFree=7,
    ZhenyingOne=8,
    ZhenyingTen=9
}

function summon:onChouka()
    local temp = {}
    temp._choukaType = self._choukaType
    Tool.push("summontwo", "Prefabs/moduleFabs/choukaModule/summontwo", temp)     
end

function summon:onClick(go, name)
    if name == "btn_renzhe" then
        self._choukaType = "renzhe"
        self:onChouka()
    elseif name == "btn_shenren" then
        self._choukaType = "shenren"
        self:onChouka()
    elseif name == "Texturezhenying" then 
        Tool.push("summon_zhenying", "Prefabs/moduleFabs/choukaModule/summon_zhenying", {delegate=self}) 
	elseif name == "btnBack" then
		UIMrg:pop()
    end
end

--更新普通抽卡免费时间
function summon:updateNorTime()
    LuaTimer.Delete(REFRESH_TIMER)
    REFRESH_TIMER = LuaTimer.Add(0, 1000, function(id)
        if self.binding == nil then return false end
        if self.time > 0 then
            local time = Tool.FormatTime(self.time)
            time =string.gsub(TextMap.GetValue("LocalKey_759"),"{0}",time)
            self.txt_left.text = time
        else
            summon:checkZhaomu()
            local time = ""
            if self.norCurTime == 0 then
                --次数用完
                time = NO_FREE
                self.NorDrawOne = DrawId.NorOne --花钱单抽
            else
                time = FREE_TIMES .. self.norCurTime .. "/" .. FREE_TIMES_COUNT
                self.NorDrawOne = DrawId.NorOneFree --免费抽卡
            end
            self.txt_left.text = time
            return false
        end
        local CdTime = Player.CdTime or {}
        self.time = ClientTool.GetNowTime(CdTime.moneyfree)
        return true
    end)
end

--更新钻石抽卡免费时间
function summon:updateSpTime()
    LuaTimer.Delete(REFRESH_SP_TIMER)
    REFRESH_SP_TIMER = LuaTimer.Add(0, 1000, function(id)
        if self.binding == nil then return false end
        if self.sp_time > 0 then
            local time = Tool.FormatTime(self.sp_time)
            time = string.gsub(TextMap.GetValue("LocalKey_759"),"{0}",time)
            self.txt_right.text = time
        else
            self.txt_right.text = FREE_THIS_TIME
            self.SpDrawOne = DrawId.SpOneFree --钻石免费单抽
            summon:checkZhaomu()
            return false
        end
        local CdTime = Player.CdTime or {}

        self.sp_time = ClientTool.GetNowTime(CdTime.goldfree)
        return true
    end)
end

--开始普通抽卡倒计时
function summon:startNorTime(time)
    self.time = time or 0
    if self.time <= 0 and self.norCurTime > 0 then
        self.NorDrawOne = DrawId.NorOneFree --免费抽卡
        self:updateNorTime()
    else
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
function summon:startSpTime(time)
    self.sp_time = time or 0
    if self.sp_time <= 0 then
        self.SpDrawOne = DrawId.SpOneFree --钻石免费单抽
        self:updateSpTime()
    else
        self:updateSpTime()
        self.SpDrawOne = DrawId.SpOne --钻石单抽
    end
end

--开始阵营抽卡倒计时
function summon:startZhenyingTime(time)
    self.sp_time = time or 0
    if self.sp_time <= 0 then
        self.SpDrawOne = DrawId.SpOneFree --阵营抽卡免费单抽
        self:updateSpTime()
    else
        self:updateSpTime()
        self.SpDrawOne = DrawId.SpOne --阵营抽卡单抽
    end
end

local timerId = 0

local isupdateCamp = false

function summon:setRefreshCampTime()
    LuaTimer.Delete(timerId)
    timerId = LuaTimer.Add(0,1000, function(id)
        local time  =Tool.FormatTime(self.zTime / 1000 -os.time()) 
        self.txt_zhenying.text=TextMap.GetValue("Text_1_2787") .. time 
        if self.zTime / 1000<=os.time() and isupdateCamp==false then
            isupdateCamp = true
            Api:loadCamp(function(result)
                self.camp=result.camp
                if self.check_zhengying==false then 
                    local consume = TableReader:TableRowByID("draw_xingyunzhi",self.camp).consume
                    if consume~=nil and Player.Resource.xingyunzhi>=consume[0].consume_arg then 
                        self.red_zhenying:SetActive(true)
                        self.check_zhengying=true
                    end
                end
                self.zTime=result.t
                summon:setRefreshCampTime()
                end)
            return true
        end
    end)
end

function summon:create(binding)
    self.binding = binding
    self.gameObject = self.binding.gameObject
    Api:loadCamp(function(result)
        self.camp=result.camp
        if self.check_zhengying==false then 
            local consume = TableReader:TableRowByID("draw_xingyunzhi",self.camp).consume
            if consume~=nil and Player.Resource.xingyunzhi>=consume[0].consume_arg then 
                self.red_zhenying:SetActive(true)
                self.check_zhengying=true
            end
        end   
        self.zTime=result.t
        summon:setRefreshCampTime()
        end)
    return self
end

function summon:update()
    local times = Player.Times or {}
    self.norCurTime = times.moneytime or 0; --免费次数
    local CdTime = Player.CdTime or {}
    local nTime = ClientTool.GetNowTime(CdTime.moneyfree)
    local sTime = ClientTool.GetNowTime(CdTime.goldfree)
    if self.zTime~=nil then 
        summon:setRefreshCampTime()
    end 
    summon:checkZhaomu()
    self:startNorTime(nTime)
    self:startSpTime(sTime)
    local linkData = Tool.readSuperLinkById( 7)
    print_t(linkData.unlock)
    local limitLv = linkData.unlock[0].arg
    if Player.Info.vip <linkData.vipLevel and Player.Info.level < limitLv then
        self.Texturezhenying.isEnabled=false
        self.Lock:SetActive(true)
        self.LockLabel.text=TextMap.GetValue("Text_1_2788") .. limitLv
        self.red_zhenying:SetActive(false) 
    else 
        self.Texturezhenying.isEnabled=true
        self.Lock:SetActive(false)
        self.LockLabel.text=""
    end 
end

function summon:checkZhaomu()
    local times = Player.Times or {}
    local norCurTime = times.moneytime or 0; --免费次数
    local CdTime = Player.CdTime or {}
    local nTime = ClientTool.GetNowTime(CdTime.moneyfree)
    local sTime = ClientTool.GetNowTime(CdTime.goldfree)
    local zCurTime =Player.Times.draw_party1time or 0
    if norCurTime >0 and nTime<=0 then 
        self.red_left:SetActive(true)   
    else
        local consume=TableReader:TableRowByID("draw", 1).consume[i]
        if consume.consume_type=="item" then 
            local ziyuan=Player.ItemBagIndex[consume.consume_arg].count
            if ziyuan >0 then 
               self.red_left:SetActive(true)
            else 
               self.red_left:SetActive(false)    
            end
        else
            self.red_left:SetActive(false)  
        end
    end
    if sTime<=0 then 
        self.red_right:SetActive(true) 
    else 
        local consume1=TableReader:TableRowByID("draw",2).consume[i]
        if consume1.consume_type=="item" then 
            local ziyuan2=Player.ItemBagIndex[consume1.consume_arg].count
            if ziyuan2>0 then 
                self.red_right:SetActive(true)
            else 
               self.red_right:SetActive(false)    
            end
        else
            self.red_right:SetActive(false)  
        end
    end
    local linkData = Tool.readSuperLinkById( 7)
    local limitLv = linkData.unlock[0].arg
    if Player.Info.level >= limitLv then
        if zCurTime>0 then 
            self.red_zhenying:SetActive(true) 
            self.check_zhengying=true
        else 
            local consume3=TableReader:TableRowByID("draw",30).consume[i]
            if consume3.consume_type=="item" then 
                local ziyuan3=Player.ItemBagIndex[consume3.consume_arg].count
                if ziyuan3>0 then 
                    self.red_zhenying:SetActive(true)
                    self.check_zhengying=true
                else
                    self.red_zhenying:SetActive(false) 
                    self.check_zhengying=false
                end
            else
                self.red_zhenying:SetActive(false)
                self.check_zhengying=false
            end
        end 
    else 
        self.red_zhenying:SetActive(false) 
    end

    return false
end

function summon:Start()
    Events.AddListener("update_summon_date",
    function()
        summon:update()
    end)
end
--关闭
function summon:OnDestroy()
    LuaTimer.Delete(REFRESH_SP_TIMER)
    LuaTimer.Delete(REFRESH_TIMER)
    LuaTimer.Delete(timerId)
    Events.RemoveListener('update_summon_date')
end

return summon
