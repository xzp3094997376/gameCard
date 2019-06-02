-- { "talk"--, 1, "朽木露琪亚", "又有虚了，一护，走！", 1 },
-- talk, 显示方式1左 2右 3中， "朽木露琪亚"--显示名字， "又有虚了，一护，走！"---对话内容， 1 --模型ID
--{ "destroytalk"}, --结束删除动画
--before --开始前
--after -- 结束后
local action_lists = {
    before = {
		{ "talk", 2, TextMap.GetValue("Text_1_1336"), TextMap.GetValue("Text_1_1337"), 119, ""},	
		{ "talk", 1, TextMap.GetValue("Text_1_1338"), TextMap.GetValue("Text_1_1339"), 44, ""},	
		{ "talk", 2, TextMap.GetValue("Text_1_1336"), TextMap.GetValue("Text_1_1340"), 119, ""},	
		{ "talk", 1, TextMap.GetValue("Text_1_1338"), TextMap.GetValue("Text_1_1341"), 44, ""},	
		{ "talk", 2, TextMap.GetValue("Text_1_1336"), TextMap.GetValue("Text_1_1342"), 119, ""},	
		{ "talk", 1, TextMap.GetValue("Text_1_1338"), TextMap.GetValue("Text_1_1343"), 44, ""},	


        { "destroytalk"},
    },

    
}

return action_lists;