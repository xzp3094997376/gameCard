local action_lists = {
    { "scene", "map_021" }, --加载场景（世界boss场景）
    { "audio", "bgm_battle03" },




    { "in", true, 114, 0, 1000, 1000, 100, false, 1.0, 5 },-- {入场, true攻false守, 角色id, 位置, 当前血量, 最大血量, 怒气值, 是否boss（true为boss）, 缩放比例（1。0是正常大小）, 名字的颜色 }
    { "in", true, 163, 1, 1000, 1000, 100, false, 1.0, 5 },
    { "in", true, 107, 2, 1000, 1000, 100, false, 1.0, 5 },
	{ "in", true, -1, 4, 1000, 1000, 100, false, 1.0, 3 },
   

    { "in", false, 191, 0, 1000, 1000, 100, false,  1.0, 4},
    { "in", false, 195, 2, 1000, 1000, 100, false,  1.0, 4},
    { "in", false, 92, 3, 1000, 1000, 100, false,  1.0, 4},
	{ "in", false, 99, 4, 1000, 1000, 100, false,  1.0, 4},
	{ "in", false, 85, 5, 1000, 1000, 100, false,  1.0, 4},
    { "enter" }, --进入场景
    
        { "talk", 1, TextMap.GetValue("Text_1_253"), TextMap.GetValue("Text_1_268"), 174, ""},		
		{ "talk", 2, "player", TextMap.GetValue("Text_1_269"), player, ""},
		{ "talk", 1, TextMap.GetValue("Text_1_270"), TextMap.GetValue("Text_1_271"), 160, ""},
		{ "talk", 2, "player", TextMap.GetValue("Text_1_272"), player, ""},
		{ "talk", 1, TextMap.GetValue("Text_1_270"), TextMap.GetValue("Text_1_273"), 160, ""},
		{ "talk", 2, "player", TextMap.GetValue("Text_1_274"), player, ""},
		{ "talk", 1, TextMap.GetValue("Text_1_270"), TextMap.GetValue("Text_1_275"), 160, ""},
	
    { "start" },
    { "show_end" },
    { "wait", 0.5 },

    { "spell", true, 2112,  0, 0, 356, 2, 356, 3, 356, 4, 356, 5, 356 }, -- 非合体技{施法，true攻false守，技能id，施法者位置，受击者1位置，受击者1伤害（根据需要可填多组）}
    { "spell", false, 2191,  0, 0, 356, 1, 356, 2, 356, 4, 356 },
    { "spell", false, 4023,  4, 5, 0, 289, 1, 245, 2, 494 }, 
	{ "spell", true, 2105,  2, 0, 222, 2, 300 }, 
	{ "spell", true, 2293,  4, 0, 199, 2, 134 }, 
	{ "spell", false, 4041,  0, 2, 0, 215, 1, 266, 2, 100, 4, 321}, 
    { "spell", true, 4027,  0, 2, 0, 1263, 2, 1263, 3, 1365, 4, 1695, 5, 1359 }, 
       
    { "wait", 0.5 },
		{ "talk", 1, TextMap.GetValue("Text_1_270"), TextMap.GetValue("Text_1_276"), 160, ""},
		{ "talk", 2, "player", TextMap.GetValue("Text_1_277"), player, ""},
		{ "talk", 1, TextMap.GetValue("Text_1_270"), TextMap.GetValue("Text_1_278"), 160, ""},
        { "talk", 1, TextMap.GetValue("Text_1_270"), TextMap.GetValue("Text_1_279"), 160, ""},
	
	
    { "win", false },
    
}

return action_lists;