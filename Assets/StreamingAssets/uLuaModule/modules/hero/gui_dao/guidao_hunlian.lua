--
-- Created by IntelliJ IDEA.
-- User: xiyou
-- Date: 2015/3/21
-- Time: 20:59
-- To change this template use File | Settings | File Templates.
--
local m = {}
selectCharPieceList = nil

local isClick = false

function m:update(tp)
    if tp == "po" then
        self.curTab = 1
    elseif tp == "hui" then
        self.toggle_hui.value = true
        self.curTab = 2
    elseif tp == "fu" then
        self.toggle_fu.value = true
        self.curTab = 3
    elseif tp == "jie" then
        self.toggle_jie.value = true
        self.curTab = 4
    end
end

function m:OnDestroy()
    selectCharPieceList = nil
    Events.RemoveListener('updateCharPiece')
end

function m:onExit()
    isClick = false
    self.UI_gongnengkaifang:SetActive(false)
end

function m:onUpdate(list)
    local len = table.getn(list)
    if (len == 1) then
        self.pageview:DisableDrag(true)
        table.insert(list, list[1])
        table.insert(list, list[1])
        self.binding:Hide("btn_left")
        self.binding:Hide("btn_right")
    else
        self.pageview:DisableDrag(false)
        self.binding:Show("btn_left")
        self.binding:Show("btn_right")
    end
    if len == 2 then
        table.insert(list, list[1])
        table.insert(list, list[2])
    end
    self.gostList = list
    self.pageview:SetInit(0, table.getn(self.gostList))
    m:updateName(list[1])
    m:resetPiece()
end

function m:updateType(tp)
    local list = self.tables[tp]
    if list then
        m:onUpdate(list)
    end
end

function m:getPieceIds()
    local list = {}
    local i = 1
    table.foreach(selectCharPieceList, function(ll, v)
        if v ~= nil and v.char.count > 0 then
            for j = 1, v.count do
                list[i] = v.char.id
                i = i + 1
            end
        end
    end)
    return list
end

