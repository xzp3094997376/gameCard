local m = {} 

function m:update(lua)
    self.effect:SetActive(false)
	self.rewardView.gameObject:SetActive(true)
	self:selectedRebornTreasure(nil)
    self.btn_add.isEnabled=true
    self.btn_equip.isEnabled=true
	self.rewardView:refresh({}, self)
	self:registerEvent()
	self:RestAllStatus()
	self.delegate = lua.delegate
	ClientTool.AddClick(self.btn_add,function()
		if self.treasure== nil then 
			if self.isOpen==true then 
				Tool.push("recycle_ghost_rebirth","Prefabs/moduleFabs/recycleModule/recycle_ghost_rebirth",{ delegate = self,tp="treasure",model="CS"})
			else 
				MessageMrg.show(TextMap.GetValue("Text_1_1001"))
			end	 
		end
	end)
	ClientTool.AddClick(self.btn_equip,function()
		if self.treasure~= nil then
			m:selectedRebornTreasure()
		end
	end)
	ClientTool.AddClick(self.bt_restore,function()
        if Tool:judgeBagCount(self.dropTypeList) == false then return end
		if Player.Resource.gold >= self.costgold then
			self:reBirth_two(go)
		else
			MessageMrg.show(TextMap.GetValue("Text_1_1002"))
		end
	end)
	self:checkOpenSelect()
end

function m:checkOpenSelect()
    self.isOpen=false
    local all_list = Tool.getUnUseTreasure()
    if #all_list>0 then
    	for k,v in pairs(all_list) do
            local gh = Treasure:new(v.value.id, v.key)
            if gh.lv>1 or gh.power>0 then 
            	self.isOpen=true
            end 
        end
    end 
end

function m:reBirth_two(go)
    -- 展示奖品信息
    UIMrg:pushWindow("Prefabs/moduleFabs/recycleModule/gui_rewards_show", {
                    title = TextMap.GetValue("Text_1_985"),
                    content = TextMap.GetValue("Text_1_1003"),
                    content1="",
                    teams = self.treasure,
                    delegate = self,
                    callback = self.reBirth,
                    rewardList = self.rewardList,
                    consume=self.zs_num.text
                    })
end

function m:reBirth()
    self.btn_add.isEnabled=false
    self.btn_equip.isEnabled=false
    Api:treasureBirth(self.treasure.key,function(result)
    	m:selectedRebornTreasure()
    	self:showEffect()
    	print(".....重生成功.....")
    	self:checkOpenSelect()
    	end,function( ... )
    	print(".....重生失败.....")
    	end)
end

function m:showEffect()
    self.effect:SetActive(true)
    self.binding:CallManyFrame(function()
        self.binding:CallAfterTime(1.2, function(...)
            self.btn_add.isEnabled=true
            self.btn_equip.isEnabled=true
            self.effect:SetActive(false)
            self.delegate:showMsg(self.rewardList)
            self:RestAllStatus()
        end)
    end)
end




function m:selectedRebornTreasure(treasure)
	if treasure ~= nil then
		print("......"..treasure.name)
		self.treasure = treasure
		self.name.text = self.treasure:getDisplayColorName() 
 		self.equip.gameObject:SetActive(true)
        self.btn_add.gameObject:SetActive(false)
        self.equip.Url = self.treasure:getHead() 
	    self.img_bt:SetActive(false)
	    self.bt_restore.isEnabled = true
	    self:showReward()
	    --self:ShowMaybeCostGold(treasure)
	else
		self.treasure = nil
        self.equip.gameObject:SetActive(false)
        self.btn_add.gameObject:SetActive(true)
		self.name.text = ""
		self.bt_restore.isEnabled = false
		self.zs_num.text = "0"
		self.rewardView:refresh({}, self)
	end
end

function m:RestAllStatus()
	self.img_bt:SetActive(true)
    self.bt_restore.isEnabled = false
    self.zs_num.text = "0"
    self.name.text = ""
    if self.item ~= nil then
    	self.item.gameObject:SetActive(false)
    end
    --self.rewardView.gameObject:SetActive(false)
end

function m:showReward(...)
    self.dropTypeList = {}
    Api:birthDrop(self.treasure.key, function(result)
        local drop = self:getDrop(result.drop)
        self.rewardList = drop
        self.rewardView:refresh(drop, self)
        self.costgold = result.consume[0].consume_arg
        self.zs_num.text = self.costgold
        for k, v in pairs(drop) do
            table.insert(self.dropTypeList, v.type)
        end
    end, function()
    end)
end

function m:getDrop(info)
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


function m:ShowMaybeCostGold(treasure)
    self.treasureArg = {}
    local power_value = 0
    for i=1,2 do
       self:CalculateTreasureProperty(treasure:getMagic()[i],treasure.lv)
       self:CalculateTreasureProperty_JL(treasure:getMagic_JL(0)[i])
    end
    local ratio_hp = TableReader:TableRowByID("treasureArgs","treasure_return_coefficient1").arg2
    local ratio_pa = TableReader:TableRowByID("treasureArgs","treasure_return_coefficient2").arg2
    local ratio_pd = TableReader:TableRowByID("treasureArgs","treasure_return_coefficient3").arg2
    local ratio_ma = TableReader:TableRowByID("treasureArgs","treasure_return_coefficient4").arg2
    local ratio_md = TableReader:TableRowByID("treasureArgs","treasure_return_coefficient5").arg2

	for k,v in pairs(self.treasureArg) do
	    if v.name == "MaxHpV" then
	        power_value = power_value + v.value*ratio_hp
	    elseif v.name == "PhyAtkV" then
	        power_value = power_value + v.value*ratio_pa
	    elseif v.name == "PhyDefV" then
	        power_value = power_value + v.value*ratio_pd
	    elseif v.name == "MagAtkV" then
	        power_value = power_value + v.value*ratio_ma
	    elseif v.name == "MagDefV" then
	        power_value = power_value + v.value*ratio_md
	    end
	end
	self.costgold = self:PowerToGold(power_value)
	self.zs_num.text = self.costgold
end

function m:PowerToGold(val)
    local return_cost_1 = nil
    local return_cost_2 = nil
    local percent = 0
    return_cost_1 = TableReader:TableRowByID('rebirthCost', "5")
    if val <= return_cost_1.args1 then
        percent = return_cost_1.args2
    else
        return_cost_2 = TableReader:TableRowByID('rebirthCost', "6")
        percent = return_cost_2.args2
    end
    return math.floor((val * percent))
end


function m:CalculateTreasureProperty(magic,level)
    local num = magic.arg + magic.arg2 * level
    local data = {}
    data.name =  magic.name
    --print("....属性名字...."..magic.name)
    data.value = num / magic.denominator
    --print("....属性大小...."..num / magic.denominator)
    table.insert(self.treasureArg,data)
end

function m:CalculateTreasureProperty_JL(magic)
    local num = magic.arg
    local data = {}
    data.name =  magic.name
    --print("....属性名字...."..magic.name)
    data.value = num / magic.denominator
    --print("....属性大小...."..num / magic.denominator)
    table.insert(self.treasureArg,data)
end


function m:OnDestroy()
    Events.RemoveListener('selectedRebornTreasure')
end

function m:registerEvent()
    Events.RemoveListener('selectedRebornTreasure')
    Events.AddListener("selectedRebornTreasure", funcs.handler(self, m.selectedRebornTreasure))
end

return m