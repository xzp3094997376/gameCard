local item = {}

local isSelected = false

function item:SelectActCallBack(index) --如果本个被选中
if self.index == index then
    item:showSelect(true)
    self.delegate.currentSelect = self
    self.delegate.currentID = self.id
end
end

function item:isShowRead()
    self.redPoint:SetActive(true)
end

function item:update(data, index)

    if data.icon ~= nil then
        self.bg.Url = UrlManager.GetImagesPath("tasksImage/" .. data.icon .. ".png")
    end
    self.index = index
    --   print("index"..index)
    self.id = data.id --类型
    --self._progress = data.progress
    --  print("data.id "..data.id)
    --  print(data.is_selected)
    if data.is_selected then
        self.dikuang:SetActive(true)
    else
        self.dikuang:SetActive(false)
    end
    self.redPoint:SetActive(false)

    --判断此类型的任务是否解锁
    if data.isLock then
        self.isLock:SetActive(true)
        self.content:SetActive(false)
        self.lockLevel.gameObject:SetActive(true)
        self.lockLevel.text = TextMap.GetValue("Text371") .. data.lockLevel
        self.lock = true
    else
        self.isLock:SetActive(false)
        self.content:SetActive(true)
        self.lockLevel.gameObject:SetActive(false)
        BlackGo.setBlack(1, self.bg.transform)

        self.progressTXT.text = TextMap.GetValue("Text373") .. data.progress .. "/" .. data.total .. "[-]"
        self.total = data.total
        self.name.text = TextMap.GetValue("Text374") .. data.recomTxt .. "[-]"
        -- print("data.hasFinish"..tostring(data.hasFinish))
        if data.hasFinish then
            self.isfinish:SetActive(true)
        else
            self.isfinish:SetActive(false)
        end

        self.delegate = data.delegate
        if data.statue >= 1 then
            --   if self.effect == nil then self:createEffect(self.bg.gameObject) end
            --     self.effect:SetActive(true)
            print("data show red")
            self.redPoint:SetActive(true)
        else
            --   if self.effect ~= nil then self.effect:SetActive(false) end
            self.redPoint:SetActive(false)
        end
        self.lock = false
    end
end

function item:statueNum(num)
    print("item num " .. num)
    if num >= 1 then
        self.redPoint:SetActive(true)
    else
        self.redPoint:SetActive(false)
    end

    self._progress = self._progress + 1
    if self._progress >= self.total then
        self._progress = self.total
    end
    self.progressTXT.text = TextMap.GetValue("Text375") .. self._progress .. "/" .. self.total .. "[-]"
end

function item:refreshState(redPointNum, _pro, hasFinish) --未领取的进度和全部完成的进度
if redPointNum >= 1 then
    self.redPoint:SetActive(true)
else
    self.redPoint:SetActive(false)
end
if hasFinish == true then
    self.isfinish:SetActive(true)
else
    self.isfinish:SetActive(false)
end
if tonumber(_pro) >= tonumber(self.total) then
    _pro = self.total
end
self.progressTXT.text = TextMap.GetValue("Text375") .. _pro .. "/" .. self.total .. "[-]"
end


function item:callClick()
    self:onClick(nil, nil)
end

function item:onClick(go, btnName)
    if self.lock ~= true then
        --  print("self.id "..self.id)
        self.delegate:showActivity(self, self.id, self.dikuang)
    end
end

function item:showSelect(isSelected)
    if isSelected then
        self.dikuang:SetActive(true)
    else
        self.dikuang:SetActive(false)
    end
end



function item:OnDestroy()
    Events.RemoveListener('SelectActCallBack')
end

function item:Start(...)
    Events.AddListener("SelectActCallBack", funcs.handler(self, item.SelectActCallBack))
end


return item