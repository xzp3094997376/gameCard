local m = {}

function m:update(data, index, delegate)
    self.chaperProgress = data.chaperProgress
    self.data = data
    self.delegate = delegate
    self:setData(data)
end

function m:onClick(go, btnName)
    if btnName == "btn_getReward" then
        --MessageMrg.show("还没有实现")
        if self.data.row.id < self.chaperProgress then
            -- 通过的章节
            self:onReward()
        else
            MessageMrg.show(TextMap.GetValue("Text1196"))
        end
    end
end

function m:OnHover()
    if data.row.id >= self.chaperProgress then
        -- 未通过的章节
        local sprite = self.btn_getReward.gameObject:GetComponent(UISprite)
        sprite.color = Color.gray
    end
end

function m:setData(data)
    self.txt_title.text = data.row.name
    if data.isGotReward then
        self.btn_getReward.isEnabled = false
        self.txt_getReward.text = TextMap.GetValue("Text397")
    else
        self.btn_getReward.hover = Color.white
        self.btn_getReward.pressed = Color.white
        self.btn_getReward.defaultColor = Color.white
        self.btn_getReward.isEnabled = true
        self.txt_getReward.text = TextMap.GetValue("Text376")
    end

    if data.row.id >= self.chaperProgress then
        --self.btn_getReward.isEnabled = false
        --self.txt_getReward.text = "未通关"
        -- 未通过的章节
        self.btn_getReward.hover = Color.gray
        self.btn_getReward.pressed = Color.gray
        self.btn_getReward.defaultColor = Color.gray
        local sprite = self.btn_getReward.gameObject:GetComponent(UISprite)
        sprite.color = Color.gray
    end

    self:showItems(data.row.drop)
end

function m:showItems(drop)
    local itemCount = drop.Count
    local voList = {}
    for i = 0, itemCount - 1 do
        local _type = drop[i]["type"]
        local vo = {}
        vo.type = _type
        local char = {}
        char = RewardMrg.getDropItem({type=_type, arg2=drop[i]["arg2"], arg=drop[i]["arg"]})
        vo.data = char
        table.insert(voList, vo)
    end
    self.itemGrid:refresh("Prefabs/moduleFabs/leagueModule/league_chapterRewardItemItem", voList, self, #voList)
end

function m:onReward(...)
    Api:copyPassReward(self.data.row.id, function(result)
        --MessageMrg.show(TextMap.GetValue("Text1168"))
        packTool:showMsg(result, nil, 0)
        GuildDatas:downGuildRewardStatus(function(args)
            self.data.isGotReward = true
            self:setData(self.data)
        end)
    end, function()
        self.btn_getReward.isEnabled = true
    end)
end

return m