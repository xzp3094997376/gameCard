local m = {}

function m:update(data, index, delegate)
    self.index = index + 1
    self.data = data
    self.delegate = delegate
    self:setData(data)
end

function m:getChapterPic(charpterid)
    local name = ""
    TableReader:ForEachLuaTable("Guild_chapter_reward", function(index, item)
        if item.id == charpterid then
            name = item.name
            return true
        end
        return false
    end)
    return name
end

function m:setData(data)
    local name = m:getChapterPic(data.chapterId)
    self.txt_name.text = name
    if data.passType == 1 then
        if self.delegate.delegate:canOpenRewordBox(data.chapterId) then
            self.lock:SetActive(false)
            self.tongguan:SetActive(true)
            self.pic.color=Color(1,1,1)
            self.btn_img_icon.gameObject:SetActive(true)
        else
            self.lock:SetActive(false)
            self.tongguan:SetActive(true)
            self.pic.color=Color(0.5, 0.5, 0.5)
            self.btn_img_icon.gameObject:SetActive(false)
        end
    elseif data.passType == 2 then
        self.btn_img_icon.gameObject:SetActive(true)
        self.tongguan:SetActive(false)
        self.lock:SetActive(false)
        self.pic.color=Color(1, 1, 1)
    elseif data.passType == 4 then
        self.lock:SetActive(true)
        self.tongguan:SetActive(false)
        self.pic.color=Color(0.5, 0.5, 0.5)
        self.btn_img_icon.gameObject:SetActive(false)
    elseif data.passType == 3 then
        self.lock:SetActive(false)
        self.tongguan:SetActive(false)
        self.pic.color=Color(1, 1, 1)
        self.btn_img_icon.gameObject:SetActive(false)
    end
end

function m:onClick(go, btnName)
    if self.data.passType == 1 then
        if self.delegate.delegate:canOpenRewordBox(self.data.chapterId) then
            self.delegate:OnClick_CurChapterItem_Callback(self.data.chapterId)
        else
            MessageMrg.show(TextMap.GetValue("Text1183"))
        end
    elseif self.data.passType == 2 then
        self.delegate:OnClick_CurChapterItem_Callback(self.data.chapterId)
    elseif self.data.passType == 3 then
        MessageMrg.show(TextMap.GetValue("Text1184"))
    elseif self.data.passType == 4 then
        MessageMrg.show(string.gsub(TextMap.GetValue("LocalKey_716"),"{0}",self.data.unlockLv))
    end
end

return m