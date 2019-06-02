-- create
-- User: benhuang
-- Date: 2016/10/14
-- 装备升星

local m = {}


local addStartInfoList = {
	id,
	_preType,
	_prevalue,
	_nextType,
	_nextValue,
	_equipName,
	_currentStar,
	_equipIconUrl
}

function m:update(lua)
	self.data = lua.data
	self.delegate = lua.delegate	
    self.ShengXing_Eff:SetActive(false)
    self.isClick = false
	m:ShowEquipInfo()
	if self.oneKeyAddStarLock ~= nil then
		if Player.Info.level >= self.oneKeyAddStarLock.arg or Player.Info.vip >= self.oneKeyAddStarLock.arg2 then
			self.btn_OneShengXing_gray.gameObject:SetActive(false)
			self.btn_One_ShengXing.gameObject:SetActive(true)
		else
			self.btn_OneShengXing_gray.gameObject:SetActive(true)
			self.btn_One_ShengXing.gameObject:SetActive(false)
		end
	end
end

function m:Start()
	self.selectAddType = 1
	self.isOneKey = 0
	--ghostArgs
	self.btn_OneShengXing_gray.gameObject:SetActive(true)
	self.btn_One_ShengXing.gameObject:SetActive(false)
	self.oneKeyAddStarLock = TableReader:TableRowByID("ghostArgs", "yj_addstar_limit")
end

function  m:ShowEquipInfo()
	self.equipIcon.Url = self.data:getHead()
	local infoStar = Player.Ghost[self.data.key]
	local curExp = infoStar.starExp
	self.curXinYun = infoStar.starLuck
	local curStar = infoStar.star
	local info = {}
	m:SetStarInfo(infoStar)
	if curStar < self.equipMaxStar then
		self.info = TableReader:TableRowByUniqueKey("ghostaddstar", self.data.id, infoStar.star + 1)
		self.Label_Add_are.gameObject:SetActive(true)
		self.btx_ShengXing.isEnabled = true
		self.btn_One_ShengXing.isEnabled = true
	else if curStar == self.equipMaxStar then
		self.info = TableReader:TableRowByUniqueKey("ghostaddstar", self.data.id, infoStar.star)
		self.Label_Add_are.gameObject:SetActive(false)
		self.btx_ShengXing.isEnabled = false
		self.btn_One_ShengXing.isEnabled = false
		m:SetSXType()
		end
	end
	if self.info ~= nil then
		self.addExp = self.info.addexp
		self.addStar = self.info.addstarlv
		local addType = string.gsub(self.info.addstarmagic[0]._magic_effect.format, "{0}", "")
		local addValue = self.info.addstarmagic[0].magic_arg1
		local addexpValue = self.info.addexpmagic[0].magic_arg1
		self.addBaseTytle = string.gsub(self.info.addexpmagic[0]._magic_effect.format, "：{0}", "")
		self.addBaseValue = self.info.addexpmagic[0].magic_arg1
		if self.selectType == nil then
			self.selectType = self.info.consume[0].consume_type
			self.NeedCost = self.info.consume[0].consume_arg
		end
		local leijiaValue = 0
		if infoStar.star > 0 then
			for i = 1, infoStar.star do
				local info = TableReader:TableRowByUniqueKey("ghostaddstar", self.data.id, i)
				leijiaValue = leijiaValue + info.addstarmagic[0].magic_arg1 + (info.addexpmagic[0].magic_arg1 * info.exp)
			end
		end

		if self.data.power > 0 then
	        self.equip_name.text = self.data:getItemColorName(self.data.star , self.data.name .. " [00ff00]+ " ..self.data.power.."[-]")
	    else   
	        self.equip_name.text = self.data:getDisplayColorName()
	    end 

 		m:isShengxingSuccess(infoStar.star)

	    self.Label_LeiJia_title.text = addType
	    self.Label_Add_type.text =  addType
	    self.Label_Ewai.text = TextMap.GetValue("Text_1_905")
	    self.Label_start_title.text =string.gsub(TextMap.GetValue("LocalKey_810"),"{0}",tostring(self.info.addstarlv))

	    self.SliderInfo.value =  curExp / self.info.exp
	    self.Label_Exp_value.text = TextMap.GetValue("Text_1_906")..math.floor(curExp).."/"..self.info.exp
	    self.Value_Xinyun.text = self.curXinYun

	    self.Label_Add_value.text = "[05fc17]"..self.info.exp * addexpValue .."[-]"
	    self.Label_Add_Ewvalue.text = "[05fc17]".. addValue .."[-]"
	    self.Label_Leijia_value.text = math.floor(leijiaValue + addexpValue * curExp)


	    --成功率 + 幸运值 找区间判断
	    if self.selectType ~= nil then
	    	for i = 0, 2 do
	    		if self.info.consume[i] ~= nil and self.selectType == self.info.consume[i].consume_type then
	    			m:judgeChengGonglv(self.info.consume[i].rate_addstar, self.curXinYun)
	    			break
	    		end
	    	end
	    else
	    	for i = 0, 2 do
	    		if  self.info.consume[i] ~= nil then
	    			m:judgeChengGonglv(self.info.consume[i].rate_addstar, self.curXinYun)
	    			break
	    		end
	    	end
	    end

	   	self.addStartInfoList = {}
	   	self.addStartInfoList.id = self.data.id
	    self.addStartInfoList._preType =  addType
	    self.addStartInfoList._prevalue = leijiaValue
	    self.addStartInfoList._nextType = addType
	    self.addStartInfoList._nextValue = addValue + self.addBaseValue * self.info.exp--tonumber(leijiaValue) + tonumber(addValue)
	    self.addStartInfoList._equipName = self.equip_name.text
	    self.addStartInfoList._currentStar = tonumber(infoStar.star) + 1
	    self.addStartInfoList._equipIconUrl = self.data:getHead()


		m:SetSXType()

	end
