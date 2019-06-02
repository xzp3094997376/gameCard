
-- 进化
local starUp = require("uLuaModule/modules/char/sub/uStarUp.lua")

local m = {}
-- 宠物碎片
function m:pieceInfo(pet)
	local star_max = TableReader:TableRowByID("yulingArgs","max_yuling_starup").value
    if tonumber(star_max) == pet.star_level then
        self.binding:Hide("btn_starUp")
        self.Panel:SetActive(false)
        return
    else
        self.Panel:SetActive(true)
        self.binding:Show("btn_starUp")
    end

    local ret = true
    --材料
    local row = TableReader:TableRowByUniqueKey("yulingstarUp", pet.id, pet.star_level + 1)
    if row then
        local consume = RewardMrg.getConsumeTable(row.consume, pet.id)
        local list = {}
        table.foreach(consume, function(i, v)
            local t = v:getType()
            if t == "money" then
                self.costMoney = toolFun.moneyNumber(math.floor(tonumber(v.rwCount)))
                local max = Tool.getCountByType("money")
                if v.rwCount > max then
                    self.txt_cost_money.text = "[ff2222]" .. self.costMoney .. "[-]"
                    ret = false
                else
                    self.txt_cost_money.text = self.costMoney
                end

            else
                local num = v.rwCount
                local max 
				if t == "yuling" then 
					max = Tool.getCountByType(v:getType(), v.id)
				else 
					max = Tool.getCountByType(v:getType(), v.id)
				end 
                if num > max then
                    num = "[ff0000]" .. max .. "[-][00ff00]/" .. num.."[-]"
                    ret = false
                else
                    num = "[00ff00]".. max .. "/" .. num .. "[-]"
                end
                v.rwCount = 1

                table.insert(list, {
                    item = v,
                    num = num
                })
            end
        end)
        ClientTool.UpdateGrid("", self.Grid, list)
	else 
		ret = false
		self.isMax = true
		self.Grid.gameObject:SetActive(false)
    end

    if self.isMax == nil or self.isMax == false then
        local lv = row.limitLv
		if lv == nil then 
			self.txt_need.text = ""
			return 
		end 
		if self.pet.lv < lv then 
			self.txt_need.text =string.gsub(TextMap.GetValue("Text91"),"{0}",lv)
			self.txt_need.color = Color.red
		else 
			self.txt_need.text =string.gsub(TextMap.GetValue("Text91"),"{0}",lv)
			self.txt_need.color = Color.green
		end 
		--self.txt_need.text = TextMap.getText("TXT_XIULIAN_LEVEL", { lv })
    end

    self.isCanJingHua = ret
    -- self.efBtnEvolve:SetActive(info.value == 1 and pet.star_level < info.max) --可进化特效
end

function m:dropNumber(list, newList)
    local descIndex = {}
    local numList = {}
    for i = 0, list.Count - 1 do
        if list[i] ~= newList[i] then
            table.insert(descIndex, i)
            numList[i] = newList[i] - list[i]
        end
    end
    --    local txtList = self.pet:getAttrList(descIndex, numList, "+")
    --TODO
    --    OperateAlert.getInstance:showToGameObject(txtList, self.hero.gameObject)
    --    self.delegate:showOperateAlert(txtList)
end


--进化
function m:onStarUp(go)
    --TODO
    --    if self._pieceValue < 1 then
    --        MessageMrg.show(TextMap.TXT_NO_CHAR_PIECE)
    --        return
    --    end
    --    local money = self.pet:startUpNeed()
    --    if money == nil then
    --        MessageMrg.show(TextMap.TXT_TOP_STAR)
    --        return
    --    end
    --    if self.isCanJingHua == false then
    --        MessageMrg.show(TextMap.getText("TXT_NOT_ITEM"))
    --        return
    --    end
	if self.isMax == true then 
		MessageMrg.show(TextMap.TXT_TOP_STAR)
		return 
	end 
	local row = TableReader:TableRowByUniqueKey("yulingstarUp", self.pet.id, self.pet.star_level + 1)
    local lv = row.limitLv
	if lv == nil then return end 
    if self.pet.lv < lv then
        MessageMrg.show(TextMap.GetValue("Text9") .. lv)
        return
    end

	local that = self
    local pet = self.pet
    local data_before = {}
    data_before[1] = pet:getAttrSingle("MaxHp", true)
    data_before[2] = pet:getAttrSingle("PhyAtk", true)
    data_before[3] = pet:getAttrSingle("PhyDef", true)
    data_before[4] = pet:getAttrSingle("MagDef", true)
    local power = pet.power
    Api:yulingStarUp(that.pet.id, function(result)
	that.refresh = true
        power = that.pet.power - power
        if power and power > 0 then
            local list = { TextMap.GetValue("Text1055") .. power }
            OperateAlert.getInstance:showToGameObject(list, that.gameObject)
        end

        starUp.Show({
            oldchar = pet,
            data_before = data_before,
            char = that.pet,
			killname = that.skill_name or "",
			killdes = that.skill_des or ""
        })
		--that.pet:updateInfo()
		that:onUpdate(that.pet)
        self.delegate:updateRedPoint()
		Events.Brocast('updateChar')
    end, function(ret)

        return false
    end)
end

function m:playEffect()
    self.effect_levelup:SetActive(false)
    self.effect_levelup:SetActive(true)
end

--添加碎片
function m:onAddPiece(go)
    DialogMrg.showPieceDrop(self.pet)
end

