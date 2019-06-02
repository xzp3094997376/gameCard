
local m = {}

local Type = {
    [1] = "common",
    [2] = "expert",
    [3] = "master"
}
local base_consume = nil 

local _hp_arg = 0.250
local _phatk_arg = 3.330
local _phdef_arg = 6
local _mgdef_arg = 6

function m:update(lua)
    self.powerCalcu = 0
    self.AllPowerInit = _hp_arg + _phatk_arg + _phdef_arg + _mgdef_arg
	self.char = lua.char
    self.delegate = lua.delegate
    self.fullCount = 0
    self.OneKeyState = false
    self:onUpdate(lua.char, true)
    self.OneKeyCul.gameObject:SetActive(false)
    --self.btn_OneKey.gameObject:SetActive(true)
end

function m:showOperateAlert(desc)
    self.binding:CallManyFrame(function()
        OperateAlert.getInstance:showToGameObject(desc, self.img_hero.gameObject)
    end)
end

function m:updateDesc()

end

function m:isHasFull()
    self.fullCount = self.fullCount + 1
    if self.fullCount == 4 then
        self.btn_cultivate.gameObject:SetActive(false)
        self.btn_OneKey.gameObject:SetActive(false)
        self.btn_OneKey_gray.gameObject:SetActive(true)
        self.btn_cultivate_gray.gameObject:SetActive(true)
        self.OneKeyState = false
    end
end

function m:judgeAddProInfo(index, num)
    if index == 1 then
        self.powerCalcu = self.powerCalcu + (string.format("%0.03f", (tonumber(num) / 1000) + 1) *  _hp_arg)
        --print("生命系数值："..num..":"..string.format("%0.03f", ((tonumber(num) / 1000) + 1) *  _hp_arg))
    elseif index == 2 then
        self.powerCalcu = self.powerCalcu + (string.format("%0.03f", (tonumber(num) / 1000) + 1) *  _phatk_arg)
        --print("攻击系数值："..num..":"..string.format("%0.03f", ((tonumber(num) / 1000) + 1) * _phatk_arg))
    elseif index == 3 then
        self.powerCalcu = self.powerCalcu + (string.format("%0.03f", (tonumber(num) / 1000) + 1) *  _phdef_arg)
        --print("物防系数值："..num..":"..string.format("%0.03f", ((tonumber(num) / 1000) + 1) *  _phdef_arg))
    elseif index == 4 then
        self.powerCalcu = self.powerCalcu + (string.format("%0.03f", (tonumber(num) / 1000) + 1) *  _mgdef_arg)
        --print("法防系数值："..num..":"..string.format("%0.03f", ((tonumber(num) / 1000) + 1) *  _mgdef_arg))
    end
end

