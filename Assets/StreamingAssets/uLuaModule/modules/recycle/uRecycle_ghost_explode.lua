local explode = {}

--显示鬼道列表
function explode:onSelect(go)
    self.effect:SetActive(false)
    if self.isOpen==true then 
        Tool.push("recycle_ghost_rebirth","Prefabs/moduleFabs/recycleModule/recycle_ghost_rebirth",{ delegate = self,tp="ghost",model="CS"})
    else 
        MessageMrg.show(TextMap.GetValue("Text_1_990"))
    end
end

function explode:update(lua)
    self.effect:SetActive(false)
    self.delegate = lua.delegate
    self.btn_add.isEnabled=true
    self.btn_equip.isEnabled=true
    local obj = TableReader:TableRowByID("moduleExplain", 12)
    self.desLabel.text = string.gsub(obj.desc, '\\n', '\n')
    obj = nil
    self.rewardView.gameObject:SetActive(true)
    self:getChar(nil)
    self:checkOpenSelect()
end
function explode:checkOpenSelect()
    self.isOpen=false
    local ghost = Tool.getUnUseGhost()
    for i = 1, #ghost do
        local m = {}
        local gh = ghost[i]
        gh:updateInfo()
        if self.isOpen==false and gh.star>=3 then 
            self.isOpen=true
        end
    end  
end

function explode:showEffect(...)
    self.effect:SetActive(true)
    self.binding:CallManyFrame(function(...)
        GameObject.Destroy(effect1)
        self.binding:CallAfterTime(0.7, function(...)
            self.btn_add.isEnabled=true
            self.btn_equip.isEnabled=true
            self.effect:SetActive(false)
            self.delegate:showMsg(self.rewardList)
        end)
    end)
end

--显示要分解的鬼道
function explode:getChar(char)
    --如果有选择的char显示，没有不显示
    if char ~= nil then
        if self.item ~= nil then
            self.item.gameObject:SetActive(true)
        end
        self.rewardView.gameObject:SetActive(true)
        self.char = char
        if self.char.power > 0 then
            self.name.text = self.char:getItemColorName(self.char.star , self.char.name .. " [00ff00]+ " ..self.char.power.."[-]")  -- 装备名称  
        else   
            self.name.text = self.char:getDisplayColorName() --self.data.suitName  -- 装备名称  ghost:getDisplayColorName()
        end
        self.equip.gameObject:SetActive(true)
        self.btn_add.gameObject:SetActive(false)
        self.equip.Url = self.char:getHead() 
        self.img_bt:SetActive(false)
        self:showReward()
        self.bt_restore.isEnabled = true
    else
        self.char = nil
        self.equip.gameObject:SetActive(false)
        self.btn_add.gameObject:SetActive(true)
        self.name.text = ""
        self.rewardView:refresh({}, self)   
        self.zs_num.text = "0"
        self.bt_restore.isEnabled = false
    end
end
--显示返还物品列表
function explode:showReward()
    local _list = self:getRewardList()
    --self.rewardView:refresh(_list, self)
    _list = nils
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
function explode:getRewardList()
    if self.char == nil then return end
    self.dropTypeList = {}
    local key_arr = {}
    key_arr= self.teams[1].char.key
    local _list = {}
    Api:ghostBirthShowDrop(key_arr, function(result)
        _list = self:getDrop(result.drop)
        self.rewardList = _list
        self.rewardView:refresh(_list, self)
        self.zs_num.text = result.consume[0].consume_arg
        for k, v in pairs(_list) do
            table.insert(self.dropTypeList, v.type)
        end
        end, function()
        end)
    return _list
end

function explode:pushArr(list, _type, id, num)
    local hasFind = false
    local mt = "resource"
    if _type == nil then return list end
    table.foreach(list, function(k, v)
        if num == 0 and v.type == _type then --表示是资源
            v.arg = v.arg + id
            hasFind = true
        elseif num ~= 0 and v.type == _type and v.arg == id then --其他类型
            v.arg2 = v.arg2 + num
            hasFind = true
        end
    end)
    if hasFind ~= true then
        local m = {}
        m.type = _type
        m.arg = id
        m.arg2 = num
        table.insert(list, m)
        m = nil
    end
    return list
end






function explode:reBirth(go)
    if self.char == nil then return end
    local key_arr = {}
    key_arr = self.teams[1].char.key
    self.btn_add.isEnabled=false
    self.btn_equip.isEnabled=false
    Api:ghostBirth(key_arr, function(result)
        self.drop = result.drop
        self:showEffect()
        self:getChar()
        self.teams = {}
        self:checkOpenSelect()
    end, function()
        print("重生失败")
    end)
end

--记录已选的鬼道
function explode:selectGhost(char,isChoose,num)
    if isChoose == true then
        self.char = char
        local temp = {}
        temp.char = self.char
        table.insert(self.teams,temp)
        self:getChar(char)  
    else
        self.char = nil
        self.teams = {}
        self:getChar()
    end
end

function explode:isChoose(go)
    if self.char == nil then --未选择鬼道，进入选择界面
        self:onSelect()
    else                             --有选中的鬼道，再次点击则取消
        self:getChar()
        self.teams = {}
    end
end

function explode:reBirth_two(go)
    -- 展示奖品信息
    UIMrg:pushWindow("Prefabs/moduleFabs/recycleModule/gui_rewards_show", {
                    title = TextMap.GetValue("Text_1_985"),
                    content = TextMap.GetValue("Text_1_991"),
                    content1="",
                    teams = self.teams[1].char,
                    delegate = self,
                    callback = self.reBirth,
                    rewardList = self.rewardList,
                    consume=self.zs_num.text
                    })
end

function explode:onClick(go, name)
    if name == "bt_restore" then
        if Tool:judgeBagCount(self.dropTypeList) == false then return end
        self:reBirth_two(go)
    elseif name == "btn_add" or name == "btn_equip" then
        self:isChoose(go)
    end
end

function explode:Start(...)
    self.img_bt:SetActive(true)
    self.bt_restore.isEnabled = false --开始状态没有英雄不可以点击
    self.teams = {}
end

function explode:create(binding)
    self.binding = binding
    return self
end

return explode