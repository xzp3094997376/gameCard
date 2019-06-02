local EquipInfo = require("uLuaModule/modules/char/sub/uEquipInfo.lua")

local m = {}

local CAN_NOT_EQUIP = TextMap.GetValue("Text524")
local NO_EQUIP = TextMap.GetValue("Text_1_823") -- TextMap.GetValue("Text1063")
--local NO_EQUIP = ""
local CAN_COM = TextMap.GetValue("Text1064") .. "[-]"
local CAN_EQUP = TextMap.GetValue("Text_1_824") --TextMap.GetValue("Text1065") .. "[-]"

----------------------------------------------- 更新---------------------------------------------------------------------
--[[
ITEM_STATE = {
    wear = 1,--已穿
    no = 2,--没有装备，不可合成
    can = 3,--有装备，可以装备
    en = 4, -- 有碎片，可合成
    cant = 5 --等级不足
}
]]
function m:setStars(star)
    local stars = {}
    for i = 1, star do
        stars[i] = i
    end
    self.binding:Show("star")
    ClientTool.UpdateMyTable("", self.star, stars)
end

function m:showEquip(ret)
    if ret then
        if self.__itemAll == nil then
            self.__itemAll = ClientTool.loadAndGetLuaBindingFromPool("Prefabs/publicPrefabs/itemAll", self.con.gameObject)
			self.__itemAll.gameObject.transform.localPosition = Vector3(0, 4, 0)
           -- self.binding:CallManyFrame(function()
           --     ClientTool.AdjustDepth(self.__itemAll.gameObject, self.itemFrame.depth)
           -- end)
        end
        self.__itemAll:CallUpdate({ "char", self.equip, self.itemFrame.width, self.itemFrame.height })
        Tool.SetActive(self.__itemAll, true)

    else
        Tool.SetActive(self.__itemAll, false)
    end
end

function m:setState(state)
    local equip = self.equip
    local ret = true
	local isGray = false

    if state == ITEM_STATE.no then
        --无装备
        self.labState.text = ""--NO_EQUIP
        self.addEquip:SetActive(false)
        self.addEquip_dis:SetActive(false)
        self.red_point:SetActive(false)
		isGray = true
    elseif state == ITEM_STATE.can then
        --可装备
        self.labState.text = CAN_EQUP
        self.addEquip:SetActive(true)
        self.addEquip_dis:SetActive(false)
        self.red_point:SetActive(true)
		isGray = true
        self.target:isCanEuqip(self.char.id)
    elseif state == ITEM_STATE.cant then
        --等级不足
        self.labState.text = "" -CAN_NOT_EQUIP
        self.addEquip:SetActive(false)
        self.addEquip_dis:SetActive(false)
        self.red_point:SetActive(false)
		isGray = false
    elseif state == ITEM_STATE.en_cant then
        --有装备，等级不足
        self.labState.text = "" --CAN_NOT_EQUIP
        self.addEquip:SetActive(false)
        self.addEquip_dis:SetActive(true)
        self.red_point:SetActive(false)
		isGray = false
    elseif state == ITEM_STATE.wear then
        --已装备
        self.labState.text = ""
        self.addEquip:SetActive(false)
        self.addEquip_dis:SetActive(false)
        self.red_point:SetActive(false)
		isGray = false
        ret = false
    elseif state == ITEM_STATE.en then
        --可合成
        self.labState.text = CAN_COM
        self.addEquip:SetActive(true)
        self.addEquip_dis:SetActive(false)
        self.red_point:SetActive(true)
		isGray = true
    end


    self.mask.enabled = ret
    self.itemFrame.enabled = true
    if ret == true then
        --        self.itemFrame.spriteName = equip:getFrame()
        --        self.itemFrame.enabled = true
        --     self.icon:setImage(equip:getHeadSpriteName(), "ItemIcon_atlas")
        self.binding:Show("itemFrame")
        --self.icon:isShowGray(ret)
        self.icon:setImage(equip:getHeadSpriteName(), packTool:getIconByName(equip:getHeadSpriteName()))
		self.icon:isShowGray(isGray)
		if isGray then 
			self.icon_bg.spriteName = Tool.getBg(0)
			self.itemFrame.spriteName = Tool.getFrame(0)
		else 
			self.icon_bg.spriteName = equip:getFrameBG()
			self.itemFrame.spriteName = equip:getFrame()
		end
    else
        self.binding:Hide("itemFrame")
    end
    m:showEquip(not ret)
    --self:setStars(equip.level)
end

function m:update(lua, index, grid, delegate)
    self.equip = lua.equip
    self.char = lua.char
    self.pos = lua.pos
    self.target = lua.delegate
    --    self.binding:CallManyFrame(function()
    self:setState(self.equip:getState(self.char))
    --    end)
end

function m:onClick(go, name)
    local that = self
    EquipInfo:show(self.equip, self.char, self.pos, function(ret)
        --that.target:playEquipOnEffect(that.binding.gameObject, that.equip)
    end)
end

------------------------------------------------------------------------------------------------------------------------

----------------------------------------------- 创建----------------------------------------------------------------------
function m:create(binding)
    self.binding = binding
    return self
end

-----------------------------------------------------------------------------------------------------------------------
return m
