local summon_box = {} 
local selectindex = 1

function summon_box:update(lua)
    self.camp = lua.camp
    self.delegate=lua.delegate
    local list =summon_box:getDropDate()
    if list ~=null and #list>0 then 
        self.selsect_item_index=0
        ClientTool.UpdateGrid("Prefabs/moduleFabs/choukaModule/SummonselectItem", self.Grid, list, self)
    else 
        UIMrg:popWindow()
    end 
end
function summon_box:onClick(go, name)
    if name == "closeBtn" or name == "btnClose" then
        UIMrg:popWindow()
        self.delegate.Container:SetActive(true)
        self.delegate.isCanClick=true
    end
    if name == "btn_queren" then
    	local consume = TableReader:TableRowByID("draw_xingyunzhi",self.camp).consume
    	if Player.Resource.xingyunzhi>=consume[0].consume_arg then 
    		Api:exchangeCampReward(self.selsect_item_index+1,
    			function(result)
    				packTool:showMsg(result, nil, 2,function()
                        self.delegate.Container:SetActive(true)
                        self.delegate.isCanClick=true
                    end)
    				UIMrg:popWindow()
                    self.delegate:updateZhanxingNum()
                return true
            end)
    	else 
    		MessageMrg.show(TextMap.GetValue("Text_1_2802") .. consume[0].consume_arg .. TextMap.GetValue("Text_1_2803"))
            self.delegate.Container:SetActive(true)
            self.delegate.isCanClick=true
    		UIMrg:popWindow()
    	end
    end
end



function summon_box:getDropDate()
    local list={}
    local propdate = {}
    propdate = TableReader:TableRowByID("draw_xingyunzhi",self.camp)
    local drop = propdate.drop
    local count = drop.Count
    for i=0,count-1 do
        local item
        local cell = drop[i]
        local type = cell.type
        if type == "char" and cell.arg ~=nil and cell.arg ~=0 then
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
            table.insert(list, item)
        elseif type == "charPiece" and cell.arg ~=nil and cell.arg ~=0 then
            item = CharPiece:new(cell.arg)
            item.isRes = true
            item.item_pos = i
            item.item_item = cell
            item.item_type=type
            table.insert(list, item)
        elseif type == "equip" and cell.arg ~=nil and cell.arg ~=0 then
            item = Equip:new(cell.arg)
            item.item_pos = i
            item.item_item = cell
            item.item_type=type
            table.insert(list, item)
        elseif type == "equipPiece" and cell.arg ~=nil and cell.arg ~=0 then
            item = EquipPiece:new(cell.arg)
            item.item_pos = i
            item.item_item = cell
            item.item_type=type
            table.insert(list, item)
        elseif type == "ghostPiece" and cell.arg ~=nil and cell.arg ~=0 then
            item = GhostPiece:new(cell.arg)
            item.item_pos = i
            item.item_item = cell
            item.item_type=type
            table.insert(list, item)
        elseif type == "ghost" and cell.arg ~=nil and cell.arg ~=0 then
            item = Ghost:new(cell.arg)
            item.item_pos = i
            item.item_item = cell
            item.item_type=type
            table.insert(list, item)
        elseif type == "reel" and cell.arg ~=nil and cell.arg ~=0 then
            item = Reel:new(cell.arg)
            item.item_pos = i
            item.item_item = cell
            item.item_type=type
            table.insert(list, item)
        elseif type == "reelPiece" and cell.arg ~=nil and cell.arg ~=0 then
            item = ReelPiece:new(cell.arg)
            item.item_pos = i
            item.item_item = cell
            item.item_type=type
            table.insert(list, item)
        elseif type == "item" and cell.arg ~=nil and cell.arg ~=0 then
            item = uItem:new(cell.arg)
            item.item_pos = i
            item.item_item = cell
            item.item_type=type 
            table.insert(list, item)
        elseif type == "treasure" and cell.arg ~=nil and cell.arg ~=0 then
            item = Treasure:new(cell.arg)
            item.item_pos = i
            item.item_item = cell
            item.item_type=type
            table.insert(list, item)
        elseif type == "treasurePiece" and cell.arg ~=nil and cell.arg ~=0 then
            item = TreasurePiece:new(cell.arg,cell.arg2)
            item.item_pos = i
            item.item_item = cell
            item.item_type=type
            table.insert(list, item)
        else
            item = uRes:new(type, arg)
            item.item_pos = i
            item.item_item = cell
            item.item_type=type
            item.isRes = true
            table.insert(list, item)
        end
    end
    return list
end

--初始化
function summon_box:create(binding)
    self.binding = binding
    return self
end

return summon_box