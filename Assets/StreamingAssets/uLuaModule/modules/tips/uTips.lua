local MyTips = {}
local tempNumLY = 0
--设置每个物品的详细信息，temp可以是itemVo类型数据，也可以是char类型数据

function MyTips:destory()
    UIMrg:popWindow()
end


function MyTips:setData()
end

function MyTips:typeId(_type)
    return Tool.notResType(_type)
end

--temp基础数据
function MyTips:update(temp)
    if temp == nil then
        MyTips:destory()
        return
    end
    local itemData
    if temp.obj ~= nil then
        itemData = temp.obj
    else
        itemData = temp
    end
    local tempObj = {}
    self.txt_mingcheng.text = itemData.itemColorName
    self.img_kuangzi.gameObject:SetActive(false)
	if self.tujingBG ~= nil then 
		self.tujingBG.gameObject:SetActive(true)
	end
    if self:typeId(itemData.itemType) then
        self.txt_shuliang.text = TextMap.GetValue("Text1343") .. packTool.getNumByID(itemData.itemType, itemData.itemID)
        itemData.itemCount = 1
        infobinding = ClientTool.loadAndGetLuaBindingFromPool("Prefabs/publicPrefabs/itemAll", self.newpackitem)
        infobinding:CallUpdate({ "itemvo", itemData, self.img_kuangzi.width, self.img_kuangzi.height })
        self.txt_desc.text = itemData.itemPro
        tempObj = itemData.itemTable
        if itemData.itemTable.droptype ~=nil then 
            tempNumLY = itemData.itemTable.droptype.Count
        end 
        MyTips:SetMainSX(itemData.itemType, itemData.itemID)
        if itemData.itemType == "equip" and  itemData.itemTable.magic.Count > 2 then
            MyTips:ShowMainInfo(itemData.itemTable.magic)
            self.txt_desc.text = itemData.itemDes
        end
    elseif temp._type == "charPiece" then
        local piece = CharPiece:new(itemData.id)
        self.tujingBG.gameObject:SetActive(false)
        if self.txt_mingcheng.text == nil or self.txt_mingcheng.text == "" then
            self.txt_mingcheng.text = piece:getDisplayColorName()
        end
        self.txt_shuliang.text = TextMap.GetValue("Text1343") .. piece.count--packTool.getNumByID(itemData:getType(), itemData.id)
        itemData.rwCount = piece.count
        infobinding = ClientTool.loadAndGetLuaBindingFromPool("Prefabs/publicPrefabs/itemAll", self.newpackitem)
        infobinding:CallUpdate({ "char", piece, self.img_kuangzi.width, self.img_kuangzi.height })
        tempObj = piece.Table
        self.txt_desc.text = "[f1e081]" .. piece.desc
        MyTips:SetMainSX(piece:getType(), piece.id)
    elseif temp._type == "treasurePiece" then
        self.tujingBG.gameObject:SetActive(false)
        if self.txt_mingcheng.text == nil or self.txt_mingcheng.text == "" then
            self.txt_mingcheng.text = itemData:getDisplayColorName()
        end
        self.txt_shuliang.text = TextMap.GetValue("Text1343") .. itemData.count--packTool.getNumByID(itemData:getType(), itemData.id)
        itemData.rwCount = 1
        infobinding = ClientTool.loadAndGetLuaBindingFromPool("Prefabs/publicPrefabs/itemAll", self.newpackitem)
        infobinding:CallUpdate({ "treasurePiece", itemData, self.img_kuangzi.width, self.img_kuangzi.height })
        tempObj = itemData.Table
        self.txt_desc.text = "[f1e081]" .. tempObj.desc
        MyTips:SetMainSX(itemData:getType(), itemData.id)
    elseif itemData.itemType=="treasurePiece" then 
        if self.txt_mingcheng.text == nil or self.txt_mingcheng.text == "" then
            self.txt_mingcheng.text = itemData:getDisplayColorName()
        end
        self.txt_shuliang.text = TextMap.GetValue("Text1343") .. itemData.tempCount--packTool.getNumByID(itemData:getType(), itemData.id)
        itemData.rwCount = 1
        local cell = TreasurePiece:new(itemData.itemID)
        infobinding = ClientTool.loadAndGetLuaBindingFromPool("Prefabs/publicPrefabs/itemAll", self.newpackitem)
        infobinding:CallUpdate({ "treasurePiece", cell, self.img_kuangzi.width, self.img_kuangzi.height })
        tempObj = cell.Table
        self.txt_desc.text = "[f1e081]" .. cell.desc
        MyTips:SetMainSX(cell:getType(), cell.id)
    else
        if self.txt_mingcheng.text == nil or self.txt_mingcheng.text == "" then
            self.txt_mingcheng.text = itemData:getDisplayColorName()
        end
        self.txt_shuliang.text = TextMap.GetValue("Text1343") .. packTool.getNumByID(itemData:getType(), itemData.id)
        itemData.rwCount = 1
        infobinding = ClientTool.loadAndGetLuaBindingFromPool("Prefabs/publicPrefabs/itemAll", self.newpackitem)
        infobinding:CallUpdate({ "char", itemData, self.img_kuangzi.width, self.img_kuangzi.height })
        tempObj = itemData.Table
        self.txt_desc.text = "[f1e081]" .. tempObj.desc
        MyTips:SetMainSX(itemData:getType(), itemData.id)
        if tempObj ~= nil and tempObj.type == "equip" and  tempObj.magic.Count > 2 then
            MyTips:ShowMainInfo(itemData.Table.magic)
        end
    end

    if tempObj.droptype ==nil then 
        tempNumLY=0
    else 
        tempNumLY = tempObj.droptype.Count
    end
    if tempNumLY == 0 then
        self.txt_no:SetActive(true)
        return
    end
    self.txt_no:SetActive(false)
    if tempNumLY > 0 then
        local index = 0
        for i = 0, tempNumLY - 1 do
            local tempData = {}
            if tempObj.droptype[i] ~= nil and tempObj.droptype[i] ~= "" then
                tempData.obj = Tool.readSuperLinkById(tempObj.droptype[i])
                tempData.type = "tujing"
                tempData.proxy = self
                local binding = ClientTool.loadAndGetLuaBinding("Prefabs/moduleFabs/packModule/newPackInfoitem2", self.tables.gameObject)
                binding:CallUpdate(tempData)
                binding.name = index
                binding = nil
                tempData = nil
                index = index + 1
            end
        end
    end
    self.tables.repositionNow = true
    self.view:ResetPosition()
