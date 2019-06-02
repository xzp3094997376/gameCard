local m = {}
local isClick = false
function m:update(lua)
    self.effect:SetActive(false)
    isClick = false
    self.data = lua.data
    self.star = self.data.star
    self.delegate = lua.delegate
	
    if self._effects then
        table.foreach(self._effects, function(i, v)
            GameObject.Destroy(v)
        end)
    end

    m:resetPiece()
    m:onUpdate()
    self.Btn_ShenBinFrom.gameObject:SetActive(false)
    m:judgeShenBinSkill()
	--m:updateLeft(lua.data)
end

function m:judgeShenBinSkill()

    local godSkillMenu = Tool:getGodSkillListInfo()
    self.Btn_ShenBinFrom.gameObject:SetActive(false)

    for i = 1, #godSkillMenu do
        local item = godSkillMenu[i]
        if item ~= nil and item.name == self.data.name then
            self.Btn_ShenBinFrom.gameObject:SetActive(true)
            break
        end
    end
end

function m:onUpdate()
    local des  = {fu = TextMap.GetValue("Text_1_891"), hui = TextMap.GetValue("Text_1_892"), jie = TextMap.GetValue("Text_1_893"), po = TextMap.GetValue("Text_1_894")}
    local des2 = {fu = TextMap.GetValue("Text_1_895"), hui = TextMap.GetValue("Text_1_896"), jie = TextMap.GetValue("Text_1_897"), po = TextMap.GetValue("Text_1_898")}
    Tool.resetUnUseGhost()
    -- self.txt_power.text = "进阶等级：" .. self.data.power
    self.left_equip.Url = self.data:getHead()
    self.right_equip.Url = self.data:getHead()
    self.txt_lname.text = self.data:getItemColorName(self.data.star , self.data.name .. " [00ff00]+ " ..self.data.power.."[-]") -- 装备名称 
    --self.Label_gongji.text =  des[self.data.kind] .. "："
    --self.Label_fafang.text = des2[self.data.kind] .. "："
    
    if self.data:isMaxPower() == true then  --最大精炼等级
        Tool.SetActive(self.txt_top, true)
        Tool.SetActive(self.slider, false)
        self.btn_jinjie.isEnabled = false
        self.Sprite_gongji:SetActive(false)
        self.Sprite_fafang:SetActive(false)
         
        self.txt_rname.text = self.data:getItemColorName(self.data.star , self.data.name .. " [00ff00]+ " ..self.data.power.."[-]") -- 装备名称 
        local rownow1 = TableReader:TableRowByUniqueKey("ghostPowerUp", self.data.id, self.data.power)
        --self.next_Label_gongji.text = ""
        --self.next_Label_fafang.text = ""
        self.txt_gongji.text = string.gsub("[ffff96]" .. rownow1.magic[0]._magic_effect.format .. "[-]", "{0}", "[ffffff]" .. rownow1.magic[0].magic_arg1 / rownow1.magic[0]._magic_effect.denominator)--rownow1.magic[0].magic_arg1
        self.txt_fafang.text = string.gsub("[ffff96]" .. rownow1.magic[1]._magic_effect.format .. "[-]", "{0}", "[ffffff]" .. rownow1.magic[1].magic_arg1 / rownow1.magic[1]._magic_effect.denominator)--rownow1.magic[1].magic_arg1 
        self.next_txt_gongji.text = TextMap.GetValue("Text_1_899")
        self.next_txt_fafang.text = TextMap.GetValue("Text_1_899")
        self.Sprite_gongji:SetActive(false)
        self.Sprite_fafang:SetActive(false)
        --self.selectPiece:SetActive(false)
        --self.btnOneKey.isEnabled = false
        return
    end
    Tool.SetActive(self.txt_top, false)
    Tool.SetActive(self.slider, true)
    -------------------------------------- 进阶材料------------------------------------------------------------------------
    local row = TableReader:TableRowByUniqueKey("ghostPowerUp", self.data.id, self.data.power + 1) 
    if row == nil then return end

    if self.data.power > 0 then
        local rownow = TableReader:TableRowByUniqueKey("ghostPowerUp", self.data.id, self.data.power)
        self.txt_lname.text = self.data:getItemColorName(self.data.star , self.data.name .. " [00ff00]+ " ..self.data.power.."[-]")--self.data.suitName  -- 装备名称
		--self.Label_gongji.text = rownow.magic[0]._magic_effec.cnName
		--self.Label_fafang.text = rownow.magic[1]._magic_effec.cnName
		self.txt_gongji.text = string.gsub("[ffff96]" .. rownow.magic[0]._magic_effect.format .. "[-]", "{0}", "[ffffff]" .. rownow.magic[0].magic_arg1 / rownow.magic[0]._magic_effect.denominator)
        self.txt_fafang.text = string.gsub("[ffff96]" .. rownow.magic[1]._magic_effect.format .. "[-]", "{0}", "[ffffff]" .. rownow.magic[1].magic_arg1 / rownow.magic[1]._magic_effect.denominator)--.. "%"
        self.grow_txt_gongji.text = row.magic[0].magic_arg1 - rownow.magic[0].magic_arg1
        self.grow_txt_fafang.text = ((row.magic[1].magic_arg1 - rownow.magic[1].magic_arg1) / rownow.magic[1]._magic_effect.denominator)--.."%"
        self.attrone = "[ffff96]".. des[self.data.kind] .."[-]" .. " +" .. row.magic[0].magic_arg1 - rownow.magic[0].magic_arg1
        self.attrtwo = "[ffff96]".. des2[self.data.kind] .."[-]" .. " +" .. ((row.magic[1].magic_arg1 - rownow.magic[1].magic_arg1) / rownow.magic[1]._magic_effect.denominator)--.."%"
    else
        self.txt_lname.text = self.data:getDisplayColorName() --self.data.suitName  -- 装备名称
        self.txt_gongji.text = string.gsub("[ffff96]" .. row.magic[0]._magic_effect.format .. "[-]", "{0}", "[ffffff]" .. 0)     
        self.txt_fafang.text = string.gsub("[ffff96]" .. row.magic[1]._magic_effect.format .. "[-]", "{0}", "[ffffff]" .. 0) -- .. "%"
        self.grow_txt_gongji.text = row.magic[0].magic_arg1
        self.grow_txt_fafang.text = row.magic[1].magic_arg1 / row.magic[1]._magic_effect.denominator-- .."%"
        self.attrone = "[ffff96]".. des[self.data.kind] .."[-]" .. " +" .. row.magic[0].magic_arg1
        self.attrtwo = "[ffff96]".. des2[self.data.kind] .."[-]" .. " +" .. row.magic[1].magic_arg1 / row.magic[1]._magic_effect.denominator-- .."%"
    end
    if des2[self.data.kind] == des2["hui"] or des2[self.data.kind] == des2["po"] then
        self.attrtwo = self.attrtwo .."%"
        self.grow_txt_fafang.text = self.grow_txt_fafang.text .."%"
        --self.txt_fafang.text = self.txt_fafang.text  .."%"
    end


    --print_t(row.magic)
    self.next_txt_gongji.text = string.gsub("[ffff96]" .. row.magic[0]._magic_effect.format .. "[-]", "{0}", "[ffffff]" .. row.magic[0].magic_arg1 / row.magic[0]._magic_effect.denominator)
    self.next_txt_fafang.text = string.gsub("[ffff96]" .. row.magic[1]._magic_effect.format .. "[-]", "{0}", "[ffffff]" .. row.magic[1].magic_arg1 / row.magic[1]._magic_effect.denominator)
	--self.next_Label_gongji.text = row.magic[0]._magic_effec.cnName
    --self.next_Label_fafang.text = row.magic[1]._magic_effec.cnName
	self.txt_rname.text = self.data:getItemColorName(self.data.star , self.data.name .. " [00ff00]+ " .. (self.data.power + 1) .. "[-]")
    --self.next_Label_gongji.text = des[self.data.kind] .. "："
    --self.next_Label_fafang.text = des2[self.data.kind] .. "："
    
    if  self.data.lv < row.level then
        self.messageShow = TextMap.GetValue("Text_1_900") .. row.level .. TextMap.GetValue("Text_1_901")
        self.canClick = false
    else
        self.canClick = true
    end

    local consume = RewardMrg.getConsumeTable(row.consume)
    local list = {}
    table.foreach(consume, function(i, v)
        local t = v:getType()
        local num = v.rwCount
        local max = Tool.getCountByType(v:getType(), v.id)
        if num > max then
            num = "[ff2222]" .. max .. "[-]/" .. num
            ret = false
        else
            num = max .. "/" .. num
        end
            v.rwCount = 1
            table.insert(list, {
                item = v,
                num = num
            })
       
    end)
    ClientTool.UpdateGrid("", self.Grid, list)





    --self.selectPiece:SetActive(true)

    -- local list = RewardMrg.getConsumeTable(row.consume)
    -- for i = 1, #list do
    --     local it = list[i]
    --     local tp = it:getType()
    --     if tp == "money" then
    --         self.txt_cost_money.text = it.rwCount
    --         self._costMoney = it.rwCount
    --     elseif tp == "ghost" then
    --         self.txt_piece_name.text = Tool.getNameColor(it.star) .. it.name .. "[-]"
    --         self.txt_piece_count.text = Tool.getGhostCountByID(it.id) .. "/" .. it.rwCount
    --         local name = it:getHeadSpriteName()
    --         local atlasName = packTool:getIconByName(name)
    --         self.piece_icon:setImage(name, atlasName)
    --         self.ghostPiece.spriteName = it:getFrameNormal()
    --     end
    -- end
    -- local max = row.combine_exp
    -- self.combine_exp = max
    -- local cur = self.data.exp
    -- self.txt_num.text = cur .. "/" .. max
    -- self.slider.value = cur / max
    
