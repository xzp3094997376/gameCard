local action_lists = {
    { "scene", "map_001" }, --加载场景（世界boss场景）
    { "audio", "bgm_battle03" },


    { "in", false, 279, 0, 1000, 1000, 100, false, 1.0, 1 },-- {入场, true攻false守, 角色id, 位置, 当前血量, 最大血量, 怒气值, 是否boss（true为boss）, 缩放比例（1。0是正常大小）, 名字的颜色 }
    { "in", false, 23, 1, 1000, 1000, 100, false, 1.0, 4 },
    { "in", false, 271, 2, 1000, 1000, 100, false, 1.0, 1 },
    { "in", false, 271, 3, 1000, 1000, 100, false, 1.0, 1 },
    { "in", false, 30, 4, 1000, 1000, 100, false, 1.0, 4 },
    { "in", false, 277, 5, 1000, 1000, 100, false, 1.0, 1 },

    { "in", true, -1, 0, 1000, 1000, 100, false,  1.0, 3},
  
 		{ "enter" }, --进入场景
		{ "talk", 2, TextMap.GetValue("Text_1_233"), TextMap.GetValue("Text_1_293"), 23, ""},
		{ "talk", 1, TextMap.GetValue("Text_1_294"), TextMap.GetValue("Text_1_295"), 12, ""},
		
		{ "in", true, 12, 1, 1000, 1000, 100, false,  1.0, 6},
		{ "in", true, 19, 2, 1000, 1000, 100, false,  1.0, 5},
    
    { "start" },
    { "show_end" },
    { "wait", 0.5 },

    { "spell", true, 1251,  0, 0, 365 }, -- 非合体技{施法，true攻false守，技能id，施法者位置，受击者1位置，受击者1伤害（根据需要可填多组）}
    { "spell", true, 2012,  1, 0, 355 },
    { "spell", true, 2019,  2, 0, 228, 1, 228, 2, 228, 3, 228, 4, 228, 5, 228 }, 
		{ "spell", false, 2023,  1, 0, 122, 1, 231, 2, 321 }, 
    { "spell", false, 4009,  1, 4, 0, 245, 1, 258, 2, 249, },---合击柳生+云雀
    { "spell", true, 2251,  0, 0, 200, 1, 200, 2, 200 },
    { "spell", true, 1027,  2, 4, 244 },
    { "spell", true, 4005,  1, 2, 0, 9999, 1, 9999, 2, 9999, 3, 9999, 4, 9999, 5, 9999 },
            
       
    { "wait", 0.5 },
		{ "talk", 1, TextMap.GetValue("Text_1_294"), TextMap.GetValue("Text_1_296"), 12, ""},
		{ "talk", 1, TextMap.GetValue("Text_1_233"), TextMap.GetValue("Text_1_297"), 23, ""},
		{ "talk", 1, "player", TextMap.GetValue("Text_1_298"), player, ""},
		{ "talk", 1, TextMap.GetValue("Text_1_233"), TextMap.GetValue("Text_1_299"), 23, ""},
		{ "talk", 1, TextMap.GetValue("Text_1_233"), TextMap.GetValue("Text_1_300"), 23, ""},
		{ "talk", 1, TextMap.GetValue("Text_1_236"), TextMap.GetValue("Text_1_301"), 30, ""},
		{ "talk", 1, "player", TextMap.GetValue("Text_1_302"), player, ""},

    { "win", false },
    
}

return action_lists;