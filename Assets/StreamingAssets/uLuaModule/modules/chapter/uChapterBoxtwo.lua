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
    self.ZJType = data.ZJType
    self.ZJid = data.ZJid
    self.go = data._go
    self.delegate = data.delegate
    self.state = data.state
    self._callBack = data.BtnSprite
    self.callFun = data.callFun
    if self.state == 0  then
        self.btn_queren.isEnabled = false
        self.btntxt_nor.text = TextMap.GetValue("Text_1_201")
    elseif self.state == 2 then
        self.btn_queren.isEnabled = false
        self.btntxt_nor.text = TextMap.GetValue("Text_1_138")
    elseif  self.state == 1 then
        self.btn_queren.isEnabled = true
        self.btntxt_nor.text = TextMap.GetValue("Text_1_22")
    end


    local itemCount = table.getn(data.obj)
    self.dropTypeList = {}
    for i = 1, itemCount  do
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
end

function boxGet:onClick(go, name)
    if name == "closeBtn" then
        UIMrg:popWindow()
    elseif name == "btn_queren" then
        if Tool:judgeBagCount(self.dropTypeList) == false then return end
        Api:getChapterBox(self.ZJType, self.ZJid, function(result)
                self.btn_queren.isEnabled = false
                self.btntxt_nor.text = TextMap.GetValue("Text_1_138")
                --MessageMrg.show("领取成功")
                packTool:showMsg(result, nil,2)
                UIMrg:popWindow()
                self.delegate:setData()
                Events.Brocast("CheckChuanguanPoint")
                --self.binding:CallAfterTime(4, function()
                --    UIMrg:popWindow()
                --end)
            end, function()
                MessageMrg.show(TextMap.GetValue("Text_1_202"))
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