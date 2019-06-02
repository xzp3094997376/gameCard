local action_lists = {
    { "scene", "map_021" }, --加载场景（世界boss场景）
    { "audio", "bgm_battle03" },




    { "in", true, 178, 0, 1000, 1000, 100, false, 1.0, 4 },-- {入场, true攻false守, 角色id, 位置, 当前血量, 最大血量, 怒气值, 是否boss（true为boss）, 缩放比例（1。0是正常大小）, 名字的颜色 }
    { "in", true, 185, 1, 1000, 1000, 100, false, 1.0, 4 },
    { "in", true, 170, 2, 1000, 1000, 100, false, 1.0, 4 },
	{ "in", true, -1, 4, 1000, 1000, 100, false, 1.0, 3 },
   

    { "in", false, 265, 0, 1000, 1000, 100, false,  1.0, 3},
    { "in", false, 266, 1, 1000, 1000, 100, false,  1.0, 4},
    { "in", false, 267, 2, 1000, 1000, 100, false,  1.0, 4},
    { "enter" }, --进入场景
    
        { "talk", 2, "player", TextMap.GetValue("Text_1_245"), player, ""},		
		{ "talk", 1, TextMap.GetValue("Text_1_246"), TextMap.GetValue("Text_1_247"), 167, ""},
		{ "talk", 2, TextMap.GetValue("Text_1_248"), TextMap.GetValue("Text_1_249"), 198, ""},
		{ "talk", 1, TextMap.GetValue("Text_1_250"), TextMap.GetValue("Text_1_251"), 181, ""},
		{ "talk", 2, TextMap.GetValue("Text_1_248"), TextMap.GetValue("Text_1_252"), 198, ""},
		{ "talk", 1, TextMap.GetValue("Text_1_253"), TextMap.GetValue("Text_1_254"), 174, ""},
		{ "talk", 2, "player", TextMap.GetValue("Text_1_255"), player, ""},
		{ "talk", 1, TextMap.GetValue("Text_1_250"), TextMap.GetValue("Text_1_256"), 181, ""},
		{ "talk", 2, "player", TextMap.GetValue("Text_1_257"), player, ""},
		{ "talk", 1, TextMap.GetValue("Text_1_248"), TextMap.GetValue("Text_1_258"), 198, ""},
		{ "talk", 2, "player", TextMap.GetValue("Text_1_259"), player, ""},
	    { "talk", 1, TextMap.GetValue("Text_1_246"), TextMap.GetValue("Text_1_260"), 167, ""},
	    { "talk", 2, "player", TextMap.GetValue("Text_1_261"), player, ""},
	
    { "start" },
    { "show_end" },
    { "wait", 0.5 },

    { "spell", true, 1292,  4, 0, 356 }, -- 非合体技{施法，true攻false守，技能id，施法者位置，受击者1位置，受击者1伤害（根据需要可填多组）}
    { "spell", false, 1265,  0, 4, 888 },

       
    { "wait", 0.5 },
		{ "talk", 1, TextMap.GetValue("Text_1_253"), "……", 174, ""},
		{ "talk", 2, TextMap.GetValue("Text_1_250"), TextMap.GetValue("Text_1_262"), 181, ""},
		{ "talk", 1, "player", TextMap.GetValue("Text_1_263"), player, ""},
		{ "talk", 2, TextMap.GetValue("Text_1_250"), TextMap.GetValue("Text_1_264"), 181, ""},
	    { "talk", 1, TextMap.GetValue("Text_1_253"), TextMap.GetValue("Text_1_265"), 174, ""},
    { "wait", 0.5 },
    { "spell", true, 4038, 0, 1, 0, 789, 1, 1023, 2, 1045, },---合击柳生+云雀
	{ "wait", 0.5 },
	
		{ "talk", 2, TextMap.GetValue("Text_1_250"), TextMap.GetValue("Text_1_266"), 181, ""},
		{ "talk", 1, TextMap.GetValue("Text_1_246"), TextMap.GetValue("Text_1_267"), 167, ""},
		
	
	
    { "win", false },
    
}

return action_lists;