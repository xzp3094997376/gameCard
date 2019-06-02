-- 编辑公会公告呀宣言
local m = {}

-- type｛123｝: 1-修改图标, 2-悠announce 3-修改notice。
function m:update(lua)
    self.type = lua.type
    self.title = lua.title
    self.content = lua.content
    self.sucCallback = lua.sucCallback

    self.txt_biaoti.text = self.title
    self.Input_Content.value = self.content
end

function m:onQueding(...)
    local content = self.Input_Content.value
    if content == nil or content == "" then
        MessageMrg.show(TextMap.GetValue("Text563"))
        return
    end
    if content == self.content then
        MessageMrg.show(TextMap.GetValue("Text1238"))
        return
    end

    local len = self:checkContentLen(content)
    print("*******************")
    print(len)
    if len > 60 then
        MessageMrg.show(TextMap.GetValue("Text1239"))
        return
    end

    Api:changeGuildInfo(self.type, content, function(result)
        print("lzh print: changeGuildInfo 1111111111111111 ret = " .. result.ret)
        if tonumber(result.ret) == 0 then
            --MessageMrg.show("修改成功")
            if self.type == 2 then
                GuildDatas:getMyGuildInfo().announce = content
            elseif self.type == 3 then
                GuildDatas:getMyGuildInfo().notice = content
            end

            if self.sucCallback ~= nil then
                self.sucCallback(content)
            end
            UIMrg:popMessage(true)
        end
    end, function(...)
        print("lzh print: changeGuildInfo 2222222222222222")
        print(result)
    end)
end

function m:onQuxiao(...)
    --self.gameObject:SetActive(false)
    UIMrg:popMessage(true)
end

function m:onClick(go, btnName)
    if btnName == "btn_queding" then
        self:onQueding()
    elseif btnName == "btn_quxiao" then
        self:onQuxiao()
    end
end


function m:checkContentLen(str)
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



return m