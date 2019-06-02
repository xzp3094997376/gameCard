local item = {}

local isSelected = false

function item:SelectActCallBack(index)
    if self.index == index and self.delegate.canSelect==true then
        item:showSelect(true)
        self.delegate.currentSelect = self
        self.delegate.currentID = self.id
    end
end

function item:update(data, index)
    self.index = index
    self.id = data.id
    self.data=data
    self.delegate = data.delegate

    --活动名
    self.act_name.text = data.title
    if self.act_name2~=nil then 
        self.act_name2.text = data.title
    end 

    if data.icon ~= nil and self.icon~=nil then
        self.icon.gameObject:SetActive(true)
        self.icon.Url = UrlManager.GetImagesPath("sl_activity/" .. data.icon .. ".png")
    end

    if self.data.is_selected then
        self.select:SetActive(true)
    else
        self.select:SetActive(false)
    end
    if self.new ~=nil then 
        if data.is_new == 1 then
            self.new.gameObject:SetActive(true)
        else
            self.new.gameObject:SetActive(false)
        end
    end 

    self:showEffect()
end

function item:showEffect()
    if self.redPoint~=nil then 
        if self.delegate.rp[self.id] == true then
            self.redPoint:SetActive(true)
        else
            self.redPoint:SetActive(false)
        end
    end
end

function item:callClick()
    self:onClick(nil, nil)
end

function item:OnDestroy()
    Events.RemoveListener('SelectActCallBack')
end

function item:onClick(go, btnName)

    -- if btnName == "actItem" then
    self.delegate:showActivity(self, self.id, self.select)
    return


    -- Api:getActivity(self.id, function(result)
    --     local info = result.info
    --     self.delegate:showInfo(result.info)
    -- end, function(...)
    --     return false
    -- end)
    -- end
end

function item:showSelect(isSelected)
    if isSelected then
        self.select:SetActive(true)
    else
        self.select:SetActive(false)
    end
end

function item:hideEffect()
    -- if self.effect ~= nil then self.effect:SetActive(false) end
    self.redPoint:SetActive(false)
end

function item:createEffect(root)
    self.effect = ClientTool.load("Effect/Prefab/huodong_redpoint", root)
    self.effect.gameObject.transform.localPosition = Vector3(-4, 5, 0)
    self.effect.gameObject.transform.localScale = Vector3(1, 1, 1)
end

function item:Start(...)
    -- self.act_name.bitmapFont = actFont
    Events.AddListener("SelectActCallBack", funcs.handler(self, item.SelectActCallBack))
    --self.new.Url = UrlManager.GetImagesPath("activity/act_new.png")
end


return item