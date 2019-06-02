local newpack = {}

local analogData = {}
local packItemsNum = 0 --生成的格子数量
local packitems = {} --背包小格子
local totelNum = 0 --当前格子数量
local currentSelectItem = {}
local currentSelectType = 1 --1全部 2装备 3装备碎片 4道具,5 灵魂石
local infobinding
local superLinkData = {}
local firstItem --默认选中第一个

function newpack:OnDestroy()
    newpack = nil
    Events.RemoveListener('pack_itemChange')
    currentSelectType = 0
    collectgarbage("collect")
end

local function getAttrList(arg)
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

function newpack:showGhost(params)
    local name = params.itemName
    if params.ghost_power > 0 then name = name .. "+" .. params.ghost_power end
    self.txt_mingcheng.text = name
    if params.itemCount == " " then
        params.itemCount = 1
    end
    self.txt_shuliang.text = TextMap.GetValue("Text1330") .. params.ghost_lv .. "[-]"
    self.img_dikuang2:SetActive(false)
    self.img_kuangzi.gameObject:SetActive(false)
    if infobinding == nil then
        infobinding = ClientTool.loadAndGetLuaBindingFromPool("Prefabs/publicPrefabs/itemAll", self.newpackitem)
    end
    infobinding:CallUpdate({ "itemvo", params, self.img_kuangzi.width, self.img_kuangzi.height })
    self.btntxt_nor_left.text = TextMap.GetValue("Text1331")
    self.btntxt_nor.text = TextMap.GetValue("Text1332")
    local ghost = params.ghostItem
    if ghost then
        local list = ghost:getDesc(getAttrList(ghost.info.xilian))
        local descLeft = ""
        table.foreachi(list, function(i, v)
            descLeft = descLeft .. v .. "\n"
        end)
        self.txt_shuxing.text = string.sub(descLeft, 1, -2)
        self.txt_jieshao.text = ghost.Table.desc
    end
    self:setInfoVisible(true)
end

function newpack:itemClick(params)
    if params == nil then
        return
    end
    currentSelectItem = params
    if params.itemType == "ghost" then
        newpack:showGhost(params)
        return
    end
    self.img_dikuang2:SetActive(true)
    self.txt_mingcheng.text = params.itemName
    if params.itemCount == " " then
        params.itemCount = 1
    end
    if params.itemCount~=nil and params.itemCount~=0 then 
        self.txt_shuliang.text = TextMap.GetValue("Text_1_939") .. params.itemCount .. TextMap.GetValue("Text_1_940")
    else 
        self.txt_shuliang.text=""
    end
    self.txt_shuxing.text = params.itemPro
    self.txt_jieshao.text = params.itemDes
    if params.itemType == "charPiece" and params.star > 3 then
        self.moneySprite.spriteName = "shengwang"
    else
        self.moneySprite.spriteName = "resource_jinbi"
    end
    self.img_kuangzi.gameObject:SetActive(false)
    if infobinding == nil then
        infobinding = ClientTool.loadAndGetLuaBindingFromPool("Prefabs/publicPrefabs/itemAll", self.newpackitem)
    end
    infobinding:CallUpdate({ "itemvo", params, self.img_kuangzi.width, self.img_kuangzi.height })

    if params.itemTable.can_sell ~= 1 then
        self.txt_chushoujiage.text = 0
    else
        self.txt_chushoujiage.text = params.itemSell
    end
    if params.itemTable.can_use == 1 then
        self.btntxt_nor.text = TextMap.GetValue("Text363")
    else
        self.btntxt_nor.text = TextMap.GetValue("Text1331")
    end
    if params.itemType == "item" and superLinkData[params.itemTable.id] ~= nil then
        self.btntxt_nor.text = TextMap.GetValue("Text350")
    end
    self.btntxt_nor_left.text = TextMap.GetValue("Text1335")
    self:setInfoVisible(true)
end


--獲取服務端背包數據   type為類型，bag為數值
function getServerPackData(type, Bag, isNeedRecord)
    local bag = Bag:getLuaTable()
    if not bag then error("bag have nothing") end
    for k, v in pairs(bag) do
        local vo = {}
        if type =="equip" then 
            vo = itemvo:new(type, v.count,k, v.time, k)
        else 
            vo = itemvo:new(type, v.count, v.id, v.time, k)
        end
        totelNum = totelNum + 1
        analogData[totelNum] = vo
        analogData[totelNum].pack = newpack.itemClick
        vo = nil
    end
end

