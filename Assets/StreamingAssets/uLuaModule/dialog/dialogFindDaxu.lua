local m = {}

function m:update(data)
    local msg, onOk, onClose = data.msg, data.onOk, data.onClose
    self.onOk = onOk
    self.onClose = onClose
    self.txt_desc.text = msg or ""
    Events.Brocast("FindDaXu")
end


function m:onClick(go, name)
    if name == "btnClose" then
        if self.onClose then self.onClose() end
        UIMrg:popMessage()
    elseif name == "btnOk" then
        if self.onOk then
            UIMrg:popMessage()
            self.onOk()
        end
    end
end

function m:Start(...)
end

return m