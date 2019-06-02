local output = true

local m_check_debuger = false
local Udebug = {}
local _print = print
function Udebug.Log(...)
    if MyDebug.isDebug == false then return end
    if output == false then return end

    if output == true then
        local tmp = debug.getinfo(2)
        if tmp.name then
            --            DebugerWarp.Log(tostring(content)
            --                    .. '\n\nline :' .. tmp.currentline
            --                    .. ' 	path :' .. tmp.source
            --                    .. ' 	FuncName : ' .. tmp.name)
            _print(..., '\n\nline :' .. tmp.currentline
                    .. ' 	path :' .. tmp.source
                    .. ' 	FuncName : ' .. tmp.name)
        else
            _print(..., '\n\nline :' .. tmp.currentline
                    .. ' 	path :' .. tmp.source)
            --            DebugerWarp.Log(tostring(content)
            --                    .. '\n\nline :' .. tmp.currentline
            --                    .. ' 	path :' .. tmp.source)
        end
    end
end

print = Udebug.Log

local print = print
local tconcat = table.concat
local tinsert = table.insert
local srep = string.rep
local type = type
local pairs = pairs
local tostring = tostring
local next = next

function print_r(root)
    if MyDebug.isDebug == false then return end
    local cache = { [root] = "." }
    local function _dump(t, space, name)
        local temp = {}
        for k, v in pairs(t) do
            local key = tostring(k)
            if cache[v] then
                tinsert(temp, "+" .. key .. " {" .. cache[v] .. "}")
            elseif type(v) == "table" then
                local new_key = name .. "." .. key
                cache[v] = new_key
                tinsert(temp, "+" .. key .. _dump(v, space .. (next(t, k) and "|" or " ") .. srep(" ", #key), new_key))
            else
                tinsert(temp, "+" .. key .. " [" .. tostring(v) .. "]")
            end
        end
        return tconcat(temp, "\n" .. space)
    end

    print(_dump(root, "", ""))
end

function print_t(t)
	print("______________________begin_________________________")
    local print_r_cache={}
    local function sub_print_r(t,indent)
        if (print_r_cache[tostring(t)]) then
            print(indent.."*"..tostring(t))
        else
            print_r_cache[tostring(t)]=true
            if (type(t)=="table") then
                for pos,val in pairs(t) do
                    if (type(val)=="table") then
                        print(indent.."["..pos.."] => "..tostring(t).." {")
                        sub_print_r(val,indent..string.rep(" ",string.len(pos)+8))
                        print(indent..string.rep(" ",string.len(pos)+6).."}")
                    elseif (type(val)=="string") then
                        print(indent.."["..pos..'] => "'..val..'"')
                    else
                        print(indent.."["..pos.."] => "..tostring(val))
                    end
                end
            else
                print(indent..tostring(t))
            end
        end
    end
    if (type(t)=="table") then
        print(tostring(t).." {")
        sub_print_r(t,"  ")
        print("}")
    else
        sub_print_r(t,"  ")
    end
    print()
	print("______________________end_________________________")
end

function Udebug.LogError(content)
    if output == true then
        --error(content)
        DebugerWarp.LogError(content)
    end
end

function Udebug.LogWarning(content)
    if output == true then
        DebugerWarp.LogWarning(content)
    end
end

function error(str)
    DebugerWarp.LogError(str);
end

function warn(str)
    DebugerWarp.LogWarning(str);
end

return Udebug