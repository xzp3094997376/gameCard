local newPackUse = {} 
local selectindex = 1

function newPackUse:update(tempdata)
    self.vo = tempdata.obj
    self.go = tempdata.go
    self.btntxt_nor.text=TextMap.GetValue("Text1346")
    self.selectNum.text ="1"
    self.numberSelect.selectNum = 1
    local maxCount = 0
    if self.vo.itemType == "item" then
        maxCount = self:limitNum(self.vo.itemID)
    end
    if maxCount ~= 0 then 
        self.numberSelect:maxNumValue(maxCount) 
    else
        self.numberSelect:maxNumValue(self.vo.itemCount)
    end
    self.numberSelect:setCallFun(self.setNumChange, self)
    local list =newPackUse:getDropDate(self.vo.itemID)
    if list ~=null and #list>0 then 
        self.bg.width=40+#list*180
        self.selsect_item_index=list[1].item_pos
        for i=1,#list do
            local go = nil
            if i==1 then
                go = self.newPackselectItem
            else
                go = NGUITools.AddChild(self.Grid, self.newPackselectItem.gameObject):GetComponent(UluaBinding)
            end 
            go.transform.localPosition = Vector3(180*(i-1),0,0)
            go:CallUpdateWithArgs(list[i],i,nil,self)
        end
        self.Grid.transform.localPosition=Vector3(-90*(#list-1)+8,62,0)
    else 
        UIMrg:popWindow()
    end 
end
function newPackUse:onClick(go, name)
    if name == "closeBtn" or name == "btnClose" then
        UIMrg:popWindow()
    end
    if name == "btn_queren" then
       Api:useItemSelect(self.vo['itemType'], self.vo['itemKey'], tonumber(self.selectNum.text),self.selsect_item_index+1,
            function(result)
                local tp = self.vo.itemTable.use_type or 0
                packTool:showMsg(result, nil, tp)
                UIMrg:popWindow()
                newPackUse:useSellBack()
                return true
            end, self.vo.itemID)
    end
end


function newPackUse:setNumChange()
    Events.Brocast('Change_Num')
end

function newPackUse:useSellBack()
    Events.Brocast('pack_itemChange')
    UIMrg:popWindow()
end

function newPackUse:limitNum(id)
    local num = Player.ItemBagIndex[id].count
    local msg = ""
    local row =TableReader:TableRowByID("item", id)

    local maxUseCount =row.use_limit
    local consume=row.consume
    --print_t (consume)
    if consume~=nil and consume[0].consume_type =="item" then 
        local consumeid=consume[0].consume_arg
        if consumeid== id then 
            if num > maxUseCount then
                num = maxUseCount
            end
        else 
            local consumenum=newPackSell:limitNum(consumeid)/consume[0].consume_arg2
            if num > maxUseCount then
                num = maxUseCount
                if num >consumenum then 
                    num =consumenum
                end
            end
        end
    else
        if num > maxUseCount then
            num = maxUseCount
        end
    end
    return num
end

function newPackUse:getDropDate(id)
    local list={}
    local propdate = {}
    propdate = TableReader:TableRowByID("item",id)
    local drop = propdate.drop
    local count = drop.Count
    for i=0,count-1 do
        local item
        local cell = drop[i]
        local type = cell.type
        if cell.arg ~=nil and cell.arg ~=0 then
            item = RewardMrg.getDropItem(cell)
            item.isRes = Tool.typeId(type)
            item.item_pos = i
            item.item_item = cell
            item.item_type=type
            table.insert(list, item)
        end
    end
    return list
end

function newPackUse:getAttrList(arg)
    local list = {}
    local len = arg.Count
    for i = 0, 3 do
        if i > len - 1 then
            list[i + 1] = 0
        else
            list[i + 1] = arg[i]
        end
    end
    return list
end

--初始化
function newPackUse:create(binding)
    self.binding = binding
    return self
end

return newPackUse