local newEnchant = {}
--local selectList = require("uLuaModule/modules/selectChar/selectChar.lua")
local infobinding
--更新
function newEnchant:update(char)
    --    UluaModuleFuncs.Instance.uTimer:removeFrameTime("delayGetHeroList")
    self.node:SetActive(true)
    self.char = char
    --    self.haveSelect:SetActive(true)
    --    self.choose_Btn.gameObject:SetActive(false)
    self.txt_chooseHero:SetActive(false)
    self.txt_chooseEquip:SetActive(true)

    --    self.Sprite.gameObject:SetActive(false)
    --    if infobinding == nil then
    --        infobinding = ClientTool.loadAndGetLuaBindingFromPool("Prefabs/publicPrefabs/itemAll", self.images)
    --    end
    --    infobinding:CallUpdate({ "char", char, self.Sprite.width, self.Sprite.height })

    --    local row = TableReader:TableRowByUnique("avter", "name", char.name)
    --    self.simpleImage.Url = UrlManager.GetImagesPath('cardImage/' .. row.full_img_d .. '.png')

    self:updateEquips(char:getEquips(char))
end

function newEnchant:selectEquip(equip)
    local tempObj = {}
    tempObj.char = self.char
    tempObj.equip = equip
    --    Tool.push("qianghua", "Prefabs/moduleFabs/equipModule/equipEnchant", tempObj)
    --tempObj =nil
    -- self.binding:MoveToPos(self.node,0.3,Vector3(-700,0,0),function()
    --     self.node:SetActive(false)
    --     self.node.transform.localPosition = Vector3(0,0,0)
    -- end)
    self.node:SetActive(false)
    self.binding:Show("equipEnchant")
    self.equipEnchant.transform.localPosition = Vector3(700, 0, 0)
    self.binding:MoveToPos(self.equipEnchant.gameObject, 0.3, Vector3(0, 0, 0))
    self.equipEnchant:CallUpdate({ obj = tempObj, delegate = self })
end

function newEnchant:updateEquips(equips)
    self.equips = equips
    for i = 1, table.getn(equips) do
        local equip = equips[i]
        local state = equip:getState()
        if state == ITEM_STATE.wear then
            newEnchant:selectEquip(equip)
            return
        end
    end
    --    self.list = ClientTool.UpdateMyTable("Prefabs/moduleFabs/equipModule/enchant/equipIcon", self.equip, equips, self)
    --    self.list[1]:CallTargetFunctionWithLuaTable("clickEquipAwake",{})
end

function newEnchant:onClick(go, name)
    --    selectList:show(1, funcs.handler(self, self.update))
    self:showHero()
end

function newEnchant:create()
    return self
end

function newEnchant:Start()
    --    self.choose_Btn.gameObject:SetActive(true)
    --    self.haveSelect:SetActive(false)
    LuaMain:ShowTopMenu()
    self.binding:CallManyFrame(function()
        self:showHero()
    end, 2)
end

function newEnchant:showHero(data)
    --    selectList:show(1, funcs.handler(self, self.update))
    self.txt_chooseHero:SetActive(true)
    self.txt_chooseEquip:SetActive(false)
    --    self.haveSelect:SetActive(false)
    self.binding:Show("select_list")
    self.select_list:CallUpdate(data or { type = 1, callBack = funcs.handler(self, self.update) })
end

return newEnchant