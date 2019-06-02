-- { "talk"--, 1, "朽木露琪亚", "又有虚了，一护，走！", 1 },
-- talk, 显示方式1左 2右 3中， "朽木露琪亚"--显示名字， "又有虚了，一护，走！"---对话内容， 1 --模型ID
--{ "destroytalk"}, --结束删除动画
--before --开始前
--after -- 结束后
local action_lists = {
    before = {
		{ "talk", 2, TextMap.GetValue("Text_1_294"), TextMap.GetValue("Text_1_2351"), 9, ""},
		{ "talk", 2, TextMap.GetValue("Text_1_1114"), TextMap.GetValue("Text_1_2352"), 16, ""},
		{ "talk", 1, "player", TextMap.GetValue("Text_1_2353"), -1, ""},
		{ "talk", 2, TextMap.GetValue("Text_1_2354"), TextMap.GetValue("Text_1_2355"),-1 , ""},


        { "destroytalk"},
    },

    after = {
		{ "talk", 1, "player", TextMap.GetValue("Text_1_2356"), -1, ""},
		{ "talk", 2, TextMap.GetValue("Text_1_227"), TextMap.GetValue("Text_1_2357"), 2, ""},
		{ "talk", 2, TextMap.GetValue("Text_1_294"), TextMap.GetValue("Text_1_2358"), 9, ""},
		{ "talk", 2, TextMap.GetValue("Text_1_1114"), TextMap.GetValue("Text_1_2359"), 16, ""},
		{ "talk", 2, TextMap.GetValue("Text_1_294"), TextMap.GetValue("Text_1_2360"), 9, ""},
		{ "talk", 2, TextMap.GetValue("Text_1_1114"), TextMap.GetValue("Text_1_2361"), 16, ""},
		{ "talk", 2, TextMap.GetValue("Text_1_294"), TextMap.GetValue("Text_1_2362"), 9, ""},
    

        { "destroytalk"},
    },
}

return action_lists;