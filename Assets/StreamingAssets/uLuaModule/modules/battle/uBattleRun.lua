local BattleRun = {}
local timer = 0
function BattleRun:create(binding)
    self.binding = binding
    self.gameObject = self.binding.gameObject
    return self
end

-- function BattleRun:OnDestroy( ... )
--     LuaTimer.Delete(timer)
-- end

function BattleRun:onClick(go, name)
    if name == "btn_end" then
        self.battle_run_new:OnClickBTN()
    end
    -- elseif name == "btn_replay" then
    --     ClientTool.LoadLevel( UluaModuleFuncs.Instance.uOtherFuns.m_SceneName, function()
    --     end)
    -- elseif self.sprite_select.spriteName == "Zhandou_btn_zaizhan" then
    --     self:select(go)
    -- elseif self.sprite_select.spriteName == "Zhandou_btn_xiayiguan" then
    --     self:select(go)
    -- end
end

function BattleRun:updateByStartFight(model)
    if self._showTipsOnce ~= nil then
        local desc = ""
        if model == "common" then
            desc = TextMap.GetValue("Text472")
        else
            desc = TextMap.GetValue("Text473")
        end
		local list = self:getTeamInfo()
		--str = desc .. "\n" .. str
		table.insert(list, 1, desc)
		self.binding:CallManyFrame(function()
			OperateAlert.getInstance:showToGameObject(list, self.gameObject)
		end, 10)
	else 
		self._showTipsOnce = true
    end
end

function BattleRun:getTeamInfo()
    local teams = Player.Team[0].chars
    local list = {}
	--local str = ""
    for i = 0, 5 do
        if teams.Count > i then
            if teams[i .. ""] ~= 0 and teams[i .. ""] ~= "0" then
                local last_char = Char:new(teams[i .. ""])
                local star = last_char.star_level or 0
                --if star == 0 then star = 1 end
                local row = TableReader:TableRowByUnique("daxuUpAtk", "star", star)
                -- local name = last_char:getItemColorName(last_char.star,last_char:getDisplayName())
                local name = last_char:getDisplayName()
                local desc = name .. TextMap.GetValue("Text471") .. (row.powerup / 10) .. "%[-]"
                table.insert(list, desc)
				--str = str .. desc .. "\n"
            end
        end
    end
	--table.insert(list, str)
    return list
end

function BattleRun:createTips(model)
	self:updateByStartFight(model)
end

function BattleRun:update(go, isNewbie)
    --新手添加跳过
    -- if isNewbie and go == nil then
    -- 	self.btn_end.gameObject:SetActive(true)
    -- 	return
    -- end
    if isNewbie then
        self.txt_Total.gameObject:SetActive(false)
        self.txt_Count.gameObject:SetActive(false)
        self.btn_end.gameObject:SetActive(false)
        self.txt_round.gameObject:SetActive(false)
        return
    end

    --如果关卡是普通关卡 且挑战过了添加跳过 按钮 无时机
    if go then
        if go.mdouleName == 'commonChapter' then
            local row = TableReader:TableRowByUniqueKey("commonChapter", go.chapter_zj, go.chapter_xj)
            if Player.Chapter.status[row.id].star == 0 then
                self.btn_end.gameObject:SetActive(false)
                if (self.battle_run_new ~= nil) then
                    self.battle_run_new:ModifyClickBtnLater(10)
                end
            end
            return
        end
        if go.mdouleName == 'qiancengta' then

            self.txt_Total.gameObject:SetActive(false)
            self.txt_Count.gameObject:SetActive(false)
            self.txt_tower.gameObject:SetActive(true)

            self.txt_tower.text = go.selectID
            return
        end

        if go.mdouleName == "encirclement" then
            --围剿大虚
            BattleRun:createTips(go.model)
        end
    end
    self.btn_end.gameObject:SetActive(true)
end

return BattleRun
