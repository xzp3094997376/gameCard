-- 公会领奖面板
local m = {}

--初始化
function m:create(binding)
    self.binding = binding
    return self
end

function m:update(data)
    self.lbTitle.text = data.title
    self.lv = data.lv
    --self._index = data.index
    self._callBack = data.BtnSprite
    self.callFun = data.callFun
    self.go = data._go
    -- local itemCount = table.getn(data.obj)
    -- for i = 1, itemCount do
    local itemCount = 0
    local start_i = 0
    if data.obj.Count ~= nil then
        itemCount = data.obj.Count
    elseif #data.obj ~= nil then
        itemCount =  #data.obj + 1
        start_i = 1
    end
    
    for i = start_i, itemCount - 1 do
        local _type = data.obj[i]["type"]
        local vo = {}
        vo.type = _type
        local char = {}
        char = RewardMrg.getDropItem({type=_type, arg2=data.obj[i]["arg2"], arg=data.obj[i]["arg"]})
        vo.data = char
        local infobinding = ClientTool.loadAndGetLuaBinding("Prefabs/moduleFabs/leagueModule/league_acceptRewardBoxItem", self.grid.gameObject)
        infobinding:CallUpdate(vo)
        infobinding = nil
        char = nil
    end
    self.grid.repositionNow = true
    --0 还不能领奖 1可以领奖而未领  2 完成领奖
    print("lzh ---------------------------")
    print(data.state)
    if data.state == 1 then
        self.btn_queren.isEnabled = true
    elseif data.state == 2 then
        self.btn_queren.isEnabled = false
        -- if GuideConfig:isPlaying() then
        --     GuideManager.getInstance():End()
        --     GuideConfig:hideTalk()
        --     GuideConfig:next()
        --     UIMrg:popWindow()
        -- end
    else
        self.btn_queren.isEnabled = false
    end
end

function m:onClick(go, name)
    if name == "closeBtn" then
        UIMrg:popWindow()
    elseif name == "btn_queren" then
        Api:sacrificeReward(self.lv, function(result)
            --self._callBack:SetActive(false)
            packTool:showMsg(result, self.go, 0)
            UIMrg:popWindow()
            self.callFun()
            MessageMrg.show(TextMap.GetValue("Text1168"))
        end, function()
            self.btn_queren.isEnabled = true
        end)
    end
end

--------------------------------------------------------------------------------
function m:typeId(_type)
    local typeAll = { "equip", "equipPiece", "item", "char", "charPiece", "reel", "reelPiece" }
    for i, j in pairs(typeAll) do
        if _type == j then
            return true
        end
    end
    return false
end

return m