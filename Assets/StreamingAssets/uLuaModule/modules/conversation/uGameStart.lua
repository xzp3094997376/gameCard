local action_lists = {
    { "scene", "wuXianHuiLang_zhanDou" }, --加载场景
    { "load", 2 }, --阿散井恋次
    { "load", 24 }, --乌鲁奇奥拉
    { "load", 8 }, --井上织姬
    { "load", 25 }, --茶渡泰虎
    { "load", 19 }, --黑崎一护
    { "load_asset", "role", "wulu_s" },
    { "load_asset", "effect", "sc_01-335_chentu" },
    { "load_asset", "effect", "sc_06_a_53_chentu" },
    { "load_asset", "effect", "sc_06_new_b_40_chentu" },
    { "load_asset", "effect", "sc_08_new_76" },
    { "load_asset", "effect", "sc_09_new_95" },
    { "load_asset", "effect", "heiqiyihu_b_s_5" },
    { "load_asset", "effect", "heiqiyihu_t_s_9_atk" },
    { "load_asset", "effect", "wuluqiaola_t_leitingzhiqiang_xuqi04" },
    { "load_asset", "effect", "wuluqiaola_weapon" },
    { "load_asset", "effect", "heiqiyihu_t_xuqi" },
    { "load_asset", "effect", "cj_04" },
    { "load_asset", "effect", "sc_04_chentu" },
    { "load_asset", "role", "suishi" },
    { "audio", "bgm_battle04" },
    { "enter" }, --进入场景
    { "modify_blood", false },
    { "init_pos", -36, -4, 0 },
    { "init_rot", 0, 270, 0 },

    { "in", true, 19, 1, 99999, 99999, 100 },
    { "in", true, 2, 3, 9999, 9999, 100 },
    { "in", true, 8, 4, 9999, 9999, 100 },
    { "in", true, 25, 5, 9999, 9999, 100 },

    { "wait", 2 },
    { "show_end" },
    { "sound", "vc_cg0" },
    { "team_move", 5.7, 0, 0 },
    { "sound", "vc_cg1" },
    { "effect", "sc_01-335_chentu", 15 },
    { "sudden_in_str", false, "wulu_s", 5, 99999, 99999, 100 },
    { "camerafollow", false, 5, 2 },
    { "say", TextMap.GetValue("Text804"), TextMap.GetValue("Text805"), 4 },
    { "camerafollow", false, 5, 6 },
    { "say", TextMap.GetValue("Text804"), TextMap.GetValue("Text806"), 2 },
    { "camerafollow", false, 5, 3.167 },

    { "remove_char", false, 5 },
    { "sudden_in", false, 24, 4, 99999, 99999, 100 },
    { "flash", 0.5, 5 },
    { "modify_blood", true },
    { "spell", true, 1, 2, 4, 12196 },
    { "spell", false, 4, 2, 1, 23588 },

    { "spell", true, 3, 1, 4, 25196 },
    { "spell", false, 4, 3 },
    { "modify_blood", false },
    { "spell", false, 4, 4, 1, 47567, 3, 58867, 4, 68523, 5, 45623 },

    { "modify_blood", false },
    { "remove_char", true, 1 },
    { "sudden_in", true, 19, 1, 99999, 99999, 100 },
    { "set_position", true, 1, 0, 0, 0 },
    { "set_rotate", true, 1, 0, 270, 0 },

    { "modify_blood", false },
    { "remove_char", true, 3 },
    { "remove_char", true, 4 },
    { "remove_char", true, 5 },
    { "sudden_in", true, 2, 3, 99999, 0, 100 },
    { "sudden_in", true, 8, 4, 99999, 0, 100 },
    { "sudden_in", true, 25, 5, 99999, 0, 100 },
    { "set_rotate", true, 3, 0, 90, 0 },
    { "set_rotate", true, 4, 0, 90, 0 },
    { "set_rotate", true, 5, 0, 90, 0 },
    { "set_position", true, 3, -8.299368, 0, 2.205383 },
    { "set_position", true, 4, -8.712698, 0, 0.529223 },
    { "set_position", true, 5, -9.049947, 0, -1.038036 },
    { "sound", "vc_cg2" },
    { "animate", true, 3, "s_4" },
    { "animate", true, 4, "s_4" },
    { "animate", true, 5, "s_4" },
    { "animate", true, 1, "s_2" },
    { "say", TextMap.GetValue("Text807"), TextMap.GetValue("Text808"), 2 },
    { "camerafollow", true, 1, 3.667 },

    { "set_position", false, 4, 0, 0, 0 },
    { "set_rotate", false, 4, 0, 270, 0 },
    { "animate", false, 4, "s_3" },

    { "say", TextMap.GetValue("Text804"), TextMap.GetValue("Text809"), 5.367 },

    { "camerafollow", false, 4, 4.200 },
    { "effect", "wuluqiaola_t_leitingzhiqiang_xuqi", 5, "scene", 1.5, 3.5, 0, 0, 0, 0 },

    { "hero_effect", false, 4, "wuluqiaola_t_leitingzhiqiang_xuqi04", 5, "Bip01 Prop1" },
    { "camerafollow", false, 4, 2.400 },
    { "say", TextMap.GetValue("Text804"), TextMap.GetValue("Text810"), 2 },

    { "camerafollow", false, 4, 1.9 },
    { "flash", 1, 8, 0 },
    { "effect", "sc_04_chentu", 5, "", 0, 0, 0, 0, 270, 0 },
    { "camerafollow", false, 4, 0.3 },
    { "sudden_in", true, 19, 0, 99999, 99999, 100 },
    -- { "effect", "cj_04", 5, "", 0, 0, 0, 0, 270, 0 },
    { "set_position", true, 0, 0, 0, 0 },
    { "set_rotate", true, 0, 0, 270, 0 },
    { "set_position", false, 4, 6, 5, 0 }, --拉后一点乌鲁奇
    { "animate", true, 0, "s_4" },
    { "remove_char", true, 1 },

    { "camerafollow", true, 0, 2 },
    { "say", TextMap.GetValue("Text589"), TextMap.GetValue("Text811"), 3 },
    { "camerafollow", true, 0, 3.167 },


    { "set_position", false, 4, 0, 0, 0 },
    { "animate", true, 0, "s_5" },
    { "animate", false, 4, "s_5" },
    { "hero_effect", false, 4, "wuluqiaola_weapon", 5, "Bip01 Prop1" },
    { "effect", "heiqiyihu_b_s_5", 5, "scene", 7.5, 0, 7.5, 0, 0, 0 },
    { "camerafollow", true, 0, 2 },
    { "remove_char", true, 0 },
    { "sudden_in", true, 19, 0, 99999, 99999, 100 },
    { "set_rotate", true, 0, 0, 270, 0 },
    { "set_position", true, 0, 0.1708389, 0, 0.5316799 },

    { "hide_object", "Box141" },
    { "hide_object", "Box142" },

    { "sudden_in_str", false, "suishi", 5, 99999, 99999, 100 },
    { "animate", false, 5, "s_6" },

    { "set_rotate", false, 5, 0, 270, 0 },
    { "animate", true, 0, "s_6" },
    { "effect", "sc_06_a_53_chentu", 5, "scene", 0, 0, 0, 0, 270, 0 },
    { "camerafollow", true, 0, 1.767 },

    { "set_position", true, 0, 0, 0, 0 },
    { "set_rotate", true, 0, 0, 270, 0 },
    { "animate", true, 0, "s_6b" },
    { "animate", false, 5, "s_6b" },
    { "effect", "sc_06_new_b_40_chentu", 5, "scene", 0, 0, 0, 0, 270, 0 },
    { "camerafollow", true, 0, 1.333 },

    { "animate", false, 4, "s_7" },
    { "say", TextMap.GetValue("Text804"), TextMap.GetValue("Text812"), 2 },
    { "camerafollow", false, 4, 2.0 },

    { "set_position", true, 0, 0, 0, 0 },
    { "set_rotate", true, 0, 0, 270, 0 },


    { "animate", true, 0, "s_8" },
    { "camerafollow", true, 0, 1.5 },
    { "say", TextMap.GetValue("Text589"), TextMap.GetValue("Text813"), 2.5 },

    { "camerafollow", true, 0, 0.5 },
    { "remove_char", false, 5 },
    { "show_line", 3.667, -31.23608, -4.6, 4.95843 },
    { "effect", "xuqi_red", 3, "", -31.23608, -4.6, 4.95843, 0, 90, 0 },
    { "camerafollow", true, 0, 0.5 },
    { "change_model", true, 0, "heiqiyihu_t" },
    { "animate", true, 0, "s_9" },
    { "effect", "sc_09_new_95", 3, "", 0, 0, 0, 0, -90, 0 },
    { "camerafollow", true, 0, 1.0 },
    { "effect", "heiqiyihu_t_s_9_atk", 7.5, "MainCamera" },
    { "camerafollow", true, 0, 0.5 },
    { "camerafollow", true, 0, 1.667 },
    { "hide_object", "wuXianHuiLang_zhanDou" },
    { "remove_char", true, 3 },
    { "remove_char", true, 1 },
    { "remove_char", true, 0 },
    { "remove_char", false, 4 },

    { "wait", 2 },
    { "end" }
}

return action_lists;