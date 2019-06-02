local powerUp = {}


--进化成功,传数据显示属性变化
function powerUp.Show(old, char, result, callback)
    UIMrg:pushWindow("Prefabs/moduleFabs/userinfoModule/tupochenggong_new", { data_before = old, char = char, result = result, callback = callback })
end

function powerUp:setLeft(char)
    self.left.text = char:getStageStar()
end

function powerUp:setRight(char)
    self.right.text = char:getStageStar()
	
	local showStar = false
	local starLists = {}
	local star = math.floor (char.stage / 10 )
    for i = 1, 6 do
		showStar = false
		if i <= star then 
			showStar = true
		end
        starLists[i] = { isShow = showStar }
    end
	self.stars:refresh("", starLists, self)
end



function powerUp:onClose(go)
    table.foreach(self.reward_list, function(i, v)
        MessageMrg.show(TextMap.GetValue("Text537") .. v.name .. " x" .. v.rwCount)
    end)
    UIMrg:popWindow()
    if self.callback ~= nil then
        self.callback()
    end
    if GuideMrg:isPlaying() then
        Messenger.Broadcast("ClosePowerUp")
    end
end

function powerUp:onClick()
	UIMrg:popWindow()
    --if self.finishEffect == true then
    --    self:onClose()
    --end
end


--更新信息
function powerUp:update(lua)
    local char = lua.char
    local data_before = lua.data_before

    --- add  by guan  添加新的突破界面---
    -- hp = "MaxHpV", --生命
    -- pAtk = "PhyAtkV", --物理攻击
    -- pDef = "PhyDefV", --物理防御
    -- mAtk = "MagAtkV", --法术攻击
    -- mDef = "MagDefV", --法术防御
    -- local data_before = {}
    local data_after = {}
    local data_attr = {}
    self:setLeft(char)

    char:updateInfo()
    data_after[1] = char:getAttrSingle("MaxHp", true)
    data_after[2] = char:getAttrSingle("PhyAtk", true)
    --data_after[3] = char:getAttrSingle("MagAtk", true)
    data_after[3] = char:getAttrSingle("PhyDef", true)
    data_after[4] = char:getAttrSingle("MagDef", true)

    data_attr[1] = TextMap.GetValue("Text538")
    data_attr[2] = TextMap.GetValue("Text539")
    --data_attr[3] = TextMap.GetValue("Text540")
    data_attr[3] = TextMap.GetValue("Text541")
    data_attr[4] = TextMap.GetValue("Text542")

    -- add  end -------------------
    local result = lua.result
    self.callback = lua.callback
    local skill = nil
    if (result:ContainsKey("unlock")) then
        --显示解锁技能名称
        --        self.frame_char:SetActive(false)
        --        self.frame_skill:SetActive(true)
        -- self.node_kill:SetActive(true)
        -- self.binding:Hide("btn_close_two")
        --skill = char:getSkill()[result.unlock.skill + 1]
        --if skill ~= nil then
        --    self.name = skill.name
        --end
    else
        --        self.frame_char:SetActive(true)
        --        self.frame_skill:SetActive(false)
        -- self.node_kill:SetActive(false)
        -- self.binding:Show("btn_close_two")
    end

    self:ShowEffect(data_before, data_after, data_attr)
    self:loadModel(char.dictid)
    self.reward_list = RewardMrg.getList(result)
    --    local _oldStage = oldChar.stage
    self:setRight(char)
    --     char:updateInfo()
    --     if char.stage == Tool.GetCharArgs("unlock_trans_level") then
    -- --        MessageMrg.show("解锁[变身]!")
    --         Api:setGuide(1000, 1, function()
    --             GuideConfig:playGuideStep(1000)
    --         end)
    --     end

    if skill == nil then return end

    -- self.img_skill_icon.Url = skill:getIcon()
    -- self.txt_skill_name.text = TextMap.TXT_UNLOCK_SKILL .. skill.name
end

--- add by guan ----
local items = {}
local binds = {}
local curIndex = 1
local maxIndex = 1
function powerUp:ShowEffect(beforeData, afterData, data_attr)
    local index = 1
    for i = 1, table.getn(beforeData) do
        local go = GameObject()
        go.name = "root" .. i
        go.transform.parent = self.Grid.gameObject.transform
        go.transform.localScale = Vector3(1, 1, 1)
        go.layer = self.Grid.gameObject.layer
        items[i] = go
        index = index + 1
    end
    if self.name ~= nil then
        local go = GameObject()
        go.name = "root" .. index
        go.transform.parent = self.Grid.gameObject.transform
        go.transform.localScale = Vector3(1, 1, 1)
        go.layer = self.Grid.gameObject.layer
        items[index] = go
    end

    self.Grid:Reposition()
    self.binding:CallManyFrame(function()
        for i = 1, table.getn(beforeData) do
            local bind = ClientTool.loadAndGetLuaBinding("Prefabs/publicPrefabs/tupoItem", items[i])
            bind.transform.localPosition = Vector3(1000, 0, 0)
            bind:CallUpdate({ beforeData[i], afterData[i], data_attr[i] })
            binds[i] = bind
        end
    end)

    if self.name ~= nil then
        local bind = ClientTool.loadAndGetLuaBinding("Prefabs/publicPrefabs/tuposkill", items[index])
        bind.transform.localPosition = Vector3(1000, 0, 0)
        bind:CallUpdate({ self.name })
        binds[index] = bind
    end



    self.binding:CallAfterTime(0.2, function()
        TweenPosition.Begin(self.hero.gameObject, 0.2, Vector3(-146, 17, 0))
        self.binding:MoveToPos(self.leftRoot, 0.2, Vector3(0, 0, 0), function()
            self.right.gameObject:SetActive(true)
            self.binding:ScaleToGameObject(self.right.gameObject, 0.2, Vector3(1, 1, 1))
        end)
        curIndex = 1
        maxIndex = table.getn(binds)
        if curIndex < maxIndex then
            self:showItem(binds[curIndex].gameObject)
        end
    end)
	
	self.binding:CallAfterTime(1, function()
		self.stars.gameObject:SetActive(true)
	end)
end

--属性值滑进来
function powerUp:showItem(go)
    if curIndex <= maxIndex then
        TweenPosition.Begin(go, 0.2, Vector3(0, 0, 0))
        curIndex = curIndex + 1
        if curIndex <= maxIndex then
            self.binding:CallManyFrame(function()
                self:showItem(binds[curIndex].gameObject)
            end, 5)
            if curIndex == maxIndex then
                --                self.back.isPopWindow = true
                self.finishEffect = true
            end
        end
    else
        return
    end
end

function powerUp:loadModel(model)
    self.hero:LoadByCharId(model, "idle", function(ctl)
    end, false, -1)
end


-- add  end ----------------

function powerUp:Start()

    MusicManager.playByID(29)
    self.leftRoot.transform.localPosition = Vector3(1000, 0, 0)
    self.right.gameObject:SetActive(false)
    self.right.gameObject.transform.localScale = Vector3(3, 3, 3)
    self.hero.gameObject.transform.localPosition = Vector3(-1000, 0, 0)
    self.finishEffect = false
    ClientTool.AddClick(self.back, funcs.handler(self, self.onClick))
end

--- -初始化
-- function powerUp:create(binding)
-- self.binding = binding
--
-- return self
-- end

return powerUp