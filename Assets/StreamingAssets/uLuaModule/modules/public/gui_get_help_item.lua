local m = {}

function m:update(data)
	self.data = data
	local data = self.data
	self.txt_name.text = data.show_name
	self.txt_des.text = data.decs
	self.img_icon.Url = UrlManager.GetImagesPath("tasksImage/" .. data.icon ..".png")
	self.img_go.gameObject:SetActive(true)
end


function m:onClick(go, name)
    if name == "img_go" then
		UIMrg:popWindow()
		uSuperLink.openModule(tonumber(self.data.droptype))
    end
end

function m:Start()

end

return m