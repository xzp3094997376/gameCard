local m = {}

function m:Start()
    -- self.txt_time.bitmapFont = myFont
    -- m:findSprite("check1")
    -- m:findSprite("Sprite")
    -- m:findSprite("check")
end

function m:update(data)
    self.data = data
    self.txt_time.text = data.name --TextMap.GetValue("Text854") .. data.name
end

function m:setSelect(flag)
     --local toggle = self.btn_check.gameObject:GetComponent(UIToggle)
     --toggle.value = true
    self.check:SetActive(flag)
end

function m:onClick()
    Events.Brocast('select_time', self.data.id)
end

function m:findSprite(name)
    local tran = self.gameObject.transform:Find(name)
    if tran == nil then return nil end
    m:setAssets(tran.gameObject:GetComponent(UISprite))
end

function m:setAssets(sp)
    if sp then
        sp.atlas = myAtlas
    end
end

return m