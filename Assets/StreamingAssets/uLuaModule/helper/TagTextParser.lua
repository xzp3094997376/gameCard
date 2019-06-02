--[[
-- 标签文本解析器
-- 将我们算定义的标签，转成ngui支持的标签，扩展ngui即有标记的使用
-- lzh
]]

-- 解析思路
-- 将整个文本，按顺序拆分成一个个片段，并组成一个列表。片段：是一个标签或一个夹在标签间一段字符
--- - 片段列表优化
-- 按要求处理片段列表中的个个标签
-- 再将所有片段重新组成新的文本返回

-- 片段属性定义：
-- orderId 	- 序号
-- isTag 	- 是不是标签, 1:是标签 2：不是标签
-- propertys 	- 属性表：如何不是标签，它里面只有一个content属性

-- 标签的属性定义：
--[[
--style:自标签类型：0-无效非法的标签，1-组队标签中的开头标签，2-组队标签中的结束标签，3：是单标签。 <html>与</html> ，<br>
--name-自标签的名字：html
--content-自整个标签的内容：<html xx=xxx, ....>
--substitutes - 替身表：这个表，到少一个元素，可以是空字符串。
--arguments - 参数表：每一个标签的值都不一样
]]

-- blink标签，形如：
-- aaaaa <blink colors=00ffff|fff600|aa00cc gap=200>bbbbb</blink> ccc <blink colors=00ffff|fff600 gap=150>ddd</blink>eeee<blink colors=00ffff gap=150>fff</blink>

-- 所有的合法的
ALL_PEER_TAGS = { "blink" }
ALL_SINGLE_TAGS = {}

-- 标示解析器类的table
local M =
{
    srcStr = nil,
    callback = nil,
    flag = 1,
    fragTab = {}, -- 用来存放要所有片段
    timers = {},
}



function M:new(_srcStr, _flag, _callback)
    local o = {}
    setmetatable(o, self)
    self.__index = self
    o:Init(_srcStr, _flag, _callback)
    return o
end

-- text :要解析的源文本
-- callback ：解析之后的回调用，会返回解析之后的
-- flag :1：表示要实现标签中的功能，2：表示不要功能了，只要去掉所的标签
function M:Init(_srcStr, _flag, _callback)
    --print("lzh print: **********************************Init() **** 00")
    if _srcStr == nil or _srcStr == "" then
        return
    end
    self.srcStr = _srcStr
    self.callback = _callback
    self.flag = _flag
    self:InitFrags();
    if self.flag == 2 then
        self:ClearAllTags()
    else
        self:ProcessTags()
    end
    self:MergeFrags()
end

-- 初始化所有的片段
function M:InitFrags()
    --print("lzh print: *****************************InitFrags()")
    -- 111 先抠出所有的片段
    local cur_pos = 1
    local cur_order = 1
    local str_len = string.len(self.srcStr)
    local l_pos, r_pos, frag -- 辅助变量
    while cur_pos <= str_len do
        --print("lzh print: *****************************InitFrags().while****")
        l_pos, r_pos = string.find(self.srcStr, "<[^<>]+>", cur_pos)
        if l_pos ~= nil and r_pos ~= nil then

            if cur_pos < l_pos then
                local fragStr_txt = string.sub(self.srcStr, cur_pos, l_pos - 1)
                frag = self:CreateAFrag(fragStr_txt, cur_order, 2)
                table.insert(self.fragTab, frag)
                cur_order = cur_order + 1
            end
            local fragStr_tag = string.sub(self.srcStr, l_pos, r_pos)
            frag = self:CreateAFrag(fragStr_tag, cur_order, 1)
            table.insert(self.fragTab, frag)

            cur_pos = r_pos + 1
            cur_order = cur_order + 1
        else
            if cur_pos <= str_len then
                local fragStr_txt = string.sub(self.srcStr, cur_pos, str_len)
                frag = self:CreateAFrag(fragStr_txt, cur_order, 2)
                table.insert(self.fragTab, frag)
                cur_order = cur_order + 1
            end

            break;
        end
    end
end

-- -- 片段列表优化
-- -- 起到一个初始处理的作用
-- function M:OptimizeFrags()	
-- end

