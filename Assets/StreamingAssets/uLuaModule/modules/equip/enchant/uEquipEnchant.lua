local selectList = require("uLuaModule/modules/selectChar/selectChar.lua")
--装备附魔
local m = {}
local PlsSelectMaterial = TextMap.GetValue("Text77")
local modelName = "equip_enchant"
local equp_piece_lz = {}
function getMaterialList(type, Bag, list)
    local bag = Bag:getLuaTable()

    for k, v in pairs(bag) do
        if type == "equip" then
            local eq = Equip:new(v.id)
            eq.selectCount = 0
            eq.key = k
            if eq.id ~= nil then
                table.insert(list, eq)
            end
        elseif type == "equipPiece" then
            local eq = EquipPiece:new(v.id)
            eq.selectCount = 0
            eq.key = k
            if eq.id ~= nil then
                if tonumber(eq.id) >= 65 then
                    equp_piece_lz[eq.id] = eq
                end
                table.insert(list, eq)
            end

        elseif type == "reel" then
            local eq = Reel:new(v.id)
            eq.selectCount = 0
            eq.key = k
            if eq.id ~= nil then
                table.insert(list, eq)
            end
        elseif type == "reelPiece" then
            local eq = ReelPiece:new(v.id)
            eq.selectCount = 0
            eq.key = k
            if eq.id ~= nil then
                table.insert(list, eq)
            end
        end
    end
end

--选择材料
--@item 选择的材料
--@ret true为加，false为减
function m:selectMaterial(item, ret, count, index, pIndex)
    local dir = 1
    local item = self.__materialList[pIndex][index]

    if ret == false then
        dir = -1
        item.selectCount = item.selectCount - 1
    else
        item.selectCount = item.selectCount + 1
    end
    self:updateExp(item.Table.exp * dir)
    self._selectedMaterial[item:getType() .. ":" .. item.key] = count
end

--显示材料
function m:showMaterial()
    local list = {}
    equp_piece_lz = {}
    getMaterialList("equip", Player.EquipmentBag, list)
    getMaterialList("equipPiece", Player.EquipmentPieceBag, list)
    getMaterialList("reel", Player.ReelBag, list)
    getMaterialList("reelPiece", Player.ReelPieceBag, list)
    table.sort(list, function(a, b)
        return a.exp < b.exp
    end)
    table.foreach(equp_piece_lz, function(i, v)
        table.insert(list, 1, v)
    end)

    --    self.materialList:refresh("Prefabs/moduleFabs/equipModule/enchant/material", list, self, 6)
    local _list = self:getData(list)
    self.__materialList = _list
    self.scrollView:refresh(_list, self, true, 0)
end

function m:getData(data)
    local list = {}
    local row = 4
    for i = 1, table.getn(data), row do
        local li = {}
        local len = 0
        for j = 0, row - 1 do
            if data[i + j] then
                local d = data[i + j]
                li[j + 1] = d
                len = len + 1
            end
        end
        if len > 0 then
            table.insert(list, li)
        end
    end

    return list
end

--选择装备
function m:selectEquip(equip)
    local list = self.list
    equip:updateInfo()
    table.foreachi(self.equips, function(i, v)
        local binding = list[i]
        if v.index ~= equip.index then
            binding:CallTargetFunction("setSelected", true)
        else
            equip:isSelected(false)
            --            target:updateEquip(equip)
            binding:CallTargetFunctionWithLuaTable("updateEquip", equip)
        end
    end)
    self.equipIcon:CallUpdate(equip)
    self.equipInfo:SetActive(true)

    --刷新装备信息
    self.txt_equip_name.text = equip.name
    self.txt_desc.text = equip:getAttrDesc()
    self.curEquipMaxLevel = equip:getMaxLevel()
    self.__equip = equip
    local need = equip:getNeedExp()
    self.isFull = false
    if self.curEquipMaxLevel == equip.level then
        equip.exp = need
        self.isFull = true
    end

    self.slider_exp.value = equip.exp / need
    self.txt_count.text = equip.exp .. "/" .. need

    self.costNum = equip:getCostNum() --金币花费系统
    self.curExp = equip.exp --当前经验
    self.tempCurExp = self.curExp
    self.curEquip = equip --当前装备
    self.needExp = need --需要的经验
    self.curEquipLevel = equip.level + 1
    self.curEquipLevel = math.max(1, self.curEquipLevel)
    self.curEquipLevel = math.min(self.curEquipLevel, self.curEquipMaxLevel)
    self.no_add_materia:SetActive(true)
    self.money:SetActive(false)
    self.selectedExpPoint = 0
    --    self.binding:Show("materialList")

    self.selectedExpPoint = 0 --选择材料的经验值总和
    self:showMaterial()
    self._selectedMaterial = {}


    if self.curEquipLevel == self.curEquipMaxLevel and need == self.curExp then
        self.onekey_cost.text = "0"
        self:oneKeyEffect(self.onekey_cost.text)
    else
        local obj = TableReader:TableRowByID("equipSetting", self.selectDtata.equip.Table.color)
        self.onekey_cost.text = math.ceil((obj.totel_exp - self.curExp) * obj.gold_cost_num)
        self:oneKeyEffect(self.onekey_cost.text)
    end
