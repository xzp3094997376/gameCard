-- { "talk"--, 1, "朽木露琪亚", "又有虚了，一护，走！", 1 },
-- talk, 显示方式1左 2右 3中， "朽木露琪亚"--显示名字， "又有虚了，一护，走！"---对话内容， 1 --模型ID
--{ "destroytalk"}, --结束删除动画
--before --开始前
--after -- 结束后
local action_lists = {
    before = {
		{ "talk", 1, "player", TextMap.GetValue("Text_1_2766"), -1, ""},	
		{ "talk", 2, TextMap.GetValue("Text_1_229"), TextMap.GetValue("Text_1_2767"), 191, ""},	
		{ "talk", 1, TextMap.GetValue("Text_1_236"), TextMap.GetValue("Text_1_2768"), 30, ""},	
		{ "talk", 2, TextMap.GetValue("Text_1_229"), TextMap.GetValue("Text_1_2769"), 191, ""},	

        { "destroytalk"},
    },

    after = {
		{ "talk", 1, TextMap.GetValue("Text_1_1114"), TextMap.GetValue("Text_1_2770"), 16, ""},	
		{ "talk", 2, TextMap.GetValue("Text_1_1275"), TextMap.GetValue("Text_1_2771"), 74, ""},	
		{ "talk", 1, TextMap.GetValue("Text_1_1112"), "(ﾟｰﾟ)……", 139, ""},	
		{ "talk", 2, TextMap.GetValue("Text_1_1223"), "(ﾟｰﾟ)……", 95, ""},	
		{ "talk", 1, TextMap.GetValue("Text_1_294"), "(ﾟｰﾟ)……", 9, ""},	
		{ "talk", 2, "player", TextMap.GetValue("Text_1_2772"), -1, ""},	

        { "destroytalk"},
    },
}

return action_lists;