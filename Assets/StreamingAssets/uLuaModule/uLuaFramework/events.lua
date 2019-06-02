local Event = {}
local events = {}

--增加一个广播监听 event必须唯一，而且必须是字符串，handeler 回调方法，必须是function
function Event.AddListener(event, handler)
    if not event or type(event) ~= "string" then
        print("event parameter in addlistener function has to be string, " .. type(event) .. " not right.")
    end
    if not handler or type(handler) ~= "function" then
        print("handler parameter in addlistener function has to be function, " .. type(handler) .. " not right")
    end

    if not events[event] then
        --新建一个监听，根据输入的名字
        events[event] = EventLib:new(event)
    end
    --连接方法，用于以后回调
    events[event]:connect(handler)
end

--发送广播
function Event.Brocast(event, ...)
    if not events[event] then
        print("brocast " .. event .. " has no event.")
    else
        events[event]:fire(...)
    end
end

--移除监听
function Event.RemoveListener(event, handler)
    if not events[event] then
        print("remove " .. event .. " has no event.")
    else
        events[event]:disconnect(handler)
    end
end

return Event