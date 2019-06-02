-- { "talk"--, 1, "朽木露琪亚", "又有虚了，一护，走！", 1 },
-- talk, 显示方式1左 2右 3中， "朽木露琪亚"--显示名字， "又有虚了，一护，走！"---对话内容， 1 --模型ID
--{ "destroytalk"}, --结束删除动画
--before --开始前
--after -- 结束后
local action_lists = {
    before = {
		{ "talk", 2, TextMap.GetValue("Text_1_32"), TextMap.GetValue("Text_1_2654"), 88, ""},	
		{ "talk", 1, TextMap.GetValue("Text_1_32"), TextMap.GetValue("Text_1_2655"), 88, ""},	
		{ "talk", 2, TextMap.GetValue("Text_1_32"), TextMap.GetValue("Text_1_2656"), 88, ""},	
		{ "talk", 1, TextMap.GetValue("Text_1_1223"), TextMap.GetValue("Text_1_2657"), 95, ""},	

        { "destroytalk"},
    },

    after = {
		{ "talk", 2, TextMap.GetValue("Text_1_1223"), TextMap.GetValue("Text_1_2658"), 95, ""},	
		{ "talk", 1, "player", TextMap.GetValue("Text_1_2659"), -1, ""},	
		{ "talk", 2, "player", TextMap.GetValue("Text_1_2660"), -1, ""},	
		{ "talk", 1, TextMap.GetValue("Text_1_1223"), TextMap.GetValue("Text_1_2661"), 95, ""},	
		{ "talk", 2, "player", TextMap.GetValue("Text_1_2662"), -1, ""},	
		{ "talk", 1, TextMap.GetValue("Text_1_1223"), TextMap.GetValue("Text_1_2663"), 95, ""},	
		{ "talk", 2, "player", TextMap.GetValue("Text_1_2664"), -1, ""},	
		{ "talk", 1, "player", TextMap.GetValue("Text_1_2665"), -1, ""},	
		{ "talk", 2, TextMap.GetValue("Text_1_1223"), "(¯﹃¯)……", 95, ""},	

        { "destroytalk"},
    },
}

return action_lists;