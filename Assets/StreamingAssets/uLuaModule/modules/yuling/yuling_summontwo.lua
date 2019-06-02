local Reward = require("uLuaModule/modules/summon/uSummonReward.lua")
local RewardTen = require("uLuaModule/modules/summon/uSummonRewardTen.lua")

local summontwo = {}

--字符
local NO_FREE = TextMap.GetValue("Text1425")
local FREE_TIMES = TextMap.GetValue("Text1426")
local FREE_THIS_TIME = TextMap.GetValue("Text1427")
local TXT_FREE = TextMap.GetValue("Text1428")


--每天总共免费次数
local FREE_TIMES_COUNT = 5
local FREE_TIMES_COUNT_H = 5
--高级抽卡循环

local GOLD_DRAW_LOOP = 10

--普通抽卡循环

local MONEY_DRAW_LOOP = 10

--关闭
function summontwo:OnDestroy()
    self.topMenu = LuaMain:ShowTopMenu(1, nil)
end

function summontwo:OnDisable()
    print ("OnDisable")
    self.topMenu = LuaMain:ShowTopMenu(1, nil)
end

function summontwo:updateReward(result)
    local that = self
	local list = RewardMrg.getList(result)
    local _list = {}
    local res_Num = 0
    for i,v in ipairs(list) do
    	if Tool.typeId(v:getType()) then 
    		if v.id =="yuhun" then 
    			res_Num=res_Num+v.rwCount
    		end 
    	else 
    		table.insert( _list, v )
    	end 
    end
    local reward = ClientTool.loadAndGetLuaBinding("Prefabs/moduleFabs/renlingModule/renlingSummon_reward", UIMrg.top)
    reward:CallUpdate({type="yuling" .. self.type, _list = _list, statIndex = 0, cb = function ()
        print("LLLLLLLLLL")
        that:update()
    end}) 
    if res_Num>0 then 
        local resItem = uRes:new("yuhun", res_Num)
    	local ms = {}
    	local g = {}
    	g.type = resItem:getType()
    	g.icon = resItem:getHeadSpriteName()
    	g.text = res_Num
    	g.goodsname = resItem.name
    	g.frame = resItem:getFrame()
    	g.atlasName = packTool:getIconByName(g.icon)
    	table.insert(ms, g)
    	self.binding:CallAfterTime(0.1, function()
    		OperateAlert.getInstance:showGetGoods(ms, UIMrg.top, 0, function()
    			DialogMrg.levelUp()
    			end)
        end)
    end 
    self:activeEvent(false)
    that:update()
end

--单抽
function summontwo:onSummonOne(go, bind)
    local that = self
    self:activeEvent(true)
    local drawId = 0
    if self.type=="Nor" then 
        local freen_nun=Player.Times.xihaofreetime
        if freen_nun>0 then 
            drawId=23
        else 
            drawId=25
        end 
    else
        local freen_nun=Player.Times.yulingfreetime
        if freen_nun>0 then 
            drawId=33
        else 
            drawId=35
        end 
    end 
    Api:yulingDraw(drawId, function(result)
        that:updateReward(result)
    end, function()
        that:activeEvent(false)
        return false
    end)
end

--5连抽
function summontwo:onSummonFive(go, bind)
    local that = self
    self:activeEvent(true)
    local drawId = 0
    if self.type=="Nor" then 
    	drawId=27
    else
    	drawId=37
    end 
    Api:yulingDraw(drawId, function(result)
        that:updateReward(result)
    end, function()
        that:activeEvent(false)
        return false
    end)
end

--50连抽
function summontwo:onSummonFiftieth(go, bind)
    local that = self
    self:activeEvent(true)
    local drawId = 0
    if self.type=="Nor" then 
    	drawId=28
    else
    	drawId=38
    end 
    Api:yulingDraw(drawId, function(result)
    	that:updateReward(result)
    end, function()
        that:activeEvent(false)
        return false
    end)
end

function summontwo:activeEvent(ret)
    if ret == false then
        local that = self
        self.binding:CallAfterTime(0.1, function()
            that.eventMake:SetActive(false)
        end)
    else
        self.eventMake:SetActive(true)
    end
end

function summontwo:onUpdate()
    self:update()
end

function summontwo:onClick(go, name)
    print(name)
    if name == "btnNorSummon" then
        self:onSummonOne(go)
    elseif name == "btnNorSummonFive" then
        self:onSummonFive(go)
    elseif name == "btnNorSummonFiftieth" then
        self:onSummonFiftieth(go)
    elseif name == "btnBack" then
        Events.Brocast('update_summon_date')
        UIMrg:pop()
    end