function m:onClick(go, name)
    if name == "btn_starUp" then
        self:onStarUp(go)
    elseif name == "btn_shop" then
        uSuperLink.openModule(16)
    end
end

function m:updateDesc(propertys)
    --[[
        hp = "MaxHpV", --生命
        pAtk = "PhyAtkV", --物理攻击
        pDef = "PhyDefV", --物理防御
        mAtk = "MagAtkV", --法术攻击
        mDef = "MagDefV", --法术防御
    ]]
	local atr2 = self.pet:GetAttrNew("PhyAtk", propertys,true)
	local pd2 = self.pet:GetAttrNew("PhyDef", propertys,true)
	local life2 = self.pet:GetAttrNew("MaxHp", propertys,true)
	local md2 = self.pet:GetAttrNew("MagDef", propertys,true)
	
	local life1, life1_str = self.pet:getAttrSingle("MaxHp", false)
	local attack1, attack1_str = self.pet:getAttrSingle("PhyAtk",false)
	local defense1, defense_str = self.pet:getAttrSingle("PhyDef",false)
	local magicDense1, magicDense_str = self.pet:getAttrSingle("MagDef",false)
	
	self.txt_attr_left.text = attack1_str .. "\n" .. defense_str
	self.txt_attr_right.text = life1_str .. "\n" .. magicDense_str
	self.txt_atk.text = "[00ff00]" .. atr2 .. "[-]" 	
	self.txt_life.text = "[00ff00]" .. life2 .. "[-]" 	
	self.txt_pd.text = "[00ff00]" .. pd2 .. "[-]" 
	self.txt_md.text = "[00ff00]" .. md2 .. "[-]" 		
end

function m:onUpdate(pet, ret)
	if pet == nil then return end 
    self.pet = pet
    local star_max = TableReader:TableRowByID("yulingArgs","max_yuling_starup").value
    if self.isMax == nil then
        if self.pet.star_level >= tonumber(star_max) then 
			self.isMax = true 
		else 
			self.isMax = false
		end 
    end
    self:pieceInfo(self.pet)
	if self.isMax == true then 
		m:updateDesc(self.pet.info.propertys)
	else
		if self.refresh == true then
			self.refresh = false
			Api:getyulingProperty(self.pet.id, 0 , 1, function(result)
				m:updateDesc(result.propertys)
			end)
		end
	end
	local star_level = pet.star_level
	local starLists = {}
	local showStar = false
    for i =1, tonumber(star_max) do
		showStar = false
		if i <= star_level then 
			showStar = true
		end
        starLists[i] = { isShow = showStar }
    end
	self.stars_left:refresh("", starLists, self)
	local nextStar = star_level + 1
	if nextStar >= 5 then 
		nextStar = 5
	end 
	starLists = {}
	showStar = false
    for i =1, tonumber(star_max) do
		showStar = false
		if i <= nextStar then 
			showStar = true
		end
        starLists[i] = { isShow = showStar }
    end
	self.stars_right:refresh("", starLists, self)
	
	local row = TableReader:TableRowByUniqueKey("yulingstarUp", pet.id, star_level)
	local row2 = TableReader:TableRowByUniqueKey("yulingstarUp", pet.id, nextStar)
	if row then 
		self.txt_skill_add.text = TextMap.GetValue("Text_1_874") .. (row.skill_dmg / 10) .. "%"
		self.txt_skill_name.text = "[ffff96]" .. row.desc .. "[-]"
	else 
		self.txt_skill_add.text = TextMap.GetValue("Text_1_874") .. "0%"
		-- local id = self.pet.info.skill[0].skill_id
		-- if id ~= nil then 
		-- 	local tb = TableReader:TableRowByID("skill", id)
		-- 	self.txt_skill_name.text = "[ffff96]" .. tb.show .. "[-]"
		-- end 
	end 
	if row2 then 
		self.txt_skill_add_r.text = TextMap.GetValue("Text_1_875") .. (row2.skill_dmg / 10) .. "%[-]"
		self.txt_skill_name_r.text = "[ffff96]" .. row2.desc .. "[-]"
	else 
		self.txt_skill_add_r.text = TextMap.GetValue("Text_1_875") .. "0%[-]"
	end 
	-- 进阶之后是否有天赋技能
	--local that = self
	--local tb = nil 
	--TableReader:ForEachLuaTable("unlock_skill", function(index, item)
    --    if item.skill_type == "starup_skill" and item.unlock_condition == "starup" and item.unlock_arg == that.pet.star_level then 
	--		tb = item
	--		return true
	--	end 
    --    return false
    --end)
	--if tb ~= nil then 
	--	local skillId = self.pet.modelTable.starup_skill[tb.skill_slot]
	--	if skillId == nil then print("天赋技能没有配置， 或者配置错误！") return end 
	--	local sk = TableReader:TableRowByID("skill", skillId)
	--	if sk ~= nil then 
	--		self.txt_skill_name.text = TextMap.GetValue("Text_1_813") .. sk.name .. ""
	--		self.txt_skill_des.text = sk.desc_eff
	--		
	--		self.skill_name = self.txt_skill_name.text
	--		self.skill_des = self.txt_skill_des.text
	--	end 
	--else 
	--	self.skill:SetActive(false)
	--end 
end

function m:hideEffect()
end

function m:OnEnable()
    self:onUpdate(self.pet, true)
end

function m:Start()
	self.refresh = true
end

function m:update(lua)
    self.delegate = lua.delegate
    self.pet = lua.pet
    self:onUpdate(self.pet, true)
end

return m



