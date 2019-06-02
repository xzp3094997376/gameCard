local actList = {}

function actList:create(...)
    return self
end

-- function actList:OnDestroy( ... )
--     actFont = nil
-- end


function actList:Start(...)
    LuaMain:ShowTopMenu(6,nil,{[1]={ type="crystal"},[2]={ type="c_gold"},[3]={ type="money"},[4]={ type="gold"}})
    self._title=Tool.loadTopTitle(self.gameObject, "VIP",function ()
        LuaMain:ShowTopMenu(1)
        Api:checkUpdate(function()end)
        Tool.updateActivityOpen()
        UIMrg:pop()
    end)
    self:init()
    self.oldVip = Player.Info.vip
    self.vipLevel = {}
	TableReader:ForEachLuaTable("vipLevel", function(index, item) --shopPurchase
		self.vipLevel[item.id] = item
		return false
		end)
	self:updateVipData()
	self:setGiftData()
	self.indexTq = Player.Info.vip
	self:refreshGift(Player.Info.vip)
    self.binding:CallManyFrame(function()
        self:getActivityData()
    end, 1)
    self:refreshDataWhenVip()
    self.select1:SetActive(true)
    self.select2:SetActive(false)
    self.select3:SetActive(false)
end

function actList:refreshDataWhenVip( ... )
    Player.Resource:addListener("vipMenucurrency", "vip_exp", function(key, attr, newValue)
        print("refresh")
        self.delegate:refreshEveryPay()
        Player:removeListener("vipMenucurrency")
    end)
end


function actList:OnDisable()
    Player:removeListener("vipMenucurrency")
end

function actList:onClick(go, name)
	print(name)
	if name == "btTequan" then 
		UIMrg:pop()
        LuaMain:ShowTopMenu(1)
		Tool.push("activity", "Prefabs/moduleFabs/activityModule/activity_gradeGift",{"","recharge"})
	elseif name == "btn_fuli1" then
        self.tap=1
		self.select1:SetActive(true)
	    self.select2:SetActive(false)
	    self.select3:SetActive(false)
	    self.BlockVip:SetActive(true)
        self.tip.gameObject:SetActive(false)
	    self.gifttable.gameObject:SetActive(false)
	    self.fulitable.gameObject:SetActive(false)
	    self.hero.gameObject:SetActive(false)
	elseif name == "btn_fuli2" then
        self.tap=2
		self.select1:SetActive(false)
	    self.select2:SetActive(true)
	    self.select3:SetActive(false)
	    self.BlockVip:SetActive(false)
        self.tip.gameObject:SetActive(true)
	    self.gifttable.gameObject:SetActive(false)
	    self.fulitable.gameObject:SetActive(true)
	    if self.isUpdate_fuli==false then 
		    self.fulitable:refresh(self.extra_item, self, true, 0)
		    self.binding:CallAfterTime(0.1,function()
		        self.fulitable:goToIndex(self.fuliIndex)
		        self.isUpdate_fuli=true
		    end)
		end 
	    self.hero.gameObject:SetActive(true)
	elseif name == "btn_fuli3" then
        self.tap=3
		self.select1:SetActive(false)
	    self.select2:SetActive(false)
	    self.select3:SetActive(true)
	    self.BlockVip:SetActive(false)
        self.tip.gameObject:SetActive(true)
	    self.gifttable.gameObject:SetActive(true)
	    if self.isUpdate_gift==false then 
		    self.gifttable:refresh(self.list, self, true, 0)
		    self.binding:CallAfterTime(0.1,function()
		        self.gifttable:goToIndex(self.giftindex)
		        self.isUpdate_gift=true
		    end) 
		end 
	    self.fulitable.gameObject:SetActive(false)
	    self.hero.gameObject:SetActive(true)
	elseif name == "btNext" then
		self:onNext()
	elseif name == "btBuy" then
		self:buyGift()
	elseif name == "btPrev" then
		self:onPrev()
	end
end

function actList:getScrollView()  
    if self.tp ==1 then     
        return self.view
    elseif self.tp ==2 then     
        return self.view_fuli
    else 
        return self.view_gift
    end      