function m:onUpdate(char)
    self.powerCalcu = 0
    self.char = char
	m:updateMainAttr()
	local xilian = m:getAttrList(self.char.info.xilian)
	local xilian_tmp = m:getAttrList(self.char.info.xilian_tmp)
	local bindings = {}
	bindings[1] = self.life
	bindings[2] = self.atk
	bindings[3] = self.ph_denfense
	bindings[4] = self.magic_defense
    local list = {}
    local temp = self.char:getAttrCultivateDesc()
	local lv = m:getMaxLevel(self.char.lv)
    local row = Tool.charXilianIds["char_" .. self.char.star .. "_" .. lv]
	self.status = 0
	self.isShowCancel = false
    if row then
        self.fullCount = 0
        for i = 1, 4 do
            local obj = {}
            obj.cur = xilian[i] or 0
            obj.next = xilian_tmp[i] or 0
            obj.max = row[i] or 0
            obj.name = temp[i] or ""
            obj.delegate = self
			local t = tonumber(obj.next) or 0
			if t < 0 then 
				self.isShowCancel = true
			end 
            list[i] = obj
			if t > 0 then self.status = 1 end 
            m:judgeAddProInfo(i, tonumber(obj.next))
			bindings[i]:CallUpdate({data = list[i]})
        end
	else 
		for i = 1, 4 do
			bindings[i].gameObject:SetActive(false)
        end
    end
    --print(self.AllPowerInit..":"..self.powerCalcu)
	self.txt_name.text = self.char:getDisplayName()
    --local index = 0
    --for i = 1, #xilian_tmp do
    --    if xilian_tmp[i] == 0 then
    --        index = index + 1
    --    end
    --end

    self.btn_replace.transform.localPosition = Vector3(460, -49, 0)
    self.btn_cultivate.gameObject:SetActive(true)
    self.btn_OneKey.gameObject:SetActive(true)
    if self.OneKeyState == false then
        if self.status == 1 then 
            self.btn_replace.gameObject:SetActive(true)
            self.btn_OneKey.gameObject:SetActive(false)
            if self.isShowCancel == false then
                self.btn_replace.transform.localPosition = Vector3(460, 27, 0)
                self.btn_cultivate.gameObject:SetActive(false)
            end
        else
            self.btn_replace.gameObject:SetActive(false)
            self.btn_cultivate.gameObject:SetActive(true)
            --self.btn_OneKey.gameObject:SetActive(true)
            -- if isShowCancel then self.btn_cultivate.gameObject:SetActive(false)
            -- else self.btn_cultivate.gameObject:SetActive(true) end
        end
        if self.isShowCancel == true then
            self.btn_OneKey.gameObject:SetActive(false)
        end
    else
        self.btn_cultivate.gameObject:SetActive(false)
        self.btn_replace.gameObject:SetActive(false)
        self.btn_OneKey.gameObject:SetActive(true)
    end
	
     if self.fullCount == 4 then
        self.btn_cultivate.gameObject:SetActive(false)
        self.btn_OneKey.gameObject:SetActive(false)
        self.btn_OneKey_gray.gameObject:SetActive(true)
        self.btn_cultivate_gray.gameObject:SetActive(true)
        self.OneKeyState = false
     end

    -- if self.OneKeyState then
    --     self.btn_OneKey.gameObject:SetActive(true)
    --     self.btn_cultivate.gameObject:SetActive(true)
    --     self.btn_replace.gameObject:SetActive(false)
    -- else
    --     self.btn_OneKey.gameObject:SetActive(true)
    --     self.btn_cultivate.gameObject:SetActive(true)
    --     self.btn_OneKey_gray.gameObject:SetActive(false)
    --     self.btn_cultivate_gray.gameObject:SetActive(false)
    -- end
	--self.btn_cancel.gameObject:SetActive(isShowCancel)
	--self.btn_cancel.gameObject:SetActive(isShowCancel)
	
	self:selectNumFun(self.selectNum)
		-- 消耗
	if self._item == nil then 
		self._item = uItem:new(base_consume.value2)
	end 
	self._item:updateInfo()
	--local atlasName = packTool:getIconByName(data.cur.icon)
    self.img_icon:setImage(self._item:getHead())
	self.txt_has.text = TextMap.GetValue("Text_1_814") .. self._item.name .. "："
	self.txt_num.text = self._item.count
	self.img_hero:LoadByModelId(self.char.modelid, "idle", function() end, false, -1, 1)
end

