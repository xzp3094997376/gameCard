packItemVo = {
    itemType = "item",
    itemCount, --实际数量
    itemShowCount, --显示在图标上的数量
    itemID = 1,
    itemName = "",
    itemColorName = "",
    itemSell = 100,
    star = 0,
    itemLvl = 1,
    itemImage = "default",
    itemPro = "", --第一行说明
    itemDes = "", --后面多余的描述
    itemColor = "item_white",
    itemColorBG = "tubiao_1",
    itemTrueColor = 1,
    itemKey = "",
    itemTime = 12345,
    itemTable = {},
    isCommon = false, --标志是否是钱币还是道具等
    ghost_lv = 0 --鬼道等级
}

-- --获取物品外框颜色SpriteName
local function getItemColorSpriteName(color)
    return Tool.getFrame(color)
end

--外框
function getFrame(star)
    return Tool.getFrame(star)
end

function getItemColorSpriteNameBG(color)
    return Tool.getBg(color)
end

local function getItemColorName(color, names)
    local _names = names
    if color == 1 then
        _names = Tool.white .. names .. "[-]"
    elseif color == 2 then
        _names = Tool.green .. names .. "[-]"
    elseif color == 3 then
        _names = Tool.bule .. names .. "[-]"
    elseif color == 4 then
        _names = Tool.purple .. names .. "[-]"
    elseif color == 5 then
        _names = Tool.orange .. names .. "[-]"
    elseif color == 6 then
        _names = Tool.red .. names .. "[-]"
	elseif color == 7 then 
		_names = Tool.golden .. names .. "[-]"
    end
    return _names
end

--獲取服務端背包數據   type為類型，bag為數值
function getServerPackDataBySubType(type, subType, Bag, isNeedRecord)
	local list = {}
    local bag = Bag:getLuaTable()
    if not bag then error("bag have nothing") end
    for k, v in pairs(bag) do
        local vo = {}
        if type =="equip" then 
            vo = itemvo:new(type, v.count,k, v.time, k)
        else 
            vo = itemvo:new(type, v.count, v.id, v.time, k)
        end
		if vo.itemTable.subtype and vo.itemTable.subtype == subType then 
			table.insert(list, vo)
		end
        vo = nil
    end
	return list
end

--钱币等的实体化
function packItemVo:initM(itemType, itemCount, itemTime, itemKey)

    self.itemType = itemType
    itemCount = tonumber(itemCount or 0) or 0
    if itemCount == "" or itemCount == nil then
        itemCount = 0
    end
    self.itemCount = math.floor(itemCount)
    self.itemShowCount = toolFun.moneyNumber(self.itemCount)
    self.itemTime = itemTime
    self.itemKey = itemKey

    local obj = TableReader:TableRowByUnique("resourceDefine", "name", itemType)
    self.itemTable = obj
    if obj ~= nil then
        self.itemName = obj["cnName"]
        self.itemImage = obj["img"]
        if itemType == "gold" then
            self.itemColor = getItemColorSpriteName(5)
            self.star=5
            self.itemColorBG = getItemColorSpriteNameBG(5)
            self.itemColorName =getItemColorName(5,obj["cnName"])
        else
            self.itemColor = getItemColorSpriteName(1)
            self.itemColorBG = getItemColorSpriteNameBG(1)
            self.star=1
            self.itemColorName =getItemColorName(1,obj["cnName"])
        end
        self.isCommon = true
    else
        --  print("配置表出错")
    end
end

--道具实体
function packItemVo:init(itemType, itemCount, itemID, itemTime, itemKey)
    self.itemType = itemType
    if itemCount ~= "" and itemCount ~= nil then
        if (tonumber(itemCount)) == nil then
            itemCount = -1
        end
        self.itemCount = math.floor(tonumber(itemCount))
    end
    self.itemShowCount = toolFun.moneyNumber(self.itemCount)
    if itemCount == 1 then
        self.itemShowCount = " "
    end
    self.itemID = itemID
    self.itemTime = itemTime
    self.itemKey = itemKey

    local obj = nil
    if tonumber(itemID) ~= nil then
        obj = TableReader:TableRowByID(itemType, itemID)
    else
        obj = TableReader:TableRowByUnique(itemType, "name", itemID)
    end
    self.itemTable = obj
    if obj ~= nil then
        if itemType ~= "charPiece" then
            self.itemSell = obj["sell"]
        end
        self.itemName = obj["show_name"]
        if obj["star"] ~=nil then 
            self.star = obj["star"]
        else 
            self.star = obj["color"]
        end 
        self.itemColor = getItemColorSpriteName(self.star)
        self.itemTrueColor = self.star
        self.itemColorBG = getItemColorSpriteNameBG(self.star)
        self.itemColorName = getItemColorName(self.star, self.itemName)

        if itemType == "char" then
            local modelTable = TableReader:TableRowByID("avter", obj.model_id)  
            self.itemImage = modelTable.head_img
        elseif itemType == "pet" then
            local modelTable = TableReader:TableRowByID("petavter", obj.model_id)  
            self.itemImage = modelTable.head_img
        elseif itemType == "yuling" then
            local modelTable = TableReader:TableRowByID("petavter", obj.model_id)  
            self.itemImage = modelTable.head_img
        elseif itemType == "fashion" then
            self.itemImage = obj.icon
        else
            if obj["iconid"] == nil then
                obj["iconid"] = "default"
            end
            self.itemImage = obj["iconid"]
        end
        self.itemPro = obj["desc"]
        self.isCommon = false
        if itemType == "equip" then
            local strPro = ""
            self.itemLvl = lowest_level --使用等级
            for i = 0, obj.magic.Count - 1 do
                local row = obj.magic[i]
                local num = row.magic_arg1 / row._magic_effect.denominator

                if num ~= 0 then
                    if num % 1 == 0 then math.floor(num) end

                    if i == obj.magic.Count - 1 then
                        local desc = string.gsub(obj.magic[i]._magic_effect.format, "{0}", " +" .. num)
                        strPro = strPro .. desc
                    else
                        local desc = string.gsub(obj.magic[i]._magic_effect.format, "{0}", " +" .. num)
                        strPro = strPro .. desc .. '\n'
                    end
                end
            end
            self.itemPro = strPro
            strPro = nil
            self.itemDes = obj["desc"]
        end
        if itemType == "ghost" and itemKey then
            self.ghostItem = Ghost:new(itemID, itemKey)
            self.ghost_lv = self.ghostItem.lv
            self.ghost_power = self.ghostItem.power
        end
    else
        print("配置表出错: " .. itemID)
    end
end

function packItemVo:typeId(_type)
    return Tool.notResType(_type) 
end

function packItemVo:new(itemType, itemCount, itemID, itemTime, itemKey)
    local o = {}
    setmetatable(o, self)
    self.__index = self
	o.tempCount = itemCount
    if Tool.typeId(itemType) then 
        local num = itemID
        if itemType ~= nil then
            o:initM(itemType, num, itemTime, itemKey)
        end
    else
        o:init(itemType, itemCount, itemID, itemTime, itemKey)
    end
    return o
end

return packItemVo
