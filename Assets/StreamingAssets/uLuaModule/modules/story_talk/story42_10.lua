-- { "talk"--, 1, "朽木露琪亚", "又有虚了，一护，走！", 1 },
-- talk, 显示方式1左 2右 3中， "朽木露琪亚"--显示名字， "又有虚了，一护，走！"---对话内容， 1 --模型ID
--{ "destroytalk"}, --结束删除动画
--before --开始前
--after -- 结束后
local action_lists = {
    before = {
		{ "talk", 2, TextMap.GetValue("Text_1_294"), TextMap.GetValue("Text_1_1971"), 9, ""},	
		{ "talk", 1, TextMap.GetValue("Text_1_294"), TextMap.GetValue("Text_1_1972"), 9, ""},	
		{ "talk", 2, TextMap.GetValue("Text_1_233"), TextMap.GetValue("Text_1_1973"), 23, ""},	

        { "destroytalk"},
    },

    after = {
	{ "talk", 1, "player", TextMap.GetValue("Text_1_1974"), -1, ""},	
	{ "talk", 2, TextMap.GetValue("Text_1_1114"), TextMap.GetValue("Text_1_1975"), 16, ""},	
	{ "talk", 1, TextMap.GetValue("Text_1_233"), TextMap.GetValue("Text_1_1976"), 23, ""},	
	{ "talk", 2, TextMap.GetValue("Text_1_1114"), TextMap.GetValue("Text_1_1977"), 16, ""},	
	{ "talk", 1, "player", TextMap.GetValue("Text_1_1978"), -1, ""},	
	{ "talk", 2, TextMap.GetValue("Text_1_1114"), TextMap.GetValue("Text_1_1979"), 16, ""},	
	{ "talk", 1, TextMap.GetValue("Text_1_1114"), TextMap.GetValue("Text_1_1980"), 16, ""},	
	{ "talk", 2, TextMap.GetValue("Text_1_294"), "……", 9, ""},	
	{ "talk", 1, TextMap.GetValue("Text_1_1114"), TextMap.GetValue("Text_1_1981"), 16, ""},	

        { "destroytalk"},
    },
}

return action_lists;