local m = {}



function m:Start()
    Tool.setFont(self.gameObject, "bg/title_bg/txt_title")


    local list = {}
    TableReader:ForEachLuaTable("world_boss_damagePrize", function(index, item)
        local it = {}
        it.row = item
        local li = RewardMrg.getProbdropByTable(item.drop)
        local _item = li[1]
        it.item = _item
        it.name = _item.name
        it.need = item.need
        it.desc = item.decs

        it.id = item.id
        list[index + 1] = it
        return false
    end)

    local states = Player.WorldBoss.dmgReward
    local newList = {}
    local count = 1
    local max = Player.WorldBoss.dmg
    local count1 = #list
    for i = #list, 1, -1 do
        local it = list[i]
        if states[it.id] == it.id then
            table.insert(newList, 1, it)
            count = count + 1
        elseif it.need <= max then
            table.insert(newList, count1, it)
            count1 = count1 - 1
        else
            table.insert(newList, count, it)
        end
    end
	
	-- table.sort(newList, function(a, b)
	-- 	return a.need > b.need
	-- end)
	
    self.binding:CallManyFrame(function()
        self.content:refresh(newList, self, true, 0)
    end, 2)
end

function m:onClick(go, name)
    UIMrg:popWindow()
end

return m