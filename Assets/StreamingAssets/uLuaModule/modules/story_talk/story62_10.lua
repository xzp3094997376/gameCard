-- { "talk"--, 1, "朽木露琪亚", "又有虚了，一护，走！", 1 },
-- talk, 显示方式1左 2右 3中， "朽木露琪亚"--显示名字， "又有虚了，一护，走！"---对话内容， 1 --模型ID
--{ "destroytalk"}, --结束删除动画
--before --开始前
--after -- 结束后
local action_lists = {
    before = {
	{ "talk", 1, TextMap.GetValue("Text_1_1114"), TextMap.GetValue("Text_1_2260"), 16, ""},	
	{ "talk", 2, TextMap.GetValue("Text_1_1112"), TextMap.GetValue("Text_1_2261"), 139, ""},	
	{ "talk", 1, TextMap.GetValue("Text_1_294"), TextMap.GetValue("Text_1_2262"), 9, ""},	
	{ "talk", 2, "player", TextMap.GetValue("Text_1_2263"), -1, ""},	

        { "destroytalk"},
    },

    after = {
	{ "talk", 1, TextMap.GetValue("Text_1_294"), TextMap.GetValue("Text_1_2264"), 9, ""},	
	{ "talk", 2, TextMap.GetValue("Text_1_1152"), TextMap.GetValue("Text_1_2265"), 125, ""},	
	{ "talk", 1, TextMap.GetValue("Text_1_294"), TextMap.GetValue("Text_1_2266"), 9, ""},	
	{ "talk", 2, "player", TextMap.GetValue("Text_1_2267"), -1, ""},	

        { "destroytalk"},
    },
}

return action_lists;