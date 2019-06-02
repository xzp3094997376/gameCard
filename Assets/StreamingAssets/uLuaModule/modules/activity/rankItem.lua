--
-- Created by IntelliJ IDEA.
-- User: xiyou
-- Date: 2015/2/6
-- Time: 22:35
-- To change this template use File | Settings | File Templates.
-- 排行
local m = {}

function m:update(data)
    if data == nil then
        self.gameObject:SetActive(false)
        return
    end
    self.gameObject:SetActive(true)

    if data.name ~= nil then
        self.Label.text = data.name
    end
    
    if data.num ~= nil then
        self.txt_power.text = data.num
    end

    if data.vip == cjson.null then
        data.vip = 0
    end
    self.vip_num.text = data.vip
end

function m:Start()
    -- self.img.Url = UrlManager.GetImagesPath("activity/rank_bg.png")
end

return m

