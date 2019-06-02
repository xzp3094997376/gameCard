local m = {}
local isChoose = false
local isFirst = true
local ChooseList = {}

function m:update(lua)
    self:RestAllStatus()
    self.index = lua.index
    self.char = lua.char
    self.delegate = lua.delegate
    local char = self.char
    self.labName.text = char:getDisplayName() --名字
	if self.__itemAll == nil then
        self.__itemAll = ClientTool.loadAndGetLuaBindingFromPool("Prefabs/publicPrefabs/itemAll", self.gd_frame.gameObject)
    end
    self.__itemAll:CallUpdate({ "treasure", self.char, self.gd_frame.width, self.gd_frame.height, true, nil, nil, false})
	
    if self.delegate._tp == "treasure"  or self.delegate._tp == "smelt" then
        self.txt_desc.text = char:GetTreasureBaseProperty(0)
        self.txt_power.text = char.lv
        if char.star==1 then 
            self.Sprite.spriteName="dengji_baise"
        elseif char.star==2 then 
            self.Sprite.spriteName="dengji_lvse"
        elseif char.star==3 then 
            self.Sprite.spriteName="dengji_lanse"
        elseif char.star==4 then 
            self.Sprite.spriteName="dengji_zise"
        elseif char.star==5 then 
            self.Sprite.spriteName="dengji_chengse"
        elseif char.star==6 then 
            self.Sprite.spriteName="dengji_hongse"
        end 
		self.binding:Hide("img_frame")
        self.binding:Show("gd_frame")
        self.gd_frame.spriteName = self.char:getFrameNormal()
        local name = self.char:getHeadSpriteName()
        local atlasName = packTool:getIconByName(name)
        --self.icon:setImage(name, atlasName)

        if self.delegate._subtp == "treasure_equip" or self.delegate._subtp == "treasure_reborn" then
            --self.txt_power.text = TextMap.GetValue("Text1751") .. char.power
        elseif self.delegate._subtp == "treasure_cost" then
            self.txt_desc.text = TextMap.GetValue("Text1752") .. char:getTreasureExp()
            if isFirst then
                if lua.delegate.hasSelect ~= nil then
                    ChooseList = lua.delegate.hasSelect
                end
                isFirst = false
            end
            for k,v in pairs(ChooseList) do
                if self.char.key == v.key then
                    self.selected_sp:SetActive(true)
                    isChoose = true
                end
            end
        end
        --self.sp_select:SetActive(self.delegate._subtp == "treasure_cost")
    end
end

function m:updateState()
    if self.delegate._tp == "ghost" then self.binding:Hide("num") return end
    self.count = self.delegate:getCount(self.char.id) or 0
    self.num.text = self.count
end


function m:onClick(uiButton, eventName)
    if self.delegate._tp == "treasure" then
        if self.delegate._subtp == "treasure_equip" then
            Api:treasureOn(self.char.charid, self.char.pos,self.char.key, function()
            	print("宝物装备成功")
                Events.Brocast('selectedTreasure', self.char)
				if self.delegate.callback ~= nil then self.delegate.callback() end 
            end,function ( ... )
            	print("宝物装备失败")
            end)
        elseif self.delegate._subtp == "treasure_cost" then
            self.delegate:SelectCostCallBack(self.char,self)
        elseif self.delegate._subtp == "treasure_reborn" then
            --Events.Brocast('selectedRebornTreasure', self.char)
            self.delegate:getChar(self.char)
        end 
    elseif self.delegate._tp == "smelt" then
        self.delegate:OnSelect(self.char)
    end
end

function m:IsSelect()
    isChoose = not isChoose
    self.selected_sp:SetActive(isChoose)
    
    if isChoose then
        table.insert(ChooseList,self.char)
    else
        for k,v in pairs(ChooseList) do
            if self.char == v then
                table.remove(ChooseList,k)
            end
        end
    end
end

function m:isChooseValue()
    return isChoose
end

function m:RestAllStatus()
    isChoose = false
    self.selected_sp:SetActive(isChoose)
end

return m