local tempAllList = {}
local tempCount = 0
function addListToAll(itemType)
    if itemType == "charPiece" then
        sortAnalogCharPiece()
    else
        sortAnalogData()
    end
    local counts = #analogData
    for i = 1, counts do
        tempCount = tempCount + 1
        tempAllList[tempCount] = analogData[i]
        counts = counts + 1
    end
    totelNum = 0
    analogData = {}
end

--排序，先按颜色
function sortAnalogData()
    if analogData ~= nil then
        table.sort(analogData, function(a, b)
            if a.itemTrueColor ~= b.itemTrueColor then 
                return a.itemTrueColor > b.itemTrueColor
            end
            if a.itemID ~= b.itemID then
                return a.itemID < b.itemID
            end
        end)
    end
end

--灵魂石排序，根据星级然后数量
function sortAnalogCharPiece()
    table.sort(analogData, function(a, b)
        if a.star ~= b.star then return a.star > b.star end
        if a.itemCount ~= b.itemCount then return a.itemCount > b.itemCount end
        return a.itemID < b.itemID
    end)
end

function sortAnalogIsCanUse()
    table.sort(analogData, function(a, b)
        if a.itemTable.can_use ~= b.itemTable.can_use then
            return a.itemTable.can_use == 1
        end
        if a.itemTrueColor ~= b.itemTrueColor then 
            return a.itemTrueColor > b.itemTrueColor
        end
        return a.itemID < b.itemID
    end)
end

local selectSprite
function newpack:showSelect(sprite, key)
    if currentSelectItem ~= nil and currentSelectItem["itemKey"] == key then
        if selectSprite ~= nil then
            selectSprite:SetActive(false)
        end
        selectSprite = sprite
        selectSprite:SetActive(true)
    end
end

function newpack:setDataList()
    sortAnalogIsCanUse()
    --self.scrollView:refresh(analogData, self)
    analogData = newpack:getData(analogData)
    self.ScrollViewInfo:refresh(analogData, self, false, -1)
    if self.isScroll then
        self.binding:CallAfterTime(0.05, function()
            self:setButtonEnable(true)
            self.ScrollViewInfo:ResetPosition()
        end)
    end

end


--初始化装备界面内容
function newpack:initZB(bol)
	--self.content:SetActive(true)
	--self.content_bw:SetActive(false)
    totelNum = 0
    analogData = {}
    getServerPackData("equip", Player.EquipmentBagIndex)
    sortAnalogData()
    if totelNum > 0 then
        firstItem = analogData[1]
    end

    self.ShowNum.gameObject:SetActive(true)
    self.Label_Value_Bag.text = TextMap.GetValue("Text_1_326")..totelNum.."/"..TableReader:TableRowByID("bagMax", "maxEquip")["vip"..Player.Info.vip]

    newpack:isShowMsg(TextMap.GetValue("Text1336"), bol)
    newpack:setDataList()
    --  self.scrollView:assignPage(0)
end

--初始化装备碎片界面内容
function newpack:initZBSP(bol)
	--self.content:SetActive(true)
	--self.content_bw:SetActive(false)
    totelNum = 0
    toolFun.tableClear(analogData)
    analogData = {}
    getServerPackData("equipPiece", Player.EquipmentPieceBag)
    sortAnalogData()
    if totelNum > 0 then
        firstItem = analogData[1]
    end

    self.ShowNum.gameObject:SetActive(false)

    newpack:isShowMsg(TextMap.GetValue("Text1337"), bol)
    newpack:setDataList()
    --self.scrollView:assignPage(0)
end

--初始化道具界面内容
function newpack:initDJ(bol)
	--self.content:SetActive(true)
	--self.content_bw:SetActive(false)
    totelNum = 0
    toolFun.tableClear(analogData)
    analogData = {}
    getServerPackData("item", Player.ItemBag)
    sortAnalogData()
    if totelNum > 0 then
        firstItem = analogData[1]
    end

    self.ShowNum.gameObject:SetActive(true)
    self.Label_Value_Bag.text = TextMap.GetValue("Text_1_326")..totelNum.."/"..TableReader:TableRowByID("bagMax", "maxItem")["vip"..Player.Info.vip]

    newpack:isShowMsg(TextMap.GetValue("Text1338"), bol)
    newpack:setDataList()
end

--初始化轨道
function newpack:initGD(bol)
	--self.content:SetActive(true)
	--self.content_bw:SetActive(false)
    totelNum = 0
    toolFun.tableClear(analogData)
    analogData = {}
    newpack:getGhost()
    if totelNum > 0 then
        firstItem = analogData[1]
    end
    newpack:isShowMsg(TextMap.GetValue("Text1339"), bol)
    newpack:setDataList()
