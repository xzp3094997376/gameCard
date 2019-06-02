local actSigninItem = {}
local infobinding = nil
local checkState = 0
local checkIndex = 0
function actSigninItem:Start()
end

--0.不存在 1.不可领取  2.可领取  3.未领完  4.领取完毕 5.补签
function actSigninItem:showByType(_type)
    self.buqian:SetActive(false) --隐藏补签
    self.selectKuang:SetActive(false)
    self.img_reward:SetActive(false) --隐藏可领取
    self.vipTip:SetActive(false)
    BlackGo.setBlack(1, self.normal.transform)
    if _type == 1 then
        return
    elseif _type == 2 then
        self.selectKuang:SetActive(true)
    elseif _type == 3 then
        if self._data.vip <= Player.Info.vip then
            self.selectKuang:SetActive(true)
        else
            self.img_reward:SetActive(true)
        end
        actSigninItem:blackFun()
        self.vipTip:SetActive(true)
        self.vipTip_nor.text=string.gsub(TextMap.GetValue("LocalKey_784"),"{0}",self._data.vip)
    elseif _type == 4 then
        self.img_reward:SetActive(true)
        actSigninItem:blackFun()
    elseif _type == 5 then
        --actSigninItem:blackFun()
        self.buqian:SetActive(true)
        self.txt_price.text = self._data.price .. TextMap.GetValue("Text_1_19")
    end
end


function actSigninItem:blackFun()
    local that = self
    self.binding:CallAfterTime(0.1, function()
        BlackGo.setBlack(0.5, that.normal.transform)
    end)
end

function actSigninItem:mulToChinese(num,vip)
    if num == 2 then
        return string.gsub(TextMap.GetValue("LocalKey_671"),"{0}",vip)
    elseif num == 3 then
        return string.gsub(TextMap.GetValue("LocalKey_672"),"{0}",vip)
    elseif num == 4 then
        return string.gsub(TextMap.GetValue("LocalKey_673"),"{0}",vip)
    elseif num == 5 then
        return string.gsub(TextMap.GetValue("LocalKey_674"),"{0}",vip)
    elseif num == 6 then
        return string.gsub(TextMap.GetValue("LocalKey_675"),"{0}",vip)
    elseif num == 7 then
        return string.gsub(TextMap.GetValue("LocalKey_676"),"{0}",vip)
    elseif num == 8 then
        return string.gsub(TextMap.GetValue("LocalKey_677"),"{0}",vip)
    elseif num == 9 then
        return string.gsub(TextMap.GetValue("LocalKey_678"),"{0}",vip)
    elseif num == 10 then
        return string.gsub(TextMap.GetValue("LocalKey_679"),"{0}",vip)
    end
end

function actSigninItem:update(data)
    if data == nil then
        self.act_signItem:SetActive(false)
        return
    end
    self._data = data
    if checkState == tonumber(self._data.state) and checkIndex == self._data.index then -- 如果状态一致并且名字一致
    return
    end
    self.act_signItem:SetActive(true)
    self.vip:SetActive(false)
    actSigninItem:showByType(tonumber(self._data.state))
    if data.vip > 0 then
        self.vip:SetActive(true)
        self.txt_viplv.text =actSigninItem:mulToChinese(data.mul + 1,data.vip)
    end
    local times = string.gsub(TextMap.GetValue("LocalKey_785"),"{0}",self._data.month)
    times=string.gsub(times,"{1}",self._data.index)
    if self._data.state==2 then  
        self.month.text = "[FF2626]" .. times
    else
        self.month.text = "[C34008]" .. times
    end
    if infobinding == nil then
        infobinding = ClientTool.loadAndGetLuaBindingFromPool("Prefabs/publicPrefabs/itemAll", self.img_kuang.gameObject)
    end
    if self._data.type == "char" then
        vo = Char:new(self._data.id)
        infobinding:CallUpdate({ "char", vo, self.img_kuang.width, self.img_kuang.height })
    else
        vo = itemvo:new(self._data.type, self._data.num, self._data.id)
        infobinding:CallUpdate({ "itemvo", vo, self.img_kuang.width, self.img_kuang.height })
    end
    if vo ~= nil then
        self.itemName.text = vo.itemColorName
    end
    data = nil
    vo = nil
end

--0.不存在 1.不可领取  2.可领取  3.未领完  4.领取完毕 5.补签
function actSigninItem:onGetAward(_type)
    if _type == 1 then
        MessageMrg.show(self.month.text .. TextMap.GetValue("Text390"))
        return
    elseif _type == 4 or _type == 5 then
        return
    elseif _type == 2 then
        Api:getActGift(self._data.actID, self._data.index, function(result)
            if result.drop ~= nil then
                self:showMsg(result, self._data.event)
                self.img_reward:SetActive(true) --隐藏可领取
                self._data.father:refreshEveryPay()
            end
        end, function()
            return false
        end)
    elseif _type == 3 then
        if self._data.vip <= Player.Info.vip then
            Api:getActGift(self._data.actID, self._data.index, function(result)
                if result.drop ~= nil then
                    self:showMsg(result, self._data.event)
                    self.img_reward:SetActive(true) --隐藏可领取
                    self._data.father:refreshEveryPay()
                end
            end, function()
                return false
            end)
        else
            actSigninItem:NeedChongzhi("VIP" .. self._data.vip .. TextMap.GetValue("Text391"))
        end
    end
end

function actSigninItem:NeedChongzhi(str)
    DialogMrg.ShowDialog(str,
        function()
            UIMrg:pop()
            DialogMrg.chognzhi()
        end, nil)
end


function actSigninItem:buqianHandler()
    if Player.Resource.gold < self._data.price then
        actSigninItem:NeedChongzhi(TextMap.GetValue("Text392"))
        return
    end
    local msg = string.gsub(TextMap.GetValue("LocalKey_669"),"{0}",self._data.price)
    msg=string.gsub(msg,"{1}",self.month.text)
    DialogMrg.ShowDialog(msg,
        function()
            Api:fillLogin30CheckIn(self._data.actID, self._data.index,
                function(result)
                    if result.drop ~= nil then
                        self:showMsg(result, self._data.event)
                        self._data.father:refreshEveryPay()
                    end
                end,
                function()
                    return false
                end)
        end, nil)
end

function actSigninItem:onClick(go, btName)
    if btName == "btn" then --领取
    actSigninItem:onGetAward(tonumber(self._data.state))
    elseif btName == "button" then --补签
    actSigninItem:buqianHandler()
    end
end

function actSigninItem:showMsg(drop, event)
    local tp = 1
    if event == "doubleMoney" or event == "getBP" then
        tp = 0
    end
    packTool:showMsg(drop, nil, tp)
end

return actSigninItem