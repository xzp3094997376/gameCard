--
-- Created by IntelliJ IDEA.
-- User: xiyou
-- Date: 2015/3/23
-- Time: 9:54
-- To change this template use File | Settings | File Templates.
-- 鬼道洗练
local m = {}
local Type = {
    [1] = "common",
    [2] = "expert",
    [3] = "master"
}
function m:update(lua)
    self.data = lua.data
    self.delegate = lua.delegate
    m:onUpdate()
    --培养丹
    --    m:setIcon(item,self.hasicon)
    --    self.choose1
    --    self.txt_attr1.text
    --    self.txt_num1.text
    --    self.slider1.value
    --[[
    -- self.xilian = info.xilian
       self.xilian_tmp = info.xilian_tmp
       self.xilian_times = info.xilian_times
    -- ]]
end

function m:getMaxLevel(lv)
    if Tool.ghostXilianLevels then
        local item = Tool.ghostXilianLevels[self.data.kind .. "_" .. self.data.star]
        if item == nil then return 20 end
        local l = 20
        table.foreach(item, function(i, v)
            if lv <= v then l = v return l end
        end)
        return l
    end
    return 20
end


function m:updateMainAttr()
    if Tool.ghostXilianLevels == nil then
        local list = {}
        local _list = {}
        TableReader:ForEachLuaTable("ghostXilianSettings", function(index, item)
            local kind, star, level, id = item.kind, item.star, item.level, item.id
            if list[kind .. "_" .. star] == nil then list[kind .. "_" .. star] = {} end
            table.insert(list[kind .. "_" .. star], level)
            local li = {}
            for o = 0, item.limit.Count - 1 do
                li[o + 1] = item.limit[o]
            end
            _list[kind .. "_" .. star .. "_" .. level] = li
            return false
        end)
        Tool.ghostXilianIds = _list    --kind_star_level
        Tool.ghostXilianLevels = list  --kind_star
    end
end

function m:getAttrList(arg)
    local list = {}
    local len = arg.Count
    for i = 0, 3 do
        if i > len - 1 then
            list[i + 1] = 0
        else
            list[i + 1] = arg[i]
        end
    end
    return list
end

local choosetype = 1
function m:onUpdate()
    m:updateMainAttr()
    self.equip.Url = self.data:getHead()
    if self.data.power > 0 then
        self.txt_name.text = self.data:getItemColorName(self.data.star , self.data.name .. " + " ..self.data.power)  -- 装备名称  
    else   
        self.txt_name.text = self.data:getDisplayColorName() --self.data.suitName  -- 装备名称  ghost:getDisplayColorName()
    end

    local xilian = m:getAttrList(self.data.info.xilian)
    local xilian_tmp = m:getAttrList(self.data.info.xilian_tmp)
    if self._item then
        self._item:updateInfo()
        self.num.text = self._item.count
    end
    local lv = m:getMaxLevel(self.data.lv)
    local row = Tool.ghostXilianIds[self.data.kind .. "_" .. self.data.star .. "_" .. lv]
    local desc = self.data:getMagic()

    --这里新的和老的不一样   这个功能暂时屏蔽  
    local list = {}
    if row then
        for i = 1, 4 do
            local obj = {}
            obj.cur = xilian[i]
            obj.next = xilian_tmp[i]
            obj.max = row[i]
            obj.name = string.gsub(desc[i].format, "{0}", "")
            list[i] = obj
        end
        Tool.SetActive(self.unlock, false)
        self.info:SetActive(true)
    else
        self.info:SetActive(false)
        Tool.SetActive(self.unlock, true)
        self.unlock.text = self.data.color .. TextMap.GetValue("Text1125")
    end
    local index = 0
    for i = 1, #xilian_tmp do
        if xilian_tmp[i] == 0 then
            index = index + 1
        end
    end

    --[[
    -- if name == 'btxilian' then
        m:onXiLian()
    elseif name == "btxilianTen" then
        m:onXiLianTen()
    elseif name == "btn_replace" then
        m:onReplace()
    elseif name == "btn_cancel" then
        m:onCancel()
    end]]
    if index ~= #xilian_tmp then
        --没有可替换的属性
        self.binding:Hide("btxilian")
        --        self.binding:Hide("btxilianTen")
        self.binding:Show("btn_replace")
        self.binding:Show("btn_cancel")
    else
        self.binding:Show("btxilian")
        --        self.binding:Show("btxilianTen")
        self.binding:Hide("btn_replace")
        self.binding:Hide("btn_cancel")
    end

    self.itemCells = ClientTool.UpdateGrid("", self.attr, list)
end

