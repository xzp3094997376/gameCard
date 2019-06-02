local m = {} 

function m:Start()
	Tool.loadTopTitle(self.gameObject, TextMap.GetValue("Text_1_2974"))
	local iconName = TableReader:TableRowByUnique("resourceDefine", "name","lingyu").img
    self.pic_res1.Url=UrlManager.GetImagesPath("itemImage/"..iconName..".png")
    iconName = TableReader:TableRowByUnique("resourceDefine", "name","renlingzhi").img
    self.pic_res2.Url=UrlManager.GetImagesPath("itemImage/"..iconName..".png")
    iconName = TableReader:TableRowByUnique("resourceDefine", "name","duihuan").img
    self.pic_res3.Url=UrlManager.GetImagesPath("itemImage/"..iconName..".png")
    local name = TableReader:TableRowByUnique("resourceDefine", "name","lingyu").cnName
    self.name1.text=name .. "："
    name = TableReader:TableRowByUnique("resourceDefine", "name","renlingzhi").cnName
    self.name2.text=name .. "："
    name = TableReader:TableRowByUnique("resourceDefine", "name","duihuan").cnName
    self.name3.text=name .. "："
	self.canClick=true
	m:update()
end

function m:update()
    LuaMain:ShowTopMenu(6,nil,{[1]={ type="lingyu"},[2]={ type="money"},[3]={ type="gold"}})
	local resNum = Tool.getCountByType("lingyu")
    self.num1.text=toolFun.moneyNumberShowOne(math.floor(tonumber(resNum)))
    resNum = Tool.getCountByType("renlingzhi")
    self.num2.text=toolFun.moneyNumberShowOne(math.floor(tonumber(resNum)))
    resNum = Tool.getCountByType("duihuan")
    self.num3.text=toolFun.moneyNumberShowOne(math.floor(tonumber(resNum)))
    local chartNum_active =m:getChartNum()
    self.chartnum.text=TextMap.GetValue("Text_1_2967") .. chartNum_active
	--抽多少次必得xx
	local row = TableReader:TableRowByID("drawSetting", 19)
    local count = Player.Times.totalRenlingDraw  + 1
    local num = count % tonumber(row.arg1)
    if num == 0 then
        self.desc.text = TextMap.GetValue("Text_1_2975")
    else
        if num == 0 then num = 1 end
        self.desc.text = TextMap.GetValue("Text_1_2793") .. (tonumber(row.arg1) - num+1) .. TextMap.GetValue("Text_1_2976")
    end
	local consume1=TableReader:TableRowByID("draw",11).consume[0]
	local ziyuan=0
    if consume1.consume_type=="gold" or consume1.consume_type=="money" then 
        self.cost_gold = TableReader:TableRowByID("draw", 11).consume[0].consume_arg
        self.cost_gold_five = TableReader:TableRowByID("draw",15).consume[0].consume_arg
        local iconName1 = Tool.getResIcon(consume1.consume_type)
        self.img1.Url=UrlManager.GetImagesPath("itemImage/" .. iconName1.. ".png")
        self.img2.Url=UrlManager.GetImagesPath("itemImage/" .. iconName1.. ".png")
        self.cost_gold_icon=iconName1
        ziyuan=Tool.getCountByType(consume1.consume_type)
    elseif consume1.consume_type=="item" then 
        self.cost_gold = TableReader:TableRowByID("draw", 11).consume[0].consume_arg2
        self.cost_gold_five = TableReader:TableRowByID("draw", 15).consume[0].consume_arg2
        local item1 = TableReader:TableRowByID("item", consume1.consume_arg)
        self.img1.Url=UrlManager.GetImagesPath("itemImage/" .. item1.iconid.. ".png")
        self.img2.Url=UrlManager.GetImagesPath("itemImage/" .. item1.iconid .. ".png")
        self.cost_gold_icon=item1.iconid
        ziyuan=Player.ItemBagIndex[consume1.consume_arg].count
    end
    if self.cost_gold<=ziyuan then 
        self.money1.text ="[ffff96]" .. self.cost_gold .."[-]"
    else 
        self.money1.text ="[ff0000]" .. self.cost_gold .."[-]"
    end
    if self.cost_gold_five<=ziyuan then 
        self.money2.text ="[ffff96]" .. self.cost_gold_five .."[-]"
    else 
        self.money2.text ="[ff0000]" .. self.cost_gold_five .."[-]"
    end
    local freen_nun=Player.Times.renlingfreetime 
	if freen_nun<=0 then 
		self.btn_name.text=TextMap.GetValue("Text_1_2978")
		self.img1.gameObject:SetActive(true)
	else 
		self.btn_name.text=TextMap.GetValue("LocalKey_209")
		self.img1.gameObject:SetActive(false)
	end
    self.chart_red:SetActive(Tool.getAllRenlingChapterRed())
