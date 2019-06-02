local starUp = {}

--进化成功,传数据显示属性变化
function starUp.Show(luaTable)
    --    local binding = ClientTool.loadAndGetLuaBinding("Prefabs/moduleFabs/charModule/sub/starUp", GlobalVar.Center)
    --    if luaTable ~= nil then
    --        binding:CallUpdate(luaTable)
    --    end
    UIMrg:pushWindow("Prefabs/moduleFabs/userinfoModule/jinhuachenggong_new", luaTable)
end

function starUp:onClose(go)
    Messenger.Broadcast("ClosePowerUp")--新手引导的监听
    --    SendBatching.DestroyGameOject(self.gameObject)
    UIMrg:popWindow()
end

function starUp:onClick()
    if self.finishEffect == true then
        self:onClose()
    end
end

function starUp:Star(char, _table)
    local stars = {}
    for i = 1, 5 do
        stars[i] = i <= char.star
    end
    ClientTool.UpdateMyTable("", _table, stars)
    MusicManager.playByID(28)
end

function starUp:left(char, desc)
    --    self.txt_name_left.text = char:getDisplayName()
    --    self.char_left_new:CallUpdate({"char",char,96,96})
    --    self.char_left.enabled = false
    --    if self.__itemAllLeft == nil then
    --        self.__itemAllLeft = ClientTool.loadAndGetLuaBindingFromPool("Prefabs/publicPrefabs/itemAll", self.char_left.gameObject)
    --    end
    --    self.__itemAllLeft:CallUpdate({ "char", char, self.char_left.width, self.char_left.height })
    -- self.char_left.spriteName = char:getStarFrame()
    -- self.char_left.text = char:getDisplayName()
    -- self.txt_befor.text = desc
end

function starUp:right(char)
    --    self.txt_name_right.text = char:getDisplayName()
    --    self.char_right_new:CallUpdate({"char",char,96,96})
    --    self.char_right.enabled = false
    --    if self.__itemAll == nil then
    --        self.__itemAll = ClientTool.loadAndGetLuaBindingFromPool("Prefabs/publicPrefabs/itemAll", self.char_right.gameObject)
    --    end
    --    self.__itemAll:CallUpdate({ "char", char, self.char_right.width, self.char_right.height })
    -- self.char_right.spriteName = char:getStarFrame()
    -- self.char_right.text = char:getDisplayName()
    -- local ds = string.gsub(char:getFactorDesc(),"00ff00","ffff00")
    -- self.txt_change.text = ds
end


--更新信息
function starUp:update(lua)
    local char = lua.char
	self.char = char
    local data_before = lua.data_before
    --- add  by guan  添加新的突破界面---
    local data_after = {}
    local data_attr = {}
    -- self:setLeft(char)
    self.name.text = Char:getItemColorName(lua.oldchar.star, lua.oldchar.name.. " [00ff00]+" .. lua.oldchar.star_level.."[-]")   --lua.oldchar:getDisplayName()
    char:updateInfo()
    data_after[1], data_attr[1] = char:getAttrSingle("MaxHp", true)
    data_after[2], data_attr[2] = char:getAttrSingle("PhyAtk", true)
    data_after[3], data_attr[3] = char:getAttrSingle("PhyDef", true)
    data_after[4], data_attr[4] = char:getAttrSingle("MagDef", true)
	
	for i = 1, #data_attr do 
		data_attr[i] = string.gsub(data_attr[i], "{0}", "")
	end 
	
    self:ShowEffect(data_before, data_after, data_attr)
    self:loadModel(char.modelid)
    if self.char:getType()=="yuling" then 
        local name = self.char:getDisplayName()
        if self.char.star_level~=nil and self.char.star_level>0 then 
            name=name .. " [24FC24]+" .. self.char.star_level .. "[-]"
        end 
        self.right_Label.text=name
    else 
        self.right_Label.text = self.char:getDisplayName()--Char:getItemColorName(char.star, char.name.. " +" .. char.star_level)  
    end 
	self.txt_skill_name.text = lua.skillname
	self.txt_skill_des.text = lua.skilldes
    if self.char:getType() == "pet" then
        self.name.text = self.char:getDisplayName()
        self.Grid.transform.localPosition = Vector3(204, 5, 0)
        local list = Tool.getPetStarList(lua.oldchar.star_level - 1)
        self.stars_left:refresh("", list, self)
        local nextStar = lua.oldchar.star_level
        if nextStar >= 5 then 
            nextStar = 5
        end 
        local list2 = Tool.getPetStarList(nextStar)
        self.stars_right:refresh("", list2, self)
    else
        self.Grid.transform.localPosition = Vector3(204, 25, 0)
    end
