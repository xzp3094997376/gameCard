-- { "talk"--, 1, "朽木露琪亚", "又有虚了，一护，走！", 1 },
-- talk, 显示方式1左 2右 3中， "朽木露琪亚"--显示名字， "又有虚了，一护，走！"---对话内容， 1 --模型ID
--{ "destroytalk"}, --结束删除动画
--before --开始前
--after -- 结束后
local action_lists = {
    before = {
		{ "talk", 2, TextMap.GetValue("Text_1_1219"), TextMap.GetValue("Text_1_2720"), 81, ""},	
		{ "talk", 1, TextMap.GetValue("Text_1_238"), TextMap.GetValue("Text_1_2721"), 195, ""},	
		{ "talk", 2, TextMap.GetValue("Text_1_229"), TextMap.GetValue("Text_1_2722"), 191, ""},	

        { "destroytalk"},
    },

    after = {
		{ "talk", 1, "player", TextMap.GetValue("Text_1_2723"), -1, ""},	
		{ "talk", 2, TextMap.GetValue("Text_1_229"), TextMap.GetValue("Text_1_2724"), 191, ""},	
		{ "talk", 1, TextMap.GetValue("Text_1_227"), TextMap.GetValue("Text_1_2725"), 2, ""},	
		{ "talk", 2, "player", TextMap.GetValue("Text_1_2726"), -1, ""},	

        { "destroytalk"},
    },
}

return action_lists;