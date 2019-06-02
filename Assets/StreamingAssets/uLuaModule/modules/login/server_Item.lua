local item = {}

--为了评审
function item:updateForUc(data, index, _table, delegate)
    self.delegate = delegate
    self.server = data
    local len = #data.line
    if len == 1 then
        self.oneLine = true
        self.server = data.line[1]
        if self.server.isSelected then
            -- self.img_status.spriteName = "xuanfu_dian"
            -- self.showImg.spriteName = "xuanfu_xuanzhongdb2"
            self.select:SetActive(true)
        else
            -- self.showImg.spriteName = "xuanfu_buzhongdb2"
            self.select:SetActive(false)
        end
        if data then
            self.txt_number.text = string.gsub(TextMap.GetValue("LocalKey_735"),"{0}",self.server.number)
            local status = self.server.status
            --1 流畅  2 火爆  3 维护
            if status == "1" then
                self.img_status.spriteName = "FWQ-tishi01"
                self.showImg.spriteName = "FWQ-xuanzelang"
                self.maintenance:SetActive(false)
            elseif status == "2" then
                self.img_status.spriteName = "FWQ-tishi02"
                self.showImg.spriteName = "FWQ-xuanzelang"
                self.maintenance:SetActive(false)
            elseif status == "3" then
                self.img_status.spriteName = "FWQ-tishi03"
                self.showImg.spriteName = "FWQ-xuanzelang03"
                self.maintenance:SetActive(true)
            end
            self.txt_name.text = self.server.name
        end
    else

        self.oneLine = false
        self.txt_number.text = string.gsub(TextMap.GetValue("LocalKey_735"),"{0}",self.server.qu_number)
        self.maintenance:SetActive(false)
        -- self.img_status.spriteName = "xuanfu_lvdian"
        self.txt_name.text = self.server.server_name or TextMap.GetValue("Text1317")
        local ret = false
        table.foreach(self.server.line, function(i, v)
            if v.isSelected then
                ret = true
                return
            end
        end)
        if ret then
            self.select:SetActive(true)
        else
            -- self.showImg.spriteName = "xuanfu_buzhongdb2"
            self.select:SetActive(false)
        end
    end
end

function item:update(data, index, _table, delegate)
    if SERVER_LIST_FOR_UC then
        --为了评审。。暂时屏蔽
        item:updateForUc(data, index, _table, delegate)
        return
    end
    self.delegate = delegate
    self.server = data
    if self.server.isSelected then
        -- self.img_status.spriteName = "xuanfu_dian"
        -- self.showImg.spriteName = "xuanfu_xuanzhongdb2"
        self.select:SetActive(true)
    else
        -- self.showImg.spriteName = "xuanfu_buzhongdb2"
        self.select:SetActive(false)
    end
    if data then
        self.txt_number.text =string.gsub(TextMap.GetValue("LocalKey_735"),"{0}",self.server.number)
        local status = self.server.status
        --1 流畅  2 火爆  3 维护
        if status == "1" then
            self.img_status.spriteName = "FWQ-tishi01"
            self.showImg.spriteName = "FWQ-xuanzelang"
            self.maintenance:SetActive(false)
        elseif status == "2" then
            self.img_status.spriteName = "FWQ-tishi02"
            self.showImg.spriteName = "FWQ-xuanzelang"
            self.maintenance:SetActive(false)
        elseif status == "3" then
            self.img_status.spriteName = "FWQ-tishi03"
            self.showImg.spriteName = "FWQ-xuanzelang03"
            self.maintenance:SetActive(true)
        end
        self.txt_name.text = self.server.name
    end
end

function item:onClick(go, name)
    if self.oneLine == false then
        --有多线的情况下弹出选线
        UIMrg:pushWindow("Prefabs/moduleFabs/loginModule/channelServer", self.server)
        return
    end
    -- UIMrg:popWindow()
    Events.Brocast('select_server', self.server)
end

return item