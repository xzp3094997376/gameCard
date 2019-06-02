local fenjie = {}

local pos_arr = {}
local selectType = 0
local effects = {}
local effect1 = nil

function fenjie:create(binding)
    self.binding = binding
    return self
end

function fenjie:Start(...)
    --更新六个位置的状态
    self.teams = {}
    self:onUpdate()
end

function fenjie:onExit()
    self.centerE.gameObject:SetActive(false)
end

function fenjie:checkOpenSelect()
    self.isOpen=false
    local ghost = Tool.getUnUseGhost()
    if #ghost>0 then
        self.isOpen=true
    end  
end

function fenjie:setFenYe(...)
    --self.delegate:setGFYShow()
end

--初始状态为空
function fenjie:update(lua)
    if table.getn(effects)>0 then 
        for i = 1, table.getn(effects) do
            if effects[i]~=nil then 
                GameObject.Destroy(effects[i])
            end 
        end
    end 
    if effect1~=nil then 
        GameObject.Destroy(effect1)
    end
    --获取选择的队员
    self.canClick=true 
    self.teams = {}
    self:onUpdate()
    self.delegate = lua.delegate
    self.rewardView.gameObject:SetActive(true)
    self:setTeamInfo({})
    self.rewardView:refresh({}, self)
    self:checkOpenSelect()
end

function fenjie:onDeleteChar(data, index)
    table.foreach(self.teams, function(k, v)
        if v.char:getType() == data:getType() and v.char.id == data.id and v.char.key==data.key then
            pos_arr[index] = false
            table.remove(self.teams, k) 
        end
    end)
    self:showReward()
end

function fenjie:getTeam()
    return self.teams
end

function fenjie:onUpdate(...)
    --初始状态没有任何选择的对象
    local data = self:onInitData()
    self:setTeamInfo()
end

local num = 0
function fenjie:onInitData(...)
    num = 0
    for i = 1, 5 do
        pos_arr[i] = false
        self["k" .. i]:CallUpdate({ data = {}, index = i, delegate = self, fenjieType = "ghost" })
    end
end

function fenjie:setTeamInfo(data)
    local num = 0
    if data ~= nil then
        self.teams = self:sort(data)
        table.foreach(self.teams, function(k, v)
            if pos_arr[k] ~= true then --位置上不存在东西
            pos_arr[k] = true
            end
            self["k" .. k].gameObject:SetActive(true)
            self["k" .. k]:CallUpdate({ data = v, index = k, delegate = self, fenjieType = "ghost" })
            self["k" .. k].name = k
            num = num + 1
        end)
    
        for i = num + 1, 5 do
            pos_arr[i] = false
            self["k" .. i].gameObject:SetActive(true)
            self["k" .. i]:CallUpdate({ data = {}, index = i, delegate = self, fenjieType = "ghost" })
        end
    else  -- 分解完数据为空了 
        for i = num + 1, 5 do
            pos_arr[i] = false
            self["k" .. i].gameObject:SetActive(true)
            self["k" .. i]:CallUpdate({ data = {}, index = i, delegate = self, fenjieType = "ghost" })
        end
    end
    --显示对应的奖励列表
    self:showReward()
    --显示需要消耗的东西
end

function fenjie:showReward(...)
    local _list = self:getRewardList()
    self.rewardView:refresh(_list, self)
end

function fenjie:getRewardList(...)
    local cardData = {}
    table.foreach(self.teams, function(k, v)
        if v.char:getType() == "ghost" then
            table.insert(cardData, v.char.key)
        end
    end)
    self.dropTypeList = {}
    local _list = {}
    if #cardData>0 then
        Api:ghostReturnShowDrop(cardData, function(result)
            _list = self:getDrop(result.drop)
            self.rewardList = _list
            self.rewardView:refresh(_list, self)
            for i = 1, #_list do
                self.dropTypeList[i] = _list[i].type
            end
        end, function()
        end)

    end

    return _list
end

function fenjie:getDrop(info)
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

