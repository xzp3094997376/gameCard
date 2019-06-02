local EquipInfo = require("uLuaModule/modules/char/sub/uEquipInfo.lua")

local m = {}

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
	local isGray = true
	
    if state == ITEM_STATE.wear then
        --已装备
		isGray = false
        ret = false
    end
    self.mask.enabled = ret
    self.itemFrame.enabled = true
    if ret == true then
        self.binding:Show("itemFrame")
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
end

function m:update(lua, index, grid, delegate)
    self.equip = lua.equip
    self.char = lua.char
    self.pos = lua.pos
    self.target = lua.delegate
    self:setState(self.equip:getState(self.char))
end
------------------------------------------------------------------------------------------------------------------------

----------------------------------------------- 创建----------------------------------------------------------------------
function m:create(binding)
    self.binding = binding
    return self
end

-----------------------------------------------------------------------------------------------------------------------
return m