end

function m:getChartNum()
    LuaMain:ShowTopMenu(6,nil,{[1]={ type="lingyu"},[2]={ type="money"},[3]={ type="gold"}})
    local num =0 
    TableReader:ForEachLuaTable("renling_tujian", function(index, _item)
        if Player.renling[_item.group]~=nil and Player.renling[_item.group].totolcnt~=nil then 
            num=num+tonumber(Player.renling[_item.group].totolcnt)
        end 
        return false
        end)
    return num
end

function m:updateReward_renling(result)
    local that = self
    local list = RewardMrg.getList(result)
    local _list = {}
    local res_Num = 0
    for i,v in ipairs(list) do
        if Tool.typeId(v:getType()) then 
            if v.id =="duihuan" then 
                res_Num=res_Num+v.rwCount
            end 
        else 
            table.insert( _list, v )
        end 
    end
    local reward = ClientTool.loadAndGetLuaBinding("Prefabs/moduleFabs/renlingModule/renlingSummon_reward", UIMrg.top)
    reward:CallUpdate({type = "renling" , _list = _list, statIndex = 0, cb = function ()
        that:update()
    end})
    local resItem = uRes:new("duihuan", res_Num)
    local ms = {}
    local g = {}
    g.type = resItem:getType()
    g.icon = resItem:getHeadSpriteName()
    g.text = res_Num
    g.goodsname = resItem.name
    g.frame = resItem:getFrame()
    g.atlasName = packTool:getIconByName(g.icon)
    table.insert(ms, g)
    reward:CallAfterTime(0.1, function()
        OperateAlert.getInstance:showGetGoods(ms, UIMrg.top, 0, function()
            DialogMrg.levelUp()
            end)
    end)
    self.canClick=true
end

--普通单抽
function m:onNorSummon(go, bind)
    local that = self
    self.canClick=false
    local freen_nun=Player.Times.renlingfreetime 
    local drawId = 0
    if freen_nun<=0 then 
    	drawId=11
    else 
    	drawId=13
    end 
    Api:renlingDraw(drawId, function(result)
        m:updateReward_renling(result)
    end, function()
        self.canClick=true
        return false
    end)
end

--五连抽
function m:onFiveSummon(go, bind)
    local that = self
    self.canClick=false
    local drawId = 15
    Api:renlingDraw(drawId, function(result)
        m:updateReward_renling(result)
    end, function()
        self.canClick=true
        return false
    end)
end

function m:onEnter()
    m:update()
end

function m:onClick(go, name)
    print(name)
    if self.canClick then 
	    if name == "btn_one" then
	        self:onNorSummon(go)
	    elseif name == "btn_five" then
	        self:onFiveSummon(go)
	    elseif name == "shop_btn" then
	        uSuperLink.openModule(20)
	    elseif name == "knapsack_btn" then
	        Tool.push("renling", "Prefabs/moduleFabs/renlingModule/newpack_renling")
	    elseif name == "chart_btn" then
	    	Tool.push("renling", "Prefabs/moduleFabs/renlingModule/arrayChart_one")
	    end
	end 
end

return m