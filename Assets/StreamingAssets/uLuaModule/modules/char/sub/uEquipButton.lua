local EquipInfo = require("uLuaModule/modules/char/sub/uEquipInfo.lua")

local m = {}

local CAN_NOT_EQUIP = TextMap.GetValue("Text524")
local NO_EQUIP = TextMap.GetValue("Text525")
--local NO_EQUIP = ""
local CAN_COM = TextMap.GetValue("Text526") .. "[-]"
local CAN_EQUP = TextMap.GetValue("Text527") .. "[-]"

----------------------------------------------- 更新---------------------------------------------------------------------
--[[
ITEM_STATE = {
    wear = 1,--已穿
    no = 2,--没有装备,不可合成
    can = 3,--有装备,可以装备
    en = 4, -- 有碎片,可合成
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

function m:setState(state)
    local equip = self.equip
    local ret = true

    if state == ITEM_STATE.no then
        --无装备
        --        self.frame.spriteName = "juese_kuang_red"
        self.labState.text = NO_EQUIP
        self.addEquip:SetActive(false)
        self.addEquip_dis:SetActive(false)
        --        self.frame.enabled = true
        self.red_point:SetActive(false)
    elseif state == ITEM_STATE.can then
        --可装备
        --        self.frame.spriteName = "juese_kuang_red"
        self.labState.text = CAN_EQUP
        --        self.binding:Show("addEquip")
        --        self.addEquip.spriteName = "juese_zhaungbeijh"
        self.addEquip:SetActive(true)
        self.addEquip_dis:SetActive(false)
        --        self.frame.enabled = true
        self.red_point:SetActive(true)
    elseif state == ITEM_STATE.cant or state == ITEM_STATE.en_cant then
        --不可装备
        --        self.frame.spriteName = "juese_kuang_red"
        self.labState.text = CAN_NOT_EQUIP
        --        self.binding:Show("addEquip")
        --        self.addEquip.spriteName = "juese_zhaungbeijh2"
        self.addEquip:SetActive(false)
        self.addEquip_dis:SetActive(true)
        --        self.frame.enabled = true
        self.red_point:SetActive(false)
    elseif state == ITEM_STATE.wear then
        --已装备
        --        self.frame.spriteName = equip:getFrame()
        self.labState.text = ""
        --        self.binding:Hide("addEquip")
        --        self.frame.enabled = false
        self.addEquip:SetActive(false)
        self.addEquip_dis:SetActive(false)
        self.red_point:SetActive(false)
        ret = false
    elseif state == ITEM_STATE.en then
        --        self.frame.spriteName = "juese_kuang_red"
        --可合成
        self.labState.text = CAN_COM
        --        self.binding:Show("addEquip")
        --        self.addEquip.spriteName = "juese_zhaungbeijh"
        --        self.frame.enabled = true
        self.addEquip:SetActive(true)
        self.addEquip_dis:SetActive(false)
        self.red_point:SetActive(true)
    end
    --    self.img.Url = equip:getHead()
    self.icon:isShowGray(ret)
    self:setStars(equip.level)
    self.icon:setImage(equip:getHeadSpriteName(), "ItemIcon_atlas")
    self.binding:Show("itemFrame")
    self.mask.enabled = ret
    if ret == false then
        self.itemFrame.spriteName = equip:getFrame()
        self.itemFrame.enabled = true
        --     self.icon:setImage(equip:getHeadSpriteName(), "ItemIcon_atlas")
    else
        self.itemFrame.enabled = false
        -- self.binding:Hide("itemFrame")
    end
    --    if self.__itemAll == nil then
    --        self.__itemAll = ClientTool.loadAndGetLuaBindingFromPool("Prefabs/publicPrefabs/itemAll", self.binding.gameObject)
    --    end
    --    self.__itemAll:CallUpdate({ "char", equip, self.frame.width, self.frame.height })

    --    self.binding:CallEndOfFrame(function()
    --    self.__itemAll:CallTargetFunction("isShowGray",  ret )
    --    self.gray:SetActive(ret)
    --    end)
end

function m:update(lua, index, grid, delegate)
    self.equip = lua.equip
    self.char = lua.char
    self.pos = lua.pos
    self.target = delegate

    self:setState(self.equip:getState(self.char))
end

function m:onClick(go, name)
    local that = self
    EquipInfo:show(self.equip, self.char, self.pos, function(ret)
        that.target:playEquipOnEffect(that.binding.gameObject, that.equip)
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