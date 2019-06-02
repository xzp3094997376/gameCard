local m = {}


function m:update(info, index, _table, target)
    self.delegate = target
    self.source = info.source
	local ret = false
    self.txt_name.text, ret = Tool.CheckSuperLink(self.source.id)
	self.go.gameObject:SetActive(ret)
    self.img_icon.Url = UrlManager.GetImagesPath("tasksImage/" .. self.source.icon .. ".png")
    self.info = info
end


function m:onClick(go, name)
	UIMrg:popWindow()
    uluabing = uSuperLink.openModule(self.source.id)
end

function m:create()
    return self
end

return m