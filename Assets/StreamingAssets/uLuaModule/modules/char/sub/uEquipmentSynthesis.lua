--装备合成
local m = {}
local COMBINE_COST = TextMap.GetValue("Text534")

local ITEM_NO_ENGOUNT = TextMap.GetValue("Text535")

function m:playState(equip)
end


--显示碎片或者装备来源 item是char类型数据
function m:showDrop(item)
    self.__showDrop = true
    self.drop:SetActive(true)
    self.piece:SetActive(false)
    --    self.gold_money.text =item.Table.buy_gold
    local times = Player.Times.buyEquip
    local row = TableReader:TableRowByUnique("buyLimitTimes", "vip_level", Player.Info.vip)
    if row.buyequip_limit_times == 0 then
        self.binding:Hide("goldbuy_btn")
        self.delegate:hideButton(false)
    else
        self.binding:Show("goldbuy_btn")
        self.delegate:hideButton(true)
    end
    --    local time = row.buyequip_limit_times - times
    --    self._buyEquipTimes = time
    --    if time == 0 then
    --        time = "[f8ad06]" .. time .. "[-]"
    --    else
    --        time = "[79ec78]" .. time .. "[-]"
    --    end
    --    self.buy_times.text = TextMap.getText("TXT_TODAY_BUY_TIMES", { time })
    local drop_info = {}
    local source = item.Table.droptype
    for i = 0, source.Count - 1 do
        local sc = source[i]
        local tb = Tool.readSuperLinkById( sc)
        if tb ~= nil then
            table.insert(drop_info, { source = tb })
        end
    end
    ClientTool.UpdateMyTable("Prefabs/moduleFabs/charModule/sub/drop_info2", self.dropList, drop_info, self)
    if table.getn(drop_info) == 0 then
        self.txt_no_drop:SetActive(true)
    else
        self.txt_no_drop:SetActive(false)
    end
end

local clicked = false
function m:playEffect()
    clicked = true
    local item = self["efEquipMerge" .. self.__itemCount - 1]
    if item then
        item:ResetToBeginning()
    end
    self.binding:CallAfterTime(1.2, function()
        clicked = false
        --        self:backFunction()
        self.delegate:onUpdate(true)
    end)
end

