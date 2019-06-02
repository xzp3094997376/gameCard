--[[
-- 标签文本解析器
-- 注:对标签的格式没有纠错功能
-- lzh
]]

-- 标签的属性分析，如何如下：
--[[
-- id-自身序号：它在整个文本中，从左到右的，出现的所有标签中的序号
--style:自标签类型：0，1，2，3。0：表示它是无效非法的标签；1：表示它是组队标签中的开头标签，2：表示它是组队标签中的结束标签，3：表示它是单标签。 <html>与</html> ，<br>, 
--peerId-自同伴序号：组对标签对应的：开始标签或结束标签的序号，这个属性对单标无意义
--name-自标签的名字： html
--content-自整个标签的内容：<html xx=xxx, ....>
--sIndex自开始位置：标签的“<” 在整个字符串中的索引位置，这个值在其它标被处理时，是会变的，所以要注意
-- eIndex自结束位置：标签的“>” 在整个字符串中的索引位置
]]

-- 所有的合法的
ALL_SINGLE_TAGS = {}
ALL_PEER_TAGS = { "blink" }

local M = {} -- 标示解析器类的table

local scrStr = nil
local len = 0
local callback = nil
local flag = 1
local tags = {} -- 用来存放要处理一个个标签，不时刻代表所有的标签
local timers = {}

-- text :要解析的源文本
-- callback ：解析之后的回调用，会返回解析之后的
-- flag :1：表示要实现标签中的功能，2：表示不要功能了，只要去掉所的标签
function M:Init(_scrStr, _callback, _flag)
    print("lzh print: **************************************************")
    print("lzh print: scrStr = " .. _scrStr)
    if _scrStr == nil or _scrStr == "" then
        return
    end
    scrStr = _scrStr
    callback = _callback
    flag = _flag

    if flag == 2 then
        self:ClearAllTags()
    else
        self:InitProcessGetTags()
        self:ParseTags()
    end
end

function M:OnDestory()
    print("lzh print *********************OnDestory()")
    for i, v in pairs(timers) do
        LuaTimer.Delete(v)
    end
end

function M:setNewStr(newStr)
    print("lzh print *********************setNewStr()")
    scrStr = newStr
    if callback ~= nil then
        callback(newStr)
    end
    print("lzh print *******11**********")
    print(newStr)
    print("lzh print *******22**********")
end

-- 清掉所标签
function M:ClearAllTags()
    print("lzh print *********************ClearAllTags()")
    if flag ~= 2 then
        return
    end

    local pattern = "<%s*/*%s*(%w+)%s*)"
    local newStr = string.gsub(scrStr, pattern, "")
    -- if callback~=nil
    -- 	callback(newStr)
    -- end
    self:setNewStr(newStr)
end

-- 初始处理，获取所有的tags
-- 先取出所有标签，设置相应的属性值
function M:InitProcessGetTags()
    print("lzh print *********************InitProcessGetTags()")
    -- 111 先抠出所有的标签
    local index = 1
    local num = 0
    local str_len = string.len(scrStr)
    while index < str_len do
        print("lzh print: while*************************")
        si, ei = string.find(scrStr, "<[^<>]+>", index)
        if si ~= nil and ei ~= nil then
            num = num + 1
            index = ei + 1

            local tagContent = string.sub(scrStr, si, ei)
            print("tagContent: " .. tagContent)
            local tag = self:createEmptyTag()
            tag.id = num
            tag.name, tag.style = self:getTagNameStyleWithContent(tagContent)
            tag.content = tagContent
            tag.sIndex = si
            tag.eIndex = ei
            self:setPeeridForTag(tag)

            table.insert(tags, tag)
        else
            break
        end
    end
end

-- 进一步处理，处理一个个的tag
function M:ParseTags()
    print("lzh print *********************ParseTags()")
    if #tags == 0 then
        return
    end

    while #tags > 0 do
        if tags[1].name == "blink" then
            self:ProcessTag_Blink(tags[1])
        else
            -- 其它table暂不处理
            self:ProcessTag_Other(tags[1])
        end
    end
end

-- 
-- 形如：<blink color=00ff88|aa8866 gap=100> ... </blink>
function M:ProcessTag_Blink(_tag)
    print("lzh print ******************* ProcessTag_Blink(): tag = " .. _tag.content)
    local sTag = _tag;
    local eTag = self:getTagWithId(_tag.peerId)
    --11 先把尾标签</blink>换成[-]
    --self:replaceTagWithString(eTag, "[-]")
    -- 22
    -- 获取 标签中的参数
    local colors = {}
    local gap = 150 -- 毫秒数
    for k, v in string.gmatch(sTag.content, "(%w+)%s*=%s*([%w|]+)") do
        if k == "colors" then
            for col in string.gmatch(v, "(%x%x%x%x%x%x)") do
                table.insert(colors, col)
            end
        elseif k == "gap" then
            gap = tonumber(v) or gap
        end
    end
    -- 33
    local colors_num = #colors
    if colors_num == 0 then
        print("lzh print ******************* ProcessTag_Blink() *** 0")
        self:removeTagFromTags(sTag)
        self:removeTagFromTags(eTag)
    elseif colors_num == 1 then
        print("lzh print ******************* ProcessTag_Blink() *** 1")
        self:replaceTagWithString(eTag, "[-]")
        self:replaceTagWithString(sTag, "[" .. colors[1] .. "]")
    else
        print("lzh print ******************* ProcessTag_Blink() *** 3")
        self:replaceTagWithString(eTag, "[-]")
        local cIndex = 0
        local blink_timer = LuaTimer.Add(0, gap, function(id)
            cIndex = cIndex + 1
            if cIndex > colors_num then cIndex = 1 end
            print("lzh print ******************* ProcessTag_Blink() *** 4 cIndex = " .. cIndex)
            self:replaceTagWithString(sTag, "[" .. colors[cIndex] .. "]")
            return true
        end)
        table.insert(timers, blink_timer)
    end
