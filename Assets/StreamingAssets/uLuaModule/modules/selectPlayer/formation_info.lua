--
-- Created by IntelliJ IDEA.
-- User: jixinpeng
-- Date: 2015/7/6
-- Time: 16:42
-- To change this template use File | Settings | File Templates.
--

local m = {}

function m:update(lua)
	--
    local delegate = lua.delegate
    local charid = lua .charid
    print ("charid" .. charid)
    self.number = 1
    local info = ""
    local row = TableReader:TableRowByID("avter", Tool.getDictId(charid))
    local char =Char:new(charid)
    self.name.text = Tool.getNameColor(char.star) .. char.name .. "[-]" --角色名
    --已经激活的羁绊
    local fetterList = delegate:getFetter(charid)
    if fetterList ~= nil then
        for j = 1, #fetterList do
            local fetterName = "" --羁绊名
            local info = "" --羁绊描述
            local line = TableReader:TableRowByID("relationship", fetterList[j])
            fetterName = "[FF2a2a]" .. line.show_name .. "[-]"
            info = "[FF2a2a]" .. line.desc_eff .. "[-]"
            self["obj" .. self.number].gameObject:SetActive(true)
            self["obj" .. self.number]:CallTargetFunction("setText", fetterName, info)
            self.number = self.number + 1
        end
    end
    --未激活的羁绊
    local line = TableReader:TableRowByID("avter", Tool.getDictId(charid))
    if line ~= nil then
        if line.relationship == nil then
            print("line.relationship is nil ")
        end

        for i = 0, line.relationship.Count-1 do
            if line.relationship[i] ~= nil and line.relationship[i].."" ~= "" then
                if self:checkFetter(line.relationship[i], fetterList) == false then
                    local fetterName = ""
                    local info = ""
                    local tb = TableReader:TableRowByID("relationship", line.relationship[i])
                    fetterName ="[ffffff]" .. tb.show_name .. "[-]"
                    info ="[ffffff]" .. tb.desc_eff .. "[-]"

                    if self.number <= 8 then
                        self["obj" .. self.number].gameObject:SetActive(true)
                        self["obj" .. self.number]:CallTargetFunction("setText", fetterName, info)
                        self.number = self.number + 1
                    end
                end
            end
        end
    end
    if self.number<=1 then
        self.gameObject:SetActive(false)

    elseif self.number <= 10 then
        for i = self.number, 10 do
            self["obj" .. i].gameObject:SetActive(false)
        end
    end
end

function m:create(binding)
    self.binding = binding
    self.gameObject = self.binding.gameObject
    return self
end
--检查该羁绊是否已经激活
function m:checkFetter(fetterId, list)
    if fetterId == nil or list == nil then
        print("fetterId or list is nil ")
        return nil
    end

    for i = 1, #list do
        if list[i] == fetterId then
            return true
        end
    end
    return false
end

function m:resetTable()
    self.uitable.repositionNow = true
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

function m:Start()
end

return m