function m:updateItem(item)
    self.item = item
    self.txt_name.text = item:getDisplayColorName()
    self.item_frame.enabled = false
    if self.__itemAll == nil then
        self.__itemAll = ClientTool.loadAndGetLuaBindingFromPool("Prefabs/publicPrefabs/itemAll", self.item_frame.gameObject)
        --self.binding:CallAfterTime(0.2, function()
        --    ClientTool.AdjustDepth(self.__itemAll.gameObject, self.item_frame.depth)
        --end)
    end
    self.__itemAll:CallUpdate({ "char", item, self.item_frame.width, self.item_frame.height })
    self.__showDrop = false
    local tb = item.Table
    local row = TableReader:TableRowByID(item:getType(), item.id); --取到要合成的目标东西的那一行
    if not row:ContainsKey("consume") then
        self:showDrop(item)
        return
    end
    local consume = row.consume
    local count = consume.Count
    self.__itemCount = count
    if count == 0 then
        self:showDrop(item)
    else
        local items = {}
        local cur_empty_cell = nil
        local no_item = nil
        for i = 0, count - 1 do
            local item = consume[i]
            local type = item.consume_type
            local arg = item.consume_arg
            local arg2 = item.consume_arg2
            if type == "money" then
                self.txt_cost.text = COMBINE_COST
                self.txt_costValue.text = toolFun.moneyNumberShowOne(math.floor(tonumber(arg)))
            elseif type == "equip" then
                local equip = Equip:new(arg)
                equip:setCostCount(arg2)
                if not cur_empty_cell and equip.count < arg2 then cur_empty_cell = i end
                table.insert(items, equip)
            elseif type == "equipPiece" then
                local equipPiece = EquipPiece:new(arg)
                equipPiece:setCostCount(arg2)
                if not no_item and equipPiece.count < arg2 then no_item = true end
                table.insert(items, equipPiece)
            elseif type == "reel" then
                local reel = Reel:new(arg)
                reel:setCostCount(arg2)
                if not cur_empty_cell and reel.count < arg2 then cur_empty_cell = i end
                table.insert(items, reel)
            elseif type == "reelPiece" then
                local reelPiece = ReelPiece:new(arg)
                reelPiece:setCostCount(arg2)
                if not no_item and reelPiece.count < arg2 then no_item = true end
                table.insert(items, reelPiece)
            end
        end

        self.drop:SetActive(false)
        self.piece:SetActive(true)
        local list = ClientTool.UpdateMyTable("Prefabs/moduleFabs/charModule/sub/item_piece", self.pieceList, items, self)
        self.curPieceCell = nil
        self.binding:CallManyFrame(function()
            self.pieceList.repositionNow = true
        end, 2)
        --self.pieceList.repositionNow = true

        if not no_item and cur_empty_cell then
            self.curPieceCell = list[cur_empty_cell]
        end
        self._no_item = no_item
        local len = table.getn(items)
        --        self.binding:CallAfterTime(0.1, funcs.handler(self, function()
        --            local width = self.pieceList.width
        --            if len == 1 then
        --                self.line.width = 2
        --            else
        --                self.line.width = width - (width / len) + 4 * len + 8
        --            end
        --        end))
        if len == 1 then
            self.line.width = 4
        elseif len == 2 then
            self.line.width = 100
        elseif len == 3 then
            self.line.width = 191
        elseif len == 4 then
            self.line.width = 280
        end

        self.combineItem = item
        if len == 0 then
            self:showDrop(item)
        end
    end
end

--装备导航
function m:setEquipTitle(equip, index)
    local len = table.getn(self.equip_list)
    self.oldIndex = index
    self.next_index = index + 1
    if equip.color >= 2 and index < 4 then
        self.button_Drop.gameObject:SetActive(true)
    else
        self.button_Drop.gameObject:SetActive(false)
    end
    if index == 1 then
        self.equip_list = {}
        equip:isSelected(true)
        self.equip_list[index] = equip
        self:updateItem(equip)
    else
        self.button_ReturnSyn.gameObject:SetActive(false)
        if index < table.getn(self.equip_list) then
            table.remove(self.equip_list, index)
        end
        table.foreach(self.equip_list, function(i, v)
            v:isSelected(false)
        end)
        equip:isSelected(true)
        self.equip_list[index] = equip
        self:updateItem(equip)
    end
    --    ClientTool.UpdateMyTable("Prefabs/moduleFabs/equipModule/sub/equip_title", self.titleList, self.equip_list, self)
    self.titleList:refresh("Prefabs/moduleFabs/charModule/sub/equip_title", self.equip_list, self)

    if index == 1 then
        self.equip:updateInfo()
        local state = self.equip:getState(self.char)
        self.__state = state
        if state == ITEM_STATE.can or state == ITEM_STATE.cant then
            self.delegate:hideButton(false)
            self:hideButton(true)
            if self.__showDrop == true then
                self.binding:Hide("goldbuy_btn")
            end
        else
            self.delegate:hideButton(true)
            self:hideButton(false)
        end
    else
        self.delegate:hideButton(true)
        self:hideButton(false)
    end
end

function m:update(lua)
    self.delegate = lua.delegate
    self.char = lua.delegate.char
    self.button_Drop.gameObject:SetActive(false)
    self.button_ReturnSyn.gameObject:SetActive(false)
    if lua.back == true and self.item and self.oldIndex ~= 1 then
        self.item:updateInfo()
        if self.item.count >= self.item._costCount then
            --self.isBuy = false
            self:onBack()
        else
            self:setEquipTitle(self.item, self.oldIndex)
        end
    else
        self.equip = lua.equip
        self.equip_list = {}
        self:setEquipTitle(lua.equip, 1)
    end
