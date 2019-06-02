local m = {}

function m:update(data)
    self.type=data.type
	self.list = data._list
	self.statIndex = data.statIndex
	self.cb = data.cb
    self.canClick=false
    self.button:SetActive(false)
    if self.type == "renling" then 
        m:updateBtnState()
    else 
        m:updateBtnStateYuling()
    end 
	m:showRewardBox(self.list, self.statIndex, self.cb)
end

function m:updateBtnStateYuling()
    local drawId = 0
    local draw_freen = 0
    local drawId_five = 0
    local drawId_fiftieth = 0
    if self.type=="yulingNor" then 
        drawId=25
        drawId_five=27
        drawId_fiftieth=28
        draw_freen=Player.Times.xihaofreetime
    else
        drawId=35
        drawId_five=37
        drawId_fiftieth=38
        draw_freen=Player.Times.yulingfreetime
    end 
    self.cost_gold = TableReader:TableRowByID("draw", drawId).consume[i].consume_arg
    self.cost_gold_five = TableReader:TableRowByID("draw", drawId_five).consume[i].consume_arg
    self.cost_gold_fiftieth = TableReader:TableRowByID("draw", drawId_fiftieth).consume[i].consume_arg
    local consume=TableReader:TableRowByID("draw", drawId).consume[i]
    local iconName=""
    if consume.consume_type=="gold" or consume.consume_type=="money" then 
        iconName = Tool.getResIcon(consume.consume_type)
        ziyuan=Tool.getCountByType(consume.consume_type)
    elseif consume.consume_type=="item" then 
        item = TableReader:TableRowByID("item", consume.consume_arg)
        iconName=item.iconid
        ziyuan=Player.ItemBagIndex[consume.consume_arg].count
    end 
    self.img1.Url=UrlManager.GetImagesPath("itemImage/" .. iconName.. ".png")
    self.img2.Url=UrlManager.GetImagesPath("itemImage/" .. iconName.. ".png")
    self.img3.Url=UrlManager.GetImagesPath("itemImage/" .. iconName.. ".png")
    self.cost_money_icon=iconName
    local ziyuanTxt=toolFun.moneyNumberShowOne(math.floor(tonumber(ziyuan)))
    if draw_freen<=0 then 
        self.btn_name.text=TextMap.GetValue("LocalKey_214")
        self.img1.gameObject:SetActive(true)
        if self.cost_gold<=ziyuan then 
            self.money1.text ="[ffffff]" .. ziyuanTxt .. "/" .. self.cost_gold .."[-]"
        else 
            self.money1.text ="[ff0000]" .. ziyuanTxt .. "/" .. self.cost_gold .."[-]"
        end
    else 
        self.btn_name.text=TextMap.GetValue("LocalKey_209")
        self.img1.gameObject:SetActive(false)
    end
    if self.cost_gold_five<=ziyuan then 
        self.money2.text ="[ffffff]" .. ziyuanTxt .. "/" .. self.cost_gold_five .."[-]"
    else 
        self.money2.text ="[ff0000]" .. ziyuanTxt .. "/" .. self.cost_gold_five .."[-]"
    end
    if self.type=="yulingNor" then 
        if self.cost_gold_fiftieth<=ziyuan then 
            self.money3.text ="[ffffff]" .. ziyuanTxt .. "/" .. self.cost_gold_fiftieth .."[-]"
        else 
            self.money3.text ="[ff0000]" .. ziyuanTxt .. "/" .. self.cost_gold_fiftieth .."[-]"
        end
    else 
        self.btn_five.transform.localPosition=self.btn_iftieth.transform.localPosition
        self.btn_iftieth.gameObject:SetActive(false)
    end 
    --抽多少次必得xx
    if self.type == "yulingNor" then
        local count = Player.Times.totalXihaoDraw +1
        local row = TableReader:TableRowByID("drawSetting", 21)
        local num = count % tonumber(row.arg1)
        if num == 0 then
         --必得橙卡
            self.desc.text = TextMap.GetValue("Text_1_3010")
        else
          --多少次后得橙卡
            if num == 0 then num = 1 end
            self.desc.text =TextMap.GetValue("Text_1_2793") .. tonumber(row.arg1) - num .. TextMap.GetValue("Text_1_3011")
        end
    else 
        local count = Player.Times.totalYulingDraw +1
        local row = TableReader:TableRowByID("drawSetting", 22)
        local num = count % tonumber(row.arg1)
        if num == 0 then
            --必得橙卡
            self.desc.text = TextMap.GetValue("Text_1_3008")
        else
           --多少次后得橙卡
           if num == 0 then num = 1 end
           self.desc.text = TextMap.GetValue("Text_1_2793") .. tonumber(row.arg1) - num .. TextMap.GetValue("Text_1_3009")
        end
    end
