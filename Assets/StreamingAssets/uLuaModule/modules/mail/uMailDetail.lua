local detail = {}

local fujianSize = 90
function detail:destroy()
    UIMrg:popWindow()
    --  SendBatching.DestroyGameOject(self.binding.gameObject)
end

function detail:create(binding)
    self.binding = binding;
    return self
end

function detail:update(_table, index)
    self.mailInfo = _table --是update过来的每一个table列表
    self.delegate = _table.delegate --
    self.foreDel = _table.forDelegate
    self.drop = _table.drop
    self._drop = _table.drop
    self.dropCount = _table.dropCount
    self:getDrop()
end

--获取掉落的物品并读表获取相关信息
function detail:getDrop()
    local mail = self.mailInfo.mail
    self.txtSender.text = mail.sender --发件人
    local tab = Tool.getFormatTime(mail.time / 1000)
    self.txtDate.text = "[79ec78]" .. mail.subject .. "[-]"
    self.isGet = mail
    if self.dropCount == 0 then --没有附件
    --只激活居中的删除按钮，同时隐藏附件和两边的收取和删除
        self.btDeleteWithNo.gameObject:SetActive(true)
        self.btReceive.gameObject:SetActive(false)
        self.btDelete.gameObject:SetActive(false)
        --隐藏附件，短富文本，分界线，并显示长富文本
        self.fujian.gameObject:SetActive(true)
        self.richTextConter.gameObject:SetActive(false)
        self.richTextConter_long.gameObject:SetActive(true)
        self.duanbg:SetActive(true)
        self.changbg:SetActive(false)
        self.richText_long:ParseValue(mail.content)
    else
        --隐藏长富文本，中间删除按钮
        self.richTextConter_long.gameObject:SetActive(false)
        self.btDeleteWithNo.gameObject:SetActive(false)
        --激活附件，左删除和右收取按钮和段文本并设置值
        self.fujian.gameObject:SetActive(true)
        self.duanbg:SetActive(true)
        self.changbg:SetActive(false)
        self.richTextConter.gameObject:SetActive(true)
        self.richText:ParseValue(mail.content)
        if self.mailInfo.mail.draw == nil then
            self.mailInfo.mail.draw = false
        end
        if self.mailInfo.mail.draw then --如果未领取
        self.btReceive.gameObject:SetActive(false)
        self.btDelete.gameObject:SetActive(true)
        else
            self.btReceive.gameObject:SetActive(true)
            self.btDelete.gameObject:SetActive(false)
        end

        self:updateTable(self.drop, self.mailInfo.mail.draw)
    end
end


function detail:Start()
    -- ClientTool.AddClick(self.bg, function()
    --     self.delegate:refresh()
    --     UIMrg:popWindow()
    -- end)
end

function detail:showMsg(drop)
    local list = RewardMrg.getList(drop)
    local ms = {}
    table.foreach(list, function(i, v)
        local g = {}
        g.type = v:getType()
        g.icon = "resource_fantuan"
        g.text = v.rwCount
        g.goodsname = v.name
        table.insert(ms, g)
        g = nil
    end)

    OperateAlert.getInstance:showGetGoods(ms, self.msg.gameObject)
end

function detail:updateTable(_list, isGet)
    local m = {}
    self.dropTypeList = {}
    table.foreach(_list, function(k, value)
        --if k <= 4 then
            local l = {}
            l.v = value.v
            l.isGet = isGet
            l.isShowTips = true
            table.insert(m, l)
            table.insert(self.dropTypeList, l.v.type)
            l = nil
        --end
    end)
    ClientTool.UpdateMyTable("Prefabs/moduleFabs/mailModule/mail_item", self.fujianTable, m)
end

function detail:onClick(go, btName)

    if btName == "btReceive" then
        if Tool:judgeBagCount(self.dropTypeList) == false then return end
        local that = self
        --获取附件操作
        -- Api:drawMails({ self.mailInfo.key }, function(result)
        --     self:updateTable(self.mailInfo.drop, true)
        -- end, function()
        --     --   print("error")
        --     return false
        -- end)
        Api:drawMails({ self.mailInfo.key }, function(result)
            --     print("收取附件")
            --  SendBatching.DestroyGameOject(self.pacTable.gameObject)
            --     self._list = {}
            --设置小item有附件状态
            --  self.foreDel:getFujian({})
            --    self:updateTable(_list)
            self:updateTable(self.drop, true)
            self.btReceive.gameObject:SetActive(false)
            self.btDelete.gameObject:SetActive(true)
            self.foreDel:getFujian(self.drop, true)
            packTool:showMsg(result, self.msg.gameObject, 0)
			--self.delegate:onUpdate()
            for i,v in ipairs(self.foreDel.mailInfo.drop) do
                v.isGet=true
            end
            self.foreDel.mailInfo.isdraw=true
            self.foreDel:update(self.foreDel.mailInfo)
            -- Api:deleteMails({ self.mailInfo.key }, function(result)
            --     self.delegate:refresh()
            --     self:destroy()
            -- end, function()
            -- --  DialogMrg.ShowDialog("请先收取附件再删除")
            --     return false
            -- end)
        end, function()
            --   print("error")
            return false
        end)
    elseif btName == "btDelete" then
        --删除该邮件操作
        Api:deleteMails({ self.mailInfo.key }, function(result)
            --     print(TextMap.GetValue("Text236"))
            self:destroy()
            self.delegate:refresh()
        end, function()
            --  DialogMrg.ShowDialog("请先收取附件再删除")
            return false
        end)
    elseif btName == "btDeleteWithNo" then
        Api:deleteMails({ self.mailInfo.key }, function(result)
            --    print(TextMap.GetValue("Text236"))
            self:destroy()
            self.delegate:refresh()
        end, function()
            return false
        end)
    elseif btName == "btclose" then
        self:destroy()
        --self.delegate:refresh()
    end
end

return detail