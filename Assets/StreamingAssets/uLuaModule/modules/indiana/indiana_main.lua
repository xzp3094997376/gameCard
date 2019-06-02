--掠夺主界面
local m = {}
local REFRESH_TIMER = 0 

function m:Start(...)
    self.CanSelect=true
    self.type ="main"
	self.selectIndex = 1
    self.topMenu = LuaMain:ShowTopMenu(3)
    Tool.loadTopTitle(self.gameObject, TextMap.GetValue("Text_1_341"))
    Api:checkRes(function(result)
    end)
    --标题
    self.cur_select = 1
    self.max_vp = TableReader:TableRowByID("trsRobConfig", "max_vp").value
    --记录碎片位置
    self.posList = {}
    self.posList[3] = {Vector3(-177, -100, 0),Vector3(-2, 178, 0),Vector3(155, -100, 0)}
    self.posList[4] = {Vector3(-177, 100, 0),Vector3(155, 100, 0),Vector3(155, -100, 0),Vector3(-177, -100, 0)}
    self.posList[5] = {Vector3(-177, 100, 0),Vector3(-2, 178, 0),Vector3(155, 100, 0),Vector3(155, -100, 0),Vector3(-177, -100, 0)}
    self.posList[6] = {Vector3(-177, 100, 0),Vector3(-2, 178, 0),Vector3(155, 100, 0),Vector3(155, -100, 0),Vector3(-177, -100, 0),Vector3(-2, -165, 0)}
    --刷新宝物碎片列表
    self:refreshList()
    self:refreshTime()
    self:refreshVP()
    Events.AddListener("refreshData", funcs.handler(self, m.refreshData))
    Events.AddListener("showMaterial", funcs.handler(self, m.showMaterial))

    self.melt_limit_level = TableReader:TableRowByID("trsRobConfig", "melt_limit_level").value
    self.one_step_rob = TableReader:TableRowByID("trsRobConfig", "one_step_rob").value
    self.one_step_rob_vip = TableReader:TableRowByID("trsRobConfig", "one_step_rob_vip").value
    
    if Player.Info.level >= self.one_step_rob or Player.Info.vip >= self.one_step_rob_vip then
        self.btn_indiana.gameObject:SetActive(true)
        self.btn_synthetic.gameObject.transform.localPosition = Vector3(278,-275,0)
    else
        self.btn_indiana.gameObject:SetActive(false)
        self.btn_synthetic.gameObject.transform.localPosition = Vector3(125,-275,0)
    end
    if Player.Info.level >= self.melt_limit_level then
        self.btn_smelt.gameObject:SetActive(true)
    else
        self.btn_smelt.gameObject:SetActive(false)
    end
end

function m:onEnter()
	LuaMain:ShowTopMenu(3)
end 

function m:OnEnable()
    print("OnEnable")
    m:update()
end

function m:refreshTime()
    local end_time = Player.Treasure:getLong("outOfRobTime")--Player.Treasure.outOfRobTime
    if end_time == nil or end_time == 0 then
        self.txt_time.text = ""
    else
        --倒计时
        local time = ClientTool.GetNowTime(end_time or 0)
        LuaTimer.Delete(REFRESH_TIMER)
        if time > 0 then
            REFRESH_TIMER = LuaTimer.Add(0, 1000, function(id)
                local time = ClientTool.GetNowTime(end_time or 0)
                if time > 0 then
                    time = Tool.FormatTime(time)
                    self.txt_time.text = time
                else
                    self.txt_time.text = ""
                end
            end)
        else
            self.txt_time.text = ""
        end
    end
end

function m:update(lua)
    self:refreshList()
    self:refreshTime()
    self:refreshVP()
end

--刷新宝物碎片列表
function m:refreshList()
    local treasurePiece_list = Tool.getTreasurePiece()
    self.treasure_id_list = {}

    TableReader:ForEachLuaTable("treasure", function(index, item) --遍历宝物碎片表
        if item.star == 3 and item.kind ~= "jing" then
            table.insert(self.treasure_id_list,item.id)
        end
        return false
    end)

    self.tb = {}
    local first_tb = {}
    for k,v in pairs(treasurePiece_list) do
       local id = TableReader:TableRowByID("treasurePiece", v.id).treasureId
       if self:checkId(id) == true then
            table.insert(self.treasure_id_list,id)
       end
    end

    for k,v in pairs(self.treasure_id_list) do
        local treasure = Treasure:new(v)
        local temp  = {}
        temp.type = "normal"
        temp.treasure = treasure
        if treasure.kind == "jing" then        
            table.insert(first_tb,temp)
        else
            table.insert(self.tb,temp)
        end 
    end

    --经验宝物排最前
    table.sort( first_tb, function (i,j)
        if i.treasure.star > j.treasure.star then return j end
    end )

    table.sort( self.tb, function (i,j)
        if i.treasure.star ~= j.treasure.star then return i.treasure.star > j.treasure.star end
        if i.treasure.id ~= j.treasure.id then return i.treasure.id < j.treasure.id end 
    end )

    for i = 1, #first_tb do
        local v = first_tb[i]
        table.insert(self.tb, 1, v)
    end

    for i=1,#self.tb do
        if i == 1 then
            self.tb[i].choose = true
        else
            self.tb[i].choose = false
        end
        self.tb[i].real_index = i
    end
	local list = m:getData(self.tb)
    self.list=list
    self:checkGotoIndex()
    self.scrollview:refresh(list, self, true, 0)
    self.binding:CallAfterTime(0.1,function()
        self.scrollview:goToIndex(self.selectIndex-1)
    end)
    self.targetTreasure=self.tb[self.selectIndex].treasure
    self:showMaterial(self.tb[self.selectIndex])
