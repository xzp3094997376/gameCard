--免战界面
local m = {}

function m:Start(...)
    --local time_1 = TableReader:TableRowByID("trsRobConfig", "rob_free_1").value
    --local time_2 = TableReader:TableRowByID("trsRobConfig", "rob_free_2").value
    --self.txt_time_1.text = "小免战牌免战[00ff00]"..string.gsub(time_1, "h", "小时").."[-]"
    --self.txt_time_2.text = "大免战牌免战[00ff00]"..string.gsub(time_2, "h", "小时").."[-]"
end

function m:update(lua)
    self.delegate = lua.delegate
    self:refreshCount()
end

--商店数据
function m:shopContainTheItem(id)
    local shop_list = Player.Shop[7] --商城是7
    local count = shop_list.count
    for i = 0, count - 1 do
        local cell = shop_list[i]
        if cell.id == id then
            return true
        end
    end 
    return false
end

function m:refreshCount()--63，64
    if m:shopContainTheItem(66)==true and m:shopContainTheItem(66)==true then 
        local data1 = uItem:new(66)
        local data2 = uItem:new(67)
        local binding1=ClientTool.loadAndGetLuaBindingFromPool("Prefabs/publicPrefabs/itemAll", self.Background1.gameObject)
        binding1:CallUpdate({ "char", data1, self.Background1.width, self.Background1.height })
        self.txt_time_1.text=data1:getDisplayColorName()
        local binding2=ClientTool.loadAndGetLuaBindingFromPool("Prefabs/publicPrefabs/itemAll", self.Background2.gameObject)
        binding2:CallUpdate({ "char", data2, self.Background2.width, self.Background2.height })
        self.txt_time_2.text=data2:getDisplayColorName()
        self.txt_count_1.text  = TextMap.GetValue("LocalKey_287") .. " [00ff00]"..Player.ItemBagIndex[66].count.."[-]"
        self.txt_count_2.text  = TextMap.GetValue("LocalKey_287") .. " [00ff00]"..Player.ItemBagIndex[67].count.."[-]"
        self.delegate:refreshTime()
    elseif m:shopContainTheItem(66)==true or m:shopContainTheItem(67)==true then 
        local data1={}
        if m:shopContainTheItem(66)==true then 
            data1 = uItem:new(66)
            local binding1=ClientTool.loadAndGetLuaBindingFromPool("Prefabs/publicPrefabs/itemAll", self.Background1.gameObject)
            binding1:CallUpdate({ "char", data1, self.Background1.width, self.Background1.height })
            self.txt_time_1.text=data1:getDisplayColorName()
            self.txt_count_1.text  = TextMap.GetValue("LocalKey_287") .. " [00ff00]"..Player.ItemBagIndex[66].count.."[-]"
            self.delegate:refreshTime()
            self.btn_free_1.transform.localPosition=Vector3(0,-5,0)
            self.btn_free_2.gameObject:SetActive(false)
        else
            data1 = uItem:new(67)
            local binding1=ClientTool.loadAndGetLuaBindingFromPool("Prefabs/publicPrefabs/itemAll", self.Background2.gameObject)
            binding1:CallUpdate({ "char", data1, self.Background1.width, self.Background1.height })
            self.txt_time_2.text=data1:getDisplayColorName()
            self.txt_count_2.text  = TextMap.GetValue("LocalKey_287") .. " [00ff00]"..Player.ItemBagIndex[67].count.."[-]"
            self.delegate:refreshTime()
            self.btn_free_2.transform.localPosition=Vector3(0,-5,0)
            self.btn_free_1.gameObject:SetActive(false)
        end
    else 
        UIMrg:popWindow()
    end


end

function m:useFree(id)
    if id == nil then return end
    if Player.ItemBagIndex[id].count <= 0 then --免战牌不足
        local tp = "xmzp"
        if id == 67 then 
            tp = "dmzp"
        end
        DialogMrg:BuyBpAOrSoul(tp, "", toolFun.handler(self, self.refreshCount),toolFun.handler(self, self.refreshCount))
        return 
    end
    Api:useItem("item", id.."", 1,function (result)
        self.delegate:refreshTime()
        UIMrg:popWindow()
    end,id.."")
end

function m:onClick(go, name)
    if name == "btn_free_1" then  --小免战牌
        self:useFree(66)
    elseif name == "btn_free_2" then --大免战牌
        self:useFree(67)
    elseif name == "btn_close" then
        UIMrg:popWindow()
    end
end

return m