end

--初始化
function summontwo:create(binding)
    self.binding = binding
    self.gameObject = self.binding.gameObject
    return self
end

function summontwo:onEnter()
    print("update__onEnter")
    self:update()
end

function summontwo:OnEnable()
    print("OnEnable")
    self:update()
end

local isStart = true
local currt_pos = 0
local target_pos = 0
local fangxiang ="Left"
function summontwo:Scorllupdate()
    local chars = {}
    local charsList = {}
    local hasChar = {}
    local index = 1

     TableReader:ForEachLuaTable("drawShow", function(index, item)
        if self.type == "Nor" then
            if item.type==25 then
                table.insert(chars, item)
            end
        elseif self.type == "Hight" then
            if item.type==35 then
                table.insert(chars, item)
            end
        end
        return false
    end)

    for k, v in pairs(chars) do
        local cell = v.showchar[0]
        local char = RewardMrg.getDropItem({type=cell.type,arg=cell.showchar,arg1=1})
        char.des=v.desc
        charsList[index] = char
        hasChar[char.id] = true
        index = index + 1
    end
    
    for i=1, index-1 do
        local randNum = math.random(1, index-2)
        charsList[i],charsList[randNum]=charsList[randNum],charsList[i]
    end

    local list = charsList
    local count = index-1
    
    for i=1,20 do
        for m =1,count do
            table.insert(charsList, list[m])
            index = index + 1
        end
    end
    self.scrollView.gameObject:SetActive(true)
    self.view.gameObject:SetActive(true)
    self.scrollView:refresh(charsList, self, false,0)
    currt_pos = self.trans.transform.localPosition.x
    target_pos = currt_pos-(index-2)*500
    fangxiang ="Left"
    isStart=false

end


function summontwo:update(data)
    if data ~= nil then
        self.type=data._choukaType
        self:Scorllupdate()
        self:myStart()
    end
    LuaMain:ShowTopMenu(6,nil,{[1]={ type="yuhun"},[2]={ type="money"},[3]={ type="gold"}})
    local name = TableReader:TableRowByUnique("resourceDefine", "name","yuhun").cnName
    local resNum = Tool.getCountByType("yuhun")
    self.name1.text=name .. "：" .. toolFun.moneyNumberShowOne(math.floor(tonumber(resNum)))
    name = TableReader:TableRowByUnique("resourceDefine", "name","haogandu").cnName
    resNum = Tool.getCountByType("haogandu")
    self.name2.text=name .. "：" .. toolFun.moneyNumberShowOne(math.floor(tonumber(resNum)))
    name = TableReader:TableRowByUnique("resourceDefine", "name","max_haogandu").cnName
    resNum = Tool.getCountByType("max_haogandu")
    self.name3.text=name .. "：" .. toolFun.moneyNumberShowOne(math.floor(tonumber(resNum)))
    local drawId = 0
    local draw_freen = 0
    if self.type=="Nor" then 
    	drawId=25
        draw_freen=Player.Times.xihaofreetime
    else
    	drawId=35
        draw_freen=Player.Times.yulingfreetime
    end 
    local i = 0
    local consume=TableReader:TableRowByID("draw", drawId).consume[i]
    self.consume_money=consume
    local ziyuan=0
    if consume.consume_type=="gold" or consume.consume_type=="money" then 
        ziyuan=Tool.getCountByType(consume.consume_type)
    elseif consume.consume_type=="item" then 
        ziyuan=Player.ItemBagIndex[consume.consume_arg].count
    end
    local ziyuanTxt=toolFun.moneyNumberShowOne(math.floor(tonumber(ziyuan)))
    if draw_freen>0 then 
    	self.txt_jiage1.gameObject:SetActive(true)
    	self.icon_money1.gameObject:SetActive(false)
    else 
    	self.txt_jiage1.gameObject:SetActive(false)
    	self.icon_money1.gameObject:SetActive(true)
    	if self.cost_money<=ziyuan then 
            self.money1.text ="[ffffff]" .. ziyuanTxt .. "/" .. self.cost_money .."[-]"
        else 
            self.money1.text ="[ff0000]" .. ziyuanTxt .. "/" .. self.cost_money .."[-]"
        end
    end
    self.txt_jiage2.gameObject:SetActive(false)
    self.icon_money2.gameObject:SetActive(true)
    if self.cost_money_five<=ziyuan then 
        self.money2.text ="[ffffff]" .. ziyuanTxt .. "/" .. self.cost_money_five .."[-]"
    else 
        self.money2.text ="[ff0000]" .. ziyuanTxt .. "/" .. self.cost_money_five .."[-]"
    end  
    if self .type=="Nor" then 
	    if self.cost_money_fiftieth <= ziyuan then 
	        self.money3.text ="[ffffff]" .. ziyuanTxt .. "/" .. self.cost_money_fiftieth .."[-]"
	    else 
	        self.money3.text ="[ff0000]" .. ziyuanTxt .. "/" .. self.cost_money_fiftieth .."[-]"
	    end
	else 
		self.moeny2.transform.localPosition=self.moeny3.transform.localPosition
		self.btnNorSummonFive.transform.localPosition=self.btnNorSummonFiftieth.transform.localPosition
		self.moeny3:SetActive(false)
		self.btnNorSummonFiftieth.gameObject:SetActive(false)
	end 
    --抽多少次必得xx
    if self.type == "Nor" then
        local count = Player.Times.totalXihaoDraw +1
        if count==0 then count =count+1 end
        local num = count % MONEY_DRAW_LOOP
        if num == 0 then
         --必得橙卡
            self.msg.text = TextMap.GetValue("Text_1_3010")
        else
          --多少次后得橙卡
            self.msg.text =TextMap.GetValue("Text_1_2793") .. MONEY_DRAW_LOOP - num .. TextMap.GetValue("Text_1_3011")
        end
    else 
        local count = Player.Times.totalYulingDraw+1
        if count==0 then count =count+1 end
        local num = count % GOLD_DRAW_LOOP
        if num == 0 then
            --必得橙卡
            self.msg.text = TextMap.GetValue("Text_1_3008")
        else
           --多少次后得橙卡
           if num == 0 then num = 1 end
           self.msg.text = TextMap.GetValue("Text_1_2793") .. GOLD_DRAW_LOOP - num .. TextMap.GetValue("Text_1_3009")
        end
    end
    self:activeEvent(false)
    self.topMenu = LuaMain:ShowTopMenu(4, nil)
