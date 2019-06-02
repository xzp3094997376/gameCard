--
-- Created by IntelliJ IDEA.
-- User: jixinpeng
-- Date: 2015/8/5
-- Time: 9:58
-- To change this template use File | Settings | File Templates.
-- 英雄血脉信息

local hero_xuemai = {}


function hero_xuemai:update(lua)
    self.char = lua.nChar
    -- local char = lua.char
    local charId = self.char.id
    local bloodline = Player.Chars[charId].bloodline
    local lv = tonumber(bloodline.level)
    self.level.text =string.gsub(TextMap.GetValue("LocalKey_705"),"{0}",lv)
    local attr1 = TableReader:TableRowByUniqueKey("bloodlineArg", lv, self.char.star)
    if self:isMax(lv + 1) then --到达最高等级
    self.right:SetActive(false)
    self.txt_left.text = self:getMagics(attr1.magic)
    self.left.transform.localPosition = Vector3(90, 73, 0)
    else --未到达最高等级
    self.right:SetActive(true)
    self.left.transform.localPosition = Vector3(-34, 73, 0)
    self.right.transform.localPosition = Vector3(245, 73, 0)
    self.txt_left.text = self:getMagics(attr1.magic)
    local attr2 = TableReader:TableRowByUniqueKey("bloodlineArg", lv + 1, self.char.star)
    self.txt_right.text = self:getMagics(attr2.magic)
    end
end

function hero_xuemai:getMagics(magics)
    local txt = ""
    local len = magics.Count - 1
    for i = 0, len do
        -- if i == 1 or i == 3 then
        --     txt = txt.."\n"
        -- end
        local row = magics[i]
        local magic_effect = row._magic_effect
        local magic_arg1 = row.magic_arg1
        -- local magic_arg2 = row.magic_arg2
        local desc = ""
        desc = string.gsub(magic_effect.format, "{0}", "+ " .. magic_arg1 / magic_effect.denominator)
        if i < len then desc = desc .. "\n" end
        -- if math.floor(magic_arg1 / magic_effect.denominator) == 0 then desc =  "" end
        txt = txt .. desc
    end
    return txt
end

function hero_xuemai:isMax(lv)
    return lv > self.max_lv
end

function hero_xuemai:Start()
    self.max_lv = tonumber(TableReader:TableRowByID("bloodlineSetting", 1).arg)
end

return hero_xuemai

