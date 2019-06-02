local member = {}

function member:update(data)
    local _type = data._type
    local str =TextMap.GetValue("Text402") 
    self.rank.text =string.gsub(str, "{0}",data.rank)
    local vip = 0

    if data.vip == cjson.null then
        vip = 0
    else
        vip = data.vip
    end
    if _type == "level" then
        self.icon_power:SetActive(false)
        self.icon_level:SetActive(true)
        --self.typeSprite.spriteName="tongyong_lv"


    elseif _type == "power" then
        self.icon_power:SetActive(true)
        self.icon_level:SetActive(false)
        --self.typeSprite.spriteName="Tongyong_lingya"
    end
    self.power.text = data.num
    self.vipLv.text = vip
    self.name.text = data.name
end


return member