local componseview = {}
local step = 1
local inc = 0
local sell_price = 0
local buy_num = 0
local sell_discount = 0
function componseview:update(tempdata)

    local maxCount = tempdata.maxCount
    step =  1

   	self.prize = tempdata.tatio
    self.cost_item = tempdata.cost_item
    self.item = tempdata.compose_item
    self.act_id = tempdata.act_id
    self.delegate=tempdata.delegate

   --[[ if self.item.isRes ~= nil and self.item.isRes then
        self.txt_name.text = self.item.name
    else
        self.txt_name.text = self.item:getDisplayColorName()
    end-]]
    
    self.numberSelect:setCallFun(componseview.setMoneyChange, self)
    local binding = ClientTool.loadAndGetLuaBindingFromPool("Prefabs/publicPrefabs/itemAll", self.img_kuangzi.gameObject)

    local vo = itemvo:new(tempdata.item.type, tempdata.item.arg2, tempdata.item.arg)
    self.txt_name.text = vo.itemColorName
    self.txt_desc.text = TextMap.GetValue("Text_1_1068") .. Player.ItemBagIndex[tempdata.item.arg].count

    binding:CallUpdate({ "itemvo", vo, self.img_kuangzi.width, self.img_kuangzi.height })
    
    self.numberSelect:maxNumValue(maxCount)
    self.numberSelect.selectNum = 1
    self.number.gameObject:SetActive(false)

    local vo_cost = itemvo:new(tempdata.cost_item.type, tempdata.cost_item.arg2, tempdata.cost_item.arg)
    --local iconName = Tool.getResIcon(shop_item.sell_type)
    self:setIcon("moneySprite", vo_cost.itemImage, true)
end


function componseview:setIcon(old, name, ret)
    local assets = packTool:getIconByName(name)
    self.img_coin:setImage(name, assets)
    --Tool.SetActive(self[old], ret)
end

function componseview:setMoneyChange()
     self.money.text = self.selectNum.text * self.prize
  --[[  buy_num = self.item.buy_num
    local num = tonumber(self.selectNum.text)
    local eprice = 0
    local tprice = 0
    for i = 1, num do
        buy_num = buy_num + 1
        eprice = sell_price + math.floor((buy_num - 1) / step) * inc
        --print(eprice)
        --出售上限
        if self.item.inc_limit ~= nil then
            if eprice > self.item.inc_limit then eprice = self.item.inc_limit end
        end
        tprice = math.floor(tprice + eprice * sell_discount / 100 + 0.5)
    end
    tprice = math.floor(tprice + 0.5)
    self.money.text = tprice-]]
end

function componseview:useSellBack()
    UIMrg:popWindow()
end

function componseview:onClick(go, name)
    if name == "btn_quxiao" or name== "btnClose" or name=="closeBtn" then
        UIMrg:popWindow()
    end
    if name == "btn_queren" then
        componseview:senAPI()
        self.btn_queren.isEnabled = false
    end
end



function componseview:senAPI()
	Api:WishingCoinCompound(self.act_id, tonumber(self.selectNum.text), function(result)
        if result.ret == 0 then
            MessageMrg.showMove(TextMap.GetValue("Text370") .. self.txt_name.text .. " [-]X " .. self.selectNum.text)
            self.delegate:updateRes()
        end
 	UIMrg:popWindow()
    end,function ()
        --componseview.bgBox:SetActive(false)
        return false
    end)

end


return componseview