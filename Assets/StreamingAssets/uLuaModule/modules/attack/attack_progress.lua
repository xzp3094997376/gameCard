-- 比武进程主界面
local m = {}

function m:Start()
    LuaMain:ShowTopMenu()
end

function m:update(data)
    if data == nil then return end
    self.halfWiner = data.halfWiner
    self.delegate = data.delegate
    self:initData(data.top32,data.topOther)
    self.type = data.type
    if self.type == "up" then
        self.sprite_qu.spriteName = "KFBW-sbq-da"
    else
        self.sprite_qu.spriteName = "KFBW-xbq-da"
    end
end

--初始化数据
function m:initData(top32,topOther)
    if top32 == nil or topOther == nil then return end
    self.top32_list = {}
    self.topOther_list = {}
    for k,v in pairs(top32) do
        local temp = {}
        temp.player1 = v[1]
        temp.player2 = v[2]
        temp.result = v[3] 
        temp.index = k
        temp.delegate = self.delegate
        table.insert(self.top32_list,temp)
    end
    table.sort(self.top32_list, function (a,b)
        if a.index ~= b.index then return tonumber(a.index) < tonumber(b.index) end
    end)

    for k,v in pairs(topOther) do
        local temp = {}
        temp.player = v
        temp.delegate = self.delegate
        table.insert(self.topOther_list,temp)
    end
    table.sort(self.topOther_list, function (a,b)
        if a.player.topNum ~= b.player.topNum then return tonumber(a.player.topNum) > tonumber(b.player.topNum) end
        if a.player.group ~= b.player.group then return tonumber(a.player.group) < tonumber(b.player.group) end
    end)

    self.list_16 = {}
    self.list_8 = {}
    self.list_4 = {}
    self.list_2 = {}
    for k,v in pairs(self.topOther_list) do
        if tonumber(v.player.topNum) == 16 then --十六强
            v.player.title = TextMap.GetValue("Text1713")
            table.insert(self.list_16,v)
        end
        if tonumber(v.player.topNum) == 8 then --八强
            v.player.title = TextMap.GetValue("Text1714")
            table.insert(self.list_8,v)
        end
        if tonumber(v.player.topNum) == 4 then --四强
            v.player.title = TextMap.GetValue("Text1715")
            table.insert(self.list_4,v)
        end
        if tonumber(v.player.topNum) == 2 then --二强
            v.player.title = TextMap.GetValue("Text1716")
            table.insert(self.list_2,v)
        end
    end
    if self.halfWiner ~= nil then
        self.txt_final.text = self.halfWiner.name
    else
        self.txt_final.text = TextMap.GetValue("Text1717")
    end

    local left_four = {}
    local right_four = {}
    for i =1,#self.top32_list do
        if i <= (#self.top32_list)/2 then
            table.insert(left_four,self.top32_list[i])
        else
            table.insert(right_four,self.top32_list[i])
        end
    end
    local left_seven = {}
    local right_seven = {}
    for i=1,#self.list_16 do
        if i <= (#self.list_16)/2 then
            table.insert(left_seven,self.list_16[i])
        else
            table.insert(right_seven,self.list_16[i])
        end
    end
    for i=1,#self.list_8 do
        if i <= (#self.list_8)/2 then
            table.insert(left_seven,self.list_8[i])
        else
            table.insert(right_seven,self.list_8[i])
        end
    end
    for i=1,#self.list_4 do
        if i <= (#self.list_4)/2 then
            table.insert(left_seven,self.list_4[i])
        else
            table.insert(right_seven,self.list_4[i])
        end
    end
    for i=1,#self.list_2 do
        if i <= (#self.list_2)/2 then
            table.insert(left_seven,self.list_2[i])
        else
            table.insert(right_seven,self.list_2[i])
        end
    end
    self.left:CallUpdate({four_data = left_four,seven_data = left_seven,delegate = self.delegate})
    self.right:CallUpdate({four_data = right_four,seven_data = right_seven,delegate = self.delegate})
end

function m:onClick(go, name)
end

return m