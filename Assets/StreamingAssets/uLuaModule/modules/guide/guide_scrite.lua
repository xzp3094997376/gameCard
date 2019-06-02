--
-- Created by IntelliJ IDEA.
-- User: xiyou
-- Date: 2014/11/17
-- Time: 10:37
-- To change this template use File | Settings | File Templates.
-- 新手指导脚本
--1 = 闯关
--2 = 战斗返回主场景
--3 = 钻石单抽
--5 = 布阵
--6 = 下一关战斗
--7 = 开启任务



local group = {
    [1] = {
        { "dataEye", 1 },
        { "jump", "zeroChapter", "Prefabs/moduleFabs/zeroChapter/chapterXuModule", "", {} },
        { "guide", 100 },
        { "battleStart" }, --开始战斗，暂停。
        { "battleContinue" }, --继续战斗，等战斗结束
        { "battleEndWin" }, --战胜
        { "dataEye", 2 },
        { "guide", 101 },
        { "guide", 102 },
        { "battleStart" }, --开始战斗，暂停。
        { "battleContinue" }, --继续战斗，等战斗结束
        { "battleEndWin" }, --战胜
        { "dataEye", 3 },
        { "open_group", 2 },
        { "group", 2 },
        name = "2cg"
    },
    --改名
    [2] = {
        { "jump", "ChangeName", "Prefabs/publicPrefabs/bgBlack", "push", {} },
        { "talk", true, TextMap.GetValue("Text589"), TextMap.GetValue("Text855"), "full_heiqiyihu_b" },
        { "talk", false, TextMap.GetValue("Text714"), TextMap.GetValue("Text856"), "full_puyuanxizhu_b" },
        { "talk", false, TextMap.GetValue("Text714"), TextMap.GetValue("Text857"), "full_puyuanxizhu_b" },
        { "talk", true, TextMap.GetValue("Text589"), "??...", "full_heiqiyihu_b" },
        { "talk", false, TextMap.GetValue("Text714"), TextMap.GetValue("Text858"), "full_puyuanxizhu_b" },
        {
            "jump", "changeName", "Prefabs/moduleFabs/userinfoModule/changeName", "window", {
            onClose = function()
                UIMrg:pop()
                GuideConfig:next()
            end
        }
        },
        { "stop" },
        -- { "showNpc", "" },
        { "scene", "main_scene", 12 },
        { "dataEye", 4 },
        { "talk", false, TextMap.GetValue("Text714"), TextMap.GetValue("Text859"), "full_puyuanxizhu_b" },
        { "open_group", 3 },
        { "group", 3 },
        name = TextMap.GetValue("Text860")
    },
    --战斗1
    [3] = {
        --对话
        { "dataEye", 5 },
        { "guide", 1 }, --闯关，第一关
        { "open_group", 4 },
        { "battleStart" }, --开始战斗，暂停。
        { "battleContinue" }, --继续战斗，等战斗结束
        { "battleEndWin" }, --战胜

        { "stop" },
        { "dataEye", 6 },
        { "guide", 2 }, --回返主场景
        { "talk", false, TextMap.GetValue("Text587"), TextMap.GetValue("Text861"), "full_luqiya_b" },
        { "talk", true, TextMap.GetValue("Text589"), "......", "full_heiqiyihu_b" },
        { "talk", false, TextMap.GetValue("Text587"), TextMap.GetValue("Text862"), "full_luqiya_b" },
        { "group", 4 },
        name = TextMap.GetValue("Text863"),
        arg = { "section", 1, 1 }
    },
    --抽卡
    [4] = {
        { "guide", 3 }, --抽卡
        { "dataEye", 7 },

        { "talk", false, TextMap.GetValue("Text654"), TextMap.GetValue("Text864"), "full_chadutaihu_b" },
        { "talk", false, TextMap.GetValue("Text587"), TextMap.GetValue("Text865"), "full_luqiya_b" },
        { "group", 5 },
        name = TextMap.GetValue("Text866")
    },


    --布阵
    [5] = {
        { "guide", 4 },
        { "open_group", 6 }, --1016
        { "dataEye", 8 },
        { "guide", "step_btn_back" }, --返回
        { "group", 6 }, --闯关,第一关
        name = TextMap.GetValue("Text867")
    },
    --第二战.
    [6] = {
        { "dataEye", 9 },
        { "guide", "step_select_section" }, --1058--点击闯关建筑
        { "guide", "step_select_chapterOne_section2" }, --1059闯关第一章第二节
        { "guide", "step_chapter_challege" }, --1060  挑战
        { "open_group", 7 },
        { "battleStart" }, --开始战斗,暂停
        { "battleContinue" }, --继续战斗,等战斗结束
        { "battleEndWin" },
        { "dataEye", 10 },
        { "stop" },
        { "guide", 2 }, --回返主场景 1022
        { "talk", false, TextMap.GetValue("Text587"), TextMap.GetValue("Text868"), "full_luqiya_b" },
        { "group", 7 },
        name = TextMap.GetValue("Text869"),
        arg = { "section", 1, 2 }
    },
    [7] = {
        --1023
        { "guide", "step_btn_select_char" }, --选择角色
        { "talk", false, TextMap.GetValue("Text587"), TextMap.GetValue("Text870"), "full_luqiya_b", true },
        { "talk", false, TextMap.GetValue("Text587"), TextMap.GetValue("Text871"), "full_luqiya_b", true },
        { "guide", "step_char_lvl_up" }, --角色升级
        { "guide", "step_char_lvl_up" }, --角色升级
        { "dataEye", 11 },
        { "open_group", 8 },
        { "group", 8, 2 },
        name = TextMap.GetValue("Text872")
    },
    --装备1
    [8] = {
        { "guide", "step_btn_select_char" }, --选择角色

        { "talk", false, TextMap.GetValue("Text587"), TextMap.GetValue("Text873"), "full_luqiya_b", true },
        { "talk", false, TextMap.GetValue("Text587"), TextMap.GetValue("Text874"), "full_luqiya_b", true },
        { "guide", "step_char_equip_1" }, --角色装备1
        { "guide", "step_char_equipOn" },
        { "dataEye", 12 },
        { "open_group", 9 },
        { "group", 9, 2 },
        name = TextMap.GetValue("Text875")
    },
    --装备2
    [9] = {
        { "guide", "step_btn_select_char" }, --选择角色

        { "guide", "step_char_equip_2" }, --角色装备2
        { "guide", "step_char_equipOn" },
        { "dataEye", 13 },

        { "talk", false, TextMap.GetValue("Text587"), TextMap.GetValue("Text876"), "full_luqiya_b", true },
        { "open_group", 11 },
        { "guide", "step_btn_back" },
        { "group", 11 },
        name = TextMap.GetValue("Text877")
    },

    --第三战
    [11] = {
        { "dataEye", 14 },
        { "guide", "step_select_section" }, --1058--点击闯关建筑
        { "guide", "step_select_chapterOne_section3" }, --1059闯关第一章第二节
        { "guide", "step_chapter_challege" }, --1060  挑战
        { "open_group", 12 },
        { "battleStart" }, --开始战斗,暂停
        { "battleContinue" }, --继续战斗,等战斗结束
        { "battleEndWin" },
        { "guide", "step_next_battle" }, --next
        { "dataEye", 15 },

        { "group", 12, 3 },
        name = TextMap.GetValue("Text878"),
        arg = { "section", 1, 3 }
    },
    [12] = {
        { "guide", "step_select_section" }, --1058--点击闯关建筑
        { "guide", "step_select_chapterOne_section4" }, --1059闯关第一章第二节
        { "dataEye", 16 },
        { "guide", "step_chapter_challege" }, --1060  挑战
        { "open_group", 13 },
        { "battleStart" }, --开始战斗,暂停
        { "battleContinue" }, --继续战斗,等战斗结束
        { "battleEndWin" },
        { "stop" },
        { "dataEye", 17 },
        { "guide", 2 }, --回返主场景 1063
        { "group", 13 }, -- 成就
        name = TextMap.GetValue("Text879"),
        arg = { "section", 1, 4 }
    },
    --角色升级,装备.突破.
    [13] = {
        --1041
        { "talk", true, TextMap.GetValue("Text589"), TextMap.GetValue("Text880"), "full_heiqiyihu_b" },
        { "talk", false, TextMap.GetValue("Text587"), TextMap.GetValue("Text881"), "full_luqiya_b" },
        { "talk", false, TextMap.GetValue("Text587"), TextMap.GetValue("Text882"), "full_luqiya_b" },
        { "guide", "step_btn_select_char" }, --选择角色
        { "guide", "step_char_lvl_up" }, --角色升级
        { "guide", "step_char_lvl_up" }, --角色升级
        { "dataEye", 18 },
        { "open_group", 14 },
        { "group", 14, 2 },
        name = TextMap.GetValue("Text883")
    },
    --装备3
    [14] = {
        { "guide", "step_btn_select_char" }, --选择角色
        { "guide", "step_char_equip_3" }, --角色装备3
        { "guide", "step_char_equipOn" },
        { "dataEye", 19 },
        { "open_group", 15 },
        { "group", 15, 2 },
        name = TextMap.GetValue("Text884")
    },
    --装备4
    [15] = {
        { "guide", "step_btn_select_char" }, --选择角色
        { "guide", "step_char_equip_4" }, --角色装备4
        { "guide", "step_char_equipOn" },
        { "dataEye", 20 },
        { "open_group", 16 },
        { "group", 16, 2 },
        name = TextMap.GetValue("Text885")
    },
    --装备5
    [16] = {
        { "guide", "step_btn_select_char" }, --选择角色
        { "guide", "step_char_equip_5" }, --角色装备2
        { "guide", "step_char_equipOn" },
        { "dataEye", 21 },
        { "open_group", 17 },
        { "group", 17, 2 },
        name = TextMap.GetValue("Text886")
    },
    --装备6
    [17] = {
        { "guide", "step_btn_select_char" }, --选择角色
        { "guide", "step_char_equip_6" }, --角色装备2
        { "guide", "step_char_equipOn" },
        { "open_group", 18 },
        { "talk", false, TextMap.GetValue("Text587"), TextMap.GetValue("Text887"), "full_luqiya_b", true },
        { "dataEye", 22 },
        { "group", 18, 2 },
        name = TextMap.GetValue("Text888")
    },
    --突破
    [18] = {
        { "guide", "step_btn_select_char" }, --选择角色
        { "guide", "step_btn_power_up" },
        { "open_group", 406 },
        { "dataEye", 23 },
        { "stop" },
        { "talk", false, TextMap.GetValue("Text587"), TextMap.GetValue("Text889"), "full_luqiya_b", true },

        { "guide", "step_btn_back" },
        { "group", 406 },
        name = TextMap.GetValue("Text890")
    },

    --闯关
    [406] = {
        { "dataEye", 24 },
        { "guide", "step_select_section" }, --4017--点击闯关建筑按钮
        --        { "guide", "step_select_chapterOne_section2" }, --4018闯关第一章第二节
        { "guide", "step_select_chapterOne_section5" }, --4018闯关第一章第二节
        { "guide", "step_chapter_challege" }, --4019  挑战
        { "open_group", 412 },
        { "battleStart" }, --开始战斗,暂停
        { "battleContinue" }, --继续战斗,等战斗结束
        { "battleEndWin" },
        { "guide", "step_next_battle" },
        { "group", 412, 3 },
        name = TextMap.GetValue("Text891"),
        arg = { "section", 1, 5 }
    },

    --闯关 4037
    [412] = {
        { "guide", "step_select_section" }, --4017--点击闯关建筑按钮
        --        { "guide", "step_select_chapterOne_section2" }, --4018闯关第一章第二节
        { "guide", "step_select_chapterOne_section6" }, --4018闯关第一章第二节
        { "guide", "step_chapter_challege" }, --4019  挑战
        { "dataEye", 25 },
        { "open_group", 413 },
        { "battleStart" }, --开始战斗,暂停.
        { "battleContinue" }, --继续战斗,等战斗结束
        { "battleEndWin" }, --战胜
        --        { "guide", 9 }, --战斗结束升级 --4040
        { "stop" },
        { "dataEye", 26 },
        --3.29 加入领取通关章节奖励
        { "guide", "step_battle_back_fast" }, --4041
        { "talk", false, TextMap.GetValue("Text714"), TextMap.GetValue("Text892"), "full_puyuanxizhu_b" },
        { "guide", "step_click_section_box" },
        { "guide", "step_click_section_box_reward" },
        { "dataEye", 27 },
        --        { "guide", "step_click_section_box_close" },
        { "guide", "step_btn_back" },
        { "group", 413 },
        name = TextMap.GetValue("Text893"),
        arg = { "section", 1, 6 }
    },
    --金币单抽
    [413] = {
        { "guide", 11 },
        { "dataEye", 28 },
        { "open_group", 414 },
        { "group", 414 },
        name = TextMap.GetValue("Text894")
    },
    --布阵尚未第三个人
    [414] = {
        { "guide", 5 },
        { "dataEye", 29 },
        { "open_group", 415 },
        { "guide", "step_btn_back" }, --  4051  step_btn_back
        { "group", 415 },
        name = TextMap.GetValue("Text895")
    },
    --第二章第一节
    [415] = {
        { "talk", false, TextMap.GetValue("Text714"), TextMap.GetValue("Text896"), "full_puyuanxizhu_b" },
        { "talk", false, TextMap.GetValue("Text743"), TextMap.GetValue("Text897"), "full_sifengyuanyeyi_b" },
        { "dataEye", 30 },
        { "guide", "step_select_section" }, --4052
        { "guide", "step_select_chapterTwo_section1" }, --4053
        { "guide", "step_chapter_challege" }, --4054
        { "open_group", 416 },
        { "battleStart" }, --开始战斗,暂停.
        { "battleContinue" }, --继续战斗,等战斗结束
        { "battleEndWin" }, --战胜
        { "dataEye", 31 },
        { "guide", "step_battle_back" },
        { "guide", "step_btn_back" },
        { "dataEye", 32 },
        { "group", 416 },
        --        { "end" },
        name = TextMap.GetValue("Text898"),
        arg = { "section", 2, 1 }
    },
    --任务
    [416] = {
        { "guide", "step_btn_select_task" },
        { "guide", "step_chengjiu_one" },
        { "dataEye", 33 },
        { "open_group", 417 },
        { "talk", true, TextMap.GetValue("Text743"), TextMap.GetValue("Text899"), "full_sifengyuanyeyi_b" },
        { "guide", "step_task_one" },
        { "gotoNext" },
        { "guide", "step_task_one_go" },
        { "talk", true, TextMap.GetValue("Text743"), TextMap.GetValue("Text900"), "full_sifengyuanyeyi_b" },
        { "guide", "step_select_chapterTwo_section1" }, --4053
        { "guide", "step_chapter_challege" }, --4054
        { "end" },
        name = TextMap.GetValue("Text245"),
        arg = { "task" }
    },
    -- --签到
    -- [417] = {
    --     { "guide", "step_btn_qian_dao" },
    --     { "open_group", 418 },
    --     { "guide", "step_btn_qian_dao_1" },
    --     {  "dataEye",32 },
    --     { "guide", "step_btn_qian_dao_2" },
    --     { "guide", "step_btn_qian_dao_close" },
    --     { "group", 418 },
    --     name = "签到"
    -- },

    -- --小助手
    -- [418] = {
    --     { "talk",true,TextMap.GetValue("Text743"),"我只能帮你到这了,前面的路途还很凶险.以后如果你有什么想知道的,可以到[帮助]里面看看,会有你要的答案的.","full_sifengyuanyeyi_b"},
    --     { "guide", "step_btn_help" },
    --     {  "dataEye",33 },
    --     { "end" },
    --     name = "小助手"
    -- },

    ------------------------------------------------- 触发式引导-----------------------------------------------------------
    ----------------------------------------- 解锁新功能引导--------------------------------------------------------------

    -- 技能解锁 6级
    [600] = {
        { "stop" },
        { "talk", true, TextMap.GetValue("Text589"), TextMap.GetValue("Text901"), "full_heiqiyihu_b" },
        { "talk", true, TextMap.GetValue("Text743"), TextMap.GetValue("Text902"), "full_sifengyuanyeyi_b" },
        { "guide", "step_btn_char_skill" },
        { "talk", true, TextMap.GetValue("Text743"), TextMap.GetValue("Text903"), "full_sifengyuanyeyi_b" },
        { "talk", true, TextMap.GetValue("Text743"), TextMap.GetValue("Text904"), "full_sifengyuanyeyi_b" },
        --{ "guide", "step_btn_charskillup_one" },
        { "open_group", 601 },
        { "end" },
        dont_check = true,
        name = TextMap.GetValue("Text905")
    },

    --解锁灵络32级
    [700] = {
        { "stop" },
        { "talk", true, TextMap.GetValue("Text743"), TextMap.GetValue("Text906"), "full_sifengyuanyeyi_b" },
        { "talk", true, TextMap.GetValue("Text743"), TextMap.GetValue("Text907"), "full_sifengyuanyeyi_b" },
        { "guide", "step_btn_change" },
        { "talk", true, TextMap.GetValue("Text743"), TextMap.GetValue("Text908"), "full_sifengyuanyeyi_b" },
        { "talk", true, TextMap.GetValue("Text743"), TextMap.GetValue("Text909"), "full_sifengyuanyeyi_b" },
        { "end" },
        dont_check = true,
        name = TextMap.GetValue("Text910")
    },
    --日常解锁 10级
    [800] = {
        { "talk", true, TextMap.GetValue("Text587"), TextMap.GetValue("Text911"), "full_luqiya_b" },
        { "guide", "step_btn_select_richang" },
        { "talk", true, TextMap.GetValue("Text587"), TextMap.GetValue("Text912"), "full_luqiya_b" },
        { "talk", true, TextMap.GetValue("Text587"), TextMap.GetValue("Text913"), "full_luqiya_b" },
        --        { "guide", "step_chengjiu_one" },
        --领取一个
        --        { "stop" },
        --        { "open_group", 801 },
        --        { "guide", "step_btn_back" },
        --        { "group", 801 },
        { "end" },
        dont_check = true,
        name = TextMap.GetValue("Text914")
    },
    -- 解锁对决 8级
    [805] = {
        { "talk", true, TextMap.GetValue("Text743"), TextMap.GetValue("Text915"), "full_sifengyuanyeyi_b" },
        { "guide", "step_select_dui_jue" },
        { "talk", true, TextMap.GetValue("Text743"), TextMap.GetValue("Text916"), "full_sifengyuanyeyi_b" },
        { "guide", "step_chapterElite_one" },
        { "end" },
        dont_check = true,
        name = TextMap.GetValue("Text917")
    },

    --解锁竞技场 13级
    [1100] = {
        --        { "stop" },
        { "guide", "step_select_jjc" },
        { "talk", true, TextMap.GetValue("Text750"), TextMap.GetValue("Text918"), "full_gengmujianba_b" },
        { "talk", true, TextMap.GetValue("Text743"), TextMap.GetValue("Text919"), "full_sifengyuanyeyi_b" },
        { "talk", true, TextMap.GetValue("Text743"), TextMap.GetValue("Text920"), "full_sifengyuanyeyi_b" },
        { "end" },
        dont_check = true,
        name = TextMap.GetValue("Text921")
    },

    --15级解锁悬赏
    [1300] = {
        { "talk", true, TextMap.GetValue("Text589"), TextMap.GetValue("Text922"), "full_heiqiyihu_b" },
        { "talk", true, TextMap.GetValue("Text743"), TextMap.GetValue("Text923"), "full_sifengyuanyeyi_b" },
        { "guide", "step_select_xian_shan" },
        { "talk", true, TextMap.GetValue("Text743"), TextMap.GetValue("Text924"), "full_sifengyuanyeyi_b" },
        { "talk", true, TextMap.GetValue("Text743"), TextMap.GetValue("Text925"), "full_sifengyuanyeyi_b" },
        { "end" },
        dont_check = true,
        name = TextMap.GetValue("Text926")
    },

    --20级解锁千层塔
    [1500] = {
        { "talk", true, TextMap.GetValue("Text743"), TextMap.GetValue("Text927"), "full_sifengyuanyeyi_b" },
        { "talk", true, TextMap.GetValue("Text589"), TextMap.GetValue("Text928"), "full_heiqiyihu_b" },
        { "guide", "step_select_tower" },
        { "talk", true, TextMap.GetValue("Text743"), TextMap.GetValue("Text929"), "full_sifengyuanyeyi_b" },
        { "talk", true, TextMap.GetValue("Text743"), TextMap.GetValue("Text930"), "full_sifengyuanyeyi_b" },
        { "end" },
        dont_check = true,
        name = TextMap.GetValue("Text931")
    },
    --18级解锁黑店
    [1800] = {
        { "talk", true, TextMap.GetValue("Text589"), TextMap.GetValue("Text932"), "full_heiqiyihu_b" },
        { "guide", "step_select_shop" },
        { "talk", true, TextMap.GetValue("Text714"), TextMap.GetValue("Text933"), "full_puyuanxizhu_b" },
        { "talk", true, TextMap.GetValue("Text714"), TextMap.GetValue("Text934"), "full_puyuanxizhu_b" },
        { "talk", true, TextMap.GetValue("Text714"), TextMap.GetValue("Text935"), "full_puyuanxizhu_b" },
        { "guide", "step_shop_lunhui" },
        { "talk", true, TextMap.GetValue("Text714"), TextMap.GetValue("Text936"), "full_puyuanxizhu_b" },
        { "talk", true, TextMap.GetValue("Text589"), TextMap.GetValue("Text937"), "full_heiqiyihu_b" },
        { "talk", true, TextMap.GetValue("Text714"), TextMap.GetValue("Text938"), "full_puyuanxizhu_b" },
        { "guide", "step_shop_lunhui_relive" },
        { "talk", true, TextMap.GetValue("Text714"), TextMap.GetValue("Text939"), "full_puyuanxizhu_b" },
        { "talk", true, TextMap.GetValue("Text714"), TextMap.GetValue("Text940"), "full_puyuanxizhu_b" },
        { "end" },
        dont_check = true,
        name = TextMap.GetValue("Text941")
    },

    --22级困难模式
    [1900] = {
        { "talk", true, TextMap.GetValue("Text589"), TextMap.GetValue("Text942"), "full_heiqiyihu_b" },
        { "talk", true, TextMap.GetValue("Text743"), TextMap.GetValue("Text943"), "full_sifengyuanyeyi_b" },
        { "guide", "step_select_section" },
        { "guide", "step_click_section_hard" },
        { "talk", true, TextMap.GetValue("Text743"), TextMap.GetValue("Text944"), "full_sifengyuanyeyi_b" },
        { "end" },
        dont_check = true,
        name = TextMap.GetValue("Text945")
    },

    --25级解锁试练
    [2000] = {
        { "talk", true, TextMap.GetValue("Text589"), TextMap.GetValue("Text946"), "full_heiqiyihu_b" },
        { "talk", true, TextMap.GetValue("Text743"), TextMap.GetValue("Text947"), "full_sifengyuanyeyi_b" },
        { "guide", "step_select_shi_lian" },
        { "talk", true, TextMap.GetValue("Text743"), TextMap.GetValue("Text948"), "full_sifengyuanyeyi_b" },
        { "end" },
        dont_check = true,
        name = TextMap.GetValue("Text949")
    },
    [2100] = {
        { "stop" },
        { "guide", "step_btn_char_ghost" },
        { "talk", false, TextMap.GetValue("Text714"), TextMap.GetValue("Text950"), "full_puyuanxizhu_b" },
        { "guide", "step_huilian" },
        { "talk", false, TextMap.GetValue("Text714"), TextMap.GetValue("Text951"), "full_puyuanxizhu_b" },

        -- { "guide", "step_hunlian_huidao" },
        --        { "guide", "step_hunlian_huidao_right" },
        -- { "guide", "step_hunlian_huidao_onekey" },
        { "guide", "step_hunlian_huidao_hunlian" },

        { "guide", "step_btn_back" },
        { "guide", "step_btn_formation" },
        { "guide", "step_btn_formation_change" },
        { "guide", "step_btn_guidao_click_huidao" },
        { "guide", "step_btn_guidao_select_huidao" },
        -- { "talk", false, TextMap.GetValue("Text714"), "哟西~这样你就装备上了你的第一个鬼道啦~", "full_puyuanxizhu_b" },

        { "guide", "step_btn_guidao_click_huidao" },
        { "talk", false, TextMap.GetValue("Text714"), TextMap.GetValue("Text952"), "full_puyuanxizhu_b" },
        -- { "guide", "step_btn_guidao_click_strong_tab" },
        { "guide", "step_btn_guidao_click_strong" },
        { "talk", false, TextMap.GetValue("Text714"), TextMap.GetValue("Text953"), "full_puyuanxizhu_b" },
        { "end" },
        dont_check = true,
        name = TextMap.GetValue("Text954")
    },

    --洗练解锁 35级
    [2500] = {
        { "stop" },
        { "guide", "step_char_xilian" },
        { "talk", true, TextMap.GetValue("Text743"), TextMap.GetValue("Text955"), "full_sifengyuanyeyi_b" },
        { "talk", true, TextMap.GetValue("Text743"), TextMap.GetValue("Text956"), "full_sifengyuanyeyi_b" },
        { "end" },
        dont_check = true,
        name = TextMap.GetValue("Text957")
    },

    --解锁强化 30
    [3000] = {
        { "talk", true, TextMap.GetValue("Text743"), TextMap.GetValue("Text958"), "full_sifengyuanyeyi_b" },
        { "guide", "step_select_qian_hua" },
        { "end" },
        dont_check = true,
        name = TextMap.GetValue("Text959")
    },
    [3100] = {
        { "talk", true, TextMap.GetValue("Text743"), TextMap.GetValue("Text960"), "full_sifengyuanyeyi_b" },
        { "guide", "step_btn_char_skill" },
        { "talk", true, TextMap.GetValue("Text743"), TextMap.GetValue("Text961"), "full_sifengyuanyeyi_b" },
        { "guide", "step_btn_change_skill" },
        { "end" },
        dont_check = true,
        name = TextMap.GetValue("Text962")
    },
    [3200] = {
        { "talk", true, TextMap.GetValue("Text743"), TextMap.GetValue("Text963"), "full_sifengyuanyeyi_b" },
        { "guide", "step_btn_back" },
        { "guide", "step_select_jin_hua" },
        { "talk", true, TextMap.GetValue("Text743"), TextMap.GetValue("Text964"), "full_sifengyuanyeyi_b" },
        -- { "guide", "step_btn_jin_hua" },
        { "end" },
        dont_check = true,
        name = TextMap.GetValue("Text965")
    }
    --------------------------------------------------------------------------------------------------------------------
}
return group