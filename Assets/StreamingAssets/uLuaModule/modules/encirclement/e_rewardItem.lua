local m = {}

function m:update(data, index, delegate)
    self.data = data
    self.delegate = data.delegate

    if self.data.item.Table.star ~= nil then
        self.txt_item_name.text = Char:getItemColorName(self.data.item.Table.star, self.data.name)
    else
        self.txt_item_name.text = self.data.name
    end

    -- if self.data.item.Table.color ~= nil then
    --     self.txt_item_name.text = Char:getItemColorName(self.data.item.Table.color, self.data.name)
    -- else
    --     self.txt_item_name.text = self.data.name
    -- end

    self.txt_desc.text = data.decs
    local max = Player.DaXu.gongxun
    self.Sprite_canGet.gameObject:SetActive(false)
    self.Sprite_hasGet.gameObject:SetActive(false)
    self.txt_slider.text = string.gsub(self._descNeed, "{0}", max .. "/" .. data.need)
    if self.__itemAll == nil then
        self.__itemAll = ClientTool.loadAndGetLuaBindingFromPool("Prefabs/publicPrefabs/itemAll", self.img.gameObject)
    end
    if self.data.row.drop[0].type == "treasure" then
        local tb = Treasure:new(self.data.row.drop[0].arg)
        self.__itemAll:CallUpdate({ "treasure" , tb, self.img.width, self.img.height })--"char"
     else
         self.__itemAll:CallUpdate({ "char" , data.item, self.img.width, self.img.height })--"char"
    end
    m:onUpdate()
end

function m:onUpdate()
    local data = self.data
    local max = Player.DaXu.gongxun
    self.btn_name.text = TextMap.GetValue("Text376")

    if Player.DaXu.gongxunReward[data.id] == data.id and max >= data.need then
        --self.btn_reward.isEnabled = true
        self.Sprite_canGet.gameObject:SetActive(true)
        self.Sprite_hasGet.gameObject:SetActive(false)
    else
        if max >= data.need then
           --self.btn_name.text = TextMap.GetValue("Text456")
            self.Sprite_hasGet.gameObject:SetActive(true)
            self.Sprite_canGet.gameObject:SetActive(false)
        end
        --self.btn_reward.isEnabled = false
    end
end

function m:getGXReward()
    local id = self.data.id
    Api:getGXReward(id, function(result)
        m:onUpdate()
        packTool:showMsg(result, nil, 0)
        if self.delegate ~= nil then
            self.delegate:setRedTip()
        end
    end)
end

function m:onClick(go, name)
    if name == "btn_reward" then
        m:getGXReward()
    end
end

function m:Start()
    self._descNeed = TextMap.GetValue("Text126") or ""
    -- Events.AddListener("updateRewardLIst",funcs.handler(self,self.onUpdate))
end

-- function m:OnDestroy()
--     Events.RemoveListener('updateRewardLIst')
-- end


return m