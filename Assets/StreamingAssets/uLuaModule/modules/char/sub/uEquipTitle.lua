local m = {}

function m:update(equip, index, _table, delegate)
    self.delegate = delegate
    self.item = equip
    self.next_index = index + 1
    if equip:isSelected() then
        self.binding:Play("equip_title", "equip_state_selected")
    else
        self.binding:Play("equip_title", "equip_state_unselected")
    end
    --    self.img_frame.spriteName = equip:getFrame()
    --    self.img_icon.Url = equip:getHead()
    self.img_frame.enabled = false
    if self.__itemAll == nil then
        self.__itemAll = ClientTool.loadAndGetLuaBindingFromPool("Prefabs/publicPrefabs/itemAll", self.img_frame.gameObject)
        --self.binding:CallAfterTime(0.2, function()
        --    ClientTool.AdjustDepth(self.__itemAll.gameObject, self.img_frame.depth)
        --end)
    end
    self.__itemAll:CallUpdate({ "char", equip, self.img_frame.width, self.img_frame.height })
    --    local that = self
    --    if self.__target == nil then
    --        self.__target = self.__itemAll:GetTarget()
    --    end
    --    if self.__target == nil then
    --        self.__itemAll:CallEndOfFrame(function()
    --            that.__itemAll:Hide("item_suibian")
    --        end)
    --    else
    --        self.__itemAll:Hide("item_suibian")
    --    end
end

function m:onClick(go, name)
    self.delegate:setEquipTitle(self.item, self.next_index)
end

function m:create()
    return self
end

return m