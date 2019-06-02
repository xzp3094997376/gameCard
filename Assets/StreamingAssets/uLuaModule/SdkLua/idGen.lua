local StringToTable = function(str)
    local list = {}
    for i = 1, #str do
        table.insert(list, string.sub(str, i, i))
    end
    return list
end
local IDGenerator = function(...)
    local args = { ... }
    words = StringToTable(args[1])
    local decs = {}
    local maxLength
    local wordslen = #words
    for i = wordslen, 1, -1 do
        decs[words[i]] = i - 1
    end
    local splits = {}
    for i = 2, #args do
        table.insert(splits, args[i])
    end

    local function dec2word(num, wordsLength)
        local word = {}
        while (num > 0)
        do
            table.insert(word, words[num % wordslen + 1])
            num = math.floor(num / wordslen)
        end
        wordsLength = wordsLength or #word;
        while (wordsLength > #word)
        do
            table.insert(word, words[1])
        end

        local arg = ""
        for i = 1, #word do
            arg = arg .. word[i]
        end
        return arg
    end

    local function word2dec(word)
        word = StringToTable(word)
        local num = 0
        for i = #word, 1, -1 do
            num = num * wordslen
            num = num + decs[word[i]]
        end
        return num
    end

    local function unescape(word)
        if (#word ~= maxLength) then
            return nil
        end
        local num = word2dec(word);
        local output = {};
        for i = #splits, 1, -1 do
            table.insert(output, 1, num % splits[i]);
            num = math.floor(num / splits[i]);
        end
        local list = {}
        return output
    end

    function escape(...)
        local arguments = { ... }
        if #arguments ~= #splits then
            return nil
        end
        local num = 0;
        local len = #splits
        for i = 1, len do
            num = num * splits[i];
            num = num + math.floor(arguments[i])
            print(num)
        end
        return dec2word(num, maxLength);
    end

    local num = 1;
    for i = #splits, 1, -1 do
        num = num * math.floor(splits[i])
    end
    maxLength = #dec2word(num)

    return {
        unescape = unescape,
        escape = escape
    }
end

local IdGen = IDGenerator("RP40L2Hr7zoAOpqW83StyaYDbEVgQMNjZTuFkvlfUdJGcwx5nI6Cs1ih9meXKB", 256, 3000000)

return {
    unescape = IdGen.unescape, --把pid转成数字
    escape = IdGen.escape --打数字转成pid
}