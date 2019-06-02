local m = {} 

function m:update(data)
	self.DaojuTips_panel.depth = 30
	self.data = data.obj
	
	--print_t(self.data)
	local atlasName
	self.Sprite_Piece.gameObject:SetActive(false)
	if self.data.itemTable ~= nil then
		if m:resTypeId(self.data.itemType) then
			self.txt_shuliang.text = TextMap.GetValue("Text_1_2806")..toolFun.moneyNumberShowOne(math.floor(tonumber(Player.Resource[self.data.itemType])))
			local desc = TableReader:TableRowByUnique("resourceDefine", "name", self.data.itemType).desc
			if desc ~= nil then
				self.txt_desc.text = desc
			else
				self.txt_desc.text = self.data.itemType
			end 
		elseif self.data.itemType == "equip" then 
			self.txt_shuliang.text = TextMap.GetValue("Text_1_2806")..Player.EquipmentBagIndex[self.data.itemTable.id].count--m:getServerPackData(self.data.itemTable.id)
			self.txt_desc.text = self.data.itemDes
		else
			self.txt_shuliang.text = TextMap.GetValue("Text_1_2806")..Player.ItemBagIndex[self.data.itemTable.id].count--m:getServerPackData(self.data.itemTable.id)
			self.txt_desc.text = self.data.itemPro
		end
		self.txt_mingcheng.text = self.data.itemColorName
		self.img_kuangzi.spriteName = self.data.itemColor
		self.img_bg.spriteName = self.data.itemColorBG
		if self.data.itemType == "item" or m:resTypeId(self.data.itemType) then
			atlasName = "itemImage"
		elseif self.data.itemType == "treasurePiece" then
			atlasName = "equipImage"
			self.Sprite_Piece.gameObject:SetActive(true)
		elseif self.data.itemType == "treasure" or self.data.itemType == "fashion" or self.data.itemType == "equip" then
			atlasName = "equipImage"
		end
		self.pic:setImage(self.data.itemImage, atlasName)
	else 
		print(self.data:getType())
		if m:resTypeId(self.data:getType()) then
			self.txt_shuliang.text = TextMap.GetValue("Text_1_2806")..toolFun.moneyNumberShowOne(math.floor(tonumber(Player.Resource[self.data:getType()])))
			local desc = TableReader:TableRowByUnique("resourceDefine", "name", self.data:getType()).desc
			if desc ~= nil then
				self.txt_desc.text = desc
			else
				self.txt_desc.text = self.data:getType()
			end
		elseif self.data:getType() == "fashion" then
			self.txt_shuliang.gameObject:SetActive(false)
			self.txt_desc.text = self.data.desc
		elseif self.data:getType() == "equip" then
			self.txt_shuliang.text = TextMap.GetValue("Text_1_2806")..Player.EquipmentBagIndex[self.data.id].count--m:getServerPackData(self.data.itemTable.id)
			self.txt_desc.text = self.data.desc
		else
			self.txt_shuliang.text = TextMap.GetValue("Text_1_2806")..Player.ItemBagIndex[self.data.id].count--m:getServerPackData(self.data.itemTable.id)
			self.txt_desc.text = self.data.desc
		end
		self.txt_mingcheng.text = self.data:getDisplayColorName()
		self.img_kuangzi.spriteName = self.data:getFrame()
		self.img_bg.spriteName = self.data:getFrameBG()
		if self.data.itemType == "item" or(self.data.itemType~=nil and m:resTypeId(self.data.itemType)) then
			atlasName = "itemImage"
		elseif self.data:getType() == "equip" then
			atlasName = "equipImage"
		elseif self.data.itemType == "treasurePiece" then
			atlasName = "equipImage"
			self.Sprite_Piece.gameObject:SetActive(true)
		elseif self.data.itemType == "treasure" or self.data.itemType == "fashion" then
			atlasName = "equipImage"
		end
		self.pic:setImage(self.data:getHead())--:getHead()
	end
end

function m:resTypeId(_type)
    -- local ret = false
    -- TableReader:ForEachLuaTable("resourceDefine", function(k, v)
    --     if _type == v.name then
    --         ret = true
    --         return false
    --     end
    -- end)
    return Tool.typeId(_type)  
end

function m:getServerPackData(itemId)
    local bag = Player.ItemBag:getLuaTable()
    if not bag then error("bag have nothing") end
    for k, v in pairs(bag) do
        local vo = {}
        vo = itemvo:new("item", v.count, v.id, v.time, k)
        --print(vo.itemID..":"..vo.itemName)
        if vo.itemID == itemId  then
        	return vo.itemCount
        end
    end
    return 0
end

function m:onClick(go, name)
	if name == "closeBtn" or name == "btn_close" then
		UIMrg:popWindow()
	end
end

return m