end

--过滤
function m:filter(piece)
    local kind = piece.Table.kind
    if kind ~= 0 and kind ~= "" and kind ~= nil then
        return kind == self.data.kind or kind == "gui"
    end
    return true
end

function m:resetPiece()
    -- local star = self.star or 3
    -- for i = 1, 5 do
    --     self["guidao_item" .. i]:CallTargetFunction("reset", star, self)
    -- end
    -- selectCharPieceList = {}
end

function m:updatemes(data, ret)
    self.data = data
    m:onUpdate()
end

function m:updateLeft(data, ret)
    m:updateMainAttr()

    local list = self.data:getPowerUpList()
    local str = ""
    local right = ""
    table.foreach(list, function(i, v)
        if v.power > self.data.power then
            --未激活
            str = str .. v.name .. "\n"
            right = right .. TextMap.GetValue("Text_1_902") .. v.power .. TextMap.GetValue("Text_1_903")
        else
            str = str .. v.name .. "\n"
            right = right .. TextMap.GetValue("Text_1_904")
        end
    end)

    self.txt_attr_power.text = string.sub(str, 1, -2)
    self.txt_attr_power_right.text = string.sub(right, 1, -2)
end

function m:updateMainAttr()
   local list = self.data:getDesc(m:getAttrList(self.data.info.xilian))
    local descLeft = ""
    descLeft = list[1] .. "\n"
    self.txt_attr.text = string.sub(descLeft, 1, -2)
    local num = self.data:getShowClient(true)
    if num == 0 then
        self.binding:Hide("txt_attr_power_cur")
        self.binding:Show("txt_attr")
    else
        num = "[00ff00]" .. self.data:getMainArg() .. "[-]"

        self.binding:Show("txt_attr_power_cur")
        self.txt_attr_power_cur.text = string.sub(descLeft, 1, -2)
        self.txt_attr_power_next.text = num
        self.binding:CallManyFrame(function()
            self.binding:Hide("txt_attr")
        end,3)
    end
