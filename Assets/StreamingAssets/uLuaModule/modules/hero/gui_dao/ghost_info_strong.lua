--
-- Created by IntelliJ IDEA.
-- User: xiyou
-- Date: 2015/3/23
-- Time: 9:54
-- To change this template use File | Settings | File Templates.
-- 鬼道强化

local m = {}
local isClick = false
local isPlaying = false
function m:update(lua)
    self.qianghuashengji:SetActive(false)
    self.data = lua.data
    self.delegate = lua.delegate
    self.ui_qianghua_2:SetActive(false)
    self.ui_qianghua_2_1:SetActive(false)
    isClick = false
    self.binding:Show("btStrongAll")
    self.binding:Hide("btnStop")
    isPlaying = false
    m:onUpdate()
end

function m:onUpdate()
   -- print_t(self.data)

    self.equip.Url = self.data:getHead()
    local ret = false
    local des = { fu = TextMap.GetValue("Text_1_891"), hui = TextMap.GetValue("Text_1_892"), jie = TextMap.GetValue("Text_1_893"), po = TextMap.GetValue("Text_1_894")}
    local ghostLevelUpCost = TableReader:TableRowByUnique("ghostLevelUpCost", "level", self.data.lv)
    local ghostLevelUpInfo = TableReader:TableRowByUnique("ghost", "id", self.data.id)
    local magic_arg1 = ghostLevelUpInfo.magic[0].magic_arg1 --初始值
    local magic_arg2 = ghostLevelUpInfo.magic[0].magic_arg2 --成长值

    if self.data.power > 0 then
        self.txt_name.text = self.data:getItemColorName(self.data.star , self.data.name .. " [00ff00]+ " ..self.data.power.."[-]")  -- 装备名称  
    else   
        self.txt_name.text = self.data:getDisplayColorName() --self.data.suitName  -- 装备名称  ghost:getDisplayColorName()
    end
    self.txt_lv.text = self.data.lv .. "/" .. Player.Info.level * 2 --当前装备等级
    self.cur_atk.text = des[self.data.kind] .. "："     -- 装备属性类型
    self.txt_atk.text = magic_arg1 + magic_arg2 * (self.data.lv - 1) -- 当前属性
    if self.data:isMaxLv() then  --强化最高
        self.btStrongAll.isEnabled = false
        self.btStrong.isEnabled = false
        Tool.SetActive(self.money, false) 
        self.next_lv.text = ""
        self.txt_next_lv.text = ""
        self.next_atk.text = ""   -- 装备属性类型             
        self.txt_next_atk.text = "" -- 下级属性
        self.up:SetActive(false)
        Tool.SetActive(self.money, false)
        --self.cur_lv.text = TextMap.GetValue("Text1118") .. self.data.lv .. "[-]"
        --self.cur_atk.text = self.data:getMainAttr()
        --self.next_lv.text = ""
        --self.txt_top.text = TextMap.GetValue("Text1119")
        ret = false
    else
        self.btStrongAll.isEnabled = true
        self.btStrong.isEnabled = true
        Tool.SetActive(self.money, true)
        self.up:SetActive(true)
        local money = ghostLevelUpCost[self.data.kind .. self.data.star]
        self.money.text = money -- 强化金币 
        if self.data.lv >=  Player.Info.level * 2 then   
            self.txt_next_lv.text = "[ff0000]" .. self.data.lv + 1 .. "/" .. Player.Info.level * 2 .. "[-]" --下级装备等级  当前强化到上限，显示红色 
        else
            self.txt_next_lv.text = self.data.lv + 1 .. "/" .. Player.Info.level * 2 --下级装备等级  
        end
        self.txt_next_atk.text = magic_arg1 + magic_arg2 * (self.data.lv) -- 下级属性
        self.next_atk.text = des[self.data.kind] .. "："    -- 装备属性类型
        self.up_atk.text = magic_arg2 -- 成长值

        --local money = ghostLevelUpCost[self.data.kind .. self.data.star]
        --self.money.text = money
        --self.cur_lv.text = TextMap.GetValue("Text1118") .. self.data.lv .. "[-]"
        --self.cur_atk.text = self.data:getMainAttr()
        --self.next_lv.text = TextMap.GetValue("Text1120") .. (self.data.lv + 1) .. "[-]"
        --self.next_atk.text = self.data:getMainAttr(true)
        --self.txt_top.text = TextMap.GetValue("Text1121")
        ret = money < Player.Resource.money
        if ret == true then
            ret = self.data:curMaxLv()
        end
    end

    -- if ret then
    --     if self.effect == nil then
    --         self.effect = Tool.LoadButtonEffect(self.btStrong.gameObject)   --老的特效
    --     end
    -- end
    Tool.SetActive(self.effect, ret)
    Tool.SetActive(self.btchange, self.data.hasWear == 1)
    Tool.SetActive(self.btn_equip, self.data.hasWear == 0)
end

