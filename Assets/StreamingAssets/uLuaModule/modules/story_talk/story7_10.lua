-- { "talk"--, 1, "朽木露琪亚", "又有虚了，一护，走！", 1 },
-- talk, 显示方式1左 2右 3中， "朽木露琪亚"--显示名字， "又有虚了，一护，走！"---对话内容， 1 --模型ID
--{ "destroytalk"}, --结束删除动画
--before --开始前
--after -- 结束后
local action_lists = {
    before = {
		{ "talk", 1, "player", TextMap.GetValue("Text_1_2489"),-1 , ""},
		{ "talk", 2, TextMap.GetValue("Text_1_233"), TextMap.GetValue("Text_1_2490"), 23, ""},
		{ "talk", 1, "player", TextMap.GetValue("Text_1_2491"),-1 , ""},



        { "destroytalk"},
    },

    after = {
		{ "talk", 2, TextMap.GetValue("Text_1_2492"), TextMap.GetValue("Text_1_2493"),-1 , ""},
		{ "talk", 1, "player", TextMap.GetValue("Text_1_2494"),-1 , ""},
		{ "talk", 2, TextMap.GetValue("Text_1_2492"), TextMap.GetValue("Text_1_2495"),-1 , ""},
		{ "talk", 2, TextMap.GetValue("Text_1_2492"), TextMap.GetValue("Text_1_2496"),-1 , ""},
		



        { "destroytalk"},
    },
}

return action_lists;