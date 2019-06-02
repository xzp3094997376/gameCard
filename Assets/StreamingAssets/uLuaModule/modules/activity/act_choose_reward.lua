local r = {}

function r:update(data)
    local list ={}
    if data.delegate~=nil then 
        self.delegate=data.delegate 
        list=self:getDropDate(data.data,true)
    else
        list=self:getDropDate(data.data,false)
    end 
	self.data=data.data
    MusicManager.playByID(51)
    if list ~=null and #list>0 then 
    	self.bg.width=40+#list*180
        self.selsect_item_index=0
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
        if data.delegate~=nil then 
            self.Grid.transform.localPosition=Vector3(-90*(#list-1)+5,62,0)
        else 
            self.Grid.transform.localPosition=Vector3(-90*(#list-1)+5,5,0)
        end 
    else 
        UIMrg:popWindow()
    end 
end

function r:getDropDate(data,istable)
	local list = {}
    local drop = data
    local count = 0
    if istable==true then
        count=#data
    else 
        count=drop.Count
    end 
    for i=0,count-1 do
        local item
        local cell ={}
        if istable then 
            cell=drop[i+1]
        else 
            cell=drop[i]
        end 
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

function r:onClick(go, name)
    if name == "closeBtn" or name == "btnClose" then
        UIMrg:popWindow()
    end
    if name == "btn_queren" then
    	UIMrg:popWindow()
        self.delegate:SelectMeCb(self.selsect_item_index)
    end
end

--初始化
function r:create(binding)
    self.binding = binding
    return self
end

return r