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
    GougHui = { path = 'main_scene/scene/new_ZhuJieMian/GougHui', rotate = 2, id = 52, pos = { 2, 0, 0 }, img = "Jianzhu_xiehui", lockPos = { 0.5, 0.5, 0 } }, --公会},
    XuanShang = { path = 'main_scene/scene/new_ZhuJieMian/XuanShang', rotate = 10, id = 10, pos = { 0.7, 0, 0 }, img = "Jianzhu_xuanshang", autoHide = 70, lockPos = { 0, 0.8, 0 } }, --悬赏
    Yanjiushuo = { path = 'main_scene/scene/new_ZhuJieMian/Yanjiushuo', rotate = 8, id = 232, pos = { -2.5, 0, 0 }, autoHide = 70, img = "Jianzhu_qianghua" }, --轮回
    Linwangta = { path = 'main_scene/scene/new_ZhuJieMian/Linwangta', rotate = 35, id = 226, pos = { 1.5, 0, 0 }, img = "Jianzhu_lingwangta", check = "qianchengta", autoHide = 57, lockPos = { 0, 1, 0 } }, --灵王塔
    Shilian = { path = 'main_scene/scene/new_ZhuJieMian/Shilian', rotate = 35, id = 70, pos = { 1.3, 0.5, 0 }, img = "Jianzhu_zhengzhan", autoHide = 46.5 }, --征战
    GuanKa = { path = 'main_scene/scene/new_ZhuJieMian/GuanKa', rotate = 30, id = 6, pos = { -1.5, 0, 0 }, img = "Jianzhu_chuangguan", check = "chapter" }, --闯关
    Juedou = { path = 'main_scene/scene/new_ZhuJieMian/Juedou', rotate = 24, id = 5, pos = { 1, 0, 0 }, img = "Jianzhu_duijue", lockPos = { 0, 1, 0 } }, --对决
    Jingji = { path = 'main_scene/scene/new_ZhuJieMian/Jingji', rotate = 20, id = 11, pos = { -1.5, 0, 0 }, img = "Jianzhu_jingji", lockPos = { 0, 1, 0 } }, --竞技场
    PuyuanShop = { path = 'main_scene/scene/new_ZhuJieMian/PuyuanShop', rotate = 16.3, id = 233, pos = { -1.8, 0, 0 }, img = "Jianzhu_heidian", lockPos = { 0, 0.8, 0 } }, --黑店
    PaiHangBang = { path = 'main_scene/scene/new_ZhuJieMian/PaiHangBang', rotate = 23, id = 122, pos = { 1.0, 0, 0 }, img = "Jianzhu_paihang" }, --排行榜
    Mailbox = { path = 'main_scene/scene/new_ZhuJieMian/Mailbox', rotate = 27, id = 51, pos = { -0.8, 0.3, 0 }, img = "Jianzhu_youxiang", check = "mail" }, --邮箱
    ZhaoHuang = { path = 'main_scene/scene/new_ZhuJieMian/ZhaoHuang', rotate = 32, id = 8, pos = { 1, 0.3, 0 }, img = "Jianzhu_zhaohuang", check = "draw" }, --抽卡
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

    if GuideConfig:isPlaying() then
        Tool.SetActive(self._hand, false)
    else
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
    end
end

function m:hideHand()
    Tool.SetActive(self._hand, false)
end

--显示跨服比武前三名详细信息
function m:show_top3_info(index)
    if index == nil or index >3 or index <1 then return end
    local data = nil
    if self.player_list ~= nil then
        data = self.player_list[index]
    end
    data.index = index
    if data ~= nil then
        UIMrg:pushWindow("Prefabs/moduleFabs/attack/attack_hero_info", data)
    end
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

function m:callBack()
    -- body
end

function m:OnDestroy()
    Events.RemoveListener('hideHand')
    Events.RemoveListener("show_top3_info")
end

function m:initPlayer(data)
    if data == nil or data.Count == 0 then return end
    self.player_list = {}
    for i=0,data.Count-1 do
        table.insert(self.player_list,data[i])
    end

    self.pos_1 = Vector3(-3.92,4.89,-6.19)
    self.pos_2 = Vector3(-2.17,4.43,-6.19)
    self.pos_3 = Vector3(-5.56,4.04,-6.19)
    self.scene_obj = GameObject.Find("main_scene/scene")
    self.click_obj = GameObject.Find("main_scene/scene/new_ZhuJieMian")
    if self.scene_obj ~= nil then
        self.taizi = ClientTool.load("Effect/Prefab/taizi_2", self.scene_obj)
        self.taizi.transform.localPosition = Vector3(-3.93,3.04,-6.61)
        self.taizi.transform.localScale = Vector3(40,40,40)
        for i=1,3 do
            local  num = "0"..i
            self["taizi_"..i] = GameObject.Find("main_scene/scene/taizi_2/tai"..num)
            -- "rankList":[{"name":"漫粉色红","team":[5,28,21,34],"sid":11},
            if self.player_list[i] ~= nil then
                local team = json.decode(self.player_list[i].team:toString())
                local id = self:getChar(team)
                self.binding:LoadModel(id,self["taizi_"..i],"stand",function(t, ctl)
                    ctl.transform.eulerAngles = Vector3(0, 0, 0)
                    ctl.transform.localPosition = Vector3(0, 0, 0)
                    ctl.transform.localScale = Vector3(0.03, 0.03, 0.03)
                    if modle ~= nil and smoke ~= nil then
                        modle.gameObject:SetActive(true)
                        smoke.gameObject:SetActive(true)
                    end
                    self["player_"..i] = ClientTool.load("Prefabs/moduleFabs/attack/attack_player", self.click_obj)
                    self["player_"..i].name = "player_"..i
                    self["player_"..i].transform.localPosition = self["pos_"..i]
                end)
            end
        end
    else
        print("fail")
    end
end

--获取玩家模型id
function m:getChar(list)
    for k,v in pairs(list) do
        if v ~= "" and v ~= "null" and v ~= 0 and v ~= nil then
            return v
        end
    end
    return 1
end

function m:Start()
    self.buideNames = {}
    self.unlockBuideNames = {}
    m:findBuild()
    Events.AddListener("hideHand", funcs.handler(self, self.hideHand))
    Events.AddListener("show_top3_info", funcs.handler(self, self.show_top3_info))
    
    --主城雕像
    self.binding:CallManyFrame(function()
        Api:getLastTop3(function (result)
            self:initPlayer(result.rankList)
        end)
    end, 2)
end

return m

