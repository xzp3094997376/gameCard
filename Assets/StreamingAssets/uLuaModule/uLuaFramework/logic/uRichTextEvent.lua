local linkEvent = {}


--在此处处理那些信息
function linkEvent:onHyperlink(args)
    --   print(self.binding.currentParams[1] .. "数量" .. self.binding.paramsNum)
end

--初始化
function linkEvent:create(binding)
    self.binding = binding
    return self
end

return linkEvent