end

function m:judgeChengGonglv(cglv, xy)
	local endCglv = tonumber(cglv) + tonumber(xy)
	local cgLvArea = {}
	for i = 1, 6 do
		cgLvArea[i] = TableReader:TableRowByID("ghostArgs", "addstar_rateshow"..i);
		if endCglv <= cgLvArea[i].arg then
			-- print("目前成功率（数值）："..endCglv)
			-- print("判断成功率（数值）："..cgLvArea[i].arg)
			-- print("文本成功率（数值）："..cgLvArea[i].arg2)
			self.Value_chenggonglv.text = cgLvArea[i].arg2
			break
		end
	end
end

--切换界面的时候，一键升星按钮需要恢复默认状态，停止升星
function m:OnDisable()
	self.isClick = false
	self.isOneKey = 0
	self.Txt_oneKey.text = TextMap.GetValue("Text_1_907")
	self.Txt_oneKey.fontSize = 30
end

function  m:SetStarInfo(infoStar)
	self.equipMaxStar = 0
	for i = 1, 5 do
		if TableReader:TableRowByUniqueKey("ghostaddstar", self.data.id, i) ~= nil then
			self["Start_"..i].gameObject:SetActive(true)
			self.equipMaxStar = self.equipMaxStar + 1
		else
			self["Start_"..i].gameObject:SetActive(false)
		end
	end
	for i = 1,infoStar.star do
		self["Start_"..i.."_Check"].gameObject:SetActive(true)
	end
	self.List_start.enabled = true
end

function  m:SetSXType()
	for i = 0, 2 do
		if self.info.consume[i] ~= nil then
			self["choose"..i + 1].gameObject:SetActive(true)
			self["choose"..i + 1]:CallUpdate(self.info.consume[i], self.data.key)
		else
			self["choose"..i + 1].gameObject:SetActive(false)
		end
	end
	--self.selectAddType = 1
end

--判断是否升星成功
function m:isShengxingSuccess(targetStar)
	if self.addStartInfoList ~= nil then
		if self.addStartInfoList._currentStar == targetStar then
			UIMrg:pushWindow("Prefabs/moduleFabs/guidao/AddStarSuccessTip", self.addStartInfoList)
			self.isOneKey = 0
			self.Txt_oneKey.text = TextMap.GetValue("Text_1_907")
			self.Txt_oneKey.fontSize = 30
			self:SelecSXtType(1)
			self.selectType = self.info.consume[0].consume_type
			if self.selectType == "ghostPiece" then
				self.NeedCost = self.info.consume[0].consume_arg2
				self.ghostId = self.info.consume[0].consume_arg
			else
				self.NeedCost = self.info.consume[0].consume_arg
			end
			m:judgeChengGonglv(self.info.consume[0].rate_addstar, self.curXinYun)
		end
	end
end