end

function starUp:Start()
    ClientTool.AddClick(self.back, funcs.handler(self, self.onClick))
    MusicManager.playByID(29)
    self.hero.gameObject.transform.localPosition = Vector3(-1000, 0, 0)
    self.root.transform.localPosition = Vector3(1000, 0, 0)

    self.finishEffect = false
end


--- -初始化
-- function starUp:create(binding)
-- self.binding = binding
--
-- return self
-- end


--- add by guan ----
local items = {}
local binds = {}
local curIndex = 1
local maxIndex = 1
function starUp:ShowEffect(beforeData, afterData, data_attr)
    for i = 1, table.getn(beforeData) do
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
            local bind = ClientTool.loadAndGetLuaBinding("Prefabs/publicPrefabs/tupoItem", items[i])
            bind.transform.localPosition = Vector3(1000, 0, 0)
            bind:CallUpdate({ beforeData[i], afterData[i], data_attr[i] })
            binds[i] = bind
        end
        self.binding:CallAfterTime(0.2, function()
            TweenPosition.Begin(self.hero.gameObject, 0.2, Vector3(-250, 60, 0))
            TweenPosition.Begin(self.root.gameObject, 0.2, Vector3(33, 60, 0))
            if self.char:getType() == "pet" then
                TweenPosition.Begin(self.stars_left.gameObject, 0.2, Vector3(33, 77.8, 0))
                TweenPosition.Begin(self.stars_right.gameObject, 0.2, Vector3(254, 77.8, 0))
            end
            curIndex = 1
            maxIndex = table.getn(binds)
            if curIndex < maxIndex then
                self:showItem(binds[curIndex].gameObject)
            end
        end)
    end)
	self.binding:CallAfterTime(0.5, function()
		self.skill:SetActive(true)
		self.finishEffect = true
	end)
end

--属性值滑进来
function starUp:showItem(go)
    if curIndex <= maxIndex then
        TweenPosition.Begin(go, 0.2, Vector3(0, 0, 0))
        curIndex = curIndex + 1
        if curIndex <= maxIndex then
            self.binding:CallManyFrame(function()
                self:showItem(binds[curIndex].gameObject)
            end, 5)
            --if curIndex == maxIndex then
            --    self.finishEffect = true
            --end
        end
    else
        return
    end
end

function starUp:loadModel(model)
	local effid = -1 
	if self.char:getType() == "pet" or self.char:getType() == "yuling" then 
		effid = 100
        self.stars_left.transform.localPosition = Vector3(1000, 0, 0)
        self.stars_right.transform.localPosition = Vector3(1000, 0, 0)
        self.title.gameObject:SetActive(false)
        self.title_shengxing.gameObject:SetActive(true)
        self.stars_left.gameObject:SetActive(true)
        self.stars_right.gameObject:SetActive(true)
    else
        self.title.gameObject:SetActive(true)
        self.title_shengxing.gameObject:SetActive(false)
        self.stars_left.gameObject:SetActive(false)
        self.stars_right.gameObject:SetActive(false)
	end 
    self.hero:LoadByModelId(model, "idle", function(ctl)
    end, false, effid,1)
end

-- add  end ----------------

return starUp