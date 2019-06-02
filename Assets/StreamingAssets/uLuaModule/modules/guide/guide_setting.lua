local EndPlot = "EndThePlot" --假战斗结束
local BattleWin = "BattleWin" --假战斗胜利
local BattleWinClose="BattleWinClose" --胜利界面关闭
local MainSceneInit = "MainSceneInit" --主场景加载完成
local ChangeName = "ChangeName"
local CloseLevelUp = "CloseLevelUp"
local GuideNext = "GuideNext" --下一步
local ClickBuild = "ClickBuild" --点击建筑,下一步
local ClickCpapter = "ClickCpapter" --点击关卡..
local RewardTaskSucc = "RewardTaskSucc" --领取任务成功
local ClosePowerUp = "ClosePowerUp" --突破成功
local CreatePlayer ="CreatePlayer" --创建角色
local RewardSucc ="RewardSucc" --领取宝箱成功
local ProgressLoad="ProgressLoad" --初始化加载完成
local ArenaDragEnd="ArenaDragEnd" --竞技场排名数据拉拉取结束
local ChapterMoveEnd = "ChapterMoveEnd" -- 关卡移动结束
local IndianaDrag = "IndianaDrag"--夺宝对象列表的拉去
local ret = true
local xiugai = false--未达关卡领关卡宝箱
local msg_grade = ""