end

function m:updateCharPiece(ret)
end

function m:getAttrList(arg)
    local list = {}
    local len = arg.Count
    for i = 0, 3 do
        if i > len - 1 then
            list[i + 1] = 0
        else
            list[i + 1] = arg[i]
        end
    end
    return list
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
    local star = self.data.star
    local has_list = {} --碎片列表
    local charPiece = {} --已上阵角色
    local ghostCahrList = {} --魂魄列表
    local guiList = {}
    local team = m:getTeam()
    local _kind = self.data.kind --鬼道类型
    table.foreach(pieces, function(i, piece)
        if index <= 5 then
            piece:updateInfo()
            if piece.count > 0 then
                if piece.star == star then
                    local id = piece.id .. ""
                    if team[id .. ""] or id == "3" or id == "5" or id == "15" or id == "19" or id == "21" or id == "24" then
                        --神将与已上阵过滤掉。
                        table.insert(charPiece, piece)
                    else
                        local kind = piece.Table.kind
                        if kind ~= 0 and kind ~= "" and kind ~= nil then
                            if kind == _kind then
                                table.insert(ghostCahrList, piece)
                            end
                            if kind == "gui" then
                                table.insert(guiList, piece)
                            end
                        else
                            table.insert(has_list, piece)
                        end
                    end
                end
            end
        end
    end)
    selectCharPieceList = {}

    table.foreachi(ghostCahrList, function(i, piece)
        for j = 1, piece.count do
            if index <= 5 then
                ids[index] = piece
                index = index + 1
            end
        end
    end)
    if index <= 5 then
        table.foreachi(guiList, function(i, piece)
            for j = 1, piece.count do
                if index <= 5 then
                    ids[index] = piece
                    index = index + 1
                end
            end
        end)
    end
    if index <= 5 then

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
    end

    -- if index <= 5 then
    --     table.sort(charPiece, function(a, b)
    --         return a.count < b.count
    --     end)
    --     table.foreachi(charPiece, function(i, piece)
    --         for j = 1, piece.count do
    --             if index <= 5 then
    --                 ids[index] = piece
    --                 index = index + 1
    --             end
    --         end
    --     end)
    -- end

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
        -- MessageMrg.show("英雄碎片不足！")
        DialogMrg.ShowDialog(TextMap.GetValue("Text8"), function()
            uSuperLink.openModule(8)
        end)
        return
    end
    m:updateCharPiece()
