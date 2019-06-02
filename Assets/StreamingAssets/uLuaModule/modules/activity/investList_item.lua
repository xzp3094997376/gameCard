local m = {}

function m:update(_data, index, delegate)

    self.investPayCell1:CallUpdate({ data = _data[1], delegate = delegate })

    if _data[2] then
        self.investPayCell2:CallUpdate({ data = _data[2], delegate = delegate })
        self.binding:Show("investPayCell2")
    else
        self.binding:Hide("investPayCell2")
    end
end


function m:create()
    return self
end

return m