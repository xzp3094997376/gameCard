local m = {}

local infoBinding
local isChoose = false
local pChooseNum = 0
--初始化
function m:create(binding)
    self.binding = binding
    return self
end


function m:update(lua)
    self.index = lua.index
    self.char = lua.char.char
    self.num = lua.char.num
    self.type = self.char:getType()
    self.delegate = lua.delegate
    self:updateState(lua.char.char.isChoose)
    self:updateItem()
end

function m:getAttrList(arg)
    local list = {}
    local len = arg.Count
    for i = 0, 3 do
        if i > len - 1 then
            list[i + 1] = 0
        else
            list[i + 1] = arg[i]
        end
    end
    return list
end

function m:updateItem(...)
    self.ghost = self.char
    self.img_frame.enabled = false
    if self.__itemAll == nil then
        self.__itemAll = ClientTool.loadAndGetLuaBindingFromPool("Prefabs/publicPrefabs/itemAll", self.img_frame.gameObject)
    end
    self.__itemAll:CallUpdate({ "char", self.ghost, self.img_frame.width, self.img_frame.height, nil,nil,nil,false})
    self.txt_lv.text = "[ffff96]" .. TextMap.GetValue("Text1143") .. "[-]" ..  self.ghost.lv
    self.txt_name.text = self.ghost:getDisplayColorName()
    if self.List_start ~= nil then
        self.List_start.gameObject:SetActive(false)
    end
    if self.type == "ghost" then
        local descLeft = ""
        local list = self.ghost:getDesc(m:getAttrList(self.ghost.info.xilian))
        table.foreachi(list, function(i, v)
            descLeft = descLeft .. v -- .. "\n"
        end)
        local attr = string.sub(descLeft, 1, -2)
        self.txt_des.text = attr
        if self.ghost ~= nil and self.ghost.key ~= nil and self.List_start ~= nil then
            self.List_start.gameObject:SetActive(false)
            local starNum = tonumber(Player.Ghost[self.ghost.key].star)
            if starNum ~= nil and starNum >= 0 then
                self.List_start.gameObject:SetActive(true)
                m:ShowStar(starNum)
            end
        end
    else 
        self.txt_des.text=self.ghost:GetTreasureBaseProperty(0)
    end
end

function m:ShowStar(count)
    local list = {}
    for i = 1, 5 do
        list[i] = self["Star"..i]
        list[i].gameObject:SetActive(false)
    end

    if count > 0 and #list > 0 then
        for i = 1, count do
            list[i].gameObject:SetActive(true)
        end
    end
    self.List_start_grid.repositionNow = true
end


function m:updateState(state)
    isChoose = state
    self.selected:SetActive(state)
end

--点击事件
function m:onClick(uiButton, eventName)
    if self.delegate.tp == "ghost" and self.delegate.model == "FJ" then
        if isChoose == true then --角色已经被选中，再点击取消
            self.selected:SetActive(false)
            self.char.isChoose = false
            self.delegate:saveChars(self.char, false, 1)
            isChoose = false
        else --再次选中
            if table.getn(self.delegate.teams) < 5 then
                self.char.isChoose = true
                isChoose = true
                self.selected:SetActive(true)
                self.delegate:saveChars(self.char, true, 1)
            else
                MessageMrg.show(TextMap.GetValue("Text_1_1017"))
            end
        --保存该物品，并更新选中状态
        end
    elseif (self.delegate.tp == "ghost" or self.delegate.tp == "treasure") and self.delegate.model == "CS" then
        if isChoose == true then --角色已经被选中，再点击取消
            self.selected:SetActive(false)
            self.char.isChoose = false
            self.delegate:selectGhost(self.char, false, 1)
            isChoose = false
        else --再次选中
            if self.delegate.char == nil then
                isChoose = true
                self.selected:SetActive(true)
                self.char.isChoose = true
                self.delegate:selectGhost(self.char, true, 1)
            else
                MessageMrg.show(TextMap.GetValue("Text_1_811"))
            end
        end
    end
end

local TimerID = 0
local clicked = false

function m:OnDestroy()
    LuaTimer.Delete(TimerID)
end


return m