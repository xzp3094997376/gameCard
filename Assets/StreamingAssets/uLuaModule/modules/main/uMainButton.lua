local unlockModule = require("uLuaModule/modules/guide/unlockModule.lua")
GuildDatas = require("uLuaModule/modules/league/uleague_Datas")
local mainButton = {}

-- 二级按钮配置
local subMenu = 
{
	more = {"fenjie", "tujian", "haoyou", "paihangbang"},
	hero = {"zhaohuan", "yingxiong", "buzhen"},
	shangcheng = {"chongzhi", "shangcheng", "shangdian"}
}


-- 死神之路
function mainButton:onRoad(go)
    -- MessageMrg.show("功能开发中，敬请期待")
    Tool.push("sishenzhilu", "Prefabs/moduleFabs/bleachRoad/bleacroad")
end


-- 任务
function mainButton:onTask(go)
   UIMrg:push("task", "Prefabs/moduleFabs/achievementModule/gui_task", {})
end

-- 背包
local isSelectBag = false
function mainButton:onBag(go)
    --if Player.Info.level >= Tool.getUnlockLevel(804) then
    --    isSelectBag = not isSelectBag
    --    self.beibao_new:SetActive(isSelectBag)
    --else
        Tool.push("PACK", "Prefabs/moduleFabs/packModule/newpack")
    --end
end
function mainButton:onRecycle(go)
    Tool.push("recycle", "Prefabs/moduleFabs/recycleModule/recycle", {})
end
-- 商店
function mainButton:onShop(go)
    uSuperLink.openModule(1)
	--UIMrg:pushWindow("Prefabs/moduleFabs/mainModule/gui_pop_menu", {data = subMenu.shangcheng, type = "center", pos = self.btn_shop.transform.position})
end

function mainButton:onAct(go)
    --Tool.push("activity", "Prefabs/moduleFabs/activityModule/holiday/activity_holiday",{"","common"})
    Tool.push("activity", "Prefabs/moduleFabs/activityModule/moduleActivity",{"","common"})
end

--2015.5.8日改为召唤
function mainButton:onTuJian(go)
    uSuperLink.openModule(231)
end

function mainButton:onSummon()
    uSuperLink.openModule(8)
end

-- 活动
function mainButton:onActive(go)
    uSuperLink.openModule(219)
end


--布阵
function mainButton:onTeam(go)
    uSuperLink.openModule(802)
    -- Tool.push("formation", "Prefabs/moduleFabs/formationModule/formation/formation_main", { 0 })
end

--设置
function mainButton:onSetting(go)
    UIMrg:pushWindow("Prefabs/moduleFabs/userinfoModule/setting_new", {})
end

--闯关
function mainButton:onSection(go)
    LuaMain:openWithSound(6)
end

--更多
function mainButton:onMore(go)
    --LuaMain:openWithSound(6)
	UIMrg:pushWindow("Prefabs/moduleFabs/mainModule/gui_pop_menu", {type = "more", pos = self.btn_more.transform.position})
end

--工会
function mainButton:onGuild(go)
    --LuaMain:openWithSound(6)
	GuildDatas:EnterLeague()
end

--征战
function mainButton:onZhengZhan(go)
	uSuperLink.openModule(70)
end

--新的英雄培养界面（临时入口）
function mainButton:onNewHero(go)
    Tool.push("hero_select_char", "Prefabs/moduleFabs/hero/hero_select_char")
    --uSuperLink.openModule(73)
	--UIMrg:pushWindow("Prefabs/moduleFabs/mainModule/gui_pop_menu", {data = subMenu.hero, type = "bottom", pos = self.btn_buxia.transform.position})
end

function mainButton:onPet()
	--Tool.push("pet_select_char", "Prefabs/moduleFabs/hero/pet_select_char")
	uSuperLink.openModule(150)
end 

