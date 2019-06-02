--
-- Created by IntelliJ IDEA.
-- User: xiyou
-- Date: 2014/12/24
-- Time: 11:34
-- To change this template use File | Settings | File Templates.
-- 建筑名

local m = {}
local builds =
{
    fuben = { path = 'gonghui_map/scene/new_ZhuJieMian/fuben', rotate = 0, id = 8, pos = { 15, 0, 0 }, img = "Jianzhu_xiehuifuben", check = "", autoHide = 1000 }, --副本},
    jibai = { path = 'gonghui_map/scene/new_ZhuJieMian/jibai', rotate = 0, id = 8, pos = { 2, -15, 0 }, img = "Jianzhu_chanbai", check = "", autoHide = 1000 }, --膜拜
    gonghuishop = { path = 'gonghui_map/scene/new_ZhuJieMian/gonghuishop', rotate = 8, id = 8, pos = { -15, 0, 0 }, img = "Jianzhu_xiehuishangdian", check = "", autoHide = 1000 }, --公会商店},
    dating = { path = 'gonghui_map/scene/new_ZhuJieMian/dating', rotate = 0, id = 8, pos = { 15, 0, 0 }, img = "Jianzhu_xiehuidazhan", check = "", autoHide = 1000 }, --大厅},
}
local Build = {}
function Build:update()
    if self.check == "draw" or self.check == "mail" then
        local ret = Tool.checkRedPoint(self.check)
        self.redpiont:SetActive(ret)
    elseif self.check == "chapter" or self.check == "qianchengta" then
        local ret = RedPoint.checkRedPoint(self.check)
        self.redpiont:SetActive(ret)
    else
        self.redpiont:SetActive(false)
    end
end

function Build:init(go, target, option)
    local autoHide, img, pos, check = option.autoHide, option.img, option.pos, option.check

    self.check = check
    local com = go:AddComponent(Follow3DObject)
    com.target = target.transform
    com.mOffset = Vector3(pos[1], pos[2], pos[3])
    if autoHide ~= nil then
        com.autoHide = autoHide
    end
    if option.type == "UITexture" then
        local sp = go.transform:Find("pic"):GetComponent(UISprite)
        local t = sp.gameObject:AddComponent(UITexture)
        t.width = sp.width
        t.height = sp.height
        local s = sp.gameObject:AddComponent(SimpleImage)
        GameObject.Destroy(sp)
        self.img = s
        self.img.Url = UrlManager.GetImagesPath("common/" .. img .. ".png")
        self.img:MakePixelPerfect()
    else
        self.img = go.transform:Find("pic"):GetComponent(UISprite)
        self.img.spriteName = img
        self.img:MakePixelPerfect()
    end


    self.redpiont = go.transform:Find("pic/red_point").gameObject
    self.redpiont:SetActive(false)
end

local fields = {}

Build.__index = function(t, k)
    local var = rawget(Build, k)

    if var == nil then
        t = fields
        var = rawget(t, k)

        if var ~= nil then
            return var()
        end
    end

    return var
end
function Build.new(go, target, option)
    local o = {}
    setmetatable(o, Build)
    o:init(go, target, option)
    return o
end

function m:checkUnLock()
    local unlock = m:unLockLevel()
    local lv = Player.Info.level
    table.foreach(builds, function(i, v)
        if v.id ~= nil then
            local go = self.builds[i]
            if go and unlock[i] then
                if lv < unlock[i] then
                    --未解锁
                    if self.unlockBuideNames[i] == nil then
                        local b = ClientTool.load("Prefabs/moduleFabs/mainScene/buildDesc", self.gameObject)
                        b.name = i
                        local com = b:AddComponent(Follow3DObject)
                        local lab = com.transform:Find("bg/txt_desc"):GetComponent(UILabel)
                        lab.text =string.gsub(TextMap.GetValue("LocalKey_737"),"{0}",unlock[i])
                        com.target = go.transform
                        if v.lockPos then
                            local pos = v.lockPos
                            com.mOffset = Vector3(pos[1], pos[2], pos[3])
                        end
                        if v.autoHide ~= nil then
                            com.autoHide = v.autoHide
                        end
                        self.unlockBuideNames[i] = b
                    end
                else
                    if self.buideNames[i] == nil then
                        local b = ClientTool.load("Prefabs/moduleFabs/mainScene/build_name_item", self.gameObject)
                        b.name = i
                        local build = Build.new(b, go, v)
                        self.buideNames[i] = build
                    end
                    if self.unlockBuideNames[i] then
                        self.unlockBuideNames[i]:SetActive(false)
                        GameObject.Destroy(self.unlockBuideNames[i])
                        self.unlockBuideNames[i] = nil
                    end
                end
            end
        end
    end)
end

function m:getUnlockText(level)
    return string.gsub(TextMap.TXT_OPEN_MODULE_BY_LEVEL, "{0}", level)
end

local unLockLv = nil
function m:unLockLevel()
    if unLockLv == nil then
        unLockLv = {}
        table.foreach(builds, function(i, v)
            if v.id ~= nil then
                local linkData = Tool.readSuperLinkById( v.id)
                if linkData then
                    local unlockType = linkData.unlock[0].type --解锁条件
                    if unlockType ~= nil then
                        --解锁条件
                        local level = linkData.unlock[0].arg
                        --等级方式节解锁
                        if unlockType == "level" then
                            unLockLv[i] = level
                        end
                    end
                end
            end
        end)
    end

    return unLockLv
end

function m:update()
    local ret = false
    m:checkUnLock()
    table.foreach(self.buideNames, function(i, v)
        v:update()
    end)

    -- if GuideConfig:isPlaying() then
    --     Tool.SetActive(self._hand, false)
    -- else
        local row = TableReader:TableRowByID("GMconfig", 11)
        if row and row.args2 > Player.Info.level then
            Events.Brocast('hideHand')
            if self._hand == nil then
                local target = GameObject.Find("main_scene/scene/new_ZhuJieMian/Object17")
                if target == nil then return end
                self._hand = ClientTool.load("Prefabs/publicPrefabs/guide_hand", self.gameObject)
                local com = self._hand:AddComponent(Follow3DObject)
                com.target = target.transform
            end
            Tool.SetActive(self._hand, false)
            Tool.SetActive(self._hand, true)
        else
            Tool.SetActive(self._hand, false)
        end
    --end
end

function m:hideHand()
    Tool.SetActive(self._hand, false)
end

function m:findBuild()
    self.builds = {}
    table.foreach(builds, function(i, v)
        local target = GameObject.Find(v.path)
        if target then
            self.builds[i] = target
            local com = target:GetComponent("BuildCtrlTarget")
            com.m_AngleY = v.rotate
        end
    end)
end

function m:OnDestroy()
    Events.RemoveListener('hideHand')
end

function m:Start()
    self.buideNames = {}
    self.unlockBuideNames = {}
    m:findBuild()
    Events.AddListener("hideHand", funcs.handler(self, self.hideHand))
end



return m