end

--一键强化按钮特效检测
function m:oneKeyEffect(str)
    if self.oneKeyeffect == nil then
        self.oneKeyeffect = Tool.LoadButtonEffect(self.btn_onekey.gameObject)
    else
        self.oneKeyeffect:SetActive(str ~= "0")
    end
end


--判断经验是否已满
function m:isExpFull()
    return self.isFull or false
end

--刷新消耗金币

function m:updateCostMoney()
    if self.selectedExpPoint <= 0 then
        --没选择材料
        self.no_add_materia:SetActive(true)
        self.money:SetActive(false)
        self.txt_cost.text = "0"
        self:QianghuaEffect(self.txt_cost.text)
    else
        self.no_add_materia:SetActive(false)
        self.money:SetActive(true)
        self.txt_cost.text = self.costNum * self.selectedExpPoint
        self:QianghuaEffect(self.txt_cost.text)
    end
end

--强化按钮特效检测
function m:QianghuaEffect(str)
    if self.effect == nil then
        self.effect = Tool.LoadButtonEffect(self.btn_powerUp.gameObject)
    else
        self.effect:SetActive(str ~= "0")
    end
end



--经验条刷新
function m:updateExp(num)
    self.selectedExpPoint = self.selectedExpPoint + num
    --MessageMrg.show(num .. "")
    local curExp = self.curExp
    curExp = curExp + num
    self.curExp = curExp
    self.isFull = false
    if curExp >= self.needExp then
        --材料材料以满当前需要
        if self.curEquipLevel + 1 > self.curEquipMaxLevel then
            self.slider_exp.value = curExp / self.needExp
            self.txt_count.text = curExp .. "/" .. self.needExp
            if curExp > self.needExp then
                MessageMrg.show(TextMap.TXT_NEED_EXP_FULL)
            end
            self.isFull = true
            self.isEffect = true
        else
            self.isLevelUp = true
            self.isEffect = true
            self.curEquipLevel = self.curEquipLevel + 1
            self.curExp = curExp - self.needExp
            self.needExp = self.curEquip:getNeedExp(self.curEquipLevel)
        end
    elseif curExp < 0 then
        self.curEquipLevel = self.curEquipLevel - 1
        self.needExp = self.curEquip:getNeedExp(self.curEquipLevel)
        self.curExp = curExp + self.needExp
    end
    -- self:TweenComm(tempCurExp/self.needExp,self.curExp / self.needExp,1.5,nil,self.sliderTweenValue)
    self.slider_exp.value = self.curExp / self.needExp
    self.txt_count.text = self.curExp .. "/" .. self.needExp
    self:updateCostMoney()
end


function m:delaySetEquips()
    self:selectEquip(self.selectDtata.equip)
    --    self.materialList.repositionNow = true
end

--更新装备
function m:updateEquips(equips)
    if not equips then
        self.binding:Hide("equip")
        return
    end
    self.binding:Show("equip")
    self.equips = equips

    self.list = ClientTool.UpdateMyTable("Prefabs/moduleFabs/equipModule/enchant/equipIcon", self.equip, equips, self)
    --    UluaModuleFuncs.Instance.uTimer:frameTime("delaySetEquips", 5, 1, self.delaySetEquips, self)
    --    self.binding:CallAfterTime(0.1, funcs.handler(self, self.delaySetEquips))
    self:delaySetEquips()
end

function m:ctrlModel(act)
    self._modeAct = act;
end

--加载模型
function m:loadModel(id)
end

--更新角色信息
function m:updateChar(char)
    self.equipInfo:SetActive(false)
    if not char then return end
    self.txt_name.text = char.name

    --    local stars = {}
    --    for i = 1, 5 do
    --        stars[i] = i <= char.star
    --    end
    --    ClientTool.UpdateGrid("", self.star, stars)
    --    self:loadModel(char.id)
    self.char = char
end

local peopleBind

function m:update(lua)
    self.delegate = self.delegate or lua.delegate
    local data = lua.obj
    self.selectDtata = data
    local linkData = Tool.readSuperLinkById( 123)
    if Player.Info.vip >= linkData.vipLevel then
        self.btn_onekey.gameObject:SetActive(true)
    else
        self.btn_onekey.gameObject:SetActive(false)
    end
    local ret = false
    ---------- 未选择英雄----------
    if data.char == nil then
        ret = false
        self:updateEquips(nil)
        self:updateChar(nil)
    else
        ---------- 已选择英雄-----------
        ret = true
        local char = data.char
        --        self:updateChar(char)
        self.char = char

        self:updateEquips(char:getEquips(char))
        self.kuangzi.gameObject:SetActive(false)
        if peopleBind == nil then
            peopleBind = ClientTool.loadAndGetLuaBindingFromPool("Prefabs/publicPrefabs/itemAll", self.leftpeople)
        end
        peopleBind:CallUpdate({ "char", data.char, self.kuangzi.width, self.kuangzi.height })
    end
    self.info:SetActive(ret)
    --    self.binding:Hide("materialList")