end

function actList:buyGift()
	if Player.Info.vip >=self.indexTq then
		if Tool:judgeBagCount(self.dropTypeList) == false or Tool.vipGift(self.indexTq)==nil or Tool.vipGift(self.indexTq).consume==nil or Tool.vipGift(self.indexTq).consume[0]==nil then 
			return 
		end
		if Tool.vipGift(self.indexTq).consume[0].consume_arg <=Player.Resource.gold then 
			Api:buyVipPackage(Tool.vipGift(self.indexTq).id,function(result)
				if result.ret == 0 then
	                packTool:showMsg(result, nil, 2)
					self:refreshGift(self.indexTq)
				end
			end)
		else 
            DialogMrg.ShowDialog(TextMap.GetValue("Text368"), function()
                DialogMrg.chognzhi()
                end)
		end
	else
        DialogMrg.ShowDialog(TextMap.GetValue("Text408"), function()
            DialogMrg.chognzhi()
            end)
	end
end

function actList:onPrev()
	if Tool.vipGift(self.indexTq - 1) ~=nil then 
		self.indexTq = self.indexTq - 1
		self:refreshGift(self.indexTq)
	end
end

function actList:onNext()
    if Tool.vipGift(self.indexTq + 1) ~=nil then 
		self.indexTq = self.indexTq + 1
		self:refreshGift(self.indexTq)
	end
end

function actList:setGiftData()
	self.vipPkg = Player.Vippkg
end

function actList:refreshGift(index)
    if Tool.vipGift(index)==nil then
        local find = false
        for i=index-1,0,-1 do
            if find==false and Tool.vipGift(i) ~= nil then 
                find=true
                self.indexTq=i
            end 
        end
        index=self.indexTq
    end  
	self.lb_libao_vip.text ="VIP " .. index
    if Tool.vipGift(index)~=nil and Tool.vipGift(index).consume~=nil and Tool.vipGift(index).consume[0]~=nil then 
        self.Container:SetActive(true)
        self.btBuy.gameObject:SetActive(true)
        self.des:SetActive(false)
        self.txt_price_un.text =Tool.vipGift(index).consume[0].consume_arg or 0
        if Tool.vipGift(index).yuanjia=="" then 
            Tool.vipGift(index).yuanjia=Tool.vipGift(index).consume[0].consume_arg
        end
    else 
        self.Container:SetActive(false)
        self.btBuy.gameObject:SetActive(false)
        self.des:SetActive(true)
        self.txt_price_un.text="0"
    end
    if Tool.vipGift(index).yuanjia=="" then 
        self.txt_price_nomal.text ="0"
    else 
        self.txt_price_nomal.text =Tool.vipGift(index).yuanjia
    end 
	self.lbCurVip.text = "[FFFF00]VIP " .. index .. " [-]"
	self.lbTequan.text = string.gsub(self.vipLevel[index].desc, '\\n', '\n')
	local list = RewardMrg.getProbdropByTable(Tool.vipGift(index).drop)
	self.dropTypeList = {}
	for i=1,#list do
		table.insert(self.dropTypeList, list[i]:getType())
	end
	ClientTool.UpdateGrid("Prefabs/moduleFabs/puYuanStoreModule/cell", self.Grid, list)
	self.binding:CallManyFrame(function()
        self.view:SetDragAmount(0,0,false)
        end, 3)
	if index > self.vip then
		self.btBuy.isEnabled = false
	else
		self.btBuy.isEnabled = true
	end
	self.lb_buy_tip.text = TextMap.GetValue("Text1464")
	if self.vipPkg[Tool.vipGift(index).id] == 1 then 
		self.btBuy.isEnabled = false 
		self.lb_buy_tip.text = TextMap.GetValue("Text1465") 
	end
	self:updatebuyGift_red()
end

