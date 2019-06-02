local m = {}

function m:update()
    for i = 1, 6 do
        self["box" .. i]:CallUpdateWithArgs(i, "world_boss")
    end
    self.txt_jife.text =string.gsub(TextMap.GetValue("Text137"),"{0}",Player.WorldBoss.dmg )

    -- self.slider.value = Player.WorldBoss.dmg / self.maxJiFei
    self:setSlider()
end

function m:Start()
    self.txt_jife.bitmapFont = GameManager.GetFont()
    self.slider.value = 0
    local row = TableReader:TableRowByID("worldBoss_config", 13)
    local id = row.type
    row = TableReader:TableRowByID("world_boss_damagePrize", id)
    if row then
        self.maxJiFei = row.need
    else
        self.maxJiFei = 1
    end

    self.needList = {}
    for i = 1,6 do
        local row = TableReader:TableRowByID("world_boss_damagePrize", i)
        if row ~= nil then
            self.needList[i] = row.need
        end
    end
end

--设置进度条
function  m:setSlider()
    local damage = Player.WorldBoss.dmg
    local count = 0
    if self.needList ~= nil then
        for  i=1,6 do
            if self.needList[i] ~= nil then
                if damage >= tonumber(self.needList[i]) then
                    count = count +1 
                end
            end
        end
    end

    if count == 0 then
        self.slider.value = 0.166 *damage/tonumber(self.needList[1])
    elseif count >0 and count < 6 then
        self.slider.value = 0.166 * count + (damage-tonumber(self.needList[count]))/(tonumber(self.needList[count+1])-tonumber(self.needList[count]))*0.166
    else
        self.slider.value = 1
    end
end

return m