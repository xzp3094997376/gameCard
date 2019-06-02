local item = {}

--为了评审
function item:updateForUc(data)
    self.delegate = data.delegate
    self.server = data.server
    --print_t(data)
    --local len = #self.server.line
    --local temp = self.server.line[1]
	--print_t(data.server)
	local temp = data.server
    local server_name = self.server.name
    local qu_number = self.server.number
    if 1 == 1 then
        self.oneLine = true
        -- self.server = data.line[1]
        --if temp.isSelected then
            -- self.img_status.spriteName = "xuanfu_dian"
            -- self.showImg.spriteName = "xuanfu_xuanzhongdb2"
            -- self.select:SetActive(true)
        --else
            -- self.showImg.spriteName = "xuanfu_buzhongdb2"
            -- self.select:SetActive(false)
        --end
        if data then
            self.txt_number.text =string.gsub(TextMap.GetValue("LocalKey_735"),"{0}",self.delegate.prefix..temp.number)
            local status = temp.status
            --1 流畅  2 火爆  3 维护    
            if status == "1" then
                self.img_status.spriteName = "icon_xin"
                --self.showImg.spriteName = "FWQ-xuanzelang"
                --self.maintenance:SetActive(false)
            elseif status == "2" then
                self.img_status.spriteName = "icon_re"
            elseif status == "3" then
                --self.img_status.spriteName = "FWQ-tishi03"
                --self.showImg.spriteName = "FWQ-xuanzelang03"
                --self.maintenance:SetActive(true)
			elseif status == "0" then 
				self.img_status.spriteName = ""
            end
            self.txt_name.text = temp.name
        end
    else
        self.oneLine = false
        if qu_number ~= nil then 
            self.txt_number.text =string.gsub(TextMap.GetValue("LocalKey_735"),"{0}",qu_number)
        else
            self.txt_number.text =string.gsub(TextMap.GetValue("LocalKey_735"),"{0}",temp.number)
        end
        --self.maintenance:SetActive(false)
        -- self.img_status.spriteName = "xuanfu_lvdian"
        self.txt_name.text = server_name or TextMap.GetValue("Text1317")
        local ret = false
        table.foreach(self.server.line, function(i, v)
            if v.isSelected then
                ret = true
                return
            end
        end)
        if ret then
            -- self.img_status.spriteName = "xuanfu_dian"
            -- self.showImg.spriteName = "xuanfu_xuanzhongdb2"
            --self.select:SetActive(true)
        else
            -- self.showImg.spriteName = "xuanfu_buzhongdb2"
            --self.select:SetActive(false)
        end
    end
end

function item:update(data)
    if SERVER_LIST_FOR_UC then
        --为了评审。。暂时屏蔽
        item:updateForUc(data)
        return
    end
end

function item:onClick(go, name)
    if self.oneLine == false then
        --有多线的情况下弹出选线
        UIMrg:pushWindow("Prefabs/moduleFabs/loginModule/ChannelServer", self.server)
        return
    end
    -- UIMrg:popWindow()
    Events.Brocast('select_server', self.server)
end

return item