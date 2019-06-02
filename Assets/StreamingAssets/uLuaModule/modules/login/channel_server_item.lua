local m = {}

local bgSprite = { normal = "FWQ-XZX-xuanzelang01", maintenance = "FWQ-XZX-xuanzelang02" }
local statusSprite = { normal = "FWQ-tishi01", busy = "FWQ-tishi02", maintenance = "FWQ-tishi03" }

function m:update(data, index, delegate)
    self.txt_server.text = data.name
    self.server = data

    if (data.isSelected) then
        -- self.btn_select.normalSprite = bgSprite.selected
        --self.sp_bg.spriteName = bgSprite.selected
        self.select:SetActive(true)
    else
        -- self.btn_select.normalSprite = bgSprite.notSelected
        --self.sp_bg.spriteName = bgSprite.notSelected
        self.select:SetActive(false)
    end

    --1 流畅  2 火爆  3 维护
    if data.status == "1" then
        self.sp_status.spriteName = statusSprite.normal
        self.btn_select.normalSprite = bgSprite.normal
        self.maintenance:SetActive(false)
    elseif data.status == "2" then
        self.sp_status.spriteName = statusSprite.busy
        self.sp_status.spriteName = statusSprite.normal
        self.maintenance:SetActive(false)
    elseif data.status == "3" then
        self.sp_status.spriteName = statusSprite.maintenance
        self.sp_status.spriteName = statusSprite.maintenance
        self.maintenance:SetActive(true)
    end
end

function m:onClick(go, name)
    if name == "btn_select" then
        UIMrg:popWindow()
        Events.Brocast('select_server', self.server)
    end
end

return m