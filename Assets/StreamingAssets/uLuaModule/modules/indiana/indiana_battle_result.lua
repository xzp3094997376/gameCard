--掠夺宝物碎片结束翻牌
local m = {}

function m:update(data)
    if data == nil then return end
    self.topMenu = LuaMain:ShowTopMenu()
    local drop = json.decode(data.drop:toString())
    local showDrop = json.decode(data.showDrop:toString())
    self:setData(drop,showDrop)
    self.binding:CallManyFrame(function()
        self:setBtnAble(true)
    end, 50)
end

function m:setData(drop,showDrop)
    if drop == nil or showDrop == nil then return end
    self.drop_list = {}  --掉落列表
    for i, j in pairs(drop) do
        local temp = {}
        if self:isUsedType(i) == true then --金钱，钻石，灵子
            temp.type = i
            temp.arg2 = j
            temp.arg = j
        else
            for k,v in pairs(j) do
                temp.type = i
                temp.arg = k
                temp.arg2 = v   
            end
        end
        table.insert(self.drop_list,temp)
    end

    self.showDrop_list = {}  --显示列表
    for i=1,#showDrop do
        local temp = {}
        for a,b in pairs(showDrop[i]) do
            if self:isUsedType(a) == true then
                temp.type = a
                temp.arg2 = b
                temp.arg = b
            elseif a=="money_rdm" then 
                temp.type="money"
                for n,m in pairs(b) do
                    local tb = split(n, "|")
                    temp.arg2=math.random(tb[1] or 1000,tb[2] or 3000)
                    temp.arg=math.random(tb[1] or 1000,tb[2] or 3000)
                end 
            else
                temp.type = a
                for n,m in pairs(b) do
                    temp.arg = n
                    temp.arg2 = m
                end
            end
        end
        table.insert(self.showDrop_list,temp)
    end
end

function m:isUsedType(_type)
    local typeAll = {"gold", "soul","money"}
    for i, j in pairs(typeAll) do
        if _type == j then
            return true
        end
    end
    return false
end

function m:setDrop(data,index,flag)
    if data ~= nil then
        local char = nil
        char = RewardMrg.getDropItem(data)

        if self["__itemAll"..index] == nil then
            self["__itemAll"..index] = ClientTool.loadAndGetLuaBindingFromPool("Prefabs/publicPrefabs/itemAll", self["img_frame_"..index].gameObject)
        end
        self["txt_name_"..index].text = Tool.getNameColor(char.star or char.color or 1) .. char.name .. "[-]"
        self["__itemAll"..index]:CallUpdate({ "char", char, self["img_frame_"..index].width, self["img_frame_"..index].height, true, nil, true })
        if flag == true then
            self.txt_get.text =string.gsub(TextMap.GetValue("LocalKey_772"),"{0}",Tool.getNameColor(char.star or char.color or 1) .. char.name .. "[-]")
            self["dakuang" .. index]:SetActive(true)
        end
    end
end

function m:setShowDrop(index)
    for i=1,2 do
        local data = self.showDrop_list[i]
        local  flag = false
        if data ~= nil then
            for j=1,3 do
                if self["__itemAll"..j] == nil and flag == false then
                    self:setDrop(data,j,false)
                    flag = true
                end
            end
        end
    end
end



function m:onClick(go,name)
    if name == "card_1" then
        self:changeCard(1)
    elseif name == "card_2" then
        self:changeCard(2)
    elseif name == "card_3" then
        self:changeCard(3)
    end
end

--翻牌
function m:changeCard(index)
    if index == nil then return end
    local rotation = Quaternion.identity;
    rotation.eulerAngles = Vector3(0, 80, 0);
    self.binding:RotTo(self["sprite_"..index], 0.2, rotation, function()
        self:setBtnAble(false)
        self["sprite_"..index]:SetActive(false)
        self["bg_"..index]:SetActive(true)
        self.binding:RotTo(self["bg_"..index], 0.2, Quaternion.identity)
        local data = self.drop_list[1]
        self:setDrop(data,index,true)
        self.binding:CallManyFrame(function()
            self:changeOther(index)
        end, 5)
    end)
end

function m:changeOther(index)
    for i=1,3 do
        if i ~= index then
            local rotation = Quaternion.identity;
            rotation.eulerAngles = Vector3(0, 80, 0);
            self.binding:RotTo(self["sprite_"..i], 0.2, rotation, function()
                self["sprite_"..i]:SetActive(false)
                self["bg_"..i]:SetActive(true)
                self.binding:RotTo(self["bg_"..i], 0.2, Quaternion.identity)
            end)
        end
    end
    self:setShowDrop(index)
    self.binding:CallManyFrame(function()
        --self.txt_tip:SetActive(true)
        self.isFinish = true
    end, 10)
end

function m:onClose(go)
    if self.isFinish == false then return end
    Events.Brocast("showMaterial")
    UIMrg:popWindow()
    ClientTool.DestoryScene()
    if GuideMrg:isPlaying() then 
        Messenger.Broadcast('BattleWinClose')--新手引导的监听
    end
end

function m:setBtnAble(flag)
    for i = 1,3 do
        self["card_"..i].isEnabled = flag
    end
end

function m:Start()
    self:setBtnAble(false)
    --self.txt_tip:SetActive(false)
    self.isFinish = false
    ClientTool.AddClick(self.back, funcs.handler(self, self.onClose))
end

return m