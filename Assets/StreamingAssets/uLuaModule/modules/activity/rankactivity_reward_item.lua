local m = {}

function m:update(list, index,delegate)
    self.drag:SetActive(true)
    ClientTool.UpdateGrid("", self.Grid, list.li)
    self.binding:CallManyFrame(function()
            self.view:SetDragAmount(0, 0, false)
        end, 3)
    if list.type~="rank" then 
        if #list.li>3 then
            self.drag:SetActive(true)
        else 
            self.drag:SetActive(false)
        end
        if list.subtype == nil then
            self.Title.text =string.gsub(TextMap.GetValue("Text402"),"{0}",list.rank)
            self.btGet.gameObject:SetActive(false)
        else
            self.Title.text =string.gsub(TextMap.GetValue("LocalKey_793"),"{0}",list.rank)
            self.btGet.gameObject:SetActive(true)
            self.btGet.isEnabled = (list.dw_status == 1)
            self.btGet.gameObject:SetActive(true)
            self.finish:SetActive(false)
            if list.dw_status == 2 then
                self.btGet.gameObject:SetActive(false)
                self.finish:SetActive(true)
                --self.btn_name.text = TextMap.GetValue("Text1671")
            else
                self.btn_name.text = TextMap.GetValue("Text1672")
            end
        end
        ClientTool.AddClick(self.btGet,function()
            if list.dw_status == 1 then
                local dw_id = tonumber(list.dw_id)
                Api:getDangweiReward(list.act_id,dw_id,function(result)
                    print(".........领取奖励成功.........")
                    --self:showMsg(result)
                    packTool:showMsg(result, nil, 1)
                    self.btn_name.text = TextMap.GetValue("Text1671")
                    self.btGet.isEnabled = false
                    if list.delegate ~= nil then
                       list.delegate:DwCallBack(dw_id,2) 
                    end
                    end,function()
                    print(".........领取奖励失败.........")
                    end)
            end
            end)
    else 
        self.Title.text=string.gsub(TextMap.GetValue("LocalKey_776"),"{0}",list.rankId)
        if #list.li>5 then
            self.drag:SetActive(true)
        else 
            self.drag:SetActive(false)
        end
    end 
end

function m:showMsg(drop)
    local list = RewardMrg.getList(drop)
    local ms = {}
    table.foreach(list, function(i, v)
        local g = {}
        g.type = v:getType()
        g.icon = "resource_fantuan"
        g.text = v.rwCount
        g.goodsname = v.name
        table.insert(ms, g)
        g = nil
    end)
    OperateAlert.getInstance:showGetGoods(ms, self.gameObject)
end

function m:onClick(go, name)
    if name == "btn_left" then
        self.slider.value = 0
    elseif name == "btn_right" then
        self.slider.value = 1
    end
end


function m:Start()
    -- self.binding:Hide("img_rank")
    Tool.SetActive(self.img_rank, false)
    if self.txt_rank == nil then
        local go = GameObject("txt_rank")
        go.transform.parent = self.gameObject.transform
        go.transform.localScale = Vector3.one
        go.transform.localPosition = Vector3(-164, 0, 0)
        self.txt_rank = go:AddComponent(UILabel)
        -- self.txt_rank.bitmapFont = actFont
        self.txt_rank.overflowMethod = UILabel.Overflow.ResizeFreely
        self.txt_rank.fontSize = 32
        self.txt_rank.depth = 10
    end
end

return m

