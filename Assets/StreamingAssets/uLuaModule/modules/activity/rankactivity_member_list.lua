local m = {}

function m:init()
    local it = self.scrollView.transform:Find("Scroll View/Grid"):GetChild(0)
    local p = self.gameObject.transform:Find("bg")
    local go = NGUITools.AddChild(p.gameObject, it.gameObject)
    go.transform.localPosition = Vector3(0, 194, 0)
    self.rank_rewad_item = go:GetComponent(UluaBinding)
    local widget = self.scrollView:GetComponent(UIWidget)
    widget:SetAnchor(p.gameObject, 0, 36, 0, -160)
    -- widget.width = 670
    -- widget.height = 382
    local sc = self.scrollView.transform:Find("Scroll View"):GetComponent(UIPanel)
    sc:SetAnchor(widget.gameObject, 0, 0, 0, 0)

    widget.transform.localPosition = Vector3(0, -62, 0)
end


function m:update(data)

    local me = data.me or {}

    local list = data.list
    if list~=nil then 
        self.scrollView:refresh(list, self, false, 0)
    else 
        self.scrollView:refresh(data, self, false, 0)
    end 

    if self.rank_txt ==nil then  return end
    local rank = me.rank or 9999
    if rank > 9998 then
        rank = TextMap.GetValue("Text1661")
    end
    local title = ""
    if data.me._type == "rankLvl" then
        title = TextMap.GetValue("Text1662")
    elseif data.me._type == "rankPower" then
        title = TextMap.GetValue("Text1663")
    elseif data.me._type == "rankPay" then
        title = TextMap.GetValue("Text1664")
    elseif data.me._type == "rankJJC" then
        title = TextMap.GetValue("Text1665") 
    elseif data.me._type == "rankChapterStar" then
        title = TextMap.GetValue("Text1666")
    elseif data.me._type == "rankQCT" then
        title = TextMap.GetValue("Text1667")
    elseif data.me._type == "rankTotalPower" then
        title = TextMap.GetValue("Text1668")
    else
        title = TextMap.GetValue("Text1669")
    end
    self.rank_txt.text = title.. me.num .. TextMap.GetValue("Text1670") .. rank or 0
end

function m:onClick(go, name)
    if name == "btn_close" then
        UIMrg:popWindow()
    end
end

return m