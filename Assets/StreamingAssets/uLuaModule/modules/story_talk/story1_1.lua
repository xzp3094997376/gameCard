-- { "talk"--, 1, "朽木露琪亚", "又有虚了，一护，走！", 1 },
-- talk, 显示方式1左 2右 3中， "朽木露琪亚"--显示名字， "又有虚了，一护，走！"---对话内容， 1 --模型ID
--{ "destroytalk"}, --结束删除动画
--before --开始前
--after -- 结束后
local action_lists = {
    before = {
		{ "talk", 2, TextMap.GetValue("Text_1_248"), TextMap.GetValue("Text_1_1567"), 198, "black"},	
		{ "talk", 1, "player", TextMap.GetValue("Text_1_1568"), -1, ""},	
		{ "talk", 2, TextMap.GetValue("Text_1_248"), TextMap.GetValue("Text_1_1569"), 198, ""},	
		{ "talk", 1, "player", TextMap.GetValue("Text_1_1570"), -1, ""},	
		{ "talk", 2, TextMap.GetValue("Text_1_248"), TextMap.GetValue("Text_1_1571"), 198, ""},	
		{ "talk", 1, "player", TextMap.GetValue("Text_1_1572"), -1, ""},	
		{ "talk", 2, TextMap.GetValue("Text_1_248"), TextMap.GetValue("Text_1_1573"), 198, ""},	
		{ "talk", 1, "player", TextMap.GetValue("Text_1_1574"), -1, ""},	

        { "destroytalk"},
    },

    after = {
		{ "talk", 1, "player", TextMap.GetValue("Text_1_1575"), -1, ""},	
		{ "talk", 2, TextMap.GetValue("Text_1_236"), TextMap.GetValue("Text_1_1576"), 30, ""},	
		{ "talk", 1, "player", TextMap.GetValue("Text_1_1577"), -1, ""},	
		{ "talk", 2, TextMap.GetValue("Text_1_236"), TextMap.GetValue("Text_1_1578"), 30, ""},	

        { "destroytalk"},
    },
}

return action_lists;