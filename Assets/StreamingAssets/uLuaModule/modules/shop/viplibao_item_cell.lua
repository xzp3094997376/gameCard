local viplibao_item_cell = {} 

function viplibao_item_cell:update(item, index, myTable, delegate)
    self.item = item
    self.index=index
    self.myTable=myTable
    self.delegate = delegate
    self:onUpdate()
    if self.item.name==nil then
        self.obj:SetActive(false)
    end
end

function viplibao_item_cell:onUpdate()
    self.dropTypeList = {}
    self.effect:SetActive(false)
    local item = self.item
    --if itemBind == nil then
    --    itemBind = ClientTool.loadAndGetLuaBindingFromPool("Prefabs/publicPrefabs/itemAll", self.pic.gameObject)
    --end
    --itemBind:CallUpdate({ "char", item, self.pic.width, self.pic.height })
    local consume = item.consume
    if consume[0].consume_type=="gold" then
    	self.img_huobi.spriteName = "icon_zuanshi"
    	self.img_huobinomal.spriteName = "icon_zuanshi"
    end
    self.txt_price_un.text=item.consume[0].consume_arg
    if item.yuanjia=="" then
    	item.yuanjia=item.consume[0].consume_arg
    end
    self.txt_price_nomal.text=item.yuanjia
    self.txt_name.text=string.gsub(TextMap.GetValue("LocalKey_752"),"{0}",item.vip_lv)
    self.txt_num.text=string.gsub(TextMap.GetValue("LocalKey_754"),"{0}",item.vip_lv)
    self.txt_des.text=item.desc1
    if Player.Vippkg[item.id] == 1 then
        self.buttonlabel.text=TextMap.GetValue("Text1465")
        self.btnBuy.isEnabled = false
    else
        self.buttonlabel.text=TextMap.GetValue("LocalKey_65")
        self.btnBuy.isEnabled = true
    end
    local list = {}
    local drop = item.drop
    local count = drop.Count
    for i=0,count-1 do
        local item
        local cell = drop[i]
        local type = cell.type
        table.insert(self.dropTypeList, type)
        if type == "char"then
            item = Char:new(nil,cell.arg)
            item.isRes = true
            if item.info.level > 0 then
                item = CharPiece:new(item.id)
                item.isRes = true
                item.__count = item.needCharNumber
            end
            item.item_pos = i
            item.item_item = cell
            item.item_type=type
            item.item_num=cell.arg2
            table.insert(list, item)
        elseif type == "charPiece" then
            item = CharPiece:new(cell.arg)
            item.isRes = true
            item.item_pos = i
            item.item_item = cell
            item.item_type=type
            item.item_num=cell.arg2
            table.insert(list, item)
        elseif type == "equip" then
            item = Equip:new(cell.arg)
            item.item_pos = i
            item.item_item = cell
            item.item_type=type
            item.item_num=cell.arg2
            table.insert(list, item)
        elseif type == "equipPiece" then
            item = EquipPiece:new(cell.arg)
            item.item_pos = i
            item.item_item = cell
            item.item_type=type
            table.insert(list, item)
        elseif type == "ghostPiece" then
            item = GhostPiece:new(cell.arg)
            item.item_pos = i
            item.item_item = cell
            item.item_type=type
            item.item_num=cell.arg2
            table.insert(list, item)
        elseif type == "ghost" then
            item = Ghost:new(cell.arg)
            item.item_pos = i
            item.item_item = cell
            item.item_type=type
            item.item_num=cell.arg2
            table.insert(list, item)
        elseif type == "reel" then
            item = Reel:new(cell.arg)
            item.item_pos = i
            item.item_item = cell
            item.item_type=type
            item.item_num=cell.arg2
            table.insert(list, item)
        elseif type == "reelPiece" then
            item = ReelPiece:new(cell.arg)
            item.item_pos = i
            item.item_item = cell
            item.item_type=type
            item.item_num=cell.arg2
            table.insert(list, item)
        elseif type == "item" then
            item = uItem:new(cell.arg)
            item.item_pos = i
            item.item_item = cell
            item.item_type=type 
            item.item_num=cell.arg2
            table.insert(list, item)
        else
            item = uRes:new(type, cell.arg)
            item.item_pos = i
            item.item_item = cell
            item.item_type=type
            item.isRes = true
            item.item_num=nil
            table.insert(list, item)
        end
    end
    ClientTool.UpdateGrid("Prefabs/moduleFabs/puYuanStoreModule/libao_contain_cell", self.Grid, list, self)
    if count<=4 then
    	--self.view.enabled=false
        --for i=0,self.Grid.transform.childCount-1 do
        --    self.Grid.transform:GetChild(i):GetComponent("BoxCollider").enabled = false
        --end 
    end
end

function viplibao_item_cell:onClick(go, name)
    if name =="btnBuy" then
    	if Player.Info.vip >=self.item.vip_lv then
        if Tool:judgeBagCount(self.dropTypeList) == false then return end
    		Api:buyVipPackage(self.item.id,function(result)
    			if result.ret == 0 then
                    packTool:showMsg(result, nil, 2)
    				self.buttonlabel.text=TextMap.GetValue("Text1465")
    				self.btnBuy.isEnabled = false
    				Events.Brocast('vipLibao_itemChange')
    			end
    		end)
    	else
    		MessageMrg.show(TextMap.GetValue("Text_1_1087"))
    	end
    end
end

function viplibao_item_cell:OnDrag(go,name,detal)
	print("viplibao_item_cell:OnDrag")
	if (self.delegate == nil or self.delegate.getScrollView == nil) then
		return
	end
	local sv = self.delegate:getScrollView()
	
	if sv ~= nil then
		sv:Drag();
	end
end

function viplibao_item_cell:getScrollView()		
	if (self.delegate == nil or self.delegate.getScrollView == nil) then
		return
	end
			return self.delegate:getScrollView();
end

return viplibao_item_cell