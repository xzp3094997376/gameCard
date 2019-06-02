-- { "talk"--, 1, "朽木露琪亚", "又有虚了，一护，走！", 1 },
-- talk, 显示方式1左 2右 3中， "朽木露琪亚"--显示名字， "又有虚了，一护，走！"---对话内容， 1 --模型ID
--{ "destroytalk"}, --结束删除动画
--before --开始前
--after -- 结束后
local action_lists = {
    before = {
		{ "talk", 2, TextMap.GetValue("Text_1_1180"), TextMap.GetValue("Text_1_1181"), 67, ""},	
		{ "talk", 1, "player", TextMap.GetValue("Text_1_1182"), -1, ""},	
		{ "talk", 2, TextMap.GetValue("Text_1_1183"), TextMap.GetValue("Text_1_1184"), 60, ""},	
		{ "talk", 1, "player", TextMap.GetValue("Text_1_1185"), -1, ""},	
		{ "talk", 2, TextMap.GetValue("Text_1_227"), TextMap.GetValue("Text_1_1186"), 2, ""},	

        { "destroytalk"},
    },

    after = {
		{ "talk", 1, TextMap.GetValue("Text_1_236"), TextMap.GetValue("Text_1_1187"), 30, ""},	
		{ "talk", 2, TextMap.GetValue("Text_1_1114"), TextMap.GetValue("Text_1_1188"), 16, ""},	
		{ "talk", 1, TextMap.GetValue("Text_1_236"), TextMap.GetValue("Text_1_1189"), 30, ""},	
		{ "talk", 2, TextMap.GetValue("Text_1_233"), TextMap.GetValue("Text_1_1190"), 23, ""},	
		{ "talk", 1, "player", "(¯﹃¯)……", -1, ""},	

        { "destroytalk"},
    },
}

return action_lists;