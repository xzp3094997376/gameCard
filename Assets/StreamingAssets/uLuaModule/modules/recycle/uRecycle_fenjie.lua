local fenjie = {}

local pos_arr = {}
local selectType = 0
local sell_type = "hunyu"
local specialChars = { 3, 5, 15, 19, 21, 24 }
local this = nil
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

function fenjie:setFenYe(...)
    self.delegate:setFYShow()
end

--初始状态为空
function fenjie:update(lua)
    LuaMain:ShowTopMenu(6,nil,self.resLis)
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
    self.canClick=true
    self.teams = {}
    local iconName = Tool.getResIcon("hunyu")
    self:onUpdate()
    self.delegate = lua.delegate
    self.rewardView.gameObject:SetActive(true)
    self.rewardView:refresh({}, self)
    self:checkOpenSelect()
end

function fenjie:checkOpenSelect()
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
function fenjie:checkFriend(char)
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
function fenjie:onAgency(char)
    if char.id == Player.Info.playercharid then return true end 
    for i = 1, 6 do
        local it = Player.Agency[i]
        if tonumber(it.charId) == tonumber(char.id) then return true end
    end
    return false
end

function fenjie:onDeleteChar(data, index)
    -- print("table.get("..table.getn(self.teams))
    table.foreach(self.teams, function(k, v)
        if v.char:getType() == data:getType() and v.char.id == data.id then
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
        self["k" .. i]:CallUpdate({ data = {}, index = i, delegate = self, sell_type = sell_type, fenjieType = "char" })
    end
end

function fenjie:setTeamInfo(data)
        self.centerE.gameObject:SetActive(false)
    local num = 0
    if data ~= nil then
        self.teams = self:sort(data)
        table.foreach(self.teams, function(k, v)
            if pos_arr[k] ~= true then --位置上不存在东西
            pos_arr[k] = true
            end
            self["k" .. k].gameObject:SetActive(true)
            self["k" .. k]:CallUpdate({ data = v, index = k, delegate = self, sell_type = sell_type, fenjieType = "char" })
            self["k" .. k].name = k
            num = num + 1
        end)
        for i = num + 1, 5 do
            pos_arr[i] = false
            self["k" .. i].gameObject:SetActive(true)
            self["k" .. i]:CallUpdate({ data = {}, index = i, delegate = self, sell_type = sell_type, fenjieType = "char" })
        end  
    else
        for i = num + 1, 5 do
            pos_arr[i] = false
            self["k" .. i].gameObject:SetActive(true)
            self["k" .. i]:CallUpdate({ data = {}, index = i, delegate = self, fenjieType = "char" })
        end
    end   
    --显示对应的奖励列表
    self:showReward()
end


function fenjie:showReward(...)
    local _list = self:getRewardList()
    self.rewardView:refresh(_list, self)
    _list = nil
end

function fenjie:getDrop(info)
    -- body
    --从服务器获取奖励的物品
    local _list = {}
    self.dropTypeList = {}
    if info.Count == 1 then
        local m = {}
        m.type = info[0].type
        m.arg = info[0].arg
        m.arg2 = info[0].arg2
        table.insert(_list, m)
        table.insert(self.dropTypeList, m.type)
        m = nil
    else
        for i = 0, info.Count - 1 do
            local m = {}
            m.type = info[i].type
            m.arg = info[i].arg
            m.arg2 = info[i].arg2
            table.insert(_list, m)
            table.insert(self.dropTypeList, m.type)
            m = nil
        end
    end
    return _list
end


function fenjie:getRewardList(...)
    local cardData = {}
    table.foreach(self.teams, function(k, v)
        if v.char:getType() == "char" then
            table.insert(cardData, v.char.id)
        end
    end)
    local _list = {}
    if #cardData>0 then
        Api:decomposeShowDrop(cardData, function(result)
            _list = self:getDrop(result.drop)
            self.rewardView:refresh(_list, self)
            self.rewardList = _list
            end, function()
        end)
    end
    return _list
end

function fenjie:getTeamInfo() --位置从1开始'
return self.data
end




function fenjie:onExpLode(go)
    -- TODO 这里的类型已经去掉， 协议需要修改
    local cardData = {}
    table.foreach(self.teams, function(k, v)
        if v.char:getType() == "char" then
            table.insert(cardData, v.char.id)
        end
    end)
    Api:decompose(cardData, function(result)
        MusicManager.playByID(42)
        self.canClick=false
        self:playAnimation()
        self.saveRewardList = self.rewardList
        self.teams = {}
        self:setTeamInfo({})
        LuaMain:refreshTopMenu()
        --self["ziyuanNum1"].text = toolFun.moneyNumberShowOne(math.floor(tonumber(Tool.getCountByType("hunyu"))))
        self:checkOpenSelect()
    end, function(...)
          return false
    end)
    
end

function fenjie:onExplodeCallback(that)
    --分解队员信息
    local cardData = {}
    table.foreach(self.teams, function(k, v)
        if v.char:getType() == "char" then
            table.insert(cardData, v.char.id)
        end
    end)
	-- TODO 这里的类型已经去掉， 协议需要修改
    Api:decompose(cardData, function(result)
        MusicManager.playByID(42)
        self:playAnimation()
        self.saveRewardList =self.rewardList
        LuaMain:refreshTopMenu()
        --self["ziyuanNum1"].text = toolFun.moneyNumberShowOne(math.floor(tonumber(Tool.getCountByType("hunyu"))))
        --  UluaModuleFuncs.Instance.uTimer:frameTime("playAnimation", 30, 1, that.delegate:showMsg(that.rewardList) , that)
        self.teams = {}
        self:setTeamInfo({})
        self:checkOpenSelect()
    end, function(...)
        return false
    end)
end

function fenjie:onExplode_two(go)
	--self.saveRewardList = self:getRewardList()
	-- 展示奖品信息
	UIMrg:pushWindow("Prefabs/moduleFabs/recycleModule/gui_rewards_show", {
					title = TextMap.GetValue("Text_1_987"),
                    content = TextMap.GetValue("Text_1_988"),
                    content1=TextMap.GetValue("Text_1_989"),
					teams = self.teams,
					delegate = self,
					callback = self.onExplodeCallback,
					rewardList = self.rewardList
					})
	this = self
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
        self.binding:CallAfterTime(0.2, function(...)
            self.centerE.gameObject:SetActive(true)
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
                self.delegate:showMsg(self.saveRewardList)
                self.canClick=true
            end)
        end)
    end
