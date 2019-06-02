-- 公会验证设置框
local m = {}

function m:Start()
    --self.Input_lv.onChange:Add(EventDelegate.Add(self.onChange))
    EventDelegate.Add(self.Input_lv.onChange, self.onChangeA);
    m.LV = tonumber(TableReader:TableRowByUnique("GuildSetting", "playerlvlmax").args1)
    -- 	self.flag = false
    -- 	self.level = 99
    -- 	self:SetData(self.flag, self.level)
end

function m:update()
    -- self.flag = false
    -- self.level = 99
    --print(GuildDatas:getMyGuildInfo().isCondition)
    self.flag = GuildDatas:getMyGuildInfo().isCondition
    self.level = GuildDatas:getMyGuildInfo().applyLevel
    self:SetData(self.flag, self.level)
end

function m:SetData(flag, level)
    if flag == true then
        self.spriteFlag.spriteName = "denglujm_on"
    else
        self.spriteFlag.spriteName = "denglujm_off"
    end
    self.Input_lv.value = tostring(level)
end

function m:onFlag(...)
    if self.flag == true then
        self.flag = false
        self.spriteFlag.spriteName = "denglujm_off"
    else
        self.flag = true
        self.spriteFlag.spriteName = "denglujm_on"
    end
end

function m:onChangeA()
    local Lv = tonumber(m.Input_lv.value)
    if Lv ~= nil and Lv > m.LV then
        m.Input_lv.value = m.LV
    end
end

function m:onOk(...)

    local strLv = self.Input_lv.value
    if strLv == nil or strLv == "" then
        MessageMrg.show(TextMap.GetValue("Text1302"))
        return
    end
    local lv = tonumber(strLv)
    if lv == nil then
        MessageMrg.show(TextMap.GetValue("Text1303"))
        return
    end
    self.level = lv
    print("000005555")
    Api:setApplyCondition(self.flag, self.level, function(result)
        if tonumber(result.ret) == 0 then
            UIMrg:popMessage(true)
            GuildDatas:getMyGuildInfo().isCondition = self.flag
            GuildDatas:getMyGuildInfo().applyLevel = self.level
        else
            MessageMrg.show(TextMap.GetValue("Text1242") .. result.ret)
        end
    end, function(result)
        print("lzh print: setApplyCondition 2222222222222222")
        print(result)
    end)
end

function m:onClick(go, btnName)
    if btnName == "btn_OnOrOff" then
        self:onFlag()
    elseif btnName == "btn_queding" then
        self:onOk()
    elseif btnName == "btn_quxiao" then
        --self.gameObject:SetActive(false)
        UIMrg:popMessage(true)
    end
end

return m