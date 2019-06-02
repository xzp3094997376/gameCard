local explode = {}

function explode:onSelect(go)
    if self.isOpen==true then 
        Tool.push("recycle_charList", "Prefabs/moduleFabs/recycleModule/recycle_charList", { teams = {}, delegate = self, model="CS",tp="char" })
    else 
        MessageMrg.show(TextMap.GetValue("Text_1_984"))
    end   
end

function explode:update(lua)
    self.effect:SetActive(false)
    self.delegate = lua.delegate
    local obj = TableReader:TableRowByID("moduleExplain", 6)
    self.desLabel.text = string.gsub(obj.desc, '\\n', '\n')
    obj = nil
    self.btn_add.isEnabled=true
    self.btn_hero.isEnabled=true
    self.rewardView.gameObject:SetActive(true)
    self.rewardView:refresh({}, self)
    self:getChar(nil)
    self:checkOpenSelect()
end
function explode:checkOpenSelect()
    self.isOpen=false
    local chars = Player.Chars:getLuaTable() --获取所有英雄
    local index = 1
    local list = {}
    --遍历所有角色
    for k, v in pairs(chars) do
        local char = Char:new(k, v)
        if self.isOpen==false and char.Table.can_return~=0 and char:getTeamIndex() == 7 and self:checkFriend(char) == false and self:onAgency(char)==false then --是初始状态并且未上阵
            self.isOpen=true
        end 
    end
end

function explode:checkFriend(char)
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
function explode:onAgency(char)
    if char.id == Player.Info.playercharid then return true end 
    for i = 1, 6 do
        local it = Player.Agency[i]
        if tonumber(it.charId) == tonumber(char.id) then return true end
    end
    return false
end

function explode:showEffect(...)
    self.effect:SetActive(true)
    self.binding:CallManyFrame(function(...)
        self.binding:CallAfterTime(0.7, function(...)
            self.btn_add.isEnabled=true
            self.btn_hero.isEnabled=true
            self.effect:SetActive(false)
            self.delegate:showMsg(self.drop)
        end)
    end)
end


function explode:getChar(char)
    --如果有选择的char显示，没有不显示
    if char ~= nil then
        if self.item ~= nil then
            self.item.gameObject:SetActive(true)
        end
        self.rewardView.gameObject:SetActive(true)
        self.char = char
        self.name.text = char:getDisplayName()
        self.hero.gameObject:SetActive(true)
        self.btn_add.gameObject:SetActive(false)
        self.hero:LoadByModelId(self.char.modelid, "idle", function() end, false, 0, 1)
        self.img_bt:SetActive(false)
        self:showReward()
        self.bt_restore.isEnabled = true
    else
        self.char = nil
        self.hero.gameObject:SetActive(false)
        self.btn_add.gameObject:SetActive(true)
        self.name.text = ""
        self.rewardView:refresh({}, self)
        self.rewardView.gameObject:SetActive(false)
        self.zs_num.text = "0"
        self.bt_restore.isEnabled = false
    end
end

function explode:showReward(...)
    self.dropTypeList = {}
    Api:rebirthShowDrop(self.char.id, function(result)
        local drop = self:getDrop(result.drop)
        self.drop = drop
        self.rewardView:refresh(self.drop, self)
        self.zs_num.text = result.consume[0].consume_arg
        for k, v in pairs(self.drop) do
            table.insert(self.dropTypeList, v.type)
        end
    end, function()
    end)
end

function explode:getRewardList()
    local _list = {}
    local num = 0
    local percent = 0
    table.foreach(self.teams, function(k, v)
        num = 0
        local char_obj
        if v.char:getType() == "char" then
            char_obj= TableReader:TableRowByID("charPiece",v.char.dictid)
            if char_obj ~= nil then
                num = v.num * char_obj.consume[0].consume_arg2
            end
        elseif v.char:getType() == "charPiece" then
            num = v.num
            char_obj = TableReader:TableRowByID("charPiece", v.char.id)
        end
        if char_obj ~= nil then    
            percent = percent + char_obj.sell_hunyu * num 
        end
        char_obj = nil
    end)
    if percent > 0 then
        local m = {}
        m.type = sell_type
        m.arg = percent
        m.arg2 = ""
        table.insert(_list, m)
        m = nil
    end
    self.rewardList = _list
    return _list
end

function explode:getDrop(info)
    -- body
    --从服务器获取奖励的物品
    local _list = {}
    if info.Count == 1 then
        local m = {}
        m.type = info[0].type
        m.arg = info[0].arg
        m.arg2 = info[0].arg2
        table.insert(_list, m)
        m = nil
    else
        for i = 0, info.Count - 1 do
            local m = {}
            m.type = info[i].type
            m.arg = info[i].arg
            m.arg2 = info[i].arg2
            table.insert(_list, m)
            m = nil
        end
    end
    return _list
end

function explode:reBirth_two(go)
    -- 展示奖品信息
    UIMrg:pushWindow("Prefabs/moduleFabs/recycleModule/gui_rewards_show", {
                    title = TextMap.GetValue("Text_1_985"),
                    content = TextMap.GetValue("Text_1_986"),
                    content1="",
                    teams = self.teams,
                    delegate = self,
                    callback = self.reBirth,
                    rewardList = self.drop,
                    consume=self.zs_num.text
                    })
end

function explode:reBirth()
    self.btn_add.isEnabled=false
    self.btn_hero.isEnabled=false
    Api:rebirth(self.char.id, function(result)
        self:checkOpenSelect()
        self:getChar()
        self:showEffect()
    end, function()
    end)
end

function explode:isChoose(go)
    if self.char == nil then --进入选择界面
        self:onSelect()
    else
        self:getChar()
        self.char = nil
    end
end

function explode:onClick(go, name)
    if name == "bt_restore" then
        if Tool:judgeBagCount(self.dropTypeList) == false then return end
        self:reBirth_two(go)
    elseif name == "btn_add" or name == "btn_hero" then
        self:isChoose(go)
    end
end

function explode:Start(...)
    self.img_bt:SetActive(true)
    self.bt_restore.isEnabled = false --开始状态没有英雄不可以点击
end

function explode:create(binding)
    self.binding = binding
    return self
end

return explode