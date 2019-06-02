local _queue = {}
local _queue_meta = { __index = _queue }
--加入队列
function _queue:push(v)
    self[self.tail] = v
    self.tail = self.tail + 1
end

--弹出队列一个元素
function _queue:pop()
    if self.tail == self.head then
        self.tail = 1
        self.head = 1
    else
        local ret = self[self.head]
        self[self.head] = nil
        self.head = self.head + 1
        return ret
    end
end

--加入队列，q为一个队列类型
function _queue:move(q)
    for v in q.pop, q do
        self:push(v)
    end
end

--新建队列
function _queue:new()
    return setmetatable({ head = 1, tail = 1 }, _queue_meta)
end

return _queue;
