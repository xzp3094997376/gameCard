local MyTips = {}
local tempNumLY = 0
--设置每个物品的详细信息，temp可以是itemVo类型数据，也可以是char类型数据

function MyTips:destory()
    UIMrg:pop()
end


--temp基础数据
function MyTips:update(temp)
    if temp == nil then
        MyTips:destory()
        return
    end
	
	-- type = 1, 去掉向左向右按钮
	-- type = 2, 布阵过来的
	self.type = temp.type
	
    self.itemData = temp.obj
    local itemData = temp.obj
    local tempObj = {}
    self:onUpdate()
end

function MyTips:Start()
	self.skill_pos = self.skill_line.transform.localPosition
    self.Godskill.gameObject:SetActive(false)
	--self.des_pos = self.des_line.transform.localPosition
end

function MyTips:onUpdate()
	local itemData = self.itemData
	itemData:updateInfo()
	self.txt_mingcheng.text = itemData.itemColorName
    self.img_kuangzi.enabled = false

    if self.txt_mingcheng.text == nil or self.txt_mingcheng.text == "" then
        self.txt_mingcheng.text = itemData:getDisplayColorName()
    end

    --self.txt_shuliang.text = "拥有数量：" .. packTool.getNumByID(itemData:getType(), itemData.id)
    itemData.rwCount = 1
    --infobinding = ClientTool.loadAndGetLuaBindingFromPool("Prefabs/publicPrefabs/itemAll", self.img_pos.gameObject)
    --infobinding:CallUpdate({ "char", itemData, self.img_kuangzi.width, self.img_kuangzi.height })
    self.img_kuangzi.Url = itemData:getHead()
	tempObj = itemData.Table

    self.item_type_txt.text = itemData:getTreasureKindName()
    MyTips:SetMainSX(itemData:getType(), itemData.id)
    
    tempNumLY = tempObj._droptype.Count
    

    ---计算简介以上的位置---
    --self.skill_line:SetActive(itemData.star == 6)
    self.skill_line:SetActive(false)
    self.txt_skill.text = itemData:GetImmortalitySkill()
    --local base_pos = self.txt_jinglian.gameObject.transform.localPosition.y - self.txt_jinglian.height
    --if itemData.star == 6 then
    -- 	self.des_line.transform.localPosition = self.des_pos   
	--else 
		--self.des_line.transform.localPosition = Vector3(self.des_line.transform.localPosition.x, self.skill_pos.y, 0)
   -- end
    --print(self.txt_skill.gameObject.transform.localPosition.y)
    --print(self.txt_skill.height)
    --self.des_line.transform.localPosition = Vector3(80,base_pos-17,0)
    ---计算简介以上的位置---

    self.txt_desc.text = tempObj.desc--"[f1e081]" .. tempObj.desc

    --self.ButtonGroup.gameObject:SetActive(self.itemData.key ~= nil and self.itemData.kind ~= "jing")
    if self.itemData.key ~= nil then
        self.btn_xiexia.gameObject:SetActive(self.itemData.onPosition)
        self.btn_replace.gameObject:SetActive(self.itemData.onPosition)
    end
    if not self.itemData.onPosition then
    end
	if self.type == 1 then 
		self.btn_left.gameObject:SetActive(false)
		self.btn_right.gameObject:SetActive(false)
		self.btn_replace.gameObject:SetActive(false)
		self.btn_xiexia.gameObject:SetActive(false)
	end 

    local data = TableReader:TableRowByID("treasure", itemData.id)
    if data ~= nil then
        if data.can_powerUp == 0 then
            self.btn_strength.gameObject:SetActive(false)
        elseif data.can_powerUp == 1 then
            self.btn_strength.gameObject:SetActive(true)
        end  

        if data.can_lvUp == 0 then
            self.btn_jinglian.gameObject:SetActive(false)
        elseif data.can_powerUp == 1 then
            self.btn_jinglian.gameObject:SetActive(true)
        end  
    end
    MyTips:getGodSkillInfo()
end 

function MyTips:getGodSkillInfo()
    local godskillList = {}
    local godSkillMenu = Tool:getGodSkillListInfo()
    if godSkillMenu ~= nil then
        for i = 1, #godSkillMenu do
            local item = godSkillMenu[i]
            if item ~= nil and item.name == self.itemData.name then
                for j = 0, item._skillid.Count do
                    if item._skillid[j] ~= nil then
                        local skillId = item._skillid[j].id
                        local name = "[ffc864]【"..item._skillid[j].name.."】 [-]"
                        local desc = "[ffc864]"..item._skillid[j].desc.."[-][64ff64]（"..string.gsub(TextMap.GetValue("Text1812"), "{0}", item.unlock[j]).."）[-]"
                        if self.itemData.info.skill ~= nil then
                            for i = 0, self.itemData.info.skill.Count - 1 do
                                if self.itemData.info.skill[i] == skillId then
                                   name = string.gsub(name,"ffc864","FF0000")
                                   desc = "[ff0000]"..item._skillid[j].desc.."（"..string.gsub(TextMap.GetValue("Text1812"), "{0}", item.unlock[j]).."）[-]" 
                                   break
                                end
                            end                        
                        end
                        table.insert(godskillList, {skillId = skillId, name = name, desc = desc}) 
                    end
                end
            end
        end
    end
    if #godskillList > 0 then
        self.Godskill.gameObject:SetActive(true)
        self.Godskill:CallUpdate({list = godskillList, targetInfo = self.itemData})
    else
        self.Godskill.gameObject:SetActive(false)
        self.des_line:SetAnchor(self.Sprite_jinlian.gameObject, 
            0, -179, 0, -125)
    end
    --print_t(godskillList)
