local m = {}

function m:update(datas)
    self.datas = datas
    -- 设置数量
    --self.txt_num.text = "数量:0/".. datas.bagTotalNums
    self.txt_num.text = TextMap.GetValue("Text1299") .. self:getCurBagNums() .. "/" .. datas.bagTotalNums

    -- 获取item数据 Guild_treasure_drop
    --local row = TableReader:TableRowByID(datas.tableName, datas.tableId)
    local row = TableReader:TableRowByID("Guild_treasure_drop", datas.tableId)
    -- local temp = {}
    -- temp.drop = row.drop
    --local itemCount = row.drop.Count
    local _type = row.drop[0]["type"]
    local vo = {}
    vo.type = _type
    local char = {}
    char = RewardMrg.getDropItem({type=_type, arg2=row.drop[0]["arg2"], arg=row.drop[0]["arg"]})
    vo.data = char

    -- 构造itemAll
    if self.itemall ~= nil then
        self.binding:DestroyObject(self.itemall.gameObject)
    end
    self.itemall = ClientTool.loadAndGetLuaBindingFromPool("Prefabs/publicPrefabs/itemAll", self.gameObject)
    self.itemall:CallUpdate({ "char", vo.data, self.img_k.width, self.img_k.height, true })
    --self.Label.text = v.data:getDisplayName()
end

--初始化
function m:create(binding)
    self.binding = binding
    return self
end

------------------------------------
function m:getCurBagNums()
    local count = self.datas.boxList.Count
    local nums = 0
    for i = 0, count - 1 do
        if self.datas.boxList[i] ~= 0 then
            if self.datas.index == self.datas.boxList[i].index then
                nums = nums + 1
            end
        end
    end
    nums = self.datas.bagTotalNums - nums
    return nums
end

return m