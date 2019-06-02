-- { "talk"--, 1, "朽木露琪亚", "又有虚了，一护，走！", 1 },
-- talk, 显示方式1左 2右 3中， "朽木露琪亚"--显示名字， "又有虚了，一护，走！"---对话内容， 1 --模型ID
--{ "destroytalk"}, --结束删除动画
--before --开始前
--after -- 结束后
local action_lists = {
    before = {
		{ "talk", 1, TextMap.GetValue("Text_1_1379"), TextMap.GetValue("Text_1_1385"), 120, ""},	
		{ "talk", 2, TextMap.GetValue("Text_1_1386"), TextMap.GetValue("Text_1_1387"), 122, ""},	
		{ "talk", 1, TextMap.GetValue("Text_1_1379"), TextMap.GetValue("Text_1_1388"), 120, ""},	
		{ "talk", 2, TextMap.GetValue("Text_1_1386"), TextMap.GetValue("Text_1_1389"), 122, ""},	
		{ "talk", 1, TextMap.GetValue("Text_1_1379"), TextMap.GetValue("Text_1_1390"), 120, ""},	
		{ "talk", 2, TextMap.GetValue("Text_1_1386"), TextMap.GetValue("Text_1_1391"), 122, ""},	


        { "destroytalk"},
    },

    
}

return action_lists;