function m:SelecSXtType(index)
	self.selectAddType = index
    if index == 1 then 
		self.selcIcon_1.gameObject:SetActive(true)
		self.selcIcon_2.gameObject:SetActive(false)
		self.selcIcon_3.gameObject:SetActive(false)
		print("1"..self.selectType..":need cost:"..self.NeedCost)
	elseif index == 2 then
		self.selcIcon_1.gameObject:SetActive(false)
		self.selcIcon_2.gameObject:SetActive(true)
		self.selcIcon_3.gameObject:SetActive(false)
		print("2"..self.selectType..":need cost:"..self.NeedCost)
	elseif index == 3 then
		self.selcIcon_1.gameObject:SetActive(false)
		self.selcIcon_2.gameObject:SetActive(false)
		self.selcIcon_3.gameObject:SetActive(true)
		print("3"..self.selectType..":need cost:"..self.NeedCost)
	end
end
function m:JudegeEought()
	local state = true
	print("判断所需资源.."..self.selectType)
	if self.selectType == "money" then
		if Player.Resource.money < self.NeedCost then
			print("金币不足")
			MessageMrg.show(TextMap.GetValue("Text_1_1065"))
			state = false
		end
	elseif self.selectType == "gold" then
		if Player.Resource.gold < self.NeedCost then
			print("钻石不足")
			MessageMrg.show(TextMap.GetValue("Text_1_100"))
			state = false
		end
	elseif self.selectType == "ghostPiece" then
		local pieces = Player.GhostPieceBagIndex:getLuaTable()
	    local pieceId = nil
	    local pieceNum
	    if self.ghostId ~= nil then
		    table.foreach(pieces, function(i, v)
		        if v.count > 0 then
			         local row = TableReader:TableRowByID("ghostPiece", i)
		            if row then
		                local consume = row.consume
		                local _costList = RewardMrg.getConsumeTable(consume)
		                for i = 1, #_costList do
		                    local it = _costList[i]
		                    if it["Table"].id == self.ghostId then
		                    	pieceId =  it["Table"].id
		                    	pieceNum = v.count
								break;
		       --              	if v.count < self.NeedCost then
		       --              		MessageMrg.show(TextMap.GetValue("Text1757"))
									-- state = false
									-- break;
		       --              	end
		                	end
		                end
		            end
		        end
		    end)
	    end

	    if pieceId == nil or pieceNum < self.NeedCost then
    		MessageMrg.show(TextMap.GetValue("Text1757"))
			state = false
    	end

	end

	return state
end

-- logic.ghostHandler.ghostStarUp
-- param:  
-- key ( 装备唯一key)
-- type (升星模式，从1开始) ,钱，钻石，碎片
-- auto (是否一键升星，0表示否，1表示是)
--Api:ZhuangBeiStarUp()
function m:onShengXing()
	print("当前选择："..self.selectAddType)
	if m:JudegeEought() == false then return end
	local key = self.data.key
	local addType = self.selectAddType
	if self.isClick == true then return end
	self.isClick = true
    self.btx_ShengXing.isEnabled = false
	Api:ZhuangBeiStarUp(key, addType, 0, function(result)
		if result ~= nil then
			--print(result)
			m:showEffect(true)
			local list = {}
			if result.exp > 0 then
				local showInfo = math.floor(result.exp).."\n".."[ffff96]"..self.addBaseTytle.."[-]+"..math.floor(self.addBaseValue * result.exp)
				if result.exp > self.addExp then
					list[1] = TextMap.GetValue("Text_1_908").."\n"..TextMap.GetValue("Text_1_909")..showInfo
				else
					list[1] = TextMap.GetValue("Text_1_910").."\n"..TextMap.GetValue("Text_1_909")..showInfo
				end
			else
    			list[1] = TextMap.GetValue("Text_1_911")
			end
    		OperateAlert.getInstance:showToGameObject(list, self.node) 
		end
	end, function() 
			self.isClick = false
    		self.btx_ShengXing.isEnabled = true
		end)
	-- self.binding:CallAfterTime(2, function()
	-- 	self.isClick = false
 --    	self.btx_ShengXing.isEnabled = true
 --    end)
end

