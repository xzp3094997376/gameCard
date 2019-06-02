local item = {}
function item:update(data)
    self.delegate = data.delegate
    self.server = data.server
    if self.server.isSelected then
        self.select:SetActive(true)
    else
        self.select:SetActive(false)
    end
    if data then
        self.txt_number.text =string.gsub(TextMap.GetValue("LocalKey_735"),"{0}",self.delegate.prefix..self.server.number)
        local status = self.server.status
        --1 流畅  2 火爆  3 维护
        if status == "1" then
            self.img_status.spriteName = "FWQ-tishi01"
            self.showImg.spriteName = "FWQ-xuanzelang01"
            self.Sprite:SetActive(true)
            self.maintenance:SetActive(false)
        elseif status == "2" then
            self.img_status.spriteName = "FWQ-tishi02"
            self.showImg.spriteName = "FWQ-xuanzelang01"
            self.Sprite:SetActive(false)
            self.maintenance:SetActive(false)
        elseif status == "3" then
            self.img_status.spriteName = "FWQ-tishi03"
            self.showImg.spriteName = "FWQ-xuanzelang03"
            self.Sprite:SetActive(false)
            self.maintenance:SetActive(true)
        end
        self.txt_name.text = self.server.name
    end
end

function item:onClick(go, name)
    -- if self.oneLine == false then
    --     --有多线的情况下弹出选线
    --     UIMrg:pushWindow("Prefabs/moduleFabs/loginModule/channelServer", self.server)
    --     return
    -- end
    -- -- UIMrg:popWindow()
    Events.Brocast('select_server', self.server)
end

return item