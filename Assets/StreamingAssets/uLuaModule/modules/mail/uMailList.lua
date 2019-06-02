local mailList = {}

function mailList:create(binding)
    self.binding = binding;
    return self
end


function mailList:Start()
	Tool.loadTopTitle(self.gameObject, TextMap.GetValue("Text_1_934"))
    LuaMain:ShowTopMenu()
    self.nomail:SetActive(false)
	self:onUpdate()
end

function mailList:update(...)
end

function mailList:onUpdate()
	Api:checkNewMails(function(ret)
        self:getList() --获取邮件列表
    end, function()
        return false
    end)
end

function mailList:getList(ret)
    --从服务器中得到邮件列表并显示到界面
    local mails = Player.Mails:getLuaTable()
    self._mailList = {}
    local that = self
    local mailCount = 0
    self._isAlldraw = true
    self._isCandelete = false
    table.foreach(mails, function(k, v)
        local m = {}
        m.key = k
        m.mail = v
        m.delegate = that
        m.dropCount = v.drop.count
        if v.draw == nil then
            v.draw = false
        end
        m.isdraw = v.draw


        if v.draw ~= true and  v.drop.count ~= 0 then
            self._isAlldraw = false
        end
            
        if (v.drop.count == 0 and v.read) or (v.drop.count ~= 0 and v.draw) then
            self._isCandelete = true
        end

        m.drop = that:getDrop(v, v.draw)
        mailCount = mailCount + 1
        table.insert(that._mailList, m)
        m = nil
    end)
    if mailCount == 0 then
        self.nomail:SetActive(true)
        self.bt_get.isEnabled = false
        self.bt_delete.isEnabled = false
    else
        self.nomail:SetActive(false)
        if self._isAlldraw then
            self.bt_get.isEnabled = false
        else
            self.bt_get.isEnabled = true
        end
        
        if self._isCandelete then
            self.bt_delete.isEnabled = true
        else
            self.bt_delete.isEnabled = false
        end   

        self:sortList()
        -- local tempForCount = 8-mailCount
        -- if tempForCount>0 then
        --     for i=0,tempForCount do
        --         local m = {}
        --          table.insert(that._mailList,m)
        --          m=nil
        --     end
        -- end
    end
    local _list = self._mailList
    self.scrollview:refresh(self._mailList, self, false)
	self:readAllMail()
    self._mailList = nil
end

function mailList:readAllMail()
	local list = {}
	for i = 1, #self._mailList do 
		local item = self._mailList[i] 
		if item.mail.read == false then 
			table.insert(list, item.key)
		end 
	end 
	if #list > 0 then 
	    Api:readMails( list, function(result)
            --设置邮件的状态为打开
            --self:refreshTable(true)
        end, function()
        end)
	end 
end 

function mailList:isUsedType(_type)
    if self:typeId(_type) then 
        return true 
    elseif Tool.notResType(_type) then 
        return true 
    end 
    return false
end

function mailList:typeId(_type)
    -- local ret = false
    -- TableReader:ForEachLuaTable("resourceDefine", function(k, v)
    --     if _type == v.name then
    --         ret = true
    --         return false
    --     end
    -- end)
    return Tool.typeId(_type)  
end

function mailList:getDrop(info, isGet)
    local drop = info.drop:getLuaTable()
    local _list = {}
    self.dropTypeList = {}
    for i, v in pairs(drop) do
        --if tonumber(i) < 4 then
            if self:isUsedType(v.type) then
                local m = {}
                m.v = v
                m.isGet = isGet
                m.isShowTips = true
                table.insert(_list, m)
                table.insert(self.dropTypeList, m.v.type)
                m = nil
            end
        --end
    end
    return _list
end

--对邮件列表进行排序
function mailList:sortList(...)
    table.sort(self._mailList, function(a, b)
        local mailA = a.mail
        local mailB = b.mail
        --将未读的放在前面
        if mailA.read == false and mailB.read == true then
            return true
            --都未读的将时间最新的放在前面
        elseif mailA.read == false and mailB.read == false then
            return mailA.time > mailB.time
            --已读的按时间排序
        elseif mailA.read == true and mailB.read == true then
            --如果已读有附件按时间
            if a.isdraw == b.isdraw then
                return mailA.time > mailB.time
                --已读有附件的在前面
            elseif a.isdraw == false then
                return true
            end
            return false
        end
        return false
        -- body
    end)
end

function mailList:getKeys()
    self.keys = {}
    for i, j in pairs(self._mailList) do
        table.insert(self.keys, j.key)
    end
end

function mailList:showMailDetailItem(result)
    packTool:showMsg(result, self.msg.gameObject, 0)
end

--一键收取邮件
function mailList:onClick(go, btName)
    --收取邮件,并将邮件都标记为已读
    if btName == "btnclose" then
        UIMrg:pop()
    elseif btName == "bt_get" then
        if Tool:judgeBagCount(self.dropTypeList) == false then return end
       Api:drawAllMails(function(result)
              --print("........good job........")
              self:getList()
              packTool:showMsg(result, self.msg.gameObject, 0)
          end, function()
                 print("error")
          end)
    elseif btName == "bt_delete" then
        Api:deleteAllMails(function(result)
               --print("........good job2222........")
               self:getList()
           end, function()
                  print("error")
           end)
   end
    --    if btName == "btReceive" and self.btReceive.isEnabled == true then
    --        --    self:getKeys()
    --        Api:drawAllMails(function(result)
    --            self:getList()
    --        end, function()
    --        --       print("error")
    --            return true
    --        end)
    --        self.btReceive.isEnabled = false
    --        --    print("收取所有邮件")
    -- --   else
end

function mailList:showMsg(drop)
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


--修改某个指定的邮件是否已读
function mailList:updateRead(isRead, index)
    self._mailList[index].read = isRead
end

--指定某个邮件已经收取
function mailList:updateDrop(index)
    self._mailList[index].dropCount = 0
end

function mailList:onEnter()
	LuaMain:ShowTopMenu()
    --    print("onEnter")
    -- self:getList()
    --self:getReceiveState(self._mailList) --设置是否有附件接受的按钮状态
end



--根据邮件列表中是否有附件来更新收取邮件列表
function mailList:getReceiveState()
    local count = 0
    for i, j in pairs(self._mailList) do
        if j.mail.drop.count ~= nil and j.mail.drop.count ~= 0 then
            count = count + 1
        end
    end
    if count == 0 then
        self.btReceive.isEnabled = false
    else
        self.btReceive.isEnabled = true
    end
end
function mailList:getScrollView()
		return mailList.uiscrollview
end
--刷新邮件列表
function mailList:refresh()
    self.binding:CallManyFrame(function()
        self:getList(true)
    end, 1)
end

return mailList