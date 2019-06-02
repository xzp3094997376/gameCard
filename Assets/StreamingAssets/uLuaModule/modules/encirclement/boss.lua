local m = {}

function m:update(data, delegate)
	--print_t(data)
    self.data = data
    self.delegate = delegate
    local row = TableReader:TableRowByID("daxueMaster", data.id)
    local id = row.model
	print("big = " .. (row.big / 1000))
    self.hero:LoadByModelId(id, "idle", function(ctl)
    end, false, -1, row.big / 1000)
    local hp = data.hp --m:curHp(data.masterHp)
    local maxhp = data.maxHp or 1
    self.slider.value = hp / maxhp
    self.txt_boss_name.text = row.name .. " Lv." .. (data.lv or row.level)
    if data.name then
        self.txt_player_name.text = TextMap.GetValue("Text815") .. data.name --TextMap.getText("Finder",data.name)
    else
        self.txt_player_name.text = ""
    end
    local name = row.name
    local star = row.star
    local color = TableReader:TableRowByID("daxuColor", star)
    name = color.color .. name .. "[-]"
    self.txt_boss_name.text = name .. " Lv." .. (data.lv or row.level)
end

function m:curHp(arg)
    local num = 0
    for i = 0, arg.Count - 1 do
        num = num + (arg[i] or 0)
    end
    return num
end

function m:showBoss()
    -- Events.Brocast("ShowBoss",self.data)
    self.delegate:ShowBoss(self.data)
end


function m:Start()
    ClientTool.AddClick(self.Sprite_click, function()--hero
        m:showBoss()
    end)
end

return m