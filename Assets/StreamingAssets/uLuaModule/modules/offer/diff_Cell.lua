local diffCell = {}

function diffCell:create(binding)
    self.binding = binding
    return self
end

function diffCell:update(luaDatas)
    self._data = luaDatas.data
    self._callBack = luaDatas.callBack

    local specialChapter = Player.specialChapter[luaDatas.Chapter]
    local last_section = last or specialChapter.last_section
    if last_section <= 1 then
        last_section = 1
    end

    BlackGo.setBlack(1, self.selectBtn.transform)
    self.simpleImage.Url = UrlManager.GetImagesPath("offer_challenge_image/diff" .. luaDatas.index .. ".png")
    self.Sprite:SetActive(false)

    local arg = self._data.unlock[0].unlock_arg
    if arg > Player.Info.level then
        self.Label.gameObject:SetActive(true)
        self.Label.text =string.gsub(TextMap.GetValue("LocalKey_737"),"{0}",arg)
        BlackGo.setBlack(0.5, self.selectBtn.transform)
        self.islock = true
    else
        self.Label.gameObject:SetActive(false)
        self.islock = false
    end

    if luaDatas.index == last_section then
        self.Sprite:SetActive(true)
        self:_callBack(self._data.id, self.Sprite, true)
    end
end

function diffCell:onClick(go, name)
    if self.islock then
        MessageMrg.show(self.Label.text)
    else
        self:_callBack(self._data.id, self.Sprite, false)
    end
end

return diffCell