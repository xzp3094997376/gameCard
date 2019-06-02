queue = require("uLuaFramework/Uqueue.lua")

local co = coroutine
local cothread = {}
local _active = queue:new()

function cothread:_resume_active()
    for v in _active.pop, _active do
        assert(co.resume(v))
    end
end

function cothread:resume(ti)
    _resume_active()
    _active:move(timer_pop())
    return _thread_count
end

function cothread:run(f, ...)
    local c = co.create(function()
        _thread_count = _thread_count + 1
        f(unpack(arg))
        _thread_count = _thread_count - 1
    end)
    _active:push(c)
end


function cothread:sleep(ti)
    if ti and ti > 0 then
        timer_add(co.running(), ti - 1)
    else
        _active:push(co.running())
    end
    co.yield()
end


function cothread:new()
    local o = {}
    setmetatable(o, self)
    self.__index = self
    return o
end

return cothread