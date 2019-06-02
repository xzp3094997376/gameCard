-- { "talk"--, 1, "朽木露琪亚", "又有虚了，一护，走！", 1 },
-- talk, 显示方式1左 2右 3中， "朽木露琪亚"--显示名字， "又有虚了，一护，走！"---对话内容， 1 --模型ID
--{ "destroytalk"}, --结束删除动画
--before --开始前
--after -- 结束后
local action_lists = {
    before = {
		{ "talk", 2, TextMap.GetValue("Text_1_1180"), TextMap.GetValue("Text_1_2401"), 67, ""},	
		{ "talk", 1, TextMap.GetValue("Text_1_1261"), TextMap.GetValue("Text_1_2402"), 53, ""},	
		{ "talk", 2, TextMap.GetValue("Text_1_1183"), TextMap.GetValue("Text_1_2403"), 60, ""},	

        { "destroytalk"},
    },

    after = {
		{ "talk", 1, TextMap.GetValue("Text_1_1110"), TextMap.GetValue("Text_1_2404"), 153, ""},	
		{ "talk", 2, TextMap.GetValue("Text_1_1158"), TextMap.GetValue("Text_1_2405"), 146, ""},	
		{ "talk", 1, TextMap.GetValue("Text_1_1175"), TextMap.GetValue("Text_1_2406"), 46, ""},	

        { "destroytalk"},
    },
}

return action_lists;