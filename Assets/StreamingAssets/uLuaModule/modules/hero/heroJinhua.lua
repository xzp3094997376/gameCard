
-- 进化
local starUp = require("uLuaModule/modules/char/sub/uStarUp.lua")

local m = {}
-- 灵魂石
function m:pieceInfo(char)
    local piece = char:getPiece()
    --获取进化所需要的灵魂石数据
    --    local info = piece:pieceInfo(char.star_level)
    --    self._pieceValue = info.value
    --    self.slider.value = info.value
    --    self.txt_count.text = info.desc
    if Tool.GetCharArgs("max_power_Leader") == char.star_level then
        self.binding:Hide("btn_starUp")
        self.Panel:SetActive(false)
        return
    else
        self.Panel:SetActive(true)
        self.binding:Show("btn_starUp")
    end

    local ret = true
    --材料
    local row = TableReader:TableRowByUniqueKey("consume_starUp", char.Table.starUpid, char.star_level + 1)
    if row then
        local consume = RewardMrg.getConsumeTable(row.consume, char.dictid)
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
				if t == "char" then 
					max = Tool.getCountByType(v:getType(), v.dictid)
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
        local lv = Tool.GetCharArgs("star_" .. char.star_level + 1 .. "_need_level")
		if lv == nil then 
			self.txt_need.text = ""
			return 
		end
		if self.char.lv < lv then 
			self.txt_need.text = string.gsub(TextMap.GetValue("Text91"),"{0}",lv)
			self.txt_need.color = Color.red
		else 
			self.txt_need.text = string.gsub(TextMap.GetValue("Text91"),"{0}",lv)
			self.txt_need.color = Color.green
		end 
        --if self.char.lv < lv then
            --self.effect:SetActive(false)
            --self.btn_name.text = TextMap.getText("TXT_XIULIAN_LEVEL", { lv })
			--self.txt_need.text = TextMap.getText("TXT_XIULIAN_LEVEL", { lv })
        --else
            --self.effect:SetActive(ret)
			--self.txt_need.text = ""--TextMap.getText("TXT_JINHUA", {})
            --self.btn_name.text = TextMap.getText("TXT_JINHUA", {})
        --end
    end

    self.isCanJingHua = ret
    -- self.efBtnEvolve:SetActive(info.value == 1 and char.star_level < info.max) --可进化特效
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
    --    local txtList = self.char:getAttrList(descIndex, numList, "+")
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
    --    local money = self.char:startUpNeed()
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
	
    local lv = Tool.GetCharArgs("star_" .. self.char.star_level + 1 .. "_need_level")
	if lv == nil then return end 
    if self.char.lv < lv then
        MessageMrg.show(TextMap.TXT_NEED_CHAR_LEVEL .. lv)
        return
    end

    local that = self
    --    local list = self.char.info.propertys
    --DialogMrg.ShowDialog(string.gsub(TextMap.TXT_STAR_UP_NEED_MONEY, "{0}", self.costMoney), function()
        local char = Char:new(that.char.id)
        local data_before = {}
        data_before[1] = char:getAttrSingle("MaxHp", true)
        data_before[2] = char:getAttrSingle("PhyAtk", true)
        --data_before[3] = char:getAttrSingle("MagAtk", true)
        data_before[3] = char:getAttrSingle("PhyDef", true)
        data_before[4] = char:getAttrSingle("MagDef", true)
        local power = char.power
        Api:charStarUp(that.char.id, function(result)
			that.refresh = true
            that.char:updateInfo()
            power = that.char.power - power
            if power and power > 0 then
                local list = { TextMap.GetValue("Text1055") .. power }
                OperateAlert.getInstance:showToGameObject(list, that.gameObject)
            end

            starUp.Show({
                oldchar = char,
                data_before = data_before,
                char = that.char,
				skillname = that.skill_name or "",
				skilldes = that.skill_des or ""
            })
			m:onUpdate(that.char)
            Events.Brocast('updateChar')
            --            local newList = self.char.info.propertys
            --            that:dropNumber(list, newList)
            self.delegate:updateHeroInfo(self.char)
        end, function(ret)

            return false
        end)
    --end)
end

function m:playEffect()
    self.effect_levelup:SetActive(false)
    self.effect_levelup:SetActive(true)
end

local imageCount = 0
function m:setImage()
    local ret = self.char.star_level >= 6
    self.img_hero:LoadByModelId(self.char.modelid, "idle", function() end, false, -1, 1)
    self.img_hero2:LoadByModelId(self.char.modelid, "idle", function() end, false, -1, 1, 50)
	
    imageCount = imageCount + 1
    if (imageCount > 15) then
        ClientTool.release()
        imageCount = 0
    end
end

--添加碎片
function m:onAddPiece(go)
    DialogMrg.showPieceDrop(self.char)
end

