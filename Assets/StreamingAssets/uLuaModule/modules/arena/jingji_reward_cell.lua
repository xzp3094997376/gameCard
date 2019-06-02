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
	if self.data.row.task_type == "server_daily" then 
		if self.data.row.type == "server_challenge_times" then 
			max = Player.crossArena.has_fight
		elseif self.data.row.type == "server_win_times" then 
			max = Player.crossArena.has_fight_win
		end 
	elseif self.data.row.task_type == "server_weekly" then 
		if self.data.row.type == "server_challenge_times" then 
			max = Player.crossArena.has_fight_week
		elseif self.data.row.type == "server_win_times" then 
			max = Player.crossArena.has_fight_win_week
		end 
	end 
	return max
end 

function m:onUpdate()
    local data = self.data
    local max = self:getMax()
    self.btn_name.text = TextMap.GetValue("Text376")
	--print("data.id = " .. data.id)
	--print("s data id = " .. Player.crossArena.challengeReward[data.id])
	--print("挑战次数每日: " .. Player.crossArena.has_fight)
	
	self.txt_slider.text = string.gsub(self._descNeed, "{0}", math.min(max, data.need) .. "/" .. data.need)
    if Player.crossArena.challengeReward[data.id] == data.id then
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
        --self.btn_reward.isEnabled = false
    end
end

function m:getChallengeReward()
    local id = self.data.id
    Api:getChallengeReward(id, function(result)
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
    self._descNeed = TextMap.GetValue("Text_1_161") or ""
end

return m