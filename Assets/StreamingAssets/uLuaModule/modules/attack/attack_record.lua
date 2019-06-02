--比武比赛记录界面
local m = {}

function m:update(data)
    self:getRecordList()
end

function m:getRecordList()
    local that = self
    Api:getRecordList(function (result)
        that:initData(result.list)
    end)
end

function m:initData(list)
    if list == nil then return end
    self.item_list = {}
    for i=0,list.Count-1 do
        if list[i] ~= nil then
            local temp = {}
            temp.player1 = list[i].player1
            temp.player2 = list[i].player2
            temp.player1Win = list[i].p1Win
            temp.player2Win = list[i].p2Win
            temp.group = list[i].group
            temp.topNum = list[i].topNum
            temp.version = list[i].version
            temp.level = list[i].level
            table.insert(self.item_list,temp)
        end
    end
    table.sort(self.item_list,function (a,b)
        if a.topNum ~= b.topNum then return tonumber(a.topNum) < tonumber(b.topNum) end
        if a.group ~= b.group then return tonumber(a.group) < tonumber(b.group) end
    end)

    if list.Count == 0 then
        self.un_record:SetActive(true)
    else
        self.un_record:SetActive(false)
    end
    self.scrollview:refresh(self.item_list, self)
end

function m:onClick(go, name)
    if name == "btn_close" then
        UIMrg:popWindow()
    end
end

function m:Start(...)
    self:getRecordList()
end

return m