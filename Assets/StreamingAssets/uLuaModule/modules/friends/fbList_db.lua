local m = {}

function m:onClick(go, name)
    if name == "givebp" then
        self:onGiveBp()
    elseif name == "recommandFD" then
        UIMrg:pushWindow("Prefabs/moduleFabs/friendModule/recommandList")
    elseif name == "addFD" then
        UIMrg:pushWindow("Prefabs/moduleFabs/friendModule/RequestFD")
    end
end

function m:onGiveBp(...)
    Api:autoSendBp(function(result)
        self.delegate:refresh("friendList")
    end, function(...)
        -- body
    end)
end

function m:update(data)
    self.delegate = data.delegate
    self.count = data.num

    self.givebp.isEnabled = true
    if self.count == 0 or data.canGive == 0 then
        self.givebp.isEnabled = false
    end
end

function m:addFd(...)
end

return m
