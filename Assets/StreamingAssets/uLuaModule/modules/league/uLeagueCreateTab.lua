-- 创建公会的tab页面
local m = {}

local curIconId = 1

function m:Start()
    local row = TableReader:TableRowByUnique("GuildSetting", "name", "create_guild")
    if row ~= nil and row.value ~= nil then
        self.txt_cost.text = row.value
    else
        self.txt_cost.text = "500"
    end
    self.hero:LoadByModelId(56, "idle", nil, false, 0, 1)
    self.Toggle1.value=true
    self.Toggle2.value=false
    self.Toggle3.value=false
    curIconId=1
end

function m:onClick(go, btnName)
    if btnName == "btn_create" then
        self:onCreateBtn()
    elseif btnName == "btn_toggle1" then
        self.Toggle1.value=true
        self.Toggle2.value=false
        self.Toggle3.value=false
        curIconId=1
    elseif btnName == "btn_toggle2" then
        self.Toggle1.value=false
        self.Toggle2.value=true
        self.Toggle3.value=false
        curIconId=2
    elseif btnName == "btn_toggle3" then
        self.Toggle1.value=false
        self.Toggle2.value=false
        self.Toggle3.value=true
        curIconId=3
    end
end


function m:onCreateBtn()
    print("lzh print: 单击了创建按钮!")
    local leagueName = self.textInput_unionname.value
    local len = self:checkLeagueNameLen(leagueName)
    if len == 0 then
        MessageMrg.show(TextMap.GetValue("Text1150"))
        return
    elseif len > 12 then
        MessageMrg.show(TextMap.GetValue("Text1151"))
        return
    end
    local cost = tonumber(self.txt_cost.text)
    Api:createGuildInfo(leagueName, curIconId, cost, function(result)
        print("lzh print: createGuildInfo 1111111111111111")
        print(result.ret)
        local retNum = tonumber(result.ret)
        if retNum == 0 then
            --MessageMrg.show("创建会成功")
            UIMrg:pop()
            --Tool.push("leagueModule", "Prefabs/moduleFabs/leagueModule/league_main_page")
            GuildDatas:setMyGuildInfo(result.info, result.ext)

            ClientTool.LoadLevel("gonghui_map", function()
                LuaMain:createGongHuiBuildName()
            end)
            local args = {}
            args.result = result
            Tool.push("leagueModule", "Prefabs/moduleFabs/leagueModule/league_main_page", args)

        elseif retNum == 1003 then
            MessageMrg.show(TextMap.GetValue("Text1152"))
        elseif retNum == 1007 then
            MessageMrg.show(TextMap.GetValue("Text1153"))
        elseif retNum == 1005 then
            MessageMrg.show(string.gsub(TextMap.GetValue("LocalKey_687"),"{0}",retNum))
        elseif retNum == 1016 then
            MessageMrg.show(TextMap.GetValue("Text1155"))
        else
            MessageMrg.show(TextMap.GetValue("Text1156") .. retNum)
        end
    end, function(result)
        print("lzh print: createGuildInfo 222222222222222")
    end)
end

-- 支持中中文-英文字母-数字，不支持符号,空格等
function m:checkLeagueNameValid(name)
    -- body
end

-- 协会名称长度限制为1~12字符，即1~6个汉字或1~12个字母、数字
function m:checkLeagueNameLen(str)
    if str == nil or type(str) ~= "string" then
        return 0
    end
    local length = 0
    local lenOfByte = #str or 0
    local i = 1
    while i <= lenOfByte do
        local curByte = string.byte(str, i)
        local byteCount = 1
        if curByte > 0 and curByte <= 127 then
            byteCount = 1
            length = length + 1
        elseif curByte >= 192 and curByte < 223 then
            byteCount = 2
            length = length + 2
        elseif curByte >= 224 and curByte < 239 then
            byteCount = 3
            length = length + 2
        elseif curByte >= 240 and curByte <= 247 then
            byteCount = 4
            length = length + 2
        end
        i = i + byteCount
    end
    return length
end

-- 获取字串的真实长度
-- 
function m:getStringLen(str)
    if str == nill or type(str) ~= "string" then
        return 0
    end
    local length = 0
    local lenOfByte = #str or 0
    local i = 1
    while i <= lenOfByte do
        local curByte = string.byte(str, i)
        local byteCount = 1
        if curByte > 0 and curByte <= 127 then
            byteCount = 1
            --length = length+1
        elseif curByte >= 192 and curByte < 223 then
            byteCount = 2
            --length = length+1
        elseif curByte >= 224 and curByte < 239 then
            byteCount = 3
            --length = length+1
        elseif curByte >= 240 and curByte <= 247 then
            byteCount = 4
        end
        i = i + byteCount
        length = length + 1
    end
    return length
end

return m