function fenjie:pushArr(list, _type, id, num)
    local hasFind = false
    local mt = "resource"
    if _type == nil then return list end
    table.foreach(list, function(k, v)
        if (num == 0 or num =="" or num ==nil )and v.type == _type and v.arg ~=nil and (v.arg2==nil or v.arg2=="" or v.arg ==0) then --表示是资源
            v.arg = v.arg + id
            hasFind = true
        elseif (num ~= 0 and num ~="" and num ~=nil ) and v.type == _type and v.arg == id and v.arg2~=nil and v.arg2=="" then --其他类型
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


function fenjie:showConsume(_type)
    local obj = TableReader:TableRowByUnique("resourceDefine", "name", _type)
    if obj ~= nil then
        self.icon.spriteName = obj["img"]
    end
    -- self.zs_num.text = math.floor(num)
end

function fenjie:getTeamInfo() --位置从1开始'
return self.data
end

function fenjie:onExpLode(go)
    --self.rewardListtwo = self:getRewardList()
     --分解队员信息
    local cardData = ""
    local equipArr = {}
    local len = table.getn(self.teams)
    local index = 1
    local pIndex = 1
    for i = 1, len do
        if self.teams[i] ~= nil then
            if self.teams[i].char:getType() == "ghost" then
                equipArr[index] = self.teams[i].char.key
                index = index + 1
            end
        end
    end

    Api:ghostReturn(equipArr, function(result)
        MusicManager.playByID(42)
        self.canClick=false
        self:playAnimation()
        self.saveRewardList = self.rewardList
        LuaMain:refreshTopMenu()
        --self["ziyuanNum1"].text = toolFun.moneyNumberShowOne(math.floor(tonumber(Tool.getCountByType("honor"))))
        self.teams = {}
        self:setTeamInfo({})
        self:checkOpenSelect()
    end, function(...)
        return false
    end)




end



function fenjie:onExplode_two(go)
   	self.saveRewardList = self:getRewardList()
	-- 展示奖品信息
	UIMrg:pushWindow("Prefabs/moduleFabs/recycleModule/gui_rewards_show", {
					title = TextMap.GetValue("Text_1_987"),
					content = TextMap.GetValue("Text_1_1015"),
                    content1=TextMap.GetValue("Text_1_1016"),
					teams = self.teams,
					delegate = self,
					callback = self.onExplodeCallback,
					rewardList = self.rewardList
					})
end

function fenjie:onExplodeCallback()
	 --分解队员信息
    local cardData = ""
    local equipArr = {}
    local len = table.getn(self.teams)
    local index = 1
    local pIndex = 1
    for i = 1, len do
        if self.teams[i] ~= nil then
            if self.teams[i].char:getType() == "ghost" then
                equipArr[index] = self.teams[i].char.key
                index = index + 1
            end

        end
    end
    Api:ghostReturn(equipArr, function(result)
        MusicManager.playByID(42)
        self.canClick=false 
        self:playAnimation()
        self.saveRewardList = self.rewardList
        self.teams = {}
        self:setTeamInfo({})
    end, function(...)
        return false
    end)
end

function fenjie:playAnimation(...)
    local objPos = {}
    local kuangPrefab = ""
    local index = 1
    local charNum = 0
    table.foreach(pos_arr, function(k, v)
        if pos_arr[k] == true then --表示该位置有物体，实例化一个特效
        local effect = ClientTool.load("Effect_New/Prefab/UI_fenjie_kuangge", self["k" .. k].gameObject)
        effects[index] = effect
        index = index + 1
        charNum = charNum + 1
        effect.transform.localPosition = Vector3(0, 0, 0)
        end
    end)
    if charNum ~= 0 then
        for i = num + 1, 5 do
            self["k" .. i].gameObject:SetActive(false)
        end
        self.binding:CallAfterTime(0.2, function(...)
            effect1 = ClientTool.load("Effect_New/Prefab/UI_fenjie", self.centerE)
            effect1.transform.localPosition = Vector3(0, 0, 0)
            for i = 1, table.getn(effects) do
                effects[i].transform.parent = self.centerE.transform

                self.binding:MoveToPos(effects[i], 0.5, Vector3(0, 0, 0), function(...)
                    GameObject.Destroy(effects[i])
                    effects[i]=nil
                    if effect1~=nil then 
                        GameObject.Destroy(effect1)
                        effect1=nil
                    end 
                end)
            end
            self.binding:CallAfterTime(0.5, function(...)
                self.canClick=true
                self.delegate:showMsg(self.saveRewardList)
                for i = num + 1, 5 do
                    self["k" .. i].gameObject:SetActive(true)
                end
            end)
        end)
    end
end

--获取未上阵的且未培养过的鬼道
function fenjie:getData(...)
    local list = {}
    local ghost = Tool.getUnUseGhost()
    local list = {}
    for i = 1, #ghost do
        local gh=Ghost:new(ghost[i].id,ghost[i].key)
        gh:updateInfo()
        if ghost[i].power.."" == "0" and gh.lv==1 and ghost[i].xilian_times.."" == "0" and ghost[i].star<4 then
            local m = {}
            local gh = ghost[i]
            local isChoose = true
            m.isChoose = isChoose
            m.char = gh
            table.insert(list, m)
        end
    end

    table.sort(list, function(a, b)
        local ac = a.char
        local bc = b.char
        if ac:getType() ~= bc:getType() then
            if ac:getType() == "ghostPiece" and bc:getType() == "ghost" then
                return true
            else
                return false
            end
        elseif ac.star ~= bc.star then return ac.star < bc.star 
        elseif ac.id ~=bc .id then return ac.id <bc.id end
    end)
    return list
end

function fenjie:isInTeam(char)
    local isIn = false
    table.foreach(self.teams, function(k, v)
        if char.id == v.char.id and char.key == v.char.key then
            isIn = true
        end
    end)
    return isIn
end

--获取随机的六个英雄或碎片
function fenjie:onGetRandChars(go)
    --self.teams = {}
    self.allList = self:getData()
    local list =self.allList
    local count =table.getn(self.teams)
    if count <5 then 
        if count >0 then 
            table.foreach(self.teams, function(k, v)
                table.foreach(list, function(h, g)
                    if g.char.id == v.char.id then
                        table.remove(list, h)
                    end 
                    end)
                end)
        end
        for i=count+1,5 do 
            if list [i-count] ~=nil then 
                table.insert(self.teams,list [i-count])
            end 
        end 
    end
    
    -- print("table.getn " .. table.getn(self.allList))
    if table.getn(self.teams) == 0 then
        local desc = TextMap.getText("TXT_LACK_LUNHUI_GUI")
        MessageMrg.show(desc)
        return false
    end
    self:setTeamInfo(self.teams)
end

--将所有的英雄，品质排序：绿色、蓝色、紫色
function fenjie:sort(_list)
    table.sort(_list, function(a, b)
        if a.char.star ~= b.char.star then return a.char.star < b.char.star end
    end)
    return _list
end

function fenjie:onClick(go, name)
    if name == "bt_explode" then --分解
        if Tool:judgeBagCount(self.dropTypeList) == false then return end
        local ishigh=false
        local len = table.getn(self.teams)
        for i = 1, len do
            if self.teams[i] ~= nil and ishigh==false then
                if self.teams[i].char.star >=4 then
                    ishigh=true
                end 
            end
        end
        if len>0 then 
            if ishigh==true then 
                self:onExplode_two(go)
            else 
                self:onExpLode(go)
            end 
        end 
    elseif name == "bt_add" then --一键添加
        if self.canClick then 
            self:onGetRandChars(go)
        end 
    elseif name=="blackShop" then 
        print(self.canClick)
        if self.canClick then 
            self:onGoShop(go)
        end 
    end
end

--去声望商店
function fenjie:onGoShop(go)
    uSuperLink.openModule(2)
    -- local binding = UIMrg:replaceToLevel("shop_common", "Prefabs/moduleFabs/puYuanStoreModule/shop_common", 2, { 8 })
    --if uSuperLink.openModule(233, nil, 1) ~= nil then
    --    MusicManager.playByID(16)
    --else
    --    MusicManager.playByID(19)
    --end
end

return fenjie
