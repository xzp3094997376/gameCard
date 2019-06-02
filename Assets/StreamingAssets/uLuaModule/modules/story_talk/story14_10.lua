-- { "talk"--, 1, "朽木露琪亚", "又有虚了，一护，走！", 1 },
-- talk, 显示方式1左 2右 3中， "朽木露琪亚"--显示名字， "又有虚了，一护，走！"---对话内容， 1 --模型ID
--{ "destroytalk"}, --结束删除动画
--before --开始前
--after -- 结束后
local action_lists = {
    before = {
		{ "talk", 2, TextMap.GetValue("Text_1_233"), TextMap.GetValue("Text_1_1493"), 23, ""},
		{ "talk", 1, "player", TextMap.GetValue("Text_1_1494"),-1 , ""},
		{ "talk", 2, TextMap.GetValue("Text_1_233"), TextMap.GetValue("Text_1_1495"), 23, ""},
		{ "talk", 2, TextMap.GetValue("Text_1_233"), TextMap.GetValue("Text_1_1496"), 23, ""},

        { "destroytalk"},
    },

    after = {
		{ "talk", 2, TextMap.GetValue("Text_1_236"), TextMap.GetValue("Text_1_1497"), 30, ""},
		{ "talk", 1, TextMap.GetValue("Text_1_233"), TextMap.GetValue("Text_1_1498"), 23, ""},
		{ "talk", 2, TextMap.GetValue("Text_1_236"), TextMap.GetValue("Text_1_1499"), 30, ""},
		{ "talk", 1, TextMap.GetValue("Text_1_233"), TextMap.GetValue("Text_1_1500"), 23, ""},
		{ "talk", 2, TextMap.GetValue("Text_1_236"), TextMap.GetValue("Text_1_1501"), 30, ""},
		

        { "destroytalk"},
    },
}

return action_lists;