end

function m:getPieceIds()
    local list = {}
    local i = 1
    self._selectExp = 0
    table.foreach(selectCharPieceList, function(ll, v)
        if v ~= nil and v.char.count > 0 then
            for j = 1, v.count do
                list[i] = v.char.id
                self._selectExp = self._selectExp + v.char.Table.ghost_exp
                i = i + 1
            end
        end
    end)
    return list
end

function m:getPos()
    local list = { self.piece_icon }
    -- for i = 1, 5 do
    --     local ret = self["guidao_item" .. i]:CallTargetFunction("isEmpty")
    --     if not ret then list[i] = self["guidao_item" .. i] end
    -- end
    return list
end

function m:playAnimation(desc)
    MusicManager.playByID(47)
    local effects = {}
    local pos_arr = m:getPos()
    local index = 1
    local charNum = 0
    table.foreach(pos_arr, function(k, v)
        if pos_arr[k] then --表示该位置有物体，实例化一个特效
        local effect = ClientTool.load("Effect/Prefab/ui_xilian_fly", v.gameObject)
        effects[index] = effect
        index = index + 1
        charNum = charNum + 1
        effect.transform.localPosition = Vector3(0, 0, 0)
        end
    end)
    self._effects = effects
    if charNum ~= 0 then
        self.binding:CallAfterTime(0.2, function(...)
            local go = self.delegate.equipbg
            local effect1 = ClientTool.load("Effect/Prefab/ui_xilian_jinjie", go.gameObject)
            self._effects["effect1"] = effect1
            effect1.transform.localPosition = Vector3(0, 12, 0)
            effect1:SetActive(false)
            self.binding:CallAfterTime(0.5, function()
                for i = 1, table.getn(effects) do
                    effects[i].transform.parent = go.transform
                    self.binding:MoveToPos(effects[i], 0.3, Vector3(0, 0, 0), function(...)
                        GameObject.Destroy(effects[i])
                        self._effects[i] = nil
                    end)
                end
            end)
            self.binding:CallAfterTime(0.5, function()
                effect1:SetActive(true)
            end)

            self.binding:CallAfterTime(1.5, function()
                m:resetPiece()
                GameObject.Destroy(effect1)
                self._effects["effect1"] = nil
                MusicManager.playByID(51)
                OperateAlert.getInstance:showToGameObject(desc, self.node)
                m:onUpdate()
                --Events.Brocast('updateLeft', self.data)
				self:updateLeft(self.data)
                local effect_reward = ClientTool.load("Prefabs/moduleFabs/guidao/gdreward_jinhua", go.gameObject)
                self._effects["effect_reward"] = effect_reward
                effect_reward.transform.localPosition = Vector3(10, -117, 0)
                self.binding:CallAfterTime(1.2, function(...)
                    GameObject.Destroy(effect_reward)
                    self._effects["effect_reward"] = nil
                    isClick = false
                    self.delegate:setLock(false)
                end)
            end)
        end)
    end
