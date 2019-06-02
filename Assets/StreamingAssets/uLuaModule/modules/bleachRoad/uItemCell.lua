local giftList = {}

function giftList:update(data, index, delegate)
    local tasks = Player.Tasks
    self._task = nil
    self.delegate = delegate
    local list
    self.btBuy.isEnabled = false
    if tasks[data.id] ~= nil then
        self._task = tasks[data.id]
        self._taskID = data.id
        self._state = self._task["state"]
        self.Label.text = string.gsub(TextMap.GetValue("Text482"),"{0}",data.complete.level.times)
        --0 开启了任务 1未完成  2 完成了未领取 3 已完成并领取
        if self._state == 2 then
            self.btBuy.isEnabled = true
            self.Label.text = TextMap.GetValue("Text483")
        end
        if self._state == 3 then
            self.btBuy.isEnabled = false
            self.Label.text = TextMap.GetValue("Text397")
        end
        list = giftList:getDrop(data.drop)
    else
        self.btBuy.isEnabled = false
        self.Label.text = TextMap.GetValue("Text397")
    end
    self.btnLeft.gameObject:SetActive(false)
    self.btnRight.gameObject:SetActive(false)
    self.vipLevel.text = data.complete.level.times
    self.simpleImage.Url = UrlManager.GetImagesPath("shopImage/" .. data.icon .. ".png")
    if list ~= nil then
        ClientTool.UpdateGrid("Prefabs/moduleFabs/bleachRoad/road_itemCell", self.myGrid, list)
    end
end

function giftList:isUsedType(_type)
    local typeAll = { "equip", "equipPiece", "item", "char", "charPiece", "reel", "reelPiece", "money", "gold", "bp", "soul", "popularity", "credit", "honor", "donate", "exp", "hunyu", "ghost", "ghostPiece" }
    for i, j in pairs(typeAll) do
        if _type == j then
            return true
        end
    end
    return false
end

function giftList:getDrop(info)
    local _list = {}
    local count = info.Count - 1
    for i = 0, count do
        local v = info[i]
        if giftList:isUsedType(v.type) then
            local m = {}
            m.type = v.type
            local char = RewardMrg.getDropItem(v)
            m.data = char
            char = nil
            table.insert(_list, m)
            m = nil
        end
    end
    drop = nil
    info = nil
    return _list
end


function giftList:onLeft(...)
    --self.scrollView:move(0)
end

function giftList:onRight(...)
    --self.scrollView:move(1)
end

function giftList:onClick(go, name)

    if name == "btnLeft" then
        self:onLeft()
    elseif name == "btnRight" then
        self:onRight()
    elseif name == "btBuy" then
        self.btBuy.isEnabled = false
        Api:submitTask(self._taskID,
            function(result)
                MusicManager.playByID(30)
                self.delegate:showMsg(result)
                -- packTool:showMsg(result, self.go, 0)
                self.btBuy.isEnabled = false
                self.Label.text = TextMap.GetValue("Text397")
            end, function()
                self.btBuy.isEnabled = true
            end)
    end
end

function giftList:create()
    return self
end

function giftList:onGetGift(result)
end


return giftList