local page = {}

function page:create()
    return self
end

function page:update(data)
    self.isExt = false
    if data~=nil then 
        self.data = data
    end 
    self.delegate = self.data.delegate
    local drop = self.data.drop
    
    local package = self.data.package
    self.gid = package.id
    if self.delegate.data.extra_status then
        self.extra_status = self.delegate.data.extra_status[self.gid]
    end
    self.status = self.delegate.data.status[self.gid]
    if self.status == 1 or self.extra_status == 1 then
        self.delegate:countMutliPoint(true)
    end
    self.Title.text = package.name
    self.btGet.gameObject:SetActive(true)
    self.finish:SetActive(false)
    self.btRecharge.gameObject:SetActive(false)
    if self.status ~= nil then
        if self.status == 2 then
            table.foreach(drop, function(i, v)
                v.has = true
            end)
        end
        if self.status == 1 or ((self.extra_status == 1 or self.extra_status == nil) and self.data.extra_drop and self.item_for_yueka) then
            self.btn_name.text = TextMap.GetValue("Text1672")
            self.btGet.isEnabled = true
        elseif self.status == 2 then
            self.btGet.gameObject:SetActive(false)
            self.finish:SetActive(true)
        end
    else
        self.btGet.isEnabled = false
        self.btn_name.text = TextMap.GetValue("Text1672")
        if self.data.event_type == "totalPay" then
            self.btGet.gameObject:SetActive(false)
            self.btRecharge.gameObject:SetActive(true)
        end
    end
    
    -- 可选择物品逻辑
    self.drag:SetActive(true)
    self.Grid:refresh("Prefabs/moduleFabs/activityModule/itemActivity", drop,self.delegate)

    --月卡玩家。
    if self.data.extra_drop and self.item_for_yueka then
        self.binding:Show("item_for_yueka")
        if self.extra_status == 2 then self.data.extra_drop.has = true end
        self.item_for_yueka:CallUpdate(self.data.extra_drop)
    elseif self.item_for_yueka then
        self.binding:Hide("item_for_yueka")
    end
    local isDrag = 3
    -- 可选择物品逻辑
    if self.data.event_type == "totalPay" or self.data.event_type == "totalCost" or self.data.event_type == "migrateGift" then
        if self.data.selectPackage ~= nil and self.data.selectName ~= nil and self.data.selectIcon ~= nil then
            self.RandomItem:SetActive(true)
            self.icoTex.gameObject:SetActive(true)
            local bg_icon =  "itemImage/" .. self.data.selectIcon .. ".png"
            self.icoTex.Url = UrlManager.GetImagesPath(bg_icon)  
            self.Grid.transform.localPosition = Vector3(-35,0,0)
        else
            self.Grid.transform.localPosition = Vector3(-150,0,0)
            self.RandomItem:SetActive(false)
            self.icoTex.gameObject:SetActive(false)
        end
    else
        if self.data.extra_drop ~= nil and self.data.selectName ~= nil and self.data.selectIcon ~= nil then
            self.icoTex.gameObject:SetActive(true)
            local bg_icon = "itemImage/" .. self.data.selectIcon .. ".png"
            self.icoTex.Url = UrlManager.GetImagesPath(bg_icon)  
            self.Grid.transform.localPosition = Vector3(-35,0,0)
            isDrag=2
        else
            self.Grid.transform.localPosition = Vector3(-150,0,0)
            self.icoTex.gameObject:SetActive(false)
        end
    end

    if #drop>isDrag then
        self.drag:SetActive(true)
    else 
        self.drag:SetActive(false)
    end

end

function page:onBtGet()
    self.delegate.selectItem_cur=self
    if self.delegate.data.event == "lvlup" then
        self.isExt = ((self.extra_status == 1 or self.extra_status == nil) and self.data.extra_drop and self.item_for_yueka)
        if self.status == 2 and self.isExt and Player.Card["yueka"] <= 0 then
            MessageMrg.show(TextMap.GetValue("Text_1_123"))
            return
        end
        if self.status == 1 or self.isExt then
            self.delegate.delegate:getMutliPackage(self, self.delegate.data.id, self.gid)
        end
    else
        if self.status == 1 then
        	if self.data.selectPackage ~= nil then
           		self:ShowCanChooseItemsPage()
           	else
           		self.delegate.delegate:getMutliPackage(self, self.delegate.data.id, self.gid)
           	end
        end
    end
end

function page:ShowCanChooseItemsPage()
	UIMrg:pushWindow("Prefabs/moduleFabs/activityModule/act_choose_reward", {data=self.data.selectPackage,delegate=self})
end

function page:SelectMeCb(ids)
	local gid = self.gid.."_"..ids
	self.delegate.delegate:getMutliPackage(self, self.delegate.data.id, gid)
end

function page:onClick(go, name)
    if name == "btGet" then
        if self.status ~= nil then
            self:onBtGet()
        end
    elseif name == "btn_left" then
        self.slider.value = 0
    elseif name == "btn_right" then
        self.slider.value = 1
    elseif name == "btRecharge" then
        self.delegate.delegate.canSelect=false
        DialogMrg.chognzhi()
    elseif name == "btn_ico" then
    	self:ReViewReward()
    end
end

function page:ReViewReward()
	local temp = {}
    temp.title = TextMap.GetValue("Text_1_23")
    temp.onOk = function()
        UIMrg:popWindow()
    end
    temp.type = "showInfo"
    temp.state =  true
    local drop =  self.data.selectPackage
    drop.number = nil
    temp.drop = drop
    temp.bt_name = TextMap.GetValue("Text_1_25")

    UIMrg:pushWindow("Prefabs/moduleFabs/chapterModule/chapterbox", temp)
end

function page:getCallBack()
    self:update()
end



return page