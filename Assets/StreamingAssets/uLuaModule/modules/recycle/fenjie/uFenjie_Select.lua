local charCell = {}
--每一个英雄或碎片的相关信息

local isChoose = false
local pChooseNum = 0


--初始化
function charCell:create(binding)
    self.binding = binding
    return self
end


--更新角色列表
--@char 角色 uChar.lua
--@index 列表中的位置
--@delegate 数据控制
function charCell:update(lua)
    --   print("lua")
    --   print("lua.cahr "..lua.char.char.id)
    -- print(lua.char.isChoose)
    self.index = lua.index
    self.char = lua.char.char
    self.num = lua.char.num --角色身上的等级
    self.delegate = lua.delegate
    if lua.char.char.isChoose == nil then
        lua.char.char.isChoose = false
    end
    self:updateState(lua.char.char.isChoose)
    local _type = self.char:getType()
    self._type = _type
    self.disState = false
    if _type == "char" then
        self:updateChar()
    elseif _type == "pet" then
        self:updatePet()
    end
end

function charCell:onAgency(char)
    if char.id == Player.Info.playercharid then return true end 
    for i = 1, 6 do
        local it = Player.Agency[i]
        if tonumber(it.charId) == tonumber(char.id) then return true end
    end
    return false
end

function charCell:checkFriend(char)
    local teams = Player.Team[12].chars
    local list = {}
    local len = teams.Count
    for i = 0, 7 do
        if i < len then
            if char.id .. "" == teams[i] .. "" then
                return true
            end
        end
    end
    return false
end

function charCell:updatePet()
    local char = self.char
    self.img_frame.enabled = false
    if self.__itemAll == nil then
        self.__itemAll = ClientTool.loadAndGetLuaBindingFromPool("Prefabs/publicPrefabs/itemAll", self.img_frame.gameObject)
    end
    self.__itemAll:CallUpdate({ "char", self.char, self.img_frame.width, self.img_frame.height })
    if self.mType == "char" or self.mType == "charPiece" then 
        self.img_type.spriteName = char:getDingWei()
    else
        self.img_type.gameObject:SetActive(false)
    end
    --属性信息
    self.txt_lv.text = "[ffff96]" .. TextMap.GetValue("Text1143") .. "[-]" ..  char.lv
    self.txt_name.text = char:getDisplayName()
    self.txt_xuemai.text = TextMap.GetValue("Text_1_782") .. char.shenlian
    self.txt_power.text=""
    self.txt_juexing.text = "[ffff96]" .. TextMap.GetValue("Text408") .. "[-]" .. char.power
    self.HuaShenInfo.gameObject:SetActive(false)
    if Player.Info.level >= 50 then
        local star = char.star_level
        local starLists = {}
        local showStar = false
        for i = 1, 5 do
            showStar = false
            if i <= star then 
                showStar = true
            end
            starLists[i] = { isShow = showStar }
        end
        self.stars:refresh("", starLists, self)
        starLists = nil
        showStar = nil
        self.stars.transform.localPosition=Vector3(125,47.2,0)
    else
        self.stars.gameObject:SetActive(false)
    end
    if self.Sprite_dis ~= nil then
        self.Sprite_dis.gameObject:SetActive(false)
    end
end

function charCell:updateState(state)
    isChoose = state
    self.has_enter:SetActive(state)