end


function m:showEffect(ret)
    MusicManager.playByID(46)
    self.effect:SetActive(false)
    self.effect:SetActive(true)
    self.binding:CallAfterTime(2, function()
        self.effect:SetActive(false)
        if ret then isClick = false end 
    end)
end

function m:onJinjie()
    if isClick == true then return end
    --检测进阶材料是否足够
    local row = TableReader:TableRowByUniqueKey("ghostPowerUp", self.data.id, self.data.power + 1)
    if row == nil then return end
    local list = RewardMrg.getConsumeTable(row.consume)
    table.foreach(list, function(i, v)
        local t = v:getType()
        local num = v.rwCount
        local max = Tool.getCountByType(v:getType(), v.id)
        if max < num then
            return
        end  
    end)
    local that = self


    --isClick = true
    that.delegate:setLock(true)
    local desc = {}
    local oldpower = that.data.power
    Api:ghostPowerUp(that.data.key, function(result)
        m:showEffect(true)
        that.data:updateInfo()
        table.insert(desc,string.gsub(TextMap.GetValue("LocalKey_707"),"{0}",that.data.power - oldpower))
        table.insert(desc, self.attrone)
        table.insert(desc, self.attrtwo)
        that.delegate:setLock(false)
        that.delegate:updateJingLianRed()
        local list = that.data:getPowerUpList()
        table.foreach(list, function(i, v)
            if v.power == self.data.power then
                --激活
                table.insert(desc, v.name)
            end
        end)
        OperateAlert.getInstance:showToGameObject(desc, self.node)
        that:updatemes(self.data)
        m:showGodSkillOpen(self.data.name, self.data.power)
    end, function(ret)
        isClick = false
        that.delegate:setLock(false)
        return false
    end)
end

function m:showGodSkillOpen(name, power)
    local godSkillMenu = Tool:getGodSkillListInfo()
        if godSkillMenu ~= nil then
            for i = 1, #godSkillMenu do
                local item = godSkillMenu[i]
                if item ~= nil and item.name == name then
                    print_t(item)
                    for i = 0, item.unlock.Count do
                        if item.unlock[i] ~= nil and item.unlock[i] == power then
                            local desc = {}
                            local str = TextMap.GetValue("Text_1_2925")..item._skillid[i].name.."[-]"
                            table.insert(desc, str)
                            OperateAlert.getInstance:showToGameObject(desc, self.node)
                            break;
                        end
                    end
                end
            end
        end
end

function m:onClick(go, name)
    if name == "btnOneKey" then
        m:onOneKey()
    elseif name == "btn_jinjie" then
        if self.canClick then
            m:onJinjie()
        else
            MessageMrg.showMove(self.messageShow)
        end
    elseif name == "Btn_ShenBinFrom" then
        UIMrg:pushWindow("Prefabs/moduleFabs/guidao/GodSkillFrom",{
            power = self.data.power, data = self.data , delegate = self})
    end
end

function m:OnDestroy()
    selectCharPieceList = nil
    -- Events.RemoveListener('updateCharPiece')
end

function m:Start()
    -- Events.AddListener("updateCharPiece", funcs.handler(self, m.updateCharPiece))
end

return m