function mainButton:onClick(go, btnName)
    if btnName == 'btn_beibao' then
        mainButton:onBag(go)
    elseif btnName == 'btn_buxia' then
        mainButton:onNewHero(go)
    elseif btnName == "btn_section" then
        mainButton:onSection(go)
    elseif btnName == "btn_road" then
        mainButton:onRoad(go)
    elseif btnName == "btn_zhenrong" then
        mainButton:onTeam(go)
    elseif btnName == "btn_chaungguan" then
        mainButton:onSection(go)
    elseif btnName == "btn_shop" then
		mainButton:onZaHuo()
	elseif btnName == "btn_activity" then 
		self:onAct(go)
	elseif btnName == "btn_chongzhi" then 
        --Tool.push("purchase", "Prefabs/moduleFabs/vipModule/vip")
		Tool.push("activity", "Prefabs/moduleFabs/activityModule/activity_gradeGift",{"","recharge"})
    elseif btnName == "btn_summon" then
        self:onSummon()
	elseif btnName == "btn_shop_shop" then 
		UIMrg:pushWindow("Prefabs/moduleFabs/mainModule/gui_shop_pop_menu", {type = "shop", pos = self.btn_shop_shop.transform.position})
	elseif btnName == "btn_richang" then 
		self:onTask(go)
    elseif btnName == "btn_zhuangbei" then
        --uSuperLink.open("ghost", { 1 })
		Tool.push("gui_equip_panel", "Prefabs/moduleFabs/equipModule/gui_equip_panel")
    elseif btnName == "btn_baowu" then  
        --Tool.push("", "Prefabs/moduleFabs/TreasureModule/treasure_main")
        uSuperLink.openModule(804)
        isSelectBag = false
        --self.beibao_new:SetActive(isSelectBag)
	elseif btnName == "btn_more" then
		self:onMore(go)
	elseif btnName == "btn_xueyuan" then
		MessageMrg.showMove(TextMap.GetValue("Text_1_938"))
        --uSuperLink.openModule(52)
	elseif btnName == "btn_zhengzhan" then
		self:onZhengZhan(go)
	elseif btnName == "btn_huishou" then 
		self:onRecycle(go)
	elseif btnName == "btn_shenle" then
		--self.btn_shenle:SetState(UIButtonColor.State.Normal, true)
        uSuperLink.openModule(13)
	elseif btnName == "btn_pet" then 
		--self.btn_pet:SetState(UIButtonColor.State.Normal, true)
		self:onPet()
	elseif btnName == "btn_vip" then 
        Tool.push("activity", "Prefabs/moduleFabs/activityModule/activity_vip",{"","vip"})
		--Tool.push("purchase", "Prefabs/moduleFabs/vipModule/vip", { ui = "tequan" })
	elseif btnName == "btn_jjc" then 
		--uSuperLink.openModule(11)
		Tool.push("jinji_main", "Prefabs/moduleFabs/arenaModule/jingji_main", {})
    elseif btnName == "btn_renling" then 
        local lv = TableReader:TableRowByID("renling_config",1).value2
        if Player.Info.level < lv then 
            MessageMrg.show(TextMap.GetValue("Text_1_803")..lv..TextMap.GetValue("Text_1_937"))
            return
        end 
        Tool.push("renling", "Prefabs/moduleFabs/renlingModule/arrayChart_main")
    elseif btnName == "btn_yuling" then 
        local lv = TableReader:TableRowByID("yulingArgs","unlock_lv").value
        lv=tonumber(lv)
        if Player.Info.level < lv then 
            MessageMrg.show(TextMap.GetValue("Text_1_803")..lv..TextMap.GetValue("Text_1_937"))
            return
        end 
        Tool.push("yuling", "Prefabs/moduleFabs/yuling/yuling_main")
	elseif btnName == "btn_zhaomu" then 
		self:onShop(go)
    end

end

function mainButton:onZaHuo()
	local uluabing = Tool.push("shop", "Prefabs/moduleFabs/puYuanStoreModule/shop")
	local args = { 1 }
	uluabing:CallUpdate(args)
end

function mainButton:onChenhao()
	Tool.push("shenle", "Prefabs/moduleFabs/chenghaoModule/chenghaoModule")
end 

--公会--测试
--function mainButton:onLeague()
--    GuildDatas:EnterLeague()
--end

