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

function m:Start()
end



function m:update(data)
    -- print("list")
    -- print(list)
    local me = data.me or {}
    local list = data.list
    self.scrollView:refresh(list, self, false, 0)

    if self.gameObject.name ~= "act_rank_list_noLevel" then
        self.binding:CallAfterTime(0.2, function()
            if self.rank_rewad_item == nil then
                m:init()
            end
            if self.rank_rewad_item then
                self.rank_rewad_item:CallUpdate(me)
            end
            self.scrollView.transform:Find("Scroll View"):GetComponent(UIScrollView):ResetPosition()
        end)
    else
        if data.title then
            local title = self.gameObject.transform:Find("bg/Sprite/Label"):GetComponent(UILabel)
            title.text = data.title
        end
        if self.me_rank == nil then
            local lab = self.gameObject.transform:Find("bg/Sprite/Label").gameObject
            local go = NGUITools.AddChild(self.gameObject, lab):GetComponent(UILabel)
            go.fontSize = 20
            go.transform.localPosition = Vector3(-120, 260, 0)
            self.me_rank = go
            self.me_rank.overflowMethod = UILabel.Overflow.ResizeFreely
        end
        if data.type == "power" then
            local num = me.power or Tool.getTeamPower()
            local rank = me.rank or 999
            if rank > 50 then
                rank = TextMap.GetValue("Text404")
            end
            self.me_rank.text = TextMap.GetValue("Text405") .. num .. TextMap.GetValue("Text406") .. rank or 0
            return
        end
        local num = me.money or 0
        num = num * (data.rank_multiple or 1) or 0
        self.me_rank.text = TextMap.GetValue("Text407") .. num .. TextMap.GetValue("Text406") .. me.rank or 0
    end
end

function m:onClick(go, name)
    if name == "btn_close" then
        UIMrg:popWindow()
    end
end

return m