end

--初始化宝物
function newpack:initBW()
	--self.content:SetActive(false)
	--self.content_bw:SetActive(true)
	self.binding:CallAfterTime(0.3, function()
        self:setButtonEnable(true)
    end)
end




--该栏目没有道具的情况
function newpack:isShowMsg(msg, bol)
    if totelNum == 0 then
        self.desLabel.gameObject:SetActive(true)
        -- self.desLabel.text =msg
        self.info:SetActive(false)
    else
        if bol then
            self.desLabel.gameObject:SetActive(false)
            --self.info:SetActive(true)
            firstItem = analogData[1]
            currentSelectItem = firstItem
            newpack:itemClick(firstItem)
        end
    end
end

--鬼道和鬼道碎片
function newpack:getGhost()
    local ghost = Tool.getUnUseGhost()
    analogData = {}
    table.foreach(ghost, function(i, v)
        local id = v.id
        local vo = {}
        totelNum = totelNum + 1
        vo = itemvo:new("ghost", 1, id, 0, v.key)
        vo.pack = newpack.itemClick
        table.insert(analogData, vo)
        vo = nil
    end)
    local pieces = Tool.getAllCharPiece() or {}
    table.foreach(pieces, function(i, piece)
        piece:updateInfo()
        if piece.count > 0 then
            local kind = piece.Table.kind
            if kind ~= 0 and kind ~= "" and kind ~= nil then
                local id = piece.id
                local vo = {}
                totelNum = totelNum + 1
                vo = itemvo:new(piece:getType(), piece.count, id, 0, id .. "")
                vo.pack = newpack.itemClick
                table.insert(analogData, vo)
                vo = nil
            end
        end
    end)
end

function newpack:getData(data)
    local list = {}
    local row = 2
    for i = 1, table.getn(data), row do
        local li = {}
        local len = 0
        for j = 0, row - 1 do
            if data[i + j] then
                local d = data[i + j]
                d.realIndex = i + j
                li[j + 1] = d
                len = len + 1
                d.mType = self.mType
            end
        end
        if len > 0 then
            table.insert(list, li)
        end
    end
    return list
end



--初始化的时候，还有使用物品之后调用
function newpack:setVisibleTab()
    if currentSelectType == 1 then
        newpack:initDJ(false)
    elseif currentSelectType == 2 then
        newpack:initZB(false)
    elseif currentSelectType == 3 then
        newpack:initZBSP(false)
    elseif currentSelectType == 4 then 
        newpack:initGD(false)
	else 
		newpack:initBW()
    end
end

function newpack:isAvalible(id)
    local num = 0
    local msg = nil
    local name = ""
    if id >= 3 and id <= 5 then
        name = TableReader:TableRowByID("item", (id + 3)).name
        if Player.ItemBagIndex[id].count ~= 0 and Player.ItemBagIndex[id + 3].count == 0 then --如果有钥匙没宝箱
        msg =string.gsub(TextMap.GetValue("LocalKey_739"),"{0}", name)

        return msg
        elseif Player.ItemBagIndex[id].count == 0 and Player.ItemBagIndex[id + 3].count ~= 0 then --如果有宝箱没钥匙
        msg = string.gsub(TextMap.GetValue("LocalKey_740"),"{0}", name)
        return msg
        end
        return msg
    elseif id >= 6 and id <= 8 then
        name = TableReader:TableRowByID("item", (id - 3)).name
        if Player.ItemBagIndex[id].count ~= 0 and Player.ItemBagIndex[id - 3].count == 0 then --如果有钥匙没宝箱
        msg = string.gsub(TextMap.GetValue("LocalKey_740"),"{0}", name)
        return msg
        elseif Player.ItemBagIndex[id].count == 0 and Player.ItemBagIndex[id - 3].count ~= 0 then --如果有宝箱没钥匙
        msg = string.gsub(TextMap.GetValue("LocalKey_739"),"{0}", name)
        return msg
        end
        return msg
    end
    return msg
end

