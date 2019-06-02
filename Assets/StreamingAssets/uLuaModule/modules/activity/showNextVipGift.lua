--
-- Created by IntelliJ IDEA.
-- User: xiyou
-- Date: 2015/3/14
-- Time: 11:42
-- To change this template use File | Settings | File Templates.
-- 下一级活动-vip礼包奖励
local m = {}

function m:update(data)

    local vip = Player.Info.vip
    vip = vip == 0 and 1 or vip

    local list = {}
    if data.drop["" .. vip] then list = data.drop["" .. vip] end
    ClientTool.UpdateGrid("Prefabs/moduleFabs/activityModule/itemActivity", self.GridCur, list)

    self.vip_num_cur.text = vip
    self.vip_num_next.text = vip + 1
    local next = vip + 1
    if data.drop["" .. next] then list = data.drop["" .. next] end

    self.binding:CallManyFrame(function()
        ClientTool.UpdateGrid("Prefabs/moduleFabs/activityModule/itemActivity", self.GridNext, list)
    end)
    local exp = Player.Resource.vip_exp
    local count = 15
    vip = Player.Info.vip
    local next_index = self.vip == count and count or vip
    local row = TableReader:TableRowByID("vipLevel", next_index)
    local exp_next = row.vip_exp
    self.txt_count.text = "[01ff13]" .. (exp / 10) .. "[-]" .. "/" .. (exp_next / 10)
    if exp > exp_next then
        self.slider_di.value = 1
    else
        self.slider_di.value = exp / exp_next
    end

    local next_money = 0

    if exp <= exp_next then
        next_money = math.ceil((exp_next - exp) / 10) --向上取整
    end
    local str=string.gsub(TextMap.GetValue("LocalKey_660"),"{0}",next_money)
    str=string.gsub(str,"{1}",next_index + 1)
    self.Label.text = str
end

function m:onClick(go, name)
    if name == "btn_close" then
        UIMrg:popWindow()
    elseif name == "btCharge" then
        UIMrg:popWindow()
        Tool.push("activity", "Prefabs/moduleFabs/activityModule/activity_vip",{"","vip"})
    end
end

return m