function mainButton:getState()
    self.charRet = Tool.checkRedPoint("char")-- or Tool.checkRedPoint("jinhua") or Tool.checkRedPoint("linluo") or Tool.checkRedPoint("tujian")
    -- self.skillRet = Tool.checkRedPoint("skill")
    -- self.jinhuaRet = Tool.checkRedPoint("jinhua")
    -- self.linluoRet = Tool.checkRedPoint("linluo")
	self.petRet = Tool.checkRedPoint("pet") or Tool.checkRedPoint("petPiece") 
    self.tujianRet = Tool.checkRedPoint("tujian")
    self.summonRet = Tool.checkRedPoint("draw")
    self.chuangguanRet = RedPoint.checkRedPoint("chapter")
    self.teamRet = RedPoint.checkTeamRedPoint() or Tool.checkRedPoint("guidao") or Tool.checkFriend("friend")
    self.red_point_roadRet = Tool.checkRedPoint("bleachRoad")
    self.isShowRet = Tool.checkRedPoint("isHaveBleachRoad")
    self.guidao_hecheng = Tool.checkRedPoint("guidao_hecheng") or Tool.checkRedPoint("guidao_qh",nil,true) or Tool.checkRedPoint("guidao_jl",nil,true)
    self.shenle =  Tool.checkRedPoint("chenghao")
    self.mail = Tool.checkRedPoint("mail")
    self.friend = Tool.checkRedPoint("friend")
    self.zhaomu = Tool.checkRedPoint("zhaomu")
	self.buzhen = Tool.checkRedPoint("guidao")
    self.renling = Tool.checkRedPoint("renling")
    self.yuling = Tool.checkRedPoint("yuling_total")
	self.richan = Tool.checkRedPoint("active") or Tool.checkRedPoint("task") or false
    self.beibao=Tool.checkRedPoint("beibao") 
    self.renwu=Tool.checkRedPoint("renwu")
    if mainButton:judgeQiriIsClose() then
        self.qiri = Tool:SevenDayRedPoint("day7")
    elseif mainButton:judgeNewQiriIsClose("Day14s") then
        self.qiri = Tool:SevenDayRedPoint("Day14s")
    end

    if mainButton:judgeNewQiriIsClose("offyear") then
        self.jieri = Tool:SevenDayRedPoint("offyear")
    elseif mainButton:judgeNewQiriIsClose("SpringFestival") then
        self.jieri = Tool:SevenDayRedPoint("SpringFestival")
    elseif mainButton:judgeNewQiriIsClose("yuanxiaojie") then
        self.jieri = Tool:SevenDayRedPoint("yuanxiaojie")
    end

    if self.isShowRet then
        self.binding:Hide("btn_road")
    else
        self.binding:Hide("btn_road")
    end
end

function mainButton:judgeQiriIsClose()
    local state = false
    local tab = Player.Day7s.time / 1000
    local now = os.time()
    if now > tab then
        state = false
        return state
    else
        state = true
        return state
    end
    return state
end

function mainButton:judgeNewQiriIsClose(actType)
    local state = false
    if Player.DayNs[actType].actState == 1 then
         --print(actType..":开启")
        state = true
    else
         --print(actType..":尚未开启或已结束")
        state = false
    end
    return state
end

function mainButton:updateRedPoint()
    mainButton:getState()
    self.red_point_char:SetActive(self.charRet or false)
    self.red_point_pet:SetActive(self.petRet or false)
    self.red_point_shenle:SetActive(self.shenle or false)
    self.red_point_for_more:SetActive(self.mail or self.friend  or false)
    self.red_point_for_zhaomu:SetActive(self.zhaomu or false)
    self.red_point_renling:SetActive(self.renling or false)
    self.red_point_for_yuling:SetActive(self.yuling or false)
    -- self.red_point_skill:SetActive(self.skillRet or false)
    -- self.red_point_jinhua:SetActive(self.jinhuaRet or false)
    -- self.red_point_linluo:SetActive(self.linluoRet or false)
    -- self.red_point_btn:SetActive(false)
    --self.red_point_tujian:SetActive(self.tujianRet or false)
    --self.red_point_summon:SetActive(self.summonRet or false)
    --self.red_point_road:SetActive(self.red_point_roadRet or false)
    self.red_point_zhengrong:SetActive(self.buzhen or false)
    self.red_point_cg:SetActive(self.chuangguanRet or false)
    self.red_point_zhuangbei:SetActive(self.guidao_hecheng or false)
    self.btn_effect:SetActive(Player.Info.level<=15 and not GuideMrg:isPlaying())
	self.red_point_for_chengjiu:SetActive(self.richan or false)
    self.red_point_for_beibao:SetActive(self.beibao or false)
    self.red_point_for_renwu:SetActive(self.renwu or false)
    --self.red_point_for_jiere:SetActive(self.jieri or false)
    --if Player.Day7s.time ~= nil and Player.Day7s.time > 0 then
    self.red_point_for_qiri:SetActive(self.qiri or false)
    --self.red_point_for_qiri:SetActive(Tool.checkRedPoint("openSv"))
    --end
