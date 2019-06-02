local currency = {}

currencyOldgold = -1
currencyOldmoney = -1
local newScale = Vector3(1.4, 1.4, 1.4)
function currency:update(data)
    if data ==nil then return end 
    if #data==4 then 
        for i=1,#data do
            self["ziyuan" .. i].gameObject:SetActive(true)
            self["ziyuan" .. i]:CallUpdate(data[i])
        end
        self.bg.width=728
    elseif #data==3 then  
        self.ziyuan1.gameObject:SetActive(false)
        for i=1,#data do
            self["ziyuan" .. (i+1)].gameObject:SetActive(true)
            self["ziyuan" .. (i+1)]:CallUpdate(data[i])
        end
        self.bg.width=560
    elseif #data==2 then  
        self.ziyuan1.gameObject:SetActive(false)
        self.ziyuan2.gameObject:SetActive(false)
        for i=1,#data do
            self["ziyuan" .. (i+2)].gameObject:SetActive(true)
            self["ziyuan" .. (i+2)]:CallUpdate(data[i])
        end
        self.bg.width=390
    elseif #data==1 then  
        self.ziyuan1.gameObject:SetActive(false)
        self.ziyuan2.gameObject:SetActive(false)
        self.ziyuan3.gameObject:SetActive(false)
        self.ziyuan4.gameObject:SetActive(true)
        self.ziyuan4:CallUpdate(data[1])
        self.bg.width=220
    end   
end 
--[[function currency:update()
    local bag = Player.Resource
    if currencyOldgold == -1 then
        currencyOldgold = bag.gold
    end
    if currencyOldgold ~= bag.gold then
        currencyOldgold = bag.gold
        self:setGold(currencyOldgold)
    else
        self.txt_gold_num.text = toolFun.moneyNumberShowOne(math.floor(tonumber(currencyOldgold)))
    end
    if currencyOldmoney == -1 then
        currencyOldmoney = bag.money
    end
    if currencyOldmoney ~= bag.money then
        currencyOldmoney = bag.money
        self:setMoney(currencyOldmoney)
    else
        self.txt_money_num.text = toolFun.moneyNumberShowOne(math.floor(tonumber(currencyOldmoney)))
    end
    self:setBp(bag.bp, bag.max_bp)
	self:setVp(bag.vp, bag.max_vp)
    self:setSoul(bag.soul)
    self.binding:CallManyFrame(function()
        self.txt_gold_num.transform.localScale = Vector3.one
        self.txt_money_num.transform.localScale = Vector3.one
    end, 5)
end]]


-- 设置金币
function currency:setMoney(money)
    money = toolFun.moneyNumberShowOne(math.floor(tonumber(money)))
    self.txt_money_num.text = money
    local oldScale = Vector3.one
    local go = self.txt_money_num.gameObject
    self.binding:ScaleToGameObject(self.txt_money_num.gameObject, 0.1, newScale, nil)
	self.binding:CallAfterTime(0.2, function()
		self.binding:ScaleToGameObject(self.txt_money_num.gameObject, 0.1, oldScale, nil)
	end)
end

-- 设置钻石
function currency:setGold(gold)
    gold = toolFun.moneyNumberShowOne(math.floor(tonumber(gold)))
    self.txt_gold_num.text = gold
    local oldScale = Vector3.one
    self.binding:ScaleToGameObject(self.txt_gold_num.gameObject, 0.1, newScale, nil)
		self.binding:CallAfterTime(0.2, function()
		self.binding:ScaleToGameObject(self.txt_gold_num.gameObject, 0.1, oldScale, nil)
	end)
end


-- 设置体力
function currency:setBp(bp, max)
	--if bp > 999 then bp = 999 end
    self.txt_bp_num.text = toolFun.moneyNumberShowOne(math.floor(tonumber(bp))) .. '/' .. max
end

-- 设置精力
function currency:setVp(vp, max)
	--if vp > 999 then vp = 999 end
	self.txt_vp_num.text = toolFun.moneyNumberShowOne(math.floor(tonumber(vp))) .. '/' .. max
end 

function currency:setSoul(num)
    num = toolFun.moneyNumberShowOne(math.floor(tonumber(num)))
    self.txt_soul_num.text = num
end

-- 添加钻石
function currency:onAddGold()
    --   print("添加钻石")
    if UIMrg:GetRunningModuleName() == "purchase" then return end
    DialogMrg.chognzhi()
end

-- 添加金币
function currency:onAddMoney()
    if UIMrg:GetRunningModuleName() == "shop_puyuan" then return end
    uSuperLink.openModule(1)
end

--增加体力
function currency:onAddBp()
    DialogMrg:BuyBpAOrSoul("bp", "", nil)
end

function currency:onAddVp()
	DialogMrg:BuyBpAOrSoul("vp", "", nil)
end 

--灵子增加
function currency:onAddSoul()
    DialogMrg:BuyBpAOrSoul("soul", "", nil)
end

--[[function currency:onClick(go, btnName)
    if btnName == "btn_add_soul" then
        self:onAddSoul()
    elseif btnName == 'btn_add_bp' then
        self:onAddBp()
    elseif btnName == 'btn_add_gold' then
        self:onAddGold()
    elseif btnName == 'btn_add_money' then
        self:onAddMoney()
	elseif btnName == "btn_add_vp" then 
		self:onAddVp()
    end
end]]


function currency:Start()
    --local font = self.txt_money_num.bitmapFont
    --GameManager.SetFont("font/MyDanicFont")
    --local atlas = self.txt_money_num.parent.gameObject:GetComponent(UISprite).atlas
    --GameManager.SetAtlas("AllAtlas/PublicAtlas/publicAtlas")
end

return currency