function m:getMaxLevel(lv)
    if Tool.charXilianLevels then
        local item = Tool.charXilianLevels["char_" .. self.char.star]
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
    if Tool.charXilianLevels == nil then
        local list = {}
        local _list = {}
        TableReader:ForEachLuaTable("charXilianSettings", function(index, item)
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
        Tool.charXilianIds = _list
        Tool.charXilianLevels = list
    end
end

function m:getIconAndNum(tb)
    local tp = tb.value
    local icon, num, name
    if tp == "money" then
        icon = Tool.getResIcon(tp)
        num = tb.value2
        name = TextMap.GetValue("Text40")
    elseif tp == "gold" then
        icon =  Tool.getResIcon(tp)
        num = tb.value2
        name = TextMap.GetValue("Text41")
    else
        local item = TableReader:TableRowByID(tp, tb.value2)
        icon = item.iconid
        num = tb.other
        name = item.name
    end
    return { icon = icon, num = num, name = name, type = tp }
end

function m:onReplace()
    local xilian_tmp = m:getAttrList(self.char.info.xilian_tmp)
    local xilian = m:getAttrList(self.char.info.xilian)
    Api:charXilianReplaceAttr(self.char.id, function(result)
		print("replace ret = " .. tostring(result))
        --self.data:updateInfo()
		m._item:updateInfo()
		m:onUpdate(self.char)
        --self.btn_OneKey.gameObject:SetActive(true)
        MusicManager.playByID(49)
        self.delegate:updateRedPoint()
        --Events.Brocast('updateLeft', self.data)
        --self.delegate:showStrongEffect()
        --local list = self.data:getMagic()
		local temp = self.char:getAttrCultivateDesc()
		local desc = {[1] = temp[1], [2] = temp[3], [3] = temp[5], [4] = temp[7]}
        local lv = m:getMaxLevel(self.char.lv)
        local row = Tool.charXilianIds["char_" .. self.char.star .. "_" .. lv]
		local xtmp = xilian_tmp[i] or 0
		local xl = xilian[i] or 0
        local descList = {}
        for i = 1, #desc do
            local num = xtmp or 0
            if num ~= 0 then
                num = math.min(row[i] - xl, num)

                if (num > 0 and xl < row[i]) or num < 0 then
                    if num > 0 then
                        num = "+" .. num
                    end
                    local str = string.gsub(desc[i], "{0}", num)
                    table.insert(descList, str)
                end
            end
        end
        if #descList > 0 then
            OperateAlert.getInstance:showToGameObject(descList, self.img_hero.gameObject)
        end

        if self.OneKeyState then
            m:CallBackOnekeyCul(self.isInte)
        else
            m:onUpdate(self.char)
        end
    end, function() 
        m:onUpdate(self.char)
    end)
end 

function m:onCancel()
    Api:charXilianGiveUp(self.char.id, function(result)
        --self.data:updateInfo()
        m:onUpdate(self.char)
        --Events.Brocast('updateLeft', self.data)
		--m:ob()
    end)
end


function m:onCultivate()
    --local last_char = Char:new(self.char.id)
	Api:charXilian(self.char.id, Type[self.selectType], self.selectNum, function(result)
        MusicManager.playByID(48)
        self.delegate:updateRedPoint()
        m:onUpdate(self.char)
    end)
end

function m:selectTypeFun(index)
	local tb = TableReader:TableRowByID("charArgs", "char_xilian_".. Type[index] .. "_vip")
	if tb == nil then
		MessageMrg.show(TextMap.GetValue("Text_1_815"))
		return 
	end 
	if Player.Info.vip < tb.value then 
		MessageMrg.show(TextMap.GetValue("Text_1_816")..tb.value ..TextMap.GetValue("Text_1_817"))
		return 
	end 
	self.selectType = index 
	
	self.item1:CallUpdate(self.obj1)
    self.item2:CallUpdate(self.obj2)
    self.item3:CallUpdate(self.obj3)
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

function m:CallBackOnekeyCul(isIntelligence)
    self.isInte = isIntelligence
    self.btn_cultivate.gameObject:SetActive(false)
    --self.btn_cultivate_gray.gameObject:SetActive(true)
    self.Label_oneKey.text = TextMap.GetValue("Text_1_162")
    self.Label_oneKey.fontSize = 36
    self.OneKeyState = true
    Api:charXilian(self.char.id, Type[self.selectType], self.selectNum, function(result)
        MusicManager.playByID(48)
        m:onUpdate(self.char)
        self.delegate:updateRedPoint()
        --判断属性是否瞒住以下条件
        --1：属性全为正数
        if self.isShowCancel == false and self.status == 1 then
            self.binding:CallAfterTime(0.2, function()
                if self.OneKeyState == false then 
                    m:onUpdate(self.char)
                    return 
                end
                self:onReplace()
            end)
        end
        --2：不使战力增加，0.5秒之后进行下次的培养
        if self.AllPowerInit >= self.powerCalcu then
            self.binding:CallAfterTime(0.5, function()
                if self.OneKeyState == false then 
                    m:onUpdate(self.char)
                    return 
                end
                m:CallBackOnekeyCul(self.isInte)
            end)
        end
        --3：战斗力增加了，不全为正数，且勾选了智能替换，就播放特效进行下次培养
        if self.powerCalcu > self.AllPowerInit and self.isShowCancel == true and isIntelligence then
            self.binding:CallAfterTime(0.2, function()
                if self.OneKeyState == false then 
                    m:onUpdate(self.char)
                    return 
                end
                self:onReplace()
            end)
        end
        --4：战斗力增加了，不全为正数，且没勾选智能替换，就停止培养，按钮重置
        if self.powerCalcu > self.AllPowerInit and self.isShowCancel == true and isIntelligence == false then
            self.OneKeyState = false
            self.Label_oneKey.text = TextMap.GetValue("Text_1_818")
            self.Label_oneKey.fontSize = 30
            m:onUpdate(self.char)
        end
    end, function()
        self.OneKeyState = false
        self.Label_oneKey.text = TextMap.GetValue("Text_1_818")
        self.Label_oneKey.fontSize = 30
        m:onUpdate(self.char)
    end)
end

function m:onClick(go, name)
    if name == "btn_replace" then
		self:onReplace()
	elseif name == "btn_cultivate" then 
		self:onCultivate()
	elseif name == "btn_cancel" then 
		self:onCancel()
	elseif name == "btn_one" then 
		self:selectNumFun(1)
	elseif name == "btn_five" then
		self:selectNumFun(5)
	elseif name == "btn_ten" then 
		self:selectNumFun(10)
    elseif name == "btn_OneKey" then
        if self.OneKeyState then
            self.OneKeyState = false
            self.Label_oneKey.text = TextMap.GetValue("Text_1_818")
            self.Label_oneKey.fontSize = 30
        else
            local data = {}
            data.delegate = self
            self.OneKeyCul.gameObject:SetActive(true)
            self.OneKeyCul:CallUpdate(self)
        end
    elseif name == "btn_cultivate_gray" or name == "btn_OneKey_gray" then
        MessageMrg.show(TextMap.GetValue("LocalKey_655"))
    end
end

function m:updateBtn()

end 

function m:Start()
	self.status = 0
	self.selectNum = 1
	self.selectType = 1
	base_consume = TableReader:TableRowByID("charArgs",  "char_xilian_normal_consume")
	local common_consume = TableReader:TableRowByID("charArgs",  "char_common_xilian_consume")
	local expert_consume = TableReader:TableRowByID("charArgs",  "char_expert_xilian_consume")
	local master_consume = TableReader:TableRowByID("charArgs",  "char_master_xilian_consume")
		
	local obj = {}
    local cur = m:getIconAndNum(base_consume)
	
    obj.cur = cur
    obj.next = m:getIconAndNum(common_consume)
    obj.type = TextMap.GetValue("Text1126")
    obj.index = 1
    obj.delegate = self
    self.obj1 = obj
	self.item1:CallUpdate(obj)
		
	local obj = {}
    obj.cur = cur
    obj.next = m:getIconAndNum(expert_consume)
    obj.type = TextMap.GetValue("Text1127")
    obj.index = 2
    obj.delegate = self
    self.obj2 = obj
	self.item2:CallUpdate(obj)
	
	local obj = {}
    obj.cur = cur
    obj.next = m:getIconAndNum(master_consume)
    obj.type = TextMap.GetValue("Text1128")
    obj.index = 3
    obj.delegate = self
    self.obj3 = obj
	self.item3:CallUpdate(obj)
end

function m:selectNumFun(index)	
	local tb = TableReader:TableRowByID("charArgs", "char_xilian_".. index .. "_limit")
	if tb == nil then
		MessageMrg.show(TextMap.GetValue("Text_1_815"))
		return 
	end 
	local ret = Player.Info.level >= tb.value or Player.Info.vip >= tb.value2
	if not ret then 
        local msg = string.gsub(TextMap.GetValue("LocalKey_826"),"{0}",tb.value)
		MessageMrg.show(string.gsub(msg,"{1}",tb.value2))
		return 
	end 
	
    self.selectNum = index
	
    self.obj1.times = index
    self.obj2.times = index
    self.obj3.times = index
    self.item1:CallUpdate(self.obj1)
    self.item2:CallUpdate(self.obj2)
    self.item3:CallUpdate(self.obj3)
	
	m:updateNum()
end

function m:updateNum()
	if self.selectNum == 1 then 
		self.btn_one.isEnabled = false
		self.btn_five.isEnabled = true
		self.btn_ten.isEnabled = true
		self.txt_one.color = Color.white
		self.txt_one.effectStyle = UILabel.Effect.Outline8
		self.txt_five.effectStyle = UILabel.Effect.None
		self.txt_ten.effectStyle = UILabel.Effect.None
		self.txt_five.color = Color.black
		self.txt_ten.color = Color.black
	elseif self.selectNum == 5 then 
		self.btn_one.isEnabled = true
		self.btn_five.isEnabled = false
		self.btn_ten.isEnabled = true
		self.txt_one.color = Color.black
		self.txt_five.color = Color.white
		self.txt_ten.color = Color.black
		self.txt_one.effectStyle = UILabel.Effect.None
		self.txt_five.effectStyle = UILabel.Effect.Outline8
		self.txt_ten.effectStyle = UILabel.Effect.None
	elseif self.selectNum == 10 then
		self.btn_one.isEnabled = true
		self.btn_five.isEnabled = true
		self.btn_ten.isEnabled = false
		self.txt_one.color = Color.black
		self.txt_five.color = Color.black
		self.txt_ten.color = Color.white
		self.txt_one.effectStyle = UILabel.Effect.None
		self.txt_five.effectStyle = UILabel.Effect.None
		self.txt_ten.effectStyle = UILabel.Effect.Outline8
	end
end

return m

