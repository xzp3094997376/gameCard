-- { "talk"--, 1, "朽木露琪亚", "又有虚了，一护，走！", 1 },
-- talk, 显示方式1左 2右 3中， "朽木露琪亚"--显示名字， "又有虚了，一护，走！"---对话内容， 1 --模型ID
--{ "destroytalk"}, --结束删除动画
--before --开始前
--after -- 结束后
local action_lists = {
    before = {
		{ "talk", 2, TextMap.GetValue("Text_1_1110"), TextMap.GetValue("Text_1_1839"), 153, ""},
		{ "talk", 1, "player", TextMap.GetValue("Text_1_1840"),-1 , ""},
		{ "talk", 2, TextMap.GetValue("Text_1_233"), TextMap.GetValue("Text_1_1841"), 23, ""},
		{ "talk", 1, "player", TextMap.GetValue("Text_1_1842"),-1 , ""},
		{ "talk", 1, "player", TextMap.GetValue("Text_1_1843"),-1 , ""},
		{ "talk", 2, TextMap.GetValue("Text_1_1110"), TextMap.GetValue("Text_1_1844"), 153, ""},

        { "destroytalk"},
    },

    after = {
		{ "talk", 1, "player", TextMap.GetValue("Text_1_1845"),-1 , ""},
		{ "talk", 2, TextMap.GetValue("Text_1_1110"), TextMap.GetValue("Text_1_1846"), 153, ""},
		{ "talk", 1, "player", TextMap.GetValue("Text_1_1847"),-1 , ""},
		{ "talk", 2, TextMap.GetValue("Text_1_1110"), "……", 153, ""},
		{ "talk", 2, TextMap.GetValue("Text_1_1110"), TextMap.GetValue("Text_1_1848"), 153, ""},
		

        { "destroytalk"},
    },
}

return action_lists;