end

-- 处理无效的tag
-- 就是不处理
function M:ProcessTag_Other(_tag)
    print("lzh print *********************ProcessTag_Other()")
    local sTag = _tag;
    for i, v in pairs(tags) do
        if v.id == sTag.id then
            table.remove(tgas, i)
            break
        end
    end
end


-- 提取标签的name和style属性
-- 形如：<html xx=xxx> --> html 1; </html> --> html 2;
-- 特定的
function M:getTagNameStyleWithContent(tagContent)
    print("lzh print *********************getTagNameStyleWithContent()")
    local name, style = 0
    -- 提取名字
    local pattern = "<%s*/*%s*(%w+)%s*"
    name = string.match(tagContent, pattern)

    -- 判断类型
    local isValid = false
    local isPeer = false
    if name ~= nil then
        isValid, isPeer = self:checkTagValidWithName(name)
    end
    if isValid == true then
        if isPeer == true then
            pattern = "<%s*(/)%s*"
            local result = string.match(tagContent, pattern)
            if result ~= nil then
                style = 2
            else
                style = 1
            end
        else
            style = 3
        end
    else
        style = 0
    end

    return name, style;
end

-- 生成成一个空的tag
function M:createEmptyTag()
    print("lzh print *********************createEmptyTag()")
    local tag = {}
    tag.id = nil
    tag.name = nil
    tag.style = nil
    tag.peerId = nil
    tag.content = nil
    tag.sIndex = nil
    return tag
end

-- 根据name判断，tag的合法性
-- 返回两个数据:
-- 1,是否合法，true or false
-- 2,是双？，true or false
function M:checkTagValidWithName(_name)
    print("lzh print *********************createEmptyTag()")
    local valid = false
    local peer = false
    for i, v in pairs(ALL_PEER_TAGS) do
        if v == _name then
            valid = true
            peer = true
            return valid, peer
        end
    end
    for i, v in pairs(ALL_SINGLE_TAGS) do
        if v == _name then
            valid = true
            peer = false
            return valid, peer
        end
    end
    return valid, peer
end

-- 设置一个tag的结对tag的id。
-- 如果这个tag是一开始标签，就先设置，直接返回
-- 如果它是一个结尾标签：就是与以经存在的tags表，进行逆推上去，
--      碰到的最近一个没有配对的同名标签，它们就互为头尾,
--      这样就可同时确定他们两者的peerId了
function M:setPeeridForTag(_tag)
    print("lzh print *********************setPeeridForTag()")
    if _tag.style ~= 2 or #tags == 0 then
        return
    end
    local tags_len = #tags
    for i = tags_len, 1, -1 do
        if (tags[i].style == 1 or tags[i].style == 2) and tags[i].peerId == nil then
            tags[i].peerId = _tag.id
            _tag.peerId = tags[i].id
            return
        end
    end
end

function M:getTagWithId(_id)
    print("lzh print *********************getTagWithId()")
    if #tags == 0 then
        return nil
    end
    for i, v in pairs(tags) do
        if v.id == _id then
            print("lzh print *********************getTagWithId() ** 1")
            return v
        end
    end
    return nil
end

-- 将指定的标签换成指定的字符串
function M:replaceTagWithString(_tag, _str)
    print("lzh print *********************replaceTagWithString()")
    self:removeTagFromTags(_tag)
    --if _tag==nil then return end
    -- 先刷新现存tags的sIndex和eIndex属性
    local tag_len = #_tag.content
    for i, v in pairs(tags) do
        if v.id > _tag.id then
            v.sIndex = v.sIndex - tag_len
            v.eIndex = v.eIndex - tag_len
        end
    end
    -- 再将字符串换上
    local sStr = string.sub(scrStr, 1, _tag.sIndex - 1)
    local eStr = string.sub(scrStr, _tag.eIndex + 1, string.len(scrStr))
    if sStr == nil then sStr = "" end
    if eStr == nil then eStr = "" end
    local newStr = sStr .. _str .. eStr
    print(scrStr)
    print(_tag.sIndex)
    print(_tag.eIndex)
    print(newStr)
    self:setNewStr(newStr)
end

function M:removeTagFromTags(_tag)
    print("lzh print *********************removeTagFromTags")
    local tag = _tag
    if tag == nil then return end
    for i, v in pairs(tags) do
        if v.id == tag.id then
            table.remove(tags, i)
            return
        end
    end
end

return M