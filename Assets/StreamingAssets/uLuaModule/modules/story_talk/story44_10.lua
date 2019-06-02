-- { "talk"--, 1, "朽木露琪亚", "又有虚了，一护，走！", 1 },
-- talk, 显示方式1左 2右 3中， "朽木露琪亚"--显示名字， "又有虚了，一护，走！"---对话内容， 1 --模型ID
--{ "destroytalk"}, --结束删除动画
--before --开始前
--after -- 结束后
local action_lists = {
    before = {
	{ "talk", 1, TextMap.GetValue("Text_1_294"), TextMap.GetValue("Text_1_1999"), 9, ""},	
	{ "talk", 2, TextMap.GetValue("Text_1_1102"), TextMap.GetValue("Text_1_2000"), 132, ""},	
	{ "talk", 1, TextMap.GetValue("Text_1_294"), TextMap.GetValue("Text_1_2001"), 9, ""},	
	{ "talk", 2, TextMap.GetValue("Text_1_1102"), TextMap.GetValue("Text_1_2002"), 132, ""},	
	{ "talk", 1, TextMap.GetValue("Text_1_294"), "——？！！！_(:зゝ∠)_", 9, ""},	

        { "destroytalk"},
    },

    after = {
	{ "talk", 2, TextMap.GetValue("Text_1_294"), TextMap.GetValue("Text_1_2003"), 9, ""},	
	{ "talk", 1, TextMap.GetValue("Text_1_1102"), TextMap.GetValue("Text_1_2004"), 132, ""},	
	{ "talk", 2, "player", TextMap.GetValue("Text_1_2005"), -1, ""},	

        { "destroytalk"},
    },
}

return action_lists;