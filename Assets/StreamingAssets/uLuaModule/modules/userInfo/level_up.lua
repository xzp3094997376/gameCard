local level_up = {}
local push = false
function level_up:update(data)
    self.canClickBtn = false
    self.binding:CallAfterTime(1, function()
        self.canClickBtn = true
    end)

    local data_before = {}
    local data_after = {}
    local data_attr = {}
	push = data.push
    data_before[1] = data.lv
    data_before[2] = data.bp
    data_before[3] = data.max_bp
    data_before[4] = data.max_char_lv
    data_before[5] = data.vp
    data_before[6] = data.max_vp
    local info = Player.Info
    local res = Player.Resource
    data_after[1] = info.level
    data_after[2] = res.bp
    data_after[3] = res.max_bp
    data_after[4] = res.max_char_lv
    data_after[5] = res.vp
    data_after[6] = res.max_vp

    --data_attr[1] = TextMap.GetValue("Text1446")
    --data_attr[2] = TextMap.GetValue("Text1447")
    --data_attr[3] = TextMap.GetValue("Text1448")
    --data_attr[4] = TextMap.GetValue("Text1449")

    local max_slot = res.max_slot
    max_slot = math.min(max_slot, 6)
    if data.max_slot < max_slot then
        self._showOpenSlot = true
    end
    data.lv = info.level
    data.max_bp = res.max_bp
    data.max_char_lv = res.max_char_lv
    data.bp = res.bp
    data.max_slot = max_slot
    MusicManager.playByID(36)
    DialogMrg._levelData = data
    --self:Show(data_before, data_after, data_attr)
	
	self:updateDes(data_before, data_after)
	local tb = TableReader:TableRowByID("lvUpDrop", data_before[1])
	for i = 1, 3 do 
		local id = tb.lvuptxt[i-1]
		local item = TableReader:TableRowByID("lvuptxt", id)
		self["item"..i]:CallUpdate({data = item})
	end 

end

function level_up:updateDes(data_before, data_after)
	self.txt_lv.text = TextMap.GetValue("Text_1_2823") .. data_before[1]
	self.txt_lv_add.text = data_after[1]
	
	self.txt_life.text = TextMap.GetValue("Text_1_2824") .. data_before[2]
	self.txt_life_add.text = data_after[2]
	
	self.txt_jingli.text = TextMap.GetValue("Text_1_2825") .. data_before[5]
	self.txt_jingli_add.text = data_after[5]
end 

local items = {}
local binds = {}
local curIndex = 1
local maxIndex = 1
function level_up:Show(beforeData, afterData, data_attr)
    for i = 1, 4 do
        local go = GameObject()
        go.name = "root" .. i
        go.transform.parent = self.Grid.gameObject.transform
        go.transform.localScale = Vector3(1, 1, 1)
        go.layer = self.Grid.gameObject.layer
        items[i] = go
    end
    self.Grid:Reposition()
    self.binding:CallManyFrame(function()
        for i = 1, table.getn(items) do
            local bind = ClientTool.loadAndGetLuaBinding("Prefabs/publicPrefabs/levelItem", items[i])
            bind.transform.localPosition = Vector3(1000, 0, 0)
            bind:CallUpdate({ beforeData[i], afterData[i], data_attr[i] })
            binds[i] = bind
        end
    end)

    self.binding:CallAfterTime(1, function()
        TweenPosition.Begin(self.renwu, 0.5, Vector3(-149, -65, 0))
        curIndex = 1
        maxIndex = table.getn(binds)
        if curIndex < maxIndex then
            self:showItem(binds[curIndex].gameObject)
        end
    end)
end

--属性值滑进来
function level_up:showItem(go)
    if curIndex <= maxIndex then
        TweenPosition.Begin(go, 0.5, Vector3(0, 0, 0))
        curIndex = curIndex + 1
        if curIndex <= maxIndex then
            self.binding:CallManyFrame(function()
                self:showItem(binds[curIndex].gameObject)
            end, 5)
            if curIndex == maxIndex then
                level_up:finishEffect()
            end
        end
    end
end

local isNext = true
function level_up:finishEffect()
    self.binding:CallManyFrame(function()
        --        self.back.isPopWindow = true
        Api:checkUpdate(function()
            self.finish = true
            isNext = Tool.checkLevelUnLockWithLevel(Player.Info.level)
        end, function(ret)
            self.finish = true
            isNext = Tool.checkLevelUnLockWithLevel(Player.Info.level)
            return true
        end)
    end, 20)
end

function level_up:checkLv(id, ret)
    if Tool.getUnlockLevel(id) == Player.Info.level then
        local unlock = unlockMap[id]
        if unlock then
			-- 如果触发的是夺宝， 背包里面的有宝物碎片的话， 设置完成
			if id == 803 then
				local list = Tool.getTreasurePiece()
				if #list > 0 then 
					Api:setGuide("duobao", 2, function() end)
                    return false 
				end 
			end 
            local step = unlock.guide
            if step~="guidao" then 
                local _id = Player.guide[step]
                print ("_id =" .. _id)
                if _id < 2 then
                    if ret then
                        Tool.checkLevelUnLock(id)
                    end
                    return true
                end
            end
        end
    end
    return false
end

function level_up:InitUnLock()
    local ret = false
    table.foreach(unlockMap, function(i, v)
        if v.effect == true then
            ret = level_up:checkLv(i)
        else
            ret = level_up:checkLv(i, true)
        end
        if ret == true then return end
    end)
end


function level_up:onClick()
    if self.canClickBtn == nil or self.canClickBtn == false then
        return
    end
    Messenger.Broadcast("CloseLevelUp")--新手引导的监听
    if push == nil or push == false then
	   UIMrg:popWindow()
    else
        UIMrg:pop()
    end
    level_up:InitUnLock()
    --if self.finish == true then
    --    UIMrg:popWindow()
    --    if isNext == false and self._showOpenSlot == true and not GuideMrg:isPlaying() then
    --        DialogMrg.ShowDialog(TextMap.getText("TXT_NEW_FORMATION"), function()
    --            Tool.replaceToLevel("team", "Prefabs/moduleFabs/formationModule/formation/formation_main", 2, { 0 })
    --        end, function() end, nil, "openModule")
    --    elseif not isNext then
    --        Messenger.Broadcast("CloseLevelUp")
    --    end
    --end
end

function level_up:Start()
    self.finish = false
    ClientTool.AddClick(self.backcollider, funcs.handler(self, self.onClick))
	
end

return level_up