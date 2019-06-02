local checkinReward = {}
local vo = {}
local istheThreeType = 0 -- 0表示已领取或者不能领取，显示物品tips --1表示领取物品 --2.表示领取了一次，但是如果vip的话，还可以再领一次
local isSpealCondition = false
local itemType = "itemvo"
--设置签到基本信息，这个地方逻辑比较复杂
function checkinReward:update(Data)
    self.canReward:SetActive(false)
    isSpealCondition = false
    istheThreeType = 0
    self.data = Data
    if Data.obj.vip == -1 then
        self.img_vip:SetActive(false)
    else
        local msg = string.gsub(TextMap.GetValue("LocalKey_681"),"{0}",Data.obj.vip)
        msg=string.gsub(msg,"{1}",Data.obj.vip_mul)
        self.txt_viplv.text = msg
    end
    self.img_ckuang.gameObject:SetActive(false)
    local infobinding = ClientTool.loadAndGetLuaBindingFromPool("Prefabs/publicPrefabs/itemAll", self.go)
    if Data.obj.drop[0].type == "char" then
        vo = Char:new(Data.obj.drop[0].arg)
        itemType = "char"
        infobinding:CallUpdate({ "char", vo, self.img_ckuang.width, self.img_ckuang.height })
    else
        itemType = "itemvo"
        vo = itemvo:new(Data.obj.drop[0].type, Data.obj.drop[0].arg2, Data.obj.drop[0].arg)
        infobinding:CallUpdate({ "itemvo", vo, self.img_ckuang.width, self.img_ckuang.height })
    end
    infobinding = nil

    --1.领取次数大于当前cell次数，则一定是已经领取
    if Player.Checkin.times > Data.obj.month_time then
        BlackGo.setBlack(0.5, self.go.transform)
        self.img_gou:SetActive(true)
        istheThreeType = 0
        return
    end

    --2.相等并且可领取，那就是第二天的可以领取
    if Player.Checkin.times == Data.obj.month_time and os.time() * 1000 > Player.Checkin.countdown then
        BlackGo.setBlack(0.5, self.go.transform)
        self.img_gou:SetActive(true)
        istheThreeType = 0
        return
    end

    --3.如果相等，并且领取状态为true,那么就是领取了 .false,那就是VIP等级不够并且未领取
    if Player.Checkin.times == Data.obj.month_time then
        if Player.Checkin.fulldrop then
            BlackGo.setBlack(0.5, self.go.transform)
            self.img_gou:SetActive(true)
            istheThreeType = 0
        else
            if Player.Info.vip >= Data.obj.vip then
                istheThreeType = 1 --表示可以领取
                self.canReward:SetActive(true)
                isSpealCondition = true
            else
                self.img_gou:SetActive(true)
                istheThreeType = 2 --表示vip等级不够，不能领取
            end
        end
        return
    end

    --4.表示可以领取
    if (Player.Checkin.times + 1) == Data.obj.month_time and os.time() * 1000 > Player.Checkin.countdown then
        istheThreeType = 1 --表示可以领取
        self.canReward:SetActive(true)
        return
    end
    --5.表示不能领取
    if (Player.Checkin.times + 1) > Data.obj.month_time then
        istheThreeType = 0
    end
end

function checkinReward:onClick(go, name)
    if istheThreeType == 0 then
        local temp = {}
        temp["tipData"] = vo
        temp["tipType"] = itemType
        temp["index"] = self.data.obj.month_time
        local binding = UIMrg:pushWindow("Prefabs/moduleFabs/signModule/checkinTips", temp)
        temp = nil
    elseif istheThreeType == 1 then
        Api:checkin(function(result)
            self.data.label.text =string.gsub(TextMap.GetValue("LocalKey_690"),"{0}",Player.Checkin.times)
            checkinReward:update(self.data) --刷新数据
            local drops = {}
            drops.obj = result
            drops.vip = self.data.obj.vip
            drops.mul = self.data.obj.vip_mul
            drops.special = isSpealCondition
            self.canReward:SetActive(false)
            UIMrg:pushWindow("Prefabs/moduleFabs/signModule/signgetNormal", drops)
            drops = nil
        end)
    elseif istheThreeType == 2 then
        local msg = string.gsub(TextMap.GetValue("LocalKey_700"),"{0}",self.data.obj.vip)
        DialogMrg.ShowDialog(string.gsub(msg,"{1}",self.data.obj.vip_mul),
            function()
                DialogMrg.chognzhi()
            end)
    end
end

--初始化界面
function checkinReward:Start()
end

--初始化
function checkinReward:create(binding)
    self.binding = binding
    return self
end

return checkinReward