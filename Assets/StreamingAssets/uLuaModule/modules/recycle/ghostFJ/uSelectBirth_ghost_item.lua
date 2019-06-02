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
    self.num = lua.char.char.num
    self.txt_strongLevel.gameObject:SetActive(true)
    self.txt_jjLevel.gameObject:SetActive(true)
    self.delegate = lua.delegate
    -- print(lua.char.char.isChoose)
    self:updateState(lua.char.char.isChoose)
    self:updateItem()
end

function m:updateItem(...)
        --self.suipian_num.gameObject:SetActive(false)
        self.img_frame.gameObject:SetActive(false)
        if infoBinding == nil then
            infoBinding = ClientTool.loadAndGetLuaBindingFromPool("Prefabs/publicPrefabs/itemAll", self.go)
        end
        infoBinding:CallUpdate({ "char", self.char, self.img_frame.width, self.img_frame.height })
        --self.labName.text = self.char.name
        --self.txt_jjLevel.text = "+" .. self.char.power
        --self.selected:SetActive(isChoose)
        self.txt_strongLevel.gameObject:SetActive(true)
        self.txt_jjLevel.gameObject:SetActive(false)
        self.txt_strongLevel.text = TextMap.GetValue("Text_1_306") .. self.char.lv --强化等级
        self.labName.text = self.char:getDisplayColorName()
end


function m:updateState(state)
    isChoose = state
    self.selected:SetActive(state)
end

--点击事件
function m:onClick(uiButton, eventName)
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

local TimerID = 0
local clicked = false

function m:OnDestroy()
    LuaTimer.Delete(TimerID)
end

-- function m:onPress(go, name, ret)
--     if name == "btn_select" and self.type == "ghostPiece" then
--         clicked = ret
--         if ret then
--             LuaTimer.Delete(TimerID)
--             local hasExist = false
--             table.foreach(self.delegate.teams, function(k, v)
--                 if v.char:getType() == self.char:getType() and v.char.id == self.char.id then
--                     hasExist = true
--                 end
--             end)
--             if table.getn(self.delegate.teams) >= 6 and hasExist == false then
--                 MessageMrg.show(TextMap.GetValue("Text_1_1017"))
--                 return false
--             else
--                 TimerID = LuaTimer.Add(500, 200, function(id)
--                     if (self.num + pChooseNum) >= self.char.count then --碎片的数量
--                     MessageMrg.show("碎片数量已达上限。")
--                     return
--                     else
--                         pChooseNum = pChooseNum + 1
--                         self.suipian_num.text = self.num + pChooseNum --再少一个
--                         self.delegate:saveChars(self.char, true, self.num + pChooseNum) --花费多少个
--                     end
--                     if clicked == false then return false end
--                     return true
--                 end)
--             end
--             -- else
--             --     LuaTimer.Delete(TimerID)
--         end
--     end
-- end

function m:Start()
    isChoose = false
end

return m