function m:stongUp(count)
    if count == 0 then
        m:onStop()
        return
    end
    if isPlaying == false then return end
    isClick = true

    local olv = self.data.lv
    Api:ghostLevelUp(self.data.key, function(result)
        m:showEffect()
        self.data:updateInfo()
        local newlv = self.data.lv
        local ret = false
        if newlv - olv > 1 then ret = true end
        m:onUpdate()
        Events.Brocast('updateLeft', self.data)
        self.delegate:updateQianHuaRed()
        local magic = self.data:getMagic()[1]
        local num = magic.arg2
        local e = newlv - olv
        local list = {}
        list[1] = string.gsub(TextMap.GetValue("LocalKey_708"), "{0}",e)
        list[2] = string.gsub(magic.format, "{0}", num * e)
        if ret then
            table.insert(list, 1, string.gsub(TextMap.GetValue("LocalKey_709"), "{0}",e))
        end
        OperateAlert.getInstance:showToGameObject(list, self.node)
        if self.gameObject.activeInHierarchy then
            self.binding:CallAfterTime(1.5, function()
                --                isClick = false
                m:stongUp(count - 1)
            end)
        end
    end, function(ret)
        m:onStop()
        return false
    end)
end

--一键强化
function m:onOneKey()
    if isClick == true then return end
    isClick = true
    local olv = self.data.lv
    Api:ghostAutoLevelUp(self.data.key, function(result)
		--print(result)
        local t = 4
        if result.t then
            t = result.t
        end
        m:showEffect(true)
        self.data:updateInfo()
        local newlv = self.data.lv
        local ret = false
        if newlv - olv > 1 then ret = true end
        m:onUpdate()
        Events.Brocast('updateLeft', self.data)
        self.delegate:updateQianHuaRed()
        --self.delegate:showStrongEffect(newlv - olv)
        local magic = self.data:getMagic()[1]
        local num = magic.arg2
        local e = result.luck.Count--newlv - olv
        local list = {}
        list[1] = string.gsub(TextMap.GetValue("LocalKey_708"), "{0}",e)
        if t < 5 then
            list[1] =string.gsub(TextMap.GetValue("LocalKey_694"),"{0}",t)
        end
        list[2] = string.gsub(magic.format, "{0}", num * e)
        if ret then
            table.insert(list, 1, string.gsub(TextMap.GetValue("LocalKey_709"), "{0}",e))
        end
        OperateAlert.getInstance:showToGameObject(list, self.node)
    end, function(ret)
        isClick = false
        return false
    end)
    -- isPlaying = true
    -- self.binding:Hide("btStrongAll")
    -- self.binding:Show("btnStop")
    -- m:stongUp(5)
end

--强化
function m:onStrong()
    if isClick == true then return end
    isClick = true
    local olv = self.data.lv
    Api:ghostLevelUp(self.data.key, function(result)
        m:showEffect(true)
        self.data:updateInfo()
        local newlv = self.data.lv
        local ret = false
        if newlv - olv > 5 then ret = true end
        m:onUpdate()
        Events.Brocast('updateLeft', self.data)
        self.delegate:updateQianHuaRed()
        --self.delegate:showStrongEffect(newlv - olv)
        local magic = self.data:getMagic()[1]
        local num = magic.arg2
        local e = newlv - olv
        local list = {}
        list[1] = string.gsub(TextMap.GetValue("LocalKey_708"), "{0}",e)
        list[2] = string.gsub(magic.format, "{0}", num * e)
        if ret then
            table.insert(list, 1, string.gsub(TextMap.GetValue("LocalKey_709"), "{0}",e))
        end
        OperateAlert.getInstance:showToGameObject(list, self.node)
    end, function(ret)
        isClick = false
        return false
    end)
end

function m:showEffect(ret)
    MusicManager.playByID(46)
    self.qianghuashengji:SetActive(false)
    self.qianghuashengji:SetActive(true)
    self.binding:CallAfterTime(2, function()
        self.qianghuashengji:SetActive(false)
        if ret then isClick = false end 
    end)


    -- MusicManager.playByID(46)
    -- self.ui_qianghua_2:SetActive(false)
    -- self.ui_qianghua_2:SetActive(true)
    -- self.ui_qianghua_2_1:SetActive(false)
    -- self.ui_qianghua_2_1:SetActive(true)
    -- self.binding:CallAfterTime(1, function()
    --     if ret then isClick = false end
    --     self.ui_qianghua_2:SetActive(false)
    --     self.ui_qianghua_2_1:SetActive(false)
    -- end)
end



function m:onStop()
    isPlaying = false
    isClick = false
    self.binding:Show("btStrongAll")
    self.binding:Hide("btnStop")
end

function m:onCallBack(char)
    Events.Brocast('updateLeft', self)
end

--更换鬼道
function m:onChange()
    UIMrg:pushWindow("Prefabs/moduleFabs/guidao/guidao_select_charpiece", { kind = self.data.kind, ghost = nil, type = "ghost" })
end


function m:onClick(go, name)
    if name == "btchange" then
        m:onChange()
    elseif name == "btn_equip" then
        Tool.replace("team", "Prefabs/moduleFabs/formationModule/formation/formation_main", { 0 })
    elseif name == "btStrongAll" then -- 强化5次
        m:onOneKey()
    elseif name == "btStrong" then    -- 强化1次
        m:onStrong()
    elseif name == "btnStop" then
        m:onStop()
    end
end

function m:Start()
end

return m
