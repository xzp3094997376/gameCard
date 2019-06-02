--
-- Created by IntelliJ IDEA.
-- User: jixinpeng
-- Date: 2015/7/21
-- Time: 9:57
-- To change this template use File | Settings | File Templates.
-- 英雄羁绊信息

local m = {}

function m:update(lua)
    local nChar = lua.nChar
    local char = lua.char
    if nChar == nil then return end
    local line = TableReader:TableRowByID("avter", nChar.id)
    if line ~= nil then
        if line.relationship == nil then
            print("line.relationship is nil ")
        end

        for i = 0, 7 do
            if line.relationship[i] ~= nil and line.relationship[i].."" ~= "" then
                self["hero_fetter_icon" .. i + 1].gameObject:SetActive(true)
                local tb = TableReader:TableRowByID("relationship", line.relationship[i])
                local lua = { tb = tb }
                self["hero_fetter_icon" .. i + 1]:CallUpdate(lua)
            else
                self["hero_fetter_icon" .. i + 1].gameObject:SetActive(false)
            end
        end

        self.binding:CallAfterTime(0.1, function()
        self.Table.repositionNow = true
        end)
    end
    if line.relationship.Count == 0 then
        local text = TextMap.getText("TXT_NO_FETTER")
        self.txt_desc.gameObject:SetActive(true)
        self.txt_desc.text = text
    else
        self.txt_desc.gameObject:SetActive(false)
    end
end

return m