--
-- Created by IntelliJ IDEA.
-- User: jixinpeng
-- Date: 2015/7/21
-- Time: 9:57
-- To change this template use File | Settings | File Templates.
-- 英雄羁绊信息

local m = {}

function m:update(lua)
    local tb = lua.tb
    if tb == nil then return end

    self.txt_name.text = tb.relation_name
    -- print("desc============="..tb.desc_eff)
    -- local desc = ""
    -- for k=0,5 do
    --     if tb.drop[k] ~= nil then
    --         if tb.drop[k].condition_value ~= nil then
    --             local charRow = TableReader:TableRowByID(tb.type,tb.drop[k].condition_value)
    --             local name = charRow.name
    --             desc = desc..name
    --             if tb.drop[k+1] ~= nil then
    --             	desc = desc.."、"
    --             end
    --         end
    --     end
    -- end
    -- desc = desc.."同时上阵，"
    -- if tb.script_arg[0] ~= nil then
    -- 	local text = self:getType(tb.script_arg[0])
    -- 	if tb.script_arg[1] ~= nil then 
    -- 		desc = desc..string.gsub(text,"{0}",tb.script_arg[1]).." " 
    -- 	end
    -- end
    -- if tb.script_arg[3] ~= nil then
    -- 	local text = self:getType(tb.script_arg[3])
    -- 	if tb.script_arg[4] ~= nil then
    -- 		desc = desc..string.gsub(text,"{0}",tb.script_arg[4])
    -- 	end
    -- end
    self.txt_desc.text = tb.desc_eff
end

function m:getType(type)
    if type == nil then return end
    local text = ""
    if type == TextMap.GetValue("Text1066") then
        text = TextMap.GetValue("Text1067")
    elseif type == TextMap.GetValue("Text1068") then
        text = TextMap.GetValue("Text1069")
    elseif type == TextMap.GetValue("Text1070") then
        text = TextMap.GetValue("Text1071")
    elseif type == TextMap.GetValue("Text1072") then
        text = TextMap.GetValue("Text1073")
    elseif type == TextMap.GetValue("Text1074") then
        text = TextMap.GetValue("Text1075")
    elseif type == TextMap.GetValue("Text1076") then
        text = TextMap.GetValue("Text1077")
    elseif type == TextMap.GetValue("Text1078") then
        text = TextMap.GetValue("Text1079")
    elseif type == TextMap.GetValue("Text1080") then
        text = TextMap.GetValue("Text1081")
    elseif type == TextMap.GetValue("Text1082") then
        text = TextMap.GetValue("Text1083")
    elseif type == TextMap.GetValue("Text1084") then
        text = TextMap.GetValue("Text1085")
    end
    return text
end

return m