end

function m:updateBtnState()
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
		self.btn_name.text=TextMap.GetValue("LocalKey_214")
		self.img1.gameObject:SetActive(true)
	else 
		self.btn_name.text=TextMap.GetValue("LocalKey_209")
		self.img1.gameObject:SetActive(false)
	end
    self.btn_five.transform.localPosition=self.btn_iftieth.transform.localPosition
    self.btn_iftieth.gameObject:SetActive(false)
end

function m:showRewardBox(_list, statIndex, cb)
	if _list == nil then return end
    if #_list == 0 then return end 
    local list = {}
    if #_list>5 then 
        for k,v in pairs(_list) do
            local iscontain = false
            for m,n in pairs(list) do
                if n:getType()==v:getType() and n.id ==v.id then 
                    iscontain=true 
                    n.Count=n.Count+v.rwCount
                end 
            end
            if iscontain ==false then
                local _item = v
                v.Count=v.rwCount
                table.insert(list,v)
            end 
        end
    else 
        list=_list
    end 
    MusicManager.playByID(43)
    local grid = self.Grid--Baoxiang_prefab.transform:FindChild("Grid"):GetComponent(UIGrid)
    local mParent = grid.transform
    local goodsManager = self.Sprite--Baoxiang_prefab.transform:FindChild("Sprite"):GetComponent(DestroyObject)
    if cb then
        goodsManager:setCallBack(function ()
            cb()
            GameObject.Destroy(self.gameObject)
        end)
    end

    local gos = {}
    local effects = {}
    local items = {}
    local charList = {}
    local findIndex = 0
    local itemIndex = 0
    for i = 1, #list do
        local it = list[i]
        if it:getType() == "char" then
            table.insert(charList, it)
            if findIndex == 0 then
                findIndex = i
            end
        elseif itemIndex == 0 then
            itemIndex = i
        end
    end
    if findIndex == 1 and itemIndex > 1 then
        list[findIndex], list[itemIndex] = list[itemIndex], list[findIndex]
    end
    if #list ==1 then 
        grid.transform.localPosition = Vector3(75,-150,0)
    elseif #list <=5 then 
        grid.transform.localPosition = Vector3(0,-50,0)
    else 
        grid.enabled=true 
        grid:Reposition()
        grid.transform.localPosition = Vector3(380,-130,0)
    end 
    self.binding:CallAfterTime(0.01, function()
        for i = 1, #list do
            local temp = grid.transform:FindChild("node".. i).gameObject
            local mTran = temp.transform
            local item = ClientTool.loadAndGetLuaBindingFromPool("Prefabs/publicPrefabs/itemAll", self.gameObject)
            local effect = temp.transform:GetChild(0)
            local lab = mTran:Find("tx_name")
            lab.parent = item.transform
			--lab.fontSize = 22
            lab.localPosition = Vector3(0, -75, 0)
            --lab.localScale = Vector3(1.4, 1.4, 1.4)
            lab = lab:GetComponent(UILabel)
            lab.text = list[i]:getDisplayColorName()
            effect.parent = item.transform
            effect.localPosition = Vector3(0, 0, 0)
            effect.localScale = Vector3(1.4, 1.4, 1.4)
            table.insert(effects, effect.gameObject)
            item.gameObject:SetActive(false)
			
            item:CallUpdate({ "char", list[i], 100, 100,nil,nil,nil,nil,false })
            if list[i].Count~=nil and list[i].Count>1 then 
                item:CallTargetFunctionWithLuaTable("ShowNum", list[i].Count)
            end 
            item.transform.localPosition = Vector3(0, 0, 0);
            table.insert(gos, mTran)
            table.insert(items, item.gameObject)
        end
    end)

    self.binding:CallAfterTime(0.2, function()
        local index = 1
        local function show()
            self.gameObject:SetActive(true)
            local len = #items
            if len < index then
                goodsManager.isClick = true
                self.canClick=true
                self.button:SetActive(true)
                return
            end
            local tempItem = items[index]
            local item = items[index]
            item:SetActive(true)
            item.transform.parent = gos[index]
            local ts = TweenPosition.Begin(item, 0.4, Vector3.zero)
            effects[index]:SetActive(true)
            local rot = Quaternion(0, 0, 0, -1)
            local r = item:AddComponent(TweenRotation)

            r.duration = 0.4
            r.to = Vector3(0, 0, 360)
            if list[index]:getType() == "char" and list[index].Table.show_special==1 then
                ts:SetOnFinished(function()
                    self.binding:CallAfterTime(0.2, function()
                        --packTool:showChar({ list[index] }, show)
                        local luaTable = {
                            char = list[index],
                            auto = true,
                            cb = function()
                                UIMrg:popWindow()
                                show()
                            end
                        }
                        print("显示第" .. index .. TextMap.GetValue("Text_1_920"))
                        UIMrg:pushWindow("Prefabs/moduleFabs/choukaModule/RewardChar", luaTable)
                        self.binding:CallAfterTime(0.1, function()
                            self.gameObject:SetActive(false)
                        end)
                        index = index + 1
                    end)
                end)
            else
                ts:SetOnFinished(function()
                    index = index + 1
                    show()
                end)
            end
        end

        if #charList > 0 then
            show()
        else
            local len = #items
            for i = 1, len do
                local item = items[i]
                item:SetActive(true);
                item.transform.parent = gos[i]
                local ts = TweenPosition.Begin(item, 0.4, Vector3.zero)
                effects[i]:SetActive(true)
                local rot = Quaternion(0, 0, 0, -1)
                local r = item:AddComponent(TweenRotation)
                if i == len then
                    ts:SetOnFinished(function()
                        goodsManager.isClick = true
                        self.canClick=true
                        self.button:SetActive(true)
                        return
                    end)
                end
                r.duration = 0.4
                r.to = Vector3(0, 0, 360)
            end
        end
    end)
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

