-- { "talk"--, 1, "朽木露琪亚", "又有虚了，一护，走！", 1 },
-- talk, 显示方式1左 2右 3中， "朽木露琪亚"--显示名字， "又有虚了，一护，走！"---对话内容， 1 --模型ID
--{ "destroytalk"}, --结束删除动画
--before --开始前
--after -- 结束后
local action_lists = {
    before = {
		{ "talk", 2, TextMap.GetValue("Text_1_236"), TextMap.GetValue("Text_1_1588"), 30, ""},
		{ "talk", 1, "player", TextMap.GetValue("Text_1_1589"), 251, ""},
		{ "talk", 2, TextMap.GetValue("Text_1_233"), TextMap.GetValue("Text_1_1590"), 23, ""},
		{ "talk", 1, "player", TextMap.GetValue("Text_1_1591"), 251, ""},
		{ "talk", 2, TextMap.GetValue("Text_1_233"), TextMap.GetValue("Text_1_1592"), 23, ""},
		{ "talk", 1, "player", TextMap.GetValue("Text_1_1593"), 251, ""},

        { "destroytalk"},
    },

	pre = {
		{ "talk", 2, TextMap.GetValue("Text_1_236"), TextMap.GetValue("Text_1_285"), 30, ""},
		{ "talk", 2, TextMap.GetValue("Text_1_233"), TextMap.GetValue("Text_1_286"), 23, ""},
		{ "talk", 2, TextMap.GetValue("Text_1_236"), TextMap.GetValue("Text_1_287"), 30, ""},
        { "destroytalk"},
    },

    after = {
		{ "talk", 2, TextMap.GetValue("Text_1_236"), TextMap.GetValue("Text_1_1594"), 30, ""},
		{ "talk", 1, "player", TextMap.GetValue("Text_1_1595"), 251, ""},
		{ "talk", 2, TextMap.GetValue("Text_1_236"), TextMap.GetValue("Text_1_1596"), 30, ""},
		{ "talk", 2, TextMap.GetValue("Text_1_236"), TextMap.GetValue("Text_1_1597"), 30, ""},

        { "destroytalk"},
    },
}

return action_lists;