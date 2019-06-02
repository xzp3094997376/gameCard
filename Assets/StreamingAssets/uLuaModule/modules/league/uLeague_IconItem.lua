local m = {}

function m:update(data, index, csMyTable, delegate)
    self.data = data
    self.isSelect = data.isSelect
    self.delegate = delegate
    if self.isSelect == true then
        self.Sprite_kuang_select.gameObject:SetActive(true)
    else
        self.Sprite_kuang_select.gameObject:SetActive(false)
    end
    self.gameObject.name = tostring(data.iconId)
    self.Sprite.spriteName = tostring(data.iconId)
end

function m:onClick(go, name)
    if self.isSelect == true then
        return
    end
    self.isSelect = true
    self.data.isSelect = self.isSelect
    self.Sprite_kuang_select.gameObject:SetActive(self.isSelect)
    print(self.delegate.onSelectCallback)
    self.delegate.onSelectCallback(self.data.iconId)
    self.delegate.gameObject:SetActive(false)
end

return m