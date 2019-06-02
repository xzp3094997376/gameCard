local m = {}

function m:update(data)
    self.data = data
    self.delegate = data.delegate
    self.btn_oneKey.isEnabled = false
    m:updateInfo()
end

function m:updateInfo()
    local list = self.list
    local states = Player.DaXu.gongxunReward
    local newList = {}
    local count = 1
    local max = Player.DaXu.gongxun
    local count1 = #list
    for i = #list, 1, -1 do
        local it = list[i]
        it.delegate = self.delegate
        if states[it.id] == it.id then
            table.insert(newList, 1, it)
            count = count + 1
        elseif it.need <= max then
            table.insert(newList, count1, it)
            count1 = count1 - 1
        else
            table.insert(newList, count, it)
        end

        if states[it.id] == it.id and max >= it.need then
            self.btn_oneKey.isEnabled = true
        end
    end
    self.content:refresh(newList, self, true, 0)
end


function m:Start()
    self.txx_desc.text = TextMap.GetValue("Text125")
    local list = {}
    TableReader:ForEachLuaTable("daxuGongxun", function(index, item)
        local it = {}
        it.row = item
        local li = RewardMrg.getProbdropByTable(item.drop)
        local _item = li[1]
        it.item = _item
        it.name = _item.name
        it.need = item.need
        it.decs = item.decs
        it.id = item.id
        list[index + 1] = it
        return false
    end)
    self.list = list
end

function m:onClick(go, name)
    if name == "btn_close" then
        self.gameObject:SetActive(false)
    elseif name == "btn_oneKey" then
        Api:getAllGXReward(function(result)
            packTool:showMsg(result, nil, 0)
            m:update(self.data)
            --m:updateInfo()
        end)
    end
end

return m