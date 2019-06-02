RewardMrg = require("uLuaModule/uLuaFramework/logic/uRewardMrg.lua")
RewardChar = require("uLuaModule/modules/summon/uRewardChar.lua")

local RewardTen = {}
local DrawId = {
    NorOneFree = 4,
    NorOne = 1,
    NorTen = 6,
    SpOneFree = 5,
    SpOne = 2,
    SpTen = 3
}
--关闭奖励显示
function RewardTen:destory()
    --    SendBatching.DestroyGameOject(self.binding.gameObject)
    UIMrg:popWindow()
    UIMrg:pop()
end

--确定
function RewardTen:onOk()
    if self.delegate then
        self.delegate:activeEvent(false)
    end
    self:destory()
end

--再抽一次
function RewardTen:onSummon()
    if self.draw_id ==6 then 
        self.obj:SetActive(true)
        for i=1,10 do
            self["hero" .. i].gameObject:SetActive(false)
            self["name" .. i].gameObject:SetActive(false)
            self["effect" .. i].gameObject:SetActive(false)
        end
    end 
    self:destory()
    self.cbAgin()
end

local comp
function RewardTen:Next()
    if comp~=null then 
        comp.transform.localScale=Vector3.zero
    end
    comp = self.itemsList[self.index]
    if comp ~= nil then
        comp.transform:FindChild("ani"):GetComponent("TweenScale").enabled=true
        self.ItemIcon.transform:FindChild("effect").gameObject:SetActive(true)
        comp:PlayTween("ani", 0.3, funcs.handler(self, self.play))

        comp:Show("flash")
        --        comp:Play("ani", "reward_effect", funcs.handler(self, self.play))
    end
    --    self:play()
end

local index 
local count=0
function RewardTen:play()
    self.canClick=false
    local list = self.rewardList
    count = table.getn(list)
    self.index = self.index + 1
    index = self.index
    local item = list[index]
    item.isDes=false
    if self.draw_id ==6 then 
        self["effect" .. (self.index)].gameObject:SetActive(true)
        self.binding:CallAfterTime(0.4, function()
            self["hero" .. (self.index)].gameObject:SetActive(true)
            self["hero" .. (self.index)]:LoadByModelId(item.modelid, "idle", function() end, false, 0, 1,255,2)
            self["name" .. (self.index)].gameObject:SetActive(true)
            self["name" .. (self.index)].text=item.itemColorName
            local ts = TweenScale.Begin(self["hero" .. (self.index)].gameObject,0.4, Vector3.one)
            if item:getType() == "char" and item.star>=4 then
                ts:SetOnFinished(function()
                    self["effect" .. (self.index)].gameObject:SetActive(false)
                    LuaTimer.Add(200, function()
                        self.canClick=true
                        self.obj:SetActive(false)
                        RewardChar:show(item,nil,false)
                    end)
                end)
            else
                ts:SetOnFinished(function()
                    self["effect" .. (self.index)].gameObject:SetActive(false)
                    if self.index<10 then 
                        self:play()
                    else 
                        self.ani_show_button.gameObject:SetActive(true)
                        self.ani_show_button.enabled=true
                    end 
                end)
            end
            end)
    else 
        RewardChar:show(item,nil,false)
    end 
    if item.star ~= nil and item.star > 3 then
        local time = 0.8
        if item.star > 4 then
            time = 3
        end
        local soundInfo = TableReader:TableRowByID("avter", item.dictid)
        if soundInfo.jianjie_audio ~= nil and soundInfo.jianjie_audio ~= "" and soundInfo.jianjie_audio > 0 then
            self.binding:CallAfterTime(time, function()
                 MusicManager.playByID(soundInfo.jianjie_audio)
           end)
        end
    end
end

function RewardTen:onClick(go, name)
    print(name)
    if name == "btn_queding" then
        if index==10 and index==count then 
            index=0
            count=0
            self:onOk()
        end 

    elseif name == "btn_zaichouyici" then
        if index==10 and index==count then 
            index=0
            count=0
            self:onSummon()
        end 
    elseif name == "Next" then
        if self.draw_id ~=6 then 
            if index <= count-1 then
                UIMrg:popWindow()
                local that = self
                that:play()
            end
        else 
            if self.canClick==true then 
                UIMrg:popWindow()
                self.obj:SetActive(true)
                self.NextObj:SetActive(false)
                if index <= count-1 then
                    self:play()
                else 
                    self.ani_show_button.gameObject:SetActive(true)
                    self.ani_show_button.enabled=true
                end 
            end 
        end 
    end
end

function RewardTen:update(luaTable)
    self.result = luaTable.result
    self.cbAgin = luaTable.cbAgin
    self.delegate = luaTable.delegate
    self.txt_cost.text = luaTable.cost .. ""
    self.icon.Url =UrlManager.GetImagesPath("itemImage/" .. luaTable.cost_icon .. ".png")

    self.draw_id = luaTable.darw_id
    local list = RewardMrg.getList(self.result)
    self.ani_show_button:ResetToBeginning()
    self.ani_show_button.gameObject:SetActive(false)
    self.rewardList = list
    self.index = 0
    local randNum = math.random(1, 9)
    local temp = list[2]
    list[2] = list[randNum]
    list[randNum] = temp
    local that = self
    that:play()
end





--显示
function RewardTen:show(luaTable)
    if luaTable.darw_id==6 then 
        Tool.push("RewardItem", "Prefabs/moduleFabs/choukaModule/RewardItemTen_money", luaTable)
    else 
        Tool.push("RewardItem", "Prefabs/moduleFabs/choukaModule/RewardItemTen", luaTable)
    end
end

function RewardTen:HideNext()
    self.NextObj:SetActive(false)
end

function RewardTen:ShowNext()
    if index > count-1 and self.draw_id~=6 then
        self.ani_show_button.gameObject:SetActive(true)
        self.ani_show_button.enabled = true
    else
        self.NextObj:SetActive(true)
    end 
end

function RewardTen:OnDestroy()
    RewardTen = nil
    Events.RemoveListener('Next_hide')
    Events.RemoveListener('Next_show')
end

function RewardTen:Start()
    Events.AddListener("Next_hide",
        function(params)
        self:HideNext()
    end)
    Events.AddListener("Next_show",
        function(params)
            self:ShowNext()
    end)
end

return RewardTen