function m:getChangeList()
    local xilian = m:getAttrList(self.data.info.xilian)
    local xilian_tmp = m:getAttrList(self.data.info.xilian_tmp)
    local lv = m:getMaxLevel(self.data.lv)
    local row = Tool.ghostXilianIds[self.data.kind .. "_" .. self.data.star .. "_" .. lv]
    local list = {}
    local desc = self.data:getMagic()
    if row then
        for i = 1, 4 do
            local obj = {}
            obj.cur = xilian[i]
            obj.next = xilian_tmp[i]
            obj.max = row[i]
            obj.name = string.gsub(desc[i].format, "{0}", "")
            list[i] = obj
        end
        Tool.SetActive(self.unlock, false)
        self.info:SetActive(true)
    else
        self.info:SetActive(false)
        Tool.SetActive(self.unlock, true)
        self.unlock.text = self.data.color .. TextMap.GetValue("Text1125")
    end
    return list
end

function m:selectIndex(index)
    self._selectIndex = index
    self:CbButton(index)
end

function m:setIcon(item, icon)
    local name = item:getHeadSpriteName()
    local atlasName = packTool:getIconByName(name)
    icon:setImage(name, atlasName)
end



function m:showEffect()
    if self.itemCells ~= nil then
        local xilian_tmp = m:getAttrList(self.data.info.xilian_tmp)
        local recordOpen = {}
        for i = 1, #xilian_tmp do
            if xilian_tmp[i] ~= 0 then
                table.insert(recordOpen, { index = i, item = self.itemCells[i] })
            end
        end
        local time = 1
        for k, v in pairs(recordOpen) do
            v.item:CallManyFrame(function()
                v.item:CallTargetFunction("showEffect", xilian_tmp[v.index])
            end, (k - 1) * 3)
            time = time + (k - 1) * 3
        end

        self.binding:CallManyFrame(function()
            m:onUpdate()
        end, time + 12)
    end
end

function m:onEnter()
    if self._item then
        self._item:updateInfo()
        self.num.text = self._item.count
    end
end

function m:onXiLian()
    local tp = Type[self._selectIndex + 1]
    Api:ghostXilian(self.data.key, tp, choosetype ,function(result)
        self.binding:Show("btn_replace")
        self.binding:Show("btn_cancel")
        self.binding:Hide("btxilian")
        self.binding:Hide("btxilianTen")
        m:showEffect()
        MusicManager.playByID(48)
        self.data:updateInfo()
        --        m:onUpdate()
        Events.Brocast('updateLeft', self.data)
    end)
end

function m:onXiLianTen()
    local tp = Type[self._selectIndex + 1]
    Api:ghostXilianTen(self.data.key, tp, ghostXilian,function(result)
        self.binding:Show("btn_replace")
        self.binding:Show("btn_cancel")
        self.binding:Hide("btxilian")
        self.binding:Hide("btxilianTen")
        MusicManager.playByID(48)
        m:showEffect()
    end, function()
        return false
    end)
end

function m:onCancel()
    Api:ghostXilianGiveUp(self.data.key, function(result)
        self.data:updateInfo()
        m:onUpdate()
        Events.Brocast('updateLeft', self.data)
    end)
end

function m:onReplace()
    local xilian_tmp = m:getAttrList(self.data.info.xilian_tmp)
    local xilian = m:getAttrList(self.data.info.xilian)
    Api:ghostXilianReplaceAttr(self.data.key, function(result)
        self.data:updateInfo()
        m:onUpdate()
        MusicManager.playByID(49)
        Events.Brocast('updateLeft', self.data)
        --self.delegate:showStrongEffect()
        local list = self.data:getMagic()
        local lv = m:getMaxLevel(self.data.lv)
        local row = Tool.ghostXilianIds[self.data.kind .. "_" .. self.data.star .. "_" .. lv]

        local descList = {}
        for i = 1, #list do
            local num = xilian_tmp[i]
            if num ~= 0 then
                num = math.min(row[i] - xilian[i], num)

                if (num > 0 and xilian[i] < row[i]) or num < 0 then
                    if num > 0 then
                        num = "+" .. num
                    end
                    local str = string.gsub(list[i].format, "{0}", num)
                    table.insert(descList, str)
                end
            end
        end
        if #descList > 0 then
            OperateAlert.getInstance:showToGameObject(descList, self.node)
        end
    end)
end

function m:getGhostArg(id)
    return TableReader:TableRowByID("ghostArgs", id)
end

