--
-- Created by IntelliJ IDEA.
-- User: xiyou
-- Date: 2014/10/15
-- Time: 10:18
-- To change this template use File | Settings | File Templates.
-- 对话框

local dialog = {}

function dialog:update(lua)
    self.type = lua.type
    self._ok = lua.onOk
    self._cancel = lua.onCancel
    self._cancleName = lua.btnName
    self.msg = lua.msg

    if self.type == "openModule" then
        self.txt_btn.text = TextMap.GetValue("Text350")
    elseif self.type == "chong_zhi" then
        self.txt_btn.text = TextMap.GetValue("Text68")
    else
        self.txt_btn.text = TextMap.GetValue("Text351")
    end
    if lua.btnName and lua.btnName ~= "formation" then
        self.txt_btn.text = lua.btnName
    end
    if lua.cancelBtnName~= nil then
        self.cancleTxt.text = lua.cancelBtnName
    else 
        self.cancleTxt.text = TextMap.GetValue("LocalKey_12")
    end
    if lua.btnName ~= nil and lua.btnName == "formation" then
        self.cancleTxt.text = TextMap.GetValue("Text331")
    end
    self.binding:SetLabelAlignment(self.desLab, self.msg, 26)
    self.txt_title.text = lua.title
    self.desLab.text = self.msg
    if self._cancel == true then
        self.binding:Hide("cancel")
        self.sure.transform.localPosition = Vector3(0, -115, 0)
    end
end

function dialog:onOk(go)
    UIMrg:popMessage()
    if self._ok then self._ok() end
    DialogMrg.isShow = false
    if self._callNext ~= nil then
        GuideManager.callNext = self._callNext
    end
end

function dialog:onCancel(go)
    UIMrg:popMessage()
    if self._cancel then self._cancel() end
    DialogMrg.isShow = false
end

function dialog:onClose(go)
    UIMrg:popMessage()
	if self._cancel and type(self._cancel) == "function" then self._cancel() end
    DialogMrg.isShow = false
end

function dialog:onClick(go, name)
    if name == "sure" then
        self:onOk(go)
    elseif name == "cancel" then
        self:onCancel(go)
	elseif name == "btnClose" then 
		self:onClose(go)
    end
end


return dialog