end
function charCell:updateChar()
    local char = self.char
    self.img_frame.enabled = false
    if self.__itemAll == nil then
        self.__itemAll = ClientTool.loadAndGetLuaBindingFromPool("Prefabs/publicPrefabs/itemAll", self.img_frame.gameObject)
    end
    self.__itemAll:CallUpdate({ "char", self.char, self.img_frame.width, self.img_frame.height })
    if self.mType == "char" or self.mType == "charPiece" then 
        self.img_type.spriteName = char:getDingWei()
    else
        self.img_type.gameObject:SetActive(false)
    end 
    --属性信息
    self.txt_lv.text = "[ffff96]" .. TextMap.GetValue("Text1143") .. "[-]" ..  char.lv
    self.txt_name.text = char:getDisplayName()
    self.txt_xuemai.text = "[ffff96]" .. TextMap.GetValue("Text1144") .. "[-]" .. Player.Chars[char.id].bloodline.level
    self.txt_power.text = "[ffff96]" .. TextMap.GetValue("Text408") .. "[-]" .. char.power
    if self.char.lv >= 50 then  
        self.stars.gameObject:SetActive(true)
        self.txt_juexing.text = TextMap.GetValue("Text_1_779") .. self.char:getStageStar()
        local star = math.floor ( self.char.stage / 10 )
        local starLists = {}
        local showStar = false
        for i = 1, 6 do
            showStar = false
            if i <= star then 
                showStar = true
            end
            starLists[i] = { isShow = showStar }
        end
        self.stars:refresh("", starLists, self)
        starLists = nil
        showStar = nil
        self.dik.transform.localPosition=Vector3(175,-20,0)
    else
        self.txt_juexing.text = ""
        self.stars.gameObject:SetActive(false)
        self.dik.transform.localPosition=Vector3(175,0,0)
    end

    if self.HuaShenInfo ~= nil then self.HuaShenInfo.gameObject:SetActive(false) end

    if self.char.id ~= Player.Info.playercharid and self.char.star_level >= 8 and self.char.lv >= 90 and self.HuaShenInfo ~= nil then
        if self.char.star >= 5 then
            self.HuaShenInfo.gameObject:SetActive(true)
            self.Label_huashenLevel.text = self.char:getHuaShenLevel(self.char.id, self.char.dictid, self.char.quality) --TextMap.GetValue("Text_1_780")..
        else
            self.HuaShenInfo.gameObject:SetActive(false)
        end
    end

    if self.Sprite_dis ~= nil then
        self.Sprite_dis.gameObject:SetActive(false)
        if self.char:getTeamIndex() ~= 7 then
            self.Label_dis.text = TextMap.GetValue("Text_1_1013")
            self.Sprite_dis.gameObject:SetActive(true)
            self.Sprite_dis.spriteName = "jiaobiao_1"
            self.disState = true
        elseif self:checkFriend(self.char) then
            self.Label_dis.text = TextMap.GetValue("Text_1_1014")
            self.Sprite_dis.gameObject:SetActive(true)
            self.Sprite_dis.spriteName = "jiaobiao_3"
            self.disState = true
        elseif self:onAgency(self.char) then
            self.Label_dis.text = TextMap.GetValue("Text_1_343")
            self.Sprite_dis.gameObject:SetActive(true)
            self.Sprite_dis.spriteName = "jiaobiao_4"
            self.disState = true
        end
    end
end

function charCell:updatePiece(num)

    --self.bt_choose.gameObject:SetActive(false)
    self.has_enter:SetActive(false)
    --self.suipian_num.gameObject:SetActive(true)
    --self.suipian_num.text = num
end

function charCell:updateSelect(flag)
    isChoose = flag
    self.has_enter:SetActive(flag)
end

function charCell:saveChar(go, char)
    self.delegate:setChar(char)
end

--点击事件
function charCell:onClick(uiButton, eventName)
    if eventName == "bg" then --点击选择，针对角色
        if self.disState then
            MessageMrg.show(TextMap.GetValue("Text_1_776"))
            return
        end
        if self.delegate.tp == "char" and self.delegate.model=="FJ" then
            if isChoose == true then --角色已经被选中，再点击取消
                self.has_enter:SetActive(false)
                self.delegate:saveChars(self.char, false, 1)
                isChoose = false
                self.char.isChoose = false
            else --再次选中
                if table.getn(self.delegate.teams) < 5 then
                    isChoose = true
                    self.char.isChoose = true
                    self.has_enter:SetActive(true)
                    self.delegate:saveChars(self.char, true, 1)
                else
                    MessageMrg.show(TextMap.GetValue("Text1375"))
                end
            --保存该物品，并更新选中状态
            end
        elseif (self.delegate.tp == "char" or self.delegate.tp == "pet") and self.delegate.model=="CS"
               or (self.delegate.tp == "pet" and self.delegate.model=="FJ")  then
            if self.delegate:getCharId() == nil or self.delegate:getCharId() == self.char.id then
            if isChoose then
                self.has_enter:SetActive(false)
                self.char.isChoose = false
                self:saveChar(go)
                isChoose = false
            else   
                self.has_enter:SetActive(true)
                self.char.isChoose = true
                self:saveChar(go, self.char)
                isChoose = true
            end
        elseif self.delegate:getCharId() ~= nil then
            MessageMrg.show(TextMap.GetValue("Text1375"))
            return false
        end
        end
    end
end

local TimerID = 0
local clicked = false
function charCell:OnDestroy()
    LuaTimer.Delete(TimerID)
end

function charCell:onPress(go, name, ret)
    if name == "btnCell" and self._type == "charPiece" then
        clicked = ret
        if ret then
            LuaTimer.Delete(TimerID)
            local hasExist = false
            table.foreach(self.delegate.teams, function(k, v)
                if v.char:getType() == self.char:getType() and v.char.id == self.char.id then
                    hasExist = true
                end
            end)
            if table.getn(self.delegate.teams) >= 5 and hasExist == false then
                MessageMrg.show(TextMap.GetValue("Text1375"))
                return false
            else
                TimerID = LuaTimer.Add(500, 200, function(id)
                    if (self.num + pChooseNum) >= self.char.count then --碎片的数量
                    MessageMrg.show(TextMap.GetValue("Text1381"))
                    return false
                    else
                        pChooseNum = pChooseNum + 1
                        --self.suipian_num.text = self.num + pChooseNum --再少一个
                        self.delegate:saveChars(self.char, true, self.num + pChooseNum) --花费多少个
                    end
                    if clicked == false then return false end
                    return true
                end)
            end
        else
            -- LuaTimer.Delete(TimerID)
        end
    end
end

return charCell