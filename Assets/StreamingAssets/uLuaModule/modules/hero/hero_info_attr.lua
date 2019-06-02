--
-- Created by IntelliJ IDEA.
-- User: xiyou
-- Date: 2015/3/3
-- Time: 9:57
-- To change this template use File | Settings | File Templates.
-- 英雄属性

local m = {}



function m:update(lua)
    local nChar = lua.nChar
    local char = lua.char
    self.txt_dw.text = nChar.Table.dingwei_desc
    local equips = nChar:getEquips()
    local tran = self.equips.transform
    local ret = false
    local tp = char:getType()
    if tp == "charPiece" then
        ret = false
    end

    for i = 0, tran.childCount - 1 do
        local go = tran:GetChild(i).gameObject
        if tp == "char" then
            ret = equips[i + 1]:getState(char) == ITEM_STATE.wear
        end
        if ret == false then
            local sp = go:GetComponent("UISprite")
            if sp then
                sp.alpha = 0.3
            end
        end
        local bind = ClientTool.loadAndGetLuaBindingFromPool("Prefabs/publicPrefabs/itemAll", go)
        bind.gameObject:SetActive(true)
        bind:CallUpdate({ "char", equips[i + 1], 70, 70, true })
    end

    local tp = char:getType()
    local descLeft = ""
    local descRight = ""
    local list
    local num = -2
    if tp == "char" then
        --属性与描述
        list = nChar:getAttrDesc()
        table.foreachi(list, function(i, v)
            if i % 2 ~= 0 then
                descLeft = descLeft .. v
            else
                descRight = descRight .. v
            end
        end)
        self.txt_left.text = string.sub(descLeft, 1, num)
        self.txt_right.text = string.sub(descRight, 1, num)
    else
        self.info_attr:SetActive(false)
        self.info_desc:SetAnchor(self.info_anchors, 0, -155, 0, -155)
        --        self.info_desc.transform.localPosition = Vector3(0,-65,0)
    end




    self.txt_desc.text = nChar:getDesc()
end

return m