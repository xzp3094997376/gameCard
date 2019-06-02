local member = {}

function member:update(data,index)
    local _type = data._type
    local _muti = data.muti
    --print("##############".._type)
    self.rank.text =string.gsub(TextMap.GetValue("Text402"),"{0}",data.rank)
    local vip = 0

    if data.vip == cjson.null then
        vip = 0
    else
        vip = data.vip
    end

    self.icon_power:SetActive(_type == "rankPower" or _type == "rankJJC" or  _type == "rankTotalPower")
    self.icon_level:SetActive(_type == "rankLvl")
    self.icon_jifen:SetActive(_type == "rankPay")
    self.icon_stars:SetActive(_type == "rankChapterStar")
    self.icon_floor:SetActive(_type == "rankQCT")

    self.power.text = data.num*_muti
    self.vipLv.text = vip
    self.name.text = data.name
    --print("......最大奖励排名是......."..data.max)
    if index + 1 <= data.max then
        self._haRsp.enabled = true
        self._noRsp.gameObject:SetActive(false)
       -- Tool.SetActive(self._line, true)
    else
        self._haRsp.enabled = false
        self._noRsp.gameObject:SetActive(true)
       -- Tool.SetActive(self._line, false)
    end
end

function member:Start()
     -- "itfc_uxjy01"
    local go = NGUITools.AddChild(self.gameObject)
    local tx = go:AddComponent(UITexture)
    tx.depth = 1
    tx.width = 590
    tx.height = 62

    local img = go:AddComponent(SimpleImage)
    img.Url = UrlManager.GetImagesPath("activity/itfc_uxjy01.png")
    self._noRsp = go
    --self._haRsp = go
end


return member