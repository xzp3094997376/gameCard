-- { "talk"--, 1, "朽木露琪亚", "又有虚了，一护，走！", 1 },
-- talk, 显示方式1左 2右 3中， "朽木露琪亚"--显示名字， "又有虚了，一护，走！"---对话内容， 1 --模型ID
--{ "destroytalk"}, --结束删除动画
--before --开始前
--after -- 结束后
local action_lists = {
    before = {
		{ "talk", 1, TextMap.GetValue("Text_1_1152"), TextMap.GetValue("Text_1_2745"), 125, ""},	
		{ "talk", 2, TextMap.GetValue("Text_1_1110"), TextMap.GetValue("Text_1_2746"), 153, ""},	
		{ "talk", 1, TextMap.GetValue("Text_1_1158"), TextMap.GetValue("Text_1_2747"), 146, ""},	
		{ "talk", 2, "player", TextMap.GetValue("Text_1_2748"), -1, ""},	

        { "destroytalk"},
    },

    after = {
		{ "talk", 1, TextMap.GetValue("Text_1_233"), TextMap.GetValue("Text_1_2749"), 23, ""},	
		{ "talk", 2, TextMap.GetValue("Text_1_236"), TextMap.GetValue("Text_1_2750"), 30, ""},	
		{ "talk", 1, "player", TextMap.GetValue("Text_1_2751"), -1, ""},	
		{ "talk", 2, TextMap.GetValue("Text_1_236"), TextMap.GetValue("Text_1_2752"), 30, ""},	
		{ "talk", 1, "player", TextMap.GetValue("Text_1_2753"), -1, ""},	

        { "destroytalk"},
    },
}

return action_lists;