--按钮点击事件
function newpack:onClick(go, name)
    if name == "btn_zhuangbei" then
        --self:setButtonEnable(false)
        self.checkdaoju:SetActive(false)
        self.checkjuexing:SetActive(true)
        self.isScroll = true
        newpack:initZB(true)
        currentSelectType = 2
   -- elseif name == "btn_zhuangbeisuipian" then
       -- self:setButtonEnable(false)
     --   newpack:initZBSP(true)
      --  currentSelectType = 3
    elseif name == "btn_daoju" then
        self.checkdaoju:SetActive(true)
        self.checkjuexing:SetActive(false)
        self.isScroll = true
        newpack:initDJ(true)
        currentSelectType = 1
	--elseif name == "btn_baowu" then 
		--self:setButtonEnable(false)
		--newpack:initBW()
	--	currentSelectType = 5
    elseif name == "btn_chushou" then
        --if currentSelectItem.itemType == "ghost" and currentSelectItem.ghostItem ~= nil then
        --    UIMrg:pushWindow("Prefabs/moduleFabs/guidao/guidao_desc", currentSelectItem.ghostItem)
        --    return
        --end
        --if currentSelectItem.itemTable.can_sell ~= 1 then
        --    MessageMrg.show("该物品不可出售")
        --else
        --    local temp = {}
        --    temp.obj = currentSelectItem
        --    temp.type = "sell"
        --    temp.go = self.binding.gameObject
        --    UIMrg:pushWindow("Prefabs/moduleFabs/packModule/newPackSell", temp)
        --    temp = nil
        --end
    elseif name == "btn_xiangqing" then
        --if currentSelectItem.itemType == "ghost" then
        --    uSuperLink.openModule(546)
        --    return
        --end
        --if self.btntxt_nor.text == TextMap.GetValue("Text_1_6") then
        --    local temp = {}
        --    temp.obj = currentSelectItem
        --    temp.type = "use"
        --    temp.go = self.binding.gameObject
        --    local msg = self:isAvalible(currentSelectItem.itemTable.id)
        --    if msg ~= nil then --判断是否有相对于的钥匙和宝箱             
        --    MessageMrg.show(msg)
        --    return
        --    else
        --        UIMrg:pushWindow("Prefabs/moduleFabs/packModule/newPackSell", temp)
        --    end
        --    temp = nil
        --elseif self.btntxt_nor.text == "前往" then
        --    uSuperLink.openModule(superLinkData[currentSelectItem.itemTable.id])
        --else
        --    local temp = {}
        --    temp.obj = currentSelectItem
        --    UIMrg:pushWindow("Prefabs/moduleFabs/packModule/newpackInfo", temp)
        --    temp = nil
        --end
	elseif name == "btnBack" then 
		UIMrg:pop()
	elseif name == "btn_add_soul" then 
	--	newpack:onAddSoul()
    end
end

--灵子增加
function newpack:onAddSoul()
    DialogMrg:BuyBpAOrSoul("soul", "", nil)
end

function newpack:setButtonEnable(bool)
    --self.btn_quanbu.isEnabled = bool
    --self.btn_zhuangbei.isEnabled = bool
    --self.btn_zhuangbeisuipian.isEnabled = bool
    --self.btn_daoju.isEnabled = bool
	--self.btn_baowu.isEnabled = bool
end

local isHave = false
-- Events.AddListener("pack_itemChange",
--     function(params)
--         --newpack:callbackListener()
--     end
--     )

function newpack:callbackListener()
    self.isScroll = false
    newpack:setVisibleTab()
end

function newpack:setInfoVisible(bool)
    if bool == false then
        currentSelectItem = firstItem
        if firstItem ~= nil then
            newpack:itemClick(currentSelectItem)
        else
            --到时候看策划需求
        end
    end
end

--初始化
function newpack:create(binding)
    self.binding = binding
    return self
end

function newpack:update(data)
	print("_____")
	self.txt_soul_num.text = Player.Resource.soul .. ""
end

function newpack:onRecycle()
end

function newpack:setSoul(num)
    num = toolFun.moneyNumberShowOne(math.floor(tonumber(num)))
    self.txt_soul_num.text = num
end

function newpack:onEnter()
	LuaMain:ShowTopMenu()
    self.binding:CallAfterTime(0.05, function()
        self:callbackListener()
        end)
end 

--初始化界面
function newpack:Start()
    self.isScroll = true
    Tool.loadTopTitle(self.gameObject, TextMap.GetValue("Text_1_941"))
    LuaMain:ShowTopMenu()
    newpack:initDJ(true)
    -- if totelNum>0 then 
    --     self.scrollView:adjustingLocation()
    -- end
    self.checkdaoju:SetActive(true)
    self.checkjuexing:SetActive(false)
    currentSelectType = 1
	self.info:SetActive(false)

	--newpack:setSoul(Player.Resource.soul)
    -- superLinkData[43] = 10 --悬赏
    -- superLinkData[44] = 9 --挑战
end

return newpack