function m:updateList(list)
    local _list = {}
    for k,v in pairs(table_name) do
        print(k,v)
    end
end

function m:updateReward_renling(result)
    local that = self
    local list = RewardMrg.getList(result)
    if #list==0 then return end 
    local _list = {}
    local res_Num = 0
    local res_type = ""
    if self.type=="renling" then 
        res_type="duihuan"
    else 
        res_type="yuhun"
    end
    for i,v in ipairs(list) do
        if Tool.typeId(v:getType()) then 
            if v.id ==res_type then 
                res_Num=res_Num+v.rwCount
            end 
        else 
            table.insert( _list, v )
        end 
    end
    GameObject.Destroy(self.gameObject)
    local reward = ClientTool.loadAndGetLuaBinding("Prefabs/moduleFabs/renlingModule/renlingSummon_reward", UIMrg.top)
    reward:CallUpdate({type = self.type , _list = _list, statIndex = 0, cb = self.cb})
    if res_Num > 0 then 
        local resItem = uRes:new(res_type, res_Num)
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
    end 
    that:updateBtnState()
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

--单抽
function m:onSummonOne(go, bind)
    local that = self
    self.canClick=false
    local drawId = 0
    if self.type=="yulingNor" then 
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
        that:updateReward_renling(result)
    end, function()
        self.canClick=true
        return false
    end)
end

--5连抽
function m:onSummonFive(go, bind)
    local that = self
    self.canClick=false
    local drawId = 0
    if self.type=="yulingNor" then 
        drawId=27
    else
        drawId=37
    end 
    Api:yulingDraw(drawId, function(result)
        that:updateReward_renling(result)
    end, function()
        self.canClick=true
        return false
    end)
end

--50连抽
function m:onSummonFiftieth(go, bind)
    local that = self
    self.canClick=false
    local drawId = 0
    if self.type=="yulingNor" then 
        drawId=28
    else
        drawId=38
    end 
    Api:yulingDraw(drawId, function(result)
        that:updateReward_renling(result)
    end, function()
        self.canClick=true
        return false
    end)
end

function m:onClick(go, name)
    if self.canClick==true then 
        if name == "btn_one" then
            if self.type=="renling" then 
                self:onNorSummon(go)
            else 
                self:onSummonOne(go)
            end 
        elseif name == "btn_five" then
            if self.type=="renling" then 
                self:onFiveSummon(go)
            else 
                self:onSummonFive(go)
            end 
        elseif name=="btn_iftieth" then 
            self:onSummonFiftieth()
        end 
    end 
end

return m