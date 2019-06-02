--装备信息
local m = {}
local HAS_EQUIP = TextMap.GetValue("Text528")
local TXT_Synthetic = TextMap.GetValue("Text529")
local TXT_EQUIP = TextMap.GetValue("Text49")
local TXT_OK = TextMap.GetValue("Text351")
local TXT_NEED_LV = TextMap.GetValue("Text530")
local TXT_BINDING = TextMap.GetValue("Text531")
local TXT_NO_EQUIP = TextMap.GetValue("Text532")
local TXT_COM_EQUIP = TextMap.GetValue("Text533")
function m:show(equip, char, pos, closeCallBack)
    UIMrg:pushWindow("Prefabs/moduleFabs/charModule/sub/equip_info", {
        equip = equip,
        char = char,
        pos = pos,
        closeCallBack = closeCallBack
    })
end

--关闭
function m:destory(ret)
    --    SendBatching.DestroyGameOject(self.gameObject)
    -- UluaModuleFuncs.Instance.uTimer:removeFrameTime("piaozi")
    UIMrg:popWindow()
    Player:removeListener("equipInfo")
end

function m:onClose()
    self:destory()
    if self.closeCallBack ~= nil then
        self.closeCallBack()
    end
end

function m:onEnter()
    self:onUpdate(true)
end


function m:weapEquip(char, pos)
    local that = self
    Api:wearEquip(char.id, pos, function()
        char:updateInfo()
        MusicManager.playByID(34)
        that:onClose()
		if that.delegate ~= nil then 
			that.delegate:onUpdate(true)
		end 
    end, function(ret)
        return false
    end)
end

function m:doAction()
    local equip = self.equip
    local state = self.state
    if state == ITEM_STATE.no then
        --无装备
        MessageMrg.show(TXT_NO_EQUIP)
    elseif state == ITEM_STATE.en then
        MessageMrg.show(TXT_COM_EQUIP)
    elseif state == ITEM_STATE.can then
        --可装备
        self:weapEquip(self.char, self.pos)

    elseif state == ITEM_STATE.wear then
        --已装备
        self:destory()
    elseif state == ITEM_STATE.cant then
        MessageMrg.show(TXT_NEED_LV .. equip.lv)
    end
end

--技能描述显示
function m:onTooltip(name)
    if (self.equip ~= nil) then
        return self.equip.desc or ""
    end
    return ""
end

--按钮事件
function m:onClick(go, name)
    if name == "btn_back" then
        self:destory()
    elseif name == "button" then
        self:doAction()
    elseif name == "btn_close" then
        self.binding:ScalePage(2, self.root, 0.28, function()
            self:destory()
        end)
    end
end


function m:onUpdate(ret)
    self.equip:updateInfo()
    self:updateEquipInfo(self.equip)
    self.EquipmentSynthesis:CallUpdate({ equip = self.equip, delegate = self, back = ret or false })
    local state = self.equip:getState(self.char)
    if state == ITEM_STATE.can then
        self.__itemAll:CallUpdate({ "char", equip, self.img_frame.width, self.img_frame.height, nil, "show" })
    else
        self.__itemAll:CallUpdate({ "char", equip, self.img_frame.width, self.img_frame.height })
    end
end

--信息状态信息
function m:updateEquipInfo(equip)
    self.txt_count.text = string.gsub(HAS_EQUIP, "{0}", equip.count)

    local state = equip:getState(self.char)
    if state == ITEM_STATE.no then
        --无装备
        self.txt_button.text = TXT_EQUIP
        self.button.isEnabled = false
        self.txt_info.text = TXT_NEED_LV .. equip.lv
    elseif state == ITEM_STATE.en_cant then
        --可合成,等级不足
        self.txt_button.text = TXT_EQUIP
        self.button.isEnabled = false
        self.txt_info.text = "[ff0000]" .. TXT_NEED_LV .. equip.lv .. "[-]"
    elseif state == ITEM_STATE.en then
        self.txt_button.text = TXT_EQUIP
        self.button.isEnabled = false
        self.txt_info.text = TXT_Synthetic --TXT_NEED_LV .. equip.lv
    elseif state == ITEM_STATE.can then
        --可装备
        self.txt_button.text = TXT_EQUIP
        self.txt_info.text = TXT_BINDING
        self.button.isEnabled = true
    elseif state == ITEM_STATE.cant then
        self.txt_button.text = TXT_EQUIP
        self.txt_info.text = "[ff0000]" .. TXT_NEED_LV .. equip.lv .. "[-]"
        self.button.isEnabled = true
    elseif state == ITEM_STATE.wear then
        --已装备
        self.txt_button.text = TXT_OK

        self.txt_info.text = TXT_NEED_LV .. equip.lv
        self.button.isEnabled = true
    end
    self.state = state
end

function m:hideButton(ret)
    if not ret then
        self.binding:Show("button")
    else
        self.binding:Hide("button")
    end
end

function m:setStars(star)
    local stars = {}
    for i = 1, star do
        stars[i] = i
    end
    ClientTool.UpdateMyTable("", self.star, stars)
end

function m:update(lua)
    local equip = lua.equip

    --self:setStars(equip.level)

    self.equip = equip
    self.closeCallBack = lua.closeCallBack
	self.delegate = lua.delegate
    self.char = lua.char
    self.pos = lua.pos

    if self.__itemAll == nil then
        self.__itemAll = ClientTool.loadAndGetLuaBindingFromPool("Prefabs/publicPrefabs/itemAll", self.img_frame.gameObject)
        --self.binding:CallAfterTime(0.2, function()
        --    ClientTool.AdjustDepth(self.__itemAll.gameObject, self.img_frame.depth)
        --end)
    end

    local state = self.equip:getState(self.char)
    if state == ITEM_STATE.can then
        self.__itemAll:CallUpdate({ "char", equip, self.img_frame.width, self.img_frame.height, nil, "show" })
    else
        self.__itemAll:CallUpdate({ "char", equip, self.img_frame.width, self.img_frame.height })
    end
    --    self.img_frame.spriteName = equip:getFrame()
    --    self.img_icon.Url = equip:getHead()
    self.txt_equipName.text = equip:getDisplayColorName()
    --    self.lab_desc.text = equip.desc --装备介绍
    self.txt_attr.text = equip:getAttrDesc()

    self:updateEquipInfo(equip)
    self.EquipmentSynthesis:CallUpdate({ equip = equip, delegate = self })
end

----------------------------------------------- 创建----------------------------------------------------------------------
function m:create(binding)
    self.binding = binding
    self.gameObject = binding.gameObject
    return self
end

function m:Start()
    self.img_frame.enabled = false
    --    self.binding:ScalePage(1,self.root,0.28)
    ClientTool.AddClick(self.btn_back, funcs.handler(self, self.destory))
end



-----------------------------------------------------------------------------------------------------------------------
return m