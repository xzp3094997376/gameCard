local m = {}
local REFRESH_TIMER = 0
function m:update(row)
    local img = row.img
    if img == "" then img = row.id end
    self.img.Url = UrlManager.GetImagesPath("sl_go_on_patrol/icon/" .. img .. ".png")
    self.row = row
    local item = Player.Agency[row.id]
    local ret = m:checkUn_lock(row)
    if ret == "" then
        self._lock = false
        self.txt_time.text = ""
        self.txt_time.gameObject:SetActive(false)

        local data = Player.Agency[row.id]
        if data.state == "1" then
            local charId = tonumber(data.charId) or 0
            local sTime = ClientTool.GetNowTime(data:getLong("PatrolTime"))
            if charId ~= 0 then
                if sTime > 0 then
                    LuaTimer.Delete(REFRESH_TIMER)
                    local data = Player.Agency[self.row.id]
                    self.time = ClientTool.GetNowTime(data:getLong("PatrolTime"))
                    local ctl = self.ctl
                    local aniList = { "stand", "run", "attack" }
                    local count = 0
                    REFRESH_TIMER = LuaTimer.Add(0, 1000, function(id)
                        if self.binding == nil then return false end
                        if self.time > 0 then
                            local time = Tool.FormatTime(self.time)
                            time = "[ffff00]" .. time .. "[-]"
                            self.txt_time.text = time
                            self.txt_time.gameObject:SetActive(true)
                        else
                            --倒计时结束
                            self.txt_time.text = ""
                            self.txt_time.gameObject:SetActive(false)
                            self.can:SetActive(true)
                            Events.Brocast("showRewardSprite",{})
                            return false
                        end
                        self.time = ClientTool.GetNowTime(data:getLong("PatrolTime"))

                        return true
                    end)
                end
            end
            self.add:SetActive(charId == 0)
            self.can:SetActive(sTime <= 0 and data.dropState == "1")
        end
        self.ani:SetActive(data.state ~= "1")
        self.gameObject:GetComponent(UITexture).color = Color.white
    else
        self._lock = true
        self.txt_time.text = ""
        self.txt_time.gameObject:SetActive(false)
        self.gameObject:GetComponent(UITexture).color = Color.black
        self.ani:SetActive(false)
        self.add:SetActive(false)
        self.can:SetActive(false)
    end
    self.tip = ret
    self.lock:SetActive(self._lock)
end

-- 检查是否能获取奖励
function m:canGetReward( ... )
    if self.can.gameObject.activeInHierarchy == false then
        return false
    else 
        return true
    end
end

function m:OnDestroy()
    LuaTimer.Delete(REFRESH_TIMER)
end

function m:stop()
    LuaTimer.Delete(REFRESH_TIMER)
end

function m:checkUn_lock(row)
    local id = tonumber(row.id)
    local txt = ""
    local un_lock = row.unlock
    for i = 0, un_lock.Count - 1 do
        local it = un_lock[i]
        if it.unlock_condition == "lv" then
            local lv = it.unlock_arg
            if Player.Info.level < lv then
                txt = txt .. string.gsub(TextMap.GetValue("Text115"),"{0}",lv)
            end
        elseif it.unlock_condition == "area" then
            local preRow = TableReader:TableRowByID("areaConfig", it.unlock_arg)
            local pre = Player.Agency[preRow.id]
            if pre and pre.state ~= "1" then
                txt = txt .. string.gsub(TextMap.GetValue("Text116"),"{0}",preRow.area_name)
            end
        end
    end
    return txt
end

function m:onClick(...)
    if self._lock == true then
        MessageMrg.show(self.tip)
        return
    end
    local binding = UIMrg:push("go_on_patrol", "Prefabs/activityModule/goOnPatrol/go_on_patrol")
    Debug.Log(binding.name)
    binding:CallUpdate({ self.row })
end

function m:findSprite(name)
    local tran = self.gameObject.transform:Find(name)
    if tran == nil then return nil end
    m:setAssets(tran.gameObject:GetComponent(UISprite))
end

function m:setAssets(sp)
    if sp then
        sp.atlas = myAtlas
    end
end

function m:Start()
    ClientTool.AddClick(self.gameObject, function()
        m:onClick()
    end)
    -- self.txt_time.bitmapFont = myFont

    -- m:findSprite("lock")
    -- m:findSprite("node/can/txt_can")
    -- m:findSprite("node/can/sp")
    -- m:findSprite("node/add")
    -- m:findSprite("ani/dao_left")
    -- m:findSprite("ani/dao_right")
    -- m:findSprite("ani/light")
end

return m