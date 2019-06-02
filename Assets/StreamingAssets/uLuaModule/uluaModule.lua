modulePrefabs = {
    shop_puyuan = "Prefabs/moduleFabs/puYuanStoreModule/shop", --普源商店
    shop_xuyegong = "Prefabs/moduleFabs/puYuanStoreModule/storeTwo", --虚越宫商店
    shop_xiehui = "Prefabs/moduleFabs/puYuanStoreModule/store", --公会商店
    shop_jingjichang = "Prefabs/moduleFabs/puYuanStoreModule/storeTwo", --竞技场商店
    jingyingguanqia = "Prefabs/moduleFabs/EliteModule/chapterEliteDiff", --对决（英雄超链接）
    jingyingguanqia1 = "Prefabs/moduleFabs/EliteModule/chapterElite", --对决首页
    chouka = "Prefabs/moduleFabs/choukaModule/summon", --抽卡
    tiaozhan = "Prefabs/moduleFabs/offer_challenge/fubenUI", --禁地试练
    xuanshang = "Prefabs/moduleFabs/offer_challenge/fubenUI", --悬赏
    jingjichang = "Prefabs/moduleFabs/arenaModule/arena_new", --竞技场
    qianghua = "Prefabs/moduleFabs/equipModule/equip/equip_choose", --强化
    xuyegong = "Prefabs/moduleFabs/xuyegongModule/xuYeGong_map", --虚越宫
    sishenzhilu = "Prefabs/moduleFabs/bleachRoad/bleacroad", --死神之路
    qiancengta = "Prefabs/moduleFabs/qiancengta/qiancengta", --千层塔
    jineng = "Prefabs/moduleFabs/charModule/charList", --技能升级
    chapter1 = "Prefabs/moduleFabs/chapterModule/chapterModule_new", --闯关
    chapter = "Prefabs/moduleFabs/chapterModule/chapterModule_new", --闯关超链接
    hardChapter = "Prefabs/moduleFabs/chapterModule/chapterModule_new", --闯关超链接
    mail = "Prefabs/moduleFabs/mailModule/mail_main", --邮箱
    xiehui = "Prefabs/moduleFabs/unionModule/union", --协会
    dianshichengjin = "Prefabs/moduleFabs/alertModule/GoldToMoney", --点石成金
    rank = "Prefabs/moduleFabs/ranksModule/rank_all", --排行榜
    --charge = "Prefabs/moduleFabs/vipModule/vip", --充值
    charge="Prefabs/moduleFabs/activityModule/activity_gradeGift",
    dailyTask = "Prefabs/moduleFabs/questModule/quest_main", --日常任务
    tujian = "Prefabs/moduleFabs/tujian/newHeroTujian",
    lunhui = "Prefabs/moduleFabs/recycleModule/recycle", --轮回
    heidian = "Prefabs/moduleFabs/puYuanStoreModule/store", --黑店
    ghost = "Prefabs/moduleFabs/guidao/ghost_list_new", --鬼道
    guidao = "Prefabs/moduleFabs/guidao/ghost_list_new", --鬼道
    treasureview = "Prefabs/moduleFabs/TreasureModule/treasure_main",--宝物
    haoyou = "Prefabs/moduleFabs/friendModule/friend_all", --好友
    bleach_delegate = "Prefabs/activityModule/goOnPatrol/bleach_delegate",
    encirclement = "Prefabs/activityModule/encirclementModule/encirclement_main",
    zhengzhan = "Prefabs/activityModule/fightingModule/fighting_main",
    worldBoss = "Prefabs/activityModule/world_boss/world_boss_main",
    newHero = "Prefabs/moduleFabs/hero/newHero",
    jingji = "Prefabs/moduleFabs/arenaModule/jingji_main",
    formation = "Prefabs/moduleFabs/formationModule/formation/formation_main" ,--阵容
    indiana_main = "Prefabs/moduleFabs/indiana/indiana_main" ,      --掠夺战
    contest_main = "Prefabs/moduleFabs/attack/attack_main",  --比武
	equip_main = "Prefabs/moduleFabs/equipModule/gui_equip_panel",
    chenghao = "Prefabs/moduleFabs/chenghaoModule/chenghaoModule",--神乐
    list_char="Prefabs/moduleFabs/hero/hero_select_char",
    fashion="Prefabs/moduleFabs/fashionDress/newFashionDress",--時裝
    bzsc_pet = "Prefabs/moduleFabs/pet/PetFight", --百战沙场_宠物
	pet_list = "Prefabs/moduleFabs/hero/pet_select_char", -- 宠物列表
	pet_lvup = "Prefabs/moduleFabs/pet/pet_main", -- 宠物升级
	pet_starup = "Prefabs/moduleFabs/pet/pet_main", -- 宠物升星
	pet_shenlian = "Prefabs/moduleFabs/pet/pet_main", -- 宠物神炼
    huodong="Prefabs/moduleFabs/activityModule/moduleActivity", -- 活动
    buyOruse= "Prefabs/moduleFabs/alertModule/GoldToSoulAndBP", --购买或使用资源
	taorenBoss = "Prefabs/activityModule/panRen_boss/gui_panren_boss_main", --逃忍boss
    renlingshilian = "Prefabs/moduleFabs/renlingModule/arrayChart_battle", --忍灵试练
    renlingzhaohuan = "Prefabs/moduleFabs/renlingModule/arrayChart_summon", --忍灵祭坛
    renlingtujian = "Prefabs/moduleFabs/renlingModule/arrayChart_one", --忍灵图鉴
    yulingzhaohuan = "Prefabs/moduleFabs/yuling/yuling_summon", --御灵祭坛
    yulingtujian = "Prefabs/moduleFabs/yuling/yuling_tujian", --御灵图鉴
    chat = "Prefabs/moduleFabs/chat/chat_dialog" --liaotian
}

--根据名字获取主预设路径
function modulePrefabs.getPrefabByName(moduleName, args)
    --local isHave = false
	if modulePrefabs[moduleName] ~= nil then 
		return modulePrefabs[moduleName]
	end 
	return nil 
    --for key, value in pairs(modulePrefabs) do
    --    if key == moduleName then
    --        --isHave = true
	--		return modulePrefabs[moduleName]
    --    end
    --end
	--return nil
    --if isHave then
    --    return modulePrefabs[moduleName]
    --else
    --    return nil
    --end
end

return modulePrefabs