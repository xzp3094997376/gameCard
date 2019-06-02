local newItemContent = {} 

local selsect_item_index=0
local ret = true

function newItemContent:update(item, index, myTable, delegate)
    self.item_item = item.item_item
    self.item_type =item.item_type
    self.item = item
    self.index=item.item_pos
    self.myTable=myTable
    self.delegate = delegate
    self:onUpdate()
end

function newItemContent:typeId(_type)
    -- local ret = false
    -- TableReader:ForEachLuaTable("resourceDefine", function(k, v)
    --     if _type == v.name then
    --         ret = true
    --         return false
    --     end
    -- end)
    return Tool.typeId(_type)  
end

function newItemContent:onUpdate()
    local binding 
    self.pic.gameObject:SetActive(true)
    --
    local type = self.item:getType()
    local name = ""
    local isTips = true
    binding=ClientTool.loadAndGetLuaBindingFromPool("Prefabs/publicPrefabs/itemAll", self.pic.gameObject)
    binding:CallUpdate({"char", self.item, self.kuang.width, self.kuang.height, true})
    if self.item.itemColorName ~= nil then
        self.name.text = self.item.itemColorName--self.item:getDisplayColorName() 
    else
        self.name.text = self.item:getDisplayColorName() 
    end
    if self.num~=nil then
        if self:typeId(self.item_type) then 
            self.num.text=self.item_item.arg
        else 
            self.num.text=self.item_item.arg2
        end 
    end 
    if self.index ==self.delegate.selsect_item_index then
        ret = true
        if self.checkmark ~=nil then 
            self.checkmark:SetActive(true)
        end 
    else
        ret = false
        if self.checkmark ~=nil then 
            self.checkmark:SetActive(false)
        end 
    end
end

function newItemContent:OnDestroy()
    if self.checkmark~=nil then 
        Events.RemoveListener("select_Item")
        Events.RemoveListener("Change_Num")
    end 
end

function newItemContent:onClick(go, name)
    if name == "toggle_btn" then
        if ret == false then
            self.delegate.selsect_item_index=self.index
            Events.Brocast('select_Item')
        end
    end
end
function newItemContent:Start(...)
    if self.checkmark~=nil then 
        Events.AddListener("select_Item", function()
            if self.index ==self.delegate.selsect_item_index then
                ret = true
                if self.checkmark ~=nil then 
                    self.checkmark:SetActive(true)
                end 
            else
                ret = false
                if self.checkmark ~=nil then 
                    self.checkmark:SetActive(false)
                end 
            end
        end)
        Events.AddListener("Change_Num", function()
            if self.num~=nil then
                if self:typeId(self.item_type) then 
                    self.num.text=self.item_item.arg*tonumber(self.delegate.selectNum.text)
                else 
                    self.num.text=self.item_item.arg2*tonumber(self.delegate.selectNum.text)
                end 
            end 
            end)
    end 
end
--初始化
function newItemContent:create(binding)
    self.binding = binding
    return self
end
return newItemContent