function actList:updateVipData( ... )
	self.vip = Player.Info.vip
	self.exp = Player.Resource.vip_exp
	if self.oldVip ~= self.vip then
		self.oldVip = self.vip
	end
	local count = 15
	local next_index = self.vip + 1
	if next_index > count then 
		next_index=count
	end 
	self.exp_next = self.vipLevel[next_index].vip_exp

	self.lbVipLevel.text ="VIP " .. self.vip
    local rate = TableReader:TableRowByID("charge_settings","charge_rate").value
	self.lbSliderPercent.text = "[01ff13]" .. (self.exp / rate) .. "[-]" .. "/" .. (self.exp_next / rate)
	if self.exp > self.exp_next then
		self.sliderVip.value = 1
	else
		self.sliderVip.value = self.exp / self.exp_next
	end
	if self.exp > self.exp_next then
		self.lbPurchaseContinue.text = TextMap.GetValue("Text1460")
	else
		self.lbPurchaseContinue.text = math.floor((self.exp_next - self.exp) / rate) .. TextMap.GetValue("Text1461") --向上取整
	end
	self.lbVipContinue.text = "VIP " .. next_index
end

function actList:updatebuyGift_red()
	local ret = false
	for i=0,Player.Info.vip do
        if Tool.vipGift(i)~=nil and Tool.vipGift(i).drop[0]~=nil and (Player.Vippkg[Tool.vipGift(i).id] == nil or Player.Vippkg[Tool.vipGift(i).id] ~= 1) then 
            ret = true
        end 
    end
    self.redPoint1:SetActive(ret)
end

function actList:onEnter()
     LuaMain:ShowTopMenu(6,nil,{[1]={ type="crystal"},[2]={ type="c_gold"},[3]={ type="money"},[4]={ type="gold"}})
end

function actList:update(data)
    if data then
        self.__curActId = data[1]
        self._type = data[2]
    else
        self.__curActId = nil
        self._type = nil
    end
end

function actList:init()
    self.bind = {}
end


function actList:getActivityData(...)
    self.list = {}
    Api:getActivity("",self._type, function(result)
        self:ApiReqActivityandFuli(result)
        end, function(...) 
        self.btn_fuli2.gameObject:SetActive(false) 
        self.btn_fuli3.gameObject:SetActive(false) 
        return false
        end)
end

function actList:ApiReqActivityandFuli(result)
    actList:refreshData(result,false) 
end

function actList:refreshData(result,_bool)
    if result.ids == nil then 
        return
    end
    local count = result.ids.Count
    if count == 0 then 
        self.btn_fuli2.gameObject:SetActive(false) 
        self.btn_fuli3.gameObject:SetActive(false) 
        return 
    end
    
    local rp ={}
    if result.rp ~=nil then 
        rp=json.decode(result.rp:toString())
    end 
    self.rp = {}
    self.redPoint = 0
    table.foreachi(rp, function(k, v)
        self.rp[v] = true
    end)
    if result.infos~=nil then
        local infos_drop = json.decode(result.infos:toString())
        table.foreach(infos_drop, function(i, v)
        	if v.event == "vipGift" then 
        		self.data = v
        		self:setVipInfo(_bool)
        	end 
        end)
    end 
end

function actList:OnDestroy()
    Events.RemoveListener('activity_refresh')
    Player:removeListener("vipMenucurrency")
end

Events.AddListener("activity_refresh",
    function(params)
        actList:refreshEveryPay()
    end
    )

function actList:refreshEveryPay( ... )
     Api:getActivity("",self._type, function(result)
            local id = self.currentID
            actList:refreshData(result,true)
            self:onEnter()
        end)
end

function actList:onExit()
    self.__exit = true
end

