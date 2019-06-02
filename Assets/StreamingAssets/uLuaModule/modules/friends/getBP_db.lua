local m = {}

--一键领取
function m:onAcceptBp(...)
    Api:autoAcceptBp(function(result)
        packTool:showMsg(result, nil, 0)
        self.delegate:refresh("getBp")
    end, function(...)
        -- body
    end)
end

function m:update(data)
    self.delegate = data.delegate
    self.count = data.num
    self.listCount = data.listCount
    self.givebp.isEnabled = true
    self.fd_num.text =string.gsub(TextMap.GetValue("LocalKey_693"),"{0}",tostring(data.num))
    if self.count == 0 or self.listCount == 0 then
        self.givebp.isEnabled = false
    end
end

function m:onClick(go, name)
    if name == "givebp" then
        self:onAcceptBp()
    end
end

return m