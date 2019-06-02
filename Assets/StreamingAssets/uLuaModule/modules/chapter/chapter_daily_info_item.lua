--
-- 头像
local m = {}

local tipsShowStr = ""
--点击事件
function m:onClick(uiButton, eventName)
    if m:isOpen(self.data.id) == false then
		local times = "[00ff00]" .. self.data.des3 .. "[-]"
        tipsShowStr = TextMap.getText("TXT_XS_UNLOCK_DESC", { times })
        MessageMrg.show(tipsShowStr)
		return 
    end
    local open = Player.specialChapter[self.data.id].open
    if open ==false then 
        tipsShowStr =  self.data.remark
        MessageMrg.show(tipsShowStr)
        return 
    end
	Events.Brocast('daily_select_chapter')
    m:isSelect(true)
    self.delegate:updateItem(self.data.id, self.char.realIndex, self)
end

function m:isSelect(ret)
	self.binding:CallManyFrame(function()
		self.select:SetActive(ret)
	end
	)
    if ret == true then
        self.delegate.sIndex = self.index
    end
end

function m:updateChar()
    local char = self.char
	self.txt_name.text = char.show_name
    self.Pic.Url=UrlManager.GetImagesPath("itemImage/" .. char.stage_icon)
    if m:isOpen(self.data.id) == false then
        self.dec.text=string.gsub(TextMap.GetValue("LocalKey_737"),"{0}",self.data.des3)
        self.sou:SetActive(true)
    else
        local open = Player.specialChapter[self.data.id].open
        if open ==false then 
             self.dec.text=self.data.remark
             self.sou:SetActive(true)
        else 
            self.sou:SetActive(false)
            self.dec.text=""
        end
    end
end

--false 未解锁  true 已解锁
function m:isChongzhi(id)
   
    if needLevel <= Player.Info.level then
        self._open = true
    else
        self._open = false
    end
    return self._open
end

--false 未解锁  true 已解锁
function m:isOpen(id)
    local needLevel = self.data.des3
    if needLevel <= Player.Info.level then
        self._open = true
    else
        self._open = false
    end
	return self._open
end


--更新角色列表
--@char 角色 uChar.lua
--@index 列表中的位置
--@delegate 数据控制
function m:update(lua)
	self.data = lua
    self.index = lua.realIndex
    self.char = lua
    self.delegate = lua.delegate
    self:updateChar()
	m:onUpdate()
end

function m:onUpdate()
	m:isSelect(self.delegate.sIndex == self.index)
end

function m:Start()
	Events.AddListener("daily_select_chapter", function()
		m:isSelect(false)
    end)
	--Events.AddListener("updateChar", funcs.handler(self, m.updateChar))
end

function m:OnDestroy()
    Events.RemoveListener('daily_select_chapter')
    --Events.RemoveListener('updateChar')
end

return m