function actList:setVipInfo(up)
    if up then 
        if self.selectItem_cur~=nil then 
            self.selectItem_cur:getCallBack()
        end 
        return 
    end 
    self.list = {}
    self.giftindex = 0
    local index = 0
    local _times = self.data.times
    local _disc = self.data.disc
    local _cost = self.data.cost
    self.fuliIndex = 0
    self.extra_item= {}
    local cur_vip = -1
    for i=Player.Info.vip,30 do
        if cur_vip<Player.Info.vip and self.data.drop["" .. i] ~=nil then 
            cur_vip=i
        end 
    end
    local next_vip = cur_vip 
    for i=cur_vip+1,30 do
        if next_vip<=cur_vip and self.data.drop["" .. i] ~=nil then 
            next_vip=i
        end 
    end
    for k, v in pairs(self.data.drop) do
        if tonumber(k) ==cur_vip or tonumber(k) ==next_vip then
            local data = {}
            table.foreach(v, function(i, item)
                local _type = item.type
                if _type == "char" then
                    local vo = Char:new(item.arg)
                    vo.__tp = "char"
                    table.insert(data, vo)
                else
                    local vo = itemvo:new(item.type, item.arg2, item.arg)
                    vo.__tp = "vo"
                    table.insert(data, vo)
                end
            end)
            local status= 3
            if tonumber(k) == Player.Info.vip then 
                status=self.data.status
                if status~=nil and status==1 then 
			    	self.redPoint2:SetActive(true)
			    else 
			    	self.redPoint2:SetActive(false)
			    end 
            end 
            index=index+1
            local package = {}
            package.id=k 
            table.insert(self.extra_item, {type="vipFuli",status=status,delegate = self, drop = data, package =package })
        end 
    end
    table.sort(self.extra_item, function(a, b)
         if a.package.id ~= b.package.id then return tonumber(a.package.id) <tonumber(b.package.id) end 
    end)
    for i,v in ipairs(self.extra_item) do
        if self.fuliIndex==0 and v.package.id == self.vip then 
            self.fuliIndex=i 
        end 
    end
    self.isUpdate_fuli=false
    index=0
    local canbuygift = false
    for k, v in pairs(self.data.extra_drop) do
        local data = {}

        table.foreach(v, function(i, item)
            local _type = item.type
            if _type == "char" then
                local vo = Char:new(item.arg)
                vo.__tp = "char"
                table.insert(data, vo)
            else
                local vo = itemvo:new(item.type, item.arg2, item.arg)
                vo.__tp = "vo"
                table.insert(data, vo)
            end
        end)
        index=index+1
        local disc = 10
        if _disc~=nil and _disc[k] ~=nil then 
            disc=_disc[k]
        end 
        local times = 0 
        if _times~=nil and _times[k] ~=nil then 
            times=_times[k]
        end 
        local package = {}
        package.id=k
        if canbuygift==false and tonumber(package.id)<=Player.Info.vip and times>0 then 
        	canbuygift=true 
        end 
        table.insert(self.list, {type="vipGift",disc=disc,cost=_cost[k],times=times,delegate = self, drop = data, package = package })
    end
    self.redPoint3:SetActive(canbuygift)
    table.sort(self.list, function(a, b)
        if a.package.id ~= b.package.id then return tonumber(a.package.id) <tonumber(b.package.id) end 
    end)
    for i,v in ipairs(self.list) do
        if self.giftindex==0 and tonumber(v.package.id) == Player.Info.vip then 
            self.giftindex=i-1 
        end 
    end
    self.isUpdate_gift=false
    local path = UrlManager.GetImagesPath("sl_activity/activity_tip/" .. self.data.title .. ".png")
    if self.tip ~= nil then 
        self.tip.Url=path
    end
    self.tip.gameObject:SetActive(false)
    if self.hero~=nil then 
        local id = 0
        if self.data.title~=nil then 
            id =tonumber(self.data.title)
        end
        local row
        if id~=nil and id>0 and id <1000 then 
            row = TableReader:TableRowByID("char", id)
        end
        if row~=nil then 
            self.hero.gameObject:SetActive(true)
            self.hero:LoadByModelId(id, "idle", function() end, false, 0, 1)
            self.hero.gameObject:SetActive(false)
        else 
            self.hero.gameObject:SetActive(false)
        end 
    else 
        self.hero.gameObject:SetActive(false)
    end  
end

function actList:update_vipgift_red( ... )
	local canbuygift = false
    for k, v in pairs(self.data.extra_drop) do
        local times = 0 
        if self.data.times~=nil and self.data.times[k] ~=nil then 
            times=self.data.times[k]
        end 
        local package = {}
        package.id=k
        if canbuygift==false and tonumber(package.id)<=Player.Info.vip and times>0 then 
        	canbuygift=true 
        end 
    end
    self.redPoint3:SetActive(canbuygift)
