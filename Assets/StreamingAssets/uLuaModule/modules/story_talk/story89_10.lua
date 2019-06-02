-- { "talk"--, 1, "朽木露琪亚", "又有虚了，一护，走！", 1 },
-- talk, 显示方式1左 2右 3中， "朽木露琪亚"--显示名字， "又有虚了，一护，走！"---对话内容， 1 --模型ID
--{ "destroytalk"}, --结束删除动画
--before --开始前
--after -- 结束后
local action_lists = {
    before = {
		{ "talk", 1, TextMap.GetValue("Text_1_1223"), TextMap.GetValue("Text_1_2628"), 95, ""},	
		{ "talk", 2, TextMap.GetValue("Text_1_32"), TextMap.GetValue("Text_1_2629"), 88, ""},	
		{ "talk", 1, TextMap.GetValue("Text_1_1223"), TextMap.GetValue("Text_1_2630"), 95, ""},	
		{ "talk", 2, TextMap.GetValue("Text_1_32"), TextMap.GetValue("Text_1_2631"), 88, ""},	
		{ "talk", 1, TextMap.GetValue("Text_1_1223"), TextMap.GetValue("Text_1_2632"), 95, ""},	
		{ "talk", 2, TextMap.GetValue("Text_1_32"), TextMap.GetValue("Text_1_2633"), 88, ""},	

        { "destroytalk"},
    },

    after = {
		{ "talk", 1, "player", TextMap.GetValue("Text_1_2634"), -1, ""},	
		{ "talk", 2, TextMap.GetValue("Text_1_236"), TextMap.GetValue("Text_1_2635"), 30, ""},	
		{ "talk", 1, "player", TextMap.GetValue("Text_1_2636"), -1, ""},	
		{ "talk", 2, TextMap.GetValue("Text_1_236"), TextMap.GetValue("Text_1_2637"), 30, ""},	
		{ "talk", 1, "player", TextMap.GetValue("Text_1_2638"), -1, ""},	

        { "destroytalk"},
    },
}

return action_lists;