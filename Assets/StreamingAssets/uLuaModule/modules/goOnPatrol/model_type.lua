local m = {}

function m:Start()
    -- 	self.select.atlas = myAtlas
    -- 	self.txt_desc.bitmapFont = myFont
    -- 	self.txt_lock.bitmapFont = myFont
end

function m:update(row)
    self.row = row
    local unlock = row.unlock
    local txt = ""
    local txt2 = ""
    local vipLock = true
    local lvLock = true
    for i = 0, unlock.Count - 1 do
        local it = unlock[i]
        if it.unlock_condition == "vip" and Player.Info.vip < it.unlock_arg  then  
            txt = TextMap.getText("TXT_GUIDAO_XIULIAN", { it.unlock_arg })
            txt2 = TextMap.getText("TXT_GUIDAO_XIULIAN", { it.unlock_arg })
            vipLock = false
        end
        if it.unlock_condition == "level" and Player.Info.level < it.unlock_arg  then
            txt = TextMap.getText("TXT_XS_UNLOCK_DESC", { it.unlock_arg })
            txt2 = txt2..TextMap.GetValue("Text_1_357")..TextMap.getText("TXT_XS_UNLOCK_DESC", { it.unlock_arg })
            lvLock = false
        end
    end

    self.lock = true
    self.txt = txt2
    if txt == "" then
        self.lock = false
    end

    if (lvLock and vipLock == false) or (vipLock and lvLock == false) or (lvLock and vipLock) then
        self.lock = false
    elseif vipLock == false and lvLock == false then
        self.lock = true
    end

    if self.lock then
        self.txt_lock.text = TextMap.GetValue("Text_1_358")
    else
        self.txt_lock.text = ""
    end
    self.txt_desc.text = row.desc
    -- self.binding:CallManyFrame(function()
    --     self.model_type.gameObject:GetComponent(UIToggle).enabled = not self.lock
    -- end, 2)
end


function m:setSelect(flag)
    -- local toggle = self.model_type.gameObject:GetComponent(UIToggle)
    -- toggle.value = true
    self.select:SetActive(flag)
end

function m:onClick(go, name)
    if self.lock then
        MessageMrg.show(self.txt)
    end
    Events.Brocast('select_type', self.row.id, self.lock, self.txt)
end


return m