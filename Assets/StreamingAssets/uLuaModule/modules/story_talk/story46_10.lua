-- { "talk"--, 1, "朽木露琪亚", "又有虚了，一护，走！", 1 },
-- talk, 显示方式1左 2右 3中， "朽木露琪亚"--显示名字， "又有虚了，一护，走！"---对话内容， 1 --模型ID
--{ "destroytalk"}, --结束删除动画
--before --开始前
--after -- 结束后
local action_lists = {
    before = {
	{ "talk", 2, TextMap.GetValue("Text_1_1114"), TextMap.GetValue("Text_1_2024"), 16, ""},	
	{ "talk", 1, TextMap.GetValue("Text_1_1112"), TextMap.GetValue("Text_1_2025"), 139, ""},	
	{ "talk", 2, TextMap.GetValue("Text_1_1114"), TextMap.GetValue("Text_1_2026"), 16, ""},	
	{ "talk", 1, TextMap.GetValue("Text_1_1112"), TextMap.GetValue("Text_1_2027"), 139, ""},	
	{ "talk", 2, TextMap.GetValue("Text_1_1110"), TextMap.GetValue("Text_1_2028"), 153, ""},	

        { "destroytalk"},
    },

    after = {
	{ "talk", 1, TextMap.GetValue("Text_1_1110"), TextMap.GetValue("Text_1_2029"), 153, ""},	
	{ "talk", 2, TextMap.GetValue("Text_1_1158"), TextMap.GetValue("Text_1_2030"), 146, ""},	
	{ "talk", 1, TextMap.GetValue("Text_1_1110"), TextMap.GetValue("Text_1_2031"), 153, ""},	
	{ "talk", 2, TextMap.GetValue("Text_1_1158"), TextMap.GetValue("Text_1_2032"), 146, ""},	
	{ "talk", 1, TextMap.GetValue("Text_1_1110"), TextMap.GetValue("Text_1_2033"), 153, ""},	
	{ "talk", 2, "player", TextMap.GetValue("Text_1_2034"), -1, ""},	

        { "destroytalk"},
    },
}

return action_lists;