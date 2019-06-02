local itemAll = {}
local tipPanell = {}
local itemDataType = ""

local item_types = "" --物品类型
local data_type = "" --数据类型
local item_ids = 1 --物品ID
local isGray = false --是否灰选
--2015.3.6 日大改
function itemAll:isShowGray(bool)
    self.pic:isShowGray(bool)
    self.kuang_img:isShowGray(bool)
    if (bool == true) then
        self.beijing.spriteName="tubiao_1"
    end
end

function itemAll:callRecycle()
    self.itemRecycle:recycleItemAll()
end

function itemAll:typeId(_type)
    return not Tool.typeId(_type) 
end

function itemAll:resTypeId(_type)
    return Tool.typeId(_type) 
end

function itemAll:onClick()
	if self.click == false then return end
    local temp = {}
    local id = 0
    if self.baseData.itemID~=nil then 
        id =self.baseData.itemID
        temp.obj = RewardMrg.getDropItem({type=self.itemtype,arg=id,arg2=1})
    else 
        temp.obj = self.baseData
    end 
    temp._type = self.itemtype
	temp.type = 1
    MessageMrg.showTips(temp)
end

--采用char类型的数据赋值
function itemAll:updateByChar()
    if self.baseData == nil then
        return
    end
    data_type = self.__type
    itemAll:resetData()
    local atlasName = ""
    local itemtype = self.itemtype
    if self.baseData.itemImage~=nil then
        atlasName=packTool:getIconByName(self.baseData.itemImage)
        self.pic:setImage(self.baseData.itemImage, atlasName)
        self.beijing.spriteName = self.baseData.itemColorBG
        self.kuang_img.Url = UrlManager.GetImagesPath("sl_kuang/"..self.baseData.itemColor ..".png")
        if isGray then 
            self:isShowGray(isGray)
        end
    else 
        atlasName=packTool:getIconByName(self.baseData:getHeadSpriteName())
        self.pic:setImage(self.baseData:getHeadSpriteName(), atlasName)
        self.beijing.spriteName = self.baseData:getFrameBG()
        self.kuang_img.Url = UrlManager.GetImagesPath("sl_kuang/"..self.baseData:getFrame()..".png")
        if isGray then 
            self:isShowGray(isGray)
        end
    end 
	
	self.kuang.gameObject:SetActive(true)
	self.beijing.gameObject:SetActive(true)
    if self.suipian~=nil then self.suipian.gameObject:SetActive(false) end
    if itemtype == "char" or itemType == "pet" or itemtype== "yuling" then
        if self.char~=nil then self.char:SetActive(true) end 
    end
    if self.showNum and self.shuliang~=nil then 
        self.shuliang.gameObject:SetActive(true)
        self.shuliang.text=""
        local num =toolFun.itemNumber(self.baseData.rwCount, self.baseData.id, itemtype)
        if num==1 or num == "1" then 
            self.shuliang.text=""
        else 
            self.shuliang.text = num--toolFun.itemNumber(self.baseData.rwCount, self.baseData.id, self.baseData:getType())
        end 
    end 
    if itemtype == "equipPiece" or itemtype == "charPiece" or itemtype == "charPieceSplit"  or  itemtype == "treasurePiece"  or itemtype == "ghostPiece" or itemtype == "petPiece" or itemtype == "yulingPiece" then
		if self.suipian~=nil then self.suipian.gameObject:SetActive(true)end
        self:SetNumAndSuipianDepth()
    end
end

--采用item类型的数据赋值(不包括人物,怪物等)
function itemAll:updateByItemVO()
    if self.baseData == nil then
        return
    end
    local color = self.baseData.__numColor or ""
    local color_end = self.baseData.__numColor and "[-]" or ""
    if data_type == self.__type then
        if self.baseData.itemID == item_ids and self.baseData.itemType == item_types then
            local num =toolFun.itemVoNumber(self.baseData.itemCount, self.baseData.itemID, item_types)
			if num ==1 then 
                self.shuliang.text=""
            elseif self.showNum then
                self.shuliang.text = color .. toolFun.itemVoNumber(self.baseData.itemCount, self.baseData.itemID, item_types) .. color_end
            end
            return
        end
    end
    data_type = self.__type
    item_ids = self.baseData.itemID
    item_types = self.baseData.itemType
    itemAll:resetData()
    local itemtype = self.baseData.itemType

    self.beijing.spriteName = self.baseData.itemColorBG
    self.kuang_img.Url = UrlManager.GetImagesPath("sl_kuang/"..self.baseData.itemColor..".png")
    --self.kuang.spriteName = self.baseData.itemColor
    self.shuliang.gameObject:SetActive(true)
    local num = toolFun.itemVoNumber(self.baseData.itemCount, self.baseData.itemID, itemtype)
	if num == nil or num == " " or num == "" or num == 0 then 
		num = self.baseData.tempCount or ""
	end
    if num ==1 then 
        self.shuliang.text=""
    elseif self.showNum then
        self.shuliang.text = color .. num .. color_end
    end
	local iconPath = self.baseData.itemImage
	self.kuang.gameObject:SetActive(true)
	self.beijing.gameObject:SetActive(true)
    if itemtype == "equipPiece" or itemtype == "charPiece" or itemtype == "ghostPiece" or itemtype == "treasurePiece" or itemtype == "petPiece" or itemtype == "yulingPiece" then
				if self.suipian~=nil then self.suipian.gameObject:SetActive(true) end
        self:SetNumAndSuipianDepth()
    end
	local atlasName = packTool:getIconByName(iconPath)
	self.pic:setImage(iconPath, atlasName)
