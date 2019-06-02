-- { "talk"--, 1, "朽木露琪亚", "又有虚了，一护，走！", 1 },
-- talk, 显示方式1左 2右 3中， "朽木露琪亚"--显示名字， "又有虚了，一护，走！"---对话内容， 1 --模型ID
--{ "destroytalk"}, --结束删除动画
--before --开始前
--after -- 结束后
local action_lists = {
    before = {
		{ "talk", 1, "player", TextMap.GetValue("Text_1_2731"), -1, ""},	
		{ "talk", 2, TextMap.GetValue("Text_1_238"), TextMap.GetValue("Text_1_2732"), 195, ""},	
		{ "talk", 1, TextMap.GetValue("Text_1_229"), TextMap.GetValue("Text_1_2733"), 191, ""},	
		{ "talk", 2, "player", TextMap.GetValue("Text_1_2734"), -1, ""},	
		{ "talk", 1, TextMap.GetValue("Text_1_229"), TextMap.GetValue("Text_1_2735"), 191, ""},	

        { "destroytalk"},
    },

    after = {
		{ "talk", 2, TextMap.GetValue("Text_1_236"), TextMap.GetValue("Text_1_2736"), 30, ""},	
		{ "talk", 1, TextMap.GetValue("Text_1_1110"), TextMap.GetValue("Text_1_2737"), 153, ""},	
		{ "talk", 2, "player", TextMap.GetValue("Text_1_2738"), -1, ""},	
		{ "talk", 1, TextMap.GetValue("Text_1_1110"), TextMap.GetValue("Text_1_2739"), 153, ""},	
		{ "talk", 2, TextMap.GetValue("Text_1_227"), TextMap.GetValue("Text_1_2740"), 2, ""},	

        { "destroytalk"},
    },
}

return action_lists;