local starUp = {}


function starUp:onClose(go)
    UIMrg:popWindow()
end

function starUp:onClick()
    if self.finishEffect == true then
        self:onClose()
    end
end


--更新信息
function starUp:update(lua)
	self.data = lua
    local char = lua.char
    local data_before = lua.data_before
    local data_after = lua.data_after
    local data_attr = lua.data_attr
    self.name.text = TextMap.GetValue("Text1107") .. lua.lv - 1
    char:updateInfo()
    self:ShowEffect(data_before, data_after, data_attr)
    self:loadModel(char.dictid)
    self.right_Label.text = lua.lv
    -- self.right_Label.bitmapFont = lua.font
    -- self.name.bitmapFont = lua.font
    lua = nil
end

function starUp:Start()
    ClientTool.AddClick(self.back, funcs.handler(self, self.onClick))
    MusicManager.playByID(29)
    self.hero.gameObject.transform.localPosition = Vector3(-1000, 0, 0)
    self.root.transform.localPosition = Vector3(1000, 0, 0)
    self.finishEffect = false
end


--- add by guan ----
local items = {}
local binds = {}
local curIndex = 1
local maxIndex = 1
function starUp:ShowEffect(beforeData, afterData, data_attr)
	self.skill:SetActive(false)
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
            TweenPosition.Begin(self.hero.gameObject, 0.2, Vector3(-260, 17, 0))
            TweenPosition.Begin(self.root.gameObject, 0.2, Vector3(0, 40, 0))
            curIndex = 1
            maxIndex = table.getn(binds)
            if curIndex < maxIndex then
                self:showItem(binds[curIndex].gameObject)
            end
        end)
    end)
	self.binding:CallAfterTime(1, function()
		self.skill:SetActive(true)
		self.txt_skill.text = self.data.skill_before
		self.txt_skill_next.text = self.data.skill_after
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
            if curIndex == maxIndex then
                self.finishEffect = true
            end
        end
    else
        return
    end
end

function starUp:loadModel(model)
    self.hero:LoadByCharId(model, "idle", function(ctl)
    end, false, -1)
end

return starUp