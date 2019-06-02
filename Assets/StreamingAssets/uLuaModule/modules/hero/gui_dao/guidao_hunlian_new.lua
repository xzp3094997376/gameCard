

local m = {}
selectCharPieceList = nil

local isClick = false

function m:update(delegate, ghost)
    self.delegate = delegate
    m:onUpdate(ghost)
end

function m:OnDestroy()
    selectCharPieceList = nil
end

function m:onExit()
    isClick = false
    self.UI_gongnengkaifang:SetActive(false)
end

function m:onUpdate(ghost)
    m:updateGhost(ghost)
    m:resetPiece()
end


function m:getPos()
    local list = {}
    for i = 1, 3 do
        list[i] = self["guidao_item" .. i]
    end
    return list
end

function m:playAnimation(result)
    MusicManager.playByID(45)
    local effects = {}
    local pos_arr = m:getPos()
    local index = 1
    local charNum = 0
    table.foreach(pos_arr, function(k, v)
        if pos_arr[k] then --表示该位置有物体，实例化一个特效
        local effect = ClientTool.load("Effect/Prefab/ui_guidao_fly", v.gameObject)
        effects[index] = effect
        index = index + 1
        charNum = charNum + 1
        effect.transform.localPosition = Vector3(0, 0, 0)
        end
    end)
    if charNum ~= 0 then
        self.binding:CallAfterTime(0.2, function(...)
            local effect1 = ClientTool.load("Effect/Prefab/ui_guidao_flash", self.ghost_item.gameObject)
            effect1.transform.localPosition = Vector3(0, 12, 0)
            effect1:SetActive(false)
            self.binding:CallAfterTime(0.5, function()
                for i = 1, table.getn(effects) do
                    effects[i].transform.parent = self.ghost_item.transform
                    self.binding:MoveToPos(effects[i], 0.3, Vector3(0, 0, 0), function(...)
                        GameObject.Destroy(effects[i])
                    end)
                end
            end)
            self.binding:CallAfterTime(0.5, function()
                effect1:SetActive(true)
                m:resetPiece()
            end)

            self.binding:CallAfterTime(2, function()
                GameObject.Destroy(effect1)
                local effect_reward = ClientTool.load("Prefabs/moduleFabs/guidao/gdreward", self.ghost_item.gameObject)
                effect_reward.transform.localPosition = Vector3(10, -117, 0)
                self.binding:CallAfterTime(1.2, function(...)
                    packTool:showMsg(result, self.node, 0)
                    isClick = false
                    GameObject.Destroy(effect_reward)
                    self.delegate.ghostList = nil
                    self.delegate:onUpdate(self.ghost)
                end)
            end)
        end)
    end
end

--魂炼
function m:onHunLian()
    if self.ghost == nil then return end
    if isClick == true then
        return
    end
    isClick = true
    local id = self.ghost.id
    Api:ghostCombineByPiece(tonumber(id), function(result)
        Tool.resetUnUseGhost()
        m:playAnimation(result)
    end, function(ret)
        isClick = false
        return false
    end)
end

function m:resetPiece()
    local list = self._costList
    for i = 1, 3 do
        list[i]:updateInfo()
        self["guidao_item" .. i]:CallUpdate(list[i])
    end
end


function m:onClick(go, name)
    if name == "btn_hunlian" then
        m:onHunLian()
    end
end


function m:updateGhost(ghost)
    self.txt_name.text = Tool.getNameColor(ghost.star) .. ghost.name .. "[-]"
    self.star = ghost.star
    self.ghost = ghost
    self.ghost_item:CallUpdate(ghost)
    local row = TableReader:TableRowByID("ghostPiece", ghost.id)
    local consume = row.consume
    self._costList = RewardMrg.getConsumeTable(consume)
    local ret = true
    for i = 1, #self._costList do
        local it = self._costList[i]
        it._rwCount = it.rwCount
        if it.count < it.rwCount then
            ret = false
        end
    end
    m:resetPiece()
    if ret and self.eff_btn == nil then
        self.eff_btn = Tool.LoadButtonEffect(self.btn_hunlian.gameObject)
    end
    Tool.SetActive(self.eff_btn, ret)
end

function m:Start()
    self.bg.Url = UrlManager.GetImagesPath("guidao/guidao_bg.png")
end

return m

