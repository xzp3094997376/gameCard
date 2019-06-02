--宝物掠夺结果icon
local m = {}

function m:Start(...)
end

function m:update(data)
    self.data = data[1]
    if data[2]~=nil then
        self.pieceId=data[2]
    end
    self:setInfo(self.data)  
    self.piece=TreasurePiece:new(self.pieceId)

end

function m:setInfo(data)
    if data == nil then return end
    local win = data.win
    local  consume = data.consume
    local drop = data.drop
    local real_index = data.real_index
    local exp = data.exp
    local money = data.money
    self.txt_exp.text = exp or 0 
    self.txt_money.text = money or 0
    if win == true then
        local piece=TreasurePiece:new(self.pieceId)
        self.txt_result.text = string.gsub(TextMap.GetValue("Text1730"), "%[1%]", real_index)
        self.txt_title.text =string.gsub(TextMap.GetValue("LocalKey_773"),"{0}",piece:getDisplayColorName())
    else
        self.txt_result.text = string.gsub(TextMap.GetValue("Text_1_928"), "%[1%]", real_index)
        self.txt_title.text = TextMap.GetValue("Text1733")
    end
    if drop == nil or drop == {} then
        self.img_frame.gameObject:SetActive(false)
    else
        self.img_frame.gameObject:SetActive(true)

        local char = nil
        char = RewardMrg.getDropItem(drop)
        
        if self.__itemAll == nil then
            self.__itemAll = ClientTool.loadAndGetLuaBindingFromPool("Prefabs/publicPrefabs/itemAll", self.img_frame.gameObject)
        end
        self.__itemAll:CallUpdate({ "char", char, self.img_frame.width, self.img_frame.height, true, nil, true })
    end
end

function m:isUsedType(_type)
    local typeAll = {"gold", "soul"}
    for i, j in pairs(typeAll) do
        if _type == j then
            return true
        end
    end
    return false
end

return m