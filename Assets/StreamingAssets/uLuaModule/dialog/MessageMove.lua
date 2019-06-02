local msg = {}

function msg:update(desc)
    self.msg.text = desc
    self.aMsg:ResetToBeginning()
    self.aMsg.enabled = true
    self.pMsg:ResetToBeginning()
    self.pMsg.enabled = true
    self.sMsg:ResetToBeginning()
    self.sMsg.enabled = true
    self.messageMove.transform.localPosition = Vector3(0, -50, 0)
    self.messageMove.transform.localScale = Vector3(1.5, 1.5, 1.5)
end

function msg:create()
    return self
end

return msg