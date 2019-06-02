--
-- Created by IntelliJ IDEA.
-- User: xiyou
-- Date: 2014/10/14
-- Time: 13:47
-- To change this template use File | Settings | File Templates.
-- 礼包

local gift = {}

function gift:create()
    return self
end

function gift:update(data, index)
    self.vipPkg = Player.Vippkg
    self.index = index + 1
    -- self.btn_buy.transform.name = data
    self.data = data
    self.txt_name.text =string.gsub(TextMap.GetValue("LocalKey_752"),"{0}",data.id)
    self.txt_buyTip.text = string.gsub(TextMap.GetValue("LocalKey_753"),"{0}",data.id)
    self.sp_icon.spriteName = data.icon
    self.vipLevel = data.id
    if self.vipPkg[data.id] == 1 then
        self.hasBuy:SetActive(true)
        self.btBuy.isEnabled = false
    else
        self.hasBuy:SetActive(false)
        self.btBuy.isEnabled = true
    end
    self.txt_price1.text = data.yuanjia
    self.txt_price.text = data.consume[0].consume_arg
end

function gift:onClick(go, name)
    local index = self.data.id
    if name == "bt_icon" then
        self:showGift(index, TextMap.GetValue("Text1407"))
        return
    end

    if Player.Info.vip < index then
        DialogMrg.ShowDialog(TextMap.GetValue("Text1408"), function()
            Tool.push("activity", "Prefabs/moduleFabs/activityModule/activity_vip",{"","vip"})
        end)
        return
    end
    UIMrg:pushWindow("Prefabs/moduleFabs/puYuanStoreModule/gift_dialog", {
        delegate = self,
        item = self.data
    })

    -- Api:buyVipPackage(index,function(result)
    -- 	if result.ret == 0 then
    -- 		local tween = self.img_buy:AddComponent("TweenScale")
    -- 		tween.from = Vector3(1.7,1.7,1)
    -- 		tween.duration = 0.2
    -- 		self.img_buy:SetActive(true)
    -- 	    self.btn_buy.isEnabled = false
    -- 	    self.sp_buy.spriteName = "shangdian_goumaian_en"
    -- 	end
    -- end)
end

function gift:showGift(id, title)
    local temp = {}
    temp.data = self.data
    temp.lb_title = title
    local binding = UIMrg:pushWindow("Prefabs/moduleFabs/packModule/newUseGet")
    binding:CallTargetFunctionWithLuaTable("checkGift", temp)
end

function gift:onGetGift(id)
    local tween = self.img_buy:AddComponent("TweenScale")
    tween.from = Vector3(1.7, 1.7, 1)
    tween.duration = 0.2
    self.img_buy:SetActive(true)
    self.btn_buy.isEnabled = false
    MusicManager.playByID(30)

    self:showGift(index, TextMap.GetValue("Text1409"))
    -- local g = {}
    -- g.type = 0
    -- g.icon = self.data.icon
    -- g.text = "VIP" .. id .. "礼包 [ceea1a]x1[-]"
    -- local g2 = {}
    -- table.insert(g2, g)
    -- OperateAlert.getInstance:showGetGoods(g2, self.txt_buyTip.gameObject)
end

return gift