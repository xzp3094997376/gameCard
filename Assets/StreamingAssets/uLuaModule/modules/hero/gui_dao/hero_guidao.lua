-- 鬼道
local m = {}
local tps = { TextMap.GetValue("Text106"), TextMap.GetValue("Text107"), TextMap.GetValue("Text108"), TextMap.GetValue("Text109") }
local types = { "po", "hui", "fu", "jie" }
function m:update(lua)
    self.delegate = lua.delegate
    self.index = lua.index
    self:onUpdate(lua.char, true)
end

function m:onUpdate(char, ret)
    if char.empty == true then
        self.binding:Hide("hero")
        self.binding:Show("empty")
        if self.delegate:isFull() then
            self.empty.text = TextMap.GetValue("Text1130")
        else
            self.empty.text = TextMap.GetValue("Text1137")
        end
        self.txt_btn_name.text = TextMap.GetValue("Text1138")
        self.btn_check:SetActive(false)
        self.top:SetActive(false)
        self.hero_desc_bg:SetActive(false)
        m:updateGhost()
        self.binding:Hide("dingwei")
        return
    end
    self.btn_check:SetActive(true)
    self.top:SetActive(true)
    self.char = char
    self.txt_btn_name.text = TextMap.GetValue("Text1139")
    self.binding:Show("hero")
    self.binding:Hide("empty")
    self.hero:LoadByCharId(char.id, "stand", function(ctl) end)
    self.hero:canDrag(true)
    self.dingwei.spriteName = char:getDingWei()
    self.binding:Show("dingwei")
    self.dw_text = char.Table.dingwei_desc
    m:updateGhost()
end

--定位描述显示
function m:onTooltip(name)
    if name == "dingwei" then
        return self.dw_text
    end
end

function m:updateInfos()
    local char = self.char
    if char == nil or char.empty then return end
    local atk = "PhyAtk"
    if self.char:getAttrSingle("PhyAtk", true) < self.char:getAttrSingle("MagAtk", true) then
        atk = "MagAtk"
    end
    local attr1 = char:getAttrSingleForGhost(self.gostAttrName[1] or atk, self.ghostArg[1] or 0)
    local attr2 = char:getAttrSingleForGhost(self.gostAttrName[2] or "MaxHp", self.ghostArg[2] or 0)
    local attr3 = char:getAttrSingleForGhost(self.gostAttrName[3] or "MagDef", self.ghostArg[3] or 0)
    local attr4 = char:getAttrSingleForGhost(self.gostAttrName[4] or "PhyDef", self.ghostArg[4] or 0)


    self.txt_attr1.text = attr1
    self.txt_attr2.text = attr2
    self.txt_attr3.text = attr3
    self.txt_attr4.text = attr4

    --属性与描述
    local list = char:getAttrDesc()
    local descLeft = ""
    local descRight = ""
    table.foreachi(list, function(i, v)
        if i % 2 ~= 0 then
            descLeft = descLeft .. v
        else
            descRight = descRight .. v
        end
    end)
    self.txt_attr_left.text = string.sub(descLeft, 1, -2)
    self.txt_attr_right.text = string.sub(descRight, 1, -2)
    self.txt_hero_desc.text = char:getDesc()
    self.txt_ding_wei_desc.text = char.Table.dingwei_desc
end

function m:updateGhost()
    local index = self.index
    local ghostSlot = Player.ghostSlot
    local ghost = Player.Ghost
    local slot = ghostSlot[index]
    local postion = slot.postion
    local list = {}
    local len = postion.Count
    local equipPos = {}
    self.ghostArg = {}
    self.gostAttrName = {}
    for i = 1, 4 do
        if i > len then
            list[i] = { empty = true, name = tps[i], kind = types[i], charIndex = self.index, equipIndex = i - 1 }
            equipPos[i] = false
            self.ghostArg[i] = 0
        else
            local key = postion[i - 1]
            if key ~= "" and key ~= nil and key ~= 0 and key ~= "0" then
                local g = ghost[key].id
                if g == 0 then
                    equipPos[i] = false
                    self.ghostArg[i] = 0
                    list[i] = { empty = true, name = tps[i], kind = types[i], charIndex = self.index, equipIndex = i - 1 }
                else
                    local gh = Ghost:new(g, key)
                    gh.equipIndex = i - 1
                    gh.charIndex = index
                    list[i] = gh
                    equipPos[i] = true
                    self.ghostArg[i] = gh:getMainArg()
                    self.gostAttrName[i] = gh:getMainAttrName()
                end

            else
                equipPos[i] = false
                list[i] = { empty = true, name = tps[i], kind = types[i], charIndex = self.index, equipIndex = i - 1 }
                self.ghostArg[i] = 0
            end
        end
    end
    self.equipPos = equipPos
    --    self.itemList = ClientTool.UpdateGrid("", self.equips, list, self)
    for i = 1, #list do
        self["cell" .. (i - 1)]:CallUpdate(list[i])
    end
    m:updateInfos()
