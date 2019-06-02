-- { "talk"--, 1, "朽木露琪亚", "又有虚了，一护，走！", 1 },
-- talk, 显示方式1左 2右 3中， "朽木露琪亚"--显示名字， "又有虚了，一护，走！"---对话内容， 1 --模型ID
--{ "destroytalk"}, --结束删除动画
--before --开始前
--after -- 结束后
local action_lists = {
    before = {
		{ "talk", 2, TextMap.GetValue("Text_1_1201"), TextMap.GetValue("Text_1_2614"), 102, ""},	
		{ "talk", 1, TextMap.GetValue("Text_1_231"), TextMap.GetValue("Text_1_2615"), 109, ""},	
		{ "talk", 2, "player", TextMap.GetValue("Text_1_2616"), -1, ""},	
		{ "talk", 1, TextMap.GetValue("Text_1_1201"), TextMap.GetValue("Text_1_2617"), 102, ""},	
		{ "talk", 2, "player", TextMap.GetValue("Text_1_2618"), -1, ""},	

        { "destroytalk"},
    },

    after = {
		{ "talk", 1, TextMap.GetValue("Text_1_1201"), TextMap.GetValue("Text_1_2619"), 102, ""},	
		{ "talk", 2, TextMap.GetValue("Text_1_1201"), "_(:зゝ∠)_", 102, ""},	
		{ "talk", 1, "player", TextMap.GetValue("Text_1_2620"), -1, ""},	
		{ "talk", 2, TextMap.GetValue("Text_1_1114"), TextMap.GetValue("Text_1_2621"), 16, ""},	

        { "destroytalk"},
    },
}

return action_lists;