end

function actList:getTableLen()
    local index = 0
    for k,v in pairs(self.bind) do
        index=index+1
    end 
    return index
end



function actList:getDropPackage(delegate, aid, gid, cb)
    local info = self.data
    if info.status == 0 then MessageMrg.show(TextMap.GetValue("Text447")) return end
    if info.status == 1 or info.status == 4 or info.status == 5 then --领取|开宴
    Api:getActGift(aid, gid, function(result)
        if result.drop ~= nil then
            self:showMsg(result, info.event)
            self:onEnter()
            self.rp[aid] = false
            self.data.status=2
            self.redPoint2:SetActive(false)
            if self.selectItem_cur ~= nil then  
            	self.selectItem_cur:getCallBack()
            end 
        end
        if cb then cb() end
    end, function()
        return false
    end)
    elseif info.status == 3 then
        DialogMrg.chognzhi()
    end
end

function actList:fortune(delegate, aid,  cb)
    local info = self.list[aid].info
    Api:fortune(aid, function(result)
        if result.drop ~= nil then
            self:showMsg(result, info.event)
            self:onEnter()
            self.rp[aid] = false
            if self.currentSelect ~= nil then self.currentSelect:hideEffect() end
            delegate:getCallBack()
        end
        if cb then cb() end
    end, function()
        return false
    end)
end

function actList:buyVipGift(delegate, aid, gid,num,cb)
    local info = self.data
    Api:buyVipGift(aid, gid,num, function(result)
        if result.drop ~= nil then
            self:showMsg(result, info.event)
            self:onEnter()
            local times = self.data.times[gid]
            self.data.times[gid]=times-1
            self:update_vipgift_red()
        end
        if cb then cb() end
    end, function()
        return false
    end)
end

function actList:getMutliPackage(delegate, aid, gid,cb)
    local info = self.list[aid].info
    if info.status[gid] == 0 then MessageMrg.show(TextMap.GetValue("Text447")) return end
    Api:getActGift(aid, gid, function(result)
        if result.drop ~= nil then
            if result.times~=nil and result.times>0 then
                info.status[gid] = 1
            else 
                info.status[gid] = 2
            end 
            self:showMsg(result, info.event)
            self:onEnter()
            local rp = false
            if info.package ~=nil then 
                for k, v in pairs(info.package) do
                    local st = info.status[info.package[k].id]
                    if st == 1 then
                        rp = true
                    end 
                end
            end 
            self.rp[aid] = rp
            if self.currentSelect ~= nil then self.currentSelect:showEffect() end
            delegate:getCallBack()
        end
        if cb then cb(result) end
    end, function()
        return false
    end)
end

function actList:hideEffect()
    if self.currentSelect ~= nil then self.currentSelect:hideEffect() end
end

function actList:showMsg(drop, event)
    local tp = 1
    if event == "doubleMoney" or event == "getBP" then
        tp = 0
    end
    packTool:showMsg(drop, nil, tp)
end

function actList:getDrop(_drop)
    local drop = _drop
    local _list = {}
    for i = 0, drop.Count - 1 do
        local v = drop[i]
        if self:isUsedType(v.type) then
            local m = {}
            m.type = v.type
            m.arg = v.arg
            m.arg2 = v.arg2
            table.insert(_list, m)
        end
    end
    return _list
end

function actList:isUsedType(_type)
    local typeAll = { "equip", "equipPiece", "item", "char", "charPiece", "reel", "reelPiece", "money", "gold", "bp", "soul", "popularity", "credit", "honor", "donate", "exp", "hunyu", "ghost", "ghostPiece" }
    for i, j in pairs(typeAll) do
        if _type == j then
            return true
        end
    end
    return false
end

--小红点计数
function actList:countRedPoint(add)
    if add then self.redPoint = self.redPoint + 1
    else self.redPoint = self.redPoint - 1
    end
end


return actList