local page = {}
local link_id = 0

function page:create()
    return self
end

function page:update(data, index)
    self.isExt = false
    if data~=nil then 
        self.data = data
        self.delegate = data.delegate
        self._index = index
    end 
    local drop = self.data.drop
    local package = self.data.package
    self.gid = package.id
    self.status = self.delegate.data.status[self.gid]
    if self.status == 1 then
        self.delegate:countMutliPoint(true)
    end

    self.Title.text = package.name
    --extra_info = {total= , complete = }
    if package.extra_info~=nil and package.extra_info.link_id ~=nil then 
        self.link_id = package.extra_info.link_id
    else 
        self.link_id=0
    end
    if package.extra_info~=nil then 
        local count = package.extra_info.complete
        if count > package.extra_info.total then count = package.extra_info.total end
        self.txt_progress.text = TextMap.GetValue("Text396") .. count .. "[-]/" .. package.extra_info.total
    end
    --self.binding:Hide('txt_login_cost')
    self.btn_name.text = TextMap.GetValue("Text376")
    self.btGet.isEnabled = true

    --0:未完成 1:可领取 2:已领取
    self.finish:SetActive(false)
    self.btGet.gameObject:SetActive(true)
    if self.status ~= nil then
        if self.status == 2 then
            table.foreach(drop, function(i, v)
                v.has = true
            end)
        end

        if self.status == 0 then
            self.btn_name.text = TextMap.GetValue("Text350")
            self.btGet.isEnabled = true
        elseif self.status == 1 then
            self.btn_name.text = TextMap.GetValue("Text376")
            self.btGet.isEnabled = true
        elseif self.status == 2 then
            self.btGet.gameObject:SetActive(false)
            self.finish:SetActive(true)
        end
    else
        self.btGet.isEnabled = false
        self.btn_name.text = TextMap.GetValue("Text_1_22")
    end
    -- 可选择物品逻辑
    if self.data.event_type == "challengeWinReward" then
    	if self.data.selectPackage ~= nil and self.data.selectName ~= nil and self.data.selectIcon ~= nil then
            self.icoTex.gameObject:SetActive(true)
    		local bg_icon = "itemImage/" .. self.data.selectIcon .. ".png"
        	self.icoTex.Url = UrlManager.GetImagesPath(bg_icon)  
        	self.Grid.transform.localPosition = Vector3(-35,0,0)
        else
            self.Grid.transform.localPosition = Vector3(-150,0,0)
        	self.icoTex.gameObject:SetActive(false)
        	print("set false");
    	end
    else
        self.Grid.transform.localPosition = Vector3(-150,0,0)
        self.icoTex.gameObject:SetActive(false)
    	--self.RandomItem:SetActive(false)
    end
    -- 可选择物品逻辑
    self.drag:SetActive(true)
    self.Grid:refresh("Prefabs/moduleFabs/activityModule/itemActivity", drop,self.delegate)
    if #drop>3 then
        self.drag:SetActive(true)
    else 
        self.drag:SetActive(false)
    end
end

function page:onBtGet()
    if self.status == 1 then
		--领取
        self.delegate.selectItem_cur=self
		if self.data.selectPackage ~= nil then
        	self:ShowCanChooseItemsPage()
        else
        	self.delegate.delegate:getMutliPackage(self, self.delegate.data.id, self.gid)
        end
    elseif self.status == 0 then
        UIMrg:pop()
        local obj = Tool.readSuperLinkById( self.link_id)
        uSuperLink.openModule(self.link_id)
    end
end

function page:SelectMeCb(ids)
    print(self.gid)
	local gid = self.gid.."_"..ids
	print("........gid.........."..gid)
	self.delegate.delegate:getMutliPackage(self, self.delegate.data.id, gid)
end

function page:ShowCanChooseItemsPage()
	UIMrg:pushWindow("Prefabs/moduleFabs/activityModule/act_choose_reward", {data=self.data.selectPackage,delegate=self})
end

function page:fillCheckIn()
    Api:fillCheckIn(self.delegate.data.id, self._index + 1, function(result)
        packTool:showMsg(result, nil, 1)
        page:getCallBack()
    end)
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
    temp.tip = TextMap.GetValue("Text_1_24")
    temp.type = "showInfo"
    temp.state =  true
    local drop =  self.data.selectPackage
    drop.number = nil
    temp.drop = drop
    temp.bt_name = TextMap.GetValue("Text_1_25")

    UIMrg:pushWindow("Prefabs/moduleFabs/chapterModule/chapterbox", temp)
end
function page:getCallBack()
    self.delegate:countMutliPoint(false)
    if self.delegate.mutliPoint < 1 then
        self.delegate.delegate:hideEffect()
    end
    self.delegate:getCallBack()
end

function page:onPress(go,name,bPress)
	
	if (self.delegate == nil or self.delegate.getScrollView == nil) then
		return
	end
  local sv = self.delegate:getScrollView()
	if sv ~= nil then
		sv:Press(bPress);
	end
end

function page:OnDrag(go,name,detal)
	
	if (self.delegate == nil or self.delegate.getScrollView == nil) then
		return
	end
	local sv = self.delegate:getScrollView()		
	if sv ~= nil then
		sv:Drag();
	end
end

function page:getScrollView()
    return self.delegate:getScrollView()
end

return page