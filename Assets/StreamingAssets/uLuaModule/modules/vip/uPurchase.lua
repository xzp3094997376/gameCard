local page = {}
local effect1
function page:create(binding)
	self.binding = binding
	return self
end

function page:onClick(go, name)
	print(name)
	if name == "btnBack" then 
		Events.Brocast('activity_refresh')
		UIMrg:pop()
	elseif name == "btn_close" then
		self:destroy()
	elseif name == "btTequan" then
		self:onTequan()
	elseif name == "btPrev" then
		self:onPrev()
	elseif name == "btNext" then
		self:onNext()
	elseif name == "btBuy" then
		self:buyGift()
	elseif name == "btPrevCharge" then
		self.ScrollCharge:Scroll(-4.4)
	elseif name == "btNextCharge" then
		self.ScrollCharge:Scroll(4.4)
	end
end

function page:onEnter()
	LuaMain:ShowTopMenu()
end 

function page:Start()
	LuaMain:ShowTopMenu()
	Tool.loadTopTitle(self.gameObject, TextMap.GetValue("Text_1_129"),function ()
		Events.Brocast('activity_refresh')
		UIMrg:pop()
	end)
	self.vipLevel = {}
	TableReader:ForEachLuaTable("vipLevel", function(index, item) --shopPurchase
	self.vipLevel[item.id] = item
	return false
	end)
	self.scroll = self.BlockVip.transform:Find("BlockRight/Scroll View"):GetComponent("UIScrollView")
	self:initObj()
	self.oldVip = Player.Info.vip
	self:setInfoData()
	self:setGiftData()
	self:setItemData()
end

function page:update(data)
	if data.ui == "tequan" then self:onTequan() end
end

function page:destroy()
	Events.Brocast('activity_refresh')
	UIMrg:pop()
end

function page:setItemData()
	self.purchaseData = {}
	self.yueka_data = {}
	local indexs = {}
	local yueka_index=1
	local data_index=1
	TableReader:ForEachLuaTable("shopPurchase", function(index, item)
		local _sendNum=0
		if item.sendNum ~=nil then _sendNum = item.sendNum end 
		if item.rtype=="gold" then
		local rate = TableReader:TableRowByID("charge_settings","charge_rate").value
		self.purchaseData[data_index] = {
			sendNum = item.cost*rate,
			item=item
		}
		data_index=data_index+1
	end
	return false
	end)

	-- 兼容appStore
	if GlobalVar.dataEyeChannelID == "ios" then
	   table.foreach(self.purchaseData,function (i,v)
		   if v.name ==TextMap.GetValue("Text_1_2849") then
				print(GlobalVar.dataEyeChannelID)
			   table.remove(self.purchaseData,i)
		   end
		   if v.name == TextMap.GetValue("Text_1_2850") then
				v.name = TextMap.GetValue("Text_1_2851")
				v.cost = 6
				v.sendNum = 60
		   end
	   end)
	end
	local  purchaseData= {}
	table.foreach(self.yueka_data, function(_k, _v)
		table.insert(purchaseData,_v)
		end )
	table.foreach(self.purchaseData, function(_k, _v)
		table.insert(purchaseData,_v)
	end)

	ClientTool.UpdateGrid("Prefabs/moduleFabs/vipModule/vip_libiao", self.grid, purchaseData, self)

	--self.vip_yueka:CallUpdateWithArgs(self.yueka_data, 1, nil, self)
	self.binding:CallManyFrame(function() self.ScrollCharge:ResetPosition() end)
end

function page:getfirst(id)
	local firstPay = 0
	local first = Player.FirstPay
	if first ==nil then return firstPay end 
	for i=0,first.Count-1 do
		if first[i]==id then 
			firstPay=1 
		end 
	end
	return firstPay
end

--====================
-- 更新vip信息，页面载入和充值后调用
--====================
function page:setInfoData()

	self.player_id = Player.playerId
	self.vip = Player.Info.vip
	self.exp = Player.Resource.vip_exp
	if self.oldVip ~= self.vip then
		self.oldVip = self.vip
		Debug.Log("play VIP effect");
	end
	local count = 15
	local next_index = self.vip + 1
	if next_index > count then 
		next_index=count
	end 
	self.exp_next = self.vipLevel[next_index].vip_exp

	self.lbVipLevel.text ="VIP " .. self.vip
	self.lbSliderPercent.text = "[01ff13]" .. (self.exp / 10) .. "[-]" .. "/" .. (self.exp_next / 10)
	if self.exp > self.exp_next then
		self.sliderVip.value = 1
	else
		self.sliderVip.value = self.exp / self.exp_next
	end
	if self.exp > self.exp_next then
		self.lbPurchaseContinue.text = TextMap.GetValue("Text_1_2852")
	else
		self.lbPurchaseContinue.text = math.ceil((self.exp_next - self.exp) / 10) .. TextMap.GetValue("Text_1_2853") --向上取整
	end
	self.lbVipContinue.text = "VIP " .. next_index
end

