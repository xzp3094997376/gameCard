-- { "talk"--, 1, "朽木露琪亚", "又有虚了，一护，走！", 1 },
-- talk, 显示方式1左 2右 3中， "朽木露琪亚"--显示名字， "又有虚了，一护，走！"---对话内容， 1 --模型ID
--{ "destroytalk"}, --结束删除动画
--before --开始前
--after -- 结束后
local action_lists = {
    before = {
		{ "talk", 1, TextMap.GetValue("Text_1_1152"), TextMap.GetValue("Text_1_2271"), 125, ""},	
		{ "talk", 2, TextMap.GetValue("Text_1_1110"), TextMap.GetValue("Text_1_2272"), 153, ""},	
		{ "talk", 1, TextMap.GetValue("Text_1_1158"), TextMap.GetValue("Text_1_2273"), 146, ""},	
		{ "talk", 2, TextMap.GetValue("Text_1_1110"), TextMap.GetValue("Text_1_2274"), 153, ""},	
		{ "talk", 1, TextMap.GetValue("Text_1_1158"), TextMap.GetValue("Text_1_2275"), 146, ""},	

        { "destroytalk"},
    },

    after = {
	{ "talk", 2, TextMap.GetValue("Text_1_1114"), TextMap.GetValue("Text_1_2276"), 16, ""},	
	{ "talk", 1, TextMap.GetValue("Text_1_1112"), TextMap.GetValue("Text_1_2277"), 139, ""},	

        { "destroytalk"},
    },
}

return action_lists;