end

function m:hideButton(ret)
    if ret then
        self.binding:Hide("btn_combine")
    else
        self.binding:Show("btn_combine")
    end
end

function m:showTip(cell)
    ClientTool.AlignToObject(self.lab_tip.gameObject, cell.gameObject)
    self.binding:Show("lab_tip")
    self.lab_tip:ResetToBeginning()
    self.lab_tip.enabled = true
end

function m:backFunction()
    if self.combineItem ~= nil then
        local list = self.equip_list
        local len = table.getn(list)
        if len == 1 then
            self:setEquipTitle(list[1], 1)
        else
            self:setEquipTitle(list[len - 1], len - 1)
        end
    end
end

--合成
function m:onCombine(go)
    if self.combineItem ~= nil then
        local item = self.combineItem
        local that = self
        local list = self.equip_list
        local len = table.getn(list)
        if self.curPieceCell then
            if self.combineItem:getType() == "equip" and self.combineItem:canCompose() then
                self:showTip(self.curPieceCell)
                return
            end
        end
        if self._no_item then
            return MessageMrg.show(ITEM_NO_ENGOUNT)
        end
        Api:combineFunc(item:getType(), item.id, function(result)
            that:playEffect()
            MusicManager.playByID(31) --装备合成音效
        end, function(ret)
            if ret == 26 then
                MessageMrg.show(ITEM_NO_ENGOUNT)
                return true
            end
            return false
        end)
    end
end

--返回上一级装备合成信息
function m:onBack(go)
    local list = self.equip_list
    local len = table.getn(list)
    if len == 1 then
        local state = self.equip:getState(self.char)
        if state == ITEM_STATE.can then
            self.delegate:hideButton(false)
            self:hideButton(true)
        else
            self.delegate:hideButton(true)
            self:hideButton(false)
        end
        return
    end
    table.remove(list)
    len = table.getn(list)
    local item = list[len]
    if item then
        self:setEquipTitle(item, len)
    end
end


function m:onBuyEquip(go)
    if self._buyEquipTimes == 0 then
        local row = TableReader:TableRowByUnique("buyLimitTimes", "vip_level", Player.Info.vip + 1)
        if row == nil then
            MessageMrg.show(TextMap.GetValue("Text536"))
            return
        else
            local msg = string.gsub(TextMap.GetValue("Text69"),"{0}",Player.Info.vip + 1)
            DialogMrg.ShowDialog(string.gsub(msg,"{1}",row.buyequip_limit_times ), function()
                DialogMrg.chognzhi()
            end, function()
            end, TextMap.GetValue("Text68"), "chong_zhi")
            return
        end
    end
    local temp = {}
    temp.obj = self.item
    temp.callback = funcs.handler(self, function()
        --        self.delegate:onUpdate(true)
        --self:onBack(go)
    end)
    UIMrg:pushWindow("Prefabs/moduleFabs/charModule/sub/buyEquip", temp)
    temp = nil
end

function m:onClick(go, name)
    if name == "btn_combine" then
        if clicked == true then return end
        self:onCombine(go)
    elseif name == "btn_back" then
        self:onBack(go)
    elseif name == "goldbuy_btn" then
        self:onBuyEquip(go)
    elseif name == "button_Drop" then
        self:showDrop(self.item)
        self.button_ReturnSyn.gameObject:SetActive(true)
        self.button_Drop.gameObject:SetActive(false)
    elseif name == "button_ReturnSyn" then
        self:setEquipTitle(self.item, self.oldIndex)
        --self:updateItem(self.item)
        self.button_Drop.gameObject:SetActive(true)
        self.button_ReturnSyn.gameObject:SetActive(false)
    end
end

function m:create()
    return self
end

return m