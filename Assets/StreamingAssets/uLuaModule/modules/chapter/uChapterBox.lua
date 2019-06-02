local boxGet = {}
function boxGet:typeId(_type)
    local typeAll = { "equip", "equipPiece", "item", "char", "charPiece", "reel", "reelPiece" }
    for i, j in pairs(typeAll) do
        if _type == j then
            return true
        end
    end
    return false
end

function boxGet:update(data)
    if data.tip~=nil then 
        self.lbTitle.text=data.tip
    end 
    if data.type == "showInfo" then
        local title = self.gameObject.transform:Find("Sprite/Label")
        title = title:GetComponent(UILabel)
        title.text = data.title or ""
        self.onOk = data.onOk
        if data.state == 1 then
            self.btn_queren.isEnabled = true
            self.btntxt_nor.text = TextMap.GetValue("Text_1_22")
        elseif data.state == 2 then
            self.btn_queren.isEnabled = false
            self.btntxt_nor.text = TextMap.GetValue("Text_1_138")
        else
            self.btn_queren.isEnabled = false
            self.btntxt_nor.text = TextMap.GetValue("Text_1_201")
        end 
        ClientTool.UpdateGrid("Prefabs/moduleFabs/activityModule/itemActivity", self.grid, data.drop)
        self.btn_queren.isEnabled = data.state == 1
        return
    end
    self._index = data.index
    self.delegate = data.delegate
    self.currentChapterType = data.currentChapterType
    self._callBack = data.BtnSprite
    self.callFun = data.callFun
    self.go = data._go
    self.dropTypeList = {}
    local itemCount = table.getn(data.obj)
    for i = 1, itemCount do
        local _type = data.obj[i]["type"]
        local vo = {}
        vo.type = _type
        table.insert(self.dropTypeList, _type)
        local char = {}
        char = RewardMrg.getDropItem({type= _type,arg=data.obj[i]["arg2"],arg=data.obj[i]["arg"]})
        vo.data = char
        local infobinding = ClientTool.loadAndGetLuaBinding("Prefabs/moduleFabs/chapterModule/chapterboxItem", self.grid.gameObject)
        infobinding:CallUpdate(vo)
        infobinding = nil
        char = nil
    end
    self.grid.repositionNow = true
    if data.type == "showReward" or data.type == "showInfo" then 
        self.onOk = data.onOk
        if data.state == 1 then
            self.btn_queren.isEnabled = true
            self.btntxt_nor.text = TextMap.GetValue("Text_1_22")
        elseif data.state == 2 then
            self.btn_queren.isEnabled = false
            self.btntxt_nor.text = TextMap.GetValue("Text_1_138")
        else
            self.btn_queren.isEnabled = false
            self.btntxt_nor.text = TextMap.GetValue("Text_1_201")
        end 
    else 
        if data.state == 2 then
            self.btn_queren.isEnabled = true
            self.btntxt_nor.text = TextMap.GetValue("Text_1_22")
        elseif data.state == 3 then
            self.btn_queren.isEnabled = false
            self.btntxt_nor.text = TextMap.GetValue("Text_1_138")
        else
            self.btn_queren.isEnabled = false
            self.btntxt_nor.text = TextMap.GetValue("Text_1_201")
            if GuideConfig:isPlaying() then
                GuideManager.getInstance():End()
                GuideConfig:hideTalk()
                GuideConfig:next()
                UIMrg:popWindow()
            end
        end 
    end
end

function boxGet:onClick(go, name)
    if name == "closeBtn" then
        UIMrg:popWindow()
    elseif name == "btn_queren" then
        if Tool:judgeBagCount(self.dropTypeList) == false then return end
        if self.onOk then
            self.onOk()
            return
        end
        Api:submitTask(self._index,
            function(result)
                self.btn_queren.isEnabled = false
                self.btntxt_nor.text = TextMap.GetValue("Text_1_138")
                self.delegate:showOrHideBtn()
                self.delegate.delegate:checkRedPoint()
                packTool:showMsg(result, nil,2)
                UIMrg:popWindow()
                Events.Brocast("CheckChuanguanPoint")
            end, function()
                self.btn_queren.isEnabled = true
            end)
    end
end

--初始化
function boxGet:create(binding)
    self.binding = binding
    return self
end

return boxGet