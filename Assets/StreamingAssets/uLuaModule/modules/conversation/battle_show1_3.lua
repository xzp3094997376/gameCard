local action_lists = {
    { "scene", "map_021" }, --加载场景（世界boss场景）
    { "audio", "bgm_battle03" },




    { "in", false, 279, 0, 1000, 1000, 100, false, 1.0, 1 },-- {入场, true攻false守, 角色id, 位置, 当前血量, 最大血量, 怒气值, 是否boss（true为boss）, 缩放比例（1。0是正常大小）, 名字的颜色 }
    { "in", false, 279, 1, 1000, 1000, 100, false, 1.0, 1 },
    { "in", false, 279, 2, 1000, 1000, 100, false, 1.0, 1 },
   

    { "in", true, -1, 0, 1000, 1000, 100, false,  1.0, 3},
    { "in", true, 23, 1, 1000, 1000, 100, false,  1.0, 4},
    { "in", true, 30, 2, 1000, 1000, 100, false,  1.0, 4},
    { "enter" }, --进入场景
    
        { "talk", 2, "", TextMap.GetValue("LocalKey_852"), "-1", ""},		
		{ "talk", 2, TextMap.GetValue("Text_1_236"), TextMap.GetValue("Text_1_280"), 30, ""},
		{ "talk", 1, TextMap.GetValue("Text_1_233"), TextMap.GetValue("Text_1_281"), 23, ""},
		{ "talk", 2, TextMap.GetValue("Text_1_236"), TextMap.GetValue("Text_1_282"), 30, ""},
		{ "talk", 2, "player", TextMap.GetValue("Text_1_283"), player, ""},
		{ "talk", 2, TextMap.GetValue("Text_1_233"), TextMap.GetValue("Text_1_284"), 23, ""},
		
	
    { "start" },
    { "show_end" },
    { "wait", 0.5 },

    { "spell", true, 1251,  0, 0, 356 }, -- 非合体技{施法，true攻false守，技能id，施法者位置，受击者1位置，受击者1伤害（根据需要可填多组）}
    { "spell", true, 1023,  1, 1, 356 },
    { "spell", true, 2023,  1, 0, 289, 1, 245, 2, 226 }, 
	{ "spell", false, 1279,  0, 0, 300 }, 
	{ "spell", false, 1279,  1, 2, 311 }, 
	{ "spell", false, 1279,  2, 1, 322 }, 

       
    { "wait", 0.5 },
		{ "talk", 1, TextMap.GetValue("Text_1_236"), TextMap.GetValue("Text_1_285"), 30, ""},
		{ "talk", 1, TextMap.GetValue("Text_1_233"), TextMap.GetValue("Text_1_286"), 23, ""},
		{ "talk", 1, TextMap.GetValue("Text_1_236"), TextMap.GetValue("Text_1_287"), 30, ""},
    { "wait", 0.5 },
    { "spell", true, 4009,  1, 2, 0, 789, 1, 756, 2, 798, },---合击柳生+云雀
	{ "wait", 0.5 },
	
		{ "talk", 2, TextMap.GetValue("Text_1_236"), TextMap.GetValue("Text_1_288"), 30, ""},
		{ "talk", 1, "player", TextMap.GetValue("Text_1_289"), player, ""},
		{ "talk", 2, TextMap.GetValue("Text_1_236"), TextMap.GetValue("Text_1_290"), 30, ""},
		{ "talk", 2, TextMap.GetValue("Text_1_236"), TextMap.GetValue("Text_1_291"), 30, ""},
		{ "talk", 1, "player", TextMap.GetValue("Text_1_292"), player, ""},
	
	
    { "win", false },
    
}

return action_lists;