end

function MyTips:onEnter()
	self:onUpdate()
end

--显示道具、道具碎片、鬼道、鬼道碎片的主要属性
function MyTips:SetMainSX(itemType, itemID)
    self.txt_main_sx.text = self.itemData:GetTreasureBaseProperty(0)--str--"[f1e081]" .. str
    self.txt_jinglian.text = self.itemData:GetTreasureJLProperty(0)
    self.item_plv_txt.text = "[ffff96]" .. TextMap.GetValue("Text1118") .. "[-][ffffff]"..self.itemData.lv .. "[-] \n" .. self.itemData:GetTreasureBaseProperty(0)
	self.txt_jinglian_lv.text = "[ffff96]" .. TextMap.GetValue("Text1751").."：[-]"..self.itemData.power

end


function MyTips:onClick(go, name)
    --MyTips:destory()
    if name == "btn_xiexia" then
        local api_data = self.itemData:GetCharIDandPos()
        if api_data ~= nil then
            if api_data.charid ~= nil and api_data.pos ~= nil then
                Api:treasureDown(api_data.charid, api_data.pos , function()
                print(TextMap.GetValue("Text32"))
                Events.Brocast('selectedTreasure', self.itemData)
				UIMrg:pop()
                end, function()
                    print(TextMap.GetValue("Text1758"))
                end)
            end
        end

    elseif name == "btn_replace" then
        local api_data = self.itemData:GetCharIDandPos()
        if api_data ~= nil then
            if api_data.charid ~= nil and api_data.pos ~= nil then
                UIMrg:pushWindow("Prefabs/moduleFabs/guidao/guidao_select_charpiece", 
                    {kind = self.itemData.kind,type = "treasure",charid = api_data.charid,pos = api_data.pos,callback = MyTips.replaceCallback})
            end
        end
    elseif name == "btn_strength" then
       MyTips:GotoTreasureView("strength")
    elseif name == "btn_jinglian" then
       MyTips:GotoTreasureView("jinglian")
	elseif name == "btn_left" then 
		self:onLeft()
	elseif name == "btn_right" then 
		self:onRight()
	elseif name == "btnBack" then 
	   UIMrg:pop()
    end
end

function MyTips.replaceCallback()
	UIMrg:pop()
end 

function MyTips:onLeft()
	if self.allTreasures == nil then 
		self:findTreasureList()
	end  
	
	self.index = self.index - 1
	if self.index < self.minIndex then self.index = self.minIndex end 
	self:updateTreasure()
end 

function MyTips:onRight()
	if self.allTreasures == nil then 
		self:findTreasureList()
	end
	
	self.index = self.index + 1
	if self.index > self.maxIndex then self.index = self.maxIndex end 
	self:updateTreasure()
end 

function MyTips:updateTreasure()
	self:update({obj = self.allTreasures[self.index]})
end 

function MyTips:findTreasureList()
     local treasuresList = {} --未装备的所有宝物
    local treasures = Player.Treasure:getLuaTable()

    local list = {} --装备的宝物
    local explist = {} --经验宝物
    for k,v in pairs(treasures) do
       local _treasure = Treasure:new(v.id, k)
       if v.onPosition then
            table.insert(list, _treasure)
        else
            if _treasure.kind == "jing" then
                table.insert(explist, _treasure)
            else
                table.insert(treasuresList, _treasure)
            end
        end
    end

    -- 排列未装备的宝物
    table.sort(treasuresList, function(a, b)
        if a.star ~= b.star then return a.star > b.star end
        if a.power ~= b.power then return a.power > b.power end
        if a.lv ~= b.lv then return a.lv > b.lv end
        return a.id < b.id
    end)

    --排列装备的宝物
    table.sort(list, function(a, b)
        if a.star ~= b.star then return a.star > b.star end
        if a.power ~= b.power then return a.power > b.power end
        if a.lv ~= b.lv then return a.lv > b.lv end
        return a.id < b.id
    end)

    --排列EXP宝物
    table.sort(explist, function(a, b)
        if a.star ~= b.star then return a.star > b.star end
        return a.id < b.id
    end)


    for i = 1, #treasuresList do
        local v = treasuresList[i]
        table.insert(list, v)
    end

    for i=1,#explist do
        local sz = explist[i]
        table.insert(list, sz)
    end

    treasuresList = list
    if #treasuresList == 0 then
        MessageMrg.show(TextMap.GetValue("Text_1_2923"))
        return {}
    end
    for i = 1,#treasuresList do
        local t = treasuresList[i]
		if t.id == self.itemData.id then 
			self.index = i
		end 
    end

	self.minIndex = 1
	self.maxIndex = #treasuresList
    self.allTreasures = treasuresList
end

function MyTips:getData(data)
    local list = {}
    local row = 2
    for i = 1, table.getn(data), row do
        local li = {}
        local len = 0
        for j = 0, row - 1 do
            if data[i + j] then
                local d = data[i + j]
                d.realIndex = i + j
                li[j + 1] = d
                len = len + 1
            end
        end
        if len > 0 then
            table.insert(list, li)
        end
    end

    return list
end

function MyTips:GotoTreasureView(typemode)
    local infotemp = {}
    infotemp.treasure = self.itemData
    infotemp.typemode = typemode
    Tool.push("treasure_info","Prefabs/moduleFabs/TreasureModule/treasureInfo",infotemp)
end

return MyTips