end

function m:getBestGhostByType(pos, list)
    if #list == 0 then return "" end
    table.sort(list, function(a, b)
        if a.star ~= b.star then return a.star > b.star end
        if a.power ~= b.power then return a.power > b.power end
        if a.lv ~= b.lv then return a.lv > b.lv end
        return false
    end)
    if list[1] then return pos .. ":" .. list[1].key end
    return ""
end

--一键装备
function m:onWear(go)
    local index = 0
    for i = 1, #self.equipPos do
        if self.equipPos[i] == true then index = index + 1 end
    end
    if index == #self.equipPos then
        return
    end
    local list = Tool.getUnUseGhost()
    local po = {}
    local hui = {}
    local fu = {}
    local jie = {}
    table.foreach(list, function(i, v)
        if v.kind == "po" then table.insert(po, v) end
        if v.kind == "hui" then table.insert(hui, v) end
        if v.kind == "fu" then table.insert(fu, v) end
        if v.kind == "jie" then table.insert(jie, v) end
    end)

    local str = ""
    local tb = {}
    if self.equipPos[1] == false then
        local s = m:getBestGhostByType(0, po)
        table.insert(tb, s)
    end

    if self.equipPos[2] == false then
        local s = m:getBestGhostByType(1, hui)
        table.insert(tb, s)
    end

    if self.equipPos[3] == false then
        local s = m:getBestGhostByType(2, fu)
        table.insert(tb, s)
    end

    if self.equipPos[4] == false then
        local s = m:getBestGhostByType(3, jie)
        table.insert(tb, s)
    end
    local len = #tb
    for i = 1, len do
        if tb[i] ~= "" then
            str = str .. tb[i]
            if i ~= len then
                str = str .. "|"
            end
        end
    end
    if str == "" then
        MessageMrg.show(TextMap.GetValue("Text1140"))
        return
    end
    Api:gd_equipOn_ones(self.index, str, function(result)
        MusicManager.playByID(50)
        m:updateGhost()
        Tool.resetUnUseGhost()
        Events.Brocast('updateChar')
    end)
end

--魂炼
function m:onHunLian(go)
    Tool.push("HunLian", "Prefabs/moduleFabs/guidao/hun_lian")
end

function m:onClick(go, name)
    if name == "btn_wear" then
        m:onWear(go)
    elseif name == "btnChange" then
        if self.delegate:isFull() then
            local lv = Player.Info.level
            lv = lv + 5 - lv % 5
            MessageMrg.show(string.gsub(TextMap.GetValue("Text111"),"{0}",lv))
            return
        end
        local bind = UIMrg:pushWindow("Prefabs/moduleFabs/formationModule/formation/formation_select_char")
        bind:CallUpdate({ type = "single", module = "ghost", delegate = self.delegate })
    elseif name == "btnXianJi" then
        m:onHunLian(go)
    end
end


function m:showEquipOnEffect(go)
    if go == nil then return end
    ClientTool.AlignToObject(self.UI_guodaojiemian_whitelight, go.gameObject, 3)
    self.UI_guodaojiemian_whitelight:SetActive(false)
    self.UI_guodaojiemian_whitelight:SetActive(true)
    self.binding:CallAfterTime(0.8, function()
        self.UI_guodaojiemian_whitelight:SetActive(false)
    end)
end

local indexs = { po = 0, hui = 1, fu = 2, jie = 3 }
--装备鬼道
function m:selectedGhost(ghost)
    --装备鬼道
	print("____________________+++")
    local data = ghost
    local index = indexs[data.kind]
    Api:gd_equipOn(data.key, self.index, index, function(result)
        MusicManager.playByID(50)
        Tool.resetUnUseGhost()
        Events.Brocast('updateChar')
        Events.Brocast('updateLeft', data)
        m:updateGhost()
        UIMrg:popWindow()
        m:showEquipOnEffect(self.itemList[index + 1])
    end, function(ret)
        return false
    end)
end

function m:OnDestroy()
    Events.RemoveListener('selectedGhost')
end

function m:Start()
    self.UI_guodaojiemian_whitelight:SetActive(false)
    Events.AddListener("selectedGhost", funcs.handler(self, m.selectedGhost))
    self.itemList = {}
    for i = 0, 3 do
        table.insert(self.itemList, self["cell" .. i])
    end
end

return m