end

function summontwo:myStart()
    self.time = 0
    local i = 0
    local drawId = 0
    local drawId_five = 0
    local drawId_fiftieth = 0
    if self.type=="Nor" then 
    	Tool.loadTopTitle(self.gameObject, TextMap.GetValue("Text_1_3012"))
    	drawId=25
        drawId_five=27
        drawId_fiftieth=28
    else
    	Tool.loadTopTitle(self.gameObject, TextMap.GetValue("Text_1_3013"))
    	drawId=35
        drawId_five=37
        drawId_fiftieth=38
    end 
    self.cost_money = TableReader:TableRowByID("draw", drawId).consume[i].consume_arg
    self.cost_money_five = TableReader:TableRowByID("draw", drawId_five).consume[i].consume_arg
    self.cost_money_fiftieth = TableReader:TableRowByID("draw", drawId_fiftieth).consume[i].consume_arg
    local consume=TableReader:TableRowByID("draw", drawId).consume[i]
    local iconName=""
    if consume.consume_type=="gold" or consume.consume_type=="money" then 
        iconName = Tool.getResIcon(consume.consume_type)
    elseif consume.consume_type=="item" then 
        item = TableReader:TableRowByID("item", consume.consume_arg)
        iconName=item.iconid
    end 
    self.icon_money1.Url=UrlManager.GetImagesPath("itemImage/" .. iconName.. ".png")
    self.icon_money2.Url=UrlManager.GetImagesPath("itemImage/" .. iconName.. ".png")
    self.icon_money3.Url=UrlManager.GetImagesPath("itemImage/" .. iconName.. ".png")
    self.cost_money_icon=iconName
    local row = TableReader:TableRowByID("drawSetting", 23)
    if row then
        FREE_TIMES_COUNT = row.arg2
    end
    local row = TableReader:TableRowByID("drawSetting", 24)
    if row then
        FREE_TIMES_COUNT_H = row.arg2
    end
    row = TableReader:TableRowByID("drawSetting", 22)
    if row then
        GOLD_DRAW_LOOP = row.arg1
    end
    row = TableReader:TableRowByID("drawSetting", 21)
    if row then
        MONEY_DRAW_LOOP = row.arg1
    end
end

return summontwo
