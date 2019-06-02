--
-- Created by IntelliJ IDEA.
-- User: xiyou
-- Date: 2014/10/28
-- Time: 10:08
-- To change this template use File | Settings | File Templates.
-- 点金手，买体力

local purchase = {}

--买金币
function purchase:buyMoney()
    local that = self
    Api:buyMoney(function(reuslt)
        MessageMrg.show(TextMap.BUY_SUCC)

        that:onUpdate()
        MusicManager.playByID(25)
    end)
end

--买体力
function purchase:buyBp()
    if self._times == 0 then
        DialogMrg.ShowDialog(BUY_BP_VIP_COUNT, function()
            UIMrg:popWindow()
            DialogMrg.chognzhi()
        end)
        return
    end
    local that = self
    Api:buyBp(function(reuslt)
        --修改成飘字
        self:showBpMsg()
        -- MessageMrg.show(TextMap.BUY_SUCC)
        self.binding:CallAfterTime(1, function()
            UIMrg:popWindow()
        end)
    end)
end

function purchase:showBpMsg()
    --print("sdfh")
    --针对饭团
    local ms = {}
    local g = {}
    g.type = 0
    g.icon = "resource_fantuan"
    print("self.bpNum" .. self.bpNum)
    g.text = self.bpNum
    g.goodsname = TextMap.GetValue("Text46")
    table.insert(ms, g)
    g = nil
    OperateAlert.getInstance:showGetGoods(ms, UIMrg.top)

    -- body
end

--更新体力
function purchase:updateBp()
    self.msg.text = TextMap.GET_BP
    self.buyType.text = TextMap.TITLE_BP
    local bp_time = Player.Times.buybp
    local times = self.bp_limit_times - bp_time
    self._times = times
    self.title.text = string.gsub(TextMap.TITLE_BP_NUM, "{0}", times .. "/" .. self.bp_limit_times)
    self.icon.spriteName = "resource_fantuan"
    local row = TableReader:TableRowByUniqueKey("buyBp", bp_time + 1, "buy_bp")
    if row == nil then
        row = TableReader:TableRowByUniqueKey("buyBp", bp_time, "buy_bp")
    end
    local consume = row.consume
    local i = 0
    local gold = consume[i].consume_arg
    consume = row.drop
    local num = consume[i].arg

    self.bpNum = num
    self.txt_gold.text = gold
    self.txt_number.text = num
end

--更新金币
function purchase:updateMoney()
    self.msg.text = TextMap.GET_MONEY
    self.buyType.text = TextMap.TITLE_MONEY
    local money_time = Player.Times.buymoney
    local times = self.money_limit_times - money_time
    self._times = times
    self.title.text = string.gsub(TextMap.TITLE_MONEY_NUM, "{0}", money_time)
    self.icon.spriteName = "resource_jinbi"
    local row = TableReader:TableRowByUniqueKey("buyMoney", money_time + 1, "buy_money")
    if row == nil then
        row = TableReader:TableRowByUniqueKey("buyMoney", money_time, "buy_money")
    end
    local consume = row.consume
    local i = 0
    local gold = consume[i].consume_arg
    consume = row.drop
    local num = consume[i].arg
    self.txt_gold.text = gold
    self.txt_number.text = num
end


function purchase:onUpdate()
    local type = self.type
    if type == "bp" then
        self:updateBp()
    elseif type == "money" then
        self:updateMoney()
        --    elseif type == "skill_point" then
        --        self:updateSkillPoint()
    end
end

function purchase:update(lua)
    self.type = lua[1] -- lua.type
    local row = TableReader:TableRowByUnique("buyLimitTimes", "vip_level", Player.Info.vip)
    self.bp_limit_times = row.bp_limit_times
    self.money_limit_times = row.money_limit_times
    --    self.skillpoint_limit_times = row.skillpoint_limit_times
    self:onUpdate()
end

function purchase:onOk(go)
    if self.type == "money" then
        self:buyMoney()
    elseif self.type == "bp" then
        self:buyBp()
        --    elseif self.type == "skill_point" then
        --        self:buySkillPoint()
    end
end

function purchase:onCancel(go)
    UIMrg:popWindow()
end

function purchase:onClick(go, name)
    if name == "sure" then
        self:onOk(go)
    elseif name == "cancel" then
        self:onCancel(go)
    end
end

function purchase:create()
    return self
end

return purchase

