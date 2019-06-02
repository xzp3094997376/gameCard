local m = {}

function m:update(data)
	self.list = data._list
	self.statIndex = data.statIndex
	self.cb = data.cb
	m:showRewardBox(self.list, self.statIndex, self.cb)
end

function m:showRewardBox(_list, statIndex, _cb)
	if _list == nil then return end
    if #_list == 0 then return end 

    local list = {}
    if #_list > 12 * ( statIndex + 1 ) then 
        for i = 1 + ( 12 * statIndex ), 12 *( statIndex + 1 ) do
            table.insert( list, _list[i])
        end
        cb = function ()
            m:showRewardBox(_list, statIndex + 1, _cb)
        end
    else 
        for i = 1 + ( 12 * statIndex ), #_list do
            table.insert( list, _list[i])
        end
        cb = _cb
    end 

    MusicManager.playByID(43)
    local grid = self.Grid--Baoxiang_prefab.transform:FindChild("Grid"):GetComponent(UIGrid)
    local mParent = grid.transform
    local next = self.Next--Baoxiang_prefab.transform:FindChild("Next").gameObject
    next:SetActive(false)
    local goodsManager = self.Sprite--Baoxiang_prefab.transform:FindChild("Sprite"):GetComponent(DestroyObject)
    if cb then
        goodsManager:setCallBack(function ()
            Messenger.Broadcast("RewardSucc")--新手引导的监听
            cb()
            if Player.Info.level<9 then 
                local _id = Player.guide["guidao"]
                if _id <2 then 
                    local ret = true
                    if packTool.checkBoxOpen()==false then 
                        ret =false
                    else 
                        if packTool.checkGhostAndGhostLv()==false then
                            ret =false
                        end
                    end 
                    if ret then
                        table.foreach(unlockMap, function(i, v)
                            if unlockMap[i].guide =="guidao" then 
                                Tool.checkLevelUnLock(i)
                            end 
                            end)
                    end     
                end
            end 
        end)
    end

    local gos = {}
    local effects = {}
    local items = {}
    local charList = {}
    local findIndex = 0
    local itemIndex = 0
    for i = 1, #list do
        local it = list[i]
        if it:getType() == "char" then
            table.insert(charList, it)
            if findIndex == 0 then
                findIndex = i
            end
        elseif itemIndex == 0 then
            itemIndex = i
        end
    end
    if findIndex == 1 and itemIndex > 1 then
        list[findIndex], list[itemIndex] = list[itemIndex], list[findIndex]
    end
    if #list <= 6 then 
        grid.transform.localPosition = Vector3((6-#list)*75,-208,0)
    else 
        grid.transform.localPosition = Vector3(0,-66,0)
    end 
    self.binding:CallAfterTime(0.01, function()
        for i = 1, #list do
            local temp = grid.transform:FindChild("node".. i).gameObject
            local mTran = temp.transform
            local item = ClientTool.loadAndGetLuaBindingFromPool("Prefabs/publicPrefabs/itemAll", self.gameObject)
            local effect = temp.transform:GetChild(0)
            local lab = mTran:Find("tx_name")
            lab.parent = item.transform
			--lab.fontSize = 22
            lab.localPosition = Vector3(0, -75, 0)
            --lab.localScale = Vector3(1.4, 1.4, 1.4)
            lab = lab:GetComponent(UILabel)
            lab.text = list[i]:getDisplayColorName()
            effect.parent = item.transform
            effect.localPosition = Vector3(0, 0, 0)
            effect.localScale = Vector3(1.4, 1.4, 1.4)
            table.insert(effects, effect.gameObject)
            item.gameObject:SetActive(false)
			
            item:CallUpdate({ "char", list[i], 100, 100 })
            item.transform.localPosition = Vector3(0, -120, -500);
            table.insert(gos, mTran)
            table.insert(items, item.gameObject)
        end
    end)

    self.binding:CallAfterTime(0.2, function()
        local index = 1
        local function show()
            self.gameObject:SetActive(true)
            local len = #items
            if len < index then
                goodsManager.isClick = true
                next:SetActive(true)
                --LuaTimer.Add(500, function()
                --    GameObject.Destroy(Baoxiang_prefab.gameObject)
                --    end)
                return
            end
            local tempItem = items[index]
            local item = items[index]
            item:SetActive(true)
            item.transform.parent = gos[index]
            local ts = TweenPosition.Begin(item, 0.4, Vector3.zero)
            effects[index]:SetActive(true)
            local rot = Quaternion(0, 0, 0, -1)
            local r = item:AddComponent(TweenRotation)

            r.duration = 0.4
            r.to = Vector3(0, 0, 360)
            if list[index]:getType() == "char" and list[index].Table.show_special==1 then
                ts:SetOnFinished(function()
                    self.binding:CallAfterTime(0.2, function()
                        --packTool:showChar({ list[index] }, show)
                        local luaTable = {
                            char = list[index],
                            auto = true,
                            cb = function()
                                UIMrg:popWindow()
                                show()
                            end
                        }
                        print("显示第" .. index .. TextMap.GetValue("Text_1_920"))
                        UIMrg:pushWindow("Prefabs/moduleFabs/choukaModule/RewardChar", luaTable)
                        self.binding:CallAfterTime(0.1, function()
                            self.gameObject:SetActive(false)
                        end)
                        index = index + 1
                    end)
                end)
            else
                ts:SetOnFinished(function()
                    index = index + 1
                    show()
                end)
            end
        end

        if #charList > 0 then
            show()
            --LuaTimer.Add(100, function()
            --    eff:SetActive(false)
            --end)
        else
            local len = #items
            for i = 1, len do
                local item = items[i]
                item:SetActive(true);
                item.transform.parent = gos[i]
                local ts = TweenPosition.Begin(item, 0.4, Vector3.zero)
                effects[i]:SetActive(true)
                local rot = Quaternion(0, 0, 0, -1)
                local r = item:AddComponent(TweenRotation)
                if i == len then
                    ts:SetOnFinished(function()
                        goodsManager.isClick = true
                        next:SetActive(true)
                        --LuaTimer.Add(500, function()
                        --    GameObject.Destroy(Baoxiang_prefab.gameObject)
                         --   end )
                        return
                    end)
                end
                r.duration = 0.4
                r.to = Vector3(0, 0, 360)
            end
        end
    end)
end

return m