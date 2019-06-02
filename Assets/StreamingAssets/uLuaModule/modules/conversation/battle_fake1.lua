local action_lists = {
    { "scene", "map_034" }, --加载场景（世界boss场景）
    { "audio", "xinshou_fight_bg" },



    { "in", true, 35, 0, 99999, 99999, 100, false, 1.0, 5 },-- {入场, true攻false守, 角色id, 位置, 当前血量, 最大血量, 怒气值, 是否boss（true为boss）, 缩放比例（1。0是正常大小）, 名字的颜色 }
    { "in", true, 5, 1, 99999, 99999, 100, false, 1.0, 6 },
    { "in", true, 27, 2, 99999, 99999, 100, false, 1.0, 5 },
    { "in", true, 195, 3, 99999, 99999, 100, false, 1.0, 5 },
    { "in", true, 112, 4, 99999, 99999, 100, false, 1.0, 6 },
    { "in", true, 191, 5, 99999, 99999, 100, false, 1.0, 6 },

    { "in", false, 271, 0, 50000, 50000, 100, false,  1.0, 4},
    { "in", false, 273, 1, 50000, 50000, 100, false,  1.0, 4},
    { "in", false, 276, 2, 50000, 50000, 100, false,  1.0, 4},
    { "in", false, 290, 4, 320000, 320000, 100, true,  2.2, 6},

    
    { "enter" }, --进入场景
      
 		{ "talk", 1, "...", TextMap.GetValue("Text_1_226"), "-1", "balck"}, 
    { "sound", "jianjie_feiniao"}, 
		{ "talk", 2, TextMap.GetValue("Text_1_227"), TextMap.GetValue("Text_1_228"), 5, ""},
		{ "talk", 1, TextMap.GetValue("Text_1_229"), TextMap.GetValue("Text_1_230"), 191, ""},
		{ "talk", 2, TextMap.GetValue("Text_1_231"), TextMap.GetValue("Text_1_232"), 112, ""},
		{ "talk", 1, TextMap.GetValue("Text_1_233"), TextMap.GetValue("Text_1_234"), 27, ""},

    
    { "start" },
    { "show_end" },

    
    { "wait", 0.5 },
		{ "talk", 1, TextMap.GetValue("Text_1_233"), TextMap.GetValue("Text_1_235"), 27, ""},
		{ "talk", 2, TextMap.GetValue("Text_1_236"), TextMap.GetValue("Text_1_237"), 35, ""},
    { "wait", 0.5 },	
    { "spell", true, 4009,  2, 0, 0, 50000, 1, 50000, 2, 50000, 4, 50000 },

    { "wait", 0.5 },

		{ "talk", 2, TextMap.GetValue("Text_1_238"), TextMap.GetValue("Text_1_239"), 195, ""},
		{ "talk", 1, TextMap.GetValue("Text_1_229"), TextMap.GetValue("Text_1_240"), 191, ""},
    { "wait", 0.2 },
    { "sound", "vc_boss_in"},    
--    { "remove_char", false, 1 }, 
--    { "in", false, 290, 1, 99999, 99999, 100, true,  3.2, 6},     --boss狂暴（血量回满，怒气回满 攻击上升）

	  { "spell", false, 2290,  4, 0, 22222, 1, 22222, 2, 89999,  3, 22222,  4, 22222,  5, 89999 },

    { "wait", 0.5 },
		{ "talk", 1, TextMap.GetValue("Text_1_231"), TextMap.GetValue("Text_1_241"), 112, ""},
		{ "talk", 2, TextMap.GetValue("Text_1_238"), TextMap.GetValue("Text_1_242"), 195, ""},
		{ "talk", 1, TextMap.GetValue("Text_1_229"), TextMap.GetValue("Text_1_243"), 191, ""},
    { "wait", 0.5 },    
    { "spell", true, 4016, 3, 5, 4, 399999 },     
    { "wait", 1 }, 
    --{ "remove_char", true, 5 }, 
    { "wait", 0.5 },     
		{ "talk", 1, TextMap.GetValue("Text_1_238"), TextMap.GetValue("Text_1_244"), 195, ""},    
    { "wait", 1.0 }, 

    { "end" },
    
}

return action_lists;