end

----------------------------------------------- 事件----------------------------------------------------------------------
function m:onClose(go)
    --    UIMrg:pop()
    self.binding.gameObject:SetActive(false)
end

--强化
function m:onPowerUp(go)
    if self.__equip.level == self.curEquipMaxLevel then
        MessageMrg.show(TextMap.TXT_NEED_EXP_FULL) --经验满了。
        return
    end
    local list = self._selectedMaterial
    local material = ""


    table.foreach(list, function(i, v)
        if v > 0 then
            material = material .. i .. ":" .. v .. "|"
        end
    end)
    if material == "" then
        MessageMrg.show(TextMap.PlsSelectMaterial)
        return
    end

    material = string.sub(material, 1, -2)
    Api:equipUp(self.char.id, self.curEquip.index, material, funcs.handler(self, function(result)
        self:gentlyUpdateSlider()
        MusicManager.playByID(32)
    end), function(ret)
        return false
    end)
end

--平缓的改变slider value， 并且播放升级特效
function m:gentlyUpdateSlider()
    self.sliderTweenValue._slider = self.slider_exp
    self.sliderTweenValue.endIndex = self.needExp
    local efffect = ClientTool.load("Effect/Prefab/UI_Zhuangbeiqianghua", self.equipIcon.gameObject)
    efffect.transform.parent = Vector3(0, 0, 0)
    self.binding:CallAfterTime(1, function(...)
        GameObject.Destroy(efffect)
    end)
    --同时获取对应选中的物品并启动对应的
    if self.isEffect then
        self.isEffect = false
        -- self.equipIcon:Show('flash')
    end
    -- if self.isLevelUp and self.equip ~= nil then
    --     self.isLevelUp = false
    --     self.curEquip:updateInfo()
    --     local need = self.curEquip:getNeedExp()
    --     local newExp = self.curEquip.exp --当前经验
    --     self.sliderTweenValue.endIndex = need
    --     self.slider_exp.value = 0
    --     self:TweenComm(0, newExp, 0.5, nil, self.sliderTweenValue)
    -- else
    --     self:TweenComm(self.tempCurExp, self.curExp, 0.5, nil, self.sliderTweenValue)
    -- end
    self:TweenComm(self.tempCurExp, self.curExp, 0.5, nil, self.sliderTweenValue)

    self.binding:CallAfterTime(0.5, function() self:selectEquip(self.curEquip) end)
end

function m:TweenComm(from, to, duration, anima, tween)

    tween:ResetToBeginning()
    tween.from = from
    tween.to = to
    tween.duration = duration
    if anima ~= nil then
        tween.animationCurve = anima
    end
    tween:PlayForward()
end

function m:onOneKey(go)
    if self.__equip.level == self.curEquipMaxLevel then
        MessageMrg.show(TextMap.TXT_NEED_EXP_FULL) --经验满了.
        return
    end
    DialogMrg.ShowDialog(string.gsub(TextMap.GetValue("LocalKey_703"),"{0}",tonumber(self.onekey_cost.text)), function()
        Api:oneStepEquipUp(self.char.id, self.curEquip.index, funcs.handler(self, function(result)
            self:selectEquip(self.curEquip)
            self:createEffect()
            MusicManager.playByID(32)
        end), function(ret)
            return false
        end)
    end)
end

--添加特效啊
function m:createEffect()
    -- body
end

function m:onChangeCharCallBack(charInfo)
    self.delegate.node:SetActive(false)

    self.binding.gameObject:SetActive(true)
    local equips = charInfo:getEquips()
    local curEquipCount = 0
    for i = 1, 6 do
        local equip = equips[i]
        if (equip:getChar() ~= nil) then
            curEquipCount = i
        end
    end
    if curEquipCount == 0 then
        MessageMrg.show(TextMap.GetValue("Text825"), function() end)
    else
        local tempObj = {}
        tempObj.char = charInfo --人物信息
        tempObj.equip = equips[curEquipCount] --选中的装备
        self:update({ obj = tempObj })
        tempObj = nil
    end
end

--更换英雄
function m:onChangeChar(go)
    --    selectList:show(1, funcs.handler(self, self.onChangeCharCallBack))
    self.binding.gameObject:SetActive(false)
    self.delegate.node:SetActive(true)
    self.delegate:showHero({ type = 1, callBack = funcs.handler(self, self.onChangeCharCallBack) })
end

--事件注册
function m:onClick(go, name)
    if name == "btn_close" then
        self:onClose(go)
    elseif name == "btn_powerUp" then
        self:onPowerUp(go)
    elseif name == "btn_changeChar" then
        self:onChangeChar(go)
    elseif name == "btn_onekey" then
        self:onOneKey(go)
    end
end

function m:Start()
    --TODO 强化
    --self:update(nil)
end

function m:create()
    return self
end

return m