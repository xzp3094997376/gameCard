local m = {}
--右侧纵向item里面的横向item脚本

local infobinding = nil

function m:update(data)
    local typeT = ""
    local itemInfo
    local binding 
    if data.type == "item" then
        typeT = "itemvo"
        itemInfo = itemvo:new(data.type, data.arg2, data.arg)
    elseif data.type == "char" then
        typeT = "char"
        itemInfo = Char:new(data.arg)
    elseif data.type == "charPiece" then 
        typeT = "charPiece"
        itemInfo = CharPiece:new(data.arg)
    elseif data.type == "pet" then
        typeT = "pet"
        itemInfo = Pet:new(nil, data.arg)
    elseif data.type == "petPiece" then
        typeT = "petPiece"
        itemInfo = PetPiece:new(data.arg)
    elseif Tool.typeId(data.type) then
        typeT = "itemvo"
        itemInfo = itemvo:new(data.type, 1, data.arg)
    elseif data.type == "ghost" then 
        typeT = "ghost"
        itemInfo = Ghost:new(data.arg)
    elseif data.type == "ghostPiece" then 
        typeT = "ghostPiece"
        itemInfo = GhostPiece:new(data.arg)
    else
        typeT = "itemvo"
        itemInfo = itemvo:new(data.type, 1, data.arg)
    end
	if infobinding == nil then
		infobinding = ClientTool.loadAndGetLuaBindingFromPool("Prefabs/publicPrefabs/itemAll", self.pic.gameObject)
        local obj = infobinding.transform:GetChild(0).gameObject
        if obj ~= nil then
            obj:AddComponent(UIDragScrollView)
        end
	end
    infobinding:CallUpdate({ typeT, itemInfo, self.pic.width, self.pic.height, true})


    if self.Label_targetName ~= nil and itemInfo.itemColorName ~= nil then
        self.Label_targetName.gameObject:SetActive(true)
        self.Label_targetName.text = itemInfo.itemColorName
    end
end

function m:onClick(go,name)
	if name == "" then

	end
end

function m:OnDestroy()
end

return m