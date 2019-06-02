local m = {}

function m:update(data, index, delegate)
    self.data = data
    self.txt_item_name.text = data.name
    self.txt_desc.text = data.desc
    local max = Player.WorldBoss.dmg
    self.txt_slider.text = string.gsub(self._descNeed, "{0}", max .. "/" .. data.need)
    if self.__itemAll == nil then
        self.__itemAll = ClientTool.loadAndGetLuaBindingFromPool("Prefabs/publicPrefabs/itemAll", self.img.gameObject)
    end
    self.__itemAll:CallUpdate({ "char", data.item, self.img.width, self.img.height })
    m:onUpdate()
end

function m:onUpdate()
    local data = self.data
    local max = Player.WorldBoss.dmg
    self.btn_name.text = TextMap.GetValue("Text376")
    self.btn_name.gameObject:SetActive(true)
    self.btn_name_gray.gameObject:SetActive(false)
    self.Sprite_hasGet.gameObject:SetActive(false)

    if Player.WorldBoss.dmgReward[data.id] == data.id and max >= data.need then
        self.btn_reward.gameObject:SetActive(true)
        self.btn_reward.isEnabled = true
    else
        if max >= data.need then
            --self.btn_name.text = TextMap.GetValue("Text456")
            self.Sprite_hasGet.gameObject:SetActive(true)
            self.btn_reward.gameObject:SetActive(false)
        end
        --self.btn_reward.gameObject:SetActive(false)
        self.btn_name.gameObject:SetActive(false)
        self.btn_name_gray.gameObject:SetActive(true)
        self.btn_name_gray.text = TextMap.GetValue("Text1350")
        self.btn_reward.isEnabled = false
    end
end

function m:getBossReward()
    local id = self.data.id
    Api:getBossReward(id, function(result)
        m:onUpdate()
        packTool:showMsg(result, nil, 0)
    end)
end

function m:onClick(go, name)
    if name == "btn_reward" then
        m:getBossReward()
    end
end

function m:Start()

    self._descNeed = TextMap.GetValue("Text130") or ""
end



return m