end

function m:updateItem(index, item)

	--currentId = id
	self.selectIndex = index
	self:showMaterial(self.tb[self.selectIndex])
    self.targetTreasure=self.tb[self.selectIndex].treasure
	--self:onUpdate(false, false)
	--if self.tab then
    --    self.tab:CallUpdate({ delegate = self, char = self.char })
    --end
end

function m:getData(data)
    local list = {}
    for i = 1, table.getn(data), 1 do
        local d = data[i]
        d.realIndex = i
		d.delegate = self
		table.insert(list, d)
    end

    return list
end

function m:checkId(id)
    for i = 1,#self.treasure_id_list do
        if id == self.treasure_id_list[i] then
            return false
        end
    end
    return true
end

--显示宝物需要合成的材料
function m:showMaterial(treasure)
    if treasure == nil then 
        treasure = {}
        treasure.real_index = self.cur_select
        treasure.treasure = self.tb[self.cur_select].treasure
    end
    --设置选中状态
    self.tb[self.cur_select].choose = false
    self.tb[treasure.real_index].choose = true
    self.cur_select = treasure.real_index

    local temp  = {}
    temp.type = "info"
    temp.treasure = treasure.treasure
    self.treasure:CallUpdateWithArgs(temp,nil,self)
    local tb = TableReader:TableRowByID("treasure", treasure.treasure.id)
    if tb == nil then return end
    local list = {}
    local consume = json.decode(tb.consume:toString())
    if consume ~= nil then
        table.foreach(consume, function(i, v)
            if v.consume_type == "treasurePiece" then
                table.insert(list,v)
            end
        end)
    end
    
    local count = #list
    self.count = count
    for i = 1,6 do
        if list[i] ~= nil then
            self["piece_" .. i].gameObject:SetActive(true)
            self["piece_" .. i].gameObject.transform.localPosition = self.posList[count][i]
            local piece = TreasurePiece:new(list[i].consume_arg,list[i].consume_arg2)
            local data = {}
            data.type = "normal"
            data.treasure = piece
            self["piece_" .. i]:CallUpdateWithArgs(data,self)
            self["piece_" .. i]:CallTargetFunction("setEffect",false)
        else
            self["piece_" .. i].gameObject:SetActive(false)
        end
    end

    local flag = self:checkMaterial()
    self.btn_synthetic.isEnabled = flag
    if flag == true then
        self.btn_indiana.isEnabled = false
    else
        self.btn_indiana.isEnabled = true
    end

    self:refreshVP()
end

--检测合成材料是否足够
function m:checkMaterial()
    local cur_treasure = self.tb[self.cur_select].treasure
    local tb = TableReader:TableRowByID("treasure", cur_treasure.id)
    if tb == nil then return end
    local list = {}
    local consume = json.decode(tb.consume:toString())
    if consume ~= nil then
        table.foreach(consume, function(i, v)
            if v.consume_type == "treasurePiece" then
                table.insert(list,v)
            end
        end)
    end
    self.combineNum=0

    for i=1,#list do
        local piece = TreasurePiece:new(list[i].consume_arg,list[i].consume_arg2)
        if piece.count <= 0 then
            return false
        else 
            if self.combineNum==0 then 
                self.combineNum=piece.count
            else 
                self.combineNum=math.min(self.combineNum,piece.count)
            end 
        end
    end
    return true
end

function m:onSynthetic()
    if self:checkMaterial() == true then
        local tp = self.tb[self.cur_select].treasure:getType()
        local treasureid = self.tb[self.cur_select].treasure.id
        local msg = TextMap.GetValue("Text_1_921") .. self.tb[self.cur_select].treasure:getDisplayColorName()
        self.targetTreasure=self.tb[self.cur_select].treasure
        if self.combineNum>1 then 
            local lua = {
            selectMax=self.combineNum,
            data=self.tb[self.cur_select].treasure,
            delegate=self
            }
            UIMrg:pushWindow("Prefabs/moduleFabs/indiana/indiana_combine", lua)
        else 
            self:onSyntheticCallBack(tp,treasureid,msg,1)
        end     
    end
end

