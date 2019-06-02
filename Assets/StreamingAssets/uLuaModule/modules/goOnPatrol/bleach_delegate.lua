--死神代理
local m = {}

function m:Start()
    self.topMenu = LuaMain:ShowTopMenu(1)
	Tool.loadTopTitle(self.gameObject, TextMap.GetValue("Text_1_343"))
    self.bg.Url = UrlManager.GetImagesPath("sl_go_on_patrol/bleach_delegate.png")
    local list = {}
	self.lock = false
    TableReader:ForEachLuaTable("areaConfig", function(index, item)
		if self.lock == false and m:checkUn_lock(item) == false then
			self.lock = true 
		end 
        table.insert(list, item)
        return false
    end)
    self.list = list
    m:onUpdate()
    Api:checkRes(function()
        m:onUpdate()
    end, function(ret)
        return true
    end)
    -- myFont = GameManager.GetFont()
    -- myAtlas = ClientTool.Pureload("Prefabs/activityModule/goOnPatrol/goOnPatrol")
    -- myAtlas = myAtlas:GetComponent(UIAtlas)
    -- m:findSprite("top")
    self:addListerForReward()
end

function m:updateLock()
	self.lock = false
    TableReader:ForEachLuaTable("areaConfig", function(index, item)
		if self.lock == false and m:checkUn_lock(item) == false then
			self.lock = true 
		end 
        return false
    end)
end 

function m:onUpdate(...)
	m:updateLock()
    self.getAllReward.gameObject:SetActive(false)
	if self.lock == true then 
		self.btn_onekey.gameObject:SetActive(false)
	else 
		self.btn_onekey.gameObject:SetActive(true)
	end 
    for i = 1, #self.list do
        local item = self.list[i]
        self["btn_pos" .. item.id]:CallUpdate(item)
        self:checkRewardCanGet(self["btn_pos"..item.id])
    end
end

-- function m:findSprite(name)
-- 	local tran = self.gameObject.transform:Find(name)
-- 	if tran == nil then return nil end
-- 	m:setAssets(tran.gameObject:GetComponent(UISprite))
-- end

function m:isCanXunluo()
	for i = 1, 6 do
        local it = Player.Agency[i]
        if tonumber(it.charId) > 0 then 
			return false 
		end
    end
	return true
end 

function m:onClick(go, name) 
    if name == "getAllReward" then
        self:getAllRewardNow()
	elseif name == "btn_onekey" then 
		if m:isCanXunluo() == true then 
			UIMrg:pushWindow("Prefabs/activityModule/goOnPatrol/gui_onekey_patrol", {delegate = self})
		else 
			MessageMrg.show(TextMap.GetValue("Text_1_348"))
		end 
	elseif name == "btnBack" then 
		UIMrg:pop()
    end
end

function m:checkUn_lock(row)
    local id = tonumber(row.id)
    local txt = ""
    local un_lock = row.unlock
    for i = 0, un_lock.Count - 1 do
        local it = un_lock[i]
        if it.unlock_condition == "lv" then
            local lv = it.unlock_arg
            if Player.Info.level < lv then
                return false
            end
        elseif it.unlock_condition == "area" then
            local preRow = TableReader:TableRowByID("areaConfig", it.unlock_arg)
            local pre = Player.Agency[preRow.id+1]
            if pre and pre.state ~= "1" then
                return false
            end
        end
		if Player.Agency[i+1].charId > 0 then 
			return false
		end 
    end
    return true
end

function m:getAllRewardNow() 
    Api:getAllReward(function (result)
        packTool:showMsg(result, self.gameObject, 0)
		m:onUpdate()
        Api:checkRes(function()
            m:onUpdate()
            end,
            function(ret)
                return true
        end)
    end)
end

function m:checkRewardCanGet(item)
    local can = item:CallTargetFunction("canGetReward",{})
    if can == true then
        self.getAllReward.gameObject:SetActive(true)
		self.btn_onekey.gameObject:SetActive(false)
    end
end

function  m:setRewardSpriteActive()

    self.getAllReward.gameObject:SetActive(true)
end

function m:OnDestroy()
    Events.RemoveListener('showRewardSprite')
end

function m:addListerForReward()
     Events.AddListener("showRewardSprite", funcs.handler(self, m.setRewardSpriteActive))
end

function m:setAssets(sp)
    if sp then
        sp.atlas = myAtlas
    end
end

function m:onEnter(...)
    self.topMenu = LuaMain:ShowTopMenu(1)
    m:onUpdate()
end

function m:onExit(...)
    for i = 1, #self.list do
        local item = self.list[i]
        self["btn_pos" .. item.id]:CallTargetFunction("stop")
    end
end




return m