-- { "talk"--, 1, "朽木露琪亚", "又有虚了，一护，走！", 1 },
-- talk, 显示方式1左 2右 3中， "朽木露琪亚"--显示名字， "又有虚了，一护，走！"---对话内容， 1 --模型ID
--{ "destroytalk"}, --结束删除动画
--before --开始前
--after -- 结束后
local action_lists = {
    before = {
		{ "talk", 2, TextMap.GetValue("Text_1_1598"), TextMap.GetValue("Text_1_1599"), 277, ""},	
		{ "talk", 2, TextMap.GetValue("Text_1_236"), TextMap.GetValue("Text_1_1600"), 30, ""},	
		{ "talk", 1, "player", TextMap.GetValue("Text_1_1601"), -1, ""},	
		{ "talk", 2, TextMap.GetValue("Text_1_233"), TextMap.GetValue("Text_1_1602"), 23, ""},	
		{ "talk", 1, "player", "(。_。)……", -1, ""},	

        { "destroytalk"},
    },

    after = {
		{ "talk", 2, TextMap.GetValue("Text_1_236"), TextMap.GetValue("Text_1_1603"), 30, ""},	
		{ "talk", 1, "player", TextMap.GetValue("Text_1_1604"), -1, ""},	
		{ "talk", 2, TextMap.GetValue("Text_1_233"), TextMap.GetValue("Text_1_1605"), 23, ""},	
		{ "talk", 1, "player", TextMap.GetValue("Text_1_1606"), -1, ""},	
		{ "talk", 2, TextMap.GetValue("Text_1_233"), TextMap.GetValue("Text_1_1607"), 23, ""},	


        { "destroytalk"},
    },
}

return action_lists;