end

function MyTips:ShowMainInfo(dataMagic)
    local gji = ""
    local sming = ""
    local wfang = ""
    local ffang = ""           
    for i = 0, 3 do
        local title = string.gsub(dataMagic[i]._magic_effect.format, "：{0}","")
        local value = "[FFFF96]"..string.gsub(dataMagic[i]._magic_effect.format, "：{0}", "：[-]"..dataMagic[i].magic_arg1)
        if title == TextMap.GetValue("Text_1_894") then
            gji = value
        elseif title == TextMap.GetValue("Text_1_893") then
            sming = value
        elseif title == TextMap.GetValue("Text_1_892") then 
            wfang = value
        elseif title == TextMap.GetValue("Text_1_891") then 
            ffang = value
        end
    end
    self.Label:SetActive(true)
    self.txt_main_sx.text = sming.."\n"..wfang--gji.."    "..sming.."\n"..wfang.."   　"..ffang
    self.txt_main_sx2.text = gji.."\n"..ffang
        --self.txt_main_sx.text = itemData.itemPro--.."[f1e081]" .. "[-]"
end

--显示道具、道具碎片、鬼道、鬼道碎片的主要属性
function MyTips:SetMainSX(itemType, itemID)
    if self.txt_main_sx == nil then return end

    local sxTable = nil
    if itemType == "equip" or itemType == "equipPiece" then
        sxTable = TableReader:TableRowByID("equip", itemID).magic
    elseif itemType == "ghost" or itemType == "ghostPiece" then
        sxTable = TableReader:TableRowByID("ghost", itemID).magic
    elseif itemType == "treasure"  then
        sxTable = TableReader:TableRowByID("treasure", itemID).magic
    elseif itemType == "treasurePiece" then
        sxTable = TableReader:TableRowByID("treasurePiece", itemID).magic
    else
        self.txt_main_sx.transform.parent.gameObject:SetActive(false)
        self.txt_desc.height = 182
        return
    end
    
    if sxTable ~= nil then
        sxTable = json.decode(sxTable:toString())
    end
    
    if sxTable ~= nil then

        local str = nil
        local isPerc = false
        for i, sx in pairs(sxTable) do
            local num = tonumber(sx.magic_arg1)
            if num ~= nil and num ~= 0 then
                if str ~= nil then str = str .. "\n" else str = "" end
                if i == 1 then
                    str = str .. "[FFFF96]" .. string.gsub(sx._magic_effect.format, "{0}", "[-]").. sx.magic_arg1--.."\n"
                else
                    if string.find(sx._magic_effect.format, TextMap.GetValue("Text_1_898")) or string.find(sx._magic_effect.format, TextMap.GetValue("Text_1_897")) or string.find(sx._magic_effect.format, TextMap.GetValue("Text_1_896")) or string.find(sx._magic_effect.format, TextMap.GetValue("Text_1_895")) then
                        isPerc = true
                    end

                    if isPerc then
                        str = str .. "[FFFF96]"..string.gsub(sx._magic_effect.format, "{0}", "[-]"..sx.magic_arg1 / 10)
                    else
                        str = str .. "[FFFF96]"..string.gsub(sx._magic_effect.format, "{0}", "[-]"..sx.magic_arg1)
                    end
                end
            end
        end
        if str ~= nil then
            self.txt_main_sx.text = str
        end
    end