function m:onClick(go, name)
    if name == "btn_starUp" then
        self:onStarUp(go)
    elseif name == "btn_addPiece" then
        self:onAddPiece(go)
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
	local atr2_n, atr2 = GetAttrNew("PhyAtk", propertys, true)
	local pd2_n, pd2 = GetAttrNew("PhyDef", propertys, true)
	local life2_n, life2 = GetAttrNew("MaxHp", propertys, true)
	local md2_n, md2 = GetAttrNew("MagDef", propertys, true)
	
	local life1, life1_str = self.char:getAttrSingle("MaxHp", false)
	local attack1, attack1_str = self.char:getAttrSingle("PhyAtk",false)
	local defense1, defense_str = self.char:getAttrSingle("PhyDef",false)
	local magicDense1, magicDense_str = self.char:getAttrSingle("MagDef",false)
	
	self.txt_attr_left.text = attack1_str .. "\n" .. defense_str
	self.txt_attr_right.text = life1_str .. "\n" .. magicDense_str
	self.txt_atk.text = string.gsub("{0}", "{0}", "[ffffff]" .. atr2 .. "[-]")
	self.txt_life.text = string.gsub("{0}", "{0}", "[ffffff]" .. life2 .. "[-]")
	self.txt_pd.text = string.gsub("{0}", "{0}", "[ffffff]" .. pd2 .. "[-]")
	self.txt_md.text = string.gsub("{0}", "{0}", "[ffffff]" .. md2 .. "[-]")
	local atkadd = math.floor(atr2_n - attack1)
	local lifeadd = math.floor(life2_n - life1)
	local pdadd = math.floor(pd2_n - defense1)
	local mdadd = math.floor(md2_n - magicDense1)
	self.txt_atk_add.text = atkadd .. ""
	self.txt_life_add.text = lifeadd .. ""
	self.txt_pd_add.text =  pdadd .. ""
	self.txt_md_add.text = mdadd .. ""
end

function m:onUpdate(char, ret)
    self.char = char
    --    if ret == nil then
    --        self.delegate:onUpdate()
    --    end
    self:pieceInfo(self.char)
    self.txt_name.text = self.char:getItemColorName(self.char.star, self.char.name .. " [00ff00]+" ..(self.char.star_level).."[-]")
	self.txt_name2.text = self.char:getItemColorName(self.char.star, self.char.name .. " [00ff00]+" ..(self.char.star_level + 1).."[-]") 
	if self.isMax == true then 
		self.txt_name2.text = self.txt_name.text
		m:updateDesc(self.char.info.propertys)
		self.btn_starUp.isEnabled = false
		self.txt_next_title.text = TextMap.GetValue("Text_1_811")
	else
		self.btn_starUp.isEnabled = true
		self.txt_next_title.text = TextMap.GetValue("Text_1_812")
		if self.refresh == true then
			self.refresh = false
			Api:getCharProperty(self.char.id, 0 , 0, 1, 0, function(result)
				m:updateDesc(result.propertys)
			end)
		end
	end
 
	local star_level = char.star_level
	local row = TableReader:TableRowByUniqueKey("consume_starUp", char.Table.starUpid, star_level)
	if row then
       m:setImage()
	end
	-- 进阶之后是否有天赋技能
	local that = self
	local tb = TableReader:TableRowByUniqueKey("unlock_skill", "starup_skill", self.char.star_level+1)
	--TableReader:ForEachLuaTable("unlock_skill", function(index, item)
    --    if item.skill_type == "starup_skill" and item.unlock_condition == "starup" and item.unlock_arg == that.char.star_level+1 then 
	--		tb = item
	--		return true
	--	end 
    --    return false
    --end)
	if tb ~= nil then
        local skillId
        if self.char.quality == 5 and self.char.star == 6 then
            local huaSInfo = TableReader:TableRowByUniqueKey("qualitylevel", self.char.dictid, Player.Chars[self.char.id].qualitylvl)
            if huaSInfo ~= nil then
                local hsSkillList = TableReader:TableRowByID("qualitylevelattrib", huaSInfo.skilllvlid)
                if hsSkillList ~= nil then
                    skillId = hsSkillList.starup_skill[tb.skill_slot-1]
                end
            end
        else
            skillId = self.char.modelTable.starup_skill[tb.skill_slot-1]
        end
		if skillId == nil then print("天赋技能没有配置， 或者配置错误！") return end 
		local sk = TableReader:TableRowByID("skill", skillId)
		if sk ~= nil then 
			self.txt_skill_name.text = TextMap.GetValue("Text_1_813") .. sk.show .. ""
			self.txt_skill_des.text = sk.desc_eff
			
			self.skill_name = self.txt_skill_name.text
			self.skill_des = self.txt_skill_des.text
		end 
	else 
		self.skill:SetActive(false)
	end 
end

function m:hideEffect()
end

function m:OnEnable()
    self:onUpdate(self.char, true)
end

function m:update(lua)
    self.delegate = lua.delegate
    self.char = lua.char
    self:onUpdate(lua.char, true)
end

function m:Start()
	self.refresh = true
end 

return m



