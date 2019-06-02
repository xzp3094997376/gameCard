local m = {} 

function m:Start()
	Tool.loadTopTitle(self.gameObject, TextMap.GetValue("Text_1_2999"))
	self.canClick=true
    local consume1=TableReader:TableRowByID("draw",25).consume[0]
    if consume1.consume_type=="gold" or consume1.consume_type=="money" then 
        self.cost_gold = TableReader:TableRowByID("draw", 25).consume[0].consume_arg
        self.cost_gold_five = TableReader:TableRowByID("draw",35).consume[0].consume_arg
        local iconName1 = Tool.getResIcon(consume1.consume_type)
        self.img1.Url=UrlManager.GetImagesPath("itemImage/" .. iconName1.. ".png")
        self.img2.Url=UrlManager.GetImagesPath("itemImage/" .. iconName1.. ".png")
        self.cost_gold_icon=iconName1
    elseif consume1.consume_type=="item" then 
        self.cost_gold = TableReader:TableRowByID("draw", 25).consume[0].consume_arg2
        self.cost_gold_five = TableReader:TableRowByID("draw", 35).consume[0].consume_arg2
        local item1 = TableReader:TableRowByID("item", consume1.consume_arg)
        self.img1.Url=UrlManager.GetImagesPath("itemImage/" .. item1.iconid.. ".png")
        self.img2.Url=UrlManager.GetImagesPath("itemImage/" .. item1.iconid .. ".png")
        self.cost_gold_icon=item1.iconid
    end
	m:update()
end

function m:update()
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
    local consume1=TableReader:TableRowByID("draw",25).consume[0]
    local ziyuan=0
    if consume1.consume_type=="gold" or consume1.consume_type=="money" then 
        ziyuan=Tool.getCountByType(consume1.consume_type)
    elseif consume1.consume_type=="item" then 
        ziyuan=Player.ItemBagIndex[consume1.consume_arg].count
    end
    if self.cost_gold<=ziyuan then 
        self.num1.text ="[ffff96]" .. self.cost_gold .."[-]"
    else 
        self.num1.text ="[ff0000]" .. self.cost_gold .."[-]"
    end
    if self.cost_gold_five<=ziyuan then 
        self.num2.text ="[ffff96]" .. self.cost_gold_five .."[-]"
    else 
        self.num2.text ="[ff0000]" .. self.cost_gold_five .."[-]"
    end
    local freen_nun=Player.Times.xihaofreetime
	if freen_nun<=0 then 
		self.img1.gameObject:SetActive(true)
        self.txt_left.text=""
        self.redPoint1:SetActive(false)
	else 
        self.redPoint1:SetActive(true)
		self.img1.gameObject:SetActive(false)
		self.txt_left.text=string.gsub(TextMap.GetValue("LocalKey_697"),"{0}",freen_nun)
	end
    local freen_nun2=Player.Times.yulingfreetime
    if freen_nun2<=0 then 
        self.img2.gameObject:SetActive(true)
        self.txt_right.text=""
        self.redPoint2:SetActive(false)
    else 
        self.redPoint2:SetActive(true)
        self.img2.gameObject:SetActive(false)
        self.txt_right.text=string.gsub(TextMap.GetValue("LocalKey_697"),"{0}",freen_nun2)
    end
end

function m:onEnter()
    m:update()
end

function m:onClick(go, name)
    print(name)
    if self.canClick then 
	    if name == "btn_renzhe" then
	        local temp = {}
            temp._choukaType = "Nor"
            Tool.push("summontwo", "Prefabs/moduleFabs/yuling/yuling_summontwo", temp)  
	    elseif name == "btn_shenren" then
	        local temp = {}
            temp._choukaType = "Hight"
            Tool.push("summontwo", "Prefabs/moduleFabs/yuling/yuling_summontwo", temp)   
	    elseif name == "btn_shop" then
	        uSuperLink.openModule(16)
	    end
	end 
end

return m