local m = {}

function m:update(data, index, delegate)
    self.data = data
    self.delegate = delegate
	self.type = "GX"
	self._descNeed = TextMap.GetValue("Text_1_2940") or ""
	if self.delegate.type == 2 then 
		self.type = "LV"
		self._descNeed = TextMap.GetValue("Text_1_2941") or ""
	end 

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
    self.txt_desc.text = data.desc
    local max = self:getMax()
    self.Sprite_canGet.gameObject:SetActive(false)
    self.Sprite_hasGet.gameObject:SetActive(false)
    self.txt_slider.text = string.gsub(self._descNeed, "{0}", math.min(max, data.need) .. "/" .. data.need)
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

function m:getMax()
	local max = 0
	if self.type == "GX" then 
		max = Player.TaoRenBoss.gongxun
	elseif self.type == "LV" then 
		max = self.delegate.bossLv or 0
        if self.delegate.bossHp and self.delegate.bossHp > 0 then 
            max = max - 1
        end
	end 
	return max
end 

function m:onUpdate()
    local data = self.data
    local max = self:getMax()
    self.btn_name.text = TextMap.GetValue("Text376")
	local reward = nil
	if data.type == "gongji" then 
		reward = Player.TaoRenBoss.gongxunReward
	elseif data.type == "jisha" then 
		reward = Player.TaoRenBoss.levelReward
	end 
	self.txt_slider.text = string.gsub(self._descNeed, "{0}", math.min(max, data.need) .. "/" .. data.need)
    if self.type == "GX" then 
        if reward[data.id] == data.id then
	    	if max >= data.need then
	    		self.Sprite_canGet.gameObject:SetActive(true)
	    		self.Sprite_hasGet.gameObject:SetActive(false)
	    	end	
	    else
            if max >= data.need then
               --self.btn_name.text = TextMap.GetValue("Text456")
                self.Sprite_hasGet.gameObject:SetActive(true)
                self.Sprite_canGet.gameObject:SetActive(false)
            end
        end
    else 
        if max >= data.need and reward[data.id] == nil then
	    	self.Sprite_canGet.gameObject:SetActive(true)
	    	self.Sprite_hasGet.gameObject:SetActive(false)
        else 
            if max >= data.need and reward[data.id] and reward[data.id] == 0 then 
	    	    self.Sprite_canGet.gameObject:SetActive(true)
	    	    self.Sprite_hasGet.gameObject:SetActive(false)
            else 
                if max >= data.need then
                    --self.btn_name.text = TextMap.GetValue("Text456")
                    self.Sprite_hasGet.gameObject:SetActive(true)
                    self.Sprite_canGet.gameObject:SetActive(false)
                end
            end 
	    end	
    end
end

function m:getChallengeReward()
    local id = self.data.id
    Api:getLvReward(self.type, id, function(result)
        m:onUpdate()
        packTool:showMsg(result, nil, 0)
        Events.Brocast("updateReward")
    end)
end

function m:onClick(go, name)
    if name == "btn_reward" then
        m:getChallengeReward()
    end
end

function m:Start()
end

return m