local script = {
    step1 = {
        {
            "callFunc", 
            function()
            MusicManager.stopAllMusic()
        end
        },
        { "text", {TextMap.GetValue("Text_1_360")},1,50 ,log = "0-0" },
        { "play", "battle_fake1",log = "0-2",server = 1 },
        { "wait", EndPlot ,log = "0-3",server = 1 },
        { "text", {TextMap.GetValue("Text_1_366")},1,50 ,log = "0-4",server = 1 },
        { "save",log = "0-5",server = 1  },
        { "call", "step2",}
    },
    step2 = {
        { "talk", true,TextMap.GetValue("Text_1_248"),TextMap.GetValue("Text_1_370"), 198,false,"map_c_001_s",log = "1-0",server = 1},
        { "talk", false,TextMap.GetValue("Text_1_250"),"……",180,false,"map_c_001_s",log = "1-1",server = 1},
        { "talk", true,TextMap.GetValue("Text_1_248"),TextMap.GetValue("Text_1_371"), 198,false,"map_c_001_s",log = "1-2",server = 1},
        { "talk", false,TextMap.GetValue("Text_1_250"),TextMap.GetValue("Text_1_372"), 180,false,"map_c_001_s",log = "1-3",server = 1},
        { "talk", true,TextMap.GetValue("Text_1_248"),TextMap.GetValue("Text_1_373"), 198,false,"map_c_001_s",log = "1-4",server = 1},
        { "talk", false,TextMap.GetValue("Text_1_250"), TextMap.GetValue("Text_1_374"),180,false,"map_c_001_s",log = "1-5",server = 1},
        { "save", log = "1-6",server = 1},
        { "wait", CreatePlayer },
    },
    --章节开头
    step3 = {
        { "wait", ProgressLoad,log = "1-7",server = 1},
        { "save", log = "1-8",server = 1},
        { "text", {TextMap.GetValue("Text_1_375")},1,50,log = "1-9",server=1},
        { "call", "step4",2}
    },
    --闯关1
    step4 = {
        { "wait", ProgressLoad,log = "1-10",server = 1},
        { "jump", "chapter1", "Prefabs/moduleFabs/chapterModule/chapterModule_new", "", { 1, 0, "commonChapter" } },
        {"wait",ChapterMoveEnd,log = "1-11",server = 1},
        {
            "guide",
            path = "GameManager/Camera/mainUI/center/Module_chapterModule_new/chapterModule_new/chapter/content/scrollView/view_grid/cell0/pos/chapterPage/chapterPageItem1/simpleImage",
            say = TextMap.GetValue("Text_1_379"),
            pos = "leftTop",
            event = GuideNext,
            log = "2-0",
            server = 1
        },
        {
            "guide",
            path = "GameManager/Camera/mainUI/center/Module_chapterModule_new/top_layer/chapterFight/challengeBtn",
            say = "",
            pos = "leftTop",
            event = "logic.chapterHandler.fightChapter",
            log = "2-1",
            server = 1
        },
        { "save", log = "2-2",server = 1 },
        { "wait", BattleWinClose,log = "2-3",server = 1 },
        { "wait", CloseLevelUp,log = "2-4",server = 1 },
        { "call", "step5",4}
    },
    --领取关卡宝箱
    step5 = {
        { "wait", ProgressLoad },
        { "jump", "chapter1", "Prefabs/moduleFabs/chapterModule/chapterModule_new", "", { 1, 0, "commonChapter" } },
        {"wait",ChapterMoveEnd},
        {"callFunc",
            function()
                local lastSection = Player.Chapter.lastSection
                if lastSection <2 then
                    xiugai=true 
                    GuideMrg.CallStep("step4", 3)
                elseif xiugai then 
                    xiugai=false 
                    local obj = GameObject.Find("GameManager/Camera/mainUI/center/Module_chapterModule_new/top_layer/levelup_new")
                    GameObject.Destroy(obj)
                end 
            end
        },
        { "talk", true,"player",TextMap.GetValue("Text_1_380"), 30,false,"map_c_001_s",log = "3-0" },
        {
            "guide",
            path = "GameManager/Camera/mainUI/center/Module_chapterModule_new/chapterModule_new/chapter/content/scrollView/view_grid/cell0/pos/chapterPage/chapterPageItem1/baoxiang",
            say = TextMap.GetValue("Text_1_381"),
            pos = "leftTop",
            event = GuideNext,
            condition = function()
                local chapterData = TableReader:TableRowByUniqueKey("chapter", 1, "commonChapter")
                --小关宝箱
                local ta = TableReader:TableRowByUniqueKey("commonChapter", 1, 1)
                local  box = ta["box"]
                if box.Count > 0 then
                    local boxState = false
                    if Player.Chapter.status[ta.id] ~= nil then
                        boxState = Player.Chapter.status[ta.id].bGotBox
                    end
                    if boxState ~= nil and boxState == true then
                        GuideMrg.CallStep("step5", 8)
                        return false
                    end
                end
                return true
            end,
            log = "3-1" 
        },
        {
            "guide",
            path = "GameManager/Camera/mainUI/center/Module_chapterModule_new/top_layer/chapterboxtwo/btn_queren",
            say = "",
            pos = "leftTop",
            --event = "logic.chapterHandler.getChapterBox",
            event = GuideNext,
            condition = function()
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
                        GuideMrg.CallStep("step5", 8)
                        return false
                    end
                end
                return true
            end,
            log = "3-2" 
        },
        { "wait", RewardSucc },
        { "save", log = "3-3" },
        { "talk", false,TextMap.GetValue("Text_1_382"),TextMap.GetValue("Text_1_383"), 30,false,"map_c_001_s",log = "3-4" },
        { "talk", true,"player",TextMap.GetValue("Text_1_384"), 30,false,"map_c_001_s",log = "3-4" },
        { "talk", false,TextMap.GetValue("Text_1_382"),TextMap.GetValue("Text_1_385"), 30,false,"map_c_001_s",log = "3-5" },
        { "talk", true,"player",TextMap.GetValue("Text_1_386"), 30,false,"map_c_001_s",log = "3-6" },
        { "talk", false,TextMap.GetValue("Text_1_382"),TextMap.GetValue("Text_1_387"), 30,false,"map_c_001_s",log = "3-7" },
        { "talk", true,"player",TextMap.GetValue("Text_1_388"), 30,false,"map_c_001_s",log = "3-8" },
        {
            "guide",
            path = "GameManager/Camera/mainUI/center/Module_chapterModule_new/chapterModule_new/btns/btnBack",
            say = "",
            pos = "leftBottom",
            event = GuideNext,
            log = "3-5" 
        },
        { "call", "step6",2}
    },
    --上阵1
    step6 = {
        { "wait", ProgressLoad },
        {
            "guide",
            path = "GameManager/Camera/mainUI/center/Module_main_menu/main_menu/top_menu/ButtonMenu_new/btn_list/btn_item_right/btn_zhenrong",
            say = "",
            pos = "leftTop",
            event = GuideNext,
            log = "4-0" 
        },
        { "sleep", 5},
        {
            "guide",
            path = "GameManager/Camera/mainUI/center/Module_formation_main/formation_main/bg/frame_bg/hero_list/Scroll View/Content/icon2",
            say = "",
            pos = "leftTop",
            event = GuideNext,
            log = "4-1" 
        },
        { "sleep", 5},
        {
            "guide",
            path = "GameManager/Camera/mainUI/center/Module_formation_main/top_layer/formation_select_char/scrollView/Scroll View/Content/0/Grid/selectCharCell1/bg/btn_up",
            say = "",
            pos = "left",
            event = "logic.chapterHandler.saveTeam",
            log = "4-2" 
        },
        { "save", log = "4-3" },
        { "talk", true,TextMap.GetValue("Text_1_382"),TextMap.GetValue("Text_1_389"), 30,false,"map_c_001_s",log = "4-4" },
        {
            "guide",
            path = "GameManager/Camera/mainUI/center/Module_formation_main/formation_main/gui_top_title/btnBack",
            say = "",
            pos = "leftBottom",
            event = GuideNext,
            log = "4-5" 
        },
        { "call", "step7",2}
    },
    --闯关2
    step7 = {
        { "wait", ProgressLoad },
        {
            "guide",
            path = "GameManager/Camera/mainUI/center/Module_main_menu/main_menu/top_menu/ButtonMenu_new/btn_list/btn_item_right/btn_chaungguan",
            say = "",
            pos = "leftTop",
            event = GuideNext,
            log = "5-0" 
        },
        {"wait",ChapterMoveEnd},
        {
            "guide",
            path = "GameManager/Camera/mainUI/center/Module_chapterModule_new/chapterModule_new/chapter/content/scrollView/view_grid/cell0/pos/chapterPage/chapterPageItem2/simpleImage",
            say = "",
            pos = "top",
            event = GuideNext,
            log = "5-1" 
        },
        {
            "guide",
            path = "GameManager/Camera/mainUI/center/Module_chapterModule_new/top_layer/chapterFight/challengeBtn",
            say = "",
            pos = "leftTop",
            event = "logic.chapterHandler.fightChapter",
            log = "5-2" 
        },
        { "save", log = "5-3" },
        { "wait", BattleWinClose,log = "5-3-1"},
        { "wait", CloseLevelUp,log = "5-3-2"},
        { "talk", true,TextMap.GetValue("Text_1_382"),TextMap.GetValue("Text_1_390"), 30,false,"map_c_001_s",log = "5-4" },
        { "talk", false,"player",TextMap.GetValue("Text_1_391"), 30,false,"map_c_001_s",log = "5-5" },
        { "talk", true,TextMap.GetValue("Text_1_382"),TextMap.GetValue("Text_1_392"), 30,false,"map_c_001_s",log = "5-6" },
        {
            "guide",
            path = "GameManager/Camera/mainUI/center/Module_chapterModule_new/chapterModule_new/btns/btnBack",
            say = "",
            pos = "leftBottom",
            event = GuideNext,
            log = "5-7" 
        },
        { "call", "step8",2}
    },
    --钻石单抽
    step8 = {
        { "wait", ProgressLoad },
        {
            "guide",
            path = "GameManager/Camera/mainUI/center/Module_main_menu/main_menu/top_menu/ButtonMenu_new/btn_list/btn_item_right/btn_zhaomu",
            say = TextMap.GetValue("Text_1_393"),
            pos = "leftTop",
            event = GuideNext,
            log = "6-0" 
        },
        {
            "guide",
            path = "GameManager/Camera/mainUI/center/Module_shop/shop/BlockLeft/item/zhaomu/Textureright",
            say = TextMap.GetValue("Text_1_394"),
            pos = "top",
            event = GuideNext,
            log = "6-1" 
        },
        {
            "guide",
            path = "GameManager/Camera/mainUI/center/Module_summontwo/summontwo/BlockSecond/btnSpSummon",
            say ="",
            pos = "left",
            event = "logic.drawHandler.draw",
            call = function(go)
                Api:draw(8, function(result)
                    Messenger.BroadcastObject(GuideNext, go)
                    PlayerPrefs.SetInt(Player.playerId.."_guide_"..0, 5)
                    local lua = {
                        result = result,
                        cbAgin = function() end,
                        darw_id = 5,
                        cost_type = "gold",
                        cost = 280,
                        cost_icon ="res_gold",
                        consume={consume_type="gold",consume_arg=280}
                    }
                    UIMrg:CallRunnigModuleFunctionWithArgs("hideOrShowEffect", { false })
                    Tool.push("RewardItem", "Prefabs/moduleFabs/choukaModule/RewardItem", lua)
                end,function(ret)
                     if ret == 54 then 
                        local api = "logic.drawHandler.draw"
                        Messenger.BroadcastObject(api, api)
                    end
                    return true
                end)
            end,
            condition = function()
                local chars = Player.Chars:getLuaTable()
                for k, v in pairs(chars) do
                    local char = Char:new(k, v)
                    if char.dictid=="23" then return false end
                end 
                return true
            end,
            log = "6-2" 
        },
        { "save", log = "6-3" },
        { "sleep", 400 },
        {
            "guide",
            path = "GameManager/Camera/mainUI/center/Module_RewardItem/RewardItem/Panel/ani_show_button/btn_queding",
            say = "",
            pos = "leftTop",
            event = GuideNext,
            log = "6-4" 
        },
        {
            "guide",
            path = "GameManager/Camera/mainUI/center/Module_summontwo/summontwo/btnBack",
            say = "",
            pos = "leftTop",
            event = GuideNext,
            log = "6-4-2" 
        },
        {
            "guide",
            path = "GameManager/Camera/mainUI/center/Module_shop/shop/gui_top_title/btnBack",
            say = "",
            pos = "leftBottom",
            event = GuideNext,
            log = "6-6" 
        },
        { "call", "step9",2}
    },
    --上阵2
    step9 = {
        { "wait", ProgressLoad },
        {
            "guide",
            path = "GameManager/Camera/mainUI/center/Module_main_menu/main_menu/top_menu/ButtonMenu_new/btn_list/btn_item_right/btn_zhenrong",
            say = "",
            pos = "leftTop",
            event = GuideNext,
            log = "7-0" 
        },
        {
            "guide",
            path = "GameManager/Camera/mainUI/center/Module_formation_main/formation_main/bg/frame_bg/hero_list/Scroll View/Content/icon3",
            say = "",
            pos = "rightTop",
            event = GuideNext,
            log = "7-1" 
        },
        {
            "guide",
            path = "GameManager/Camera/mainUI/center/Module_formation_main/top_layer/formation_select_char/scrollView/Scroll View/Content/0/Grid/selectCharCell1/bg/btn_up",
            say = "",
            pos = "left",
            event = "logic.chapterHandler.saveTeam",
            log = "7-2"  
        },
        { "save", log = "7-3" },
        --{ "talk", true,TextMap.GetValue("Text_1_382"),"菜菜我本来就厉害，有了英英这个奶，感觉就更厉害了我！", 30,false,"map_c_011_s"},
        {
            "guide",
            path = "GameManager/Camera/mainUI/center/Module_formation_main/formation_main/gui_top_title/btnBack",
            say = "",
            pos = "leftBottom",
            event = GuideNext,
            log = "7-4" 
        },
        { "call", "step10",2}
    },
    --闯关3
    step10 = {
        { "wait", ProgressLoad },
        {
            "guide",
            path = "GameManager/Camera/mainUI/center/Module_main_menu/main_menu/top_menu/ButtonMenu_new/btn_list/btn_item_right/btn_chaungguan",
            say = "",
            pos = "leftTop",
            event = GuideNext,
            log = "8-0" 
        },
        {"wait",ChapterMoveEnd},
        {
            "guide",
            path = "GameManager/Camera/mainUI/center/Module_chapterModule_new/chapterModule_new/chapter/content/scrollView/view_grid/cell0/pos/chapterPage/chapterPageItem3/simpleImage",
            say = "",
            pos = "rightTop",
            event = GuideNext,
            log = "8-1" 
        },
        {
            "guide",
            path = "GameManager/Camera/mainUI/center/Module_chapterModule_new/top_layer/chapterFight/challengeBtn",
            say = "",
            pos = "left",
            event = "logic.chapterHandler.fightChapter",
            log = "8-2" 
        },
        { "save", log = "8-3" },
        { "wait", BattleWinClose,log = "8-3-1",server = 1 },
        { "wait", CloseLevelUp,log = "8-3-2",server = 1 },
        { "talk", true,"player",TextMap.GetValue("Text_1_395"), 30 ,false,"map_c_001_s",log = "8-4" },
        { "talk", false,TextMap.GetValue("Text_1_382"),TextMap.GetValue("Text_1_396"), 30 ,false,"map_c_001_s",log = "8-5" },
        { "talk", true,TextMap.GetValue("Text_1_397"),TextMap.GetValue("Text_1_398"), 23 ,false,"map_c_001_s",log = "8-6" },
        { "talk", false,TextMap.GetValue("Text_1_382"),TextMap.GetValue("Text_1_399"), 30 ,false,"map_c_001_s",log = "8-6-1" },
        {
            "guide",
            path = "GameManager/Camera/mainUI/center/Module_chapterModule_new/chapterModule_new/btns/btnBack",
            say = "",
            pos = "leftBottom",
            event = GuideNext,
            log = "8-7" 
        },
        { "call", "step11",2}
    },
    -- 武将升级
    step11 = {
        { "wait", ProgressLoad },
        {
            "guide",
            path = "GameManager/Camera/mainUI/center/Module_main_menu/main_menu/top_menu/ButtonMenu_new/btn_list/btn_item_right/btn_zhenrong",
            say = "",
            pos = "leftTop",
            event = GuideNext,
            log = "9-0" 
        },
        {
            "guide",
            path = "GameManager/Camera/mainUI/center/Module_formation_main/formation_main/bg/frame_bg/hero_list/Scroll View/Content/icon2",
            say = "",
            pos = "leftTop",
            event = GuideNext,
            log = "9-1" 
        },
        {
            "guide",
            path = "GameManager/Camera/mainUI/center/Module_formation_main/formation_main/bg/Container/con/formation_guidao/Panel/heromodel",
            say = "",
            pos = "left",
            event = GuideNext,
            log = "9-2" 
        },
        {
            "guide",
            path = "GameManager/Camera/mainUI/center/Module_hero_info/hero_info/attr/Scroll View/con/info_bg/btn_lvup",
            say = "",
            pos = "left",
            event = GuideNext,
            log = "9-3" 
        },
        { "sleep", 5 },
        {
            "guide",
            path = "GameManager/Camera/mainUI/center/Module_newHero/newHero/con/gui_heroLvUp/Container/btnAdd",
            say = TextMap.GetValue("Text_1_400"),
            pos = "top",
            event = GuideNext,
            condition = function()
                local chars = Player.Chars:getLuaTable()
                local isHasChar = false
                for k, v in pairs(chars) do
                    local char = Char:new(k, v)
                    if tonumber(char.dictid)==30 and char.lv==1 then 
                        isHasChar=true 
                    end
                end 
                return isHasChar
            end,
            log = "9-4" 
        },
        {
            "guide",
            path = "GameManager/Camera/mainUI/center/Module_newHero/newHero/con/gui_heroLvUp/Container/btnLvUp",
            say = TextMap.GetValue("Text_1_401"),
            pos = "leftTop",
            event = "logic.trainHandler.charLevelUp",
            condition = function()
                local chars = Player.Chars:getLuaTable()
                local isHasChar = false
                for k, v in pairs(chars) do
                    local char = Char:new(k, v)
                    if tonumber(char.dictid)==30 and char.lv==1 then 
                        isHasChar=true 
                    end
                end 
                return isHasChar
            end,
            log = "9-11" 
        },
        { "save", log = "9-12" },
        { "sleep", 200 },
        {
            "guide",
            path = "GameManager/Camera/mainUI/center/Module_newHero/newHero/gui_top_title/btnBack",
            say = TextMap.GetValue("Text_1_402"),
            pos = "leftBottom",
            event = GuideNext,
            log = "9-13" 
        },
        {
            "guide",
            path = "GameManager/Camera/mainUI/center/Module_hero_info/hero_info/gui_top_title/btnBack",
            say = "",
            pos = "leftBottom",
            event = GuideNext,
            log = "9-14" 
        },
        { "sleep", 5 },
        {
            "guide",
            path = "GameManager/Camera/mainUI/center/Module_formation_main/formation_main/gui_top_title/btnBack",
            say = "",
            pos = "leftBottom",
            event = GuideNext,
            log = "9-15" 
        },
        { "call", "step12",2}
    },
    --闯关4
    step12 = {
        { "wait", ProgressLoad },
        {
            "guide",
            path = "GameManager/Camera/mainUI/center/Module_main_menu/main_menu/top_menu/ButtonMenu_new/btn_list/btn_item_right/btn_chaungguan",
            say = "",
            pos = "leftTop",
            event = GuideNext,
            log = "10-0" 
        },
        {"wait",ChapterMoveEnd},
        {
            "guide",
            path = "GameManager/Camera/mainUI/center/Module_chapterModule_new/chapterModule_new/chapter/content/scrollView/view_grid/cell0/pos/chapterPage/chapterPageItem4/simpleImage",
            say = "",
            pos = "left",
            event = GuideNext,
            log = "10-1" 
        },
        {
            "guide",
            path = "GameManager/Camera/mainUI/center/Module_chapterModule_new/top_layer/chapterFight/challengeBtn",
            say = "",
            pos = "left",
            event = "logic.chapterHandler.fightChapter",
            log = "10-2" 
        },
        { "save", log = "10-3" },
        { "wait", BattleWinClose,log = "10-4" },
        { "wait", CloseLevelUp,log = "10-5" },
        { "call", "step13",4}
    },
    --领取星星宝箱
    step13 ={
        { "wait", ProgressLoad },
        {"callFunc",
            function()
                local tasks = Player.Tasks:getLuaTable() --任务表
                local taskid = TableReader:TableRowByUniqueKey("chapter", 1, "commonChapter")["taskID"]
                if taskid == nil then
                    return
                end
                if taskid[0] ~= nil then
                    local taskidv = taskid[0].taskID
                    local row = TableReader:TableRowByID('allTasks', taskidv)
                    if row == nil then
                        GuideMrg.SaveLog()
                        GuideMrg.saveLineEnd()
                        return false
                    end
                    if tasks[taskidv] ~= nil then
                        local state = tasks[taskidv]["state"]
                        print(state)
                        if state==0 or state==1 then
                            GuideMrg.SaveLog()
                            GuideMrg.saveLineEnd()
                            return false
                        elseif state==2 then 
                            return true
                        elseif state==3 then 
                            GuideMrg.SaveLog()
                            GuideMrg.saveLineEnd()
                            return false
                        else
                            GuideMrg.SaveLog()
                            GuideMrg.saveLineEnd()
                            return false
                        end
                    end
                end
                GuideMrg.SaveLog()
                GuideMrg.saveLineEnd()
                return false
            end
        },
        { "jump", "chapter1", "Prefabs/moduleFabs/chapterModule/chapterModule_new", "", { 1, 0, "commonChapter" }},
        {
            "guide",
            path = "GameManager/Camera/mainUI/center/Module_chapterModule_new/chapterModule_new/chapter/bg/Container/awardBtn/baoxiang0",
            say = TextMap.GetValue("Text_1_403"),
            pos = "leftTop",
            event = GuideNext,
            condition = function()
                local tasks = Player.Tasks:getLuaTable() --任务表
                local taskid = TableReader:TableRowByUniqueKey("chapter", 1, "commonChapter")["taskID"]
                if taskid == nil then
                    return
                end
                if taskid[0] ~= nil then
                    local taskidv = taskid[0].taskID
                    local row = TableReader:TableRowByID('allTasks', taskidv)
                    if row == nil then
                        GuideMrg.CallStep("step13", 6)
                        return false
                    end
                    if tasks[taskidv] ~= nil then
                        local state = tasks[taskidv]["state"]
                        if state==0 or state==1 then
                            GuideMrg.CallStep("step13", 6)
                            return false
                        elseif state==2 then 
                            return true
                        elseif state==3 then 
                            GuideMrg.CallStep("step13", 6)
                            return false
                        else
                            GuideMrg.CallStep("step13", 6)
                            return false
                        end
                    end
                end
                GuideMrg.CallStep("step13", 6)
                return false
            end,
            log = "11-0" 
        },
        {
            "guide",
            path = "GameManager/Camera/mainUI/center/Module_chapterModule_new/top_layer/chapterbox/btn_queren",
            say = "",
            pos = "left",
            event ="logic.taskHandler.submitTask",
            condition = function()
                local tasks = Player.Tasks:getLuaTable() --任务表
                local taskid = TableReader:TableRowByUniqueKey("chapter", 1, "commonChapter")["taskID"]
                if taskid == nil then
                    return
                end
                if taskid[0] ~= nil then
                    local taskidv = taskid[0].taskID
                    local row = TableReader:TableRowByID('allTasks', taskidv)
                    if row == nil then
                        GuideMrg.CallStep("step13", 6)
                        return false
                    end
                    if tasks[taskidv] ~= nil then
                        local state = tasks[taskidv]["state"]
                        if state==0 or state==1 then
                            GuideMrg.CallStep("step13", 6)
                            return false
                        elseif state==2 then 
                            return true
                        elseif state==3 then 
                            GuideMrg.CallStep("step13", 6)
                            return false
                        else
                            GuideMrg.CallStep("step13", 6)
                            return false
                        end
                    end
                end
                return false
            end,
            log = "11-1" 
        },
        { "wait", RewardSucc},
        { "save", log = "11-2" },
        {
            "guide",
            path = "GameManager/Camera/mainUI/center/Module_chapterModule_new/chapterModule_new/btns/btnBack",
            say = "",
            pos = "leftBottom",
            event = GuideNext,
            log = "11-3" 
        },
        { "call", "step14",2}
    },
    --武将进化
    step14 = {
        { "wait", ProgressLoad },
        {
            "guide",
            path = "GameManager/Camera/mainUI/center/Module_main_menu/main_menu/btns_hero/btn_buxia",
            say = TextMap.GetValue("Text_1_404"),
            pos = "leftTop",
            event = GuideNext,
            log = "12-0" 
        },
        {
            "guide",
            path = "GameManager/Camera/mainUI/center/Module_hero_select_char/hero_select_char/scrollView_hero/Scroll View/Content/0/Grid/selectCharIcon1/button",
            say = "",
            pos = "left",
            event = GuideNext,
            log = "12-1" 
        },
        {
            "guide",
            path = "GameManager/Camera/mainUI/center/Module_newHero/newHero/con/heroJinhua/Container/btn_starUp",
            say = "",
            pos = "left",
            event = GuideNext,
            log = "12-2" 
        },
        {
            "guide",
            path = "ui_waiting/Panel/dialog/img_bg/sure",
            say = "",
            pos = "left",
            event = "logic.trainHandler.charStarUp",
            log = "12-3" 
        },
        { "save", log = "12-4" },
        {"wait",ClosePowerUp},
        { "talk", true,"player",TextMap.GetValue("Text_1_405"), 30 ,false,"map_c_001_s",log = "12-5" },
        { "talk", false,TextMap.GetValue("Text_1_382"),TextMap.GetValue("Text_1_406"), 30 ,false,"map_c_001_s",log = "12-6" },
        { "talk", true,"player",TextMap.GetValue("Text_1_407"), 30 ,false,"map_c_001_s",log = "12-7" },
        {
            "guide",
            path = "GameManager/Camera/mainUI/center/Module_newHero/newHero/gui_top_title/btnBack",
            say = "",
            pos = "leftBottom",
            event = GuideNext,
            log = "12-8" 
        },
        {
            "guide",
            path = "GameManager/Camera/mainUI/center/Module_hero_select_char/hero_select_char/gui_top_title/btnBack",
            say = "",
            pos = "leftBottom",
            event = GuideNext,
            log = "12-9" 
        },
        { "call", "step15",2}
    },
    --闯关五
    step15 = {
        { "wait", ProgressLoad },
        {
            "guide",
            path = "GameManager/Camera/mainUI/center/Module_main_menu/main_menu/top_menu/ButtonMenu_new/btn_list/btn_item_right/btn_chaungguan",
            say = "",
            pos = "leftTop",
            event = GuideNext,
            log = "13-0" 
        },
        {"wait",ChapterMoveEnd},
        {
            "guide",
            path = "GameManager/Camera/mainUI/center/Module_chapterModule_new/chapterModule_new/chapter/content/scrollView/view_grid/cell0/pos/chapterPage/chapterPageItem5/simpleImage",
            say = "",
            pos = "left",
            event = GuideNext,
            log = "13-1" 
        },
        {
            "guide",
            path = "GameManager/Camera/mainUI/center/Module_chapterModule_new/top_layer/chapterFight/challengeBtn",
            say = "",
            pos = "left",
            event = "logic.chapterHandler.fightChapter",
            log = "13-2" 
        },
        { "save", log = "13-3" },
        { "wait", BattleWinClose },
        { "sleep", 300 },
        { "talk", true,TextMap.GetValue("Text_1_397"),TextMap.GetValue("Text_1_408"), 23 ,false,"map_c_001_s",log = "13-4" },
        { "talk", false,"player",TextMap.GetValue("Text_1_409"), 30 ,false,"map_c_001_s",log = "13-5" },
        { "talk", true,TextMap.GetValue("Text_1_397"),TextMap.GetValue("Text_1_410"), 23 ,false,"map_c_001_s",log = "13-6" },
        { "talk", false,"player",TextMap.GetValue("Text_1_411"), 30 ,false,"map_c_001_s",log = "13-7" },
        { "talk", true,TextMap.GetValue("Text_1_382"),TextMap.GetValue("Text_1_412"), 30 ,false,"map_c_001_s",log = "13-8" },
        {
            "guide",
            path = "GameManager/Camera/mainUI/center/Module_chapterModule_new/chapterModule_new/btns/btnBack",
            say = "",
            pos = "leftBottom",
            event = GuideNext,
            log = "13-9" 
        },
        { "call", "step16",2}
    },
    --等级礼包
    step16 = {
        { "wait", ProgressLoad },
        {
            "guide",
            path = "GameManager/Camera/mainUI/center/Module_main_menu/main_menu/top_menu/ButtonMenu_new/btns_left/btn_dengji",
            say = TextMap.GetValue("Text_1_413"),
            pos = "leftTop",
            event = GuideNext,
            log = "14-1" 
        },
        {"wait" ,ArenaDragEnd},
        {
            "guide",
            path = "GameManager/Camera/mainUI/center/Module_activity_gradeGift/activity_gradeGift/BlockLeft/Scroll View/Content/0",
            say = "",
            pos = "left",
            event = GuideNext,
            log = "14-2" 
        },

        {
            "guide",
            path = "GameManager/Camera/mainUI/center/Module_activity_gradeGift/activity_gradeGift/BlockRight/act_lvlup/table/view/grid/0/btGet",
            say = "",
            pos = "left",
            event = GuideNext,
            condition = function()
                local obj = GameObject.Find("GameManager/Camera/mainUI/center/Module_activity_gradeGift/activity_gradeGift/BlockRight/act_lvlup/table/view/grid/0/btGet")
                if obj~=nil then 
                    local bind = obj:GetComponent(UIButton)
                    if bind~=nil and bind.isEnabled==true then
                        msg_grade= RewardSucc
                        return true 
                    end 
                end 
                msg_grade=""
                return false
            end,
            log = "14-3" 
        },
        { "save", log = "14-4" },
        { "wait", msg_grade },
        {
            "guide",
            path = "GameManager/Camera/mainUI/center/Module_activity_gradeGift/activity_gradeGift/gui_top_title/btnBack",
            say = "",
            pos = "leftBottom",
            event = GuideNext,
            log = "14-5" 
        },
        {
            "guide",
            path = "GameManager/Camera/mainUI/center/Module_main_menu/main_menu/top_menu/ButtonMenu_new/btn_list/btn_item_right/btn_chaungguan",
            say = TextMap.GetValue("Text_1_414"),
            pos = "leftTop",
            event = GuideNext,
            log = "14-6" 
        },
        --{ "call", "step17"},
        { "end" }
    },
    guidao = {
        --鬼道
        { "sleep", 10 },
        { "talk", true,"player",TextMap.GetValue("Text_1_415"), 30 ,false,"map_c_008_s",log = "15-0" },
        { "talk", false,TextMap.GetValue("Text_1_382"),TextMap.GetValue("Text_1_416"), 30 ,false,"map_c_008_s",log = "15-1" },
        { "talk", false,TextMap.GetValue("Text_1_382"),TextMap.GetValue("Text_1_417"), 30 ,false,"map_c_008_s",log = "15-2" },
        { 
            "guide",
            path = "GameManager/Camera/mainUI/center/Module_main_menu/main_menu/top_menu/ButtonMenu_new/btn_list/btn_item_right/btn_zhenrong",
            say = TextMap.GetValue("Text_1_418"), 
            pos = "leftTop", 
            event = "GuideNext",
            log = "15-4" 
        },
        {
            "guide",
            path = "GameManager/Camera/mainUI/center/Module_formation_main/formation_main/bg/frame_bg/hero_list/role",
            say = "",
            pos = "leftTop",
            event = GuideNext,
            log = "4-1" 
        },
        { 
            "guide",
            path = "GameManager/Camera/mainUI/center/Module_formation_main/formation_main/bg/Container/con/formation_guidao/equips/cell0",
            say = "", 
            pos = "top", 
            event = "GuideNext",
            condition = function()
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
                        return false 
                    end 
                end
                return true
            end,
            log = "15-5" 
        },
        {
            "callFunc", 
            function()
            Api:setGuide("guidao", 2, function() end)
        end
        },
        { 
            "guide",
            path = "GameManager/Camera/mainUI/center/Module_formation_main/top_layer/guidao_select_charpiece/scrollView/Scroll View/Content/0/Grid/selectCharCell1",
            say = "", 
            pos = "leftTop", 
            event = "logic.equipHandler.gd_equipOn",
            condition = function()
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
                        return false 
                    end 
                end
                return true
            end,
            log = "15-6" 
        },
        { "talk", true,TextMap.GetValue("Text_1_397"),TextMap.GetValue("Text_1_419"), 23 ,false,"map_c_008_s",log = "15-7" },
        { "talk", false,TextMap.GetValue("Text_1_382"),TextMap.GetValue("Text_1_420"), 30 ,false,"map_c_008_s",log = "15-8" },
        { "talk", true,TextMap.GetValue("Text_1_397"),TextMap.GetValue("Text_1_421"), 23 ,false,"map_c_008_s",log = "15-9" },
        { "talk", false,TextMap.GetValue("Text_1_382"),TextMap.GetValue("Text_1_422"), 30 ,false,"map_c_008_s",log = "15-10" },
        { 
            "guide",
            path = "GameManager/Camera/mainUI/center/Module_formation_main/formation_main/bg/Container/con/formation_guidao/equips/cell0",
            say = "", 
            pos = "top", 
            event = "GuideNext",
            condition = function()
                local charid=Player.Team[0].chars[0]
                local char =Char:new(charid)
                local ghostSlot = Player.ghostSlot
                local ghost = Player.Ghost
                local slot = ghostSlot[0]
                local postion = slot.postion
                local key = postion[0]
                ret=true
                if key ~= "" and key ~= nil and key ~= 0 and key ~= "0" then
                    local g = ghost[key].id
                    if g ~= 0 then
                        local gh = Ghost:new(g, key)
                        local ghostLevelUpCost = TableReader:TableRowByUnique("ghostLevelUpCost", "level", gh.lv + 1)
                        if ghostLevelUpCost~=nil then 
                            local money = ghostLevelUpCost[gh.kind .. gh.star]
                            ret = money < Player.Resource.money
                        end
                        if ret == true then
                            ret = gh:curMaxLv()
                        end
                        return ret
                    end 
                else 
                    ret=false
                    return false
                end
                ret=true
                return true
            end,
            log = "15-11" 
        },
        { 
            "guide",
            path = "GameManager/Camera/mainUI/center/Module_equip_info/equip_info/attr/Scroll View/info_bg/qianghua/btn_lvup",
            say = "", 
            pos = "leftTop", 
            event = "GuideNext" ,
            condition = function()
                return ret
            end,
            log = "15-12" 
        },
        { 
            "guide",
            path = "GameManager/Camera/mainUI/center/Module_ghost_list_new/ghost_list_new/tab/Container/info/strong/Bottom_bg/btStrongAll",
            say = TextMap.GetValue("Text_1_423"), 
            pos = "leftTop", 
            event = "logic.ghostHandler.ghostAutoLevelUp" ,
            condition = function()
                return ret
            end,
            log = "15-13" 
        },
        {
            "guide",
            path = "GameManager/Camera/mainUI/center/Module_ghost_list_new/ghost_list_new/gui_top_title/btnBack",
            say = "",
            pos = "leftBottom",
            event = GuideNext,
            condition = function()
                return ret
            end,
            log = "15-18" 
        },
        {
            "guide",
            path = "GameManager/Camera/mainUI/center/Module_equip_info/equip_info/gui_top_title/btnBack",
            say = "",
            pos = "leftBottom",
            event = GuideNext,
            condition = function()
                return ret
            end,
            log = "15-19" 
        },
        {
            "guide",
            path = "GameManager/Camera/mainUI/center/Module_formation_main/formation_main/gui_top_title/btnBack",
            say = TextMap.GetValue("Text_1_424"),
            pos = "leftBottom",
            event = GuideNext,
            log = "15-20" 
        },
        {
            "guide",
            path = "GameManager/Camera/mainUI/center/Module_main_menu/main_menu/top_menu/ButtonMenu_new/btn_list/btn_item_right/btn_chaungguan",
            say = "",
            pos = "leftTop",
            event = GuideNext,
            log = "15-21" 
        },
        {"end"}
    },
    jjc = {
        --竞技场
        { "sleep", 10 },
        { "talk", true,"player",TextMap.GetValue("Text_1_425"), 30 ,false,"map_c_008_s"},
        { "talk", false,TextMap.GetValue("Text_1_426"),TextMap.GetValue("Text_1_427"), 16 ,false,"map_c_008_s"},
        { "talk", true,"player",TextMap.GetValue("Text_1_428"), 30 ,false,"map_c_008_s"},
        { "talk", false,TextMap.GetValue("Text_1_426"),TextMap.GetValue("Text_1_429"), 16 ,false,"map_c_008_s"},
        { 
            "guide", 
            path = "GameManager/Camera/mainUI/center/Module_main_menu/main_menu/top_menu/ButtonMenu_new/btn_list/btn_item_left/btn_jjc", 
            say = TextMap.GetValue("Text_1_430"),
            pos = "rightTop", 
            event = "GuideNext"
        },
        {
            "callFunc", 
            function()
            Api:setGuide("jjc", 2, function() end)
        end
        },
        { 
            "guide", 
            path = "GameManager/Camera/mainUI/center/Module_jingji_main/jingji_main/scrollView/view/Content/0", 
            say = "",
            pos = "rightTop", 
            event = "GuideNext"
        },
        { "wait", ArenaDragEnd },
        { 
            "guide", 
            path = "GameManager/Camera/mainUI/center/Module_arena_new/arena_new/center/tab_jjc/right/scrollView/Scroll View/Content/2/btn_fight", 
            say = TextMap.GetValue("Text_1_431"),
            pos = "leftTop", 
            event = "GuideNext"
        },
        {"wait" ,BattleWinClose},
        { 
            "guide", 
            path = "GameManager/Camera/mainUI/center/Module_arena_new/arena_new/top/BlockButton/btn_shop", 
            say = TextMap.GetValue("Text_1_432"),
            pos = "leftTop", 
            event = "GuideNext"
        },
        { "talk", true,TextMap.GetValue("Text_1_250"),TextMap.GetValue("Text_1_433"),180,true},
        { "talk", false,TextMap.GetValue("Text_1_382"),TextMap.GetValue("Text_1_434"), 30 ,true},
        { "talk", true,TextMap.GetValue("Text_1_250"),TextMap.GetValue("Text_1_435"),180,true},
        { "talk", false,TextMap.GetValue("Text_1_382"),TextMap.GetValue("Text_1_436"), 30 ,true},
        { "talk", true,TextMap.GetValue("Text_1_250"),TextMap.GetValue("Text_1_437"),180,true},
        { "end" },
    },
    shenle = {
        --神乐
        { "sleep", 10 },
        { "talk", true,"player",TextMap.GetValue("Text_1_438"), 30 ,false,"map_c_008_s"},
        { "talk", false,TextMap.GetValue("Text_1_382"),TextMap.GetValue("Text_1_439"), 30 ,false,"map_c_008_s"},
        { 
            "guide", 
            path = "GameManager/Camera/mainUI/center/Module_main_menu/main_menu/btns_hero/btn_shenle", 
            say = TextMap.GetValue("Text_1_440"),
            pos = "leftTop", 
            event = "GuideNext"
        },
        {
            "callFunc", 
            function()
            Api:setGuide("shenle", 2, function() end)
        end
        },
        { 
            "guide", 
            path = "GameManager/Camera/mainUI/center/Module_chenghaoModule/chenghaoModule/clipPanel/movePanel/1/chenghao_content_item_1/dianliang/dianliangbtn", 
            say = "",
            pos = "leftTop", 
            event = "GuideNext"
        },
        {
            "guide",
            path = "GameManager/Camera/mainUI/center/Module_chenghaoModule/chenghaoModule/btnBack",
            say = TextMap.GetValue("Text_1_424"),
            pos = "leftBottom",
            event = GuideNext
        },
        {
            "guide",
            path = "GameManager/Camera/mainUI/center/Module_main_menu/main_menu/top_menu/ButtonMenu_new/btn_list/btn_item_right/btn_chaungguan",
            say = "",
            pos = "leftTop",
            event = GuideNext
        },
        { "end" },
    },
    duobao = {
        --夺宝
        { "sleep", 10 },
        { "talk", true,"player",TextMap.GetValue("Text_1_441"), 30 ,false,"map_c_008_s"},
        { "talk", false,TextMap.GetValue("Text_1_382"),TextMap.GetValue("Text_1_442"), 30 ,false,"map_c_008_s"},
        { "talk", true,"player",TextMap.GetValue("Text_1_443"), 30 ,false,"map_c_008_s"},
        { "talk", false,TextMap.GetValue("Text_1_382"),TextMap.GetValue("Text_1_444"), 30 ,false,"map_c_008_s"},
        { 
            "guide", 
            path = "GameManager/Camera/mainUI/center/Module_main_menu/main_menu/top_menu/ButtonMenu_new/btn_list/btn_item_left/btn_zhengzhan", 
            say = TextMap.GetValue("Text_1_445"),
            pos = "rightTop", 
            event = "GuideNext"
        },
        {
            "callFunc", 
            function()
            Api:setGuide("duobao", 2, function() end)
        end
        },
        { 
            "guide", 
            path = "GameManager/Camera/mainUI/center/Module_fighting_main/fighting_main/scrollView/view/Content/0", 
            say = TextMap.GetValue("Text_1_446"),
            pos = "rightTop", 
            event = "GuideNext"
        },
        { 
            "guide", 
            path = "GameManager/Camera/mainUI/center/Module_indiana_main/indiana_main/right/piece_2", 
            say = TextMap.GetValue("Text_1_447"),
            pos = "bottom", 
            event = "logic.treasureHandler.getRobList"
        },
        { "wait", IndianaDrag },
        {
            "guide",
            path = "GameManager/Camera/mainUI/center/Module_indiana_list/indiana_list/scrollview/Scroll View/Content/2/btn_rob_one",
            say = TextMap.GetValue("Text_1_448"),
            pos = "leftBottom",
            event = GuideNext
        },
        {"wait" ,BattleWinClose},
        {
            "guide",
            path = "GameManager/Camera/mainUI/center/Module_indiana_list/top_layer/indiana_battle_result/card_2",
            say = "",
            pos = "leftTop",
            event = GuideNext
        },
        {
            "callFunc", function()
            local go = GameObject.Find("GameManager/Camera/mainUI/center/Module_indiana_list/top_layer/indiana_battle_result/card_2")
            if go then
                print (TextMap.GetValue("Text_1_449"))
            else 
                if GuideMrg:isPlaying() then 
                    Messenger.Broadcast('BattleWinClose')--新手引导的监听
                end
            end
        end
        },
        { "wait", BattleWinClose},
        {
            "guide",
            path = "GameManager/Camera/mainUI/center/Module_indiana_list/indiana_list/gui_top_title/btnBack",
            say = "",
            pos = "leftBottom",
            event = GuideNext
        },
        { "talk", true,"player",TextMap.GetValue("Text_1_450"), 30 ,false,"map_c_008_s"},
        { "talk", false,TextMap.GetValue("Text_1_382"),TextMap.GetValue("Text_1_451"), 30 ,false,"map_c_008_s"},
        { "talk", true,"player",TextMap.GetValue("Text_1_452"), 30 ,false,"map_c_008_s"},
        { "talk", false,TextMap.GetValue("Text_1_382"),TextMap.GetValue("Text_1_453"), 30 ,false,"map_c_008_s"},
        { "talk", false,TextMap.GetValue("Text_1_382"),TextMap.GetValue("Text_1_454"), 30 ,false,"map_c_008_s"},
        { "end" },
    },
    jinglian = {
        --装备精炼
        { "sleep", 10 },
        { "talk", false,TextMap.GetValue("Text_1_382"),TextMap.GetValue("Text_1_455"), 30 ,false,"map_c_008_s"},
        { "talk", true,"player",TextMap.GetValue("Text_1_456"), 30 ,false,"map_c_008_s"},
        { "talk", false,TextMap.GetValue("Text_1_382"),TextMap.GetValue("Text_1_457"), 30 ,false,"map_c_008_s"},
        { 
            "guide", 
            path = "GameManager/Camera/mainUI/center/Module_main_menu/main_menu/btns_hero/btn_zhuangbei", 
            say = TextMap.GetValue("Text_1_458"),
            pos = "leftBottom", 
            event = "GuideNext"
        },
        {
            "callFunc", 
            function()
            Api:setGuide("jinglian", 2, function() end)
        end
        },
        { 
            "guide", 
            path = "GameManager/Camera/mainUI/center/Module_gui_equip_panel/gui_equip_panel/scrollView_equip/Scroll View/Content/0/Grid/selectCharIcon1/button", 
            say = TextMap.GetValue("Text_1_459"),
            pos = "bottom", 
            event = "GuideNext"
        },
        { 
            "guide", 
            path = "GameManager/Camera/mainUI/center/Module_ghost_list_new/ghost_list_new/leftButton/btn_jinglian/btn_jinglian_down", 
            say = TextMap.GetValue("Text_1_460"),
            pos = "right", 
            event = "GuideNext"
        },
        { 
            "guide", 
            path = "GameManager/Camera/mainUI/center/Module_ghost_list_new/ghost_list_new/tab/Container/info/jinhua/Bottom_bg/btn_jinjie", 
            say = "",
            pos = "leftTop", 
            event = "GuideNext"
        },
        {
            "guide",
            path = "GameManager/Camera/mainUI/center/Module_ghost_list_new/ghost_list_new/gui_top_title/btnBack",
            say = TextMap.GetValue("Text_1_424"),
            pos = "leftBottom",
            event = GuideNext
        },
        {
            "guide",
            path = "GameManager/Camera/mainUI/center/Module_gui_equip_panel/gui_equip_panel/gui_top_title/btnBack",
            say = "",
            pos = "leftBottom",
            event = GuideNext
        },
        {
            "guide",
            path = "GameManager/Camera/mainUI/center/Module_main_menu/main_menu/top_menu/ButtonMenu_new/btn_list/btn_item_right/btn_chaungguan",
            say = "",
            pos = "leftTop",
            event = GuideNext
        },
        { "end" },
    },

    chapter1 = {
        { "text", {TextMap.GetValue("Text_1_461")},1,50 ,log = "0-0" },
    },
    chapter2 = {
        { "text", {TextMap.GetValue("Text_1_464")},1,50 ,log = "0-0" },
    },
    chapter3 = {
        { "text", {TextMap.GetValue("Text_1_467")},1,50 ,log = "0-0" },
    },
    chapter4 = {
        { "text", {TextMap.GetValue("Text_1_469")},1,50 ,log = "0-0" },
    },
    chapter5 = {
        { "text", {TextMap.GetValue("Text_1_471")},1,50 ,log = "0-0" },
    },
    chapter6 = {
        { "text", {TextMap.GetValue("Text_1_474")},1,50 ,log = "0-0" },
    },
    chapter7 = {
        { "text", {TextMap.GetValue("Text_1_477")},1,50 ,log = "0-0" },
    },
    chapter8 = {
        { "text", {TextMap.GetValue("Text_1_480")},1,50 ,log = "0-0" },
    },
    chapter9 = {
        { "text", {TextMap.GetValue("Text_1_484")},1,50 ,log = "0-0" },
    },
    chapter10 = {
        { "text", {TextMap.GetValue("Text_1_486")},1,50 ,log = "0-0" },
    },
	chapter11 = {
        { "text", {TextMap.GetValue("Text_1_489")},1,50 ,log = "0-0" },
    },
	chapter12 = {
        { "text", {TextMap.GetValue("Text_1_492")},1,50 ,log = "0-0" },
    },
	chapter13 = {
        { "text", {TextMap.GetValue("Text_1_495")},1,50 ,log = "0-0" },
    },
	chapter14 = {
        { "text", {TextMap.GetValue("Text_1_498")},1,50 ,log = "0-0" },
    },
	chapter15 = {
        { "text", {TextMap.GetValue("Text_1_501")},1,50 ,log = "0-0" },
    },
	chapter16 = {
        { "text", {TextMap.GetValue("Text_1_504")},1,50 ,log = "0-0" },
    },
	chapter17 = {
        { "text", {TextMap.GetValue("Text_1_507")},1,50 ,log = "0-0" },
    },
	chapter18 = {
        { "text", {TextMap.GetValue("Text_1_510")},1,50 ,log = "0-0" },
    },
	chapter19 = {
        { "text", {TextMap.GetValue("Text_1_513")},1,50 ,log = "0-0" },
    },
	chapter20 = {
        { "text", {TextMap.GetValue("Text_1_516")},1,50 ,log = "0-0" },
    },
	chapter21 = {
        { "text", {TextMap.GetValue("Text_1_519")},1,50 ,log = "0-0" },
    },
	chapter22 = {
        { "text", {TextMap.GetValue("Text_1_522")},1,50 ,log = "0-0" },
    },
	chapter23 = {
        { "text", {TextMap.GetValue("Text_1_527")},1,50 ,log = "0-0" },
    },
	chapter24 = {
        { "text", {TextMap.GetValue("Text_1_530")},1,50 ,log = "0-0" },
    },
	chapter25 = {
        { "text", {TextMap.GetValue("Text_1_533")},1,50 ,log = "0-0" },
    },
	chapter26 = {
        { "text", {TextMap.GetValue("Text_1_536")},1,50 ,log = "0-0" },
    },
	chapter27 = {
        { "text", {TextMap.GetValue("Text_1_539")},1,50 ,log = "0-0" },
    },
	chapter28 = {
        { "text", {TextMap.GetValue("Text_1_542")},1,50 ,log = "0-0" },
    },
	chapter29 = {
        { "text", {TextMap.GetValue("Text_1_545")},1,50 ,log = "0-0" },
    },
	chapter30 = {
        { "text", {TextMap.GetValue("Text_1_548")},1,50 ,log = "0-0" },
    },
	chapter31 = {
        { "text", {TextMap.GetValue("Text_1_551")},1,50 ,log = "0-0" },
    },
	chapter32 = {
        { "text", {TextMap.GetValue("Text_1_554")},1,50 ,log = "0-0" },
    },
	chapter33 = {
        { "text", {TextMap.GetValue("Text_1_558")},1,50 ,log = "0-0" },
    },
	chapter34 = {
        { "text", {TextMap.GetValue("Text_1_561")},1,50 ,log = "0-0" },
    },
	chapter35 = {
        { "text", {TextMap.GetValue("Text_1_564")},1,50 ,log = "0-0" },
    },
	chapter36 = {
        { "text", {TextMap.GetValue("Text_1_568")},1,50 ,log = "0-0" },
    },
	chapter37 = {
        { "text", {TextMap.GetValue("Text_1_572")},1,50 ,log = "0-0" },
    },
	chapter38 = {
        { "text", {TextMap.GetValue("Text_1_576")},1,50 ,log = "0-0" },
    },
	chapter39 = {
        { "text", {TextMap.GetValue("Text_1_580")},1,50 ,log = "0-0" },
    },
	chapter40 = {
        { "text", {TextMap.GetValue("Text_1_583")},1,50 ,log = "0-0" },
    },
	chapter41 = {
        { "text", {TextMap.GetValue("Text_1_587")},1,50 ,log = "0-0" },
    },
	chapter42 = {
        { "text", {TextMap.GetValue("Text_1_591")},1,50 ,log = "0-0" },
    },
	chapter43 = {
        { "text", {TextMap.GetValue("Text_1_594")},1,50 ,log = "0-0" },
    },
	chapter44 = {
        { "text", {TextMap.GetValue("Text_1_597")},1,50 ,log = "0-0" },
    },
	chapter45 = {
        { "text", {TextMap.GetValue("Text_1_600")},1,50 ,log = "0-0" },
    },
	chapter46 = {
        { "text", {TextMap.GetValue("Text_1_603")},1,50 ,log = "0-0" },
    },
	chapter47 = {
        { "text", {TextMap.GetValue("Text_1_606")},1,50 ,log = "0-0" },
    },	
	chapter48 = {
        { "text", {TextMap.GetValue("Text_1_609")},1,50 ,log = "0-0" },
    },
	chapter49 = {
        { "text", {TextMap.GetValue("Text_1_612")},1,50 ,log = "0-0" },
    },
	chapter50 = {
        { "text", {TextMap.GetValue("Text_1_615")},1,50 ,log = "0-0" },
    },
	chapter51 = {
        { "text", {TextMap.GetValue("Text_1_618")},1,50 ,log = "0-0" },
    },
	chapter52 = {
        { "text", {TextMap.GetValue("Text_1_621")},1,50 ,log = "0-0" },
    },
	chapter53 = {
        { "text", {TextMap.GetValue("Text_1_624")},1,50 ,log = "0-0" },
    },
	chapter54 = {
        { "text", {TextMap.GetValue("Text_1_627")},1,50 ,log = "0-0" },
    },
	chapter55 = {
        { "text", {TextMap.GetValue("Text_1_630")},1,50 ,log = "0-0" },
    },
	chapter56 = {
        { "text", {TextMap.GetValue("Text_1_633")},1,50 ,log = "0-0" },
    },
	chapter57 = {
        { "text", {TextMap.GetValue("Text_1_636")},1,50 ,log = "0-0" },
    },
	chapter58 = {
        { "text", {TextMap.GetValue("Text_1_639")},1,50 ,log = "0-0" },
    },
	chapter59 = {
        { "text", {TextMap.GetValue("Text_1_642")},1,50 ,log = "0-0" },
    },
	chapter60 = {
        { "text", {TextMap.GetValue("Text_1_645")},1,50 ,log = "0-0" },
    },
	chapter61 = {
        { "text", {TextMap.GetValue("Text_1_648")},1,50 ,log = "0-0" },
    },
	chapter62 = {
        { "text", {TextMap.GetValue("Text_1_651")},1,50 ,log = "0-0" },
    },
	chapter63 = {
        { "text", {TextMap.GetValue("Text_1_654")},1,50 ,log = "0-0" },
    },
	chapter64 = {
        { "text", {TextMap.GetValue("Text_1_657")},1,50 ,log = "0-0" },
    },
	chapter65 = {
        { "text", {TextMap.GetValue("Text_1_660")},1,50 ,log = "0-0" },
    },
	chapter66 = {
        { "text", {TextMap.GetValue("Text_1_663")},1,50 ,log = "0-0" },
    },
	chapter67 = {
        { "text", {TextMap.GetValue("Text_1_666")},1,50 ,log = "0-0" },
    },
	chapter68 = {
        { "text", {TextMap.GetValue("Text_1_669")},1,50 ,log = "0-0" },
    },
	chapter69 = {
        { "text", {TextMap.GetValue("Text_1_672")},1,50 ,log = "0-0" },
    },
	chapter70 = {
        { "text", {TextMap.GetValue("Text_1_675")},1,50 ,log = "0-0" },
    },
	chapter71 = {
        { "text", {TextMap.GetValue("Text_1_678")},1,50 ,log = "0-0" },
    },
	chapter72 = {
        { "text", {TextMap.GetValue("Text_1_681")},1,50 ,log = "0-0" },
    },
	chapter73 = {
        { "text", {TextMap.GetValue("Text_1_684")},1,50 ,log = "0-0" },
    },
	chapter74 = {
        { "text", {TextMap.GetValue("Text_1_687")},1,50 ,log = "0-0" },
    },
	chapter75 = {
        { "text", {TextMap.GetValue("Text_1_690")},1,50 ,log = "0-0" },
    },
	chapter76 = {
        { "text", {TextMap.GetValue("Text_1_693")},1,50 ,log = "0-0" },
    },
	chapter77 = {
        { "text", {TextMap.GetValue("Text_1_696")},1,50 ,log = "0-0" },
    },
	chapter78 = {
        { "text", {TextMap.GetValue("Text_1_699")},1,50 ,log = "0-0" },
    },
	chapter79 = {
        { "text", {TextMap.GetValue("Text_1_702")},1,50 ,log = "0-0" },
    },
	chapter80 = {
        { "text", {TextMap.GetValue("Text_1_705")},1,50 ,log = "0-0" },
    },
	chapter81 = {
        { "text", {TextMap.GetValue("Text_1_708")},1,50 ,log = "0-0" },
    },
	chapter82 = {
        { "text", {TextMap.GetValue("Text_1_711")},1,50 ,log = "0-0" },
    },
	chapter83 = {
        { "text", {TextMap.GetValue("Text_1_714")},1,50 ,log = "0-0" },
    },
	chapter84 = {
        { "text", {TextMap.GetValue("Text_1_717")},1,50 ,log = "0-0" },
    },
	chapter85 = {
        { "text", {TextMap.GetValue("Text_1_720")},1,50 ,log = "0-0" },
    },
	chapter86 = {
        { "text", {TextMap.GetValue("Text_1_723")},1,50 ,log = "0-0" },
    },
	chapter87 = {
        { "text", {TextMap.GetValue("Text_1_726")},1,50 ,log = "0-0" },
    },
	chapter88 = {
        { "text", {TextMap.GetValue("Text_1_729")},1,50 ,log = "0-0" },
    },
	chapter89 = {
        { "text", {TextMap.GetValue("Text_1_732")},1,50 ,log = "0-0" },
    },
	chapter90 = {
        { "text", {TextMap.GetValue("Text_1_735")},1,50 ,log = "0-0" },
    },
	chapter91 = {
        { "text", {TextMap.GetValue("Text_1_738")},1,50 ,log = "0-0" },
    },
	chapter92 = {
        { "text", {TextMap.GetValue("Text_1_741")},1,50 ,log = "0-0" },
    },
	chapter93 = {
        { "text", {TextMap.GetValue("Text_1_744")},1,50 ,log = "0-0" },
    },
	chapter94 = {
        { "text", {TextMap.GetValue("Text_1_747")},1,50 ,log = "0-0" },
    },
	chapter95 = {
        { "text", {TextMap.GetValue("Text_1_750")},1,50 ,log = "0-0" },
    },
	chapter96 = {
        { "text", {TextMap.GetValue("Text_1_753")},1,50 ,log = "0-0" },
    },
	chapter97 = {
        { "text", {TextMap.GetValue("Text_1_756")},1,50 ,log = "0-0" },
    },
	chapter98 = {
        { "text", {TextMap.GetValue("Text_1_759")},1,50 ,log = "0-0" },
    },
	chapter99 = {
        { "text", {TextMap.GetValue("Text_1_762")},1,50 ,log = "0-0" },
    },
	chapter100 = {
        { "text", {TextMap.GetValue("Text_1_765")},1,50 ,log = "0-0" },
    },
    --[[step1 = {
        { "wait", EndPlot, log = "0-0"  },
        { "jump", "zeroChapter", "Prefabs/moduleFabs/zeroChapter/chapterXuModule", "", {} },
        { "sleep", 200 },
        {
            "guide",
            path = "GameManager/Camera/mainUI/center/Module_chapterXuModule/chapterXuModule/clipPanel/2/simpleImage",
            say = TextMap.GetValue("Text1499"),
            pos = "top",
            event = GuideNext
        },
        { "save", log = "0-1" },
        { "wait", BattleWin },
        { "sleep", 2500 },
        {
            "guide",
            path = "GameManager/Camera/mainUI/center/Module_blood_words/blood_words/battle_win_new1/backgroundroot/dikuang/btn_select",
            call = function(go)
                UIMrg:pop()
                Messenger.BroadcastObject(GuideNext, go)
            end,
            say = TextMap.GetValue("Text1500"),
            pop = "left",
            event = GuideNext
        },
        { "call", "step2", 1, log = "0-2" }
    },
    step2 = {
        { "jump", "zeroChapter", "Prefabs/moduleFabs/zeroChapter/chapterXuModule", "", {} },
        {
            "guide",
            path = "GameManager/Camera/mainUI/center/Module_chapterXuModule/chapterXuModule/clipPanel/2/two",
            say = TextMap.GetValue("Text1501"),
            pos = "top",
            event = GuideNext
        },
        { "wait", EndPlot, log = "0-3" },
        { "save" },
        { "sleep", 100 },
        { "call", "step3" }
    },
    step3 = {
        { "jump", "ChangeName", "Prefabs/publicPrefabs/bgBlack", "push", {} },
        { "talk", true, TextMap.GetValue("Text1502"), TextMap.GetValue("Text1503"), "full_heiqiyihu_b" },
        { "talk", false, TextMap.GetValue("Text1504"), TextMap.GetValue("Text1505"), "full_puyuanxizhu_b" },
        { "talk", false, TextMap.GetValue("Text1504"), TextMap.GetValue("Text1506"), "full_puyuanxizhu_b" },
        { "talk", true, TextMap.GetValue("Text1502"), "??...", "full_heiqiyihu_b" },
        { "talk", false, TextMap.GetValue("Text1504"), TextMap.GetValue("Text1507"), "full_puyuanxizhu_b" },
        {
            "jump",
            "changeName",
            "Prefabs/moduleFabs/userinfoModule/changeName",
            "window",
            {
                isFirst  = true,
                onClose = function()
                    UIMrg:pop()
                    RotateCamera.canMove = false
                    Messenger.Broadcast(ChangeName)
                end
            }
        },
        { "wait", ChangeName },
        { "save", log = "0-4" },
        { "call", "step4" }
    },
    step4 = {
        --闯关1
        { "scene", "main_scene" },
        {
            "wait", MainSceneInit, function(go)
            RotateCamera.canMove = false
            print(".........")
            Messenger.RemoveListenerObject(MainSceneInit)
            GuideMrg.CallNextStep()
        end
        },
        { "sleep", 100 },
        { "talk", false, TextMap.GetValue("Text1504"), TextMap.GetValue("Text1508"), "full_puyuanxizhu_b" },
        { "sleep", 400 },
        { "guide", path = "main_scene/scene/new_ZhuJieMian/GuanKa", say = TextMap.GetValue("Text1509"), pos = "bottom", event = ClickBuild, log = "1-1" },
        { "sleep", 200, log = "1-2" },
        {
            "guide",
            path = "GameManager/Camera/mainUI/center/Module_chapterModule/chapterModule/clipPanel/movePanel/1/chapterPage/grid1/simpleImage",
            say = TextMap.GetValue("Text1499"),
            pos = "top",
            event = "ClickCpapter",
            condition = function()
                if Player.Info.level > 1 then return false end
                print("Player.Chapter.lastChapter->" .. Player.Chapter.lastChapter)
                print("Player.Chapter.lastSection->" .. Player.Chapter.lastSection)
                return true
            end
        },
        { "guide", path = "GameManager/Camera/mainUI/center/Module_chapterFight/chapterFight/content/challengeBtn", say = TextMap.GetValue("Text1510"), pos = "left", event = "logic.chapterHandler.fightChapter", log = "1-3" }, --等待挑战返回
        { "save", log = "1-4" },
        { "wait", BattleWin },
        { "wait", CloseLevelUp },
        { "guide", path = "GameManager/Camera/mainUI/center/Module_blood_words/blood_words/battle_win_new1/btn_quit", say = TextMap.GetValue("Text1511"), pos = "leftBottom", event = "GuideNext" },
        { "sleep", 400, log = "1-5" },
        { "guide", path = "GameManager/Camera/mainUI/top_menu/bg/Panel/btn_close", say = TextMap.GetValue("Text1511"), pos = "leftBottom", event = "GuideNext" },
        { "talk", false, TextMap.GetValue("Text1512"), TextMap.GetValue("Text1513"), "full_luqiya_b", log = "1-6"  },
        { "talk", true, TextMap.GetValue("Text1502"), "......", "full_heiqiyihu_b" },
        { "talk", false, TextMap.GetValue("Text1512"), TextMap.GetValue("Text1514"), "full_luqiya_b", log = "2-1" },
        { "call", "step5" }
    },
    step5 = {
        --召唤1
        { "sleep", 200 },
        { "guide", path = "main_scene/scene/new_ZhuJieMian/ZhaoHuang", say = TextMap.GetValue("Text1515"), pos = "bottom", event = "ClickBuild" },
        {
            "guide",
            path = "GameManager/Camera/mainUI/center/Module_summon/summon/BlockSecond/btnSpSummon",
            say = TextMap.GetValue("Text1516"),
            pos = "left",
            event = "logic.drawHandler.draw",
            call = function(go)
                Api:draw(8, function(result)
                    Messenger.BroadcastObject(GuideNext, go)
                    PlayerPrefs.SetInt(Player.playerId.."_guide_"..0, 5)
                    local lua = {
                        result = result,
                        cbAgin = function() end,
                        darw_id = 5,
                        cost_type = "gold",
                        cost = 280
                    }
                    UIMrg:CallRunnigModuleFunctionWithArgs("hideOrShowEffect", { false })
                    UIMrg:pushWindow("Prefabs/moduleFabs/choukaModule/RewardItem", lua)
                end,function(ret)
                     if ret == 54 then 
                        local api = "logic.drawHandler.draw"
                        Messenger.BroadcastObject(api, api)
                    end
                    return true
                end)
            end,
            condition = function()
                if Player.Info.level ~= 2 then return false end
                local chars = Player.Chars:getLuaTable()
                if chars["25"] then return false end
                return true
            end, log = "2-2"
        },
        { "save", log = "2-3" },
        { "guide", path = "GameManager/Camera/mainUI/center/Module_summon/top_layer/RewardItem/Panel/ani_show_button/btn_queding", say = TextMap.GetValue("Text1511"), pos = "top", event = "GuideNext" },
        { "guide", path = "GameManager/Camera/mainUI/top_menu/bg/Panel/btn_close", say = TextMap.GetValue("Text1511"), pos = "leftBottom", event = "GuideNext", log = "2-4" },
        { "talk", false, TextMap.GetValue("Text1517"), TextMap.GetValue("Text1518"), "full_chadutaihu_b", log = "2-5" },
        { "talk", false, TextMap.GetValue("Text1512"), TextMap.GetValue("Text1519"), "full_luqiya_b", log = "2-6" },
        { "call", "step6" }
    },
    step6 = {
        --上阵2
        { "sleep", 200, log = "3-1" },
        { "guide", path = "GameManager/Camera/mainUI/center/Module_main_menu/main_menu/top_menu/ButtonMenu_new/btn_list/btn_item_bottom/btn_team", say = TextMap.GetValue("Text1520"), pos = "top", event = "GuideNext" },
        { "sleep", 200, log = "3-2" },
        { "guide", path = "GameManager/Camera/mainUI/center/Module_formation_main/formation_main/bg/frame_bg/hero_list/Scroll View/Content/icon2", say = TextMap.GetValue("Text1521"), pos = "right", 
            event = "GuideNext",
            condition = function()
                local teams = Player.Team[0].chars
                local ret = false
                if teams.Count < 3 then ret = true end
                if teams[2] == "0" or teams[2] == 0 then ret = true end
                if ret then 
                    local chars = Player.Chars:getLuaTable()
                    if chars["25"] == nil then 
                        ret = false
                    end
                end
                return ret
            end 
        },
        { "sleep", 200, log = "3-3" },
        { "guide", path = "GameManager/Camera/mainUI/center/Module_formation_main/top_layer/formation_select_char/scrollView/Scroll View/Content/0/Grid/selectCharCell1", say = TextMap.GetValue("Text1522"), pos = "right", event = "logic.chapterHandler.saveTeam" },
        { "save", log = "3-4" },
        { "sleep", 200 },
        { "guide", path = "GameManager/Camera/mainUI/top_menu/bg/Panel/btn_close", say = TextMap.GetValue("Text1511"), pos = "leftBottom", event = "GuideNext" },
        { "call", "step7", log = "3-5" }
    },
    step7 = {
        --闯关2
        { "sleep", 200 },
        { "guide", path = "main_scene/scene/new_ZhuJieMian/GuanKa", say = TextMap.GetValue("Text1509"), pos = "bottom", event = "ClickBuild" },
        { "sleep", 200, log = "3-6" },
        { 
            "guide", 
            path = "GameManager/Camera/mainUI/center/Module_chapterModule/chapterModule/clipPanel/movePanel/1/chapterPage/grid2/simpleImage", 
            say = TextMap.GetValue("Text1501"), 
            pos = "top", 
            event = "ClickCpapter",
            
            condition = function()
                if Player.Info.level ~= 2 then return false end
                if Player.Chapter.lastChapter >=1 and Player.Chapter.lastSection >= 2 then
                    return true
                end
                print("Player.Chapter.lastChapter->" .. Player.Chapter.lastChapter)
                print("Player.Chapter.lastSection->" .. Player.Chapter.lastSection)
                return false
            end
        },
        { "sleep", 200,log = "3-7", },
        { "guide", path = "GameManager/Camera/mainUI/center/Module_chapterFight/chapterFight/content/challengeBtn", say = TextMap.GetValue("Text1510"), pos = "left", event = "logic.chapterHandler.fightChapter" },
        { "save", log = "3-8" },
        { "wait", CloseLevelUp },
        { "guide", path = "GameManager/Camera/mainUI/center/Module_blood_words/blood_words/battle_win_new1/btn_quit", say = TextMap.GetValue("Text1511"), pos = "leftBottom", event = "GuideNext" },
        { "sleep", 400, log = "3-9" },
        { "guide", path = "GameManager/Camera/mainUI/top_menu/bg/Panel/btn_close", say = TextMap.GetValue("Text1511"), pos = "leftBottom", event = "GuideNext"},
        { "sleep", 200, log = "3-10"  },
        { "talk", false, TextMap.GetValue("Text1512"), TextMap.GetValue("Text1523"), "full_luqiya_b" },
        { "call", "step8", log = "4-1" }
    },
    step8 = {
        --升级1
        { "guide", path = "GameManager/Camera/mainUI/center/Module_main_menu/main_menu/top_menu/ButtonMenu_new/btn_list/btn_item_bottom/btn_buxia", say = TextMap.GetValue("Text1524"), pos = "top", event = "GuideNext" },
        { "sleep", 200, log = "4-2" },
        { "guide", path = "GameManager/Camera/mainUI/center/Module_hero_select_char/hero_select_char/scrollView/Scroll View/Content/0/Grid/selectCharIcon1/button", say = TextMap.GetValue("Text1525"), pos = "top", event = "GuideNext" },
        { "sleep", 500, log = "4-3" },
        { "talk", false, TextMap.GetValue("Text1512"), TextMap.GetValue("Text1526"), "full_luqiya_b", true },
        { "talk", false, TextMap.GetValue("Text1512"), TextMap.GetValue("Text1527"), "full_luqiya_b", true, log = "4-4" },
        {   
            "guide", 
            path = "GameManager/Camera/mainUI/center/Module_newHero/newHero/heroEquip/Container/hero_info/btnLvUp", 
            say = TextMap.GetValue("Text1528"), 
            pos = "top", 
            event = "logic.trainHandler.charLevelUp", 
            log = "4-5",
            condition = function()
                local char = Char:new(19)
                local ret = Player.Resource.max_char_lv > char.lv and char:expInfo().value >= 1
                return ret
            end
        },
        { "save", log = "4-6" },
        { "call", "step9", 5 }
    },
    step9 = {
        --升级2
        { "sleep", 200 },
        { "guide", path = "GameManager/Camera/mainUI/center/Module_main_menu/main_menu/top_menu/ButtonMenu_new/btn_list/btn_item_bottom/btn_buxia", say = TextMap.GetValue("Text1524"), pos = "top", event = "GuideNext" },
        { "sleep", 200 },
        { "guide", path = "GameManager/Camera/mainUI/center/Module_hero_select_char/hero_select_char/scrollView/Scroll View/Content/0/Grid/selectCharIcon1/button", say = TextMap.GetValue("Text1525"), pos = "top", event = "GuideNext" },
        { "sleep", 200 },
        {   
            "guide", 
            path = "GameManager/Camera/mainUI/center/Module_newHero/newHero/heroEquip/Container/hero_info/btnLvUp", 
            say = TextMap.GetValue("Text1528"), 
            pos = "top", 
            event = "logic.trainHandler.charLevelUp",
            condition = function()
                local char = Char:new(19)
                local ret = Player.Resource.max_char_lv > char.lv and char:expInfo().value >= 1
                return ret
            end
        },
        { "save", log = "4-7" },
        { "call", "step10", 6 }
    },
    step10 = {
        --装备1
        { "sleep", 200 },
        { "guide", path = "GameManager/Camera/mainUI/center/Module_main_menu/main_menu/top_menu/ButtonMenu_new/btn_list/btn_item_bottom/btn_buxia", say = TextMap.GetValue("Text1524"), pos = "top", event = "GuideNext" },
        { "sleep", 200 },
        { "guide", path = "GameManager/Camera/mainUI/center/Module_hero_select_char/hero_select_char/scrollView/Scroll View/Content/0/Grid/selectCharIcon1/button", say = TextMap.GetValue("Text1525"), pos = "top", event = "GuideNext" },
        { "sleep", 200 },
        { "talk", false, TextMap.GetValue("Text1512"), TextMap.GetValue("Text1529"), "full_luqiya_b", true },
        { "talk", false, TextMap.GetValue("Text1512"), TextMap.GetValue("Text1530"), "full_luqiya_b", true, log = "4-8" },
        { 
            "guide", 
            path = "GameManager/Camera/mainUI/center/Module_newHero/newHero/heroEquip/Container/equips/cell0", 
            say = TextMap.GetValue("Text1531"), 
            pos = "left", 
            event = "GuideNext", 
            log = "4-9",
            condition = function()
                local char = Char:new(19)
                local equips = char:getEquips()
                local equip1 = equips[1]
                equip1:updateInfo()
                local state = equip1:getState()
                local ret = false
                if (state == ITEM_STATE.can) then
                    ret = true
                end
                return ret
            end
        },
        { "guide", path = "GameManager/Camera/mainUI/center/Module_newHero/top_layer/equip_info/root/left_frame/button", say = TextMap.GetValue("Text1532"), pos = "left", event = "logic.equipHandler.wearEquip", log = "4-10" },
        { "save", log = "4-11" },
        { "call", "step11", 6 }
    },
    step11 = {
        --装备2
        { "sleep", 200 },
        { "guide", path = "GameManager/Camera/mainUI/center/Module_main_menu/main_menu/top_menu/ButtonMenu_new/btn_list/btn_item_bottom/btn_buxia", say = TextMap.GetValue("Text1524"), pos = "top", event = "GuideNext" },
        { "sleep", 200 },
        { "guide", path = "GameManager/Camera/mainUI/center/Module_hero_select_char/hero_select_char/scrollView/Scroll View/Content/0/Grid/selectCharIcon1/button", say = TextMap.GetValue("Text1525"), pos = "top", event = "GuideNext" },
        { "sleep", 200 },
        { 
            "guide", path = "GameManager/Camera/mainUI/center/Module_newHero/newHero/heroEquip/Container/equips/cell1", say = TextMap.GetValue("Text1533"), pos = "left", 
            event = "GuideNext",
            condition = function()
                local char = Char:new(19)
                local equips = char:getEquips()
                local equip1 = equips[2]
                equip1:updateInfo()
                local state = equip1:getState()
                local ret = false
                if (state == ITEM_STATE.can) then
                    ret = true
                end
                return ret
            end
        },
        { "guide", path = "GameManager/Camera/mainUI/center/Module_newHero/top_layer/equip_info/root/left_frame/button", say = TextMap.GetValue("Text1532"), pos = "left", event = "logic.equipHandler.wearEquip", log = "4-12" },
        { "save", log = "4-13" },
        { "talk", false, TextMap.GetValue("Text1512"), TextMap.GetValue("Text1534"), "full_luqiya_b", true },
        { "guide", path = "GameManager/Camera/mainUI/top_menu/bg/Panel/btn_close", say = TextMap.GetValue("Text1511"), pos = "leftBottom", event = "GuideNext", log = "4-14" },
        { "guide", path = "GameManager/Camera/mainUI/top_menu/bg/Panel/btn_close", say = TextMap.GetValue("Text1511"), pos = "leftBottom", event = "GuideNext", log = "4-15" },
        { "call", "step12", log = "4-16" }
    },
    step12 = {
        --闯关3,下一关
        { "sleep", 200 },
        { "guide", path = "main_scene/scene/new_ZhuJieMian/GuanKa", say = TextMap.GetValue("Text1509"), pos = "bottom", event = "ClickBuild", log = "4-17" },
        { "sleep", 200 },
        { 
            "guide", 
            path = "GameManager/Camera/mainUI/center/Module_chapterModule/chapterModule/clipPanel/movePanel/1/chapterPage/grid3/simpleImage", 
            say = TextMap.GetValue("Text1535"), 
            pos = "top", 
            event = "ClickCpapter",
            condition = function()
                if Player.Info.level ~= 3 then return false end
                if Player.Chapter.lastChapter >=1 and Player.Chapter.lastSection >= 3 then
                    return true
                end
                print("Player.Chapter.lastChapter->" .. Player.Chapter.lastChapter)
                print("Player.Chapter.lastSection->" .. Player.Chapter.lastSection)
                return false
            end
        },
        { "sleep", 200, log = "4-18" },
        { "guide", path = "GameManager/Camera/mainUI/center/Module_chapterFight/chapterFight/content/challengeBtn", say = TextMap.GetValue("Text1510"), pos = "left", event = "logic.chapterHandler.fightChapter" },
        { "save", log = "4-19" },
        { "wait", BattleWin },
        { "sleep", 3000 },
        { "guide", path = "GameManager/Camera/mainUI/center/Module_blood_words/blood_words/battle_win_new1/backgroundroot/dikuang/btn_select", say = TextMap.GetValue("Text1500"), pos = "left", event = "GuideNext" },
        { "call", "step13", 6, log = "4-20" }
    },
    step13 = {
        --闯关4
        { "sleep", 200 },
        { "guide", path = "main_scene/scene/new_ZhuJieMian/GuanKa", say = TextMap.GetValue("Text1509"), pos = "bottom", event = "ClickBuild" },
        { "sleep", 200 },
        { 
            "guide", 
            path = "GameManager/Camera/mainUI/center/Module_chapterModule/chapterModule/clipPanel/movePanel/1/chapterPage/grid4/simpleImage", 
            say = TextMap.GetValue("Text1536"), 
            pos = "top", 
            event = "ClickCpapter",
            condition = function()
                if Player.Info.level ~= 3 then return false end
                if Player.Chapter.lastChapter >=1 and Player.Chapter.lastSection >= 4 then
                    return true
                end
                print("Player.Chapter.lastChapter->" .. Player.Chapter.lastChapter)
                print("Player.Chapter.lastSection->" .. Player.Chapter.lastSection)
                return false
            end
        },
        { "sleep", 200 },
        { "guide", path = "GameManager/Camera/mainUI/center/Module_chapterFight/chapterFight/content/challengeBtn", say = TextMap.GetValue("Text1510"), pos = "left", event = "logic.chapterHandler.fightChapter" },
        { "save", log = "4-21" },
        { "wait", CloseLevelUp },
        { "guide", path = "GameManager/Camera/mainUI/center/Module_blood_words/blood_words/battle_win_new1/btn_quit", say = TextMap.GetValue("Text1511"), pos = "leftBottom", event = "GuideNext" },
        { "sleep", 400 , log = "4-22"},
        { "guide", path = "GameManager/Camera/mainUI/top_menu/bg/Panel/btn_close", say = TextMap.GetValue("Text1511"), pos = "leftBottom", event = "GuideNext" },
        { "call", "step14", log = "4-23" }
    },
    step14 = {
        --升级3
        { "sleep", 200 },
        { "talk", true, TextMap.GetValue("Text1502"), TextMap.GetValue("Text1537"), "full_heiqiyihu_b", log = "5-1" },
        { "talk", false, TextMap.GetValue("Text1512"), TextMap.GetValue("Text1538"), "full_luqiya_b", log = "5-2" },
        { "talk", false, TextMap.GetValue("Text1512"), TextMap.GetValue("Text1539"), "full_luqiya_b", log = "5-3" },
        { "guide", path = "GameManager/Camera/mainUI/center/Module_main_menu/main_menu/top_menu/ButtonMenu_new/btn_list/btn_item_bottom/btn_buxia", say = TextMap.GetValue("Text1524"), pos = "top", event = "GuideNext" },
        { "sleep", 200, log = "5-4" },
        { "guide", path = "GameManager/Camera/mainUI/center/Module_hero_select_char/hero_select_char/scrollView/Scroll View/Content/0/Grid/selectCharIcon1/button", say = TextMap.GetValue("Text1525"), pos = "top", event = "GuideNext" },
        { "sleep", 200, log = "5-5" },
        { 
            "guide", 
            path = "GameManager/Camera/mainUI/center/Module_newHero/newHero/heroEquip/Container/hero_info/btnLvUp", 
            say = TextMap.GetValue("Text1528"), 
            pos = "top", 
            event = "logic.trainHandler.charLevelUp",
            condition = function()
                local char = Char:new(19)
                local ret = Player.Resource.max_char_lv > char.lv and char:expInfo().value >= 1
                return ret
            end 
        },
        { "save" },
        { "call", "step15", 6 }
    },
    step15 = {
        --升级4
        { "sleep", 200 },
        { "guide", path = "GameManager/Camera/mainUI/center/Module_main_menu/main_menu/top_menu/ButtonMenu_new/btn_list/btn_item_bottom/btn_buxia", say = TextMap.GetValue("Text1524"), pos = "top", event = "GuideNext" },
        { "sleep", 200 },
        { "guide", path = "GameManager/Camera/mainUI/center/Module_hero_select_char/hero_select_char/scrollView/Scroll View/Content/0/Grid/selectCharIcon1/button", say = TextMap.GetValue("Text1525"), pos = "top", event = "GuideNext" },
        { "sleep", 200 },
        { 
            "guide", path = "GameManager/Camera/mainUI/center/Module_newHero/newHero/heroEquip/Container/hero_info/btnLvUp", 
            say = TextMap.GetValue("Text1528"), pos = "top", 
            event = "logic.trainHandler.charLevelUp",
            condition = function()
                local char = Char:new(19)
                local ret = Player.Resource.max_char_lv > char.lv and char:expInfo().value >= 1
                return ret
            end
        },
        { "save", log = "5-6" },
        { "call", "step16", 5 }
    },
    step16 = {
        --装备3
        { "sleep", 200 },
        { "guide", path = "GameManager/Camera/mainUI/center/Module_main_menu/main_menu/top_menu/ButtonMenu_new/btn_list/btn_item_bottom/btn_buxia", say = TextMap.GetValue("Text1524"), pos = "top", event = "GuideNext" },
        { "sleep", 200 },
        { "guide", path = "GameManager/Camera/mainUI/center/Module_hero_select_char/hero_select_char/scrollView/Scroll View/Content/0/Grid/selectCharIcon1/button", say = TextMap.GetValue("Text1525"), pos = "top", event = "GuideNext" },
        { "sleep", 200 },
        { "guide", path = "GameManager/Camera/mainUI/center/Module_newHero/newHero/heroEquip/Container/equips/cell2", say = TextMap.GetValue("Text1540"), pos = "left", event = "GuideNext", 
            log = "5-7",
            condition = function()
                local char = Char:new(19)
                local equips = char:getEquips()
                local equip1 = equips[3]
                equip1:updateInfo()
                local state = equip1:getState()
                local ret = false
                if (state == ITEM_STATE.can) then
                    ret = true
                end
                return ret
            end
        },
        { "guide", path = "GameManager/Camera/mainUI/center/Module_newHero/top_layer/equip_info/root/left_frame/button", say = TextMap.GetValue("Text1532"), pos = "left", event = "logic.equipHandler.wearEquip" },
        { "save" },
        { "call", "step17", 6 }
    },
    step17 = {
        --装备4
        { "sleep", 200 },
        { "guide", path = "GameManager/Camera/mainUI/center/Module_main_menu/main_menu/top_menu/ButtonMenu_new/btn_list/btn_item_bottom/btn_buxia", say = TextMap.GetValue("Text1524"), pos = "top", event = "GuideNext" },
        { "sleep", 200 },
        { "guide", path = "GameManager/Camera/mainUI/center/Module_hero_select_char/hero_select_char/scrollView/Scroll View/Content/0/Grid/selectCharIcon1/button", say = TextMap.GetValue("Text1525"), pos = "top", event = "GuideNext" },
        { "sleep", 200 },
        { 
            "guide", path = "GameManager/Camera/mainUI/center/Module_newHero/newHero/heroEquip/Container/equips/cell3", say = TextMap.GetValue("Text1541"), pos = "left", event = "GuideNext",
            condition = function()
                local char = Char:new(19)
                local equips = char:getEquips()
                local equip1 = equips[4]
                equip1:updateInfo()
                local state = equip1:getState()
                local ret = false
                if (state == ITEM_STATE.can) then
                    ret = true
                end
                return ret
            end
        },
        { "guide", path = "GameManager/Camera/mainUI/center/Module_newHero/top_layer/equip_info/root/left_frame/button", say = TextMap.GetValue("Text1532"), pos = "left", event = "logic.equipHandler.wearEquip" },
        { "save" },
        { "call", "step18", 6 }
    },
    step18 = {
        --装备5
        { "sleep", 200 },
        { "guide", path = "GameManager/Camera/mainUI/center/Module_main_menu/main_menu/top_menu/ButtonMenu_new/btn_list/btn_item_bottom/btn_buxia", say = TextMap.GetValue("Text1524"), pos = "top", event = "GuideNext" },
        { "sleep", 200 },
        { "guide", path = "GameManager/Camera/mainUI/center/Module_hero_select_char/hero_select_char/scrollView/Scroll View/Content/0/Grid/selectCharIcon1/button", say = TextMap.GetValue("Text1525"), pos = "top", event = "GuideNext" },
        { "sleep", 200 },
        { 
            "guide", path = "GameManager/Camera/mainUI/center/Module_newHero/newHero/heroEquip/Container/equips/cell4", say = TextMap.GetValue("Text1542"), pos = "left", 
            event = "GuideNext",
            condition = function()
                local char = Char:new(19)
                local equips = char:getEquips()
                local equip1 = equips[5]
                equip1:updateInfo()
                local state = equip1:getState()
                local ret = false
                if (state == ITEM_STATE.can) then
                    ret = true
                end
                return ret
            end
        },
        { "guide", path = "GameManager/Camera/mainUI/center/Module_newHero/top_layer/equip_info/root/left_frame/button", say = TextMap.GetValue("Text1532"), pos = "left", event = "logic.equipHandler.wearEquip" },
        { "save" },
        { "call", "step19", 6 }
    },
    step19 = {
        --装备六
        { "sleep", 200 },
        { "guide", path = "GameManager/Camera/mainUI/center/Module_main_menu/main_menu/top_menu/ButtonMenu_new/btn_list/btn_item_bottom/btn_buxia", say = TextMap.GetValue("Text1524"), pos = "top", event = "GuideNext" },
        { "sleep", 200 },
        { "guide", path = "GameManager/Camera/mainUI/center/Module_hero_select_char/hero_select_char/scrollView/Scroll View/Content/0/Grid/selectCharIcon1/button", say = TextMap.GetValue("Text1525"), pos = "top", event = "GuideNext" },
        { "sleep", 200 },
        { 
            "guide", path = "GameManager/Camera/mainUI/center/Module_newHero/newHero/heroEquip/Container/equips/cell5", say = TextMap.GetValue("Text1543"), pos = "left", 
            event = "GuideNext",
            condition = function()
                local char = Char:new(19)
                local equips = char:getEquips()
                local equip1 = equips[6]
                equip1:updateInfo()
                local state = equip1:getState()
                local ret = false
                if (state == ITEM_STATE.can) then
                    ret = true
                end
                return ret
            end
        },
        { "guide", path = "GameManager/Camera/mainUI/center/Module_newHero/top_layer/equip_info/root/left_frame/button", say = TextMap.GetValue("Text1532"), pos = "left", event = "logic.equipHandler.wearEquip" },
        { "save", log = "5-8" },
        { "talk", false, TextMap.GetValue("Text1512"), TextMap.GetValue("Text1544"), "full_luqiya_b", true, log = "5-9" },
        { "call", "step20", 6 }
    },
    step20 = {
        --突破
        { "sleep", 200 },
        { "guide", path = "GameManager/Camera/mainUI/center/Module_main_menu/main_menu/top_menu/ButtonMenu_new/btn_list/btn_item_bottom/btn_buxia", say = TextMap.GetValue("Text1524"), pos = "top", event = "GuideNext" },
        { "sleep", 200 },
        { "guide", path = "GameManager/Camera/mainUI/center/Module_hero_select_char/hero_select_char/scrollView/Scroll View/Content/0/Grid/selectCharIcon1/button", say = TextMap.GetValue("Text1525"), pos = "top", event = "GuideNext" },
        { "sleep", 200 },
        { "guide", path = "GameManager/Camera/mainUI/center/Module_newHero/newHero/heroEquip/Container/hero_info/btn_powerUp", say = TextMap.GetValue("Text1545"), pos = "top", 
            event = "GuideNext",
            condition = function()
                local char = Char:new(19)
                --可突破
                local charEquips = char.info.equip or {} --身上的装备
                local count = 0
                for i = 1, 6 do
                    local id = charEquips[i - 1].id
                    if (id and id ~= 0 and id ~= "0") then
                        count = count + 1
                    end
                end
                local ret = false
                if count == 6 and char:canPowerUp() then
                    ret = true
                else
                    GuideMrg.CallNextStep()
                    GuideMrg.CallNextStep()
                    GuideMrg.CallNextStep()
                end
                return ret
            end 
        },
        { "save", log = "5-10" },
        { "wait", ClosePowerUp },
        { "talk", false, TextMap.GetValue("Text1512"), TextMap.GetValue("Text1546"), "full_luqiya_b", true, log = "5-11" },
        { "guide", path = "GameManager/Camera/mainUI/top_menu/bg/Panel/btn_close", say = TextMap.GetValue("Text1511"), pos = "leftBottom", event = "GuideNext" },
        { "guide", path = "GameManager/Camera/mainUI/top_menu/bg/Panel/btn_close", say = TextMap.GetValue("Text1511"), pos = "leftBottom", event = "GuideNext", log = "5-12" },
        { "call", "step21", log = "5-13" }
    },
    step21 = {
        --闯关5,下一关
        { "sleep", 200 },
        { "guide", path = "main_scene/scene/new_ZhuJieMian/GuanKa", say = TextMap.GetValue("Text1509"), pos = "bottom", event = "ClickBuild" },
        { "sleep", 200 , log = "5-14"},
        { 
            "guide", 
            path = "GameManager/Camera/mainUI/center/Module_chapterModule/chapterModule/clipPanel/movePanel/1/chapterPage/grid5/simpleImage", 
            say = TextMap.GetValue("Text1547"), 
            pos = "top", 
            event = "ClickCpapter",
            condition = function()
                if Player.Info.level ~= 4 then return false end
                if Player.Chapter.lastChapter >=1 and Player.Chapter.lastSection >= 5 then
                    return true
                end
                print("Player.Chapter.lastChapter->" .. Player.Chapter.lastChapter)
                print("Player.Chapter.lastSection->" .. Player.Chapter.lastSection)
                return false
            end
        },
        { "sleep", 200, log = "5-15" },
        { "guide", path = "GameManager/Camera/mainUI/center/Module_chapterFight/chapterFight/content/challengeBtn", say = TextMap.GetValue("Text1510"), pos = "left", event = "logic.chapterHandler.fightChapter" },
        { "save" , log = "5-16"},
        { "wait", BattleWin },
        { "sleep", 3000 },
        { "guide", path = "GameManager/Camera/mainUI/center/Module_blood_words/blood_words/battle_win_new1/backgroundroot/dikuang/btn_select", say = TextMap.GetValue("Text1500"), pos = "left", event = "GuideNext" },
        { "call", "step22", 6, log = "5-17" }
    },
    step22 = {
        --闯关6
        { "sleep", 200 },
        { "guide", path = "main_scene/scene/new_ZhuJieMian/GuanKa", say = TextMap.GetValue("Text1509"), pos = "bottom", event = "ClickBuild" },
        { "sleep", 200 },
        { 
            "guide", 
            path = "GameManager/Camera/mainUI/center/Module_chapterModule/chapterModule/clipPanel/movePanel/1/chapterPage/grid6/simpleImage", 
            say = TextMap.GetValue("Text1548"), 
            pos = "top", 
            event = "ClickCpapter",
            condition = function()
                if Player.Chapter.lastChapter >=1 and Player.Chapter.lastSection >= 6 then
                    return true
                end
                print("Player.Chapter.lastChapter->" .. Player.Chapter.lastChapter)
                print("Player.Chapter.lastSection->" .. Player.Chapter.lastSection)
                return false
            end

        },
        { "sleep", 200 },
        { "guide", path = "GameManager/Camera/mainUI/center/Module_chapterFight/chapterFight/content/challengeBtn", say = TextMap.GetValue("Text1510"), pos = "left", event = "logic.chapterHandler.fightChapter" },
        { "save", log = "5-18",server = 1 },
        { "wait", CloseLevelUp },
        { "guide", path = "GameManager/Camera/mainUI/center/Module_blood_words/blood_words/battle_win_new1/btn_quit", say = TextMap.GetValue("Text1511"), pos = "leftBottom", event = "GuideNext"},
        { "sleep", 400, log = "5-19" ,server = 1 },
        { "call", "step23", 4 }
    },
    step23 = {
        --三星通关奖励
        { "sleep", 200 },
        { "guide", path = "main_scene/scene/new_ZhuJieMian/GuanKa", say = TextMap.GetValue("Text1509"), pos = "bottom", event = "ClickBuild" },
        { "sleep", 200 },
        { "talk", false, TextMap.GetValue("Text1504"), TextMap.GetValue("Text1549"), "full_puyuanxizhu_b", log = "6-1" ,server = 1},
        { "guide", path = "GameManager/Camera/mainUI/center/Module_chapterModule/chapterModule/bg/awardBtn", say = TextMap.GetValue("Text1550"), pos = "left", event = "GuideNext", log = "6-2",server = 1 },
        { "guide", path = "GameManager/Camera/mainUI/center/Module_chapterModule/top_layer/chapterbox/btn_queren", say = "", pos = "left", event = "logic.taskHandler.submitTask" },
        { "save", log = "6-3",server = 1 },
        { "guide", path = "GameManager/Camera/mainUI/top_menu/bg/Panel/btn_close", say = TextMap.GetValue("Text1511"), pos = "leftBottom", event = "GuideNext", log = "6-4",server = 1 },
        { "call", "step24" }
    },
    step24 = {
        --召唤2
        { "sleep", 200 },
        { "guide", path = "main_scene/scene/new_ZhuJieMian/ZhaoHuang", say = TextMap.GetValue("Text1515"), pos = "left", event = "ClickBuild", log = "6-5",server = 1 },
        {
            "guide",
            path = "GameManager/Camera/mainUI/center/Module_summon/summon/BlockFirst/btnNorSummon",
            say = TextMap.GetValue("Text1516"),
            pos = "right",
            event = "logic.drawHandler.draw",
            call = function(go)
                Api:draw(10, function(result)
                    PlayerPrefs.SetInt(Player.playerId.."_guide_"..0, 24)
                    Messenger.BroadcastObject(GuideNext, go)
                    local lua = {
                        result = result,
                        cbAgin = function() end,
                        darw_id = 5,
                        cost_type = "gold",
                        cost = 280
                    }
                    UIMrg:CallRunnigModuleFunctionWithArgs("hideOrShowEffect", { false })
                    UIMrg:pushWindow("Prefabs/moduleFabs/choukaModule/RewardItem", lua)
                end,function(ret)
                    if ret == 54 then 
                        local api = "logic.drawHandler.draw"
                        Messenger.BroadcastObject(api, api)
                    end
                    return true
                end)
            end,
            condition = function()
                local chars = Player.Chars:getLuaTable()
                if chars["52"] then return false end
                return true
            end
        },
        { "save", log = "7-1" ,server = 1},
        { "guide", path = "GameManager/Camera/mainUI/center/Module_summon/top_layer/RewardItem/Panel/ani_show_button/btn_queding", say = TextMap.GetValue("Text1511"), pos = "top", event = "GuideNext", log = "7-2",server = 1 },
        { "guide", path = "GameManager/Camera/mainUI/top_menu/bg/Panel/btn_close", say = TextMap.GetValue("Text1511"), pos = "leftBottom", event = "GuideNext", log = "7-3",server = 1 },
        { "call", "step25" }
    },
    step25 = {
        --上阵3
        { "sleep", 200 },
        { "guide", path = "GameManager/Camera/mainUI/center/Module_main_menu/main_menu/top_menu/ButtonMenu_new/btn_list/btn_item_bottom/btn_team", say = TextMap.GetValue("Text1520"), pos = "top", event = "GuideNext", log = "7-4",server = 1 },
        { "sleep", 200 },
        { 
            "guide", path = "GameManager/Camera/mainUI/center/Module_formation_main/formation_main/bg/frame_bg/hero_list/Scroll View/Content/icon3", say = TextMap.GetValue("Text1551"), pos = "right", event = "GuideNext", 
            log = "7-5",
            condition = function()
                local teams = Player.Team[0].chars
                local ret = false
                if teams.Count < 3 then ret = true end
                if teams[2] == "0" or teams[2] == 0 then ret = true end
                if ret then 
                    local chars = Player.Chars:getLuaTable()
                    if chars["52"] == nil then 
                        ret = false
                    end
                end
                return ret
            end,server = 1
        },
        { "sleep", 200 },
        { "guide", path = "GameManager/Camera/mainUI/center/Module_formation_main/top_layer/formation_select_char/scrollView/Scroll View/Content/0/Grid/selectCharCell1", say = TextMap.GetValue("Text1522"), pos = "right", event = "logic.chapterHandler.saveTeam" },
        { "save", log = "7-6" ,server = 1},
        { "sleep", 200 },
        { "guide", path = "GameManager/Camera/mainUI/top_menu/bg/Panel/btn_close", say = TextMap.GetValue("Text1511"), pos = "leftBottom", event = "GuideNext", log = "7-7",server = 1 },
        { "call", "step26" }
    },
    step26 = {
        --闯关7
        { "talk", false, TextMap.GetValue("Text1504"), TextMap.GetValue("Text1552"), "full_puyuanxizhu_b", log = "7-8",server = 1 },
        { "talk", false, TextMap.GetValue("Text1553"), TextMap.GetValue("Text1554"), "full_sifengyuanyeyi_b", log = "7-9" ,server = 1},
        { "guide", path = "main_scene/scene/new_ZhuJieMian/GuanKa", say = TextMap.GetValue("Text1509"), pos = "bottom", event = "ClickBuild" },
        { "sleep", 200, log = "7-10" ,server = 1},
        { 
            "guide", 
            path = "GameManager/Camera/mainUI/center/Module_chapterModule/chapterModule/clipPanel/movePanel/2/chapterPage/grid1/simpleImage", 
            say = TextMap.GetValue("Text1499"), 
            pos = "top", 
            event = "ClickCpapter", 
            
            condition = function()
                if Player.Chapter.lastChapter >=2 and Player.Chapter.lastSection >= 1 then
                    return true
                end
                print("Player.Chapter.lastChapter->" .. Player.Chapter.lastChapter)
                print("Player.Chapter.lastSection->" .. Player.Chapter.lastSection)
                return false
            end
        },
        { "sleep", 200 ,log = "7-11",server = 1},
        { "guide", path = "GameManager/Camera/mainUI/center/Module_chapterFight/chapterFight/content/challengeBtn", say = TextMap.GetValue("Text1510"), pos = "left", event = "logic.chapterHandler.fightChapter" },
        { "save", log = "7-12" ,server = 1},
        { "wait", BattleWin },
        { "sleep", 3000 },
        { "guide", path = "GameManager/Camera/mainUI/center/Module_blood_words/blood_words/battle_win_new1/btn_quit", say = TextMap.GetValue("Text1511"), pos = "leftBottom", event = "GuideNext" },
        { "sleep", 500 },
        { "guide", path = "GameManager/Camera/mainUI/top_menu/bg/Panel/btn_close", say = TextMap.GetValue("Text1511"), pos = "leftBottom", event = "GuideNext" },
        { "call", "step27" }
    },
    step27 = {
        { "sleep", 200 },
        { "guide", path = "GameManager/Camera/mainUI/center/Module_main_menu/main_menu/buttons/btn_chengjiu", say = TextMap.GetValue("Text1555"), pos = "left", event = "GuideNext" },
        { "sleep", 200, log = "8-1",server = 1 },
        { "guide", path = "GameManager/Camera/mainUI/center/Module_moduleTask/moduleTask/BlockLeft/bg_left/Scroll View/Content/1", say = TextMap.GetValue("Text1556"), pos = "right", event = "GuideNext" },
        { "talk", true, TextMap.GetValue("Text1553"), TextMap.GetValue("Text1557"), "full_sifengyuanyeyi_b", log = "8-2",server = 1 },
        { 
            "guide", 
            path = "GameManager/Camera/mainUI/center/Module_moduleTask/moduleTask/BlockRight/scrollView/Scroll View/Content/0/progress/btnGet", 
            say = TextMap.GetValue("Text1558"), 
            pos = "left", 
            event = "logic.taskHandler.submitTask",
            condition = function()
                local lab = GameObject.Find("GameManager/Camera/mainUI/center/Module_moduleTask/moduleTask/BlockRight/scrollView/Scroll View/Content/0/progress/btnGet/Label")
                if lab then 
                    lab = lab:GetComponent(UILabel)
                    if lab and lab.text == TextMap.GetValue("Text1559") then 
                        GuideMrg.CallNextStep()
                        return false 
                    end
                end
                return true
            end, log = "8-3",server = 1
        },
        { "save", log = "8-4",server = 1 },
        { "wait", RewardTaskSucc },
        { "sleep", 800 },
        { "guide", path = "GameManager/Camera/mainUI/center/Module_moduleTask/moduleTask/BlockRight/scrollView/Scroll View/Content/0/progress/btnGet", say = TextMap.GetValue("Text1560"), pos = "left", event = "GuideNext"},
        { "call", "step28", 3, log = "8-5" ,server = 1 }
    },
    step28 = {
        { "sleep", 200 },
        { "guide", path = "main_scene/scene/new_ZhuJieMian/GuanKa", say = TextMap.GetValue("Text1509"), pos = "bottom", event = "ClickBuild" },
        { "talk", true, TextMap.GetValue("Text1553"), TextMap.GetValue("Text1561"), "full_sifengyuanyeyi_b", log = "8-6",server = 1 },
        {   
            "guide", 
            path = "GameManager/Camera/mainUI/center/Module_chapterModule/chapterModule/clipPanel/movePanel/2/chapterPage/grid1/simpleImage", 
            say = TextMap.GetValue("Text1499"), 
            pos = "top", event = "ClickCpapter"
        },
        { "sleep", 200, log = "8-7",server = 1  },
        { "guide", path = "GameManager/Camera/mainUI/center/Module_chapterFight/chapterFight/content/challengeBtn", say = TextMap.GetValue("Text1510"), pos = "left", event = "logic.chapterHandler.fightChapter" },
        { "save", log = "8-8" ,server = 1 },
        { "end" }
    },

    skill = {
        { "sleep", 200 },
        { "talk", true, TextMap.GetValue("Text1502"), TextMap.GetValue("Text1562"), "full_heiqiyihu_b", log = "9-1" },
        { "talk", true, TextMap.GetValue("Text1553"), TextMap.GetValue("Text1563"), "full_sifengyuanyeyi_b", log = "9-2" },
        { "guide", path = "GameManager/Camera/mainUI/center/Module_main_menu/main_menu/top_menu/ButtonMenu_new/btn_list/btn_item_bottom/btn_buxia", say = TextMap.GetValue("Text1524"), pos = "top", event = "GuideNext", log = "9-3" },
        { "sleep", 200 },
        { "guide", path = "GameManager/Camera/mainUI/center/Module_hero_select_char/hero_select_char/scrollView/Scroll View/Content/0/Grid/selectCharIcon1/button", say = TextMap.GetValue("Text1525"), pos = "top", event = "GuideNext", log = "9-4" },
        { "sleep", 200 },
        --点击技能
        { "guide", path = "GameManager/Camera/mainUI/center/Module_newHero/newHero/bg/frame_bg/box/Scroll View/btn_skill", say = TextMap.GetValue("Text1564"), pos = "right", event = "GuideNext", log = "9-5" },
        -- { "save" },
        { "talk", true, TextMap.GetValue("Text1553"), TextMap.GetValue("Text1565"), "full_sifengyuanyeyi_b", log = "9-6" },
        { "talk", true, TextMap.GetValue("Text1553"), TextMap.GetValue("Text1566"), "full_sifengyuanyeyi_b", log = "9-7" },
        { "end" }
    },
    change_skill = {
        -- { "sleep", 200 },
        -- { "guide", path = "GameManager/Camera/mainUI/center/Module_main_menu/main_menu/top_menu/ButtonMenu_new/btn_list/btn_item_bottom/btn_buxia",say = TextMap.GetValue("Text1524"),pos = "top", event = "GuideNext" },
        -- { "sleep", 200 },
        -- { "guide", path = "GameManager/Camera/mainUI/center/Module_hero_select_char/hero_select_char/scrollView/Scroll View/Content/0/Grid/selectCharIcon1/button",say = TextMap.GetValue("Text1525"),pos = "top", event = "GuideNext" },
        -- { "sleep", 200 },
        --点击技能,变身技能
        { "talk", true, TextMap.GetValue("Text1553"), TextMap.GetValue("Text1567"), "full_sifengyuanyeyi_b", log = "11-1" },
        { "guide", path = "GameManager/Camera/mainUI/center/Module_newHero/newHero/bg/frame_bg/box/Scroll View/btn_skill", say = TextMap.GetValue("Text1564"), pos = "right", event = "GuideNext" },
        { "sleep", 200, log = "11-2" },
        { "guide", path = "GameManager/Camera/mainUI/center/Module_newHero/newHero/heroSkill/Container/btn_change", say = TextMap.GetValue("Text1568"), pos = "left", event = "GuideNext" },
        -- { "save" },
        { "talk", true, TextMap.GetValue("Text1553"), TextMap.GetValue("Text1569"), "full_sifengyuanyeyi_b", log = "11-3" },
        { "save", 3100, log = "11-4" },
        { "end" },
        condition = function()
            local val = Player.guide:getItem(3100)
            if val == 2 then return false end
            return true
        end
    },
    lin_luo = {
        { "sleep", 200 },
        { "guide", path = "GameManager/Camera/mainUI/center/Module_main_menu/main_menu/top_menu/ButtonMenu_new/btn_list/btn_item_bottom/btn_buxia", say = TextMap.GetValue("Text1524"), pos = "top", event = "GuideNext" },
        { "sleep", 200 },
        { "guide", path = "GameManager/Camera/mainUI/center/Module_hero_select_char/hero_select_char/scrollView/Scroll View/Content/0/Grid/selectCharIcon1/button", say = TextMap.GetValue("Text1525"), pos = "top", event = "GuideNext" },
        { "sleep", 200 },
        --点击灵络
        { "guide", path = "GameManager/Camera/mainUI/center/Module_newHero/newHero/bg/frame_bg/box/Scroll View/btn_lingluo", say = TextMap.GetValue("Text1570"), pos = "right", event = "GuideNext" },
        -- { "save" },
        { "end" }
    },
    xi_lian = {
        -- { "sleep", 200 },
        -- { "guide", path = "GameManager/Camera/mainUI/center/Module_main_menu/main_menu/top_menu/ButtonMenu_new/btn_list/btn_item_bottom/btn_buxia",say = TextMap.GetValue("Text1524"),pos = "top", event = "GuideNext" },
        -- { "sleep", 200 },
        -- { "guide", path = "GameManager/Camera/mainUI/center/Module_hero_select_char/hero_select_char/scrollView/Scroll View/Content/0/Grid/selectCharIcon1/button",say = TextMap.GetValue("Text1525"),pos = "top", event = "GuideNext" },
        { "sleep", 200 },
        {
            "callFunc", function()
            local go = GameObject.Find("GameManager/Camera/mainUI/center/Module_newHero/newHero/bg/frame_bg/box/Scroll View")
            if go then
                go = go:GetComponent(UIScrollView)
                go:SetDragAmount(0, 1, false)
                go:SetDragAmount(0, 1, true)
            end
        end
        },
        --点击洗练
        { "guide", path = "GameManager/Camera/mainUI/center/Module_newHero/newHero/bg/frame_bg/box/Scroll View/btn_wash", say = TextMap.GetValue("Text1571"), pos = "right", event = "GuideNext" },
        { "save", 2500 },
        { "talk", true, TextMap.GetValue("Text1553"), TextMap.GetValue("Text1572"), "full_sifengyuanyeyi_b" },
        { "talk", true, TextMap.GetValue("Text1553"), TextMap.GetValue("Text1573"), "full_sifengyuanyeyi_b" },

        { "end" },
        condition = function()
            local val = Player.guide:getItem(2500)
            if val == 2 then return false end
            return true
        end
    },
    du_jie = {
        --对决
        { "sleep", 200 },
        { "talk", true, TextMap.GetValue("Text1553"), TextMap.GetValue("Text1574"), "full_sifengyuanyeyi_b" },
        { "guide", path = "main_scene/scene/new_ZhuJieMian/Juedou", say = TextMap.GetValue("Text1575"), pos = "top", event = "ClickBuild" },
        { "talk", true, TextMap.GetValue("Text1553"), TextMap.GetValue("Text1576"), "full_sifengyuanyeyi_b" },
        { "guide", path = "GameManager/Camera/mainUI/center/Module_chapterElite/chapterElite/chapter/content/grid/chapterElite_hero/normal/simpleImage", say = TextMap.GetValue("Text1577"), pos = "right", event = "GuideNext" },
        { "end" }
    },
    guidao = {
        --鬼道
        { "sleep", 200 },
        { "guide", path = "GameManager/Camera/mainUI/center/Module_main_menu/main_menu/top_menu/ButtonMenu_new/btn_list/btn_item_bottom/btn_ghost", say = TextMap.GetValue("Text1578"), pos = "top", event = "GuideNext" },
        { "talk", false, TextMap.GetValue("Text1504"), TextMap.GetValue("Text1579"), "full_puyuanxizhu_b" },
        { "guide", path = "GameManager/Camera/mainUI/center/Module_ghost_list_new/ghost_list_new/hero_list_bg/btn_change", say = TextMap.GetValue("Text1580"), pos = "right", event = "GuideNext" },
        { "sleep", 200 },
        { "guide", path = "GameManager/Camera/mainUI/center/Module_ghost_list_new/ghost_list_new/tab/Container/hun_lian/right/btn_hunlian", say = TextMap.GetValue("Text1580"), pos = "top", event = "GuideNext" },
        { "sleep", 200 },
        { "guide", path = "GameManager/Camera/mainUI/top_menu/bg/Panel/btn_close", say = TextMap.GetValue("Text1511"), pos = "leftBottom", event = "GuideNext" },
        { "guide", path = "GameManager/Camera/mainUI/center/Module_main_menu/main_menu/top_menu/ButtonMenu_new/btn_list/btn_item_bottom/btn_team", say = TextMap.GetValue("Text1520"), pos = "top", event = "GuideNext" },
        { "sleep", 500 },
        { "guide", path = "GameManager/Camera/mainUI/center/Module_formation_main/formation_main/bg/Container/formation_guidao/equips/cell1", say = TextMap.GetValue("Text1581"), pos = "left", event = "GuideNext" },
        { "sleep", 200 },
        { "guide", path = "GameManager/Camera/mainUI/center/Module_formation_main/top_layer/guidao_select_charpiece/scrollView/Scroll View/Content/0/Grid/selectCharCell1/bg", say = "", pos = "right", event = "GuideNext" },
        { "sleep", 200 },
        { "guide", path = "GameManager/Camera/mainUI/center/Module_formation_main/formation_main/bg/Container/formation_guidao/equips/cell1", say = TextMap.GetValue("Text1581"), pos = "left", event = "GuideNext" },
        { "sleep", 200 },
        { "guide", path = "GameManager/Camera/mainUI/center/Module_guidaoInfo/guidaoInfo/BlockContent/right/strong/btStrong", say = TextMap.GetValue("Text1582"), pos = "top", event = "GuideNext" },
        { "end" }
    },
    ri_chang = {
        --日常
        { "sleep", 200 },
        { "talk", true, TextMap.GetValue("Text1512"), TextMap.GetValue("Text1583"), "full_luqiya_b", log = "10-1" },
        { "guide", path = "GameManager/Camera/mainUI/center/Module_main_menu/main_menu/buttons/btn_richang", say = TextMap.GetValue("Text1584"), pos = "left", event = "GuideNext", log = "10-2" },
        { "sleep", 200 },
        { "talk", true, TextMap.GetValue("Text1512"), TextMap.GetValue("Text1585"), "full_luqiya_b", log = "10-3" },
        { "talk", true, TextMap.GetValue("Text1512"), TextMap.GetValue("Text1586"), "full_luqiya_b", log = "10-4" },
        { "end" }
    },
    ling_huang_ta = {
        --灵王塔
        { "sleep", 200 },
        { "talk", true, TextMap.GetValue("Text1553"), TextMap.GetValue("Text1587"), "full_sifengyuanyeyi_b" },
        { "talk", true, TextMap.GetValue("Text1502"), TextMap.GetValue("Text1588"), "full_heiqiyihu_b" },
        { "guide", path = "main_scene/scene/new_ZhuJieMian/Linwangta", say = TextMap.GetValue("Text1589"), pos = "leftBottom", event = "ClickBuild" },
        { "sleep", 200 },
        { "talk", true, TextMap.GetValue("Text1553"), TextMap.GetValue("Text1590"), "full_sifengyuanyeyi_b" },
        { "talk", true, TextMap.GetValue("Text1553"), TextMap.GetValue("Text1591"), "full_sifengyuanyeyi_b" },
        { "end" },
    },
    jjc = {
        --竞技场
        { "sleep", 200 },
        { "guide", path = "main_scene/scene/new_ZhuJieMian/Jingji", say = TextMap.GetValue("Text1592"), pos = "top", event = "ClickBuild", log = "12-1" },
        { "sleep", 200 },
        { "talk", true, TextMap.GetValue("Text1593"), TextMap.GetValue("Text1594"), "full_gengmujianba_b" },
        { "talk", true, TextMap.GetValue("Text1553"), TextMap.GetValue("Text1595"), "full_sifengyuanyeyi_b" },
        { "talk", true, TextMap.GetValue("Text1553"), TextMap.GetValue("Text1596"), "full_sifengyuanyeyi_b" },
        { "end" },
    },
    xuan_shang = {
        --悬赏
        { "sleep", 200 },
        { "talk", true, TextMap.GetValue("Text1502"), TextMap.GetValue("Text1597"), "full_heiqiyihu_b", log = "13-1" },
        { "talk", true, TextMap.GetValue("Text1553"), TextMap.GetValue("Text1598"), "full_sifengyuanyeyi_b", log = "13-2" },
        { "guide", path = "main_scene/scene/new_ZhuJieMian/XuanShang", say = TextMap.GetValue("Text1599"), pos = "top", event = "ClickBuild", log = "13-3" },
        { "talk", true, TextMap.GetValue("Text1553"), TextMap.GetValue("Text1600"), "full_sifengyuanyeyi_b", log = "13-4" },
        { "talk", true, TextMap.GetValue("Text1553"), TextMap.GetValue("Text1601"), "full_sifengyuanyeyi_b", log = "13-5" },
        { "end" }
    },
    hei_dian = {
        --黑店
        { "sleep", 200 },
        { "talk", true, TextMap.GetValue("Text1502"), TextMap.GetValue("Text1602"), "full_heiqiyihu_b" },
        { "guide", path = "main_scene/scene/new_ZhuJieMian/PuyuanShop", say = TextMap.GetValue("Text1603"), pos = "top", event = "ClickBuild" },
        { "talk", true, TextMap.GetValue("Text1504"), TextMap.GetValue("Text1604"), "full_puyuanxizhu_b" },
        { "talk", true, TextMap.GetValue("Text1504"), TextMap.GetValue("Text1605"), "full_puyuanxizhu_b" },
        { "talk", true, TextMap.GetValue("Text1504"), TextMap.GetValue("Text1606"), "full_puyuanxizhu_b" },
        { "guide", path = "GameManager/Camera/mainUI/center/Module_shop_common/shop_common/bg_back/bt_lunhui", say = TextMap.GetValue("Text1607"), pos = "right", event = "GuideNext" },
        { "talk", true, TextMap.GetValue("Text1504"), TextMap.GetValue("Text1608"), "full_puyuanxizhu_b" },
        { "talk", true, TextMap.GetValue("Text1502"), TextMap.GetValue("Text1609"), "full_heiqiyihu_b" },
        { "talk", true, TextMap.GetValue("Text1504"), TextMap.GetValue("Text1610"), "full_puyuanxizhu_b" },
        { "guide", path = "GameManager/Camera/mainUI/center/Module_recycle/recycle/btn_chongsheng", say = TextMap.GetValue("Text1611"), pos = "left", event = "GuideNext" },
        { "talk", true, TextMap.GetValue("Text1504"), TextMap.GetValue("Text1612"), "full_puyuanxizhu_b" },
        { "talk", true, TextMap.GetValue("Text1504"), TextMap.GetValue("Text1613"), "full_puyuanxizhu_b" },
        { "end" },
    },
    diff_section = {
        --困难模式
        { "sleep", 200 },
        { "talk", true, TextMap.GetValue("Text1502"), TextMap.GetValue("Text1614"), "full_heiqiyihu_b" },
        { "talk", true, TextMap.GetValue("Text1553"), TextMap.GetValue("Text1615"), "full_sifengyuanyeyi_b" },
        { "guide", path = "main_scene/scene/new_ZhuJieMian/GuanKa", say = TextMap.GetValue("Text1509"), pos = "top", event = "ClickBuild" },
        { "guide", path = "GameManager/Camera/mainUI/center/Module_chapterModule/chapterModule/bg/hardBtn", say = TextMap.GetValue("Text1616"), pos = "left", event = "GuideNext" },
        { "talk", true, TextMap.GetValue("Text1553"), TextMap.GetValue("Text1617"), "full_sifengyuanyeyi_b" },
        { "end" }
    },
    jin_hua = {
        --进化
        { "talk", true, TextMap.GetValue("Text1553"), TextMap.GetValue("Text1618"), "full_sifengyuanyeyi_b",log = "a-1" },
        { "guide", path = "GameManager/Camera/mainUI/center/Module_newHero/newHero/bg/frame_bg/box/Scroll View/btn_evolve", say = TextMap.GetValue("Text1619"), pos = "right", event = "GuideNext",log = "a-2" },
        { "save", 3200 },
        { "talk", true, TextMap.GetValue("Text1553"), TextMap.GetValue("Text1620"), "full_sifengyuanyeyi_b",log = "a-3" },
        { "end" },
        condition = function()
            local val = Player.guide:getItem(3200)
            if val == 2 then return false end
            return true
        end
    },
    blood = {
        --血脉
        { "sleep", 200 },
        { "guide", path = "GameManager/Camera/mainUI/center/Module_main_menu/main_menu/top_menu/ButtonMenu_new/btn_list/btn_item_bottom/btn_buxia", say = TextMap.GetValue("Text1621"), pos = "top", event = "GuideNext" },
        { "sleep", 200 },
        { "guide", path = "GameManager/Camera/mainUI/center/Module_hero_select_char/hero_select_char/scrollView/Scroll View/Content/0/Grid/selectCharIcon1/button", say = TextMap.GetValue("Text1522"), pos = "right", event = "GuideNext" },
        { "sleep", 200 },
        {
            "callFunc", function()
            local go = GameObject.Find("GameManager/Camera/mainUI/center/Module_newHero/newHero/bg/frame_bg/box/Scroll View")
            if go then
                go = go:GetComponent(UIScrollView)
                go:SetDragAmount(0, 1, false)
                go:SetDragAmount(0, 1, true)
            end
        end
        },
        { "guide", path = "GameManager/Camera/mainUI/center/Module_newHero/newHero/bg/frame_bg/box/Scroll View/btn_xuemai", say = TextMap.GetValue("Text1622"), pos = "right", event = "GuideNext" }
    },]]
}

return script