function m:getPos()
    local list = {}
    for i = 1, 5 do
        local ret = self["guidao_item" .. i]:CallTargetFunction("isEmpty")
        if not ret then list[i] = self["guidao_item" .. i] end
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
            local effect1 = ClientTool.load("Effect/Prefab/ui_guidao_flash", self.pageview.gameObject)
            effect1.transform.localPosition = Vector3(0, 12, 0)
            effect1:SetActive(false)
            self.binding:CallAfterTime(0.5, function()
                for i = 1, table.getn(effects) do
                    effects[i].transform.parent = self.pageview.transform
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
                local effect_reward = ClientTool.load("Prefabs/moduleFabs/guidao/gdreward", self.pageview.gameObject)
                effect_reward.transform.localPosition = Vector3(10, -117, 0)
                self.binding:CallAfterTime(1.2, function(...)
                    packTool:showMsg(result, self.node, 0)
                    isClick = false
                    GameObject.Destroy(effect_reward)
                    self.model:SetActive(false)
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
    local arg = m:getPieceIds()
    self.model:SetActive(true)
    Api:ghostCombineByChar(id .. "", arg, function(result)
        Tool.resetUnUseGhost()
        m:playAnimation(result)
    end, function(ret)
        self.model:SetActive(false)
        isClick = false
        return false
    end)
end

function m:resetPiece()
    local star = self.star or 3
    for i = 1, 5 do
        self["guidao_item" .. i]:CallTargetFunction("reset", star, self)
    end
    selectCharPieceList = {}
end

function m:getTeam()
    local teams = Player.Team[0].chars
    local list = {}
    for i = 0, 5 do
        local id = teams[i]
        if teams.Count > i and id ~= nil and id ~= 0 and id ~= "0" then
            list[id .. ""] = true
        end
    end
    return list
end

--一键增加
function m:onOneKey()
    local pieces = Tool.getAllCharPiece() or {}
    local ids = {}
    local index = 1
    local star = self.star or 3
    local has_list = {} --碎片列表
    local charPiece = {} --已上阵角色
    local team = m:getTeam()
    table.foreach(pieces, function(i, piece)
        if index <= 5 then
            piece:updateInfo()
            if piece.count > 0 then
                if piece.star == star then
                    if m:filter(piece) then
                        local id = piece.id .. ""
                        if team[id .. ""] or id == "3" or id == "5" or id == "15" or id == "19" or id == "21" or id == "24" then
                            table.insert(charPiece, piece)
                        else
                            table.insert(has_list, piece)
                        end
                    end
                end
            end
        end
    end)
    selectCharPieceList = {}

    table.sort(has_list, function(a, b)
        return a.count < b.count
    end)
    table.foreachi(has_list, function(i, piece)
        for j = 1, piece.count do
            if index <= 5 then
                ids[index] = piece
                index = index + 1
            end
        end
    end)

    --    if index <= 5 then
    --        table.sort(charPiece, function(a, b)
    --            return a.count < b.count
    --        end)
    --        table.foreachi(charPiece, function(i, piece)
    --            for j = 1, piece.count do
    --                if index <= 5 then
    --                    ids[index] = piece
    --                    index = index + 1
    --                end
    --            end
    --        end)
    --    end

    for i = 1, #ids do
        local char = ids[i]
        if selectCharPieceList[char.id] == nil then
            selectCharPieceList[char.id] = { count = 1, char = char }
        else
            selectCharPieceList[char.id].char = char
            selectCharPieceList[char.id].count = selectCharPieceList[char.id].count + 1
        end
    end
    if #charPiece == 0 and #ids == 0 then
        DialogMrg.ShowDialog(TextMap.GetValue("Text8"), function()
            uSuperLink.openModule(8)
        end)
        return
    end
    m:updateCharPiece()
end

function m:onClick(go, name)
    if name == "btn_podao" then
        m:updateType(1)
    elseif name == "btn_huidao" then
        m:updateType(2)
    elseif name == "btn_jiedao" then
        m:updateType(4)
    elseif name == "btn_fudao" then
        m:updateType(3)
    elseif name == "btn_left" then
        self.pageview:move(1)
    elseif name == "btn_right" then
        self.pageview:move(0)
    elseif name == "btnOneKey" then
        m:onOneKey()
    elseif name == "btn_help" then
        UIMrg:pushWindow("Prefabs/moduleFabs/qiancengta/qiancengta_rule", { 7 })
    elseif name == "btn_hunlian" then

        m:onHunLian()
    end
end

function m:updateCharPiece()
    local star = self.star or 3
    local i = 1
    local list = {}
    table.foreach(selectCharPieceList, function(ll, v)
        if v ~= nil and v.char.count > 0 then
            for j = 1, v.count do
                list[i] = v.char
                i = i + 1
            end
        end
    end)
    for i = 1, 5 do
        local v = list[i]
        if v then
            self["guidao_item" .. i]:CallUpdateWithArgs(v)
        else
            self["guidao_item" .. i]:CallTargetFunction("reset", star, self)
        end
    end
end

--过滤
function m:filter(piece)
    local kind = piece.Table.kind
    if kind ~= 0 and kind ~= "" and kind ~= nil then
        return false
    end
    return true
end

function m:updateName(ghost)
    self.txt_name.text = ghost.name
    self.star = ghost.star
    self.ghost = ghost
end

function m:Start()
    LuaMain:ShowTopMenu()
    self.model:SetActive(false)
    self.bg.Url = UrlManager.GetImagesPath("guidao/guidao_bg.png")
    Events.AddListener("updateCharPiece", funcs.handler(self, m.updateCharPiece))
    selectCharPieceList = {}


    local that = self
    self.pageview:SetCallBack(function(bind, page, init)
        if that.gostList == nil then return end
        local _char = that.gostList[page]
        if bind and _char then
            if not init then
                local curPage = that.pageview:getCurPage()
                local char = that.gostList[curPage]
                --                that:onUpdate(true)
                bind:CallUpdate(_char)
                m:updateName(char)
                m:resetPiece()
                self.pageview:getCurPageObject():CallTargetFunctionWithLuaTable("onUpdate", char)
            else
                bind:CallUpdate(_char)
                --                m:updateName(_char)
            end
        end
    end)

    self.tables = {}
    self.curTab = 1
    self.binding:CallManyFrame(function()
        local po = {}
        local hui = {}
        local fu = {}
        local jie = {}
        TableReader:ForEachLuaTable("ghost", function(index, it)
            local kind = it.kind
            local item = Ghost:new(it.id)
            if kind == "po" then
                table.insert(po, item)
            elseif kind == "hui" then
                table.insert(hui, item)
            elseif kind == "fu" then
                table.insert(fu, item)
            elseif kind == "jie" then
                table.insert(jie, item)
            end
            return false
        end)
        table.sort(po, function(a, b) return a.star < b.star end)
        table.sort(hui, function(a, b) return a.star < b.star end)
        table.sort(fu, function(a, b) return a.star < b.star end)
        table.sort(jie, function(a, b) return a.star < b.star end)
        self.tables = { po, hui, fu, jie }
        m:updateType(self.curTab)
    end, 2)
end

return m

