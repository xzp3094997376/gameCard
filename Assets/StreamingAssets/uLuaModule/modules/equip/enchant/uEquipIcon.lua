local m = {}

function m:OnDestroy()
    self.delegate = nil
    self.equip = nil
    self.isWear = false
end

function m:update(equip, index, _table, delegate)
    self.delegate = delegate
    self:updateEquip(equip)
end

function m:updateEquip(equip)
    self.equip = equip
    local state = equip:getState()
    self.isWear = state == ITEM_STATE.wear
    if self.isWear then
        if equip:isSelected() then
            self.selected:SetActive(true)
            if self.selected2 ~= nil then self.selected2:SetActive(false) end
        else
            self.selected:SetActive(false)
            if self.selected2 ~= nil then self.selected2:SetActive(true) end
        end

        --        self.img_frame.spriteName = equip:getFrame()
        --        self.img_icon.Url = equip:getHead()
        self.img_frame.enabled = false
        if self.__itemAll == nil then
            self.__itemAll = ClientTool.loadAndGetLuaBindingFromPool("Prefabs/publicPrefabs/itemAll", self.img_frame.gameObject)
        end
        self.__itemAll.gameObject:SetActive(true)
        self.__itemAll:CallUpdate({ "char", equip, self.img_frame.width, self.img_frame.height })
    else
        if self.__itemAll then
            self.__itemAll.gameObject:SetActive(false)
        end
        self.img_frame.enabled = true
    end
    local stars = {}
    for i = 1, equip.level do stars[i] = i end
    ClientTool.UpdateMyTable("", self.star, stars)
end

function m:setSelected(ret)
    self.selected:SetActive(ret)
    if self.selected2 ~= nil then self.selected2:SetActive(not ret) end
    self.equip:isSelected(ret)
end

function m:onClick(go, name)
    if self.delegate == nil then return end
    if self.isWear then
        self:setSelected(false)
        self.delegate:selectEquip(self.equip)
    end
end

function m:Start()
    self.selected:SetActive(false)
end

function m:clickEquipAwake()
    self:onClick(nil, nil)
end

return m