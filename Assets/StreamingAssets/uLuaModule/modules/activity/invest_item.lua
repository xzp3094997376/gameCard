local item = {}

function item:update(data, index, delegate)
    self.btReward.gameObject:SetActive(true)
    self.hasGet:SetActive(false)
    self.delegate = delegate

    local drop = data.drop
    local package = data.package
    self.gid = package.id
    self.status = self.delegate.data.status[self.gid]
    if self.status == 1 then
        self.delegate:countMutliPoint(true)
    end
    if self.status ~= nil then
        if self.status == 1 then
            self.hasGet:SetActive(false)
            self.btReward.isEnabled = true
        elseif self.status == 2 then
            self.btReward.gameObject:SetActive(false)
            self.hasGet:SetActive(true)
        end

    else
        self.hasGet:SetActive(false)
        self.btReward.isEnabled = false
    end
    self.Title.text =string.gsub(TextMap.GetValue("LocalKey_787"),"{0}",data.lv)
    self.lv.text="" 
    self.Grid:refresh("Prefabs/moduleFabs/activityModule/itemActivity", drop,self.delegate)
    self.drag:SetActive(true)
    if #drop>3 then
        self.drag:SetActive(true)
    else 
        self.drag:SetActive(false)
    end
end




function item:onClick(go, name)
    if name == "btReward" then
        if self.status ~= nil and self.status == 1 then
            self:onBtGet()
        end
    elseif name == "btn_left" then
        self.slider.value = 0
    elseif name == "btn_right" then
        self.slider.value = 1
    end
end

function item:onBtGet()
    if self.status == 1 then
        self.delegate.delegate:getMutliPackage(self, self.delegate.data.id, self.gid,function ()
            self.delegate:refreshinvestPlan()
        end)
    end
end

function item:getCallBack()
    self.btReward.gameObject:SetActive(false)
    self.hasGet:SetActive(true)
    -- self.btn_name.text = TextMap.GetValue("Text397")
    --self.btGet.isEnabled = false
    self.status = 2
    self.delegate:countMutliPoint(false)
    if self.delegate.mutliPoint < 1 then
        self.delegate.delegate:hideEffect()
    end
end


return item