-- { "talk"--, 1, "朽木露琪亚", "又有虚了，一护，走！", 1 },
-- talk, 显示方式1左 2右 3中， "朽木露琪亚"--显示名字， "又有虚了，一护，走！"---对话内容， 1 --模型ID
--{ "destroytalk"}, --结束删除动画
--before --开始前
--after -- 结束后
local action_lists = {
    before = {
		{ "talk", 2, TextMap.GetValue("Text_1_1152"), TextMap.GetValue("Text_1_1453"), 125, ""},
		{ "talk", 2, TextMap.GetValue("Text_1_1152"), TextMap.GetValue("Text_1_1454"), 125, ""},
		{ "talk", 1, TextMap.GetValue("Text_1_227"), TextMap.GetValue("Text_1_1455"), 2, ""},
		{ "talk", 2, TextMap.GetValue("Text_1_1152"), TextMap.GetValue("Text_1_1456"), 125, ""},
		{ "talk", 1, TextMap.GetValue("Text_1_227"), TextMap.GetValue("Text_1_1457"), 2, ""},


        { "destroytalk"},
    },

    after = {
		{ "talk", 2, TextMap.GetValue("Text_1_1152"), TextMap.GetValue("Text_1_1458"), 125, ""},
		{ "talk", 1, TextMap.GetValue("Text_1_227"), TextMap.GetValue("Text_1_1459"), 2, ""},
		{ "talk", 2, TextMap.GetValue("Text_1_1152"), TextMap.GetValue("Text_1_1460"), 125, ""},
		{ "talk", 1, TextMap.GetValue("Text_1_227"), TextMap.GetValue("Text_1_1461"), 2, ""},
		{ "talk", 2, TextMap.GetValue("Text_1_1152"), "(⊙ˍ⊙)……", 125, ""},
		{ "talk", 2, TextMap.GetValue("Text_1_1152"), TextMap.GetValue("Text_1_1462"), 125, ""},
		{ "talk", 2, TextMap.GetValue("Text_1_1152"), TextMap.GetValue("Text_1_1463"), 125, ""},


        { "destroytalk"},
    },
}

return action_lists;