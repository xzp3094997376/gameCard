local item = {}

local isSelected = false

function item:selectActCallBack(index)
    if self.index == index then
        item:showSelect(true)
        self.delegate.currentSelect = self
        self.delegate.currentID = self.id
    else 
        item:showSelect(false)
    end
end

function item:update(data, index)
    self.index = index
    self.id = data.id
    self.delegate = data.delegate
    self.data=data

    --活动名
    self.act_name.text = data.title
    if self.act_name2~=nil then 
        self.act_name2.text = data.title
    end 

    if data.icon ~= nil and self.icon~=nil then
        self.icon.gameObject:SetActive(true)
        self.icon.Url = UrlManager.GetImagesPath("sl_activity/" .. data.icon .. ".png")
    end

    if data.is_selected then
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
    if self.delegate.rp[self.id] == true then
        self.redPoint:SetActive(true)
    else
        self.redPoint:SetActive(false)
    end
end

function item:callClick()
    self:onClick(nil, nil)
end

function item:OnDestroy()
    Events.RemoveListener('SelectActCallBack_grade')
    Events.RemoveListener('update_item_redPoint')
end

function item:onClick(go, btnName)
    self.delegate:showActivity(self, self.id, self.select)
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
    Events.AddListener("SelectActCallBack_grade", funcs.handler(self, item.selectActCallBack))
    Events.AddListener("update_item_redPoint", function ()
        item:showEffect()
    end)
end


return item