end

function fenjie:checkFriend(char)
    local teams = Player.Team[12].chars
    local list = {}
    local len = teams.Count
    for i = 0, 7 do
        if i < len  then
            if char.id .. "" == teams[i] .. "" then
                return true
            end
        end
    end
    return false
end

--索取所有可用的英雄和英雄碎片
function fenjie:getData(...)
    self.allList = {}
    local chars = Player.Chars:getLuaTable() --获取所有英雄
    local index = 1
    local list = {}
    for k, v in pairs(chars) do
        local char = Char:new(k, v)
        if char.Table.can_return~=0 and char.info.exp <= 1 and char:getTeamIndex() == 7 and self:checkFriend(char) == false and self:onAgency(char)==false and char.star<=4 then --是初始状态并且未上阵,而且星级小雨6
            local m = {}
            m.num = 1
            m.char = char
            m.char.isChoose = true
            table.insert(list, m)
            table.insert(self.allList, m)
            m = nil
        end
    end
    self.allList = self:sort(self.allList)

    return self.allList
end

function fenjie:onAgency(char)
    if char.id == Player.Info.playercharid then return true end 
    for i = 1, 6 do
        local it = Player.Agency[i]
        if tonumber(it.charId) == tonumber(char.id) then return true end
    end
    return false
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

    if table.getn(self.teams) == 0 then
        local desc = TextMap.getText("TXT_LACK_LUNHUI_HERO")
        --   DialogMrg.ShowDialog(desc, function()
        --    Api:buySkillPoint(function(reuslt)
        MessageMrg.show(desc)
        return false
        --     if cb ~= nil then cb() end
        --    end)
        --end)
    end
    self:setTeamInfo(self.teams)
end

--将所有的英雄，碎片排序：3星碎片→3星英雄→4星碎片→4星英雄→5星碎片→5星英雄
function fenjie:sort(_list)
    table.sort(_list, function(a, b)
        --现根据星级
        local ac = a.char
        local bc = b.char
        if ac.star ~= bc.star then return ac.star < bc.star end
        if ac:getType() ~= bc:getType() then
            if ac:getType() == "charPiece" and bc:getType() == "char" then
                return true
            else
                return false
            end
        end
    end)
    return _list
end


--去忍魂商店
function fenjie:onGoShop(go)
    local shoptype = 0
    TableReader:ForEachLuaTable("shop_refresh", function(k, v)
        if v.shop ==8 then 
            shoptype=v.sell_type
        end
        return false
        end)
    UIMrg:pop()
    local binding
    if shoptype==0 then 
        binding=Tool.push("store","Prefabs/moduleFabs/puYuanStoreModule/store",{8})
    else 
        binding=Tool.push("store","Prefabs/moduleFabs/puYuanStoreModule/storeTwo",{8})
    end
    binding:CallTargetFunction("updateOpenPath",true) 
    -- local binding = UIMrg:replaceToLevel("shop_common", "Prefabs/moduleFabs/puYuanStoreModule/shop_common", 2, { 8 })
    --if uSuperLink.openModule(233, nil, 1) ~= nil then
    --    MusicManager.playByID(16)
    --else
    --    MusicManager.playByID(19)
    --end
end

function fenjie:onEnter()
    self.centerE.gameObject:SetActive(false)
end

function fenjie:onClick(go, name)
    if name == "bt_explode" then --分解
        if Tool:judgeBagCount(self.dropTypeList) == false then return end
        self.centerE.gameObject:SetActive(false)
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
            self.centerE.gameObject:SetActive(false)
    		self:onGetRandChars(go)  
        end   
    elseif name == "blackShop" then
        if self.canClick then 
            self:onGoShop(go)
        end 
    end
end

return fenjie