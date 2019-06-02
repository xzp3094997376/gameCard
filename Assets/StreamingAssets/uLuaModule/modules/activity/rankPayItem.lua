local m = {}

function m:update(data)
    if data ~= nil then
        self.info:SetActive(true)
        self.noWinner:SetActive(false)

        self.Label.text = data.name

        if data.vip == cjson.null then
            data.vip = 0
        end
        self.vip_num.text = data.vip
    else
        self.info:SetActive(false)
        self.noWinner:SetActive(true)
    end
end

function m:Start()
    self.img.Url = UrlManager.GetImagesPath("activity/rankPay_bg.png")
end

return m