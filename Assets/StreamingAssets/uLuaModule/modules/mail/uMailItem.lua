local mailItem = {}


function mailItem:create(binding)
    return self
end

function mailItem:destory()
    SendBatching.DestroyGameOject(self.binding.gameObject)
end

--从父item获取该item的相关信息
function mailItem:update(_table)
    if _table == nil then
        self.gameObject:SetActive(false)
        return
    end
    self.gameObject:SetActive(true)
		self.delegate = _table.delegate
    self.mailInfo = _table
    self.mailInfo.forDelegate = self
    self.mailInfo.mail = _table.mail
    self.mailInfo.dropCount = _table.dropCount
    self.mailInfo.drop = _table.drop
    self.txtSubject.text = _table.mail.subject --邮件主题
    --self.txtSender.text = TextMap.FROM .. "[ffdf87]" .. mail.sender .. "[-]" --发件人
    local tab = Tool.getFormatDate(_table.mail:getLong("time") / 1000)
    self.txtDate.text = TextMap.GetValue("Text1320") .. "[00ff00]" .. tab .. "[-]"

    self:refreshTable(_table.mail.read)
    self.fujianTable.gameObject:SetActive(true)
    if self.mailInfo.dropCount == 0 then
        self.fujianTable.gameObject:SetActive(false)
		self.btnDelete.gameObject:SetActive(false)
		self.btnGet.gameObject:SetActive(false)
    else
        self.fujianTable.gameObject:SetActive(true)
				self.richText:clearContent()
				self.richText:ParseValue(self.mailInfo.mail.content)
        if self.mailInfo.mail.draw == nil then
            self.mailInfo.mail.draw = false
        end
		if self.mailInfo.isdraw == true then 
            self.img_get:SetActive(true)
            self.img_set:SetActive(false)
			self.btnDelete.gameObject:SetActive(true)
			self.btnGet.gameObject:SetActive(false)
		else 
			self.img_get:SetActive(false)
            self.img_set:SetActive(true)
			self.btnDelete.gameObject:SetActive(false)
			self.btnGet.gameObject:SetActive(true)
		end 
        --self.binding:CallManyFrame(function()
            ClientTool.UpdateMyTable("Prefabs/moduleFabs/mailModule/mail_item", self.fujianTable, self.mailInfo.drop,self.delegate)
        --end, 1)
        -- self.binding:CallManyFrame(function()
        --       self:getFujian(self.mailInfo.drop, self.mailInfo.mail.draw)
        --   end, 1)
    end
	
	--if self.mailInfo.mail.read == false then
    --    --执行服务器代码
    --    Api:readMails({ self.mailInfo.key }, function(result)
    --        --设置邮件的状态为打开
    --        --self:refreshTable(true)
    --    end, function()
    --    end)
    --end
end


function mailItem:getFujian(_list, isGet)
    local m = {}
    table.foreach(_list, function(k, value)
        --if k <= 4 then
            local l = {}
            l.isGet = isGet
            l.v = value.v
            l.isShowTips = false
            table.insert(m, l)
            l = nil
        --end
    end)
    ClientTool.UpdateMyTable("Prefabs/moduleFabs/mailModule/mail_item", self.fujianTable, m)
    _list = nil
    if isGet then
        self.img_get:SetActive(true)
        self.img_set:SetActive(false)
        self.btnDelete.gameObject:SetActive(true)
        self.btnGet.gameObject:SetActive(false)
    end
end

--更新客户端是否读的图标
function mailItem:refreshTable(state)

    -- 已读
    --if state then
    --    self.txtSubject.text = "[696565]" .. self.mailInfo.mail.subject .. "[-]" --邮件主题设为灰色
    --    self.icon.spriteName = "mail_read";
    --else
    --    self.icon.spriteName = "mail_unread";
    --end
end

--点击邮件列表中的某一个显示详细信息
function mailItem:onClick(go, btName)
    if btName == "btnGet" then
        UIMrg:pushWindow("Prefabs/moduleFabs/mailModule/mail_receive", self.mailInfo )
  --       MusicManager.playByID(27)
		-- local that = self
  --       --获取附件操作
  --       Api:drawMails({ self.mailInfo.key }, function(result)
		-- 	self:getFujian(self.mailInfo.drop, true)
  --           self.delegate:showMailDetailItem(result)
		-- 	self.delegate:refresh()
  --       end, function()
  --           --   print("error")
  --           return false
  --       end)
	elseif btName == "btnDelete" then 
		 --删除该邮件操作
        Api:deleteMails({ self.mailInfo.key }, function(result)
            self.delegate:refresh()
        end, function()
            return false
        end)
	elseif btName == "btnclose" then 
		UIMrg:popWindow()
    elseif btName == "btDetail" then 
        UIMrg:pushWindow("Prefabs/moduleFabs/mailModule/mail_receive", self.mailInfo )
    end
end


return mailItem