function m:onSyntheticCallBack(tp,id,msg,num)
    Api:combineFuncOneKey(tp,id,num,function(result)
        msg=msg .. "X" .. num
        self.btn_synthetic.isEnabled = false
        self:PlayEffect(msg)
        end)
end

--一键掠夺
function m:onIndiana()
    local cur_treasure = self.tb[self.cur_select].treasure
    local tb = TableReader:TableRowByID("treasure", cur_treasure.id)
    local list = {}
    local consume = json.decode(tb.consume:toString())
    if consume ~= nil then
        table.foreach(consume, function(i, v)
            if v.consume_type == "treasurePiece"  and self:check(v.consume_arg) == false then --and self:check(v.consume_arg) == false
                table.insert(list,v.consume_arg)
            end
        end)
    end
    UIMrg:pushWindow("Prefabs/moduleFabs/indiana/indiana_sure", list)
end

function m:check(id)
    local list = Tool.getTreasurePiece()
    for i=1,#list do
        if list[i].id == id then
            return true
        end
    end
    return false
end

--播放特效
function m:PlayEffect(msg)
    self.CanSelect=false
    self.effect:SetActive(false)
    for i=1,self.count do
        self["piece_" .. i]:CallTargetFunction("PlayEffect")
    end
    self.binding:CallAfterTime(0.2,function()
        self.effect:SetActive(true)
    end)
    self.binding:CallAfterTime(1.3,function ()
        MessageMrg.showMove(msg)
        --self:showTip()
        self.effect:SetActive(false)
        self.binding:CallAfterTime(1,function ()
            self:refreshList()
            self.CanSelect=true
        end)
    end)
end

--播放特效
function m:PlayEffect(msg)
    self.effect:SetActive(false)
    for i=1,self.count do
        self["piece_" .. i]:CallTargetFunction("PlayEffect")
    end
    self.binding:CallAfterTime(0.2,function()
        self.effect:SetActive(true)
    end)
    self.binding:CallAfterTime(1.3,function ()
        MessageMrg.showMove(msg)
        --self:showTip()
        self.effect:SetActive(false)
        self.binding:CallAfterTime(1,function ()
            self:refreshList()
        end)
    end)
end

--检测跳转
function m:checkGotoIndex()
    local index=1
    if self.targetTreasure ~=nil then 
        for j=1,#self.tb do
            if self.tb[j].treasure.id ==self.targetTreasure.id  then 
                if self.targetTreasure.star==3 and self.targetTreasure.kind~="jing" then 
                    index=j
                else 
                    local cur_treasure = self.targetTreasure
                    local tb = TableReader:TableRowByID("treasure", cur_treasure.id)
                    if tb == nil then return end
                    local list = {}
                    local consume = json.decode(tb.consume:toString())
                    if consume ~= nil then
                        table.foreach(consume, function(i, v)
                            if v.consume_type == "treasurePiece" then
                                table.insert(list,v)
                            end
                            end)
                    end
                    if self:checkHavePiece(list)== true then 
                        index=j
                    end 
                end   
            end
        end
    end 
    self.selectIndex=index
    print (self.selectIndex)
    return false   
end
function m:checkHavePiece(list)
    for i=1,#list do
        local piece = TreasurePiece:new(list[i].consume_arg,list[i].consume_arg2)
        if piece.count>0 then
            return true
        end 
    end
    return false
end

function m:showTip()
    local temp = {}
    temp.obj = self.tb[self.cur_select].treasure
    temp._type = "treasure"
	temp.type = 1
    Tool.push("treasure_info", "Prefabs/moduleFabs/TreasureModule/treasure_tips", temp)
end

--刷新数据
function m:refreshData()
    print("refreshData=======")
    --刷新列表
    self.changetarge=false
    self:refreshList()
    --刷新免战时间
    self:refreshTime()
    --刷新精力
    -- self:refreshVP()
end

function m:refreshVP()
    --local vp = Player.Resource.vp
   -- self.txt_count.text = "[00ff00]"..vp.."[-]/"..self.max_vp
end

function m:OnDestroy()
    Events.RemoveListener("refreshData")
    Events.RemoveListener("showMaterial")
end

function m:onClick(go, name)
    print (name)
    if name == "btnBack" then
		UIMrg:pop()
	elseif name == "btn_synthetic" then --合成
        self:onSynthetic()
    elseif name == "btn_indiana" then --一键抢夺
        self:onIndiana()
    elseif name == "btn_smelt" then -- 熔炼
        UIMrg:pushWindow("Prefabs/moduleFabs/indiana/indiana_smelt", {})
    elseif name == "btn_free" then --免战
        UIMrg:pushWindow("Prefabs/moduleFabs/indiana/indiana_free", {delegate = self})
    elseif name == "btn_rule" then --规则
        UIMrg:pushWindow("Prefabs/moduleFabs/qiancengta/qiancengta_rule", {13,title = TextMap.GetValue("Text_1_927")})
    elseif name == "up" then 
        self.scroll:Scroll(-1)
    elseif name == "bottom" then 
        self.scroll:Scroll(1)
    end
end

return m