-- { "talk"--, 1, "朽木露琪亚", "又有虚了，一护，走！", 1 },
-- talk, 显示方式1左 2右 3中， "朽木露琪亚"--显示名字， "又有虚了，一护，走！"---对话内容， 1 --模型ID
--{ "destroytalk"}, --结束删除动画
--before --开始前
--after -- 结束后
local action_lists = {
    before = {
		{ "talk", 2, TextMap.GetValue("Text_1_1152"), TextMap.GetValue("Text_1_2592"), 125, ""},	
		{ "talk", 1, TextMap.GetValue("Text_1_1219"), TextMap.GetValue("Text_1_2593"), 81, ""},	
		{ "talk", 2, TextMap.GetValue("Text_1_1152"), TextMap.GetValue("Text_1_2594"), 125, ""},	
		{ "talk", 1, TextMap.GetValue("Text_1_1219"), TextMap.GetValue("Text_1_2595"), 81, ""},	

        { "destroytalk"},
    },

    after = {
		{ "talk", 2, "player", TextMap.GetValue("Text_1_2596"), -1, ""},	
		{ "talk", 1, TextMap.GetValue("Text_1_1219"), TextMap.GetValue("Text_1_2597"), 81, ""},	
		{ "talk", 2, TextMap.GetValue("Text_1_1223"), TextMap.GetValue("Text_1_2598"), 95, ""},	
		{ "talk", 1, "player", TextMap.GetValue("Text_1_2599"), -1, ""},	

        { "destroytalk"},
    },
}

return action_lists;