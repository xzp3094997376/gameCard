--
-- Created by IntelliJ IDEA.
-- User: xiyou
-- Date: 2015/2/4
-- Time: 14:41
-- To change this template use File | Settings | File Templates.
-- 功能解锁

local unlockModule = {}

function unlockModule:init(id, item, check)
    self.unlockLv = Tool.getUnlockLevel(id)
    self.linkId = id
    self.item = item
    self.oldPlayerLv = Player.Info.level
    if check then
        self:check()
        return
    end
    if not self:checkLvUnlock(self.unlockLv) then
        self:check()
    end
end

function unlockModule:checkLvUnlock(clv)
    local lv = Player.Info.level
    if clv ~= lv then return false end
    local unlock = unlockMap[self.linkId]
    if unlock then
        local step = unlock.guide
        if Player.guide[step] < 2 then
            self.item.gameObject:SetActive(false)
            Events.AddListener("ListenerPlayUnlock", funcs.handler(self, self.playUnlock))
            Tool.checkLevelUnLock(self.linkId)
            return true
        end
    end
    return false
end


function unlockModule:update()
    local lv = Player.Info.level
    if self.oldPlayerLv < lv and lv == self.unlockLv then
        self:playUnlock()
    elseif self.oldPlayerLv < lv and lv > self.unlockLv then
        self:check()
    end
    self.oldPlayerLv = lv
end

function unlockModule:playUnlock()
    GuideManager.isModel(true)
    local back = ClientTool.load("Prefabs/publicPrefabs/bgBlack")
    UIMrg:pushWindow(back)
    local go = ClientTool.AddChild(self.item.gameObject, GlobalVar.center)
    back:GetComponent("UIWidget").alpha = 0.5
    go.transform.localPosition = Vector3(0, 0, 0)
    go:SetActive(true)
    UIMrg:pushWindow(go)
    Events.RemoveListener('ListenerPlayUnlock')

    LuaTimer.Add(1000, function(id)
        go.transform.position = self.item.transform.position
        ClientTool.PlayTweenPostion(go, GlobalVar.center, 1, function()
            self.item.gameObject:SetActive(true)
            UIMrg:popWindow()
            UIMrg:popWindow()
            GuideConfig:next()
        end)
        return false
    end) --定时器
end

function unlockModule:check()
    if self.unlockLv > Player.Info.level then
        self.item.gameObject:SetActive(false)
    else
        self.item.gameObject:SetActive(true)
    end
end

function unlockModule:new(lv, item, check)
    local o = {}
    setmetatable(o, self)
    self.__index = self
    o:init(lv, item, check)
    return o
end

return unlockModule

