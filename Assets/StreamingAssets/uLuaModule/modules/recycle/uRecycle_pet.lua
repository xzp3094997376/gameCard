local m = {}

function m:onSelect(go)
    if self.model=="pet_fenjie" then 
        if self.isOpen==false then 
            MessageMrg.show(TextMap.GetValue("Text_1_992"))
            return
        end
        Tool.push("recycle_charList", "Prefabs/moduleFabs/recycleModule/recycle_charList", { teams = {}, delegate = self, model="FJ",tp="pet" })
    else
        if self.isOpen==false then 
            MessageMrg.show(TextMap.GetValue("Text_1_993"))
            return
        end
        Tool.push("recycle_charList", "Prefabs/moduleFabs/recycleModule/recycle_charList", { teams = {}, delegate = self, model="CS",tp="pet" })
    end
end

function m:update(lua)
    self.effect:SetActive(false)
	self.model=lua.model
    self.delegate = lua.delegate
    self.canClick=true
    if self.model=="pet_fenjie" then 
    	self.desLabel.text=TextMap.GetValue("Text_1_994")
    	self.btn_label.text=TextMap.GetValue("Text_1_995")
    	self.blackShop.gameObject:SetActive(true)
    else
    	self.desLabel.text=TextMap.GetValue("Text_1_996")
    	self.btn_label.text=TextMap.GetValue("Text_1_997")
    	self.blackShop.gameObject:SetActive(false)
    end
    self:getChar(nil)
    self.rewardView:refresh({}, self)
    self:checkOpenSelect()

end

function m:onFilter(pet)
    if self:checkHuyou(pet.id) then return false end 
    return true
end 


function m:checkHuyou(petId)
    local ghostSlot = Player.ghostSlot
    for i = 0, 5 do 
        local slot = ghostSlot[i]
        local petid = slot.petid
        if petId == petid then 
            return true
        end 
    end 
    return false
end 
function m:petIsOnTeam()
    local ret = false 
    if Player.Team[0].pet ~= nil and tostring(Player.Team[0].pet) ~= "0" then 
        ret = true 
    end 
    return ret
end 

function m:checkOpenSelect()
    self.isOpen=false
    local ids = {}
    if self:petIsOnTeam() == true then
        ids[Player.Team[0].pet .. ""] = true
    end

    local function isShow(id)
        if ids[id .. ""] then
            return false
        end
        return true
    end

    local pets = Player.Pets:getLuaTable()
    local petsList = {}
    local index = 1
    for k, v in pairs(pets) do
        local pet = Pet:new(k, v)
        if self.isOpen==false and isShow(pet.id) then
            if self.onFilter then
                if self:onFilter(pet) then
                    self.isOpen=true
                end
            else
                self.isOpen=true
            end
        end
    end
end


function m:showEffect(...)
    self.effect:SetActive(true)
    self.binding:CallManyFrame(function(...)
        self.binding:CallAfterTime(1.7, function(...)
            self.canClick=true
            self.effect:SetActive(false)
            self.delegate:showMsg(self.drop)
        end)
    end)
end

function m:consume(char)
	if self.model=="pet_fenjie" then 
		return TableReader:TableRowByID('rebirthCost', "7").args1
	else 
		return TableReader:TableRowByID('rebirthCost', "8").args1
	end 
end


function m:getChar(char)
    if char ~= nil then
        if self.item ~= nil then
            self.item.gameObject:SetActive(true)
        end
        self.rewardView.gameObject:SetActive(true)
        self.char = char
        self.name.text = char:getDisplayName()
        self.equip.gameObject:SetActive(true)
        self.btn_add.gameObject:SetActive(false)
        self.equip:LoadByModelId(self.char.modelid, "idle", function() end, false, 100, 1)
        self.img_bt:SetActive(false)
        self:showReward()
        self.bt_restore.isEnabled = true
    else
        self.char = nil
        self.equip.gameObject:SetActive(false)
        self.btn_add.gameObject:SetActive(true)
        self.name.text = ""
        self.rewardView:refresh({}, self)
        self.zs_num.text = "0"
        self.bt_restore.isEnabled = false
    end
