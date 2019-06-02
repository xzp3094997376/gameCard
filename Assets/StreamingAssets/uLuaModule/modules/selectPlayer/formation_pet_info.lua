--
local m = {}

function m:update(lua)
    self.delegate = lua.delegate
    self.index = lua.index
	self.pet = lua.pet
    self:onUpdate(true)
end

function m:onUpdate(ret)
    local pet = self.pet
    if self.pet == nil then
        self.binding:Hide("hero")
        self.binding:Hide("heromodel")
        self.binding:Hide("btn_xiexia")
        self.binding:Hide("btnChange")
        self.binding:Hide("Panel")
        self.binding:Hide("left")
        self.binding:Hide("img_type")
        self.binding:Hide("Sprite1")
        self.binding:Hide("Sprite2")
        self.binding:Show("jianying")
		for i = 1, 6 do 
			self["txt_attr"..i].text = ""
			self.txt_skill1.text = ""
			self.txt_skill2.text = ""
		end 
        self.txt_btn_name.text = TextMap.GetValue("Text1138")
        self.txt_name.text = ""
        return
    end
	self.binding:Show("hero")
    self.binding:Show("heromodel")
    self.binding:Show("btn_xiexia")
    self.binding:Show("btnChange")
    self.binding:Show("Panel")
    self.binding:Show("left")
	self.binding:Show("img_type")
	self.binding:Show("Sprite1")
    self.binding:Show("Sprite2")
	self.binding:Hide("jianying")
	
    -- self.btn_check:SetActive(false)
	local row = TableReader:TableRowByUniqueKey("petShenlian", pet.dictid, pet.shenlian)
	self.pos_pet:CallUpdate(row)
	local list = Tool.getPetStarList(self.pet.star_level)
	self.stars:refresh("", list, self)
	
    self.top:SetActive(true)
    self.txt_btn_name.text = TextMap.GetValue("Text1139")
	self.img_type.spriteName = "chongwu_" .. self.pet.star
	self.txt_power.text = pet.power
    self.txt_name.text = Tool.getNameColor(pet.star) .. pet:getDisplayName() .. "[-]"
	local tb = TableReader:TableRowByID("skill", tonumber(pet.modelTable.normal_skill))
	self.txt_skill1.text = tb.show
	local sid = Player.Pets[pet.id].skill[0].skill_id
	local tb2 = TableReader:TableRowByID("skill", sid)
	self.txt_skill2.text = tb2.show
	self.heromodel:LoadByModelId(pet.modelid, "idle", function() end, false, 100, 1)
	self:updateInfos()
end

function m:updateInfos()
    local pet = self.pet
    if pet == nil or pet.empty then return end

    local attr1 = string.gsub(TextMap.GetValue("LocalKey_748"),"{0}",pet.lv) -- 等级

    local attr2 = pet:getAttrSingleForGhost("MaxHp") -- 最大生命
    local attr3 = pet:getAttrSingleForGhost("PhyAtk") -- 物理攻击
    local attr4 = pet:getAttrSingleForGhost("PhyDef") -- 物理防御
    --local attr5 = pet:getAttrSingleForGhost("MagAtk") -- 灵术攻击
    local attr6 = pet:getAttrSingleForGhost("MagDef") -- 灵术防御


    self.txt_attr1.text = attr1
    self.txt_attr2.text = attr2
    self.txt_attr3.text = attr3
    self.txt_attr4.text = attr4
    --self.txt_attr5.text = attr5
    self.txt_attr6.text = attr6
end

function m:getBestGhostByType(pos, list)
    if #list == 0 then return "" end
    table.sort(list, function(a, b)
        if a.star ~= b.star then return a.star > b.star end
        if a.power ~= b.power then return a.power > b.power end
        if a.lv ~= b.lv then return a.lv > b.lv end
        return false
    end)
    if list[1] then return pos .. ":" .. list[1].key end
    return ""
end

function m:onXieXia()
	Api:petOffTeam(function(ret)
		if ret.ret == 0 then 
			self.pet = nil
			m:onUpdate()
			self.delegate:refreshIcon()
		end
	end, nil)
end

function m:onClick(go, name)
	if name == "btn_xiexia" then 
		m:onXieXia()
    elseif name == "btnChange" then
        --下一阵位解锁
        if self.pet.empty == true then
            local lv = TableReader:TableRowByID("playerArgs", "pet_slot").value
            MessageMrg.show(string.gsub(TextMap.GetValue("Text111"),"{0}",lv))
            return
        end
        local bind = UIMrg:pushWindow("Prefabs/moduleFabs/formationModule/formation/formation_select_char")
        bind:CallUpdate({ type = "pet", module = "ghost", delegate = self.delegate, index = 7 })
	elseif name == "bg" then 
		--if self.pet:getType() == "pet" then 
		--	UIMrg:pushWindow("Prefabs/moduleFabs/formationModule/formation/hero_property", self.pet)
		--end 
    end
end

function m:OnDestroy()

end

function m:exit()

end

function m:showInfo()
    if self.pet == nil then return end
    Tool.push("pet_info", "Prefabs/moduleFabs/hero/pet_info", self.pet)
end

function m:Start()
    ClientTool.AddClick(self.hero, funcs.handler(self, self.showInfo))
end

return m