end


--设置角色碎片的说明
function MyTips:SetCharPiece(pieceID, star)
    local bag = Player.CharPieceBag:getLuaTable()
    if not bag then error("bag have nothing") end
    local piece = CharPiece:new(pieceID)
    self.txt_shuliang.text = TextMap.GetValue("Text1343") .. piece.desc
end

function MyTips:refreashData()
    self.tables.repositionNow = true
    UluaModuleFuncs.Instance.uTimer:removeFrameTime("refreashPackInfo")
    if tempNumLY == 0 then
        self.binding:CallAfterTime(0.1, funcs.handler(self,
            function()
                self.tujingTxt:SetActive(false)
            end))
    end
end

function MyTips:onClick(go, name)
    MyTips:destory()
end

function MyTips:findSprite(name)
    local tran = self.gameObject.transform:Find(name)
    if tran == nil then return nil end
    MyTips:setAssets(tran.gameObject:GetComponent(UISprite))
end

function MyTips:setAssets(sp)
    local atlas = GameManager.GetAtlas()
    if sp then
        sp.atlas = atlas
    end
end

function MyTips:findFont(name)
    local tran = self.gameObject.transform:Find(name)
    if tran == nil then return nil end
    local lab = tran.gameObject:GetComponent(UILabel)
    if lab then
        lab.bitmapFont = GameManager.GetFont()
    end
end

function MyTips:Start()
    --MyTips:findSprite("bg/img_cornor")
    --MyTips:findSprite("closeBtn")
    --MyTips:findSprite("Sprite")
    --MyTips:findSprite("SpriteX")
    --MyTips:findSprite("Sprite_bottom")
    --MyTips:findSprite("left/bg")
    --MyTips:findSprite("left/newpackitem/img_kuangzi")
    --MyTips:findSprite("left/down/bg")
    --MyTips:findSprite("left/down/tujingBG")
    --MyTips:findSprite("left/down/tujingBG")
    --MyTips:findSprite("right/tujingBG")
    --MyTips:findSprite("right/zhuangbeiBG")
    --
    --MyTips:findFont("Sprite/Label")
    --MyTips:findFont("left/txt_mingcheng")
    --MyTips:findFont("left/txt_shuliang")
    --MyTips:findFont("left/down/tujingBG/Label")
    --MyTips:findFont("left/down/tujingBG/txt_desc")
    --MyTips:findFont("left/down/tujingBG/Label")
    --MyTips:findFont("left/down/tujingBG/txt_main_sx")
    --MyTips:findFont("right/tujingBG/Label")
    --MyTips:findFont("right/txt_no")
end

return MyTips