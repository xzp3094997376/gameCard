local challengeCell = {}
local needLevel = 0

function challengeCell:create(binding)
    self.binding = binding
    return self
end

function challengeCell:update(luaDatas)
    local specialChapter = TableReader:TableRowByID("specialChapter_config", luaDatas.data.id)
    self._data = luaDatas.data
    --self._callBack = luaDatas.callBack

    needLevel = specialChapter.des3
    if needLevel <= Player.Info.level then
        self._open = true
    else
        self._open = false
    end

    self.img.Url = UrlManager.GetImagesPath("offer_challenge_image/" .. luaDatas.data.bg_img .. ".png")

    if self._open == false then
        self.lock:SetActive(true)
        BlackGo.setBlack(0.5, self.btn_item.transform)
        local times = "[00ff00]" .. specialChapter.des3 .. "[-]"
        self.desc.text = TextMap.getText("TXT_XS_UNLOCK_DESC", { times })
    else
        local specialChapter = Player.specialChapter[luaDatas.data.id]
        local times = specialChapter.max_fight - specialChapter.fight
        self.lock:SetActive(false)
        self.desc.text = TextMap.GetValue("Text15") .. "[fedb4f]" .. times .. "[-]"
    end
end

function challengeCell:onClick(go, name)
    if self._open == false then
        MessageMrg.show(string.gsub(TextMap.GetValue("LocalKey_738"),"{0}",needLevel))
    else
        --self:_callBack(self._data.id, self.Sprite, false)
        Tool.push("xuanshang", "Prefabs/moduleFabs/offer_challenge/challengeFight", self._data)
    end
end

return challengeCell