end

function itemAll:HideNum( ... )
    self.shuliang.text=""
end

function itemAll:ShowNum(num)
    self.shuliang.gameObject:SetActive(true)
    self.shuliang.text=num
end

function itemAll:SetNumAndSuipianDepth()
    --local _depth = self.kuang.depth;
    --self.suipian:GetComponent(UISprite).depth = _depth+2
    --self.shuliang.depth = 50
end


--采用MonsterVo类型的数据赋值
function itemAll:updateByMonsterVO()
end

--默认里面4个参数
--  data[1] 传入的数据类型 
--  data[2] 传入的数据
--  data[3] 传入的宽度 
--  data[4] 传入的高度 
--  data[5] 是否显示tips   可选，默认不显示  
--  data[6] 是否显示特效外发光，默认不显示
--  data[7]
--  data[8] 屏蔽点击
-- data[9] 是否显示数量
function itemAll:update(data)
    if self.frist == true then
        self.frist = false
        self.itemAll.transform.localScale = Vector3(data[3] / 112, data[3] / 112, 1)
    end 
    self.height = data[3] / 112
    self.baseData = data[2]
    self.__type = data[1]
	self.click = data[8]
    self.showNum=data[9] 
    if self.showNum==nil then 
        self.showNum=true 
    end 
    if data.isGray~=nil then 
        isGray=data.isGray
    end 
    self.itemtype = ""
    if self.baseData.itemType ~= nil then 
        self.itemtype=self.baseData.itemType
    else 
        self.itemtype=self.baseData:getType()
    end 
    if data[1] == "char" then
        itemDataType = "char"
        itemAll:updateByChar()
    elseif data[1] == "charPiece" then
        itemDataType = "charPiece"
        itemAll:updateByChar()
    elseif data[1] == "pet" then
        itemDataType = "pet"
        itemAll:updateByChar()
    elseif data[1] == "petPiece" then
        itemDataType = "petPiece"
        itemAll:updateByChar()
    elseif data[1] == "ghost" then
        itemDataType = "ghost"
        itemAll:updateByChar()
    elseif data[1] == "ghostPiece" then
        itemDataType = "ghostPiece"
        itemAll:updateByChar()
    elseif data[1] == "item" then
        itemDataType = "item"
        itemAll:updateByChar()
    elseif data[1] == "itemvo" then
        itemDataType = "itemvo"
        itemAll:updateByItemVO()
    elseif data[1] == "treasure" then
        itemDataType = "treasure"
        itemAll:updateByChar()
    elseif data[1] == "treasurePiece" then  --宝物碎片
        itemDataType = "treasurePiece"
        itemAll:updateByChar()
    end
    if data[5] ~= nil then
        self.tipsBtn.isEnabled =data[5]
    else
        self.tipsBtn.isEnabled = false
    end

    if data[6] ~= nil then
        -- self:showEffect()
    end
    if data[7] == true and self.isAddUIScrollview == nil then
        self.isAddUIScrollview = true
        self.pic.gameObject:AddComponent("UIDragScrollView")
    end
end

function itemAll:setTipsBtn(flag)
    self.tipsBtn.isEnabled = flag
end

function itemAll:setFrameEnable(flag)
    self.kuang.enabled=flag
    self.text_kuang.enabled=flag
    self.beijing.enabled=flag
    self.cornerMark.enabled=flag
end

--恢复到最开始的状态
function itemAll:resetData()
    if self.char~=nil then self.char:SetActive(false) end 
    if self.suipian~=nil then self.suipian.gameObject:SetActive(false) end 
    --self.binding:Show("shengjie")
    if self.shuliang~=nil then self.shuliang.gameObject:SetActive(false) end 
end

function itemAll:create()
    self.frist = true
    return self
end

function itemAll:showEffect()
    -- local effect = ClientTool.load("Effect/Prefab/UI_zhuangbei_kechuan", self.pic.gameObject)
    -- effect.gameObject.transform.localPosition = Vector3(0,0,0)
    -- effect.gameObject.transform.localScale = Vector3(1,1,1)
end

-- char_font = nil

function itemAll:Start()
    self.kuang.enabled = false
    local text_kuang = self.kuang.gameObject:GetComponent("UITexture")
    if text_kuang == nil then 
        text_kuang=self.kuang.gameObject:AddComponent("UITexture")
        text_kuang.width = 112;
        text_kuang.height = 112;
        text_kuang.depth=self.kuang.depth
        self.text_kuang=text_kuang
    end 
    self.kuang_img = self.kuang.gameObject:GetComponent("SimpleImage")
    if self.kuang_img == nil then 
        self.kuang_img = self.kuang.gameObject:AddComponent("SimpleImage")
    end
end

function itemAll:setDelegate(delegate)
	self.delegate = delegate
end 
function itemAll:onPress(go,name,bPress)
	if (self.delegate == nil or self.delegate.getScrollView == nil) then
		return
	end
  local sv = self.delegate:getScrollView()
	if sv ~= nil then
		sv:Press(bPress);
	end
end

function itemAll:OnDrag(go,name,detal)
	if (self.delegate == nil or self.delegate.getScrollView == nil) then
		return
	end
		
	local sv = self.delegate:getScrollView()
	
	if sv ~= nil then
		sv:Drag();
	end
end
return itemAll