-- { "talk"--, 1, "朽木露琪亚", "又有虚了，一护，走！", 1 },
-- talk, 显示方式1左 2右 3中， "朽木露琪亚"--显示名字， "又有虚了，一护，走！"---对话内容， 1 --模型ID
--{ "destroytalk"}, --结束删除动画
--before --开始前
--after -- 结束后
local action_lists = {
    before = {
		{ "talk", 1, "player", TextMap.GetValue("Text_1_1559"),-1 , ""},
		{ "talk", 2, TextMap.GetValue("Text_1_233"), TextMap.GetValue("Text_1_1560"), 23, ""},
		{ "talk", 1, "player", TextMap.GetValue("Text_1_1556"),-1 , ""},
		{ "talk", 2, TextMap.GetValue("Text_1_233"), TextMap.GetValue("Text_1_1561"), 23, ""},
		{ "talk", 1, "player", TextMap.GetValue("Text_1_1558"),-1 , ""},
		{ "talk", 2, TextMap.GetValue("Text_1_233"), "——！！！", 23, ""},

        { "destroytalk"},
    },

    after = {
		{ "talk", 2, TextMap.GetValue("Text_1_233"), TextMap.GetValue("Text_1_1562"), 23, ""},
		{ "talk", 2, TextMap.GetValue("Text_1_233"), TextMap.GetValue("Text_1_1563"), 23, ""},
		{ "talk", 1, "player", TextMap.GetValue("Text_1_1564"),-1 , ""},
		{ "talk", 2, TextMap.GetValue("Text_1_233"), TextMap.GetValue("Text_1_1565"), 23, ""},
		{ "talk", 1, "player", TextMap.GetValue("Text_1_1566"),-1 , ""},
		


        { "destroytalk"},
    },
}

return action_lists;