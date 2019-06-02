--
-- Created by IntelliJ IDEA.
-- User: xiyou
-- Date: 2014/11/17
-- Time: 15:36
-- To change this template use File | Settings | File Templates.
-- 新手步骤

--{"预设名",延迟加载,重置事件,事件名,事件参数}
local guide = {
    --从主页开始选关
    [1] = {
        { "step_select_section", say = TextMap.GetValue("Text969"), pos = "left" },
        { "step_select_chapter_one", 0, -1, say = TextMap.GetValue("Text966"), pos = "top" },
        { "step_btn_fight", say = TextMap.GetValue("Text970"), pos = "left", api = true }
    },
    --战斗返回主场景
    [2] = {
        { "step_battle_back", 0.8, say = TextMap.GetValue("Text971"), pos = "leftBottom" },
        { "step_btn_back", 0.3, say = TextMap.GetValue("Text971"), pos = "leftBottom" },
    },
    step_battle_back = {
        { "step_battle_back", 3.5, say = TextMap.GetValue("Text971"), pos = "leftBottom" }
    },
    step_battle_back_fast = {
        { "step_battle_back", 0.8, say = TextMap.GetValue("Text971"), pos = "leftBottom" }
    },
    --钻石单抽
    [3] = {
        { "step_select_draw", say = TextMap.GetValue("Text972"), pos = "left" },
        { "step_gold_draw_one", 0.1, 1, "draw", 8, say = TextMap.GetValue("Text973"), pos = "top", api = true },
        { "step_btn_close_draw_char", 0.5, say = TextMap.GetValue("Text971"), pos = "top" },
        --        { "step_btn_close_draw" },
        { "step_btn_back", 0.1, say = TextMap.GetValue("Text971"), pos = "leftBottom" }
    },

    --金币单抽
    [11] = {
        { "step_select_draw", say = TextMap.GetValue("Text972"), pos = "left" },
        { "step_money_draw_one", 0.1, 1, "draw", 10, say = TextMap.GetValue("Text973"), pos = "right", api = true },
        { "step_btn_close_draw_char", 0.5, say = TextMap.GetValue("Text971"), pos = "top" },
        --        { "step_btn_close_draw" },
        { "step_btn_back", 0.1, say = TextMap.GetValue("Text971"), pos = "leftBottom" }
    },
    --布阵.阵们2
    [4] = {
        { "step_btn_formation", say = TextMap.GetValue("Text1022"), pos = "top" },
        -- { "step_btn_formation_change", say = TextMap.GetValue("Text1022"), pos = "rightTop" },
        { "step_select_formation_two", say = TextMap.GetValue("Text975"), pos = "right" },
        { "step_select_formation_char_one", 0.2, say = TextMap.GetValue("Text1023"), pos = "right", api = true }
        -- { "step_save_formation", say = TextMap.GetValue("Text1025"), pos = "top", api = true },
    },
    --布阵 阵门3
    [5] = {
        { "step_btn_formation", say = TextMap.GetValue("Text1022"), pos = "left" },
        -- { "step_btn_formation_change", say = TextMap.GetValue("Text1022"), pos = "rightTop" },
        { "step_select_formation_three", say = TextMap.GetValue("Text993"), pos = "right" },
        { "step_select_formation_char_one", 0.2, say = TextMap.GetValue("Text1024"), pos = "right", api = true, api = true }
        -- { "step_save_formation", say = TextMap.GetValue("Text1025"), pos = "top", api = true },
    },
    step_level_up = {
        { "step_level_up", say = TextMap.GetValue("Text1025"), pos = "left" }
    },
    [9] = {
        { "step_level_up", say = TextMap.GetValue("Text1025"), pos = "left" }
    },
    [100] = {
        { "step_select_zore_one", 0.3, say = TextMap.GetValue("Text966"), pos = "top" }
    },
    [101] = {
        { "step_next_battle", 2.5, say = TextMap.GetValue("Text967"), pos = "left" }
    },
    [102] = {
        { "step_select_zore_two", 0.3, say = TextMap.GetValue("Text968"), pos = "top" }
    },
    --角色升级
    step_char_lvl_up = {
        { "step_char_lvl_up", 0, say = TextMap.GetValue("Text979"), pos = "top", api = true }
    },
    --闯关建筑
    step_select_section = {
        { "step_select_section", say = TextMap.GetValue("Text969"), pos = "left" }
    },
    --改名
    changeName = {
        { "step_btn_close_change_name", say = TextMap.GetValue("Text1025"), pos = "left" }
    },
    --任务第一个领取奖励
    step_chengjiu_one = {
        { "step_chengjiu_one", 0.2, say = TextMap.GetValue("Text995"), pos = "right" }
    },
    --英雄里面技能按钮
    step_btn_char_skill = {
        { "step_btn_char_skill", say = TextMap.GetValue("Text998"), pos = "left" }
    },
    --英雄里面技能升级第一个按钮
    step_btn_charskillup_one = {
        { "step_btn_charskillup_one", 0.8, say = TextMap.GetValue("Text979"), pos = "left", api = true }
    },
    --第一个英雄
    step_select_char_one = {
        { "step_select_char_one", 0.2, say = TextMap.GetValue("Text1026"), pos = "top" }
    },
    --第二个英雄
    step_select_char_two = {
        { "step_select_char_two", 0.2, say = TextMap.GetValue("Text1023"), pos = "top" }
    },
    --英雄
    step_btn_select_char = {
        { "step_btn_select_char", say = TextMap.GetValue("Text1020"), pos = "top" }
    },

    --成就
    step_btn_select_cengju = {
        { "step_btn_select_cengju", say = TextMap.GetValue("Text1027"), pos = "left" } --4001
    },
    --主界面每一个item的领取按钮
    step_grow_reward = {
        { "step_grow_reward", 0.2, say = TextMap.GetValue("Text996"), pos = "bottom" }
    },
    --奖励弹出框的奖励按钮
    step_grow_liebiao_reward = {
        { "step_grow_liebiao_reward", say = TextMap.GetValue("Text996"), pos = "left", api = true }
    },
    step_btn_select_task = {
        { "step_btn_select_task", say = TextMap.GetValue("Text994"), pos = "left" }
    },

    --第一章的第二小节到第6小节
    step_select_chapterOne_section2 = {
        { "step_select_chapterOne_section2", 0, -1, say = TextMap.GetValue("Text968"), pos = "top" }
    },
    step_select_chapterOne_section3 = {
        { "step_select_chapterOne_section3", 0, -1, say = TextMap.GetValue("Text983"), pos = "top" }
    },
    step_select_chapterOne_section4 = {
        { "step_select_chapterOne_section4", 0, -1, say = TextMap.GetValue("Text984"), pos = "top" }
    },
    step_select_chapterOne_section5 = {
        { "step_select_chapterOne_section5", 0, -1, say = TextMap.GetValue("Text990"), pos = "top" }
    },
    step_select_chapterOne_section6 = {
        { "step_select_chapterOne_section6", 0, -1, say = TextMap.GetValue("Text991"), pos = "top" }
    },
    --第二章第一节
    step_select_chapterTwo_section1 = {
        { "step_select_chapterTwo_section1", 0, -1, 0.5, say = TextMap.GetValue("Text966"), pos = "top" }
    },
    --闯关挑战
    step_chapter_challege = {
        { "step_chapter_challege", say = TextMap.GetValue("Text970"), pos = "left", api = true }
    },


    --战斗结束下一关
    step_next_battle = {
        { "step_next_battle", 3, say = TextMap.GetValue("Text967"), pos = "left" }
    },
    --日常
    step_btn_select_richang = {
        { "step_btn_select_richang", say = TextMap.GetValue("Text1008"), pos = "left" }
    },
    --闯关
    step_btn_select_section = {
        { "step_btn_select_section", say = TextMap.GetValue("Text969"), pos = "left" }
    },
    --返回
    step_btn_back = {
        { "step_btn_back", 0.1, say = TextMap.GetValue("Text971"), pos = "leftBottom" }
    },
    --装备tab
    step_char_equip = {
        { "step_char_equip", say = TextMap.GetValue("Text981"), pos = "top" }
    },
    step_char_equip_1 = {
        { "step_char_equip_1", 0.2, say = TextMap.GetValue("Text980"), pos = "left" }
    },
    step_char_equip_2 = {
        { "step_char_equip_2", 0.2, say = TextMap.GetValue("Text982"), pos = "left" }
    },
    step_char_equip_3 = {
        { "step_char_equip_3", 0.2, say = TextMap.GetValue("Text985"), pos = "left" }
    },
    step_char_equip_4 = {
        { "step_char_equip_4", 0.2, say = TextMap.GetValue("Text986"), pos = "left" }
    },
    step_char_equip_5 = {
        { "step_char_equip_5", 0.2, say = TextMap.GetValue("Text987"), pos = "left" }
    },
    --装备6
    step_char_equip_6 = {
        { "step_char_equip_6", 0.2, say = TextMap.GetValue("Text988"), pos = "left" }
    },
    --装备
    step_char_equipOn = {
        { "step_char_equipOn", 0, say = TextMap.GetValue("Text981"), pos = "top", api = true }
    },
    --关闭装备
    step_char_equip_close = {
        { "step_char_equip_close", say = TextMap.GetValue("Text1028"), pos = "left" }
    },
    --突破
    step_btn_power_up = {
        { "step_btn_power_up", say = TextMap.GetValue("Text989"), pos = "top", api = true }
    },
    --确定突破
    step_btn_sure_power_up = {
        { "step_btn_sure_power_up", say = TextMap.GetValue("Text1025"), pos = "left" }
    },

    --洗练tab
    step_char_xilian = {
        { "step_char_xilian", say = TextMap.GetValue("Text1001"), pos = "rightTop" }
    },
    --洗练
    step_btn_xilian = {
        { "step_btn_xilian", 0.8, 1, "xiLianGuide", say = TextMap.GetValue("Text1001"), pos = "left" },
        { "step_btn_xilian_save", 0.1, say = TextMap.GetValue("Text1029"), pos = "left", api = true }
    },
    --洗练替换
    step_btn_xilian_save = {
        { "step_btn_xilian_save", 0.1, say = TextMap.GetValue("Text1029"), pos = "left", api = true }
    },
    --灵络
    step_btn_change = {
        { "step_btn_change", say = TextMap.GetValue("Text1000"), pos = "rightTop" }
    },
    --修炼
    step_char_change = {
        { "step_char_change", 0.8, say = TextMap.GetValue("Text1030"), pos = "left" }
    },
    --灵络1
    step_btn_select_lingLuo_one = {
        { "step_btn_select_lingLuo_one", say = TextMap.GetValue("Text1031"), pos = "left" }
    },
    --灵络修炼
    step_btn_clickLingLuo = {
        { "step_btn_clickLingLuo", say = TextMap.GetValue("Text1032"), pos = "top", api = true }
    },

    --小助手
    step_btn_help = {
        { "step_btn_help", say = TextMap.GetValue("Text1033"), pos = "left" }
    },
    --签到
    step_btn_qian_dao = {
        { "step_btn_qian_dao", say = TextMap.GetValue("Text1034"), pos = "right" }
    },
    --签到1
    step_btn_qian_dao_1 = {
        { "step_btn_qian_dao_1", 0.2, say = TextMap.GetValue("Text1035"), pos = "top", api = true }
    },
    --领取签到
    step_btn_qian_dao_2 = {
        { "step_btn_qian_dao_2", 0.2, say = TextMap.GetValue("Text996"), pos = "left" }
    },
    --关闭签到
    step_btn_qian_dao_close = {
        { "step_btn_qian_dao_close", say = TextMap.GetValue("Text1028"), pos = "leftBottom" }
    },

    --对决
    step_select_dui_jue = {
        { "step_select_dui_jue", say = TextMap.GetValue("Text1002"), pos = "bottom" }
    },
    --竞技
    step_select_jjc = {
        { "step_select_jjc", say = TextMap.GetValue("Text1010"), pos = "left" }
    },
    --试练
    step_select_shi_lian = {
        { "step_select_shi_lian", say = TextMap.GetValue("Text1036"), pos = "left" }
    },
    --悬赏
    step_select_xian_shan = {
        { "step_select_xian_shan", say = TextMap.GetValue("Text1012"), pos = "left" }
    },
    --远征
    step_select_yuan_zhen = {
        { "step_select_yuan_zhen", say = TextMap.GetValue("Text1037"), pos = "left" }
    },
    --排行
    step_select_rank = {
        { "step_select_rank", say = TextMap.GetValue("Text1038"), pos = "left" }
    },
    --强化
    step_select_qian_hua = {
        { "step_select_qian_hua", say = TextMap.GetValue("Text1007"), pos = "left" }
    },
    --黑店
    step_select_shop = {
        { "step_select_shop", say = TextMap.GetValue("Text1015"), pos = "left" }
    },
    --轮回
    step_shop_lunhui = {
        { "step_shop_lunhui", say = TextMap.GetValue("Text1016"), pos = "right" }
    },
    --重生
    step_shop_lunhui_relive = {
        { "step_shop_lunhui_relive", say = TextMap.GetValue("Text1017"), pos = "right" }
    },

    --灵王塔
    step_select_tower = {
        { "step_select_tower", say = TextMap.GetValue("Text1009"), pos = "left" }
    },
    step_chapterElite_one = {
        { "step_chapterElite_one", 0.3, say = TextMap.GetValue("Text1003"), pos = "right" }
    },

    --领取通关宝箱
    step_click_section_box = {
        { "step_click_section_box", say = TextMap.GetValue("Text992"), pos = "left" }
    },
    step_click_section_box_reward = {
        { "step_click_section_box_reward", say = TextMap.GetValue("Text996"), pos = "left", api = true }
    },
    step_click_section_box_close = {
        { "step_click_section_box_close", say = TextMap.GetValue("Text1028"), pos = "left" }
    },
    --鬼道
    step_btn_char_ghost = {
        { "step_btn_char_ghost", say = TextMap.GetValue("Text1004"), pos = "rightTop" }
    },
    --闯关,困难
    step_click_section_hard = {
        { "step_click_section_hard", say = TextMap.GetValue("Text1039"), pos = "left" }
    },
    step_huilian = {
        { "guidao/step_huilian", say = TextMap.GetValue("Text1005"), pos = "top" }
    },
    step_hunlian_huidao_hunlian = {
        { "guidao/step_hunlian_huidao_hunlian", say = TextMap.GetValue("Text1005"), pos = "left" }
    },
    step_btn_guidao_select_huidao = {
        { "guidao/step_btn_guidao_select_huidao", say = "", pos = "left" }
    },
    step_btn_guidao_click_strong = {
        { "guidao/step_btn_guidao_click_strong", say = TextMap.GetValue("Text1007"), pos = "left" }
    },
    step_btn_change_skill = {
        { "step_btn_change_skill", say = TextMap.GetValue("Text1040"), pos = "left" }
    },
    step_select_jin_hua = {
        { "step_select_jin_hua", say = TextMap.GetValue("Text1019"), pos = "top" }
    },
    step_btn_jin_hua = {
        { "step_btn_jin_hua", say = TextMap.GetValue("Text1019"), pos = "top" }
    },
    step_btn_formation = {
        { "step_btn_formation", sys = TextMap.GetValue("Text1022") }
    },
    step_btn_formation_change = {
        { "step_btn_formation_change", sys = TextMap.GetValue("Text1004") }
    },
    step_btn_guidao_click_huidao = {
        { "guidao/step_btn_guidao_click_huidao", sys = TextMap.GetValue("Text1006") }
    },
    step_task_one = {
        { "step_task_one", 0.1, sys = TextMap.GetValue("Text996"), pos = "left" }
    },
    step_task_one_go = {
        { "step_task_one", 0.5, sys = TextMap.GetValue("Text997"), pos = "left" }
    }
}

return guide