function m:getIconAndNum(tb)
    local tp = tb.arg
    local icon, num, name
    if tp == "money" then
        icon = "resource_jinbi"
        num = tb.arg2
        name = TextMap.GetValue("Text40")
    elseif tp == "gold" then
        icon = "resource_zuanshi"
        num = tb.arg2
        name = TextMap.GetValue("Text41")
    else
        local item = TableReader:TableRowByID(tp, tb.arg2)
        icon = item.iconid
        num = tb.arg3
        name = item.name
    end
    return { icon = icon, num = num, name = name, type = tp }
end

function m:Start()
	choosetype = 1
    self._selectIndex = 0
    local ghost_xilian_normal_consume = m:getGhostArg("ghost_xilian_normal_consume")  -- 洗练固定消耗（洗练消耗等于玩家选择的洗练模式额外消耗加上固定消耗）
    local ghost_common_xilian_consume = m:getGhostArg("ghost_common_xilian_consume")  -- 普通洗练额外消耗
    local obj = {}
    local cur = m:getIconAndNum(ghost_xilian_normal_consume) 
    obj.cur = cur
    obj.next = m:getIconAndNum(ghost_common_xilian_consume) 
    obj.type = TextMap.GetValue("Text1126")
    obj.index = 0
    obj.delegate = self
    self.obj1 = obj
    self.choose1:CallUpdate(obj)
    if ghost_xilian_normal_consume.arg == "item" then
        self._item = uItem:new(ghost_xilian_normal_consume.arg2)
        self.hasdan.text = self._item.name
        local icon = self._item:getHeadSpriteName()
        local atlasName = packTool:getIconByName(icon)
        self.hasicon:setImage(icon, atlasName)
    end
    local that = self
    ClientTool.AddClick(self.hasicon, function()
        if that._item then
            DialogMrg.showPieceDrop(that._item)
        end
    end)
    local ghost_expert_xilian_consume = m:getGhostArg("ghost_expert_xilian_consume") --专家洗练额外消耗
    obj = {}
    obj.delegate = self
    obj.cur = cur
    obj.type = TextMap.GetValue("Text1127")
    obj.index = 1
    obj.next = m:getIconAndNum(ghost_expert_xilian_consume)
    self.obj2 = obj
    self.choose2:CallUpdate(obj)
    local ghost_master_xilian_consume = m:getGhostArg("ghost_master_xilian_consume") --大师洗练额外消耗
    obj = {}
    obj.cur = cur
    obj.delegate = self
    obj.type = TextMap.GetValue("Text1128")
    obj.index = 2
    obj.next = m:getIconAndNum(ghost_master_xilian_consume)
    self.obj3 = obj
    self.choose3:CallUpdate(obj)
	self:updateChooseType()
end

function m:updateChooseType()
	if choosetype == 1 then 
		self.btxilianOne.isEnabled = false
		self.btxilianFive.isEnabled = true
		self.btxilianTen.isEnabled = true
	elseif choosetype == 5 then 
		self.btxilianOne.isEnabled = true
		self.btxilianFive.isEnabled = false
		self.btxilianTen.isEnabled = true
	elseif choosetype == 10 then
		self.btxilianOne.isEnabled = true
		self.btxilianFive.isEnabled = true
		self.btxilianTen.isEnabled = false
	end
end

function m:onClick(go, name)
    if name == 'btxilian' then
        m:onXiLian()
    elseif name == "btxilianTen" then
        --m:onXiLianTen()
		choosetype = 10
		self:updateChooseType()
	elseif name == "btxilianFive" then
		choosetype = 5
		self:updateChooseType()
	elseif name == "btxilianOne"  then 
		choosetype = 1
		self:updateChooseType()
    elseif name == "btn_replace" then
        m:onReplace()
    elseif name == "btn_cancel" then
        m:onCancel()
    elseif name == "btn_choosenum" then
        local lua_data = {}
        lua_data.delegate = self
        UIMrg:pushWindow("Prefabs/moduleFabs/guidao/guidao_choosenum",lua_data)
    end
end

function m:ClickCallBack(index)
    print("...1111.."..index)
    choosetype = index

    self.obj1.times = index
    self.obj2.times = index
    self.obj3.times = index
    self.choose1:CallUpdate(self.obj1)
    self.choose2:CallUpdate(self.obj2)
    self.choose3:CallUpdate(self.obj3)
end

function m:CbButton(index)
    index = index +1
    for i=1,3 do
        if self["btn_choose"..i] == self["btn_choose"..index] then
            self["btn_choose"..i].transform:FindChild("haschoose").gameObject:SetActive(true)
        else
            self["btn_choose"..i].transform:FindChild("haschoose").gameObject:SetActive(false)
        end
    end
end

return m

