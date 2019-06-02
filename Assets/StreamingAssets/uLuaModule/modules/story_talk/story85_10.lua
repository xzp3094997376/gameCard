-- { "talk"--, 1, "朽木露琪亚", "又有虚了，一护，走！", 1 },
-- talk, 显示方式1左 2右 3中， "朽木露琪亚"--显示名字， "又有虚了，一护，走！"---对话内容， 1 --模型ID
--{ "destroytalk"}, --结束删除动画
--before --开始前
--after -- 结束后
local action_lists = {
    before = {
		{ "talk", 2, TextMap.GetValue("Text_1_1114"), TextMap.GetValue("Text_1_2580"), 16, ""},	
		{ "talk", 1, TextMap.GetValue("Text_1_1112"), TextMap.GetValue("Text_1_2581"), 139, ""},	
		{ "talk", 2, TextMap.GetValue("Text_1_1114"), TextMap.GetValue("Text_1_2582"), 16, ""},	
		{ "talk", 1, "player", TextMap.GetValue("Text_1_2583"), -1, ""},	
		{ "talk", 2, TextMap.GetValue("Text_1_1112"), TextMap.GetValue("Text_1_2584"), 139, ""},	

        { "destroytalk"},
    },

    after = {
		{ "talk", 1, "player", TextMap.GetValue("Text_1_2585"), -1, ""},	
		{ "talk", 2, TextMap.GetValue("Text_1_294"), TextMap.GetValue("Text_1_2586"), 9, ""},	
		{ "talk", 1, TextMap.GetValue("Text_1_233"), TextMap.GetValue("Text_1_2587"), 23, ""},	
		{ "talk", 2, TextMap.GetValue("Text_1_236"), TextMap.GetValue("Text_1_2588"), 30, ""},	

        { "destroytalk"},
    },
}

return action_lists;