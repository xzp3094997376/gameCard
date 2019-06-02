--
-- 头像
local m = {}


--点击事件
function m:onClick(uiButton, eventName)
	if self.char.isOpen == false then 
		MessageMrg.show(TextMap.GetValue("Text_1_197"))
		return 
	end 
	Events.Brocast('select_chapter')
    m:isSelect(true)
    self.delegate:updateItem(self.char.realIndex, self, self.cName)
end

function m:isSelect(ret)
	m.select:SetActive(ret)
    if ret == true then
        m.delegate.sIndex = m.char.realIndex
    end
end

function m:updateChar()
    local char = self.char
    --self.txt_id.text = char.name
	local tb = split(char.name, "：")
	self.cName = tb[2]
	self.txt_name.text =string.gsub(TextMap.GetValue("LocalKey_667"),"{0}",tb[1]) --tb[2]
	self.txt_name_un.text = string.gsub(TextMap.GetValue("LocalKey_667"),"{0}",tb[1]) --tb[2]
	self.txt_name_unopen.text = string.gsub(TextMap.GetValue("LocalKey_667"),"{0}",tb[1]) --tb[2]
	if self.char.isOpen == true and self.delegate:isPassChapter(char.id, char.type) == true then 
		self.selectStar:SetActive(true)
		self.unselectStar:SetActive(true)
	else 
		self.selectStar:SetActive(false)
		self.unselectStar:SetActive(false)		
	end 
	if self.char.isOpen == false then 
		self.unopen:SetActive(true)
	else
		self.unopen:SetActive(false)
	end
end


--更新角色列表
--@char 角色 uChar.lua
--@index 列表中的位置
--@delegate 数据控制
function m:update(lua)
    self.index = lua.realIndex
    self.char = lua
    self.delegate = lua.delegate
    self:updateChar()
	m:onUpdate()
	m:setRedPoint()
end

function m:setRedPoint()
	if self["red_point"] == nil then
		return
	end
	self["red_point"]:SetActive(false)
    if Tool.checkChuangguan(self.char.cha_type, self.index) then
        self["red_point"]:SetActive(true)
    end
	m:updateChar()
end

function m:onUpdate()
	m:isSelect(self.delegate.sIndex == self.char.realIndex)
end

function m:Start()
	Events.AddListener("select_chapter", function()
		m:isSelect(false)
    end)
	Events.AddListener("updateChar", 
		function(params)
			m:updateChar()
		end)--funcs.handler(self, m.updateChar))
	Events.AddListener("CheckChuanguanPoint", funcs.handler(self, self.setRedPoint))
end

function m:OnDestroy()
	Events.RemoveListener("CheckChuanguanPoint")
    Events.RemoveListener('select_chapter')
    Events.RemoveListener('updateChar')
end

return m

