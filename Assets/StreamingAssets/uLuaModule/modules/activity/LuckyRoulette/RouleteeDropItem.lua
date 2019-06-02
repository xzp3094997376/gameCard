local m = {}

function m:update(info)
    self.index = info.index
    self.data = info.data

    local drop = self.data
    local item=RewardMrg.getDropItem(drop)
    if self.itemAll == nil then
        self.itemAll = ClientTool.loadAndGetLuaBindingFromPool("Prefabs/publicPrefabs/itemAll", self.pic.gameObject)
    end
    self.itemAll:CallUpdate({"char", item, self.pic.width, self.pic.height,true})
    self.itemAll.transform.localEulerAngles = Vector3.zero;
    self.itemAll:CallTargetFunctionWithLuaTable("HideNum")
    --drop的arg2没有的时候就找arg
    if Tool.typeId(drop.type)==false then
        self.num.text =toolFun.moneyNumberShowOne(tonumber(drop.arg2))
    else
        self.num.text = toolFun.moneyNumberShowOne(tonumber(drop.arg)) or ""
    end
    self.jingpin:SetActive(self.index == 1 or self.index == 6)
end


return m