function page:onPurchase(succeed, money)
	if succeed then
		OperateAlert.getInstance:showToGameObject({ TextMap.GetValue("Text1462") }, self.show)
		self:setInfoData()
	else
		-- OperateAlert.getInstance:showToGameObject({ "充值失败"}, self.center)
		MessageMrg.show(TextMap.GetValue("Text1463"))
	end
end

function page:initObj()
	self.mode = 0 -- 0 是充值界面，1是特权界面
	self.BlockCharge:SetActive(true)
	self.BlockVip:SetActive(false)
	self.btnname.text= TextMap.GetValue("Text_1_2854")
	self.Gem:SetActive(false)
	self.Star:SetActive(true)
end

function page:onTequan()
	if self.mode == 0 then
		self.BlockCharge:SetActive(false)
		self.BlockVip:SetActive(true)
		self.btnname.text= TextMap.GetValue("Text68") 
		self.Gem:SetActive(true)
		self.Star:SetActive(false)
		local index = self.vip 
		self.indexTq = index
		self.lbCurVip.text = "[FFFF00]VIP " .. self.indexTq .. " [-]"
		self.lbTequan.text = string.gsub(self.vipLevel[index].desc, '\\n', '\n')
		self.scroll:ResetPosition()
		self.mode = 1
		self:refreshGift(index)
	else
		self.BlockCharge:SetActive(true)
		self.BlockVip:SetActive(false)
		self.btnname.text= TextMap.GetValue("Text_1_2854")
		self.Gem:SetActive(false)
		self.Star:SetActive(true)
		self.mode = 0
	end
end

function page:onPrev()
	if self.indexTq > 0 then
		self.indexTq = self.indexTq - 1
		self.lbCurVip.text = "[FFFF00]VIP " .. self.indexTq .. " [-]"
		self.lbTequan.text = string.gsub(self.vipLevel[self.indexTq].desc, '\\n', '\n')
		self.scroll:ResetPosition()
		self:refreshGift(self.indexTq)
	end
end

function page:onNext()
	if self.indexTq < 15 then
		self.indexTq = self.indexTq + 1
		self.lbCurVip.text = "[FFFF00]VIP " .. self.indexTq .. " [-]"
		self.lbTequan.text = string.gsub(self.vipLevel[self.indexTq].desc, '\\n', '\n')
		self.scroll:ResetPosition()
		self:refreshGift(self.indexTq)
	end
end

function page:buyGift()
	if Player.Info.vip >=self.indexTq then
		if Tool:judgeBagCount(self.dropTypeList) == false then 
			return 
		end
		if self.gift[self.indexTq].consume[0].consume_arg <=Player.Resource.gold then 
			Api:buyVipPackage(self.gift[self.indexTq].id,function(result)
				if result.ret == 0 then
	                packTool:showMsg(result, nil, 2)
					self:refreshGift(self.indexTq)
				end
			end)
		else 
			MessageMrg.show(TextMap.GetValue("Text_1_100"))
		end
	else
		MessageMrg.show(TextMap.GetValue("Text_1_1087"))
	end
end

function page:setGiftData()
	self.vipPkg = Player.Vippkg
	self.gift = {}
	local list = {}
	TableReader:ForEachLuaTable("vipLibaoConfig", function(index, item)
		if item.id ~= nil then
			list[item.vip_lv] = item
		end
		return false
	end)
	self.gift = list
	self.scroll_g = self.Grid.transform.parent:GetComponent("UIScrollView")
end

function page:refreshGift(index)
	self.lb_libao_vip.text ="VIP " .. index
	self.txt_price_un.text =self.gift[index].consume[0].consume_arg
	if self.gift[index].yuanjia=="" then 
		self.gift[index].yuanjia=self.gift[index].consume[0].consume_arg
	end
	self.txt_price_nomal.text =self.gift[index].yuanjia
	local list = RewardMrg.getProbdropByTable(self.gift[index].drop)
	self.dropTypeList = {}
	for i=1,#list do
		table.insert(self.dropTypeList, list[i]:getType())
	end
	ClientTool.UpdateGrid("Prefabs/moduleFabs/puYuanStoreModule/cell", self.Grid, list)
	self.scroll_g:ResetPosition()
	if index > self.vip then
		self.btBuy.isEnabled = false
	else
		self.btBuy.isEnabled = true
	end
	self.lb_buy_tip.text = TextMap.GetValue("Text1464")

	if self.vipPkg[self.gift[index].id] == 1 then 
		self.btBuy.isEnabled = false 
		self.lb_buy_tip.text = TextMap.GetValue("Text1465") 
	end
end

function page:showMsg(result)
	-- drop = json.decode(drop:toString())
	local _list = RewardMrg.getList(result)
	local list = {}
	self.dropList = {}
	table.foreachi(_list, function(i, v)
		local _type = 0

		local t = v:getType()
		if t == "char" or t == "charpiece" then
			_type = 1
		end

		local icon = v:getHeadSpriteName()
		local num = v.rwCount
		local g = {}
		g.type = _type
		g.icon = icon or default
		g.text = num
		g.frame = v:getFrame()
		Debug.Log("AAAAAAA");
		table.insert(list, g)
		g = nil
	end)
	OperateAlert.getInstance:showGetGoods(list, self.show)
end

return page