-- 按要求处理片段列表的标签
-- 主要任务是设置标签的替身表的内容
function M:ProcessTags()
    --print("lzh print: ************************ProcessTags() **** 00")
    if #self.fragTab == 0 then return end
    --print("lzh print: ************************ProcessTags() **** len =" .. #self.fragTab)
    for i, f in pairs(self.fragTab) do
        --print("lzh print: ************************ProcessTags() **** for***")
        if f.isTag == 1 and f.propertys.name == "blink" then
            self:ProcessTag_Blink(f)
        end
    end
end

-- 合并处理后的
-- 主要任务是使用标签来的替身来替换标签本身
function M:MergeFrags()
    --print("lzh print *********************MergeFrags()**** start")
    local newStr = ""
    local appStr = ""
    --print("lzh print *********************MergeFrags()**** 000** len =" .. #self.fragTab)
    for i, f in pairs(self.fragTab) do
        if f.isTag == 1 then
            appStr = f.propertys.substitutes[1]
        else
            --print("lzh print *********************MergeFrags()**** 111")
            appStr = f.propertys.content
        end
        newStr = newStr .. appStr
    end
    if self.callback ~= nil then
        self.callback(newStr)
    end
    --print(newStr)
    --print("lzh print *********************MergeFrags()******end")
end

-- 清掉所标签
-- 将所有的标签的替身设置空字符串
function M:ClearAllTags()
    -- print("lzh print *********************ClearAllTags()")
    for i, f in pairs(self.fragTab) do
        if f.isTag == 1 then
            f.propertys.substitutes = { "" }
        end
    end
    --self:MergeFrags()
end



-- 根据一个段截出来的字串
function M:CreateAFrag(_fragStr, _orderId, _isTag)
    local frag = {}
    frag.orderId = _orderId
    frag.isTag = _isTag
    local propertys = nil
    if _isTag == 1 then
        propertys = self:ParseGetTagBasicPropertys(_fragStr)
    else
        propertys = {}
        propertys.content = _fragStr
    end

    frag.propertys = propertys;
    return frag
end

-- 通过标签的内容来解析出标签的基本属性
function M:ParseGetTagBasicPropertys(_tagStr)
    local name
    local style = 0
    local substitutes = {}
    local arguments
    -- 名字与类型
    local pattern = "<%s*/*%s*(%w+)%s*"
    name = string.match(_tagStr, pattern)
    if self:checkNamIsExist(name, ALL_SINGLE_TAGS) == true then
        substitutes = { "" }
        arguments = nil
        style = 3
    elseif self:checkNamIsExist(name, ALL_PEER_TAGS) == true then
        --pattern = "<%s*(/)%s*"
        pattern = "/"
        local result = string.match(_tagStr, pattern)
        if result ~= nil then
            style = 2
        else
            style = 1
        end
        substitutes, arguments = self:ParseGetTagDetailPropertys(name, style, _tagStr)
    else
        substitutes = { "" }
        arguments = nil
        style = 0
    end

    -- 返回
    local tagPropertys = {}
    tagPropertys.name = name
    tagPropertys.style = style
    tagPropertys.content = _tagStr
    tagPropertys.substitutes = substitutes
    tagPropertys.arguments = arguments
    return tagPropertys
end

-- 通过标签的名字和内容来解析出标签的详细属性
-- 主要是指substitutes和arguments
function M:ParseGetTagDetailPropertys(name, style, _tagStr)
    local substitutes
    local arguments
    if name == "blink" then
        substitutes, arguments = self:ParseTag_Blink(style, _tagStr)
    else
        substitutes, arguments = self:ParseTag_Other(style, _tagStr)
    end

    return substitutes, arguments
end

function M:ParseTag_Blink(style, _tagStr)
    local substitutes = {}
    local arguments

    if style == 2 then
        substitutes = { "[-]" }
    else -- style==1
    arguments = {}
    -- 获取 标签中的参数
    --local colors = {}	-- 颜色
    local gap = 200 -- 毫秒数
    local pattern = "(%w+)%s*=%s*([%w|]+)"
    for k, v in string.gmatch(_tagStr, pattern) do
        if k == "colors" then
            for col in string.gmatch(v, "(%x%x%x%x%x%x)") do
                --table.insert(colors, col)
                local sub = "[" .. col .. "]"
                table.insert(substitutes, sub)
            end
        elseif k == "gap" then
            gap = tonumber(v) or gap
            arguments.gap = gap
        end
    end
    if #substitutes == 0 then
        substitutes = { "ffffff" }
    end
    end


    return substitutes, arguments
end

function M:ProcessTag_Blink(_frag)
    --print("lzh print *********************ProcessTag_Blink()******000")
    if _frag.propertys.style == 2 then
        return
    else -- style==1
    local len = #_frag.propertys.substitutes
    if len < 2 then return end
    local gap = _frag.propertys.arguments.gap
    local blink_timer = LuaTimer.Add(gap, gap, function(id)
        local sub = table.remove(_frag.propertys.substitutes, 1)
        table.insert(_frag.propertys.substitutes, sub)
        self:MergeFrags()
        return true
    end)
    table.insert(self.timers, blink_timer)
    end
end

function M:ParseTag_Other(style, _tagStr)
    local substitutes = { "" }
    local arguments
    return substitutes, arguments
end

-- 判断一个标签名是否存在一个既定的表里
function M:checkNamIsExist(_name, _nameTab)
    if _name == nil or _nameTab == nil or #_nameTab == 0 then return false end
    for i, n in pairs(_nameTab) do
        if n == _name then
            return true
        end
    end
    return false
end

function M:Destory()
    -- print("lzh print:************Destory********************")
    for i, v in pairs(self.timers) do
        LuaTimer.Delete(v)
    end
    self.srcStr = nil
    self.callback = nil
    self.flag = 1
    self.fragTab = {} -- 用来存放要所有片段
    self.timers = {}
end

return M