end

function mainButton:update(hide)
    self:onUpdate()
end

function mainButton:onUpdate()
    self.binding:CallAfterTime(0.2, function()
        self:updateRedPoint()

        -- self.unlockSkill:update()
        -- self.unlockLinLuo:update()
        -- self.unlockXilian:update()
        -- self.unlockGuiDao:update()
    end)
    local ret = true
    local lv = Tool.getUnlockLevel(241)
    if lv > Player.Info.level then
        ret = false
    end
	self.btns_top:Reposition()
	--self.btns_left:Reposition()
    --Tool.SetActive(self.btn_ghost, ret)
end

function mainButton:checkBoxOpen()
    local chapterData = TableReader:TableRowByUniqueKey("chapter", 2, "commonChapter")
    --小关宝箱
    local ta = TableReader:TableRowByUniqueKey("commonChapter", 2, 3)
    local  box = ta["box"]
    if box.Count > 0 then
        local boxState = false
        if Player.Chapter.status[ta.id] ~= nil then
            boxState = Player.Chapter.status[ta.id].bGotBox
        end
        if boxState ~= nil and boxState == true then
            print("boxState")
            return true
        end
    end
    return false
end

function mainButton:checkGhostAndGhostLv()
    local charid=Player.Team[0].chars[0]
    local char =Char:new(charid)
    local ghostSlot = Player.ghostSlot
    local ghost = Player.Ghost
    local slot = ghostSlot[0]
    local postion = slot.postion
    local key = postion[0]
    if key ~= "" and key ~= nil and key ~= 0 and key ~= "0" then
        local g = ghost[key].id
        if g ~= 0 then
            local gh = Ghost:new(g, key)
            local ghostLevelUpCost = TableReader:TableRowByUnique("ghostLevelUpCost", "level", gh.lv + 1)
            local ret=true
            if ghostLevelUpCost~=nil then 
                local money = ghostLevelUpCost[gh.kind .. gh.star]
                ret = money < Player.Resource.money
            end
            if ret == true then
                ret = gh:curMaxLv()
            end
            return ret
        end 
    end
    return true
end

function mainButton:checkLv(id, ret)
    
    if Tool.getUnlockLevel(id) <= Player.Info.level then
        local unlock = unlockMap[id]
        if unlock then
            local step = unlock.guide
            if step=="guidao" then 
                if mainButton:checkBoxOpen()==false then 
                    ret =false
                else 
                    if mainButton:checkGhostAndGhostLv()==false then
                        ret =false
                    end
                end 
                local _id = Player.guide[step]
                print ("_id =" .. _id)
                if _id < 2 then
                    if ret then
                        print("<<<<<<<<<<<<<<<<<<")
                        Tool.checkLevelUnLock(id)
                        return true
                    end
                end
            end
        end
    end
    return false
end

function mainButton:InitUnLock()
    local ret = false
    -- self.unlockSkill = unlockModule:new(14, self.btn_skill) --解锁技能等级
    -- self.unlockGuiDao = unlockModule:new(241, self.btn_ghost,true) --解锁鬼道等级
    -- self.unlockLinLuo = unlockModule:new(229, self.btn_linluo) --解锁灵络等级
    -- self.unlockXilian = unlockModule:new(230, self.btn_xilian) --解锁洗练等级

    table.foreach(unlockMap, function(i, v)
        if ret ==false then 
            if v.effect == true then
                ret = mainButton:checkLv(i)
            else
                ret = mainButton:checkLv(i, true)
            end
        end
        if ret == true then return end
    end)
end

function mainButton:OnEnable()
    print("OnEnable")
    --mainButton:InitUnLock()
end

function mainButton:Start()
    self.hide = false
end


return mainButton