end

function m:showReward(...)
    self.dropTypeList = {}
	if self.model=="pet_fenjie" then 
		Api:decomposeShowDropPet(self.char.id, function(result)
			local drop = self:getDrop(result.drop)
			self.drop = drop
			self.rewardView:refresh(self.drop, self)
            self.zs_num.text = result.consume[0].consume_arg
            for k, v in pairs(self.drop) do
                table.insert(self.dropTypeList, v.type)
            end
			end, function()
			end)
	else
		Api:petBirthShowDrop(self.char.id, function(result)
			local drop = self:getDrop(result.drop)
			self.drop = drop
			self.rewardView:refresh(self.drop, self)
            self.zs_num.text = result.consume[0].consume_arg
            for k, v in pairs(self.drop) do
                table.insert(self.dropTypeList, v.type)
            end
			end, function()
			end)
	end
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

function m:reBirth_two(go)
    -- 展示奖品信息
    if self.model=="pet_fenjie" then 
    	UIMrg:pushWindow("Prefabs/moduleFabs/recycleModule/gui_rewards_show", {
                    title = TextMap.GetValue("Text_1_998"),
                    content = TextMap.GetValue("Text_1_999"),
                    content1="",
                    teams = self.teams,
                    delegate = self,
                    callback = self.reBirth,
                    rewardList = self.drop,
                    consume=self.zs_num.text
                    })
    else
    	UIMrg:pushWindow("Prefabs/moduleFabs/recycleModule/gui_rewards_show", {
                    title = TextMap.GetValue("Text_1_985"),
                    content = TextMap.GetValue("Text_1_1000"),
                    content1="",
                    teams = self.teams,
                    delegate = self,
                    callback = self.reBirth,
                    rewardList = self.drop,
                    consume=self.zs_num.text
                    })
    end
end

function m:reBirth()
	if self.model=="pet_fenjie" then 
		Api:decomposePet(self.char.id, function(result)
			self:getChar()
            LuaMain:refreshTopMenu()
            self.canClick=false
			--self["ziyuanNum1"].text = toolFun.moneyNumberShowOne(math.floor(tonumber(Tool.getCountByType("shouhun"))))
			self:showEffect()
            self:checkOpenSelect()
			end, function()
			end)
	else
		Api:petBirth(self.char.id, function(result)
			self:getChar()
            self.canClick=false
			self:showEffect()
            self:checkOpenSelect()
			end, function()
			end)
	end
end

--去宠物商店
function m:onGoShop(go)
    local shoptype = 0
    TableReader:ForEachLuaTable("shop_refresh", function(k, v)
        if v.shop ==1 then 
            shoptype=v.sell_type
        end
        return false
        end)
    UIMrg:pop()
    local binding
    if shoptype==0 then 
        binding=Tool.push("store","Prefabs/moduleFabs/puYuanStoreModule/store",{1})
    else 
        binding=Tool.push("store","Prefabs/moduleFabs/puYuanStoreModule/storeTwo",{1})
    end
    binding:CallTargetFunction("updateOpenPath",true) 
end

function m:isChoose(go)
    if self.char == nil then --进入选择界面
        self.effect:SetActive(false)
        self:onSelect()
    else
        self:getChar()
        self.char = nil
    end
end

function m:onClick(go, name)
    if name == "bt_restore" then
        if Tool:judgeBagCount(self.dropTypeList) == false then return end
        self:reBirth_two(go)
    elseif name == "btn_add" or name == "btn_hero" or name=="btn_equip" then
        if self.canClick then 
            self:isChoose(go)
        end 
    elseif name == "blackShop" then
        if self.canClick then 
            self:onGoShop(go)
        end 
    end
end

function m:Start(...)
    self.img_bt:SetActive(true)
    self.bt_restore.isEnabled = false --开始状态没有英雄不可以点击
end

function m:create(binding)
    self.binding = binding
    return self
end

return m