function  m:oneKeyShengXing()
	print("当前选择："..self.selectAddType)
	if m:JudegeEought() == false then 
		self.isClick = false
		self.isOneKey = 0
		self.Txt_oneKey.text = TextMap.GetValue("Text_1_907")
		self.Txt_oneKey.fontSize = 30
		return 
	end
	if self.isOneKey == 1 then 
		local key = self.data.key
		local addtype = self.selectAddType
		--print("key:.>"..key.." ,Type:.....>"..self.selectAddType.." ,auto:...>"..0)
		if self.isClick == true then return end
		self.isClick = true
		Api:ZhuangBeiStarUp(key, self.selectAddType, 0, function(result)
			if result ~= nil then
				m:showEffect(true)
				local list = {}
				if result.exp > 0 then
					local showInfo = math.floor(result.exp).."\n".."[ffff96]"..self.addBaseTytle.."[-]+"..math.floor(self.addBaseValue * result.exp)
					if result.exp > self.addExp then
						list[1] = TextMap.GetValue("Text_1_908").."\n"..TextMap.GetValue("Text_1_909")..showInfo
					else
						list[1] = TextMap.GetValue("Text_1_910").."\n"..TextMap.GetValue("Text_1_909")..showInfo
					end
				else
	    			list[1] = TextMap.GetValue("Text_1_911")
				end
	    		OperateAlert.getInstance:showToGameObject(list, self.node)
			end
		end, function()
			self.isClick = false
    		self.isOneKey = 0
    		self.Txt_oneKey.text = TextMap.GetValue("Text_1_907")
			self.Txt_oneKey.fontSize = 30
		end)
	end
	-- self.binding:CallAfterTime(2, function()
	-- 	self.isClick = false
 --    end)
end

function m:onClick(go, name)
	if name == "btx_ShengXing" then
		if self.isOneKey == 0 then
			self.effAfterTime = 2
			m:onShengXing()
		end
	elseif name == "btn_One_ShengXing" then
		if self.isOneKey == 0 then
			self.isOneKey = 1
			self.effAfterTime = 1.5
			self.Txt_oneKey.text = TextMap.GetValue("Text_1_162")
			self.Txt_oneKey.fontSize = 36
			m:oneKeyShengXing()
		elseif self.isOneKey == 1 then
			self.isOneKey = 0
			self.Txt_oneKey.text = TextMap.GetValue("Text_1_907")
			self.Txt_oneKey.fontSize = 30
		end
	elseif name == "btn_OneShengXing_gray" then
		if self.oneKeyAddStarLock ~= nil then
			MessageMrg.show(TextMap.GetValue("Text_1_912") ..self.oneKeyAddStarLock.arg .. TextMap.GetValue("Text_1_913")..self.oneKeyAddStarLock.arg2..TextMap.GetValue("Text_1_914"))
		end
	elseif name == "btn_sel_1" then
		if  self.info.consume[0] ~= nil then
			self.selectType = self.info.consume[0].consume_type--"money"
			m:judgeChengGonglv(self.info.consume[0].rate_addstar, self.curXinYun)
			if self.selectType == "ghostPiece" then
				self.NeedCost = self.info.consume[0].consume_arg2
				self.ghostId = self.info.consume[0].consume_arg
			else
				self.NeedCost = self.info.consume[0].consume_arg
			end
			--print_t(self.info.consume[0])
			self:SelecSXtType(1)
		end
	elseif name == "btn_sel_2" then
		if self.info.consume[1] ~= nil then
			self.selectType = self.info.consume[1].consume_type--"gold" if gold = nil then ==ghostpiece
			m:judgeChengGonglv(self.info.consume[1].rate_addstar, self.curXinYun)
			if self.selectType == "ghostPiece" then
				self.NeedCost = self.info.consume[1].consume_arg2
				self.ghostId = self.info.consume[1].consume_arg
			else
				self.NeedCost = self.info.consume[1].consume_arg
			end
			--print_t(self.info.consume[1])
			self:SelecSXtType(2)
		end
	elseif name == "btn_sel_3" then
		if self.info.consume[2] ~= nil then
			self.selectType = self.info.consume[2].consume_type
			m:judgeChengGonglv(self.info.consume[2].rate_addstar, self.curXinYun)
			if self.selectType == "ghostPiece" then
				self.NeedCost = self.info.consume[2].consume_arg2
				self.ghostId = self.info.consume[2].consume_arg
			else
				self.NeedCost = self.info.consume[2].consume_arg
			end
			--print_t(self.info.consume[2])
			self:SelecSXtType(3)
		end
    end
end

--显示升星效果
function m:showEffect(ret)
    MusicManager.playByID(46)
    self.ShengXing_Eff:SetActive(false)
    self.ShengXing_Eff:SetActive(true)
    self.binding:CallAfterTime(self.effAfterTime, function()
    	self.btx_ShengXing.isEnabled = true
        self.ShengXing_Eff:SetActive(false)
			m:ShowEquipInfo()
			self.isClick = false
			if self.isOneKey == 1 then
				m:oneKeyShengXing()
			end
        if ret then self.isClick = false end 
    end)
end

return m