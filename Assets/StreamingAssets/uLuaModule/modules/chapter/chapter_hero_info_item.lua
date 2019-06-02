--
-- 头像
local m = {}

local tipsShowStr = ""
--点击事件
function m:onClick(uiButton, eventName)
    if not m:isHaveUnlock(self.data.chars[0].easy) then
        MessageMrg.show(tipsShowStr)
		return 
    end
	Events.Brocast('hero_select_chapter')
    m:isSelect(true)
    self.delegate:updateItem(self.char.realIndex, self)
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
    --self.txt_id.text = char.name
	local tb = split(char.name, "：")
	
	if (self.char.totelChapter >= self.char.realIndex) then 
		self.txt_name.gameObject:SetActive(true)
		self.txt_name.text = tb[2]
	else
		self.txt_name.gameObject:SetActive(false)
	end
	
end

--false 未解锁  true 已解锁
function m:isHaveUnlock(id)
    local lastChapter = Player.NBChapter.lastChapter --普通关卡等级
    local lastSection = Player.NBChapter.lastSection --普通关卡小节
    local row = TableReader:TableRowByID("heroChapter", id)
    if row.unlock_chapter > lastChapter then
        tipsShowStr=string.gsub(TextMap.GetValue("LocalKey_807"),"{0}",row.unlock_chapter)
        tipsShowStr=string.gsub(tipsShowStr,"{1}",row.unlock_section)
        row = nil
        return false
    end
    if row.unlock_chapter == lastChapter and row.unlock_section >= lastSection then
        tipsShowStr=string.gsub(TextMap.GetValue("LocalKey_807"),"{0}",row.unlock_chapter)
        tipsShowStr=string.gsub(tipsShowStr,"{1}",row.unlock_section)
        row = nil
        return false
    end
    row = nil
    return true
end


--更新角色列表
--@char 角色 uChar.lua
--@index 列表中的位置
--@delegate 数据控制
function m:update(lua)

	local name = lua.chars[0].char
	self.data = lua
	self.txt_name.text = name
    self.index = lua.realIndex
    self.char = lua
    self.delegate = lua.delegate
    --self:updateChar()
	m:onUpdate()
end

function m:onUpdate()
	m:isSelect(self.delegate.sIndex == self.index)
end

function m:Start()
	Events.AddListener("hero_select_chapter", function()
		m:isSelect(false)
    end)
	Events.AddListener("updateChar", funcs.handler(self, m.updateChar))
end

function m:OnDestroy()
    Events.RemoveListener('hero_select_chapter')
    Events.RemoveListener('updateChar')
end

return m

