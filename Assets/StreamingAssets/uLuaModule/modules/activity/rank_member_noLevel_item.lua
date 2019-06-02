local member = {}

function member:update(data, index)
    local _type = data._type
    local vip = 0

    if data.vip == cjson.null then
        vip = 0
    else
        vip = data.vip
    end

    if _type == "pay" then
        if data.money ~= 0 and data.money ~= nil then
            Tool.SetActive(self.zhifen, true)
            Tool.SetActive(self.txt_zhifen, true)
            self.txt_zhifen.text = tonumber(data.money or 0) * tonumber(data.rank_multiple or 1)
        else
            Tool.SetActive(self.zhifen, false)
            Tool.SetActive(self.txt_zhifen, false)
        end
    elseif _type == "power" then
        Tool.SetActive(self.zhifen, true)
        self.zhifen.text = TextMap.GetValue("Text408")
        Tool.SetActive(self.txt_zhifen, true)
        self.txt_zhifen.text = data.num
    end
    local str =TextMap.GetValue("Text402") 
    self.rank.text =string.gsub(str, "{0}",data.rank)
    self.vipLv.text = vip
    self.name.text = data.name

    if index + 1 <= data.max then
        self._norSp.enabled = true
        self._vipSp:SetActive(false)
        Tool.SetActive(self._line, true)
    else
        self._norSp.enabled = false
        self._vipSp:SetActive(true)
        Tool.SetActive(self._line, false)
    end
end

function member:Start()
    local vipSprite = self.gameObject.transform:Find("vipSprite")
    vipSprite.localPosition = Vector3(-120, 4, 0)

    local go = NGUITools.AddChild(vipSprite.gameObject, self.name.gameObject)
    go.transform.localPosition = Vector3(226, -6.1, 0)
    local lab = go:GetComponent(UILabel)
    lab.applyGradient = false
    lab.text = TextMap.GetValue("Text409")
    self.zhifen = lab

    go = NGUITools.AddChild(vipSprite.gameObject, self.name.gameObject)
    self.txt_zhifen = go:GetComponent(UILabel)
    self.txt_zhifen.applyGradient = false
    self.txt_zhifen.color = Color.yellow
    self.txt_zhifen.text = ""
    self.txt_zhifen.pivot = UIWidget.Pivot.Left
    go.transform.localPosition = Vector3(290, -6.1, 0)


    -- "itfc_uxjy01"
    local go = NGUITools.AddChild(self.gameObject)
    local tx = go:AddComponent(UITexture)
    tx.depth = 1
    tx.width = 590
    tx.height = 62

    local img = go:AddComponent(SimpleImage)
    img.Url = UrlManager.GetImagesPath("activity/itfc_uxjy01.png")
    self._norSp = self.gameObject:GetComponent(UISprite)
    self._vipSp = go

    self._line = self.gameObject.transform:Find("line")
end

return member