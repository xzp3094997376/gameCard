local CengCell = {}
local state = 0
function CengCell:update(luaDatas)
    if luaDatas == nil then
        return
    end
    -- if luaDatas.index == self._index then
    --     return
    -- end
	--print_t(luaDatas)
    self._index = luaDatas.index
    self._callBack = luaDatas.callBack
    self.Label.text =string.gsub(TextMap.GetValue("LocalKey_743"),"{0}",self._index)
    self.Sprite:SetActive(false)
    self.lockSprite:SetActive(false)
	self.Label.gameObject:SetActive(true)
    self.icon_close.gameObject:SetActive(true)
    if self._index > Player.qianCengTa.currentTower then
        if self._index > Player.qianCengTa.lastTower then
            self.lockSprite:SetActive(true)
			self.Label.gameObject:SetActive(false)
        end
        BlackGo.setBlack(0.5, self.ceng_cell.gameObject.transform)
    else
        BlackGo.setBlack(1, self.ceng_cell.gameObject.transform)
        self.icon_close.gameObject:SetActive(false)
    end
    if luaDatas.index == Tool.qianchengta_currentSelect then
        self.Sprite:SetActive(true)
        self:_callBack(self._index, self)
    end
    luaDatas = nil
end

--刷新选中状态onRefeashState
function CengCell:onRefeashSelecteState()
    self.Sprite:SetActive(false)
    if self._index == Tool.qianchengta_currentSelect then
        self.Sprite:SetActive(true)
    end
end

function CengCell:onClick(go, name)
    Tool.qianchengta_currentSelect = self._index
    self:_callBack(self._index, self)
end

function CengCell:create(binding)
    self.binding = binding
    return self
end

return CengCell